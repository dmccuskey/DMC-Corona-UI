--====================================================================--
-- Simple Text
--
-- Shows basic use of the DMC Widget: Text
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2015 David McCuskey. All Rights Reserved.
--====================================================================--



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



--===================================================================--
--== Main
--===================================================================--


setupBackground()


--======================================================--
--== create widget, default style

function run_example1()

	local txt1

	txt1 = dUI.newText{
		text = "hello there",
		style={
			width=225,
			height=35,

			align='right',
			fontSize=13,
			marginX=5,
			fillColor={0.5,0,0.25},
			textColor={1,0,0},
		}
	}
	txt1.x, txt1.y = H_CENTER, 100

	--== Make different changes

	-- txt1.width = 125

	-- txt1.x = H_CENTER
	-- txt1.y = V_CENTER

	-- text:setAnchor( {0.5, 1} )
	-- txt1.anchorX = 0.5
	-- txt1.anchorY = 0.5

	-- txt1.text = "one two three"

	-- txt1.fontSize = 12

	txt1.font = native.systemFont
	-- txt1.font = native.systemFontBold
	-- txt1.align = txt1.RIGHT
	-- txt1.align = txt1.CENTER
	-- txt1.align = txt1.LEFT

	-- txt1.marginX = 20
	-- txt1.marginX = 10
	-- txt1.marginY = 5

	-- txt1.width = 100

	-- txt1.width = nil

	-- txt1:setTextColor( 1,0,0,0.5 )
	-- txt1:setTextColor( 0,1,1,0.5 )

end

run_example1()
