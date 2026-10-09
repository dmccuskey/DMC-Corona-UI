--====================================================================--
-- Shape Button Simple
--
-- A "Press" button drawn with shapes: a light rectangle with a yellow
-- stroke, a green rounded rectangle while pressed (colors from dUI.Palette).
-- The red dot marks its position, at the center of the screen: after two
-- seconds its anchor becomes (1,0) and its hit margin grows, after four the
-- anchor is (1,1), so the button moves to the top left of the dot. The line
-- at the bottom names each step. run_example1() shows the four button types,
-- one with a style object; run_example3() a shared style and clearStyle().
-- The backdrop fills the screen on any device.
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


-- Setup Visual Screen Items
--
-- a backdrop the size of the screen, the example's name at the top,
-- a line at the bottom which says what the widget shows (setStatus()),
-- and a marker at the screen's center, a white box with a red dot,
-- which makes a change of the widget's anchor easy to see
--
local function setupBackground()
	local o

	o = display.newRect( H_CENTER, V_CENTER, SCREEN_W, SCREEN_H )
	o:setFillColor( 0.17, 0.24, 0.31 )

	o = display.newText( "Shape Button Simple", H_CENTER, SCREEN_Y+STATUS_BAR_H+30, native.systemFontBold, 20 )

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
--== Example 1: create button widget, default style

function run_example1()

	local offsetX, offsetY = 70, 100

	local s1 = dUI.newButtonStyle{
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
				fillColor=dUI.Palette.red,
					-- width=200,
					-- height=200
				}
			}
		}
	}

	local bn1 = dUI.newButton()
	bn1.style = s1

	local bn2 = dUI.newPushButton()
	bn2.style=nil
	bn2.style=nil

	local bn3 = dUI.newRadioButton()
	local bn4 = dUI.newToggleButton()

	bn1.x, bn1.y = H_CENTER-offsetX, V_CENTER-offsetY
	bn2.x, bn2.y = H_CENTER+offsetX, V_CENTER-offsetY
	bn3.x, bn3.y = H_CENTER-offsetX, V_CENTER+offsetY
	bn4.x, bn4.y = H_CENTER+offsetX, V_CENTER+offsetY
	setStatus( "plain, push, radio, toggle" )

	timer.performWithDelay( 100000, function()
		-- bn1:removeSelf()
		-- bn2:removeSelf()
		-- bn3:removeSelf()
		-- bn4:removeSelf()
	end)

end

-- run_example1()


--======================================================--
--== Example 2: create button widget, default style

function run_example2()

	local btn1


	btn1 = dUI.newPushButton{
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

			-- label={
			-- 	text="hello",
			-- 	fontColor={1,0,1},
			-- },

			-- background = {
			--  view={

			-- 	}
			-- },

			inactive = {
				width=100,
				label = {
					align='center',
					textColor=dUI.Palette.slateDark,
				},
				background={
					type='rectangle',
					view={
						fillColor=dUI.Palette.cloud,
						strokeColor=dUI.Palette.yellow,
						strokeWidth=6
					}
				}
			},


			active = {
				label = {
					align='center',
					textColor=dUI.Palette.cloud,
				},
				background={
					type='rounded',
					view={
						fillColor=dUI.Palette.green
					}
				}
			},

			disabled = {
				label = {
					align='center',
					textColor=dUI.Palette.gray,
				},
				background={
					type='rounded',
					view={
						fillColor=dUI.Palette.cloudDark
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
	setStatus( "anchor (0.5,0.5)" )


	timer.performWithDelay( 2000, function()
		print( "\n\n\n Properties Updated")
		-- btn1:setLabelColor( 1,1,1)
		-- btn1.strokeWidth=6
		-- btn1.strokeColor={0,0,0}

		btn1.hitMarginY=20

		-- btn1.width=100
		-- btn1.height=50

		btn1.anchorX=1
		btn1.anchorY=0

		-- btn1:setAnchor({1,1})
		-- btn1.width=200
		-- btn1.height=100
		setStatus( "anchor (1,0), hitMarginY 20" )

	end)

	timer.performWithDelay( 4000, function()
		btn1:setAnchor( {0,0} )
		btn1:setAnchor( {0.5,0.5} )
		btn1:setAnchor( {1,1} )
		btn1.hitMarginY=5
		setStatus( "anchor (1,1), hitMarginY 5" )
	end)

-- timer.performWithDelay( 2000, function()
-- 	btn1:clearStyle()
-- end)

-- timer.performWithDelay( 2000, function()
-- 	btn1:clearStyle()
-- end)

end

run_example2()



--======================================================--
--== Example 3:

function run_example3()

	local st1, bw1, bw2

	st1 = dUI.newButtonStyle{
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
				textColor=dUI.Palette.slateDark,
			},
			background={
				type='rectangle',
				view={
					fillColor=dUI.Palette.teal,
					strokeColor=dUI.Palette.tealDark,
					strokeWidth=6
				}
			}
		},

		active = {
			label = {
				align='left',
				font=native.systemFontBold,
				fontSize=10,
				textColor=dUI.Palette.cloud,
			},
			background={
				type='rounded',
				view={
					fillColor=dUI.Palette.green
				}
			}
		},

		disabled = {
			label = {
				align='center',
				fontSize=12,
				textColor=dUI.Palette.gray,
			},
			background={
				type='rectangle',
				view={
					fillColor=dUI.Palette.cloudDark
				}
			}
		},
	}

	bw1 = dUI.newButton{
		id="hello-world",
		data=43,
		-- style=st1,
		labelText="Press Me",
		onPress = onPress_handler,
		onRelease = onRelease_handler,
		onEvent = onEvent_handler,
	}

	bw1.x, bw1.y = H_CENTER-70, V_CENTER-50

	bw2 = dUI.newButton{
		id="hello-world",
		data=43,
		style=st1,
		labelText="Press Me",
		onPress = onPress_handler,
		onRelease = onRelease_handler,
		onEvent = onEvent_handler,
	}
	bw2.style.inactive.background.fillColor=dUI.Palette.gray

	bw2.x, bw2.y = H_CENTER+40, V_CENTER-50
	setStatus( "default style, and a style object" )

	-- bw1.isEnabled = false

	-- bw1:clearStyle()
	-- bw2:clearStyle()

	-- print( bw1.__curr_style, bw1.__curr_style._inherit, st1 )

	timer.performWithDelay( 10000, function()
		print("\n\n Update Widget")
		-- bw1.isEnabled = true
		st1.inactive.background.fillColor = dUI.Palette.yellow
		setStatus( "the style's fill set to yellow" )

	end)

	timer.performWithDelay( 2000, function()
		print("\n\n Clear Styles")
		-- bw1.isEnabled = true
		-- bw1:clearStyle()

		print( "wid", bw2.__curr_style._inherit, st1 )

		-- st1:clearProperties()

		bw2:clearStyle()
		setStatus( "clearStyle(): the style's values are gone" )

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
-- o = dUI.newButton{
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
-- o = dUI.newButton{
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

-- o = dUI.newButton{
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

