--====================================================================--
-- Simple Text Button
--
-- Four push buttons that differ in their label, each state styled on its
-- own: "Back" turns red and moves right while pressed; "Middle" has a large
-- hit area (hitMarginX/Y, shown in red by debugOn); "Orange" sits right with
-- an offset and jumps left while pressed (each state's align and offsetX/Y);
-- "Disabled" shows the disabled style and ignores presses. The line at the
-- bottom names each press and release by the button's id (also printed).
-- The label colors are from dUI.Palette. The backdrop fills the screen on
-- any device.
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
-- 'letterbox', so a taller or a wider screen has room around the content
local SCREEN_W, SCREEN_H = display.actualContentWidth, display.actualContentHeight
local SCREEN_Y = display.screenOriginY
local H_CENTER, V_CENTER = display.contentCenterX, display.contentCenterY
local STATUS_BAR_H = display.topStatusBarContentHeight

-- the line at the bottom, later
local status = nil



--===================================================================--
--== Support Functions


-- a backdrop the size of the screen, the example's name at the top,
-- and a line at the bottom which says what the widgets show (setStatus())
--
local function setupBackground()
	local o

	o = display.newRect( H_CENTER, V_CENTER, SCREEN_W, SCREEN_H )
	o:setFillColor( 0.17, 0.24, 0.31 )

	o = display.newText( "Simple Text Button", H_CENTER, SCREEN_Y+STATUS_BAR_H+30, native.systemFontBold, 20 )

	status = display.newText( "", H_CENTER, SCREEN_Y+SCREEN_H-30, native.systemFont, 16 )
end

local function setStatus( text )
	status.text = text
end


local function onPress_handler( event )
	print( 'Main: onPress_handler: id', event.id )
	setStatus( "pressed: "..event.id )
end

local function onRelease_handler( event )
	print( 'Main: onRelease_handler: id', event.id )
	setStatus( "released: "..event.id )
end



--===================================================================--
--== Main
--===================================================================--


setupBackground()
setStatus( "press a button" )


--== "Back": the label changes color and alignment while pressed

local bn = dUI.newPushButton{
	id='button-back',
	labelText="Back",
	style={
		width=100,
		height=50,
		marginX=10,
		active={
			align='right',
			label={ textColor=dUI.Palette.red },
		},
	},
	onPress=onPress_handler,
	onRelease=onRelease_handler,
}
bn.x, bn.y = H_CENTER, V_CENTER-150


--== "Middle": a hit area larger than the button, shown by debugOn

bn = dUI.newPushButton{
	id='button-middle',
	labelText="Middle",
	style={
		debugOn=true,
		width=152,
		height=50,
		hitMarginX=20,
		hitMarginY=15,
		active={
			label={ textColor=dUI.Palette.orange },
		},
	},
	onPress=onPress_handler,
	onRelease=onRelease_handler,
}
bn.x, bn.y = H_CENTER, V_CENTER-50


--== "Orange": each state has its own alignment and offset

bn = dUI.newPushButton{
	id='button-orange',
	labelText="Orange",
	style={
		width=152,
		height=50,
		marginX=10,
		inactive={
			align='right',
			offsetX=-5,
			offsetY=-3,
			label={ textColor=dUI.Palette.orange },
		},
		active={
			align='left',
			offsetX=10,
			offsetY=0,
			label={ textColor=dUI.Palette.yellow },
		},
	},
	onPress=onPress_handler,
	onRelease=onRelease_handler,
}
bn.x, bn.y = H_CENTER, V_CENTER+50


--== "Disabled": the disabled style; presses are ignored

bn = dUI.newPushButton{
	id='button-disabled',
	labelText="Disabled",
	style={
		width=152,
		height=50,
		disabled={
			label={
				font=native.systemFontBold,
				textColor=dUI.Palette.gray,
			},
		},
	},
	onPress=onPress_handler,
	onRelease=onRelease_handler,
}
bn.x, bn.y = H_CENTER, V_CENTER+150
bn.isEnabled = false
