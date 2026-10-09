--====================================================================--
-- Test: Button Widget
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

-- the style specs load the base styles with their test defaults (anchorX
-- 403, fontSize 401, ...): give each button usable values, plus its own
local function newStyleData( params )
	local state = function()
		return {
			label={ fontSize=12, textColor={ 0, 0, 0, 1 } },
			background={ type='rectangle', view={ fillColor={ 1, 1, 1, 1 } } },
		}
	end
	local data = {
		width=100, height=40, anchorX=0.5, anchorY=0.5,
		align='center', hitMarginX=0, hitMarginY=0, isHitActive=true,
		marginX=0, marginY=0, offsetX=0, offsetY=0,
		inactive=state(), active=state(), disabled=state(),
	}
	for k, v in pairs( params or {} ) do
		if type(v)=='table' and type(data[k])=='table' then
			for k2, v2 in pairs( v ) do data[k][k2] = v2 end
		else
			data[k] = v
		end
	end
	return data
end

local function newButton( params )
	params = params or {}
	local action = params.action or 'push'
	params.action = nil
	if type( params.style )~='table' or params.style.isa==nil then
		params.style = newStyleData( params.style )
	end
	local w
	if action=='toggle' then
		w = dUI.newToggleButton( params )
	elseif action=='radio' then
		w = dUI.newRadioButton( params )
	else
		w = dUI.newPushButton( params )
	end
	return commit( track( w ) )
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
--== Test Button


