--====================================================================--
-- Navigator Simple
--
-- basic streaming example
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2014 David McCuskey. All Rights Reserved.
--====================================================================--



print( '\n\n##############################################\n\n' )



--====================================================================--
--== Imports



local dUI = require 'lib.dmc_ui'

local galleries_data = require 'data.gallery'





--====================================================================--
--== Setup, Constants


local W, H = display.contentWidth, display.contentHeight
local H_CENTER, V_CENTER = W*0.5, H*0.5

local popover

local createGalleriesView, removeGalleriesView, galleriesView_handler

local onAccept, onCancel, onError



--====================================================================--
--== Support Functions


-- Setup Visual Screen Items
--
local function setupBackground()
	local width, height = 100, 50
	local o

	o = display.newRect(0,0,W,H)
	o:setFillColor(0.5,0.5,0.5)
	o.x, o.y = H_CENTER, V_CENTER

	o = display.newRect(0,0,width+4,height+4)
	o:setStrokeColor(0,0,0)
	o.strokeWidth=2
	o.x, o.y = H_CENTER, V_CENTER

	o = display.newRect( 0,0,10,10)
	o:setFillColor(1,0,0)
	o.x, o.y = H_CENTER, V_CENTER
end


local function backButton_handler( event )
	print( 'Main: backButton_handler: id', event.id, event.phase )
end



-- Create Items

onAccept = function()
	print( "\n\n" )
	print( "Watchlist Add Popup Test onAccept: " )
	print( "\n\n" )
	-- o:removeSelf()
end
onCancel = function( event )
	print( "\n\n" )
	print( "Watchlist Add Popup Test onCancel: " )
	print( "\n\n" )
	o:removeSelf()
end
onError = function( event )
	print( "\n\n" )
	print( "Watchlist Add Popup Test onError: " )
	print( "\n\n" )
	o:removeSelf()
end


--===================================================================--
--== Main
--===================================================================--


setupBackground()



-- popover = MyPopover:new{}

-- show, customized
popover:show{
	data=galleries_data,
	pos={x=H_CENTER, y=V_CENTER-100}
}

-- popover.x, popover.y = 100, 50


timer.performWithDelay( 60000, function()
	popover:removeSelf()
end)



