--====================================================================--
-- Themed Background
--
-- Three themes (red, green, blue), each with a background style named
-- 'home-background': a rectangle, a rounded and a 9-slice background. The
-- two backgrounds use the style by name, so they change with the active
-- theme, every second; the line at the bottom names it. The backdrop
-- fills the screen on any device.
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


-- the screen, as the device reports it: config.lua asks for 320x480
-- 'letterbox', so a taller or a wider screen has room around the content
local SCREEN_W, SCREEN_H = display.actualContentWidth, display.actualContentHeight
local SCREEN_Y = display.screenOriginY
local H_CENTER, V_CENTER = display.contentCenterX, display.contentCenterY
local STATUS_BAR_H = display.topStatusBarContentHeight

-- the line at the bottom, later
local status = nil



--===================================================================--
-- Support Functions


--======================================================--
-- Setup Visual Screen Items

-- a backdrop the size of the screen, the example's name at the top,
-- a line at the bottom which says what the widget shows (setStatus()),
-- and a marker at the screen's center, a white box with a red dot,
-- which makes a change of the widget's anchor easy to see
--
local function setupBackground()
	local o

	o = display.newRect( H_CENTER, V_CENTER, SCREEN_W, SCREEN_H )
	o:setFillColor( 0.17, 0.24, 0.31 )

	o = display.newText( "Themed Background", H_CENTER, SCREEN_Y+STATUS_BAR_H+30, native.systemFontBold, 20 )

	status = display.newText( "", H_CENTER, SCREEN_Y+SCREEN_H-30, native.systemFont, 16 )

	o = display.newRect( H_CENTER, V_CENTER, 104, 54 )

	o = display.newRect( H_CENTER, V_CENTER, 10, 10 )
	o:setFillColor( 1, 0, 0 )
end

local function setStatus( text )
	status.text = text
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
	setStatus( "theme: "..order[idx] )

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
		setStatus( "theme: "..order[idx] )
	end, 0 )

end

run_example1()
