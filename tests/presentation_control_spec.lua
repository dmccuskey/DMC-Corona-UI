--====================================================================--
-- Test: Presentation Control (the modal page)
--====================================================================--

module(..., package.seeall)


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.1.0"



--====================================================================--
--== Imports


local dUI = require 'lib.dmc_ui'



--====================================================================--
--== Support Functions


local BAR_H = 40 -- the control's bar height

-- the screen, and the room below the status bar
local SCREEN_W, SCREEN_H = display.actualContentWidth, display.actualContentHeight
local SCREEN_X, SCREEN_Y = display.screenOriginX, display.screenOriginY
local TOP = SCREEN_Y + display.topStatusBarContentHeight
local ROOM_H = SCREEN_H - display.topStatusBarContentHeight

local controls

-- a Navigation Control with one view, to be presented.
-- the style specs load the base styles with their test defaults
-- (anchorX 503, ...): give the control's bar usable values
local function newControl( params )
	local ctrl = dUI.newNavigationControl( params )
	ctrl._navBar.style = {
		debugOn=false, width=ctrl.width, height=BAR_H, anchorX=0.5, anchorY=0
	}
	local view = display.newRect( 0, 0, 100, 100 )
	view.title = "Page"
	ctrl:pushView( view, { animate=false } )
	ctrl:__validate__()
	controls[ #controls+1 ] = ctrl
	return ctrl
end

local function newModal( params )
	params = params or {}
	if params.modalStyle==nil then params.modalStyle = dUI.MODAL end
	local ctrl = newControl( params )
	return ctrl, ctrl.presentationControl
end

-- run one frame of the presentation's motion, 'ms' after its start
-- (it moves on enterFrame; a test doesn't wait for frames)
local function frame( pres, ms )
	local f = pres._enterFrame_f
	if f then f( { name='enterFrame', time=pres._motion.start+ms } ) end
end

-- a delegate which notes each call
local function newDelegate( answer )
	local del = { calls={} }
	for _, name in ipairs{
		'presentationWillBegin', 'presentationEnded',
		'dismissalWillBegin', 'dismissalEnded', 'shouldDismiss'
	} do
		del[name] = function( self, pres )
			self.calls[ #self.calls+1 ] = name
			self.pres = pres
			if name=='shouldDismiss' then return answer end
		end
	end
	return del
end

local function calls( del )
	local s = table.concat( del.calls, ' ' )
	del.calls = {}
	return s
end

local function tapOutside( pres )
	local o = pres._rctDim
	return o:dispatchEvent{ name='tap', target=o, x=0, y=0, numTaps=1 }
end



--====================================================================--
--== Module Testing
--====================================================================--


function setup()
	controls = {}
end

function teardown()
	for _, ctrl in ipairs( controls ) do
		if ctrl.view then ctrl:removeSelf() end
	end
	controls = nil
end



--====================================================================--
--== Test Presentation Control


--[[
the constructors and constants are there
--]]
function test_exports()
	assert_equal( 'function', type( dUI.newPresentationControl ) )
	assert_equal( 'function', type( dUI.newPopoverControl ) )
	assert_nil( dUI.newPopover )
	assert_equal( 'string', type( dUI.MODAL ) )
	assert_equal( 'string', type( dUI.POPOVER ) )
	assert_equal( 'string', type( dUI.SLIDE_UP ) )
	assert_equal( 'string', type( dUI.FADE ) )
	assert_equal( 'string', type( dUI.NO_TRANSITION ) )
end


--[[
a control has no presentation until it has a modal style,
and presenting without one says what is missing
--]]
function test_noModalStyle()
	local ctrl = newControl()

	assert_nil( ctrl.modalStyle )
	assert_nil( ctrl.presentationControl )
	assert_nil( ctrl.popoverControl )
	assert_false( ctrl.isPresented )
	assert_error( function() ctrl:presentControl() end )
	assert_error( function() ctrl:dismissControl() end )
	assert_error( function() ctrl.modalStyle = 'window' end )
end


--[[
the modal style makes the presentation control, as a property
or as a constructor option; it is hidden until presented
--]]
function test_modalStyle()
	local ctrl = newControl()
	ctrl.modalStyle = dUI.MODAL
	local pres = ctrl.presentationControl

	assert_not_nil( pres )
	assert_nil( ctrl.popoverControl )
	assert_equal( ctrl, pres.presentedControl )
	assert_equal( pres.DISMISSED, pres.state )
	assert_false( pres.isVisible )
	assert_false( ctrl.isPresented )

	local ctrl2, pres2 = newModal()
	assert_equal( dUI.MODAL, ctrl2.modalStyle )
	assert_not_nil( pres2 )
end


--[[
without a preferred size the page is the screen below the status bar
--]]
function test_fullScreen()
	local ctrl, pres = newModal()
	ctrl:presentControl{ animated=false }

	assert_equal( SCREEN_W, ctrl.width )
	assert_equal( ROOM_H, ctrl.height )

	local b = pres._rctHit.contentBounds
	assert_equal( SCREEN_X, b.xMin )
	assert_equal( SCREEN_X+SCREEN_W, b.xMax )
	assert_equal( TOP, b.yMin )
	assert_equal( SCREEN_Y+SCREEN_H, b.yMax )

	-- the dimming layer is all of the screen
	b = pres._rctDim.contentBounds
	assert_equal( SCREEN_Y, b.yMin )
	assert_equal( SCREEN_Y+SCREEN_H, b.yMax )
	assert_equal( SCREEN_W, b.xMax-b.xMin )
end


--[[
a preferred size makes a panel, centered below the status bar;
a change while it shows moves it, nil is the full screen again
--]]
function test_preferredContentSize()
	local ctrl, pres = newModal{ preferredContentSize={ width=200, height=240 } }
	ctrl:presentControl{ animated=false }

	assert_equal( 200, ctrl.width )
	assert_equal( 240, ctrl.height )

	local b = pres._rctHit.contentBounds
	assert_equal( SCREEN_X + ( SCREEN_W-200 )*0.5, b.xMin )
	assert_equal( 200, b.xMax-b.xMin )
	assert_equal( TOP + ( ROOM_H-240 )*0.5, b.yMin )
	assert_equal( 240, b.yMax-b.yMin )

	ctrl.preferredContentSize = { width=100, height=120 }
	b = pres._rctHit.contentBounds
	assert_equal( 100, ctrl.width )
	assert_equal( TOP + ( ROOM_H-120 )*0.5, b.yMin )

	-- no larger than the room
	ctrl.preferredContentSize = { width=SCREEN_W+100, height=SCREEN_H+100 }
	assert_equal( SCREEN_W, ctrl.width )
	assert_equal( ROOM_H, ctrl.height )

	ctrl.preferredContentSize = nil
	assert_equal( SCREEN_W, ctrl.width )

	assert_error( function() ctrl.preferredContentSize = { width=10 } end )
end


--[[
the page slides up by default: from below the screen to its place,
while the dimming layer fades in
--]]
function test_slideUp()
	local ctrl, pres = newModal()
	local done = 0
	ctrl:presentControl{ time=400, onComplete=function() done = done + 1 end }

	assert_equal( pres.PRESENTING, pres.state )
	assert_true( ctrl.isPresented )
	assert_true( pres.isVisible )
	assert_equal( 0, pres._rctDim.alpha )
	-- at the start: all of it below the screen
	assert_true( pres._rctHit.contentBounds.yMin >= SCREEN_Y+SCREEN_H )

	frame( pres, 200 )
	local y = pres._rctHit.contentBounds.yMin
	assert_true( y > TOP and y < SCREEN_Y+SCREEN_H )
	assert_equal( 0.5, pres._rctDim.alpha, 0.01 )
	assert_equal( 1, pres._panel.alpha )
	assert_equal( 0, done )

	frame( pres, 400 )
	assert_equal( pres.PRESENTED, pres.state )
	assert_equal( TOP, pres._rctHit.contentBounds.yMin )
	assert_equal( 1, pres._rctDim.alpha )
	assert_equal( 1, done )
	assert_nil( pres._enterFrame_f )
end


--[[
dUI.FADE: the page fades in at its place
--]]
function test_fade()
	local ctrl, pres = newModal()
	ctrl:presentControl{ transition=dUI.FADE, time=400 }

	assert_equal( 0, pres._panel.alpha )
	frame( pres, 100 )
	assert_equal( 0.25, pres._panel.alpha, 0.01 )
	assert_equal( TOP, pres._rctHit.contentBounds.yMin )
	frame( pres, 400 )
	assert_equal( 1, pres._panel.alpha )
	assert_equal( pres.PRESENTED, pres.state )

	-- the dismissal uses the presentation's transition
	ctrl:dismissControl{ time=400 }
	frame( pres, 300 )
	assert_equal( 0.25, pres._panel.alpha, 0.01 )
	assert_equal( TOP, pres._rctHit.contentBounds.yMin )
end


--[[
dUI.NO_TRANSITION, animated=false and time=0: in place at once,
the function called before the call returns. animated=false is
for the one call, the transition stays the presentation's
--]]
function test_noTransition()
	for _, params in ipairs{
		{ transition=dUI.NO_TRANSITION }, { animated=false }, { time=0 }
	} do
		local ctrl, pres = newModal()
		local done = 0
		params.onComplete = function() done = done + 1 end

		ctrl:presentControl( params )
		assert_equal( pres.PRESENTED, pres.state )
		assert_equal( 1, pres._panel.alpha )
		assert_equal( TOP, pres._rctHit.contentBounds.yMin )
		assert_equal( 1, done )

		ctrl:dismissControl( params )
		assert_equal( pres.DISMISSED, pres.state )
		assert_false( pres.isVisible )
		assert_equal( 2, done )
	end

	local ctrl, pres = newModal()
	assert_error( function() ctrl:presentControl{ transition='spin' } end )

	ctrl:presentControl{ animated=false }
	ctrl:dismissControl()
	assert_equal( pres.DISMISSING, pres.state )
end


--[[
a dismissal hides the presentation; the control can be presented again
--]]
function test_dismissAndPresentAgain()
	local ctrl, pres = newModal()
	local done = 0
	local f = function() done = done + 1 end

	ctrl:presentControl{ animated=false }
	ctrl:dismissControl{ time=400, onComplete=f }
	assert_equal( pres.DISMISSING, pres.state )
	assert_false( ctrl.isPresented )
	assert_true( pres.isVisible )

	frame( pres, 400 )
	assert_equal( pres.DISMISSED, pres.state )
	assert_false( pres.isVisible )
	assert_equal( 1, done )

	ctrl:presentControl{ time=400, onComplete=f }
	frame( pres, 400 )
	assert_equal( pres.PRESENTED, pres.state )
	assert_true( pres.isVisible )
	assert_equal( TOP, pres._rctHit.contentBounds.yMin )
	assert_equal( 2, done )
end


--[[
a call which changes nothing: its function is called, at once when
the presentation is at rest, with the motion's own otherwise
--]]
function test_repeatedCalls()
	local ctrl, pres = newModal()
	local done = 0
	local f = function() done = done + 1 end

	ctrl:dismissControl{ onComplete=f }
	assert_equal( 1, done )

	ctrl:presentControl{ time=400, onComplete=f }
	ctrl:presentControl{ time=400, onComplete=f }
	assert_equal( 1, done )
	frame( pres, 400 )
	assert_equal( 3, done )

	ctrl:presentControl{ onComplete=f }
	assert_equal( 4, done )
	assert_equal( pres.PRESENTED, pres.state )
end


--[[
a dismissal during the presentation (and the other way around) turns
the motion around from where it is; the function of the call which
was cut short isn't called
--]]
function test_turnAround()
	local ctrl, pres = newModal()
	local presented, dismissed = 0, 0

	ctrl:presentControl{ time=400, onComplete=function() presented = presented + 1 end }
	frame( pres, 300 )
	local y = pres._rctHit.contentBounds.yMin

	ctrl:dismissControl{ time=400, onComplete=function() dismissed = dismissed + 1 end }
	assert_equal( pres.DISMISSING, pres.state )
	assert_equal( y, pres._rctHit.contentBounds.yMin )
	-- three quarters in: back out in three quarters of the time
	frame( pres, 150 )
	assert_equal( 0.375, pres._rctDim.alpha, 0.01 )
	frame( pres, 300 )
	assert_equal( pres.DISMISSED, pres.state )
	assert_equal( 0, presented )
	assert_equal( 1, dismissed )

	ctrl:presentControl{ time=400 }
	frame( pres, 400 )
	ctrl:dismissControl{ time=400 }
	frame( pres, 100 )
	ctrl:presentControl{ time=400, onComplete=function() presented = presented + 1 end }
	assert_equal( pres.PRESENTING, pres.state )
	frame( pres, 100 )
	assert_equal( pres.PRESENTED, pres.state )
	assert_equal( 1, presented )
	assert_equal( 1, dismissed )
end


--[[
the delegate is told about each step
--]]
function test_delegate()
	local ctrl, pres = newModal()
	local del = newDelegate()
	pres.delegate = del

	ctrl:presentControl{ time=400 }
	assert_equal( 'presentationWillBegin', calls( del ) )
	assert_equal( pres, del.pres )
	frame( pres, 400 )
	assert_equal( 'presentationEnded', calls( del ) )

	ctrl:dismissControl{ time=400 }
	assert_equal( 'dismissalWillBegin', calls( del ) )
	frame( pres, 400 )
	assert_equal( 'dismissalEnded', calls( del ) )

	-- a delegate without the methods
	pres.delegate = {}
	ctrl:presentControl{ animated=false }
	ctrl:dismissControl{ animated=false }
	pres.delegate = nil
	ctrl:presentControl{ animated=false }
end


--[[
a tap outside the panel is kept, and dismisses only when asked to
and when the delegate doesn't object
--]]
function test_tapOutside()
	local ctrl, pres = newModal{ preferredContentSize={ width=200, height=240 } }
	ctrl:presentControl{ animated=false }

	assert_false( pres.dismissOnTapOutside )
	assert_true( tapOutside( pres ) )
	assert_equal( pres.PRESENTED, pres.state )

	pres.dismissOnTapOutside = true
	local del = newDelegate( false )
	pres.delegate = del
	assert_true( tapOutside( pres ) )
	assert_equal( 'shouldDismiss', calls( del ) )
	assert_equal( pres.PRESENTED, pres.state )

	pres.delegate = newDelegate( true )
	assert_true( tapOutside( pres ) )
	assert_equal( pres.DISMISSING, pres.state )

	-- a tap during the motion doesn't start another
	assert_true( tapOutside( pres ) )
	assert_equal( 'shouldDismiss dismissalWillBegin', calls( pres.delegate ) )
end


--[[
touches and taps stay with the presentation: on the dimming layer,
and on the panel where the control doesn't take them
--]]
function test_touchAndTapAreKept()
	local ctrl, pres = newModal{ preferredContentSize={ width=200, height=240 } }
	ctrl:presentControl{ animated=false }

	for _, o in ipairs{ pres._rctDim, pres._rctHit } do
		assert_true( o.isHitTestable )
		assert_true( o:dispatchEvent{ name='touch', phase='began', target=o, x=0, y=0 } )
		assert_true( o:dispatchEvent{ name='tap', target=o, x=0, y=0, numTaps=1 } )
	end
end


--[[
the colors of the dimming layer and of the panel behind the view
--]]
function test_colors()
	local ctrl, pres = newModal()
	assert_equal( 0.4, pres.dimColor[4] )
	assert_equal( 1, pres.panelColor[4] )

	pres.dimColor = { 1, 0, 0, 0.5 }
	assert_equal( 0.5, pres.dimColor[4] )
	assert_error( function() pres.dimColor = 'red' end )

	pres.panelColor = { 0, 0, 0, 0 }
	assert_equal( 0, pres.panelColor[4] )
	assert_true( pres._rctHit.isHitTestable )
	assert_error( function() pres.panelColor = 'red' end )
end


--[[
modalStyle=nil gives the control's view back: its parent, place and size
--]]
function test_modalStyleNil()
	local group = display.newGroup()
	local ctrl = newControl{ width=300, height=400 }
	group:insert( ctrl.view )
	ctrl.x, ctrl.y = 30, 40

	ctrl.modalStyle = dUI.MODAL
	local pres = ctrl.presentationControl
	ctrl:presentControl{ time=400 }
	frame( pres, 200 )
	assert_not_equal( group, ctrl.view.parent )
	assert_equal( SCREEN_W, ctrl.width )

	ctrl.modalStyle = nil
	assert_nil( ctrl.presentationControl )
	assert_nil( pres.view )
	assert_nil( pres._enterFrame_f )
	assert_equal( group, ctrl.view.parent )
	assert_equal( 30, ctrl.x )
	assert_equal( 40, ctrl.y )
	assert_equal( 300, ctrl.width )
	assert_equal( 400, ctrl.height )
	assert_false( ctrl.isPresented )

	-- and back
	ctrl.modalStyle = dUI.MODAL
	ctrl:presentControl{ animated=false }
	assert_true( ctrl.isPresented )

	ctrl:removeSelf()
	group:removeSelf()
end


--[[
removing the control removes its presentation, also during a motion
--]]
function test_removeWhilePresented()
	local stage = display.getCurrentStage()
	local count = stage.numChildren

	local ctrl, pres = newModal()
	ctrl:presentControl{ time=400 }
	frame( pres, 200 )
	ctrl:removeSelf()

	assert_nil( pres.view )
	assert_nil( pres._enterFrame_f )
	assert_equal( count, stage.numChildren )

	-- from the function called at the end of a dismissal
	ctrl, pres = newModal()
	ctrl:presentControl{ animated=false }
	ctrl:dismissControl{ time=400, onComplete=function() ctrl:removeSelf() end }
	frame( pres, 400 )
	assert_nil( pres.view )
	assert_equal( count, stage.numChildren )
end


--[[
the popover is a presentation too: its own control, the default size
of a popover, a fade, and a tap outside dismisses
--]]
function test_popoverStyle()
	local ctrl = newControl()
	ctrl.modalStyle = dUI.POPOVER
	local pop = ctrl.popoverControl

	assert_not_nil( pop )
	assert_equal( pop, ctrl.presentationControl )
	assert_true( pop.dismissOnTapOutside )
	assert_equal( 320, ctrl.preferredContentSize.width )

	ctrl:presentControl{ time=100 }
	assert_equal( 0, pop._panel.alpha )
	frame( pop, 100 )
	assert_equal( pop.PRESENTED, pop.state )

	assert_true( tapOutside( pop ) )
	assert_equal( pop.DISMISSING, pop.state )

	-- from one style to the other
	ctrl.modalStyle = dUI.MODAL
	assert_nil( pop.view )
	assert_nil( ctrl.popoverControl )
	assert_not_nil( ctrl.presentationControl )
end


--[[
no globals are left behind
--]]
function test_noGlobals()
	local ctrl, pres = newModal()
	ctrl:presentControl{ time=100 }
	frame( pres, 100 )
	ctrl:dismissControl{ time=100 }
	frame( pres, 100 )

	for _, name in ipairs{ 'params', 'f', 'o', 'dg', 'frame', 'screen' } do
		assert_nil( rawget( _G, name ) )
	end
end
