--====================================================================--
-- Test: ScrollView Widget
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

-- run one frame of the widget's motion objects, 'ms' from now
-- (they move on enterFrame; a test doesn't wait for frames)
local function frame( w, ms )
	local e = { name='enterFrame', time=system.getTimer()+( ms or 0 ) }
	w._axisX:enterFrame( e )
	w._axisY:enterFrame( e )
	w._scaleMotion:enterFrame( e )
	commit( w )
end

-- the style specs load the base styles with their test defaults
-- (anchorX 101, ...): give each scroll view usable values
local function newScrollView( params )
	params = params or {}
	if params.width==nil then params.width = 200 end
	if params.height==nil then params.height = 300 end
	if params.scrollWidth==nil then params.scrollWidth = 300 end
	if params.scrollHeight==nil then params.scrollHeight = 800 end
	params.style = {
		debugOn=false, anchorX=0, anchorY=0, fillColor={ 1, 1, 1, 1 },
	}
	local w = commit( track( dUI.newScrollView( params ) ) )
	frame( w )
	return w
end

-- a scroll view which can zoom: a view to zoom, and limits
local function newZoomView( calls )
	local view = display.newGroup()
	local w = newScrollView{
		delegate={
			getViewForZoom=function() return view end,
			willBeginZooming=function() calls.began = ( calls.began or 0 ) + 1 end,
			didEndZooming=function() calls.ended = ( calls.ended or 0 ) + 1 end,
		}
	}
	w.scroller:insertItem( view )
	w.minimumZoom = 0.5
	w.maximumZoom = 2
	return w, view
end



--====================================================================--
--== Module Testing
--====================================================================--


function setup()
	widgets = {}
end

function teardown()
	for _, w in ipairs( widgets ) do
		if w.view then w:removeSelf() end
	end
	widgets = nil
end



--====================================================================--
--== Test ScrollView


--[[
setContentPosition() scrolls to a position, animated or not, wherever
the content is (animated, it moved by 'current + position')
--]]
function test_setContentPosition()
	local w = newScrollView()
	local x, y

	w:setContentPosition{ y=-100, time=0 }
	frame( w )
	x, y = w:getContentPosition()
	assert_equal( 0, x )
	assert_equal( -100, y )
	assert_equal( -100, w.scroller.y )

	local n = 0
	w:setContentPosition{ y=-200, time=300, onComplete=function() n = n+1 end }
	frame( w, 150 )
	x, y = w:getContentPosition()
	assert_true( y < -100 and y > -200, "half way is between the two" )
	assert_equal( 0, n )
	frame( w, 301 )
	x, y = w:getContentPosition()
	assert_equal( -200, y )
	assert_equal( -200, w.scroller.y )
	assert_equal( 1, n )

	-- both axes, one onComplete
	w:setContentPosition{ x=-50, y=-100, time=300, onComplete=function() n = n+1 end }
	frame( w, 301 )
	x, y = w:getContentPosition()
	assert_equal( -50, x )
	assert_equal( -100, y )
	assert_equal( 2, n )
end


--[[
a new width or height reaches the scroll limits and the mask,
and the scroll area is never smaller than the view
--]]
function test_resize()
	local w = newScrollView{ autoMask=true }
	w.width, w.height = 250, 200
	commit( w )
	assert_equal( 250, w._rectBg.width )
	assert_equal( 250, w.view.width, "mask" )
	assert_equal( 200, w.view.height, "mask" )
	assert_equal( 250, w._axisX.length )
	assert_equal( 200, w._axisY.length )

	w.width = 400
	commit( w )
	assert_equal( 400, w.scrollWidth )
	assert_equal( 400, w.scroller.width )
end


--[[
at rest, the content comes back inside the limits when the
scroll area or the view changes size, or an offset moves a limit
--]]
function test_positionFollowsSize()
	local w = newScrollView()
	local x, y

	w:setContentPosition{ y=-500, time=0 }
	frame( w )
	w.scrollHeight = 400
	commit( w )
	frame( w )
	x, y = w:getContentPosition()
	assert_equal( -100, y, "300 high, 400 of content" )
	assert_equal( -100, w.scroller.y )

	w.height = 350
	commit( w )
	frame( w )
	x, y = w:getContentPosition()
	assert_equal( -50, y )

	-- and when an offset moves a limit
	w.lowerVerticalOffset = -20
	frame( w )
	x, y = w:getContentPosition()
	assert_equal( -30, y )
	w:setContentPosition{ y=0, time=0 }
	frame( w )
	w.upperVerticalOffset = -10
	frame( w )
	x, y = w:getContentPosition()
	assert_equal( -10, y )
end


--[[
setZoomScale() without animation reaches the view and the scroll area
--]]
function test_setZoomScaleNow()
	local calls = {}
	local w, view = newZoomView( calls )

	w:setZoomScale( 2, { time=0 } )
	frame( w )
	assert_equal( 2, w.zoomScale )
	assert_equal( 2, view.xScale )
	assert_equal( 2, view.yScale )
	assert_equal( 600, w.scrollWidth )
	assert_equal( 1600, w.scroller.height )
	assert_equal( 1, calls.began )
	assert_equal( 1, calls.ended )
end


--[[
minimumZoom and maximumZoom can be constructor options
--]]
function test_zoomOptions()
	local view = display.newGroup()
	local w = newScrollView{
		minimumZoom=0.5, maximumZoom=2,
		delegate={ getViewForZoom=function() return view end },
	}
	w.scroller:insertItem( view )
	assert_equal( 0.5, w.minimumZoom )
	assert_equal( 2, w.maximumZoom )

	w:setZoomScale( 2, { time=0 } )
	frame( w )
	assert_equal( 2, w.zoomScale )
	assert_equal( 2, view.yScale )
end


--[[
an animated zoom ends on the scale asked for, on both axes, with the
content inside the limits (zoomed out, it is centered; back in, at 0)
--]]
function test_setZoomScaleAnimated()
	local calls = {}
	local w, view = newZoomView( calls )
	local x, y

	w:setZoomScale( 0.5, { time=100 } )
	frame( w, 50 )
	assert_true( view.xScale < 1 and view.xScale > 0.5 )
	frame( w, 101 )
	frame( w, 102 )
	assert_equal( 0.5, view.xScale )
	assert_equal( 0.5, view.yScale )
	x, y = w:getContentPosition()
	assert_equal( 25, x, "150 of content centered in 200" )

	w:setZoomScale( 1, { time=100 } )
	frame( w, 50 )
	frame( w, 101 )
	frame( w, 102 )
	assert_equal( 1, view.yScale )
	x, y = w:getContentPosition()
	assert_equal( 0, x )
	assert_equal( 2, calls.ended )
end


--[[
no alignment on an axis: content smaller than the view stays where it
is put (a touch raised an error)
--]]
function test_noAutoAlign()
	local calls = {}
	local w, view = newZoomView( calls )
	w.horizontalAxisAutoAlign = nil
	w:setZoomScale( 0.5, { time=0 } )
	frame( w )

	local axis = w._axisX
	local t = system.getTimer()
	axis:touch{ phase='began', time=t, value=100, start=100 }
	axis:touch{ phase='moved', time=t+50, value=120, start=100 }
	axis:touch{ phase='ended', time=t+400, value=120, start=100 }
	frame( w, 500 )
	local x = w:getContentPosition()
	assert_equal( 'number', type( x ) )
end


--[[
debugOn changes reach the touch area
--]]
function test_debugOn()
	local w = newScrollView()
	assert_equal( 1, w._rectBg.fill.a )
	w.style.debugOn = true
	commit( w )
	assert_lt( 0.5, w._rectBg.fill.a, "debug tint" )
	w.style.debugOn = false
	commit( w )
	assert_equal( 1, w._rectBg.fill.a )
end


--[[
a scroll view removed while its content moves stops moving
(the next frame raised an error)
--]]
function test_removeWhileMoving()
	local calls = {}
	local w = newZoomView( calls )
	local axis, scale = w._axisY, w._scaleMotion

	w:setContentPosition{ y=-300, time=500 }
	w:setZoomScale( 2, { time=500 } )
	frame( w, 100 )
	w:removeSelf()

	local e = { name='enterFrame', time=system.getTimer()+200 }
	axis:enterFrame( e )
	scale:enterFrame( e )
	assert_nil( axis._enterFrameIterator )
	assert_nil( scale._enterFrameIterator )
end



--====================================================================--
--== Test Scroll Indicators


--[[
an indicator shows while its axis scrolls, sized and placed from the
content, and is let go when the content stops
--]]
function test_indicatorFollowsScroll()
	local w = newScrollView()
	local x, y = w._indicators.x, w._indicators.y
	assert_true( x.canShow, "300 of content in 200" )
	assert_true( y.canShow )
	assert_false( y.isShown, "hidden at rest" )
	assert_equal( 0, y.view.alpha )

	w:setContentPosition{ y=-500, time=300 }
	frame( w, 150 )
	assert_true( y.isShown )
	assert_equal( 1, y.view.alpha )
	assert_false( x.isShown, "the other axis didn't move" )

	frame( w, 301 )
	assert_false( y.isShown, "fading" )
	-- track: 300 less a margin of 3 at each end; bar: its 300/800
	assert_equal( 294*300/800, y.view.path.height, 0.01 )
	assert_equal( 197-3, y.view.x )
	assert_equal( 3+294-294*300/800, y.view.y, 0.01, "at the end of its track" )

	w:setContentPosition{ y=-250, time=0 }
	frame( w )
	assert_equal( 3+(294-294*300/800)/2, y.view.y, 0.01, "half way" )
end


--[[
a drag which ends without speed lets the indicator go too
(the axis then comes to rest outside of a frame)
--]]
function test_indicatorAfterDrag()
	local w = newScrollView()
	local y = w._indicators.y
	local axis = w._axisY
	local t = system.getTimer()

	axis:touch{ phase='began', time=t, value=200, start=200 }
	axis:touch{ phase='moved', time=t+50, value=150, start=200 }
	frame( w, 60 )
	assert_true( y.isShown )
	-- held still, until the speed is gone
	for i = 1, 6 do frame( w, 60+i*33 ) end
	assert_true( y.isShown, "still down" )
	axis:touch{ phase='ended', time=t+400, value=150, start=200 }
	assert_false( y.isShown )
	local _, pos = w:getContentPosition()
	assert_equal( -50, pos )
end


--[[
pulled past an edge, the bar is squeezed against it
--]]
function test_indicatorInBounce()
	local w = newScrollView()
	local y = w._indicators.y
	local axis = w._axisY
	local t = system.getTimer()

	axis:touch{ phase='began', time=t, value=100, start=100 }
	axis:touch{ phase='moved', time=t+50, value=160, start=100 }
	frame( w, 60 )
	local _, pos = w:getContentPosition()
	assert_gt( 0, pos, "past the top" )
	assert_equal( 3, y.view.y )
	assert_equal( 294*300/800 - pos, y.view.path.height, 0.01 )
end


--[[
no indicator on an axis which is switched off, whose content fits,
or whose indicator is turned off, as an option or later
--]]
function test_indicatorCanShow()
	local w = newScrollView{ scrollWidth=200, showVerticalScrollIndicator=false }
	local x, y = w._indicators.x, w._indicators.y
	assert_false( x.canShow, "content fits" )
	assert_false( y.canShow, "option" )
	assert_false( w.showVerticalScrollIndicator )

	w.showVerticalScrollIndicator = true
	assert_true( y.canShow )
	w:flashScrollIndicators()
	assert_equal( 1, y.view.alpha )
	assert_equal( 0, x.view.alpha )
	assert_false( y.isShown, "on its way out" )

	w.verticalScrollEnabled = false
	assert_false( y.canShow )
	assert_equal( 0, y.view.alpha, "hidden at once" )
	w.verticalScrollEnabled = true
	assert_true( y.canShow )

	w.scrollHeight = 300
	commit( w )
	assert_false( y.canShow, "content fits now" )
end


--[[
the track leaves out the offsets, and the color comes from the style
--]]
function test_indicatorOffsetsAndColor()
	local w = newScrollView()
	local y = w._indicators.y
	w.upperVerticalOffset = 50
	w.lowerVerticalOffset = 20
	w:setContentPosition{ y=50, time=0 }
	frame( w )
	assert_equal( 53, y.view.y )
	assert_equal( (300-70-6)*300/800, y.view.path.height, 0.01 )

	w.style.indicatorColor = { 1, 0, 0, 1 }
	commit( w )
	local fill = y.view.fill
	assert_equal( 1, fill.r )
	assert_equal( 0, fill.g )
end
