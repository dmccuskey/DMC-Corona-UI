--====================================================================--
-- Shape Button Simple
--
-- Shows simple use of the DMC Widget: Button
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2014-2015 David McCuskey. All Rights Reserved.
--====================================================================--



print( "\n\n#########################################################\n\n" )



--===================================================================--
--== Imports


local Widgets = require 'lib.dmc_widgets'



--===================================================================--
--== Setup, Constants


local o



--===================================================================--
--== Support Functions


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


--[[

text
action='push' or 'toggle'

style={

	width = 75,
	height = 30,

	type='rectangle', -- shape, 9slice, image,
	type='rounded', -- shape, 9slice, image,
	type='circle', -- shape, 9slice, image,
	type='polygon', -- shape, 9slice, image,
	type='9-slice', -- shape, 9slice, image,
	type='image', -- shape, 9slice, image,

	cornerRadius = 10,
	fillColor={1,1,0.5, 0.5},
	strokeWidth=6,
	strokeColor={1,0,0,0.5},

	default={

	}

	active = {

		label = {
			align='right',
			textColor={0,0,0},
		},

		fillColor={1,0,0},
		cornerRadius = 2,
	},

	disabled={

	}


}


--]]



o = Widgets.newPushButton{
	-- button info
	id='button-top',

	style={
		width = 75,
		height = 30,

		type='rectangle',

		default ={
			label={
				textColor={1,0,0},
				font=native.systemFontBold,
				fontSize=10
			},
			background={
				cornerRadius=10,
				fillColor={1,1,0.5, 0.5},
				strokeWidth=6,
				strokeColor={1,0,0,0.5},
			}
		},


		inactive = {
		},


		active = {
			label = {
				align='right',
				textColor={0,0,0},
			},
			background={

			}
		},

	},

	-- handlers
	onPress = onPress_handler,
	onRelease = onRelease_handler,
	onEvent = onEvent_handler,

}
o.x, o.y = 150, 75



--== Create Buttons

-- --[[
-- 	button shows:
-- 	* simple label
-- 	* more complex 'active' view (alignment, color)
-- --]]
-- o = Widgets.newButton{
-- 	-- button info
-- 	id='button-top',
-- 	type='push',

-- 	-- label info
-- 	label = { },

-- 	-- view info
-- 	view='shape',
-- 	width = 75,
-- 	height = 30,
-- 	shape='roundedRect',
-- 	corner_radius = 10,
-- 	fill_color={1,1,0.5, 0.5},
-- 	stroke_width=6,
-- 	stroke_color={1,0,0,0.5},

-- 	active = {
-- 		label = {
-- 			color={0,0,0},
-- 			align='right',
-- 		},
-- 		fill_color={1,0,0},
-- 		corner_radius = 2,
-- 	},

-- 	-- handlers
-- 	onPress = onPress_handler,
-- 	onRelease = onRelease_handler,
-- 	onEvent = onEvent_handler,
-- }
-- o.x, o.y = 150, 75


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
-- 		align='center',
-- 		-- margin = 0,
-- 		x_offset = 0,
-- 		y_offset = 0,
-- 		color = { 1,0,0.5 },
-- 		font = native.systemFontBold,
-- 		font_size = 20,
-- 	},

-- 	-- view info
-- 	view='shape',
-- 	width = 100,
-- 	height = 60,
-- 	shape='roundedRect',
-- 	corner_radius = 2,
-- 	fill_color={1,1,0.5, 0.5},
-- 	stroke_width=2,
-- 	stroke_color={1,0,0,0.5},

-- 	active = {
-- 		label = {
-- 			text='pressed',
-- 			color={0,0,0}
-- 		},
-- 		fill_color={1,0,0}
-- 	},

-- 	-- handlers
-- 	onPress = onPress_handler,
-- 	onRelease = onRelease_handler,
-- 	onEvent = onEvent_handler,
-- }
-- o.x, o.y = 150, 225


-- --[[
-- 	button shows:
-- 	* disabled state
-- 	* more complex 'active' view (label change)
-- 	* bigger hit area
-- --]]

-- o = Widgets.newButton{
-- 	-- button info
-- 	id='button-bottom',
-- 	type='push',

-- 	-- label stuff
-- 	label ="Bottom",

-- 	-- view info
-- 	view='shape',
-- 	width = 100,
-- 	height = 60,
-- 	shape='roundedRect',
-- 	corner_radius = 4,
-- 	fill_color={1,1,0.5, 0.5},
-- 	stroke_width=4,
-- 	stroke_color={0.75,0.75,0.75,0.5},

-- 	disabled = {
-- 		label = {
-- 			text="Disabled",
-- 			color={0.5,0.5,0.5},
-- 			font = native.systemFontItalic,
-- 		},
-- 		fill_color={0.1, 0.1, 0.1}
-- 	},

-- 	-- handlers
-- 	onPress = onPress_handler,
-- 	onRelease = onRelease_handler,
-- 	onEvent = onEvent_handler,
-- }
-- o.x, o.y = 150, 375
-- o.enabled = false

