--====================================================================--
-- Themed Background
--
-- Three themes (red, green, blue), each with a background style named
-- 'home-background': a rectangle, a rounded and a 9-slice background. The
-- two backgrounds use the style by name, so they change with the active
-- theme, every second.
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2015, 2026 David McCuskey. All Rights Reserved.
--====================================================================--



print( "\n\n#########################################################\n\n" )



--===================================================================--
--== Imports


local dUI = require 'lib.dmc_ui'



--===================================================================--
--== Setup, Constants


local W, H = display.contentWidth, display.contentHeight
local H_CENTER, V_CENTER = W*0.5, H*0.5



--===================================================================--
-- Support Functions


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



--===================================================================--
--== Main
--===================================================================--


setupBackground()


--======================================================--
--== backgrounds styled by name, from the active theme

function run_example1()

	-- load the theme files: every .lua file in theme/
	-- (or one at a time: dUI.loadTheme( 'theme/red-theme.lua' ))
	dUI.loadThemes( 'theme' )

	local order = { 'red-theme', 'green-theme', 'blue-theme' }
	local idx = 1
	dUI.activateTheme( order[idx] )

	local bg1, bg2

	bg1 = dUI.newBackground{ style='home-background' }
	bg1.x, bg1.y = H_CENTER, V_CENTER-120

	bg2 = dUI.newBackground{ style='home-background' }
	bg2.x, bg2.y = H_CENTER, V_CENTER

	-- next theme every second
	timer.performWithDelay( 1000, function()
		idx = idx % #order + 1
		print( "Main: activating", order[idx] )
		dUI.activateTheme( order[idx] )
	end, 0 )

end

run_example1()
