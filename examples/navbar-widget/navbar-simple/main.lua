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


local Widgets = require 'lib.dmc_widgets'



--===================================================================--
--== Setup, Constants

local W, H = display.contentWidth, display.contentHeight
local H_CENTER, V_CENTER = W*0.5, H*0.5

local nav_bar, nav_item



--===================================================================--
-- Support Functions


local function backButton_handler( event )
	print( 'Main: backButton_handler: id', event.id, event.phase )
end



--===================================================================--
--== Main
--===================================================================--


-- Create Nav Bar

nav_bar = Widgets.newNavBar{
	width=W
}
nav_bar.bg_color = { 0.5, 0.5, 0.5, 1 }

nav_bar.x, nav_bar.y = H_CENTER, 50


-- Add 1st Nav Item

nav_item=Widgets.newNavItem{
	title="First"
}
nav_bar:pushNavItem( nav_item )

-- Add 2nd Nav Item

timer.performWithDelay( 1000, function()
	-- print( "moving forward")
	nav_item=Widgets.newNavItem{
		title="Second"
	}
	nav_item.back_button.onRelease = backButton_handler
	nav_bar:pushNavItem( nav_item )
end)

-- Add 3rd Nav Item

timer.performWithDelay( 2000, function()
	-- print( "moving forward")
	nav_item=Widgets.newNavItem{
		title="Third"
	}
	nav_item.back_button.onRelease = backButton_handler
	nav_bar:pushNavItem( nav_item )
end)

-- Go back

timer.performWithDelay( 3000, function()
	-- print( "going back" )
	nav_bar:popNavItemAnimated()
end)

-- Go back

timer.performWithDelay( 4000, function()
	-- print( "going back" )
	nav_bar:popNavItemAnimated()
end)

