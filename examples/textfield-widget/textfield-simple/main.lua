--====================================================================--
-- Simple TextField
--
-- Shows basic use of the DMC Widget: Text Field
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

local formatter



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

-- create text field

textfield = Widgets.newTextField{

	-- text = "",
	-- hintText = "Zipcode",

	style={
		width=width,
		height=height,

		align = nil,
		textColor = nil,

		-- font = native.systemFontBold,
		-- fontSize = 24,

		returnKey='done',
		hasBackground=false,
		inputType='password',
		-- backgroundStyle=Widgets.TextField.BORDER_STYLE_ROUNDED
		fillColor = nil,
	}
}
textfield.onEvent = textFieldOnEvent_handler
textfield:addEventListener( textfield.EVENT, textFieldOnEvent_handler )

textfield.formatter = formatter

--== Make different changes

textfield:setFillColor( 0.5, 0.2, 0.1 )
textfield:setTextColor( 1, 0, 0 )
textfield:setHintColor( 0.7, 0.2, 0.7 )

-- textfield.x = H_CENTER
-- textfield.y = V_CENTER

textfield:setAnchor( {0,0} )
textfield:setAnchor( {0.5, 0.5} )
-- textfield:setAnchor( {1,1} )

textfield.align = textfield.LEFT
-- textfield.align = textfield.CENTER
-- textfield.align = textfield.RIGHT

textfield.x = H_CENTER
textfield.y = V_CENTER

textfield.height = 50


-- textfield.anchorX = 0.5
-- textfield.anchorY = 0.5

-- textfield.text = "hello there"

-- textfield.fontSize = 12

-- textfield.fontSize = 12
-- textfield.font = native.systemFont
-- -- textfield.font = native.systemFontBold

-- textfield.marginX = 20
-- textfield.marginX = 10
-- textfield.marginY = 5

-- -- textfield.width = 100

-- -- textfield.width = nil

-- textfield:setFillColor( 1,0,0,0.5 )
-- textfield:setTextColor( 0,1,1,0.5 )


-- transition.to( textfield, {time=500, x=100})

-- textfield:setKeyboardFocus()
-- textfield:unsetKeyboardFocus()
-- native.setKeyboardFocus( textfield )


-- timer.performWithDelay( 1, function() textfield:setKeyboardFocus() end)
