--====================================================================--
-- Themed TextField
--
-- Shows themed use of the DMC Widget: Text Field
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

local textfield
local formatter, theme, style



--===================================================================--
-- Support Functions


local function textFieldOnEvent_handler( event )
	-- print( 'Main: textFieldOnEvent_handler', event.id, event.phase )
	local phase = event.phase

	if phase=='began' then
		print( "Begin text:", event.text )
	elseif phase=='ended' or phase=='submitted' then
		print( "End text:", event.text )
	else
		print( "Edit text:", event.text )
		print( string.format( "Edit char:'%s' pos:%s del:%s", event.newCharacters, event.startPosition, event.numDeleted ) )
	end

end



--===================================================================--
--== Main
--===================================================================--


local width, height = 100, 36

local o

o = display.newRect(0,0,W,H)
o:setFillColor(0.5,0.5,0.5)
o.x, o.y = H_CENTER, V_CENTER

o = display.newRect(0,0,width+4,height+4)
-- o:setFillColor(1,0,0)
o:setStrokeColor(0,0,0)
o.strokeWidth=2
o.x, o.y = H_CENTER, V_CENTER

o = display.newRect( 0,0,10,10)
o:setFillColor(1,0,0)
o.x, o.y = H_CENTER, V_CENTER


-- create formatter

formatter = Widgets.newFormatter( Widgets.Formatter.US_ZIPCODE )


-- style = Widgets.newTextFieldStyle{
-- 	name="text-field-default",

-- 	width=20,
-- 	height=20,
-- 	align='left',
-- 	returnKey='done',
-- 	inputType='password',
	-- anchorX, anchorY

-- 	placeholder={
-- 		-- text="zipecode",
-- 		font=native.systemFontBold,
-- 		fontSize=20,
-- 		color={1,0,1},
-- 		align='left'
-- 	},
-- 	text={
-- 		font=native.systemFontBold,
-- 		fontSize=20,
-- 		color={0,1,0},
-- 		align='left'
-- 	},
-- 	background={
-- 		style='none',
-- 		strokeWidth=2,
-- 		strokeColor={1,1,1},
-- 		fillColor={0.5,0.5,0.5},
-- 		marginX=0,
-- 		marginY=0
-- 	}
-- }


-- create text field

textfield = Widgets.newTextField{
	-- style=style,
	-- x,y

	text="hello",
	hintText = "Zipcode",
}
-- textfield.onEvent = textFieldOnEvent_handler
textfield:addEventListener( textfield.EVENT, textFieldOnEvent_handler )



-- timer.performWithDelay( 1, function() textfield.width( 0.5, 0.2, 0.1 ) end)

-- create a theme

textfield.x = H_CENTER
textfield.y = V_CENTER



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
