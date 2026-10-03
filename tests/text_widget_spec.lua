--====================================================================--
-- Test: Text Widget
--====================================================================--

module(..., package.seeall)


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.1.0"



--====================================================================--
--== Imports


local dUI = require 'lib.dmc_ui'



--====================================================================--
--== Support Functions


local widgets

local function track( w )
	widgets[ #widgets+1 ] = w
	return w
end

-- run the widget's pending commit now, instead of on the next frame
local function commit( w )
	w:__validate__()
	return w
end

-- the style specs load the base styles with their test defaults (width 117,
-- no height, ...): give each widget the real defaults, plus its own values
local DEFAULTS = {
	width=0, height=0, anchorX=0.5, anchorY=0.5,
	align='center', font=native.systemFont, fontSize=16, fontSizeMinimum=0,
	marginX=0, marginY=0,
	fillColor={ 0, 0, 0, 0 }, textColor={ 0, 0, 0, 1 },
	strokeColor={ 0, 0, 0, 0 }, strokeWidth=0,
}

local function newText( params )
	params = params or {}
	local style = {}
	for k, v in pairs( DEFAULTS ) do style[k] = v end
	for k, v in pairs( params.style or {} ) do style[k] = v end
	params.style = style
	return commit( track( dUI.newText( params ) ) )
end

local function textWidth( text, fontSize )
	local o = display.newText{ text=text, font=native.systemFont, fontSize=fontSize }
	local w = o.width
	o:removeSelf()
	return w
end



--====================================================================--
--== Module Testing
--====================================================================--


function setup()
	widgets = {}
end

function teardown()
	for _, w in ipairs( widgets ) do w:removeSelf() end
	widgets = nil
end



--====================================================================--
--== Test Text


--[[
the text shown follows .text
--]]
function test_textChange()
	local w = newText{ text="Wonderful" }
	assert_equal( "Wonderful", w._txtText.text )

	w.text = "World"
	commit( w )
	assert_equal( "World", w.text )
	assert_equal( "World", w._txtText.text, "shown text follows .text" )
end


--[[
without a width the widget fits its text
--]]
function test_autoWidth()
	local w = newText{ text="Wonderful", style={ fontSize=20, marginX=10 } }
	local tw = textWidth( "Wonderful", 20 )
	assert_equal( tw+20, w.width, "text width plus margins" )

	w.text = "Wonderful World"
	commit( w )
	assert_equal( textWidth( "Wonderful World", 20 )+20, w.width, "grows with the text" )
	assert_equal( w.width, w._rectBg.width, "background follows" )
end


--[[
with a width too small, the text ends in '...'
--]]
function test_ellipsis()
	local w = newText{ text="this is long text too long to fit", style={ width=80, marginX=5 } }
	local shown = w._txtText.text
	assert_equal( "...", shown:sub(-3), "ends in an ellipsis" )
	-- measured alone: a text box with a width rounds its own width up
	assert_true( textWidth( shown, w._txtText.size ) <= 70, "fits inside the margins" )
	assert_equal( 80, w.width )

	w.width = 200
	commit( w )
	assert_true( #w._txtText.text > #shown, "more text with more room" )

	w.width = 400
	commit( w )
	assert_equal( "this is long text too long to fit", w._txtText.text, "whole text when it fits" )
end


--[[
fontSizeMinimum shrinks the text before truncating it
--]]
function test_fontSizeMinimum()
	local text = "Kangaroo"
	local tw = textWidth( text, 20 )
	local w = newText{ text=text, style={ width=tw*0.8, marginX=0, fontSize=20, fontSizeMinimum=10 } }
	assert_equal( text, w._txtText.text, "shrunk, not truncated" )
	assert_true( w._txtText.size < 20, "smaller font" )

	w.style.fontSizeMinimum = 19
	commit( w )
	assert_equal( "...", w._txtText.text:sub(-3), "a change to fontSizeMinimum redraws" )
end


--[[
left and right align keep marginX from the edge
--]]
function test_align()
	local w = newText{ text="Hi", style={ width=200, marginX=10, align='left' } }
	local t = w._txtText
	-- anchorX 0.5 by default: the left edge is at -100
	assert_equal( -90, t.x - t.width*t.anchorX, "left: marginX from the left edge" )

	w.align = 'right'
	commit( w )
	t = w._txtText
	assert_equal( 90, t.x + t.width*(1-t.anchorX), "right: marginX from the right edge" )

	w.align = 'center'
	commit( w )
	t = w._txtText
	assert_equal( 0, t.x - t.width*(t.anchorX-0.5), "center" )
end


--[[
a change in size dispatches the widget's event, type DIMENSION_CHANGED
--]]
function test_dimensionEvent()
	local w = newText{ text="One" }
	local got
	w:addEventListener( w.EVENT, function( e ) got = e end )
	w.text = "One Two Three"
	commit( w )
	assert_not_nil( got, "event dispatched" )
	assert_equal( w.EVENT, got.name )
	assert_equal( w.DIMENSION_CHANGED, got.type )
	assert_equal( w.width, got.width )
end


--[[
debugOn tints the background, and off restores its fill
--]]
function test_debugOn()
	local w = newText{ text="Hi", style={ fillColor={ 0, 0, 1 } } }
	local fill = function() local f=w._rectBg.fill ; return f.r, f.b end
	w.style.debugOn = true
	commit( w )
	assert_equal( 1, ( fill() ), "red tint" )
	w.style.debugOn = false
	commit( w )
	local r, b = fill()
	assert_equal( 0, r, "fill restored" )
	assert_equal( 1, b, "fill restored" )
end


--[[
a size that comes from the text is right straight after a change, not only
after the next frame
--]]
function test_sizeBeforeFrame()
	local w = track( dUI.newText{ text="Wonderful", style={ width=0, height=0, marginX=10, marginY=5, fontSize=20 } } )
	assert_equal( textWidth( "Wonderful", 20 )+20, w.width, "width at creation" )
	assert_true( w.height > 10, "height at creation" )
	w.text = "Wonderful World"
	assert_equal( textWidth( "Wonderful World", 20 )+20, w.width, "width after a change" )
end


--[[
the ellipsis cuts at the end of a whole UTF-8 character
--]]
function test_ellipsisUTF8()
	local text = string.rep( "é", 30 ) -- two bytes each
	local w = newText{ text=text, style={ width=80 } }
	local shown = w._txtText.text
	assert_equal( "...", shown:sub(-3) )
	assert_equal( 0, ( #shown-3 )%2, "whole characters" )
	assert_true( #shown > 3, "some text shown" )
end