--[[
press() calls onPress, onEvent, then the listeners; then the same for release
--]]
function test_pressEvents()
	local calls = {}
	local function log( name )
		return function( e ) calls[ #calls+1 ] = name..':'..e.phase..':'..e.id end
	end
	local w = newButton{ id='ok', onPress=log('press'), onRelease=log('release'), onEvent=log('event') }
	w:addEventListener( w.EVENT, function( e )
		assert_equal( w.EVENT, e.name )
		assert_equal( w, e.target )
		calls[ #calls+1 ] = 'listener:'..e.phase
	end )

	w:press()
	assert_equal( table.concat( {
		'press:pressed:ok', 'event:pressed:ok', 'listener:pressed',
		'release:released:ok', 'event:released:ok', 'listener:released',
	}, ' ' ), table.concat( calls, ' ' ) )
	assert_false( w.isActive, "a push button is inactive after release" )
end


--[[
a toggle button switches state on each press
--]]
function test_toggle()
	local w = newButton{ action='toggle' }
	assert_false( w.isActive )
	w:press()
	assert_true( w.isActive )
	w:press()
	assert_false( w.isActive )
end


--[[
a touch which leaves a toggle or radio button before it ends changes
nothing: the button looks as it did, and no release is sent
--]]
function test_toggleReleasedOutside()
	for _, action in ipairs{ 'toggle', 'radio' } do
		local released = 0
		local w = newButton{ action=action, onRelease=function() released = released+1 end }
		local hit = w._rctHit
		local b = hit.contentBounds
		local x, y = ( b.xMin+b.xMax )/2, ( b.yMin+b.yMax )/2
		local function touch( phase, tx )
			hit:dispatchEvent{ name='touch', phase=phase, target=hit, x=tx, y=y }
		end

		touch( 'began', x )
		assert_equal( w.STATE_ACTIVE, w._widgetViewState, action..": looks active while pressed" )
		touch( 'moved', b.xMax+50 )
		assert_equal( w.STATE_INACTIVE, w._widgetViewState, action..": looks inactive once outside" )
		touch( 'moved', x )
		assert_equal( w.STATE_ACTIVE, w._widgetViewState, action..": looks active again inside" )
		touch( 'moved', b.xMax+50 )
		touch( 'ended', b.xMax+50 )
		assert_equal( w.STATE_INACTIVE, w._widgetViewState, action..": looks inactive after the release" )
		assert_false( w.isActive, action..": still inactive" )
		assert_equal( 0, released, action..": no release sent" )

		-- an active toggle button stays active the same way
		if action=='toggle' then
			w:press()
			assert_true( w.isActive )
			touch( 'began', x )
			assert_equal( w.STATE_INACTIVE, w._widgetViewState, "looks inactive while pressed" )
			touch( 'moved', b.xMax+50 )
			touch( 'ended', b.xMax+50 )
			assert_equal( w.STATE_ACTIVE, w._widgetViewState, "looks active after the release" )
			assert_true( w.isActive, "still active" )
		end
	end
end


--[[
isEnabled leaves a shared style alone: the other buttons still work
--]]
function test_isEnabledKeepsSharedStyle()
	local style = dUI.newButtonStyle( newStyleData() )
	local pressed = {}
	local function onRelease( e ) pressed[ e.id ] = true end
	local b1 = newButton{ id='b1', style=style, onRelease=onRelease }
	local b2 = newButton{ id='b2', style=style, onRelease=onRelease }

	b1.isEnabled = false
	assert_false( b1.isEnabled )
	assert_equal( b1.STATE_DISABLED, b1:getState() )
	assert_true( style.isHitActive, "shared style untouched" )
	assert_true( b2.isEnabled )

	b1:press() ; b2:press()
	assert_nil( pressed.b1, "a disabled button ignores presses" )
	assert_true( pressed.b2, "the other button still works" )

	b1.isEnabled = true
	b1:press()
	assert_true( pressed.b1, "enabled again" )
	style:removeSelf()
end


--[[
isEnabled=false disables a button whose isHitActive is already false
--]]
function test_isEnabledWithHitInactive()
	local w = newButton{ style={ isHitActive=false } }
	w.isEnabled = false
	assert_false( w.isEnabled )
	assert_equal( w.STATE_DISABLED, w:getState() )
end


--[[
isHitActive=false ignores presses, on toggle buttons too
--]]
function test_isHitActive()
	local n = 0
	local function onRelease() n = n+1 end
	local p = newButton{ style={ isHitActive=false }, onRelease=onRelease }
	local t = newButton{ action='toggle', style={ isHitActive=false }, onRelease=onRelease }
	p:press() ; t:press()
	assert_equal( 0, n )
	assert_false( t.isActive, "toggle not switched" )

	t.isHitActive = true
	t:press()
	assert_equal( 1, n )
	assert_true( t.isActive )
end


--[[
each state's offsetX/offsetY moves the label
--]]
function test_labelOffset()
	local w = newButton{ action='toggle', style={
		inactive={ offsetX=7, offsetY=3 },
		active={ offsetX=-2, offsetY=0 },
	} }
	assert_equal( 7, w._wgtText.x )
	assert_equal( 3, w._wgtText.y )

	w:press()
	commit( w )
	assert_equal( -2, w._wgtText.x, "active state's offset" )
	assert_equal( 0, w._wgtText.y )
end


--[[
a state with another type of background is drawn in the same update which
switches to it: no frame without a background
--]]
function test_stateBackgroundDrawnAtOnce()
	local w = newButton{ action='toggle', style={
		active={
			label={ fontSize=12, textColor={ 0, 0, 0, 1 } },
			background={ type='rounded', view={
				fillColor={ 0, 1, 0, 1 }, cornerRadius=4,
				strokeWidth=1, strokeColor={ 0, 0, 0, 1 },
			} },
		},
	} }
	assert_equal( 'rectangle', w._wgtBg._wgtView.TYPE )

	w:press()
	commit( w )
	local view = w._wgtBg._wgtView
	assert_equal( 'rounded', view.TYPE, "the active state's view" )
	-- (the shape's size counts its stroke)
	assert_true( view._rndBg.width>=100, "drawn at the button's size" )
	assert_true( view._rndBg.height>=40 )

	w:press()
	commit( w )
	view = w._wgtBg._wgtView
	assert_equal( 'rectangle', view.TYPE, "back to the inactive state's view" )
	assert_true( view.view.contentWidth>=100, "drawn at the button's size" )
end


--[[
offsetX/offsetY on the button style are valid and handed to the states
--]]
function test_buttonOffset()
	local style = dUI.newButtonStyle( newStyleData{ offsetX=5, offsetY=6,
		inactive={ label={ fontSize=12 }, background={ type='rectangle' } } } )
	assert_equal( 5, style.offsetX )
	assert_equal( 6, style.offsetY )
	assert_equal( 5, style.inactive.offsetX )
	assert_equal( 6, style.inactive.offsetY )
	style:removeSelf()
end


--[[
debugOn changes reach the hit area
--]]
function test_debugOn()
	local w = newButton()
	local fill
	local hit = w._rctHit
	local setFillColor = hit.setFillColor
	hit.setFillColor = function( o, ... ) fill = { ... } ; return setFillColor( o, ... ) end

	w.style.debugOn = true
	commit( w )
	hit.setFillColor = nil
	assert_not_nil( fill, "hit area redrawn" )
	assert_equal( 0.5, fill[4] )
end


--[[
labelText changes show in the label
--]]
function test_labelText()
	local w = newButton{ labelText='Before' }
	assert_equal( 'Before', w._wgtText.text )
	w.labelText = 'After'
	commit( w )
	assert_equal( 'After', w._wgtText.text )
end



--====================================================================--
--== Test Button Style


--[[
a copied style keeps its own disabled state, not the active one
--]]
function test_copyStyleKeepsDisabled()
	local style = dUI.newButtonStyle( newStyleData{
		active={ background={ type='rectangle' } },
		disabled={ background={ type='rounded' } },
	} )
	local copy = style:copyStyle()
	assert_equal( 'rounded', copy.disabled.background.type )
	copy:removeSelf()
	style:removeSelf()
end


--[[
clearing to a source copies each state from the same state
--]]
function test_clearPropertiesStates()
	local src = dUI.newButtonStyle( newStyleData{
		inactive={ offsetX=1 }, active={ offsetX=2 }, disabled={ offsetX=3 },
	} )
	local style = dUI.newButtonStyle( newStyleData() )
	style:_clearProperties( src, { force=true } )
	assert_equal( 1, style.inactive.offsetX )
	assert_equal( 2, style.active.offsetX )
	assert_equal( 3, style.disabled.offsetX )
	style:removeSelf()
	src:removeSelf()
end



--====================================================================--
--== Test Button Group


--[[
a radio group: the first button starts active; a press selects another
--]]
function test_radioGroup()
	local group = dUI.newButtonGroup{ type='radio' }
	local changed
	group:addEventListener( group.EVENT, function( e )
		assert_equal( group.CHANGED, e.type )
		changed = e.id
	end )
	local r1 = newButton{ action='radio', id='r1' }
	local r2 = newButton{ action='radio', id='r2' }
	group:add( r1 ) ; group:add( r2 )
	assert_true( r1.isActive )
	assert_equal( r1, group.selected )

	r2:press()
	assert_true( r2.isActive )
	assert_false( r1.isActive )
	assert_equal( r2, group.selected )
	assert_equal( 'r2', changed )
	assert_equal( r1, group:getButton( 'r1' ) )

	r2:press()
	assert_true( r2.isActive, "pressing the selected one keeps it" )
	group:removeSelf()
end


--[[
a toggle group: at most one active, none at the start
--]]
function test_toggleGroup()
	local group = dUI.newButtonGroup{ type='toggle' }
	local t1 = newButton{ action='toggle', id='t1' }
	local t2 = newButton{ action='toggle', id='t2' }
	group:add( t1 ) ; group:add( t2 )
	assert_false( t1.isActive )
	assert_nil( group.selected )

	t1:press()
	assert_true( t1.isActive )
	t2:press()
	assert_true( t2.isActive )
	assert_false( t1.isActive, "one active at most" )
	assert_equal( t2, group.selected )

	t2:press()
	assert_false( t2.isActive )
	assert_nil( group.selected )
	group:removeSelf()
end


--[[
add( button, {set_active=true} ) makes it the only active one; remove()
clears the selection; a disabled button keeps its state
--]]
function test_groupAddRemove()
	local group = dUI.newButtonGroup{ type='radio' }
	local r1 = newButton{ action='radio', id='r1' }
	local r2 = newButton{ action='radio', id='r2' }
	local r3 = newButton{ action='radio', id='r3' }
	r3.isEnabled = false
	group:add( r1 ) ; group:add( r3 )
	group:add( r2, { set_active=true } )
	assert_true( r2.isActive )
	assert_false( r1.isActive, "only one active" )
	assert_equal( r3.STATE_DISABLED, r3:getState(), "disabled kept" )
	assert_equal( r2, group.selected )

	group:remove( r2 )
	assert_nil( group.selected )
	assert_nil( group:getButton( 'r2' ) )
	group:removeSelf()
end


--[[
a tap on the button stays with it: Solar2D sends 'tap' apart from 'touch',
and without a 'tap' listener of its own it reached what lies behind
--]]
function test_tapIsKept()
	local w = newButton{ labelText="Press" }
	local o = w._rctHit
	assert_true( o:dispatchEvent{ name='tap', target=o, x=0, y=0, numTaps=1 } )
end
