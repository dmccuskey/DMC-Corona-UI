--====================================================================--
-- Simple TextField
--
-- Two text fields in the default style: "Pizza Topping:" near the top and,
-- in the middle, a secure one whose text shows as dots. Tap one to edit it;
-- the end of each edit prints its text. run_example2() (not called) gives a
-- field a style object, then a second later changes the style (size,
-- anchor) and the field (margin, colors, align, isSecure).
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


local W, H = display.contentWidth, display.contentHeight
local H_CENTER, V_CENTER = W*0.5, H*0.5



--===================================================================--
-- Support Functions


--======================================================--
-- Setup Visual Screen Items

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



--======================================================--
-- Widget Handlers

local function textFieldOnEvent_handler( event )
	-- print( 'Main: textFieldOnEvent_handler', event.target.id, event.phase )
	local phase = event.phase

	if phase=='began' then
		-- print( "Begin text:", event.text )
	elseif phase=='ended' or phase=='submitted' then
		print( "End text:", event.target.id, event.text )
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
	tf1.id="TOP"
	tf1.x, tf1.y = H_CENTER, 100

	-- a secure field: its text shows as dots

	tf2 = dUI.newTextField{
		text="",
		hintText="Secret Ingredient:",
	}
	tf2:addEventListener( tf2.EVENT, textFieldOnEvent_handler )
	tf2.id="BOTTOM"
	tf2.isSecure=true
	tf2.x, tf2.y = H_CENTER, V_CENTER

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
	end)

	timer.performWithDelay( 2000, function()
		tf1.isSecure=false
	end)

end

-- run_example2()
