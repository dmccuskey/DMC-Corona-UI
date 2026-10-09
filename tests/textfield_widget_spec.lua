--====================================================================--
-- Test: TextField Widget
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
local stubs

local function track( w )
	widgets[ #widgets+1 ] = w
	return w
end

-- run the widget's pending commit now, instead of on the next frame
local function commit( w )
	w:__validate__()
	return w
end

-- replace t[k] for this test; teardown() puts it back
local function stub( t, k, f )
	stubs[ #stubs+1 ] = { t, k, t[k] }
	t[k] = f
end

-- the style specs load the base styles with their test defaults (anchorX
-- 503, fontSize 524, no text height, ...): give each field usable values,
-- plus its own
local function newStyleData( params )
	local text = function( color )
		return {
			width=200, height=40, anchorX=0.5, anchorY=0.5,
			align='center', marginX=10, marginY=5,
			font=native.systemFont, fontSize=16, fontSizeMinimum=0,
			fillColor={ 0, 0, 0, 0 }, textColor=color,
			strokeColor={ 0, 0, 0, 0 }, strokeWidth=0,
		}
	end
	local data = {
		width=200, height=40, anchorX=0.5, anchorY=0.5,
		align='center', backgroundStyle='none', inputType='default',
		isHitActive=true, isSecure=false, marginX=10, marginY=5,
		returnKey='done',
		background={ type='rectangle', view={ fillColor={ 1, 1, 1, 1 } } },
		hint=text{ 0.5, 0.5, 0.5, 1 },
		display=text{ 0, 0, 0, 1 },
	}
	for k, v in pairs( params or {} ) do data[k] = v end
	return data
end

local function newTextField( params )
	params = params or {}
	params.style = newStyleData( params.style )
	return commit( track( dUI.newTextField( params ) ) )
end

-- send the native field a userInput event
local function input( w, phase, text )
	local o = w._inputField
	if text then o.text = text end
	o:dispatchEvent{ name='userInput', phase=phase, target=o, text=text,
		startPosition=1, newCharacters=text, numDeleted=0 }
	commit( w )
end

-- count dUI's focus calls; no real keyboard focus
local function stubFocus()
	local calls = { set=0, unset=0, native=0 }
	stub( dUI, 'setKeyboardFocus', function() calls.set = calls.set+1 end )
	stub( dUI, 'unsetKeyboardFocus', function() calls.unset = calls.unset+1 end )
	stub( native, 'setKeyboardFocus', function() calls.native = calls.native+1 end )
	return calls
end



--====================================================================--
--== Module Testing
--====================================================================--


function setup()
	widgets = {}
	stubs = {}
end

function teardown()
	for _, w in ipairs( widgets ) do w:removeSelf() end
	widgets = nil
	for i = #stubs, 1, -1 do
		local s = stubs[i]
		s[1][ s[2] ] = s[3]
	end
	stubs = nil
end



--====================================================================--
--== Test TextField


--[[
the native field is made once: a new style keeps it (a new one dropped an
edit in progress); its height follows the text's, each time
--]]
function test_nativeFieldOnce()
	local n = 0
	local newTextField_f = native.newTextField
	stub( native, 'newTextField', function( ... ) n = n+1 ; return newTextField_f( ... ) end )
	local w = newTextField{ text='Text' }
	local field = w._inputField
	w.style = newStyleData{ width=250 }
	commit( w )
	assert_equal( 1, n )
	assert_equal( field, w._inputField )
	assert_equal( 230, field.width )

	for _, size in ipairs{ 30, 12 } do
		w.displayFontSize = size
		commit( w._wgtText ) ; commit( w )
		assert_equal( w._wgtText:getTextHeight(), field.height, "height follows the text" )
	end
end


--[[
returnKey reaches the native field, at creation and when changed
--]]
function test_returnKey()
	local keys = {}
	local newTextField_f = native.newTextField
	stub( native, 'newTextField', function( ... )
		local o = newTextField_f( ... )
		o.setReturnKey = function( o, key ) keys[ #keys+1 ] = key end
		return o
	end )
	local w = newTextField{ style={ returnKey='go' } }
	assert_equal( 'go', keys[ #keys ] )

	w:setReturnKey( 'send' )
	commit( w )
	assert_equal( 'send', keys[ #keys ] )
	assert_equal( 'send', w.style.returnKey )
end


--[[
debugOn changes reach the hit area
--]]
function test_debugOn()
	local w = newTextField()
	assert_equal( 0, w._rctHit.fill.a )
	w.debugOn = true
	commit( w )
	assert_true( w._rctHit.fill.a > 0 )
end


--[[
setKeyboardFocus() starts editing: the native field shows and takes the
focus; a second call while editing does nothing
--]]
function test_setKeyboardFocus()
	local calls = stubFocus()
	local w = newTextField()
	w:setKeyboardFocus()
	commit( w )
	assert_true( w.isEditing )
	assert_true( w._inputField.isVisible )
	assert_false( w._wgtText.view.isVisible )
	assert_equal( 1, calls.set )

	w:setKeyboardFocus()
	commit( w )
	assert_equal( 1, calls.set )
	assert_equal( 0, calls.native )

	w:unsetKeyboardFocus()
	commit( w )
	assert_equal( 1, calls.unset )
end


--[[
creating, changing or removing another field leaves an edit alone
--]]
function test_otherFieldKeepsFocus()
	local calls = stubFocus()
	local a = newTextField()
	a:setKeyboardFocus()
	commit( a )

	local b = newTextField()
	b.isSecure = true
	commit( b )
	b:removeSelf()
	table.remove( widgets )
	assert_equal( 0, calls.unset )
	assert_true( a.isEditing )
end


--[[
text is live while editing; submitting ends the edit and keeps it; each
holder of the focus gives it back once
--]]
function test_editAndSubmit()
	local calls = stubFocus()
	local w = newTextField{ hintText='Hint' }
	local phases = {}
	w:addEventListener( w.EVENT, function( e )
		phases[ #phases+1 ] = e.phase..':'..tostring( e.target.text )
	end )
	w:setKeyboardFocus()
	commit( w )
	input( w, 'began' )
	input( w, 'editing', 'ab' )
	assert_equal( 'ab', w.text, "live text" )
	assert_equal( 'Hint', w._wgtText.text, "display not yet changed" )

	input( w, 'submitted', 'ab' )
	input( w, 'ended', 'ab' )
	assert_false( w.isEditing )
	assert_equal( 'ab', w.text )
	assert_equal( 'ab', w._wgtText.text )
	assert_equal( 'began: editing:ab submitted:ab ended:ab', table.concat( phases, ' ' ) )
	assert_equal( 1, calls.set )
	assert_equal( 1, calls.unset )
end


--[[
when an edit ends, the display text is drawn with the new text in the
same update which shows it again: no frame with the old text (the hint)
--]]
function test_endShowsNewTextAtOnce()
	stubFocus()
	local w = newTextField{ hintText='Hint' }
	w:setKeyboardFocus()
	commit( w )
	input( w, 'began' )
	input( w, 'editing', 'ab' )
	assert_false( w._wgtText.isVisible, "hidden while editing" )

	input( w, 'ended', 'ab' )
	assert_true( w._wgtText.isVisible, "shown again" )
	assert_equal( 'ab', w._wgtText._txtText.text, "drawn with the new text" )

	-- and back to the hint, when the field is emptied
	w:setKeyboardFocus()
	commit( w )
	input( w, 'began' )
	input( w, 'editing', '' )
	input( w, 'ended', '' )
	assert_equal( 'Hint', w._wgtText._txtText.text, "drawn with the hint" )
end


--[[
a delegate can refuse the end: editing goes on, the field takes back the
focus it lost; on 'submitted' it still has it
--]]
function test_endRefused()
	local calls = stubFocus()
	local refuse = true
	local w = newTextField{ delegate={
		shouldEndEditing=function() return not refuse end,
	} }
	w:setKeyboardFocus()
	commit( w )
	input( w, 'began' )
	input( w, 'editing', 'x' )

	input( w, 'submitted', 'x' )
	assert_true( w.isEditing )
	assert_equal( 0, calls.native )

	input( w, 'ended', 'x' )
	assert_true( w.isEditing )
	assert_equal( 1, calls.native, "focus taken back" )
	assert_equal( 0, calls.unset )

	refuse = false
	input( w, 'ended', 'x' )
	assert_false( w.isEditing )
	assert_equal( 'x', w.text )
	assert_equal( 1, calls.unset )
end


--[[
isHitActive=false ignores taps
--]]
function test_isHitActive()
	local calls = stubFocus()
	local w = newTextField{ style={ isHitActive=false } }
	assert_false( w.isHitActive )
	local hit = w._rctHit
	local c = hit.contentBounds
	local x, y = ( c.xMin+c.xMax )/2, ( c.yMin+c.yMax )/2
	local function tap()
		hit:dispatchEvent{ name='touch', phase='began', target=hit, x=x, y=y }
		hit:dispatchEvent{ name='touch', phase='ended', target=hit, x=x, y=y }
		commit( w )
	end
	tap()
	assert_false( w.isEditing )

	w.isHitActive = true
	tap()
	assert_true( w.isEditing )
	display.getCurrentStage():setFocus( nil )
end



--====================================================================--
--== Test TextField Style


--[[
returnKey changes are sent to the widget
--]]
function test_styleReturnKey()
	local style = dUI.newTextFieldStyle( newStyleData() )
	local changed
	style.onPropertyChange = function( e )
		if e.property=='returnKey' then changed = e.value end
	end
	style.returnKey = 'next'
	assert_equal( 'next', style.returnKey )
	assert_equal( 'next', changed )
	style:removeSelf()
end



--[[
a style with no background type gets the base TextField style's (the
9-slice; Background's own default is 'rounded')
--]]
function test_styleBackgroundType()
	local base = dUI.Style.TextField.__base_style__
	local data = newStyleData()
	data.background = nil
	local style = dUI.newTextFieldStyle( data )
	assert_equal( base.background.type, style.background.type )

	data = newStyleData()
	data.background = { view={} }
	local style2 = dUI.newTextFieldStyle( data )
	assert_equal( base.background.type, style2.background.type )
	style:removeSelf()
	style2:removeSelf()
end


--[[
a tap on the text field stays with it: Solar2D sends 'tap' apart from 'touch',
and without a 'tap' listener of its own it reached what lies behind
--]]
function test_tapIsKept()
	local w = newTextField()
	local o = w._rctHit
	assert_true( o:dispatchEvent{ name='tap', target=o, x=0, y=0, numTaps=1 } )
end
