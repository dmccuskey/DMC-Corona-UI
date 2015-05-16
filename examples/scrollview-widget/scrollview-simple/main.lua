--====================================================================--
-- ScrollView Simple
--
-- shows basic use of scrollview widget
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

local tdelay = timer.performWithDelay



--===================================================================--
--== Main
--===================================================================--


local function callback()
	print( "here in motion callback" )
end

local widget = dUI.newScrollView{
	width=200,
	height=300,
	scrollWidth=300,
	scrollHeight=800,
	style={
		debugOn=true
	}
}
widget.x, widget.y = H_CENTER-widget.width/2, V_CENTER/2


tdelay( 1000, function()
	print("start – move scroller")
	widget:setContentPosition{
		x=-10, y=40, onComplete=callback
	}
end)

tdelay( 4000, function()
	print("start 2 – lock scroller")
	widget.horizontalScrollEnabled = false
	-- widget.upperVerticalOffset =50
	widget.bounceIsActive = false
end)


tdelay( 8000, function()
	print("start 3 – unlock scroller ")
	widget.horizontalScrollEnabled = true
	widget.upperVerticalOffset = -10
	widget.bounceIsActive = true
end)
