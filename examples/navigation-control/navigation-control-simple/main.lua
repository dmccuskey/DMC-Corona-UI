--====================================================================--
-- Navigator Control Simple
--
-- navigate between very lightweight objects
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



--===================================================================--
--== Main
--===================================================================--


local navCtrl, view

-- create NavCntrl, position on screen
-- here y=20 is height of iOS status bar

navCtrl = dUI.newNavigationControl()
navCtrl.x, navCtrl.y = H_CENTER, 20

-- create view 1

view = display.newRect( 0, 0, W, H )
view:setFillColor( 0.3, 0.4, 0.5 )
view.anchorX, view.anchorY = 0.5, 0
view.title = 'View 1'
navCtrl:pushView( view )

-- create view 2

timer.performWithDelay( 1000, function()
	view = display.newRect( 0, 0, W, H )
	view:setFillColor( 0.5, 0.6, 0.7 )
	view.anchorX, view.anchorY = 0.5, 0
	view.title = 'View 2'
	navCtrl:pushView( view )
end)

-- create view 3

timer.performWithDelay( 2000, function()
	view = display.newRect( 0, 0, W, H )
	view:setFillColor( 0.7, 0.5, 0.3 )
	view.anchorX, view.anchorY = 0.5, 0
	view.title = 'View 3'
	navCtrl:pushView( view )
end)

