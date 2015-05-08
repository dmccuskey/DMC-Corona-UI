--====================================================================--
-- Simple Nav Bar
--
-- Shows basic use of the DMC Widget: NavBar
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


local W, H = display.contentWidth, display.contentHeight
local H_CENTER, V_CENTER = W*0.5, H*0.5

local navBar, navItem



--===================================================================--
--== Support Functions


--======================================================--
-- Setup Visual Screen Items

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



--===================================================================--
--== Main
--===================================================================--


setupBackground()


-- Create Nav Bar

navBar = dUI.newNavBar()
navBar.anchorX, navBar.anchorY = 0.5,1
navBar.x, navBar.y = H_CENTER, V_CENTER


-- Add 1st Nav Item

navItem=dUI.newNavItem{
	titleText="First"
}
navBar:pushNavItem( navItem )

-- Add 2nd Nav Item

timer.performWithDelay( 1000, function()
	-- print( "moving forward")
	navItem=dUI.newNavItem{
		titleText="Second"
	}
	navItem.backButton.onRelease = backButton_handler
	navBar:pushNavItem( navItem )
end)

-- Add 3rd Nav Item

timer.performWithDelay( 3000, function()
	-- print( "moving forward")
	navItem=dUI.newNavItem{
		titleText="Third",
		rightButton=dUI.newButton()
	}
	navItem.backButton.onRelease = backButton_handler
	navBar:pushNavItem( navItem )
end)

-- Go back

-- timer.performWithDelay( 5000, function()
-- 	-- print( "going back" )
-- 	navBar:popNavItemAnimated()
-- end)

-- -- Go back

-- timer.performWithDelay( 7000, function()
-- 	-- print( "going back" )
-- 	navBar:popNavItemAnimated()
-- end)

