--====================================================================--
--Image Simple Image Button
--
-- Shows basic use of the DMC Widget: Button
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2014 David McCuskey. All Rights Reserved.
--====================================================================--


print( "\n\n#########################################################\n\n" )


--===================================================================--
--== Imports

local Widgets = require 'lib.dmc_widgets'


--===================================================================--
--== Setup, Constants

local o


--===================================================================--
-- Support Functions

local function onPress_handler( event )
	print( 'onPress_handler: id', event.id )
end

local function onRelease_handler( event )
	print( 'onRelease_handler: id', event.id )
end

local function onEvent_handler( event )
	print( 'onEvent_handler' )
	print( 'button id', event.id, event.phase )
end



--===================================================================--
-- Main
--===================================================================--


--== Create Buttons

--[[
	button shows:
	* simple label
	* more complex 'down' view (alignment, color)
--]]
o = Widgets.newButton{
	id='button-back',
	type='push',

	-- label stuff
	label = "Back",

	-- dimension info
	file = 'asset/image/btn_back.png',
	-- base_dir = 'asset/image/btn_back.png',
	width = 55,
	height = 38,

	down = {
		label = {
			color={0,0,0},
			align='right',
		},
		file = 'asset/image/btn_back_down.png',
	},

	-- handlers
	onPress = onPress_handler,
	onRelease = onRelease_handler,
	onEvent = onEvent_handler,
}
o.x, o.y = 150, 70


--[[
	button shows:
	* complex label
	* more complex 'down' view (label change)
	* bigger hit area
--]]
o = Widgets.newButton{
	id='button-middle',
	type='push',

	-- label stuff
	label = {
		text='Middle',
		y_offset=-3
	},

	-- dimension info
	file = 'asset/image/btn_bg_green.png',
	-- base_dir = 'asset/image/btn_back.png',
	width = 152,
	height = 56,

	hit_width = 150,
	hit_height = 110,

	down = {
		label = {
			text='pressed',
			color={0,0,0}
		},
		file = 'asset/image/btn_bg_green_down.png',
	},

	-- handlers
	onPress = onPress_handler,
	onRelease = onRelease_handler,
	onEvent = onEvent_handler,

}
o.x, o.y = 150, 175


--[[
	button shows:
	* complex label
	* more complex 'down' view (label change)
--]]
o = Widgets.newButton{
	id='button-middle',
	type='push',

	-- label stuff
	label = {
		text='Orange',
		align='right',
		x_offset=-15,
		y_offset=-3,
	},

	-- dimension info
	file = 'asset/image/btn_bg_orange.png',
	-- base_dir = 'asset/image/btn_back.png',
	width = 152,
	height = 56,

	down = {
		label = {
			text='pressed',
			align='left',
			x_offset=20,
			color={0,0,0}
		},
		file = 'asset/image/btn_bg_orange_down.png',
	},

	-- handlers
	onPress = onPress_handler,
	onRelease = onRelease_handler,
	onEvent = onEvent_handler,

}
o.x, o.y = 150, 300


--[[
	button shows:
	* complex label
	* more complex 'down' view (label change)
--]]
o = Widgets.newButton{
	id='button-middle',
	type='push',

	-- label stuff
	label = 'Middle',

	-- dimension info
	file = 'asset/image/btn_bg_green.png',
	-- base_dir = 'asset/image/btn_back.png',
	width = 152,
	height = 56,

	down = {
		label = {
			text='pressed',
			color={0,0,0}
		},
		file = 'asset/image/btn_bg_green_down.png',
	},
	disabled = {
		label = {
			text='',
			color={0,0,0}
		},
		file = 'asset/image/btn_coming_soon.png',
	},

	-- handlers
	onPress = onPress_handler,
	onRelease = onRelease_handler,
	onEvent = onEvent_handler,

}
o.x, o.y = 150, 400
o.enabled = false

