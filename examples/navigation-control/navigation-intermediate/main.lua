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

local GalleriesView = require 'view.galleries'
local galleryData = require 'gallery_data'



--====================================================================--
--== Setup, Constants


local W, H = dUI.WIDTH, dUI.HEIGHT
local H_CENTER, V_CENTER = W*0.5, H*0.5



--===================================================================--
--== Main
--===================================================================--


local navCtrl = dUI.newNavigationControl()
navCtrl.x, navCtrl.y = H_CENTER, 20

local gV = GalleriesView.new( galleryData )

navCtrl:pushView( gV )



