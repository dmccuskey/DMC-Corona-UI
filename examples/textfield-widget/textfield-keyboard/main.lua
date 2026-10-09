--====================================================================--
-- Keyboard TextField
--
-- Two text fields, "Email" and a secure "Password", in a blue panel low on
-- the screen; the dark gray bar at the bottom stands in for the keyboard.
-- When a field takes the focus, dUI's KEYBOARD_SHOWING event slides the panel
-- up (dUI.adjustForKeyboard) until "Password" is above the keyboard, with 10
-- to spare; KEYBOARD_HIDING slides it back when editing ends. The line under
-- the name says which of the two happened. The backdrop fills the screen on
-- any device.
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2015 David McCuskey. All Rights Reserved.
--====================================================================--



print( "\n\n#########################################################\n\n" )



--===================================================================--
--== Imports


local dUI = require 'lib.dmc_ui'
local Utils = require 'dmc_utils'



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


--======================================================--
-- Setup Visual Screen Items

-- a backdrop the size of the screen, the example's name at the top,
-- a line under it which says what the widget shows (setStatus(); the
-- keyboard would cover a line at the bottom), and a marker at the
-- screen's center, a white box with a red dot
--
local function setupBackground()
	local o

	o = display.newRect( H_CENTER, V_CENTER, SCREEN_W, SCREEN_H )
	o:setFillColor( 0.17, 0.24, 0.31 )

	o = display.newText( "Keyboard TextField", H_CENTER, SCREEN_Y+STATUS_BAR_H+30, native.systemFontBold, 20 )

	status = display.newText( "", H_CENTER, SCREEN_Y+STATUS_BAR_H+60, native.systemFont, 16 )

	o = display.newRect( H_CENTER, V_CENTER, 104, 54 )

	o = display.newRect( H_CENTER, V_CENTER, 10, 10 )
	o:setFillColor( 1, 0, 0 )
end

local function setStatus( text )
	status.text = text
end



--===================================================================--
--== Main
--===================================================================--


setupBackground()



--======================================================--
--== create textfield widget

function run_example1()

	local dg, bg, tf1, tf2

	-- fake keyboard, where dUI expects the keyboard in portrait:
	-- the bottom quarter of the screen

	local kb = display.newRect( 0, 0, display.actualContentWidth, display.actualContentHeight*0.25 )
	kb:setFillColor( 0.2 )
	kb.anchorX, kb.anchorY=0.5, 1
	kb.x, kb.y = H_CENTER, display.screenOriginY+display.actualContentHeight


	-- setup dUI Event handler, keyboard events

	local function dUIEvent_handler( event )
		print( 'Main: dUIEvent_handler', event.name, event.type )

		if event.type==dUI.KEYBOARD_SHOWING then
			dUI.adjustForKeyboard( dg, {
				proxy=tf2,
				offset=-10
			})
			setStatus( "keyboard showing: the panel moves up" )

		elseif event.type==dUI.KEYBOARD_HIDING then
			dUI.adjustForKeyboard( dg )
			setStatus( "keyboard hiding: the panel moves back" )

		end

	end

	dUI:addEventListener( dUI.EVENT, dUIEvent_handler )


	-- setup display group, to be repositioned with keyboard

	-- (below the marker, its lower field behind the keyboard)

	dg = display.newGroup()
	dg.x, dg.y = H_CENTER, V_CENTER+115

	-- background

	bg = display.newRoundedRect( 0, 0, 250, 170, 5 )
	bg:setFillColor( 0.2, 0.5, 0.9 )
	bg:setStrokeColor( 1, 0.3, 0.3 )
	bg.strokeWidth = 3
	dg:insert( bg )

	-- create 1st text field

	tf1 = dUI.newTextField{
		text="",
		hintText="Email",
		style={ inputType='email' },
	}
	tf1.x, tf1.y = 0, 0-40
	tf1.width=200
	dg:insert( tf1.view )

	-- create 2nd text field

	tf2 = dUI.newTextField{
		text="",
		hintText="Password",
	}
	tf2.x, tf2.y = 0, 0+40
	tf2.isSecure=true
	tf2.width=200
	dg:insert( tf2.view )

	setStatus( "tap a field to edit it" )

end

run_example1()



