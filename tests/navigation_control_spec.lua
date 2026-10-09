--====================================================================--
-- Test: Navigation Control
--====================================================================--

module(..., package.seeall)


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.1.0"



--====================================================================--
--== Imports


local dUI = require 'lib.dmc_ui'



--====================================================================--
--== Support Functions


local W, H = 320, 480 -- the control's size
local BAR_H = 40 -- its bar's height

local controls

-- run the control's pending commit now, instead of on the next frame
local function commit( ctrl )
	ctrl:__validate__()
	ctrl._navBar:__validate__()
	return ctrl
end

-- run one frame of the control's slide, 'ms' from now
-- (it moves on enterFrame; a test doesn't wait for frames)
local function frame( ctrl, ms )
	commit( ctrl )
	local f = ctrl._enterFrame_f
	if f then f( { name='enterFrame', time=system.getTimer()+( ms or 0 ) } ) end
	commit( ctrl )
end

-- run frames until every push and pop has been done
local function settle( ctrl )
	for i=1, 20 do
		frame( ctrl, 1000 )
		if not ctrl._transition and #ctrl._pending==0 then return end
	end
	error( "the control didn't come to rest" )
end

-- the style specs load the base styles with their test defaults
-- (anchorX 503, ...): give the control's bar usable values
local function newControl( params )
	params = params or {}
	if params.width==nil then params.width = W end
	if params.height==nil then params.height = H end
	local ctrl = dUI.newNavigationControl( params )
	ctrl._navBar.style = {
		debugOn=false, width=params.width, height=BAR_H, anchorX=0.5, anchorY=0
	}
	controls[ #controls+1 ] = ctrl
	return commit( ctrl )
end

-- a view which is a display object
local function newRectView( title )
	local view = display.newRect( 0, 0, 100, 100 )
	view.title = title
	return view
end

-- a view which is a table with a display group, and which
-- notes each call of its functions
local function newTableView( title )
	local view = { title=title, view=display.newGroup(), calls={} }
	local o = display.newRect( 0, 0, 100, 100 )
	view.view:insert( o )
	for _, name in ipairs{
		'willBeAdded', 'viewInMotion', 'viewDidAppear', 'viewDidDisappear', 'willBeRemoved'
	} do
		view[name] = function( self, value )
			local s = name
			if value~=nil then s = s..'='..tostring( value ) end
			self.calls[ #self.calls+1 ] = s
		end
	end
	return view
end

-- a control with views already on its stack, at rest
local function newControlWith( ... )
	local ctrl = newControl()
	local views = {}
	for i, title in ipairs( { ... } ) do
		views[i] = newRectView( title )
		ctrl:pushView( views[i], { animate=false } )
		commit( ctrl )
	end
	return ctrl, views
end

local function stack( ctrl )
	local t = {}
	for i, view in ipairs( ctrl._views ) do t[i] = view.title end
	return table.concat( t, ',' )
end

local function barStack( ctrl )
	local t = {}
	for i, item in ipairs( ctrl._navBar._items ) do t[i] = item.titleText end
	return table.concat( t, ',' )
end

local function calls( view )
	local s = table.concat( view.calls, ' ' )
	view.calls = {}
	return s
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
--== Test Navigation Control


--[[
two pushes before a frame has passed: both views are on the stack
(the second replaced the first, which was never shown)
--]]
function test_twoPushesInOneFrame()
	local ctrl = newControl()
	local one, two = newRectView( "One" ), newRectView( "Two" )

	ctrl:pushView( one )
	ctrl:pushView( two )
	settle( ctrl )

	assert_equal( "One,Two", stack( ctrl ) )
	assert_equal( "One,Two", barStack( ctrl ) )
	assert_false( one.isVisible )
	assert_true( two.isVisible )
	assert_nil( ctrl._enterFrame_f )
end


--[[
a push during a slide waits for the slide to end, then slides in
itself (it raised 'Animation already in progress')
--]]
function test_pushDuringSlide()
	local ctrl, views = newControlWith( "One" )
	local two, three = newRectView( "Two" ), newRectView( "Three" )

	ctrl:pushView( two )
	frame( ctrl, 100 )
	assert_not_nil( ctrl._enterFrame_f, "slide is running" )

	ctrl:pushView( three )
	assert_equal( "One", stack( ctrl ), "the slide goes on" )
	frame( ctrl, 1000 )
	assert_equal( "One,Two", stack( ctrl ) )
	assert_not_nil( ctrl._transition, "the next slide has started" )
	settle( ctrl )

	assert_equal( "One,Two,Three", stack( ctrl ) )
	assert_equal( "One,Two,Three", barStack( ctrl ) )
	assert_true( three.isVisible )
	assert_equal( 0, three.x )
	assert_false( two.isVisible )
end


--[[
isViewInMotion is true from a push or pop until its slide, and each
one in line, has ended
--]]
function test_isViewInMotion()
	local ctrl, views = newControlWith( "One" )
	assert_false( ctrl.isViewInMotion )

	ctrl:pushView( newRectView( "Two" ) )
	assert_true( ctrl.isViewInMotion, "from the call on" )
	ctrl:pushView( newRectView( "Three" ) )
	frame( ctrl, 1000 )
	assert_equal( "One,Two", stack( ctrl ) )
	assert_true( ctrl.isViewInMotion, "one more in line" )
	settle( ctrl )
	assert_false( ctrl.isViewInMotion )

	ctrl:popViewAnimated()
	ctrl:popViewAnimated()
	assert_true( ctrl.isViewInMotion )
	settle( ctrl )
	assert_equal( "One", stack( ctrl ) )
	assert_false( ctrl.isViewInMotion )

	assert_false( ctrl:popViewAnimated(), "the root view stays" )
	assert_false( ctrl.isViewInMotion )
end


--[[
a view which waits in line is hidden from the push on (it showed
where it was made until its slide started)
--]]
function test_waitingViewIsHidden()
	local ctrl, views = newControlWith( "One" )
	local two, three = newRectView( "Two" ), newTableView( "Three" )

	ctrl:pushView( two )
	frame( ctrl, 100 )
	ctrl:pushView( three )

	assert_equal( 1, #ctrl._pending )
	assert_false( three.view.isVisible )
	settle( ctrl )
	assert_true( three.view.isVisible )
end


--[[
with wait=false a push doesn't wait: the running slide is put at
its end at once
--]]
function test_pushDuringSlideNoWait()
	local ctrl, views = newControlWith( "One" )
	local two, three = newRectView( "Two" ), newRectView( "Three" )

	ctrl:pushView( two )
	frame( ctrl, 100 )
	ctrl:pushView( three, { wait=false } )
	assert_equal( "One,Two", stack( ctrl ) )
	assert_equal( 0, two.x )
	settle( ctrl )

	assert_equal( "One,Two,Three", stack( ctrl ) )
	assert_equal( "One,Two,Three", barStack( ctrl ) )
end


--[[
pushes and pops which wait are done in the order of the calls, and
wait=false takes all of them to their end first
--]]
function test_callsWaitInOrder()
	local ctrl, views = newControlWith( "One" )
	local two, three, four = newRectView( "Two" ), newRectView( "Three" ), newRectView( "Four" )

	ctrl:pushView( two )
	ctrl:pushView( three )
	assert_true( ctrl:popViewAnimated() )
	assert_equal( 2, #ctrl._pending )

	ctrl:pushView( four, { wait=false } )
	assert_equal( 0, #ctrl._pending )
	assert_equal( "One,Two", stack( ctrl ) )
	settle( ctrl )

	assert_equal( "One,Two,Four", stack( ctrl ) )
	assert_equal( "One,Two,Four", barStack( ctrl ) )
end


--[[
a pop during a slide waits too; one which would take the root
view is refused when it is called
--]]
function test_popDuringSlide()
	local ctrl, views = newControlWith( "One", "Two", "Three" )

	assert_true( ctrl:popViewAnimated() )
	frame( ctrl, 100 )
	assert_true( ctrl:popViewAnimated() )
	assert_false( ctrl:popViewAnimated(), "the root view stays" )
	assert_equal( "One,Two,Three", stack( ctrl ), "the slide goes on" )
	settle( ctrl )

	assert_equal( "One", stack( ctrl ) )
	assert_equal( "One", barStack( ctrl ) )
	assert_true( views[1].isVisible )
end


--[[
a view which is on the stack can't be pushed again
--]]
function test_pushViewTwice()
	local ctrl, views = newControlWith( "One", "Two" )
	local three = newRectView( "Three" )

	assert_error( function() ctrl:pushView( views[1] ) end )
	-- nor one which is sliding in, or waiting to
	ctrl:pushView( three )
	assert_error( function() ctrl:pushView( three ) end )
	settle( ctrl )
	assert_equal( "One,Two,Three", stack( ctrl ) )
end


--[[
a pop slides the top view out and shows the one below
--]]
function test_popView()
	local ctrl, views = newControlWith( "One", "Two" )

	assert_true( ctrl:popViewAnimated() )
	frame( ctrl, 100 )
	assert_true( views[1].isVisible )
	assert_true( views[2].isVisible, "both show during the slide" )
	frame( ctrl, 1000 )

	assert_equal( "One", stack( ctrl ) )
	assert_equal( "One", barStack( ctrl ) )
	assert_true( views[1].isVisible )
	assert_equal( 0, views[1].x )
	assert_false( views[2].isVisible )
end


--[[
the first (root) view stays (a pop removed it, and the next one
raised an error from the bar)
--]]
function test_popRootView()
	local ctrl, views = newControlWith( "One" )

	assert_false( ctrl:popViewAnimated() )
	frame( ctrl, 1000 )

	assert_equal( "One", stack( ctrl ) )
	assert_equal( "One", barStack( ctrl ) )
	assert_true( views[1].isVisible )
end


--[[
the Back button pops the view and the bar's item together
--]]
function test_backButton()
	local ctrl, views = newControlWith( "One", "Two" )

	views[2].navItem.backButton:press()
	frame( ctrl, 1000 )

	assert_equal( "One", stack( ctrl ) )
	assert_equal( "One", barStack( ctrl ) )
end


--[[
a second Back press during the slide is ignored (it raised
'Animation already in progress', inside a touch listener)
--]]
function test_backButtonTwice()
	local ctrl, views = newControlWith( "One", "Two", "Three" )
	local back = views[3].navItem.backButton

	back:press()
	frame( ctrl, 100 )
	back:press()
	frame( ctrl, 100 )
	frame( ctrl, 1000 )

	assert_equal( "One,Two", stack( ctrl ) )
	assert_equal( "One,Two", barStack( ctrl ) )
end


--[[
a popped view can be pushed again: it gets a new nav item (it kept
the one the bar had removed, and the slide raised an error)
--]]
function test_pushPoppedViewAgain()
	local ctrl, views = newControlWith( "One", "Two" )
	local two = views[2]

	ctrl:popViewAnimated()
	frame( ctrl, 1000 )
	assert_nil( two.navItem )

	ctrl:pushView( two )
	frame( ctrl, 1000 )

	assert_equal( "One,Two", stack( ctrl ) )
	assert_equal( "One,Two", barStack( ctrl ) )
	assert_not_nil( two.navItem )
	assert_true( two.isVisible )
end


--[[
a view sits below the bar, top center, the size of what is left
--]]
function test_viewSize()
	local ctrl, views = newControlWith( "One" )
	local one = views[1]

	assert_equal( W, one.width )
	assert_equal( H-BAR_H, one.height )
	assert_equal( BAR_H, one.y )
	assert_equal( 0.5, one.anchorX )
	assert_equal( 0, one.anchorY )
end


--[[
a view which is a display group is placed, not sized (its width
and height were set, which scaled what it held)
--]]
function test_groupViewNotScaled()
	local ctrl = newControl()
	local one = newTableView( "One" )

	ctrl:pushView( one )
	frame( ctrl )

	assert_equal( 1, one.view.xScale )
	assert_equal( 1, one.view.yScale )
	assert_equal( BAR_H, one.view.y )
	assert_equal( ctrl, one.parent )

	ctrl.width, ctrl.height = 200, 300
	assert_equal( 1, one.view.xScale )
	assert_equal( 1, one.view.yScale )
end


--[[
the bar is as wide as the control from the start (it kept its
own default, the content width, until the control's width changed)
--]]
function test_barWidthAtCreation()
	local ctrl = dUI.newNavigationControl{ width=200, height=300 }
	controls[ #controls+1 ] = ctrl

	assert_equal( 200, ctrl._navBar.width )
end


--[[
a change of size reaches the bar and every view (a view got the
control's whole height, bar included)
--]]
function test_sizeChange()
	local ctrl, views = newControlWith( "One", "Two" )

	ctrl.width, ctrl.height = 200, 300

	assert_equal( 200, ctrl._navBar.width )
	for i, view in ipairs( views ) do
		assert_equal( 200, view.width )
		assert_equal( 300-BAR_H, view.height )
		assert_equal( BAR_H, view.y )
	end
end


--[[
a view's functions are called in order, with the stack already
changed when viewDidAppear runs
--]]
function test_viewFunctions()
	local ctrl = newControl()
	local one, two = newTableView( "One" ), newTableView( "Two" )
	local onTop
	two.viewDidAppear = function( self ) onTop = stack( ctrl ) end

	ctrl:pushView( one )
	frame( ctrl )
	assert_equal( "willBeAdded viewDidAppear", calls( one ) )

	ctrl:pushView( two )
	frame( ctrl, 100 )
	frame( ctrl, 1000 )
	assert_equal( "viewInMotion=true viewInMotion=false viewDidDisappear", calls( one ) )
	assert_equal( "willBeAdded viewInMotion=true viewInMotion=false", calls( two ) )
	assert_equal( "One,Two", onTop )

	ctrl:popViewAnimated()
	frame( ctrl, 100 )
	frame( ctrl, 1000 )
	assert_equal( "viewInMotion=true viewInMotion=false viewDidAppear", calls( one ) )
	assert_equal( "viewInMotion=true viewInMotion=false viewDidDisappear willBeRemoved", calls( two ) )
end


--[[
a slide which is cut short still tells its views that the motion
has ended
--]]
function test_viewInMotionEndsWhenCutShort()
	local ctrl = newControl()
	local one, two = newTableView( "One" ), newTableView( "Two" )
	ctrl:pushView( one )
	frame( ctrl )
	calls( one )

	ctrl:pushView( two )
	frame( ctrl, 100 )
	ctrl:pushView( newRectView( "Three" ), { wait=false } )

	assert_equal( "viewInMotion=true viewInMotion=false viewDidDisappear", calls( one ) )
end


--[[
a popped view is hidden and reported with REMOVED_VIEW
--]]
function test_removedViewEvent()
	local ctrl, views = newControlWith( "One", "Two" )
	local removed = {}
	ctrl:addEventListener( ctrl.EVENT, function( event )
		if event.type==ctrl.REMOVED_VIEW then removed[ #removed+1 ] = event.view.title end
	end )

	ctrl:popViewAnimated()
	frame( ctrl, 1000 )

	assert_equal( "Two", table.concat( removed, ',' ) )
	assert_false( views[2].isVisible )
end


--[[
a control removed during a slide stops it, removes its bar, and
tells each view (the bar was left on the screen)
--]]
function test_removeDuringSlide()
	local ctrl = newControl()
	local one, two = newTableView( "One" ), newTableView( "Two" )
	local bar = ctrl._navBar
	ctrl:pushView( one )
	frame( ctrl )
	ctrl:pushView( two )
	frame( ctrl, 100 )
	assert_not_nil( ctrl._enterFrame_f, "slide is running" )
	local three = newRectView( "Three" )
	ctrl:pushView( three ) -- waits, and is dropped
	calls( one ) calls( two )

	ctrl:removeSelf()
	three:removeSelf()

	assert_nil( ctrl._enterFrame_f )
	assert_equal( 0, #ctrl._pending )
	assert_nil( bar.view, "bar is removed" )
	assert_equal( "viewInMotion=false viewDidDisappear willBeRemoved", calls( one ) )
	assert_equal( "viewInMotion=false viewDidAppear willBeRemoved", calls( two ) )
end


--[[
a touch or a tap on the control stays with it: what a view doesn't
take doesn't reach what lies behind the control
--]]
function test_touchAndTapAreKept()
	local ctrl = newControlWith( "One" )
	local o = ctrl._primer

	assert_true( o.isHitTestable )
	assert_true( o:dispatchEvent{ name='touch', phase='began', target=o, x=0, y=0 } )
	assert_true( o:dispatchEvent{ name='tap', target=o, x=0, y=0, numTaps=1 } )
end


--[[
no globals are left behind ('params' by a pop, 'f' by a slide)
--]]
function test_noGlobals()
	local ctrl = newControlWith( "One" )
	local two = newTableView( "Two" )

	ctrl:pushView( two )
	frame( ctrl, 100 )
	frame( ctrl, 1000 )
	ctrl:popViewAnimated()
	frame( ctrl, 100 )
	frame( ctrl, 1000 )

	assert_nil( rawget( _G, 'params' ) )
	assert_nil( rawget( _G, 'f' ) )
end
