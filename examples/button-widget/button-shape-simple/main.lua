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


--======================================================--
--== Example 1: create textfield widget, default style

function run_example1()

	local offsetX, offsetY = 70, 100

	local s1 = Widgets.newButtonStyle{
		debugOn=false,
		width=100,
		height=50,
		-- align='right',
		marginX=0,
		inactive={
			-- width=200,
			-- height=200,
			label={},
			background={
				-- width=200,
				-- height=200,
				type='rounded',
				view={
					-- width=200,
					-- height=200
				}
			}
		}
	}

	local bn1 = Widgets.newButton()
	bn1.style = s1

	local bn2 = Widgets.newPushButton()
	local bn3 = Widgets.newRadioButton()
	local bn4 = Widgets.newToggleButton()

	bn1.x, bn1.y = H_CENTER-offsetX, V_CENTER-offsetY
	bn2.x, bn2.y = H_CENTER+offsetX, V_CENTER-offsetY
	bn3.x, bn3.y = H_CENTER-offsetX, V_CENTER+offsetY
	bn4.x, bn4.y = H_CENTER+offsetX, V_CENTER+offsetY

	timer.performWithDelay( 100000, function()
		-- bn1:removeSelf()
		-- bn2:removeSelf()
		-- bn3:removeSelf()
		-- bn4:removeSelf()
	end)

end

run_example1()


--======================================================--
--== Example 2: create textfield widget, default style

function run_example2()

	local btn1


	btn1 = Widgets.newPushButton{
		-- button info
		x=100,
		y=50,

		id='button-top',
		labelText="Press",

		data="your data",

		style = {
			debugOn=false,

			width=100,
			height=50,

			align='center',
			anchorX=0.5,
			anchorY=0.5,
			hitMarginX=10,
			hitMarginY=10,
			isHitActive=true,
			marginX=10,
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
					align='center',
					textColor={0,0,0},
				},
				background={
					type='rectangle',
					view={
						fillColor={0.7,0.7,0.7,1},
						strokeColor={1,1,0,1},
						strokeWidth=6
					}
				}
			},


			active = {
				label = {
					align='center',
					textColor={0.4,0.2,1,},
				},
				background={
					type='rounded',
					view={
						fillColor={0,1,0}
					}
				}
			},

			disabled = {
				label = {
					align='center',
					textColor={0,0,0},
				},
				background={
					type='rounded',
					view={
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
		print( "\n\n\n Properties Updated")
		-- btn1:setLabelColor( 1,1,1)
		-- btn1.strokeWidth=6
		-- btn1.strokeColor={0,0,0}

		btn1.hitMarginY=20

		btn1.anchorX=1
		btn1.anchorY=0

		-- btn1:setAnchor({1,1})
		-- btn1.width=200
		-- btn1.height=100

	end)

	timer.performWithDelay( 2000, function()
		btn1:setAnchor( {0,0} )
		btn1:setAnchor( {0.5,0.5} )
		btn1:setAnchor( {1,1} )
		btn1.hitMarginY=5
	end)

-- timer.performWithDelay( 2000, function()
-- 	btn1:clearStyle()
-- end)

-- timer.performWithDelay( 2000, function()
-- 	btn1:clearStyle()
-- end)

end

-- run_example2()



--======================================================--
--== Example 3:

function run_example3()

	local st1, bw1

	st1 = Widgets.newButtonStyle{
		debugOn=false,
		width=100,
		height=50,
		anchorX=0.5,
		anchorY=0.5,

		align='center',
		hitMarginX=10,
		hitMarginY=10,
		isHitActive=true,
		marginX=10,
		marginY=10,

		inactive = {
			label = {
				font=native.systemFont,
				fontSize=14,
				align='center',
				textColor={0.5,0.2,0, 1},
			},
			background={
				type='rectangle',
				view={
					fillColor={0.5,1,0.7,1},
					strokeColor={0.5,0,0,1},
					strokeWidth=6
				}
			}
		},

		active = {
			label = {
				align='left',
				font=native.systemFontBold,
				fontSize=10,
				textColor={0.4,0.2,1,},
			},
			background={
				type='rounded',
				view={
					fillColor={0,1,0}
				}
			}
		},

		disabled = {
			label = {
				align='center',
				fontSize=12,
				textColor={1,1,0.5},
			},
			background={
				type='rectangle',
				view={
					fillColor={0,1,0}
				}
			}
		},
	}

	bw1 = Widgets.newButton{
		id="hello-world",
		data=43,
		-- style=st1,
		labelText="Press Me",
		onPress = onPress_handler,
		onRelease = onRelease_handler,
		onEvent = onEvent_handler,
	}

	bw1.x, bw1.y = H_CENTER-70, V_CENTER-50

	bw2 = Widgets.newButton{
		id="hello-world",
		data=43,
		style=st1,
		labelText="Press Me",
		onPress = onPress_handler,
		onRelease = onRelease_handler,
		onEvent = onEvent_handler,
	}
	bw2.style.inactive.background.fillColor={ 0.4, 0.5, 0.6 }

	bw2.x, bw2.y = H_CENTER+40, V_CENTER-50

	-- bw1.isEnabled = false

	-- bw1:clearStyle()
	-- bw2:clearStyle()

	-- print( bw1.__curr_style, bw1.__curr_style._inherit, st1 )

	timer.performWithDelay( 10000, function()
		print("\n\n Update Widget")
		-- bw1.isEnabled = true
		st1.inactive.background.fillColor = {1,1,0}

	end)

	timer.performWithDelay( 2000, function()
		print("\n\n Clear Styles")
		-- bw1.isEnabled = true
		-- bw1:clearStyle()

		print( "wid", bw2.__curr_style._inherit, st1 )

		-- st1:clearProperties()

		bw2:clearStyle()

	end)

	timer.performWithDelay( 6000, function()
		print("\n\n Disable Widget")
		-- bw1.isEnabled = false
		print( unpack( 	st1.inactive.background.view.fillColor ))
	end)

	timer.performWithDelay( 10000, function()
		print("\n\n Clear Style")
		-- st1:clearProperties()
	end)


	-- timer.performWithDelay( 10000, function()
	-- 	bw1:removeSelf()
	-- 	st1:removeSelf()
	-- end)

end

-- run_example3()


--======================================================--
--== Example 4:

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

