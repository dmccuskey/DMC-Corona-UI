--====================================================================--
-- Table View Simple
--
-- Shows simple use of the DMC Widget: Slide View
--
-- by David McCuskey
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2014 David McCuskey. All Rights Reserved.
--====================================================================--

print("---------------------------------------------------")



--===================================================================--
-- Imports
--===================================================================--

local widgets = require( 'dmc_widgets' )


--===================================================================--
-- Setup, Constants
--===================================================================--

local W,H = display.contentWidth, display.contentHeight
local H_CENTER, V_CENTER = W*0.5, H*0.5

print( "phone dim", W, H )
local OFFSET = 100

local o, p, f


--===================================================================--
-- Support Functions
--===================================================================--

-- onRender()
-- called when table view needs to display a row
--
local function onRender( event )
	print( 'Main:onRender' )

	local view = event.view
	local index = event.data

	local o

	o = display.newText( tostring(index), 40,30, native.systemFont, 32)
	o.anchorX, o.anchorY = 0.5,0
	view:insert( o )
	o.x = -10

	view._o = o

end

-- onUnrender()
-- called when table view needs to destroy a row
--
local function onUnrender( event )
	print( 'Main:onUnrender' )

	local view = event.view
	local o

	o = view._o
	o:removeSelf()

	view._o = nil

end

local function onEvent( event )
	-- print( 'onEvent' )

end


--===================================================================--
-- Main
--===================================================================--

local scroller

-- create Slide View

p = {
	width=W-OFFSET,
	height=H-OFFSET,
}
scroller = widgets.newSlideView( p )
scroller.x, scroller.y = OFFSET*0.5, OFFSET*0.5


-- create slides

for i = 1, 200 do

	local p = {
		height = 300,
		onItemRender=onRender,
		onItemUnrender=onUnrender,
		onItemEvent=onEvent,
		bgColor = { 1, 0, 0 }, -- range 0-1
		data = "slide: " .. tostring( i )
	}

	scroller:insertSlide( p )

end

-- f = function()
-- 	print( "deleting slide" )
-- 	scroller:deleteSlide( 1 )
-- end
-- timer.performWithDelay( 500, f )

-- f = function()
-- 	print( "deleting slide" )
-- 	scroller:deleteSlide( 1 )
-- end
-- timer.performWithDelay( 1000, f )

-- f = function()
-- 	print( "deleting slide" )
-- 	scroller:deleteSlide( 1 )
-- end
-- timer.performWithDelay( 1500, f )

-- f = function()
-- 	print( "deleting slide" )
-- 	scroller:deleteSlide( 1 )
-- end
-- timer.performWithDelay( 2000, f )

-- f = function()
-- 	print( "deleting slide" )
-- 	scroller:deleteSlide( 1 )
-- end
-- timer.performWithDelay( 2500, f )

f = function()
	print( "goto slide" )
	scroller:gotoSlide( 100 )
end
timer.performWithDelay( 500, f )
f = function()
	print( "goto slide" )
	scroller:gotoSlide( 10 )
end
timer.performWithDelay( 1500, f )

