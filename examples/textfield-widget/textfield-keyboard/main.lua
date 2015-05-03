--====================================================================--
-- Keyboard TextField
--
-- Shows how to work with keyboard events
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


local W, H = display.contentWidth, display.contentHeight
local H_CENTER, V_CENTER = W*0.5, H*0.5



--===================================================================--
--== Support Functions


--======================================================--
-- Setup Visual Screen Items

local function setupBackground()
	local width, height = 100, 50
	local o

	o = display.newRect(0,0,W,H)
	o:setFillColor(1,1,1)
	o.x, o.y = H_CENTER, V_CENTER

	o = display.newRect(0,0,width+4,height+4)
	o:setStrokeColor(0,0,0)
	o.strokeWidth=2
	o.x, o.y = H_CENTER, V_CENTER

	o = display.newRect( 0,0,10,10)
	o:setFillColor(1,0,0)
	o.x, o.y = H_CENTER, V_CENTER
end



--===================================================================--
--== Main
--===================================================================--


setupBackground()



--======================================================--
--== create textfield widget

function run_example1()

	local dg, bg, tf1, tf2

	-- fake keyboard

	kb = display.newRect( 0, 0, W, 120 )
	kb:setFillColor( 0.2 )
	kb.anchorX, kb.anchorY=0.5, 1
	kb.x, kb.y = H_CENTER, H


	-- setup dUI Event handler, keyboard events

	local function dUIEvent_handler( event )
		print( 'Main: dUIEvent_handler', event.name, event.type )

		if event.type==dUI.KEYBOARD_SHOWING then
			dUI.adjustForKeyboard( dg, {
				proxy=tf2,
				offset=-10
			})

		elseif event.type==dUI.KEYBOARD_HIDING then
			dUI.adjustForKeyboard( dg )

		end

	end

	dUI:addEventListener( dUI.EVENT, dUIEvent_handler )


	-- setup display group, to be repositioned with keyboard

	dg = display.newGroup()
	dg.x, dg.y = H_CENTER, V_CENTER+100

	-- background

	bg = display.newRoundedRect( 0, 0, 250, 200, 5 )
	bg:setFillColor( 0.2, 0.5, 0.9 )
	bg:setStrokeColor( 1, 0.3, 0.3 )
	bg.strokeWidth = 3
	dg:insert( bg )

	-- create 1st text field

	tf1 = dUI.newTextField{
		text="",
		hintText="Email",
	}
	tf1.x, tf1.y = 0, 0-40
	tf1.width=200
	dg:insert( tf1.view )

	-- create 1st text field

	tf2 = dUI.newTextField{
		text="",
		hintText="Password",
	}
	tf2.x, tf2.y = 0, 0+40
	tf2.isSecure=true
	tf2.width=200
	dg:insert( tf2.view )

end

run_example1()



