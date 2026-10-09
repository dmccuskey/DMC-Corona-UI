--====================================================================--
-- Simple Image Button
--
-- An "OK" push button made of two images, orange and a darker orange
-- while pressed (asset/image/). A background width and height of 0 draws
-- each image at its own size. The line at the bottom names each press and
-- release (also printed). The backdrop fills the screen on any device.
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

	o = display.newText( "Simple Image Button", H_CENTER, SCREEN_Y+STATUS_BAR_H+30, native.systemFontBold, 20 )

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
	setStatus( "pressed: the darker image" )
end

local function onRelease_handler( event )
	print( 'Main: onRelease_handler: id', event.id )
	setStatus( "released" )
end

local function onEvent_handler( event )
	print( 'Main: onEvent_handler: id', event.id, event.phase )
end



--===================================================================--
--== Main
--===================================================================--


setupBackground()




--======================================================--
--== Example 1: create button widget, default style

function run_example1()

	local offsetX, offsetY = 70, 100

	local bn2 = dUI.newPushButton{
		onPress = onPress_handler,
		onRelease = onRelease_handler,
		onEvent = onEvent_handler,

		style={
			debugOn=false,
			width=100,
			height=30,
			inactive={
				background={
					type='image',
					width=0,
					height=0,
					view={
						imagePath='asset/image/btn_bg_orange.png',
					}
				}
			},
			active={
				background={
					type='image',
					width=0,
					height=0,
					view={
						imagePath='asset/image/btn_bg_orange_down.png',
					}
				}
			}
		}
	}
	bn2.x, bn2.y = H_CENTER+offsetX, V_CENTER-offsetY
	setStatus( "press the button" )

end

run_example1()


-- --== Create Buttons

-- --[[
-- 	button shows:
-- 	* simple label
-- 	* more complex 'active' view (alignment, color)
-- --]]
-- o = Widgets.newButton{
-- 	-- button info
-- 	id='button-back',
-- 	type='push',

-- 	-- label info
-- 	label = "Back",

-- 	-- view info
-- 	view='image',
-- 	file = 'asset/image/btn_back.png',
-- 	fill_color={1,0,0},
-- 	-- base_dir = 'asset/image/btn_back.png',
-- 	width = 55,
-- 	height = 38,

-- 	active = {
-- 		label = {
-- 			color={0,0,0},
-- 			align='right',
-- 		},
-- 		file = 'asset/image/btn_back_down.png',
-- 	},

-- 	-- handlers
-- 	onPress = onPress_handler,
-- 	onRelease = onRelease_handler,
-- 	onEvent = onEvent_handler,
-- }
-- o.x, o.y = 150, 70


-- --[[
-- 	button shows:
-- 	* complex label
-- 	* more complex 'active' view (label change)
-- 	* bigger hit area
-- --]]
-- o = Widgets.newButton{
-- 	-- button info
-- 	id='button-middle',
-- 	type='push',
-- 	hit_width = 150,
-- 	hit_height = 110,

-- 	-- label info
-- 	label = {
-- 		text='Middle',
-- 		y_offset=-3
-- 	},

-- 	-- view info
-- 	view='image',
-- 	file = 'asset/image/btn_bg_green.png',
-- 	width = 152,
-- 	height = 56,

-- 	active = {
-- 		label = {
-- 			text='pressed',
-- 			color={0,0,0}
-- 		},
-- 		file = 'asset/image/btn_bg_green_down.png',
-- 	},

-- 	-- handlers
-- 	onPress = onPress_handler,
-- 	onRelease = onRelease_handler,
-- 	onEvent = onEvent_handler,

-- }
-- o.x, o.y = 150, 175


-- --[[
-- 	button shows:
-- 	* complex label
-- 	* more complex 'active' view (label change)
-- --]]
-- o = Widgets.newButton{
-- 	-- button info
-- 	id='button-orange',
-- 	type='push',

-- 	-- label info
-- 	label = {
-- 		text='Orange',
-- 		align='right',
-- 		x_offset=-15,
-- 		y_offset=-3,
-- 	},

-- 	-- view info
-- 	view='image',
-- 	file = 'asset/image/btn_bg_orange.png',
-- 	width = 152,
-- 	height = 56,

-- 	active = {
-- 		label = {
-- 			text='pressed',
-- 			align='left',
-- 			x_offset=20,
-- 			color={0,0,0}
-- 		},
-- 		file = 'asset/image/btn_bg_orange_down.png',
-- 	},

-- 	-- handlers
-- 	onPress = onPress_handler,
-- 	onRelease = onRelease_handler,
-- 	onEvent = onEvent_handler,

-- }
-- o.x, o.y = 150, 300


-- --[[
-- 	button shows:
-- 	* complex label
-- 	* more complex 'active' view (label change)
-- --]]
-- o = Widgets.newButton{
-- 	-- button info
-- 	id='button-middle',
-- 	type='push',

-- 	-- label info
-- 	label = 'Middle',

-- 	-- view info
-- 	view='image',
-- 	file = 'asset/image/btn_bg_green.png',
-- 	width = 152,
-- 	height = 56,

-- 	active = {
-- 		label = {
-- 			text='pressed',
-- 			color={0,0,0}
-- 		},
-- 		file = 'asset/image/btn_bg_green_down.png',
-- 	},
-- 	disabled = {
-- 		label = {
-- 			text='',
-- 			color={0,0,0}
-- 		},
-- 		file = 'asset/image/btn_coming_soon.png',
-- 	},

-- 	-- handlers
-- 	onPress = onPress_handler,
-- 	onRelease = onRelease_handler,
-- 	onEvent = onEvent_handler,

-- }
-- o.x, o.y = 150, 400
-- o.enabled = false

