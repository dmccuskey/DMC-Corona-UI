--====================================================================--
-- Test: Background Widget
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
--== Test Widget Type


--[[
newBackground() keeps the type of an inline style
--]]
function test_inlineTypeKept()
	local w

	w = track( dUI.newBackground{ style={ type=dUI.RECTANGLE } } )
	assert_equal( dUI.RECTANGLE, w.style.type, "inline type kept" )
	assert_equal( dUI.RECTANGLE, w.viewStyle.type, "view follows the type" )

	w = track( dUI.newBackground{ style={ type=dUI.NINE_SLICE } } )
	assert_equal( dUI.NINE_SLICE, w.style.type, "inline type kept" )

	w = track( dUI.newBackground() )
	assert_equal( dUI.ROUNDED, w.style.type, "default type" )
end


--[[
the typed constructors set their type
--]]
function test_typedConstructors()
	local w

	w = track( dUI.newRectangleBackground() )
	assert_equal( dUI.RECTANGLE, w.style.type )
	w = track( dUI.newRoundedBackground() )
	assert_equal( dUI.ROUNDED, w.style.type )
	w = track( dUI.new9SliceBackground() )
	assert_equal( dUI.NINE_SLICE, w.style.type )
	w = track( dUI.newImageBackground() )
	assert_equal( dUI.IMAGE, w.style.type )
end


--[[
a shared style keeps its type, and the widget isn't given a different one
--]]
function test_sharedStyleUnchanged()
	local s, w

	s = dUI.newRoundedBackgroundStyle()
	w = track( dUI.newRectangleBackground{ style=s } )
	assert_equal( dUI.ROUNDED, s.type, "shared style unchanged" )
	assert_equal( dUI.ROUNDED, w.style.type, "widget has the style's type" )
end


--[[
a style name works in the constructor
--]]
function test_namedStyle()
	local s, w

	s = dUI.newRectangleBackgroundStyle{ name='background-widget-spec-named' }
	w = track( dUI.newBackground{ style='background-widget-spec-named' } )
	assert_equal( dUI.RECTANGLE, w.style.type, "named style used" )
	s.name = nil
end


--[[
.type reads and sets the style's type
--]]
function test_typeProperty()
	local w

	w = track( dUI.newBackground() )
	assert_equal( dUI.ROUNDED, w.type )
	w.type = dUI.RECTANGLE
	assert_equal( dUI.RECTANGLE, w.type )
	assert_equal( dUI.RECTANGLE, w.style.type )
	assert_equal( dUI.RECTANGLE, w.viewStyle.type )
end
