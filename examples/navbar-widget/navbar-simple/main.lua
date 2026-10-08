--====================================================================--
-- NavBar Simple
--
-- A navigation bar across the top of the screen, below the status bar,
-- whatever the device. Each screen of an app has a NavItem: its title,
-- a Back button, and optional left and right buttons. The bar keeps a
-- stack of them and slides from one to the next.
--
-- The app pushes three items by itself: "Home", which has a left button,
-- after a second "Albums", and a second and a half later "Photo", which
-- has a right button. Then it is yours: tap the page to push another
-- item, tap "< Back" to pop the top one. The page shows the stack; a
-- delegate hears of each pop (didPopItem), and the buttons print.
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2014-2015 David McCuskey. All Rights Reserved.
--====================================================================--



print( "\n\n#########################################################\n\n" )



--===================================================================--
--== Imports


local dUI = require 'lib.dmc_ui'



--===================================================================--
--== Setup, Constants


-- the screen, as the device reports it: config.lua asks for 320x480
-- 'letterbox', so a taller screen has room above and below the content
local SCREEN_W, SCREEN_H = display.actualContentWidth, display.actualContentHeight
local SCREEN_X, SCREEN_Y = display.screenOriginX, display.screenOriginY
local H_CENTER = display.contentCenterX
local STATUS_BAR_H = display.topStatusBarContentHeight

local tinsert = table.insert
local tremove = table.remove
local tconcat = table.concat

local navBar = nil -- later
local stackText = nil -- later
local titles = {} -- the titles on the stack
local count = 0 -- items pushed by a tap



--===================================================================--
--== Support Functions


local function showStack()
	stackText.text = tconcat( titles, "  >  " )
end


-- push a Nav Item with this title, and optional buttons
--
local function pushItem( title, params )
	params = params or {}
	params.titleText = title
	tinsert( titles, title )
	showStack()
	navBar:pushNavItem( dUI.newNavItem( params ) )
end


local function button_handler( event )
	print( "Main: button released:", event.id )
end


-- the page: tap it to push another item.
-- the bar and its buttons keep their touches and taps to themselves,
-- so a tap on "< Back" doesn't reach the page behind the bar
--
local function page_handler( event )
	count = count + 1
	pushItem( "Item " .. count )
	return true
end


--======================================================--
-- Nav Bar Delegate

local delegate = {

	-- the Back button was released: say whether the bar may pop its top item
	shouldPopItem=function( self, navBar, navItem )
		return true
	end,

	-- the top item has slid off, and is about to be removed
	didPopItem=function( self, navBar, navItem )
		print( "Main: popped:", navItem.titleText )
		tremove( titles )
		showStack()
	end,

}


--======================================================--
-- Setup Visual Screen Items

local function setupPage()
	local top = SCREEN_Y + STATUS_BAR_H + navBar.height
	local o

	-- the size of the screen
	o = display.newRect( 0, 0, SCREEN_W, SCREEN_H )
	o:setFillColor( 0.5, 0.5, 0.5 )
	o.anchorX, o.anchorY = 0.5, 0
	o.x, o.y = H_CENTER, SCREEN_Y
	o:addEventListener( 'tap', page_handler )
	o:toBack()

	o = display.newText{
		text="",
		x=H_CENTER, y=top+60,
		width=SCREEN_W-40,
		font=native.systemFontBold, fontSize=16,
		align='center',
	}
	stackText = o

	o = display.newText{
		text="Tap the page to push an item,\n\"< Back\" to pop it.",
		x=H_CENTER, y=top+140,
		width=SCREEN_W-40,
		font=native.systemFont, fontSize=14,
		align='center',
	}
end



--===================================================================--
--== Main
--===================================================================--


-- Create Nav Bar: as wide as the screen, its top edge below the status bar

navBar = dUI.newNavBar{
	delegate=delegate
}
navBar.width = SCREEN_W
navBar.anchorX, navBar.anchorY = 0.5, 0
navBar.x, navBar.y = H_CENTER, SCREEN_Y + STATUS_BAR_H

setupPage()

-- Add 1st Nav Item: the root item has no Back button, here it has a left button

pushItem( "Home", {
	leftButton=dUI.newButton{ id='menu-button', labelText="Menu", onRelease=button_handler }
})

-- Add 2nd Nav Item

timer.performWithDelay( 1000, function()
	pushItem( "Albums" )
end)

-- Add 3rd Nav Item, with a right button

timer.performWithDelay( 2500, function()
	pushItem( "Photo", {
		rightButton=dUI.newButton{ id='edit-button', labelText="Edit", onRelease=button_handler }
	})
end)
