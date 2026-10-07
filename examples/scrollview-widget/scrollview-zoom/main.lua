--====================================================================--
-- ScrollView Zoom
--
-- A photo of 1024x680 in a scroll view which fills the screen below the
-- status bar. The photo is larger than the screen, so at full size it
-- scrolls in both directions. Zooming needs three things: a delegate whose
-- getViewForZoom() returns the object to scale, minimumZoom and
-- maximumZoom. Here the minimum is the scale at which the whole photo
-- fits, the maximum twice its size. After a second the app zooms out to
-- show all of it, after four back in to full size (setZoomScale()); then
-- drag to move around, pinch to zoom (on a device: the Simulator has one
-- touch). The scroll indicators are light, from the style's
-- indicatorColor, to show on the dark photo.
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

-- the screen, as the device reports it
local STATUS_BAR_H = display.topStatusBarContentHeight

-- the photo
local PHOTO = 'asset/aci-trezza-faraglioni-sunset.jpg'
local PHOTO_W, PHOTO_H = 1024, 680



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

local w, h = W, H-STATUS_BAR_H

-- the scale at which the whole photo fits in the scroll view
local fitScale = math.min( w/PHOTO_W, h/PHOTO_H )

local widget = dUI.newScrollView{
	width=w,
	height=h,
	scrollWidth=PHOTO_W,
	scrollHeight=PHOTO_H,
	minimumZoom=fitScale,
	maximumZoom=2,
	autoMask=true, -- clip the content to the scroll view
	delegate=delegate,
	style={
		fillColor={0,0,0,1}, -- black around the photo when it is smaller
		indicatorColor={1,1,1,0.6}, -- light scroll indicators, for a dark photo
	}
}
widget.x, widget.y = 0, STATUS_BAR_H


--== Create our object to display

view = display.newImageRect( PHOTO, PHOTO_W, PHOTO_H )
view.anchorX, view.anchorY = 0,0
view.x, view.y = viewPos.x, viewPos.y

widget.scroller:insert( view )


--== Zoom out to the whole photo, then back in

tdelay( 1000, function()
	print( "Main: zoom out to fit", fitScale )
	widget:setZoomScale( fitScale )
end)

tdelay( 4000, function()
	print( "Main: zoom in to full size" )
	widget:setZoomScale( 1 )
end)
