--====================================================================--
-- Test: PageIndicator Widget
--====================================================================--

module(..., package.seeall)


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.1.0"



--====================================================================--
--== Imports


local dUI = require 'lib.dmc_ui'



--====================================================================--
--== Support Functions


-- dot size, the space between two dots, the margins
local SIZE, SPACE, MX, MY = 10, 6, 5, 4

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

-- a delegate which records its calls
local function newDelegate()
	return {
		changes={},
		didChangePage=function( self, event )
			self.changes[ #self.changes+1 ] = event.page
			self.last = event
		end,
	}
end

-- the style specs load the base styles with their test defaults
-- (anchorX 101, ...): give each page indicator usable values.
local function newStyle()
	return {
		debugOn=false, width=0, height=0, anchorX=0.5, anchorY=0.5,
		dotColor={ 0.2, 0.2, 0.2, 1 }, currentDotColor={ 1, 1, 1, 1 },
		dotSize=SIZE, dotSpacing=SPACE, marginX=MX, marginY=MY,
	}
end

local function newPageIndicator( params )
	params = params or {}
	if params.delegate==nil then params.delegate = newDelegate() end
	if params.style==nil then params.style = newStyle() end
	local w = track( dUI.newPageIndicator( params ) )
	w.x, w.y = 150, 200
	return commit( w ), params.delegate
end

-- the x of each dot, as a string: "-16 0 16"
local function dotsX( w )
	local list = {}
	for i, o in ipairs( w._dots ) do list[i] = tostring( o.x ) end
	return table.concat( list, ' ' )
end

-- which dot has the color of the current page (their red: 1, the others 0.2)
local function litDots( w )
	local list = {}
	for i, o in ipairs( w._dots ) do
		if o.fill.r > 0.9 then list[ #list+1 ] = tostring( i ) end
	end
	return table.concat( list, ' ' )
end

-- a touch or a tap on the widget's touch area, 'dx' from its middle.
-- returns true if the widget kept it
local function send( w, name, dx )
	local hit = w._rctHit
	local x, y = hit:localToContent( dx or 0, 0 )
	return hit:dispatchEvent{
		name=name, phase='ended', target=hit, x=x, y=y, xStart=x, yStart=y, numTaps=1,
	}
end

local function tap( w, dx )
	local kept = send( w, 'tap', dx )
	commit( w )
	return kept
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
--== Test PageIndicator


--[[
without options there are no pages: no dots, nothing to tap
--]]
function test_empty()
	local w, d = newPageIndicator()

	assert_equal( 0, w.numberOfPages )
	assert_equal( 1, w.currentPage )
	assert_false( w.hidesForSinglePage )
	assert_false( w.isHidden )
	assert_equal( 0, #w._dots )
	assert_equal( 2*MX, w.width, "only the margins" )
	assert_equal( SIZE+2*MY, w.height )

	assert_true( tap( w, -3 ) )
	assert_true( tap( w, 3 ) )
	assert_equal( 0, #d.changes )
	assert_equal( 1, w.currentPage )

	-- the current page has nowhere to go
	w.currentPage = 4
	assert_equal( 1, w.currentPage )
end


--[[
a dot for each page, in a row around the widget's position;
the widget is the size of the row and its margins
--]]
function test_dots()
	local w = newPageIndicator{ numberOfPages=3 }

	assert_equal( 3, w.numberOfPages )
	assert_equal( 3, #w._dots )
	assert_equal( 3*SIZE + 2*SPACE + 2*MX, w.width )
	assert_equal( SIZE + 2*MY, w.height )
	assert_equal( "-16 0 16", dotsX( w ) )
	assert_equal( 0, w._dots[1].y )
	assert_equal( SIZE, w._dots[1].width )

	-- the touch area is the widget
	local hit = w._rctHit
	assert_equal( w.width, hit.width )
	assert_equal( w.height, hit.height )
	assert_equal( 0, hit.x )
	assert_equal( 0, hit.y )

	assert_equal( 150, w.view.x )
	assert_equal( 200, w.view.y )

	-- more pages, fewer pages
	w.numberOfPages = 4
	commit( w )
	assert_equal( 4, #w._dots )
	assert_equal( "-24 -8 8 24", dotsX( w ) )
	assert_equal( w.width, hit.width )

	w.numberOfPages = 1
	commit( w )
	assert_equal( 1, #w._dots )
	assert_equal( "0", dotsX( w ) )
	assert_equal( SIZE + 2*MX, w.width )
end


--[[
the anchors say which point of the widget is at its position
--]]
function test_anchors()
	local w = newPageIndicator{ numberOfPages=3 }
	local width, height = w.width, w.height

	w.anchorX, w.anchorY = 0, 0
	commit( w )
	assert_equal( width*0.5, w._rctHit.x )
	assert_equal( height*0.5, w._rctHit.y )
	assert_equal( width*0.5, w._dots[2].x )
	assert_equal( height*0.5, w._dots[2].y )

	w:setAnchor( 1, 1 )
	commit( w )
	assert_equal( -width*0.5, w._rctHit.x )
	assert_equal( -height*0.5, w._dots[2].y )
end


--[[
a width and a height make the touch area larger; the dots stay in its middle
--]]
function test_size()
	local w = newPageIndicator{ numberOfPages=3, width=200, height=44 }

	assert_equal( 200, w.width )
	assert_equal( 44, w.height )
	assert_equal( 200, w._rctHit.width )
	assert_equal( 44, w._rctHit.height )
	assert_equal( "-16 0 16", dotsX( w ) )

	w.width, w.height = 0, 0
	commit( w )
	assert_equal( 3*SIZE + 2*SPACE + 2*MX, w.width )
	assert_equal( w.width, w._rctHit.width )
	assert_equal( SIZE + 2*MY, w._rctHit.height )
end


--[[
the dot of the current page has its own color; the page stays inside of the pages
--]]
function test_currentPage()
	local w, d = newPageIndicator{ numberOfPages=4, currentPage=2 }

	assert_equal( 2, w.currentPage )
	assert_equal( "2", litDots( w ) )

	w.currentPage = 4
	commit( w )
	assert_equal( "4", litDots( w ) )

	w.currentPage = 9
	assert_equal( 4, w.currentPage )
	w.currentPage = -2
	commit( w )
	assert_equal( 1, w.currentPage )
	assert_equal( "1", litDots( w ) )

	-- fewer pages than the current one
	w.currentPage = 4
	w.numberOfPages = 2
	commit( w )
	assert_equal( 2, w.currentPage )
	assert_equal( "2", litDots( w ) )

	-- set by the app: the delegate isn't told
	assert_equal( 0, #d.changes )

	assert_error( function() w.currentPage = "2" end )
	assert_error( function() w.numberOfPages = -1 end )
end


--[[
a tap left or right of the current dot moves one page and tells the delegate;
on the dot, or at the first or the last page, nothing happens
--]]
function test_tap()
	local w, d = newPageIndicator{ numberOfPages=3, currentPage=2 }

	-- on the current dot (the middle one)
	assert_true( tap( w, 0 ) )
	assert_true( tap( w, SIZE*0.5-1 ) )
	assert_equal( 2, w.currentPage )
	assert_equal( 0, #d.changes )

	-- right of it, however far: one page
	assert_true( tap( w, w.width*0.5-1 ) )
	assert_equal( 3, w.currentPage )
	assert_equal( "3", litDots( w ) )
	assert_equal( 1, #d.changes )
	assert_equal( 3, d.last.page )
	assert_equal( 2, d.last.previousPage )
	assert_equal( w, d.last.target )
	assert_equal( w.EVENT, d.last.name )
	assert_equal( w.PAGE_CHANGED, d.last.type )

	-- the last page: nothing right of it
	tap( w, w.width*0.5-1 )
	assert_equal( 3, w.currentPage )
	assert_equal( 1, #d.changes )

	-- left of the current dot, now the last one
	tap( w, 0 )
	assert_equal( 2, w.currentPage )
	tap( w, -w.width*0.5+1 )
	assert_equal( 1, w.currentPage )
	assert_equal( "1", litDots( w ) )
	assert_equal( "3 2 1", table.concat( d.changes, ' ' ) )

	-- the first page: nothing left of it
	tap( w, -w.width*0.5+1 )
	assert_equal( 1, w.currentPage )
	assert_equal( 3, #d.changes )

	-- without a delegate, or without the method
	w.delegate = {}
	tap( w, 0 )
	assert_equal( 2, w.currentPage )
	w.delegate = nil
	tap( w, w.width*0.5-1 )
	assert_equal( 3, w.currentPage )
end


--[[
the widget keeps its touches and its taps: nothing reaches what is behind it
--]]
function test_keepsTouchAndTap()
	local w = newPageIndicator{ numberOfPages=3 }

	assert_true( send( w, 'touch', 0 ) )
	assert_true( send( w, 'tap', 0 ) )
	assert_true( w._rctHit.isHitTestable )
end


--[[
hidesForSinglePage: no dots and no touch area for one page, or none
--]]
function test_hidesForSinglePage()
	local w = newPageIndicator{ numberOfPages=1 }

	assert_false( w.isHidden )
	assert_true( w._dgDots.isVisible )
	assert_true( w._rctHit.isVisible )

	w.hidesForSinglePage = true
	commit( w )
	assert_true( w.isHidden )
	assert_false( w._dgDots.isVisible )
	assert_false( w._rctHit.isVisible )

	w.numberOfPages = 2
	commit( w )
	assert_false( w.isHidden )
	assert_true( w._dgDots.isVisible )
	assert_true( w._rctHit.isVisible )

	w.numberOfPages = 0
	commit( w )
	assert_true( w.isHidden )
	assert_false( w._dgDots.isVisible )

	local w2 = newPageIndicator{ numberOfPages=1, hidesForSinglePage=true }
	assert_true( w2.isHidden )
	assert_false( w2._dgDots.isVisible )

	assert_error( function() w.hidesForSinglePage = 1 end )
end


--[[
style changes reach the dots: their size, the space between them, the margins, the colors
--]]
function test_styleChanges()
	local w = newPageIndicator{ numberOfPages=3, currentPage=1 }
	local first = w._dots[1]

	w.style.dotSize = 20
	commit( w )
	assert_equal( 20, w._dots[1].width )
	assert_true( first~=w._dots[1], "the dots are made again" )
	assert_equal( 3*20 + 2*SPACE + 2*MX, w.width )
	assert_equal( 20 + 2*MY, w.height )
	assert_equal( "-26 0 26", dotsX( w ) )
	assert_equal( "1", litDots( w ) )

	w.style.dotSpacing = 10
	commit( w )
	assert_equal( "-30 0 30", dotsX( w ) )
	assert_equal( 3*20 + 2*10 + 2*MX, w._rctHit.width )

	w.style.marginX, w.style.marginY = 20, 10
	commit( w )
	assert_equal( 3*20 + 2*10 + 2*20, w._rctHit.width )
	assert_equal( 20 + 2*10, w._rctHit.height )

	-- colors, through the widget too
	w.dotColor = { 1, 1, 1, 1 }
	w.currentDotColor = { 0.2, 0.2, 0.2, 1 }
	commit( w )
	assert_equal( "2 3", litDots( w ) )

	w.debugOn = true
	commit( w )
	assert_true( w._rctHit.fill.a > 0 )
	w.debugOn = false
	commit( w )
	assert_equal( 0, w._rctHit.fill.a )
end


--[[
a Style object from dUI.newPageIndicatorStyle(), shared by two widgets
--]]
function test_styleObject()
	local style = dUI.newPageIndicatorStyle( newStyle() )
	assert_equal( SIZE, style.dotSize )
	assert_equal( SPACE, style.dotSpacing )
	assert_true( style:verifyProperties() )

	local w1 = newPageIndicator{ numberOfPages=2, style=style }
	local w2 = newPageIndicator{ numberOfPages=3, style=style }
	assert_equal( SIZE, w1._dots[1].width )

	style.dotSize = 14
	commit( w1 )
	commit( w2 )
	assert_equal( 14, w1._dots[1].width )
	assert_equal( 14, w2._dots[3].width )
end


--[[
with a SlideView: a tap on the indicator moves the slides,
a move of the slides sets the dot
--]]
function test_withSlideView()
	local indicator, slideView

	slideView = track( dUI.newSlideView{
		width=200, height=300,
		style={ debugOn=false, anchorX=0, anchorY=0, fillColor={ 1, 1, 1, 1 } },
		delegate={
			numberOfSlides=function( self ) return 4 end,
			onSlideRender=function( self, event ) end,
			didShowSlide=function( self, event )
				indicator.currentPage = event.index
			end,
		},
	})
	indicator = newPageIndicator{
		numberOfPages=4,
		delegate={
			didChangePage=function( self, event )
				slideView:gotoSlide( event.page, { animate=false } )
			end,
		},
	}
	commit( slideView )
	slideView:reloadData()
	commit( slideView )
	assert_equal( 1, indicator.currentPage )

	tap( indicator, indicator.width*0.5-1 )
	assert_equal( 2, indicator.currentPage )
	assert_equal( 2, slideView.index )

	-- the slide view tells its delegate on its next frame
	slideView:gotoSlide( 4, { animate=false } )
	local e = { name='enterFrame', time=system.getTimer() }
	commit( slideView )
	slideView._axisX:enterFrame( e )
	slideView._axisY:enterFrame( e )
	commit( slideView )
	commit( indicator )
	assert_equal( 4, indicator.currentPage )
	assert_equal( "4", litDots( indicator ) )
end


--[[
removal, with pages and without, leaves nothing behind
--]]
function test_removeSelf()
	local w = newPageIndicator{ numberOfPages=3 }
	local w2 = newPageIndicator()
	local hit = w._rctHit

	w:removeSelf()
	w2:removeSelf()
	assert_nil( w._rctHit )
	assert_nil( w._dgDots )
	assert_equal( 0, #w._dots )
	assert_nil( hit.parent )

	-- created and removed before its first frame
	local w3 = dUI.newPageIndicator{ numberOfPages=2, style=newStyle() }
	w3:removeSelf()
end
