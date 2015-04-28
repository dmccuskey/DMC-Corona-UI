--====================================================================--
-- ScrollView Zoom
--
-- shows basic use of zoom action with scrollview widget
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2015 David McCuskey. All Rights Reserved.
--====================================================================--



print( '\n\n##############################################\n\n' )



--====================================================================--
--== Imports


local dUI = require 'lib.dmc_ui'



--====================================================================--
--== Setup, Constants


local W, H = dUI.WIDTH, dUI.HEIGHT
local H_CENTER, V_CENTER = W*0.5, H*0.5

local tdelay = timer.performWithDelay

local view, viewPos



--===================================================================--
--== Support Functions


--======================================================--
-- Delegate Functions

--- return view/object to use for zooming.
-- called before zooming
--
local function viewForZoom( self, event )
	-- print( "Main:viewForZoom" )
	-- local target = event.target -- scrollview
	return view
end


--- called at the beginning of zoom gestures or animation.
-- called by scrollview when starting zoom action
--
local function zoomBeginEvent( self, event )
	-- print( "Main:zoomBeginEvent" )
	-- local target = event.target -- scrollview
	-- local view = event.view -- zoom item
end


--- called at the end of zoom gestures or animation.
-- called by scrollview when ending zoom action
--
local function didZoomEvent( self, event )
	-- print( "Main:didZoomEvent" )
	-- local target = event.target -- scrollview
	-- local view = event.view -- zoom item
	-- local scale = event.scale -- zoom item
	-- view.x, view.y = viewPos.x*scale, viewPos.y*scale
end


--- called at the end of zoom gestures or animation.
-- called by scrollview when ending zoom action
--
local function zoomEndEvent( self, event )
	-- print( "Main:zoomEndEvent" )
	-- local target = event.target -- scrollview
	-- local view = event.view -- zoom item
	-- local view = event.view -- zoom item
	-- local scale = event.scale -- zoom item
	-- view.x, view.y = viewPos.x*scale, viewPos.y*scale
end



--===================================================================--
--== Main
--===================================================================--


viewPos = { x=0, y=0 }

--== Create ScrollView delgate

local delegate = {
	getViewForZoom=viewForZoom,
	willBeginZooming=zoomBeginEvent,
	didEndZooming=zoomEndEvent,
	didZoom=didZoomEvent,
}


--== Create ScrollView
local w, h = 200, 300

local widget = dUI.newScrollView{
	width=w,
	height=h,
	scrollWidth=1024,
	scrollHeight=680,
	delegate=delegate
}
widget.x, widget.y = H_CENTER-w/2, V_CENTER-h/2

widget.minimumZoom=0.2
widget.maximumZoom=1



--== Create our object to display

view = display.newImage( 'asset/aci-trezza-faraglioni-sunset.jpg', viewPos.x, viewPos.y, true )
view.anchorX, view.anchorY = 0,0
view.alpha = 0.3

widget.scroller:insert( view )




tdelay( 500, function()
	print("Main:start")
	local function callback()
		print( "here in motion callback" )
	end
	widget:setZoomScale( 0.5 )
	-- widget:setContentPosition{
	-- 	-- x=-40, y=0, onComplete=callback
	-- }
end)

