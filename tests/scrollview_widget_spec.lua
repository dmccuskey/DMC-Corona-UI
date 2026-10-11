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


--[[
the delegate hears about scrolling: willBeginScrolling, didScroll for
each move, didEndScrolling once both axes are at rest, each with the
position and the limit the content is at
--]]
function test_scrollDelegate()
	local calls, last = {}, nil
	local function note( name )
		return function( self, e ) calls[#calls+1] = name ; last = e end
	end
	local w = newScrollView{ delegate={
		willBeginScrolling=note( 'begin' ),
		didScroll=note( 'scroll' ),
		didEndScrolling=note( 'end' ),
	} }

	-- at once: one of each
	w:setContentPosition{ y=-100, time=0 }
	frame( w )
	assert_equal( 'begin,scroll,end', table.concat( calls, ',' ) )
	assert_equal( w, last.target )
	assert_equal( 0, last.x )
	assert_equal( -100, last.y )
	assert_equal( w.HIT_LEFT_LIMIT, last.horizontalLimit )
	assert_nil( last.verticalLimit )

	-- animated, on both axes: begins once, ends once
	calls = {}
	w:setContentPosition{ x=-100, y=-500, time=300 }
	frame( w, 100 )
	frame( w, 200 )
	assert_equal( 'begin', calls[1] )
	assert_equal( 'scroll', calls[#calls] )
	frame( w, 400 )
	assert_equal( 'end', calls[#calls] )
	local n = { begin=0, scroll=0, ['end']=0 }
	for _, name in ipairs( calls ) do n[name] = n[name] + 1 end
	assert_equal( 1, n.begin )
	assert_equal( 1, n['end'] )
	assert_gt( 3, n.scroll )
	assert_equal( -100, last.x )
	assert_equal( -500, last.y )
	assert_equal( w.HIT_RIGHT_LIMIT, last.horizontalLimit )
	assert_equal( w.HIT_BOTTOM_LIMIT, last.verticalLimit )

	-- back at the top
	w:setContentPosition{ x=-50, y=0, time=0 }
	frame( w )
	assert_nil( last.horizontalLimit )
	assert_equal( w.HIT_TOP_LIMIT, last.verticalLimit )

	-- a drag: begins with the first move, ends when the touch does
	calls = {}
	local axis = w._axisY
	local t = system.getTimer()
	axis:touch{ phase='began', time=t, value=200, start=200 }
	frame( w, 10 )
	axis:touch{ phase='moved', time=t+50, value=150, start=200 }
	frame( w, 60 )
	axis:touch{ phase='moved', time=t+100, value=120, start=200 }
	frame( w, 110 )
	assert_equal( 'begin', calls[1] )
	axis:touch{ phase='ended', time=t+600, value=120, start=200 }
	-- it may coast for a moment: run frames until it is at rest
	for ms=700, 4000, 100 do
		frame( w, ms )
		if calls[#calls]=='end' then break end
	end
	n = { begin=0, scroll=0, ['end']=0 }
	for _, name in ipairs( calls ) do n[name] = n[name] + 1 end
	assert_equal( 1, n.begin )
	assert_equal( 1, n['end'] )
	assert_equal( 'end', calls[#calls] )
	assert_gt( -200, last.y )

	-- a delegate without the methods, and none
	w.delegate = {}
	w:setContentPosition{ y=-100, time=0 }
	frame( w )
	w.delegate = nil
	w:setContentPosition{ y=-200, time=0 }
	frame( w )
	local _, y = w:getContentPosition()
	assert_equal( -200, y )
end


--[[
a tap on the scroll view stays with it: Solar2D sends 'tap' apart from 'touch',
and without a 'tap' listener of its own it reached what lies behind
--]]
function test_tapIsKept()
	local w = newScrollView()
	local o = w._rectBg
	assert_true( o:dispatchEvent{ name='tap', target=o, x=0, y=0, numTaps=1 } )
end


--======================================================--
-- Scroll Motion

-- run one frame of the widget's motion objects, at 'time'
local function frameAt( w, time )
	local e = { name='enterFrame', time=time }
	w._axisX:enterFrame( e )
	w._axisY:enterFrame( e )
	w._scaleMotion:enterFrame( e )
	commit( w )
end

-- drag an axis from 'from' to 'to' in three moves 16 ms apart and let go
-- 1 ms later, with the speed it has. returns the time the touch ended
local function flick( axis, t, from, to )
	axis:touch{ phase='began', time=t, value=from, start=from }
	for i = 1, 3 do
		axis:touch{ phase='moved', time=t+i*16, value=from+(to-from)*i/3, start=from }
	end
	axis:touch{ phase='ended', time=t+49, value=to, start=from }
	return t+49
end

-- run frames every 16 ms from 'from' for 'ms', and return the position
-- of the axis at each, and how long it took to come to rest
local function run( w, axis, from, ms )
	local list, rest = {}, nil
	for i = 16, ms, 16 do
		frameAt( w, from+i )
		list[ #list+1 ] = axis.value
		if rest==nil and axis:getState()==axis.STATE_AT_REST then rest = i end
	end
	return list, rest
end

-- the largest of a list, and where it is
local function peak( list )
	local max, index = list[1], 1
	for i, v in ipairs( list ) do
		if v > max then max, index = v, i end
	end
	return max, index
end


--[[
a drag past an edge: the content follows the finger by a little over
half at the edge and by less the further it goes, never further than
a third of the view, the same whichever way the finger got there;
back inside it follows the finger again
--]]
function test_dragPastEdge()
	local w = newScrollView()
	local axis = w._axisY
	local t = system.getTimer()
	-- 100 past the top of a view 300 high, which gives way by 100 at most
	local expected = 100*0.55*100 / ( 100*0.55 + 100 )

	axis:touch{ phase='began', time=t, value=100, start=100 }
	axis:touch{ phase='moved', time=t+50, value=200, start=100 }
	assert_equal( expected, axis.value, 0.01 )
	assert_lt( 50, axis.value, "less than half of the finger's travel" )

	-- there and back in steps, the first far past the view
	axis:touch{ phase='moved', time=t+60, value=5200, start=100 }
	assert_lt( 100, axis.value, "a third of the view at most" )
	assert_gt( 90, axis.value )
	axis:touch{ phase='moved', time=t+70, value=230, start=100 }
	axis:touch{ phase='moved', time=t+80, value=200, start=100 }
	assert_equal( expected, axis.value, 0.01 )
	axis:touch{ phase='moved', time=t+90, value=100, start=100 }
	assert_equal( 0, axis.value, 0.01 )
	axis:touch{ phase='moved', time=t+100, value=60, start=100 }
	assert_equal( -40, axis.value, 0.01 )
	axis:touch{ phase='cancelled', time=t+500, value=60, start=100 }

	-- the bottom, the same
	local w2 = newScrollView()
	axis = w2._axisY
	w2:setContentPosition{ y=-500, time=0 }
	frameAt( w2, t )
	axis:touch{ phase='began', time=t, value=200, start=200 }
	axis:touch{ phase='moved', time=t+50, value=100, start=200 }
	assert_equal( -500-expected, axis.value, 0.01 )
	axis:touch{ phase='cancelled', time=t+500, value=100, start=200 }

	-- without bounce the content stops at the edge
	local w3 = newScrollView{ bounceIsActive=false }
	axis = w3._axisY
	axis:touch{ phase='began', time=t, value=100, start=100 }
	axis:touch{ phase='moved', time=t+50, value=200, start=100 }
	assert_equal( 0, axis.value )
	axis:touch{ phase='moved', time=t+60, value=150, start=100 }
	assert_equal( -50, axis.value )
end


--[[
a flick which reaches an edge: one motion past it and back, without
a halt, which ends exactly on the edge. a faster one overruns it by
more and takes about as long
--]]
function test_bounceSpring()
	local function bounce( distance )
		local w = newScrollView()
		local axis = w._axisY
		local t = system.getTimer()
		w:setContentPosition{ y=-200, time=0 }
		frameAt( w, t )
		local ended = flick( axis, t, 100, 100+distance )
		local list, rest = run( w, axis, ended, 4000 )
		local max, index = peak( list )

		assert_gt( 0, max, "past the top" )
		assert_equal( 0, list[#list], 0, "ends on the edge" )
		assert_equal( axis.STATE_AT_REST, axis:getState() )
		for i = 2, #list do
			if i <= index then
				assert_gt( list[i-1], list[i], "on its way out, moving: frame "..i )
			elseif i*16 < rest then
				assert_lt( list[i-1], list[i], "on its way back, moving: frame "..i )
			else
				assert_equal( 0, list[i] )
			end
		end
		-- the time from the edge to rest
		local crossed
		for i, v in ipairs( list ) do
			if v > 0 then crossed = i*16 ; break end
		end
		return max, rest-crossed
	end

	local slow, slowTime = bounce( 30 )
	local fast, fastTime = bounce( 90 )
	assert_gt( slow+20, fast, "a faster flick goes further past the edge" )
	assert_gt( 400, slowTime )
	assert_lt( 1100, fastTime )
	assert_lt( 400, fastTime-slowTime, "about as long" )
end


--[[
let go of past an edge without speed, the content only comes back
--]]
function test_releasePastEdge()
	local w = newScrollView()
	local axis = w._axisY
	local t = system.getTimer()

	axis:touch{ phase='began', time=t, value=100, start=100 }
	axis:touch{ phase='moved', time=t+50, value=200, start=100 }
	-- held still, until the speed is gone
	for i = 1, 8 do frameAt( w, t+50+i*33 ) end
	local from = axis.value
	axis:touch{ phase='ended', time=t+320, value=200, start=100 }
	assert_equal( axis.STATE_RESTORE, axis:getState() )

	local list, rest = run( w, axis, t+320, 2000 )
	local last = from
	for i, v in ipairs( list ) do
		assert_gte( 0, v, "never past the edge on the way back: frame "..i )
		assert_lte( last, v, "always towards the edge: frame "..i )
		last = v
	end
	assert_equal( 0, list[#list] )
	assert_lt( 1000, rest )
end


--[[
without bounce a flick stops at the edge
--]]
function test_flickWithoutBounce()
	local w = newScrollView{ bounceIsActive=false }
	local axis = w._axisY
	local t = system.getTimer()
	w:setContentPosition{ y=-200, time=0 }
	frameAt( w, t )
	local ended = flick( axis, t, 100, 190 )
	local list = run( w, axis, ended, 2000 )
	assert_equal( 0, ( peak( list ) ) )
	assert_equal( 0, list[#list] )
	assert_equal( axis.STATE_AT_REST, axis:getState() )
end


--[[
a glide after a flick loses a constant part of its speed with each
millisecond (decelerationRate): its length depends on the speed of the
flick, and half of it is done after ln(2)/-ln(rate) milliseconds
--]]
function test_glide()
	local function glide( rate )
		local w = newScrollView{ scrollHeight=20000, decelerationRate=rate }
		local axis = w._axisY
		local t = system.getTimer()
		w:setContentPosition{ y=-10000, time=0 }
		frameAt( w, t )
		local ended = flick( axis, t, 200, 140 )
		local from, speed = axis.value, axis._velocity.value
		assert_equal( 60/49, speed, 0.001, "the speed of the touch" )
		assert_equal( axis.STATE_DECELERATE, axis:getState() )

		local k = -math.log( w.decelerationRate )
		frameAt( w, ended + math.log( 2 )/k )
		assert_equal( speed/k/2, from-axis.value, 1, "half way" )
		run( w, axis, ended + 400, 8000 )
		assert_equal( axis.STATE_AT_REST, axis:getState() )
		-- it stops once it is too slow to see, a little short
		assert_equal( speed/k, from-axis.value, 0.01/k + 1 )
		return from-axis.value
	end

	local w = newScrollView()
	assert_equal( 0.998, w.decelerationRate )
	assert_error( function() w.decelerationRate = 2 end )

	local normal = glide( nil )
	local fast = glide( 0.99 )
	assert_equal( 612, normal, 7 )
	assert_equal( 122, fast, 3 )
end


--[[
the speed of a touch: measured over its last moves, whatever the times
of the events (two at the same time raised a division by zero), and
limited
--]]
function test_touchSpeed()
	local w = newScrollView{ scrollHeight=20000 }
	local axis = w._axisY
	local t = system.getTimer()
	w:setContentPosition{ y=-10000, time=0 }
	frameAt( w, t )

	axis:touch{ phase='began', time=t, value=200, start=200 }
	axis:touch{ phase='moved', time=t+16, value=180, start=200 }
	axis:touch{ phase='moved', time=t+16, value=160, start=200 }
	axis:touch{ phase='moved', time=t+32, value=140, start=200 }
	axis:touch{ phase='ended', time=t+32, value=140, start=200 }
	assert_equal( 60/32, axis._velocity.value, 0.001 )
	assert_equal( -1, axis._velocity.vector )

	-- a new touch stops the glide, and starts without its speed
	frameAt( w, t+48 )
	axis:touch{ phase='began', time=t+50, value=200, start=200 }
	assert_equal( 0, axis._velocity.value )
	axis:touch{ phase='moved', time=t+66, value=1200, start=200 }
	assert_equal( axis.TOUCH_VELOCITY_LIMIT, axis._velocity.value )
	assert_equal( 1, axis._velocity.vector )
	-- a finger which rests loses its speed
	frameAt( w, t+300 )
	assert_equal( 0, axis._velocity.value )
	frameAt( w, t+1066 )
	axis:touch{ phase='ended', time=t+1100, value=1200, start=200 }
	assert_equal( axis.STATE_AT_REST, axis:getState() )
end


--======================================================--
-- Paging

-- a scroll view of four pages side by side (200 wide each)
local function newPagedView( params )
	params = params or {}
	params.scrollWidth = 800
	params.scrollHeight = 300
	if params.isPagingEnabled==nil then params.isPagingEnabled = true end
	return newScrollView( params )
end

-- drag the x axis through 'values' (the first is where the touch begins).
-- a flick ends at once, with its speed; otherwise the touch is held
-- still until the speed is gone. then run frames until the axis is at rest
local function drag( w, values, isFlick )
	local axis = w._axisX
	local t = system.getTimer()
	local start = values[1]
	local ms = 0

	axis:touch{ phase='began', time=t, value=start, start=start }
	for i = 2, #values do
		ms = ms + 16
		axis:touch{ phase='moved', time=t+ms, value=values[i], start=start }
	end
	if not isFlick then
		for i = 1, 6 do
			ms = ms + 33
			frame( w, ms )
		end
	end
	ms = ms + 1
	axis:touch{ phase='ended', time=t+ms, value=values[#values], start=start }
	for i = 1, 20 do
		frame( w, ms + i*50 )
	end
	return ( w:getContentPosition() )
end


--[[
with paging, a drag ends on the nearest page
--]]
function test_pagingDrag()
	local w = newPagedView()
	assert_true( w.isPagingEnabled )

	-- less than half a page: back
	assert_equal( 0, drag( w, { 150, 120, 90 } ) )
	-- more than half: the next page
	assert_equal( -200, drag( w, { 190, 130, 70 } ) )
	-- and back again
	assert_equal( 0, drag( w, { 10, 70, 130 } ) )
end


--[[
with paging, a flick goes to the next page in its direction,
however short it is, and one page only, however long
--]]
function test_pagingFlick()
	local w = newPagedView()

	assert_equal( -200, drag( w, { 150, 130, 110 }, true ) )
	assert_equal( -400, drag( w, { 150, 130, 110 }, true ) )
	assert_equal( -200, drag( w, { 50, 70, 90 }, true ) )
	-- longer than a page
	assert_equal( -400, drag( w, { 190, 90, -10, -110 }, true ) )

	-- a drag one way which ends in a flick back stays on its page
	assert_equal( -400, drag( w, { 150, 110, 70, 85, 100, 115, 130 }, true ) )
end


--[[
with paging, the first and the last page are the scroll limits
--]]
function test_pagingLimits()
	local w = newPagedView()

	-- before the first
	assert_equal( 0, drag( w, { 50, 70, 90 }, true ) )
	assert_equal( 0, drag( w, { 50, 90, 130 } ) )

	w:setContentPosition{ x=-600, time=0 }
	frame( w )
	-- after the last
	assert_equal( -600, drag( w, { 150, 130, 110 }, true ) )
	assert_equal( -600, drag( w, { 150, 110, 70 } ) )

	-- a last page which is shorter than the view ends at the scroll limit
	w.scrollWidth = 700
	frame( w )
	frame( w )
	assert_equal( -500, drag( w, { 150, 130, 110 }, true ) )
	assert_equal( -400, drag( w, { 50, 70, 90 }, true ) )
end


--[[
paging is off unless asked for, and can be changed later
--]]
function test_pagingOff()
	local w = newPagedView{ isPagingEnabled=false }
	assert_false( w.isPagingEnabled )

	assert_equal( -60, drag( w, { 150, 120, 90 } ) )

	w.isPagingEnabled = true
	assert_equal( -200, drag( w, { 150, 110, 70 } ) )
	assert_error( function() w.isPagingEnabled = 'yes' end )
end
