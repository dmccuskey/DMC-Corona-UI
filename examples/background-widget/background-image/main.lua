--====================================================================--
-- Image Background
--
-- An image background with its drop-shadow offsets set, scaled to 100x100
-- and anchored at its left center; after a second it's 150 wide; after
-- two, a width and height of 0 show the image at its own size, anchored
-- at its center. The red dot marks its position, at the center of the
-- screen. The backdrop fills the screen on any device, and a line at the
-- bottom says what the background shows.
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2015 David McCuskey. All Rights Reserved.
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

	o = display.newText( "Image Background", H_CENTER, SCREEN_Y+STATUS_BAR_H+30, native.systemFontBold, 20 )

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
--== create a image background

function run_example1a()

	local bw1

	-- bs1 = dUI.newImageBackgroundStyle{
	-- 	width=75,
	-- }

	bw1 = dUI.newImageBackground{

		style={
			anchorX=0,
			anchorY=0.5,
			width=100,
			height=100,
			view = {
				imagePath='asset/background.png',
				offsetLeft=11,
				offsetRight=10,
				offsetTop=7,
				offsetBottom=14,
			}
		}
	}
	bw1.x, bw1.y = H_CENTER, V_CENTER
	setStatus( "100x100, anchored at its left center" )

	-- bw1.style = bs1

	timer.performWithDelay( 1000, function()
		bw1.width=150
		print( bw1.width, bw1.height )
		setStatus( "150 wide" )
	end)

	timer.performWithDelay( 2000, function()
		bw1.width, bw1.height = 0, 0
		bw1.anchorX=0.5
		bw1.anchorY=0.5
		setStatus( "its own size, anchored at its center" )
	end)

	timer.performWithDelay( 2100, function()
		print( bw1.width, bw1.height )
	end)

end

run_example1a()


