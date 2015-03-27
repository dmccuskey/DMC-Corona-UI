--====================================================================--
-- Popover Control Simple
--
-- show navigation content in popover
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2014 David McCuskey. All Rights Reserved.
--====================================================================--



print( '\n\n##############################################\n\n' )



--====================================================================--
--== Imports


local dUI = require 'lib.dmc_ui'

local GalleriesView = require 'view.galleries'
local galleryData = require 'gallery_data'



--====================================================================--
--== Setup, Constants


local W, H = dUI.WIDTH, dUI.HEIGHT
local H_CENTER, V_CENTER = W*0.5, H*0.5

local button = display.newRect( 0,0,60,40 )
button.x, button.y = H_CENTER+150, V_CENTER-200



--===================================================================--
--== Main
--===================================================================--


local navCtl = dUI.newNavigationControl()
local gV = GalleriesView.new( galleryData )
navCtl:pushView( gV )

navCtl.modalStyle = dUI.POPOVER  -- << this is very important

local popCtl = navCtl.popoverControl
popCtl.buttonItem = button
popCtl.arrowDirections = 'all'

navCtl:presentControl{
	onComplete=function() print( "ONCOMPLETE: PRESENTED" ) end
}

-- move location
timer.performWithDelay( 1000, function()
	button.x, button.y = H_CENTER, V_CENTER-100
	popCtl.buttonItem = button
end)

-- unhide
-- timer.performWithDelay( 2000, function()
-- 	navCtl:dismissControl{
-- 		onComplete=function() print( "ONCOMPLETE: DISMISSED" ) end
-- 	}
-- end)
