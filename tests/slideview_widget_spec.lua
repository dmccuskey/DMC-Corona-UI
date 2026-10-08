--====================================================================--
-- Test: SlideView Widget
--====================================================================--

module(..., package.seeall)


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.1.0"



--====================================================================--
--== Imports


local dUI = require 'lib.dmc_ui'



--====================================================================--
--== Support Functions


local W, H = 200, 300 -- slide size

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
	commit( w )
	w._axisX:enterFrame( e )
	w._axisY:enterFrame( e )
	commit( w )
end

-- a delegate for 'count' slides, which records its calls
local function newDelegate( count )
	return {
		count=count,
		rendered=0,
		unrendered=0,
		shown={},
		selected={},
		numberOfSlides=function( self, slideview )
			return self.count
		end,
		onSlideRender=function( self, event )
			self.rendered = self.rendered + 1
			self.lastRender = event
			event.data.label = "slide " .. event.index
		end,
		onSlideUnrender=function( self, event )
			self.unrendered = self.unrendered + 1
			self.lastUnrender = event
		end,
		didShowSlide=function( self, event )
			self.shown[ #self.shown+1 ] = event.index
			self.lastShown = event
		end,
		didSelectSlide=function( self, event )
			self.selected[ #self.selected+1 ] = event.index
		end,
	}
end

-- the style specs load the base styles with their test defaults
-- (anchorX 101, ...): give each slide view usable values.
local function newSlideView( count, params )
	params = params or {}
	if params.width==nil then params.width = W end
	if params.height==nil then params.height = H end
	if params.delegate==nil then params.delegate = newDelegate( count ) end
	params.style = {
		debugOn=false, anchorX=0, anchorY=0, fillColor={ 1, 1, 1, 1 },
	}
	local w = commit( track( dUI.newSlideView( params ) ) )
	frame( w )
	if count then
		w:reloadData()
		frame( w )
	end
	return w, params.delegate
end

-- the indexes of the rendered slides, in order, as a string: "1 2 3"
local function rendered( w )
	local list = {}
	for index in pairs( w._renderedSlides ) do list[ #list+1 ] = index end
	table.sort( list )
	return table.concat( list, ' ' )
end

-- run frames until a move has ended
local function settle( w, from )
	from = from or 0
	for i = 1, 20 do
		frame( w, from + i*50 )
	end
end

-- drag the slides through 'values' (the first is where the touch begins).
-- a flick ends at once, with its speed; otherwise the touch is held
-- still until the speed is gone. then run frames until at rest
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
	settle( w, ms )
	return ( w:getContentPosition() )
end

-- a gesture event, as the pan gesture of the widget sends it
local function gesture( w, phase )
	local g = w._panGesture
	w:_gestureEvent_handler{
		name=g.EVENT, type=g.GESTURE, target=g, gesture='pan', phase=phase,
		time=system.getTimer(), x=100, y=100, xStart=100, yStart=100,
	}
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
--== Test SlideView


--[[
a slide view without slides, and one without a delegate
--]]
function test_empty()
	local w = newSlideView( nil )
	w.delegate = nil
	assert_equal( 0, w.index )
	assert_equal( 0, w.numberOfSlides )
	assert_error( function() w:reloadData() end, "no delegate" )
	assert_error( function() w:gotoSlide( 1 ) end, "no slide" )
	-- nothing to do, no error
	w:nextSlide()
	w:previousSlide()

	local w2, d = newSlideView( 0 )
	assert_equal( 0, w2.index )
	assert_equal( 0, d.rendered )
	assert_equal( 0, #d.shown )
end


--[[
reloadData() shows the first slide; the one showing
and the ones next to it are made, each the size of the view
--]]
function test_reloadData()
	local w, d = newSlideView( 5 )

	assert_equal( 5, w.numberOfSlides )
	assert_equal( 1, w.index )
	assert_equal( "1 2", rendered( w ) )
	assert_equal( 2, d.rendered )
	assert_equal( 0, d.unrendered )
	assert_equal( 1, #d.shown, "told once" )
	assert_equal( 1, d.shown[1] )
	assert_equal( w, d.lastShown.target )
	assert_equal( w:getSlideAt( 1 ), d.lastShown.view )
	assert_equal( "slide 1", d.lastShown.data.label )

	assert_equal( W, d.lastRender.width )
	assert_equal( H, d.lastRender.height )
	assert_equal( 0, w:getSlideAt( 1 ).x )
	assert_equal( W, w:getSlideAt( 2 ).x )
	assert_nil( w:getSlideAt( 3 ) )
	assert_equal( 5*W, w.scrollWidth )

	-- always a slide view
	assert_true( w.isPagingEnabled )
	assert_false( w.verticalScrollEnabled )
	w.isPagingEnabled = false
	w.verticalScrollEnabled = true
	w.scrollWidth = 50
	frame( w )
	assert_true( w.isPagingEnabled )
	assert_false( w.verticalScrollEnabled )
	assert_equal( 5*W, w.scrollWidth )
end


--[[
reloadData() right after creation, before the first frame: the slides are made once
--]]
function test_reloadBeforeFirstFrame()
	local d = newDelegate( 3 )
	local w = track( dUI.newSlideView{
		width=W, height=H, delegate=d,
		style={ debugOn=false, anchorX=0, anchorY=0, fillColor={ 1, 1, 1, 1 } },
	})
	w:reloadData()
	frame( w )
	frame( w )
	assert_equal( "1 2", rendered( w ) )
	assert_equal( 2, d.rendered )
	assert_equal( 0, d.unrendered )
	assert_equal( W, d.lastRender.width )
	assert_equal( 1, w.index )
end


--[[
gotoSlide() moves at once or over time; the index is the slide
asked for from the call on, the delegate hears when it shows
--]]
function test_gotoSlide()
	local w, d = newSlideView( 5 )
	local done = 0
	local onComplete = function() done = done + 1 end

	-- at once
	w:gotoSlide( 3, { animate=false, onComplete=onComplete } )
	assert_equal( 3, w.index )
	frame( w )
	assert_equal( -2*W, ( w:getContentPosition() ) )
	assert_equal( "2 3 4", rendered( w ) )
	assert_equal( 1, done )
	assert_equal( 3, d.shown[ #d.shown ] )
	assert_equal( 2, #d.shown )

	-- over time
	w:gotoSlide( 5, { time=300, onComplete=onComplete } )
	assert_equal( 5, w.index )
	frame( w, 150 )
	local x = w:getContentPosition()
	assert_gt( -4*W, x, "on its way" )
	assert_lt( -2*W, x, "on its way" )
	assert_equal( 2, #d.shown, "not yet" )
	frame( w, 301 )
	assert_equal( -4*W, ( w:getContentPosition() ) )
	assert_equal( "4 5", rendered( w ) )
	assert_equal( 2, done )
	assert_equal( 5, d.shown[ #d.shown ] )

	-- the slide already showing
	w:gotoSlide( 5, { onComplete=onComplete } )
	assert_equal( 3, done )
	frame( w )
	assert_equal( 3, #d.shown, "no change" )

	-- by default, over transitionTime
	w.transitionTime = 200
	w:gotoSlide( 1 )
	frame( w, 100 )
	assert_lt( 0, ( w:getContentPosition() ) )
	frame( w, 201 )
	assert_equal( 0, ( w:getContentPosition() ) )
	assert_equal( 1, w.index )

	assert_error( function() w:gotoSlide( 6 ) end )
	assert_error( function() w:gotoSlide( 0 ) end )
	assert_error( function() w:gotoSlide( 'first' ) end )
end


--[[
nextSlide() and previousSlide() stop at the ends;
two calls in a row move two slides
--]]
function test_nextPrevious()
	local w, d = newSlideView( 3 )

	w:previousSlide()
	assert_equal( 1, w.index )

	w:nextSlide{ animate=false }
	w:nextSlide{ animate=false }
	assert_equal( 3, w.index )
	frame( w )
	assert_equal( -2*W, ( w:getContentPosition() ) )

	w:nextSlide()
	assert_equal( 3, w.index )

	w:previousSlide{ animate=false }
	frame( w )
	assert_equal( 2, w.index )
	assert_equal( -W, ( w:getContentPosition() ) )
	assert_equal( "1 2 3", rendered( w ) )
end


--[[
a drag ends on the nearest slide, a flick on the next;
the delegate hears of a new slide once it is at rest
--]]
function test_dragAndFlick()
	local w, d = newSlideView( 4 )

	-- not far enough
	assert_equal( 0, drag( w, { 150, 120, 90 } ) )
	assert_equal( 1, w.index )
	assert_equal( 1, #d.shown )

	-- far enough
	assert_equal( -W, drag( w, { 190, 130, 70 } ) )
	assert_equal( 2, w.index )
	assert_equal( 2, d.shown[ #d.shown ] )
	assert_equal( "1 2 3", rendered( w ) )

	-- a flick
	assert_equal( -2*W, drag( w, { 150, 130, 110 }, true ) )
	assert_equal( 3, w.index )
	assert_equal( "2 3 4", rendered( w ) )
	assert_equal( -3*W, drag( w, { 150, 130, 110 }, true ) )
	assert_equal( 4, w.index )

	-- the last one stays
	assert_equal( -3*W, drag( w, { 150, 130, 110 }, true ) )
	assert_equal( 4, w.index )
	assert_equal( 4, #d.shown )

	-- and back
	assert_equal( -2*W, drag( w, { 50, 70, 90 }, true ) )
	assert_equal( 3, w.index )
end


--[[
slides which leave the view are removed, and the delegate hears of it
--]]
function test_unrender()
	local w, d = newSlideView( 6 )
	assert_equal( 0, d.unrendered )

	w:gotoSlide( 5, { animate=false } )
	frame( w )
	assert_equal( "4 5 6", rendered( w ) )
	assert_equal( 2, d.unrendered )
	assert_nil( w:getSlideAt( 1 ) )

	-- the unrender method is optional
	d.onSlideUnrender = nil
	w:gotoSlide( 1, { animate=false } )
	frame( w )
	assert_equal( "1 2", rendered( w ) )
end


--[[
reloadData() with other slides keeps the slide showing if it can
--]]
function test_reloadKeepsIndex()
	local w, d = newSlideView( 5 )
	w:gotoSlide( 4, { animate=false } )
	frame( w )

	d.count = 8
	d.rendered = 0
	w:reloadData()
	frame( w )
	assert_equal( 4, w.index )
	assert_equal( "3 4 5", rendered( w ) )
	assert_equal( 3, d.rendered, "made again" )
	assert_equal( 4, d.shown[ #d.shown ], "told again: the slides are new" )
	assert_equal( 8*W, w.scrollWidth )

	-- fewer: the last one
	d.count = 2
	w:reloadData()
	assert_equal( 2, w.index )
	frame( w )
	frame( w )
	assert_equal( -W, ( w:getContentPosition() ) )
	assert_equal( "1 2", rendered( w ) )
	assert_equal( 2*W, w.scrollWidth )

	-- none
	d.count = 0
	w:reloadData()
	frame( w )
	frame( w )
	assert_equal( 0, w.index )
	assert_equal( "", rendered( w ) )
	assert_equal( 0, ( w:getContentPosition() ) )
end


--[[
a new size: the slides are made again in the new size,
and the slide showing stays
--]]
function test_resize()
	local w, d = newSlideView( 4 )
	w:gotoSlide( 3, { animate=false } )
	frame( w )

	d.rendered = 0
	w.width = 300
	w.height = 400
	frame( w )
	frame( w )
	assert_equal( 3, w.index )
	assert_equal( -600, ( w:getContentPosition() ) )
	assert_equal( "2 3 4", rendered( w ) )
	assert_equal( 3, d.rendered )
	assert_equal( 300, d.lastRender.width )
	assert_equal( 400, d.lastRender.height )
	assert_equal( 600, w:getSlideAt( 3 ).x )
	assert_equal( 1200, w.scrollWidth )

	-- and pages by the new width
	assert_equal( -900, drag( w, { 250, 220, 190 }, true ) )
	assert_equal( 4, w.index )
end


--[[
a tap which nothing in the slide took selects the slide, and stays with the widget
--]]
function test_tapSelects()
	local w, d = newSlideView( 3 )
	local o = w._rectBg

	assert_true( o:dispatchEvent{ name='tap', target=o, x=0, y=0, numTaps=1 } )
	assert_equal( 1, #d.selected )
	assert_equal( 1, d.selected[1] )

	w:gotoSlide( 3, { animate=false } )
	frame( w )
	o:dispatchEvent{ name='tap', target=o, x=0, y=0, numTaps=1 }
	assert_equal( 3, d.selected[2] )

	-- the method is optional
	d.didSelectSlide = nil
	assert_true( o:dispatchEvent{ name='tap', target=o, x=0, y=0, numTaps=1 } )
end


--[[
the auto-advance: the next slide each time, the first after the last;
it waits while a finger is down
--]]
function test_autoAdvance()
	local w, d = newSlideView( 3 )
	assert_false( w.isAutoAdvancing )
	assert_nil( w._advance_timer )
	assert_error( function() w:startAutoAdvance() end, "no time" )

	w:startAutoAdvance( 5000 )
	assert_true( w.isAutoAdvancing )
	assert_equal( 5000, w.autoAdvanceTime )
	assert_not_nil( w._advance_timer )

	-- what the timer calls
	w:_advance()
	assert_equal( 2, w.index )
	settle( w )
	w:_advance()
	settle( w )
	assert_equal( 3, w.index )
	assert_equal( -2*W, ( w:getContentPosition() ) )
	w:_advance()
	assert_equal( 1, w.index )
	settle( w )
	assert_equal( 0, ( w:getContentPosition() ) )

	-- a finger down: no timer, and it starts again after
	gesture( w, 'began' )
	assert_nil( w._advance_timer )
	assert_true( w.isAutoAdvancing )
	gesture( w, 'changed' )
	assert_nil( w._advance_timer )
	gesture( w, 'ended' )
	assert_not_nil( w._advance_timer )
	settle( w )

	w:stopAutoAdvance()
	assert_false( w.isAutoAdvancing )
	assert_nil( w._advance_timer )

	-- a time of zero stops it too
	w:startAutoAdvance()
	assert_not_nil( w._advance_timer )
	w.autoAdvanceTime = 0
	assert_false( w.isAutoAdvancing )
	assert_nil( w._advance_timer )
end


--[[
the autoAdvanceTime option starts the advance; removal stops its timer
--]]
function test_autoAdvanceOption()
	local w = newSlideView( 3, { autoAdvanceTime=4000 } )
	assert_true( w.isAutoAdvancing )
	assert_not_nil( w._advance_timer )

	-- one slide: nothing to advance to
	local w2, d2 = newSlideView( 1, { autoAdvanceTime=4000 } )
	w2:_advance()
	assert_equal( 1, w2.index )

	w:removeSelf()
	assert_nil( w._advance_timer )
end


--[[
removal, at rest and during a move, takes the slides with it
--]]
function test_remove()
	local w, d = newSlideView( 4 )
	w:removeSelf()
	assert_equal( 2, d.unrendered )

	local w2, d2 = newSlideView( 4 )
	w2:gotoSlide( 3 )
	frame( w2, 100 )
	w2:removeSelf()
	assert_equal( d2.rendered, d2.unrendered )
end


--[[
the delegate also gets the ScrollView's scroll methods,
with the slides for the new position in place
--]]
function test_scrollDelegate()
	local w, d = newSlideView( 4 )
	local calls = {}
	d.willBeginScrolling = function() calls[ #calls+1 ] = 'begin' end
	d.didScroll = function( self, e ) self.inScroll = rendered( w ) end
	d.didEndScrolling = function() calls[ #calls+1 ] = 'end' end

	w:gotoSlide( 3, { time=200 } )
	frame( w, 100 )
	frame( w, 201 )
	frame( w, 250 )
	assert_equal( 'begin', calls[1] )
	assert_equal( 'end', calls[ #calls ] )
	assert_equal( "2 3 4", d.inScroll )
end
