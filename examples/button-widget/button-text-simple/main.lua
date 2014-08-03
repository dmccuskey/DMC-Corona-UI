--====================================================================--
--Image Simple Text Button
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
	print( 'Main: onPress_handler: id', event.id )
end

local function onRelease_handler( event )
	print( 'Main: onRelease_handler: id', event.id )
end

local function onEvent_handler( event )
	print( 'Main: onEvent_handler: id', event.id, event.phase )
end



--===================================================================--
-- Main
--===================================================================--


--== Create Buttons

--[[
	button shows:
	* simple label
	* more complex 'active' view (alignment, color)
--]]
o = Widgets.newButton{
	-- button info
	type='push',
	width = 100,
	height = 56,
	id='button-back',

	-- label info
	label = "Back",

	-- view info
	active = {
		label = {
			color={1,0,0},
			align='right',
		},
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
	* more complex 'active' view (label change)
	* bigger hit area
--]]
o = Widgets.newButton{
	-- button info
	type='push',
	width = 152,
	height = 56,
	id='button-middle',

	-- label info
	label = {
		text='Middle',
		y_offset=-3
	},

	-- view info
	active = {
		label = {
			text='pressed',
			color={1,0.2,0}
		},
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
	* more complex 'active' view (label change)
--]]
o = Widgets.newButton{
	-- button info
	type='push',
	width = 152,
	height = 56,
	id='button-orange',

	-- label info
	label = {
		text='Orange',
		align='right',
		x_offset=-15,
		y_offset=-3,
		color={1,0.2,0}
	},

	-- view info
	active = {
		label = {
			text='pressed',
			align='left',
			x_offset=20,
			color={1,1,0}
		},
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
	* more complex 'active' view (label change)
--]]
o = Widgets.newButton{
	type='push',
	width = 152,
	height = 56,
	id='button-middle',

	-- label info
	label = 'Middle',

	-- view info
	active = {
		label = {
			text='pressed',
			color={0,0,0}
		},
	},
	disabled = {
		label = {
			text='disabled',
			font=native.systemFontBold,
			color={0.6,0.6,0.6}
		},
	},

	-- handlers
	onPress = onPress_handler,
	onRelease = onRelease_handler,
	onEvent = onEvent_handler,

}
o.x, o.y = 150, 400
o.enabled = false

