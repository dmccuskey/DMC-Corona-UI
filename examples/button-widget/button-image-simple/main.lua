--====================================================================--
-- Simple Image Button
--
-- Shows basic use of the DMC Widget: Button
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


--======================================================--
-- Button Handlers

local function onPress_handler( event )
	print( 'Main: onPress_handler: id', event.id )
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
				type='image',
				background={
					width=0,
					height=0,
					imagePath='asset/image/btn_bg_orange.png',
					-- offsetBottom=10
				}
			},
			active={
				type='image',
				background={
					width=0,
					height=0,
					imagePath='asset/image/btn_bg_orange_down.png',
					-- offsetBottom=10
				}
			}
		}
	}
	bn2.x, bn2.y = H_CENTER+offsetX, V_CENTER-offsetY

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

