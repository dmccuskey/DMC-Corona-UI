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


local dUI = require 'lib.dmc_ui'
-- local Utils = require 'lib.dmc_corona.dmc_utils'



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
	-- print( 'Main: textFieldOnEvent_handler', event.id, event.phase )
	local phase = event.phase

	if phase=='began' then
		-- print( "Begin text:", event.text )
	elseif phase=='ended' or phase=='submitted' then
		print( "End text:", event.text )
	else
		-- print( "Edit text:", event.text )
	end

end



--===================================================================--
--== Main
--===================================================================--


setupBackground()


--======================================================--
--== create textfield widget, default style

function run_example1()

	local tf1

	tf1 = dUI.newTextField{
		text="",
		hintText="Pizza Topping:",
	}
	tf1:addEventListener( tf1.EVENT, textFieldOnEvent_handler )
	-- tf1.onProperty = widgetOnPropertyEvent_handler
	-- tf1.debugOn=true
	tf1.x, tf1.y = H_CENTER, V_CENTER
	tf1.id="BOTTOM"

	tf1:setAnchor( {0.5,0.5} )

	-- tf1.align='left'
	tf1.hintFontSize=18
	-- tf1:setBackgroundFillColor( 1,0.5,0.2,0.3 )

	-- tf1.isSecure=true
	-- tf1.isHitActive=true

	tf2 = dUI.newTextField{
		text="",
		hintText="Pizza Topping:",
	}
	tf2.x, tf2.y = H_CENTER, 100
	tf2.id="TOP"

	-- timer.performWithDelay( 1000, function()
	-- 	print("\n\n Update Properties")
		-- test background props

		-- tf1.x = H_CENTER-50
		-- tf1.y = V_CENTER+100

		-- tf1.isSecure=false

		-- tf1.align='center'
		-- tf1.text="hello"
		-- tf1.marginX=10

		-- tf1.width=200
		-- tf1.height=100

		-- -- tf1.isHitActive=false

		-- tf1:setHintTextColor( 1,1,0 )
		-- tf1.hintFontSize = 18

		-- tf1:setAnchor( {0,0} )

		-- tf1:setBackgroundStrokeColor( 0.2,0.2,0.9,0.5 )
		-- tf1:setBackgroundFillColor( 0.2,0.2,0.2,0.2 )
		-- tf1.backgroundStrokeWidth = 10

		-- tf1:setBackgroundStrokeColor( 0.2,0.2,0.9,0.5 )
		-- tf1:setBackgroundFillColor( 0.2,0.2,0.2,0.2 )
		-- tf1.backgroundStrokeWidth = 10

		-- tf1.hintFont = native.systemFontBold
		-- tf1.hintFontSize = 30
		-- tf1:setHintTextColor(1,0,0,1)

		-- tf1.displayFont = native.systemFontBold
		-- tf1.displayFontSize = 30
		-- tf1:setDisplayTextColor(1,0,0,1)

	-- end)

	-- timer.performWithDelay( 2000, function()
	-- 	print("\n\n Update Properties")
		-- test background props
		-- tf1.width=100
		-- tf1.height=80
		-- tf1.x = 100

		-- tf1.isSecure=true

		-- tf1.x = H_CENTER+50
		-- tf1.y = V_CENTER+50

		-- tf1.isHitActive=false

	-- end)

end

run_example1()

