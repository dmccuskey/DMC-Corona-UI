--====================================================================--
-- Simple 9-Slice Button
--
-- A push button with a 9-slice background (the blue image sheet in
-- asset/image/cloud_button/, whose shadow lies outside the button: the
-- offsets), anchored at its bottom center on the red dot. Its size animates
-- between 60x40 and 225x100; when narrow, the label "Press Here for Fun"
-- ends in "...". The pressed state uses the default rounded style. The line
-- at the bottom says which way it is going, and when it is pressed.
-- run_example1a() is the same button at a fixed 200x100; run_example3()
-- adds debugOn, then a yellow left-aligned label and a larger hit area.
-- The backdrop fills the screen on any device.
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

	o = display.newText( "Simple 9-Slice Button", H_CENTER, SCREEN_Y+STATUS_BAR_H+30, native.systemFontBold, 20 )

	status = display.newText( "", H_CENTER, SCREEN_Y+SCREEN_H-30, native.systemFont, 16 )

	o = display.newRect( H_CENTER, V_CENTER, 104, 54 )

	o = display.newRect( H_CENTER, V_CENTER, 10, 10 )
	o:setFillColor( 1, 0, 0 )
end

local function setStatus( text )
	status.text = text
end


--======================================================--
-- Button Handlers

local function onPress_handler( event )
	print( 'Main: onPress_handler: id', event.id )
	setStatus( "pressed" )
end

local function onRelease_handler( event )
	print( 'Main: onRelease_handler: id', event.id )
end

local function onEvent_handler( event )
	print( 'Main: onEvent_handler: id', event.id, event.phase )
end



--===================================================================--
--== Main
--===================================================================--


setupBackground()



--======================================================--
--== create background, default style

function run_example1a()

	local bw1

	bw1 = dUI.newPushButton{

		id='9-slice-button',
		labelText="Press",

		data="your data",
		onPress=onPress_handler,

		style={
			anchorX=0.5,
			anchorY=1,
			hitMarginX=10,
			hitMarginY=10,

			inactive = {
				label={ textColor=dUI.Palette.cloud },
				background = {
					type=dUI.NINE_SLICE,
					view = {
						sheetInfo='asset.image.cloud_button.button-sheet',
						sheetImage='asset/image/cloud_button/button-sheet.png',
						offsetLeft=8,
						offsetRight=7,
						offsetTop=4,
						offsetBottom=12,
					}
				}
			}
		}
	}
	bw1.width, bw1.height = 200, 100
	bw1.x, bw1.y = H_CENTER, V_CENTER+0
	setStatus( "200x100, anchored bottom center" )

	-- timer.performWithDelay( 1000, function()
	-- 	bw1.width=100
	-- 	bw1.anchorX=1
	-- end)

end

-- run_example1a()




--======================================================--
--== create 9slice example, width move

function run_example2()

	local bw1

	bw1 = dUI.newPushButton{

		id='9-slice-button',
		labelText="Press Here for Fun",

		data="your data",
		onPress=onPress_handler,

		style={
			-- debugOn=true,
			anchorX=0.5,
			anchorY=1,
			hitMarginX=10,
			hitMarginY=10,
			marginX=10,

			inactive = {
				label={
					textColor=dUI.Palette.cloud,
					-- fontSizeMinimum=0,
				},
				background = {
					type=dUI.NINE_SLICE,
					view = {
						sheetInfo='asset.image.cloud_button.button-sheet',
						sheetImage='asset/image/cloud_button/button-sheet.png',
						offsetLeft=8,
						offsetRight=7,
						offsetTop=4,
						offsetBottom=12,
					}
				}
			}
		}
	}
	bw1.width, bw1.height = 200, 100
	bw1.x, bw1.y = H_CENTER, V_CENTER+0

	local narrow, wide

	wide = function()
		setStatus( "growing to 225x100" )
		transition.to( bw1, {time=2000, width=225, height=100, onComplete=narrow} )
	end
	narrow = function()
		setStatus( "shrinking to 60x40" )
		transition.to( bw1, {time=2000, width=60, height=40, onComplete=wide} )
	end

	narrow()

end

run_example2()



--======================================================--
--== create 9slice example, width move

function run_example3()

	local bw1

	bw1 = dUI.newPushButton{

		id='9-slice-button',
		labelText="Press Here for Fun",

		data="your data",
		onPress=onPress_handler,

		style={
			debugOn=true,
			anchorX=0.5,
			anchorY=1,
			hitMarginX=10,
			hitMarginY=10,
			marginX=10,

			inactive = {
				label={ textColor=dUI.Palette.cloud },
				background = {
					type=dUI.NINE_SLICE,
					view = {
						sheetInfo='asset.image.cloud_button.button-sheet',
						sheetImage='asset/image/cloud_button/button-sheet.png',
						offsetLeft=8,
						offsetRight=7,
						offsetTop=4,
						offsetBottom=12,
					}
				}
			}
		}
	}
	bw1.width, bw1.height = 200, 100
	bw1.x, bw1.y = H_CENTER, V_CENTER+0
	setStatus( "debugOn: the hit area in red" )

	timer.performWithDelay( 2000, function()
		-- bw1.anchorX=0
		-- bw1.anchorY=0
		bw1.inactiveStyle.label.textColor=dUI.Palette.yellow
		bw1.inactiveStyle.label.align='left'
		bw1.hitMarginX=30
		bw1.hitMarginY=30
		setStatus( "yellow label, left; hit margin 30" )
	end)

end

-- run_example3()



