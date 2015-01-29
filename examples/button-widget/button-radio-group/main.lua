--====================================================================--
-- Radio Group Simple
--
-- Shows simple use of the DMC Widget: Button Group
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2014 David McCuskey. All Rights Reserved.
--====================================================================--


print( "\n\n#########################################################\n\n" )


--===================================================================--
--== Imports

local Widgets = require 'lib.dmc_widgets'
local Utils = require 'dmc_utils'

--===================================================================--
--== Setup, Constants

local o


--===================================================================--
-- Support Functions

local function radioGroupEvent_handler( event )
	print( 'Main: radioGroupEvent_handler: type', event.type )
	print( 'Main: button: ', event.id, event.state )

	local group = event.target
	local button = event.button

end



--===================================================================--
-- Main
--===================================================================--


local radioGroup = Widgets.newButtonGroup{ type='radio' }


-- we only need to listen to the group
radioGroup:addEventListener( radioGroup.EVENT, radioGroupEvent_handler )


--== Create Buttons

--[[
	button shows:
	* complex label
	* more complex 'down' view (label change)
	* bigger hit area
--]]
o = Widgets.newButton{
	-- button info
	id='button-middle',
	type='radio',
	hit_width = 150,
	hit_height = 110,


	-- label info
	label = {
		text='Inactive',
		align='center',
		-- margin = 0,
		x_offset = 0,
		y_offset = 0,
		color = { 1,0,0.5 },
		font = native.systemFontBold,
		font_size = 20,
	},

	-- view info
	view='shape',
	width = 100,
	height = 60,
	shape='roundedRect',
	corner_radius = 2,
	fill_color={1,1,0.5, 0.5},
	stroke_width=2,
	stroke_color={1,0,0,0.5},

	active = {
		label = {
			text='Active',
			color={0,0,0}
		},
		fill_color={1,0,0}
	},

	-- handlers
	onPress = onPress_handler,
	onRelease = onRelease_handler,
	onEvent = onEvent_handler,

}
o.x, o.y = 150, 75

radioGroup:add( o )



--[[
	button shows:
	* complex label
	* more complex 'down' view (label change)
	* bigger hit area
--]]
o = Widgets.newButton{
	-- button info
	id='button-bottom',
	type='radio',
	hit_width = 150,
	hit_height = 110,

	-- label info
	label = {
		text='Inactive',
		align='center',
		-- margin = 0,
		x_offset = 0,
		y_offset = 0,
		color = { 1,0,0.5 },
		font = native.systemFontBold,
		font_size = 20,
	},

	-- view info
	view='shape',
	width = 100,
	height = 60,
	shape='roundedRect',
	corner_radius = 2,
	fill_color={1,1,0.5, 0.5},
	stroke_width=2,
	stroke_color={1,0,0,0.5},

	active = {
		label = {
			text='Active',
			color={0,0,0}
		},
		fill_color={1,0,0}
	},

	-- handlers
	onPress = onPress_handler,
	onRelease = onRelease_handler,
	onEvent = onEvent_handler,

}
o.x, o.y = 150, 150

radioGroup:add( o )




local toggleGroup = Widgets.newButtonGroup{ type='toggle' }


-- we only need to listen to the group
toggleGroup:addEventListener( toggleGroup.EVENT, radioGroupEvent_handler )

--[[
	button shows:
	* complex label
	* more complex 'down' view (label change)
	* bigger hit area
--]]
o = Widgets.newButton{
	-- button info
	id='button-middle',
	type='toggle',
	hit_width = 150,
	hit_height = 110,

	-- label info
	label = {
		text='Inactive',
		align='center',
		-- margin = 0,
		x_offset = 0,
		y_offset = 0,
		color = { 1,0,0.5 },
		font = native.systemFontBold,
		font_size = 20,
	},

	-- view info
	view='shape',
	width = 100,
	height = 60,
	shape='roundedRect',
	corner_radius = 2,
	fill_color={1,1,0.5, 0.5},
	stroke_width=2,
	stroke_color={1,0,0,0.5},

	active = {
		label = {
			text='Inactive',
			color={0,0,0}
		},
		fill_color={1,0,0}
	},

	-- handlers
	onPress = onPress_handler,
	onRelease = onRelease_handler,
	onEvent = onEvent_handler,

}
o.x, o.y = 150, 275

toggleGroup:add( o )



--[[
	button shows:
	* complex label
	* more complex 'down' view (label change)
	* bigger hit area
--]]
o = Widgets.newButton{
	-- button info
	id='button-bottom',
	type='toggle',
	hit_width = 150,
	hit_height = 110,

	-- label stuff
	label = {
		text='Inactive',
		align='center',
		-- margin = 0,
		x_offset = 0,
		y_offset = 0,
		color = { 1,0,0.5 },
		font = native.systemFontBold,
		font_size = 20,
	},

	-- view info
	view='shape',
	width = 100,
	height = 60,
	shape='roundedRect',
	corner_radius = 2,
	fill_color={1,1,0.5, 0.5},
	stroke_width=2,
	stroke_color={1,0,0,0.5},

	active = {
		label = {
			text='Active',
			color={0,0,0}
		},
		fill_color={1,0,0}
	},

	-- handlers
	onPress = onPress_handler,
	onRelease = onRelease_handler,
	onEvent = onEvent_handler,

}
o.x, o.y = 150, 350

toggleGroup:add( o )


