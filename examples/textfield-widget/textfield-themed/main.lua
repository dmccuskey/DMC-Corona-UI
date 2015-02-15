--====================================================================--
-- Themed Background
--
-- Shows themed use of the DMC Widget: Background
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2015 David McCuskey. All Rights Reserved.
--====================================================================--



print( "\n\n#########################################################\n\n" )



--===================================================================--
--== Imports


-- local display, native = require('lib.dmc_corona.dmc_kozy')()
local Utils = require 'lib.dmc_corona.dmc_utils'
local Widgets = require 'lib.dmc_widgets'



--===================================================================--
--== Setup, Constants


local W, H = display.contentWidth, display.contentHeight
local H_CENTER, V_CENTER = W*0.5, H*0.5

local textfield, background
local formatter, theme, style



--===================================================================--
-- Support Functions


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



--===================================================================--
--== Main
--===================================================================--


local width, height = 100, 36
local o

--== Setup Visual Screen Items

o = display.newRect(0,0,W,H)
o:setFillColor(0.5,0.5,0.5)
o.x, o.y = H_CENTER, V_CENTER

o = display.newRect( 0,0,150,50)
o:setFillColor(1,0.5,0.5)
o:setStrokeColor(1,0,0)
o.x, o.y = 50, 200

o = display.newRect(0,0,width+4,height+4)
-- o:setFillColor(1,0,0)
o:setStrokeColor(0,0,0)
o.strokeWidth=2
o.x, o.y = H_CENTER, V_CENTER

o = display.newRect( 0,0,10,10)
o:setFillColor(1,0,0)
o.x, o.y = H_CENTER, V_CENTER



--== Setup Widget

-- create formatter

-- formatter = Widgets.newFormatter( Widgets.Formatter.US_ZIPCODE )



-- timer.performWithDelay( 1, function() textfield.width( 0.5, 0.2, 0.1 ) end)


-- style = Widgets.newTextFieldStyle{
-- 	name="text-field-default",

-- 	width=300,
-- 	height=40,
-- 	align='left',
-- 	returnKey='done',
-- 	inputType='password',
-- 	anchorX=0.5,
-- 	anchorY=0.5,
-- 	backgroundStyle='none',
-- 	marginX=0,
-- 	marginY=0,

-- 	hint={
-- 		align='left',
-- 		font=native.systemFontBold,
-- 		fontSize=20,
-- 		textColor={1,0,1},
-- 	},
-- 	text={
-- 		align='left',
-- 		font=native.systemFontBold,
-- 		fontSize=40,
-- 		textColor={1,0,0},
-- 	},
-- 	background={
-- 		fillColor={1,0.5,0.5},
-- 		strokeWidth=2,
-- 		strokeColor={0,0,1},
-- 	}
-- }

-- create text field

print( ">>>>> my text field ")
textfield = Widgets.newTextField{
	-- x,y

	text="89121",
	hintText = "Zipcode",

	style=style,

}

-- print( "\n\n>>>>> making chnages ")

textfield.x = H_CENTER
textfield.y = V_CENTER-100

-- textfield.align = 'left'
textfield.backgroundStrokeWidth = 6
textfield:setBackgroundFillColor( 0.5,0.5,1,1)
textfield:setBackgroundStrokeColor( 0.5,0.5,1,1)


-- textfield.onEvent = textFieldOnEvent_handler
-- textfield:addEventListener( textfield.EVENT, textFieldOnEvent_handler )

-- timer.performWithDelay( 1, function() textfield.width( 0.5, 0.2, 0.1 ) end)

-- create a theme

-- textfield.x = H_CENTER
-- textfield.y = V_CENTER

-- textfield:setAnchor( {0,0} )
-- textfield:setAnchor( {0.5,0.5} )
-- textfield:setAnchor( {1,1} )

-- --== APIT

-- textfield.x = 200
-- textfield.y = 200
-- textfield.width = 150
-- textfield.height = 75

-- textfield.align = 'center'
-- textfield.anchorX = 0.5
-- textfield.anchorY = 0.5
-- textfield.backgroundStyle = 'none'
-- textfield.inputType = 'password'
-- textfield.marginX = 10
-- textfield.marginY = 10
-- textfield.returnKey = 'done'

-- textfield.backgroundStrokeWidth = 4
-- textfield:setBackgroundStrokeColor( 1,0,1)
-- textfield:setBackgroundFillColor( 1,0,1)

-- textfield.hintFont = native.systemFont
-- textfield.hintFontSize = 30
-- textfield:setHintColor( 0,1,1)

-- textfield.textFont = native.systemFont
-- textfield.textFontSize = 40
-- textfield:setTextColor( 1,1,0)


-- theme = Widgets.newTextFieldTheme{
-- 	placeholder={
-- 		font=
-- 		fontSize=
-- 		color
-- 	},
-- 	text={
-- 		font=
-- 		fontSize=
-- 		color
-- 	},

-- }

-- theme.default.width
-- theme.default.placeholder.font
-- theme = Widgets.newTheme( 'textfield' )

-- theme.


