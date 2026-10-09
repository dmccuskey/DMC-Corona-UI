--====================================================================--
-- Simple TextField
--
-- Two text fields in the default style: "Pizza Topping:" and, in the middle,
-- a secure one whose text shows as dots. Tap one to edit it; the line at the
-- bottom says which is being edited and, at the end of the edit, what it
-- holds. run_example2() (not called) gives a field a style object, then a
-- second later changes the style (size, anchor) and the field (margin,
-- colors, align, isSecure). The backdrop fills the screen on any device.
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2015 David McCuskey. All Rights Reserved.
--====================================================================



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
-- Support Functions


--======================================================--
-- Setup Visual Screen Items

-- a backdrop the size of the screen, the example's name at the top,
-- a line at the bottom which says what the widget shows (setStatus()),
-- and a marker at the screen's center, a white box with a red dot,
-- which makes a change of the widget's anchor easy to see
--
local function setupBackground()
	local o

	o = display.newRect( H_CENTER, V_CENTER, SCREEN_W, SCREEN_H )
	o:setFillColor( 0.17, 0.24, 0.31 )

	o = display.newText( "Simple TextField", H_CENTER, SCREEN_Y+STATUS_BAR_H+30, native.systemFontBold, 20 )

	status = display.newText( "", H_CENTER, SCREEN_Y+SCREEN_H-30, native.systemFont, 16 )

	o = display.newRect( H_CENTER, V_CENTER, 104, 54 )

	o = display.newRect( H_CENTER, V_CENTER, 10, 10 )
	o:setFillColor( 1, 0, 0 )
end

local function setStatus( text )
	status.text = text
end



--======================================================--
-- Widget Handlers

local function textFieldOnEvent_handler( event )
	-- print( 'Main: textFieldOnEvent_handler', event.target.id, event.phase )
	local phase = event.phase
	local field = event.target

	if phase=='began' then
		-- print( "Begin text:", event.text )
		setStatus( "editing "..field.id )
	elseif phase=='ended' or phase=='submitted' then
		print( "End text:", field.id, event.text )
		local text = event.text or ""
		if field.isSecure then
			-- a secret stays one
			setStatus( field.id..": "..#text.." characters" )
		else
			setStatus( field.id..': "'..text..'"' )
		end
	else
		-- print( "Edit text:", event.text )
	end
end



--===================================================================--
--== Main
--===================================================================--


setupBackground()



--======================================================--
--== create textfield widgets, default style

function run_example1()

	local tf1, tf2

	-- a plain field

	tf1 = dUI.newTextField{
		text="",
		hintText="Pizza Topping:",
	}
	tf1:addEventListener( tf1.EVENT, textFieldOnEvent_handler )
	tf1.id="Pizza Topping"
	tf1.x, tf1.y = H_CENTER, V_CENTER-100

	-- a secure field: its text shows as dots

	tf2 = dUI.newTextField{
		text="",
		hintText="Secret Ingredient:",
	}
	tf2:addEventListener( tf2.EVENT, textFieldOnEvent_handler )
	tf2.id="Secret Ingredient"
	tf2.isSecure=true
	tf2.x, tf2.y = H_CENTER, V_CENTER

	setStatus( "tap a field to edit it" )

end

run_example1()



--======================================================--
--== create textfield widget with a style object, then change it

function run_example2()

	local ts1, tf1

	ts1 = dUI.newTextFieldStyle{
		width=280,
		height=30,
		align='left',
		anchorX=0,
		anchorY=0,
	}

	tf1 = dUI.newTextField{
		text="hello",
		hintText="Pizza:",
	}
	tf1:addEventListener( tf1.EVENT, textFieldOnEvent_handler )
	tf1.id="STYLED"
	tf1.style=ts1
	tf1.x, tf1.y = H_CENTER, V_CENTER
	setStatus( "a style object: 280x30, anchored top left" )

	timer.performWithDelay( 1000, function()
		print( "Update Properties" )
		-- the style object
		ts1.width = 150
		ts1.height = 40
		ts1.anchorX=1
		ts1.anchorY=1
		-- the field
		tf1.isSecure=true
		tf1.marginX=30
		tf1:setHintTextColor( 1, 0, 0 )
		tf1:setDisplayTextColor( 1, 0, 0 )
		tf1.align='right'
		setStatus( "150x40, anchored bottom right, secure" )
	end)

	timer.performWithDelay( 2000, function()
		tf1.isSecure=false
		setStatus( "isSecure=false: the text shows" )
	end)

end

-- run_example2()
