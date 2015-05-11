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

local Perf = require 'lib.dmc_corona.dmc_performance'


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




--======================================================--
--== stress test ScrollView Style

function run_example1()

	local createItem, destroyItem
	local DELAY = 50
	local count = 0
	local o

	createItem = function()
		count=count+1
		o = dUI.newScrollViewStyle()

		tdelay( DELAY, function()
			destroyItem()
		end)
	end

	destroyItem = function()
		-- o:removeSelf()
		o = nil
		if count%10==0 then
			print( "cycles completed: ", count )
		end
		tdelay( DELAY, function()
			createItem()
		end)
	end

	print( "Main: Starting" )
	createItem()
	Perf.watchMemory( 2500 )

end

-- run_example1()




--======================================================--
--== stress test ScrollView

function run_example2()

	local createItem, destroyItem
	local w, h = 200, 300
	local DELAY = 200
	local count = 0
	local o

	createItem = function()
		count=count+1
		o = dUI.newScrollView{
			width=w,
			height=h,
			scrollWidth=1024,
			scrollHeight=680,
			delegate=delegate
		}
		o.x, o.y = H_CENTER-w/2, V_CENTER-h/2

		tdelay( DELAY, function()
			destroyItem()
		end)
	end

	destroyItem = function()
		o:removeSelf()
		o = nil
		if count%10==0 then
			print( "cycles completed: ", count )
		end


		tdelay( DELAY, function()
			createItem()
		end)
	end

	print( "Main: Starting" )
	createItem()
	Perf.watchMemory( 2500 )

end

run_example2()

