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


local W, H = display.contentWidth, display.contentHeight
local H_CENTER, V_CENTER = W*0.5, H*0.5



--===================================================================--
--== Support Functions


-- Setup Visual Screen Items
--
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


local function widgetOnPropertyEvent_handler( event )
	print( 'Main: widgetOnPropertyEvent_handler', event.id, event.phase )
	local etype= event.type
	local property= event.property
	local value = event.value

	print( "Widget Property Changed", etype, property, value )

end

local function widgetEvent_handler( event )
	print( 'Main: widgetEvent_handler', event.id, event.phase )
	local etype= event.type

	print( "Widget Event", etype )

end



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


setupBackground()


-- src={
-- 	debugOn=true,

-- 	width=100,
-- 	height=50,


-- }

-- dest = {

-- 	width=50
-- }

-- in borroing from lower classes, upper needs to override

-- in dest:
-- if src~= nil then dest=src end


-- style={
-- 	align='right'
-- }

--======================================================--
--== create textfield widget, default style

function run_example1()

	local btn1


	btn1 = Widgets.newPushButton{
		-- button info
		x=100,
		y=50,

		id='button-top',
		labelText="Press",

		data="your data",

		style = {
			debugOn=true,

			width=100,
			height=50,

			align='center',
			anchorX=0.5,
			anchorY=0.5,
			hitMarginX=10,
			hitMarginY=10,
			isHitActive=true,
			offsetX=0,
			offsetY=0,

			label={
				text="hello",
				fontColor={1,0,1},
			},

			background = {
			 view={

				}
			},

			inactive = {
				label = {
					align='right',
					textColor={0,0,0},
				},
				background={
					view={
						type='rounded',
						fillColor={0.2,0.5,0.5}
					}
				}
			},


			active = {
				label = {
					align='right',
					textColor={0,0,0},
				},
				background={
					view={
						type='rounded',
						fillColor={0,1,0}
					}
				}
			},

			disabled = {
				label = {
					align='right',
					textColor={0,0,0},
				},
				background={
					view={
						type='rounded',
						fillColor={0,1,0}
					}
				}
			},

		},

		-- handlers
		onPress = onPress_handler,
		onRelease = onRelease_handler,
		onEvent = onEvent_handler,

	}
	btn1.x, btn1.y = H_CENTER, V_CENTER


	timer.performWithDelay( 1000, function()
		print( "\n\n\nProperties Updated")
		-- btn1:setLabelColor( 1,1,1)
		-- btn1.strokeWidth=6
		-- btn1.strokeColor={0,0,0}

		print("SETTING HIT MARGING")
		btn1.hitMarginY=20

		print("SETTING ANCHOR")
		btn1.anchorX=1

		-- btn1:setAnchor({1,1})
		-- btn1.width=200
		-- btn1.height=100

	end)

	-- timer.performWithDelay( 2000, function()
	-- 	btn1:clearStyle()
	-- end)

end

run_example1()

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

