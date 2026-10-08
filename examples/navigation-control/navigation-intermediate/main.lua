--====================================================================--
-- Navigation Control Intermediate
--
-- A small app on a Navigation Control which fills the screen below the
-- status bar: a list of galleries, a gallery's list of images, an image.
-- Tap a button to go a level down, "< Back" to come back up.
--
-- Each view (in view/) is a plain table: a 'title' for the bar, a display
-- group ('view') which the control puts below its bar, and functions which
-- the control calls as the view comes and goes (they print). A view pushes
-- the next one through 'parent', the control's reference to itself. The
-- image view brings its own NavItem, to have an "Info" button on the right
-- of the bar, and removes its display group when it is popped.
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


-- the screen, as the device reports it: config.lua asks for 320x480
-- 'letterbox', so a taller screen has room above and below the content
local SCREEN_W, SCREEN_H = display.actualContentWidth, display.actualContentHeight
local SCREEN_Y = display.screenOriginY
local H_CENTER = display.contentCenterX
local STATUS_BAR_H = display.topStatusBarContentHeight



--===================================================================--
--== Main
--===================================================================--


-- the Navigation Control: the size of the screen below
-- the status bar, positioned by its top center

local navCtrl = dUI.newNavigationControl{
	width=SCREEN_W,
	height=SCREEN_H - STATUS_BAR_H,
}
navCtrl.x, navCtrl.y = H_CENTER, SCREEN_Y + STATUS_BAR_H

-- the first view: it appears at once, and has no Back button

navCtrl:pushView( GalleriesView.new( galleryData, navCtrl ) )
