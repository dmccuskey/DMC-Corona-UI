--====================================================================--
-- Navigation Control Simple
--
-- A Navigation Control which fills the screen below the status bar,
-- whatever the device. It makes its own nav bar, and shows the views
-- pushed onto it below the bar, one at a time.
--
-- Here each view is the lightest kind there is, a display rectangle
-- with a 'title': the control gives it its place and its size. The app
-- pushes three by itself: "View 1" at once, "View 2" after a second and
-- "View 3" after two; each slides in from the right while the bar shows
-- its title and a "< Back" button. Then it is yours: tap a view to push
-- another, tap "< Back" to pop the top one. The first view stays.
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


-- the screen, as the device reports it: config.lua asks for 320x480
-- 'letterbox', so a taller screen has room above and below the content
local SCREEN_W, SCREEN_H = display.actualContentWidth, display.actualContentHeight
local SCREEN_Y = display.screenOriginY
local H_CENTER = display.contentCenterX
local STATUS_BAR_H = display.topStatusBarContentHeight

local COLORS = {
	{ 0.3, 0.4, 0.5 },
	{ 0.5, 0.6, 0.7 },
	{ 0.7, 0.5, 0.3 },
	{ 0.4, 0.6, 0.4 },
	{ 0.6, 0.4, 0.6 },
}

local navCtrl = nil -- later
local count = 0 -- views made



--====================================================================--
--== Support Functions


local pushNextView -- forward


-- a tap on a view pushes another
--
local function view_handler( event )
	pushNextView()
	return true
end


-- make a view and push it: a rectangle of any size, the control
-- puts it below its bar and makes it as large as the room there
--
pushNextView = function()
	count = count + 1

	local view = display.newRect( 0, 0, 100, 100 )
	view:setFillColor( unpack( COLORS[ (count-1) % #COLORS + 1 ] ) )
	view.title = "View " .. count -- shown in the bar
	view:addEventListener( 'tap', view_handler )

	navCtrl:pushView( view )
end


-- a popped view is hidden, not removed: it is ours to remove
--
local function navCtrl_handler( event )
	if event.type == navCtrl.REMOVED_VIEW then
		print( "Main: popped:", event.view.title )
		event.view:removeSelf()
	end
end



--===================================================================--
--== Main
--===================================================================--


-- create the Navigation Control: the size of the screen
-- below the status bar, positioned by its top center

navCtrl = dUI.newNavigationControl{
	width=SCREEN_W,
	height=SCREEN_H - STATUS_BAR_H,
}
navCtrl.x, navCtrl.y = H_CENTER, SCREEN_Y + STATUS_BAR_H
navCtrl:addEventListener( navCtrl.EVENT, navCtrl_handler )

-- a hint, over the control: it has no listeners,
-- so a tap on it goes on to the view below

local hint = display.newText{
	text="Tap the view to push another,\n\"< Back\" to pop it.",
	x=H_CENTER, y=display.contentCenterY,
	width=SCREEN_W-40,
	font=native.systemFont, fontSize=14,
	align='center',
}

-- view 1: the first view appears at once, and has no Back button

pushNextView()

-- view 2

timer.performWithDelay( 1000, pushNextView )

-- view 3

timer.performWithDelay( 2000, pushNextView )
