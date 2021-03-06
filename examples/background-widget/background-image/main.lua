--====================================================================--
-- Simple 9-Slice Background
--
-- Shows 9-slice setup with DMC Background Widget
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
--== create 9-slice background, from sprite sheet

function run_example1a()

	local bw1

	-- bs1 = dUI.newImageBackgroundStyle{
	-- 	width=75,
	-- }

	bw1 = dUI.newImageBackground{

		style={
			anchorX=0,
			anchorY=0.5,
			width=100,
			height=100,
			view = {
				imagePath='asset/background.png',
				offsetLeft=11,
				offsetRight=10,
				offsetTop=7,
				offsetBottom=14,
			}
		}
	}
	bw1.x, bw1.y = H_CENTER, V_CENTER

	-- bw1.style = bs1

	timer.performWithDelay( 1000, function()
		bw1.width=200
		print( bw1.width, bw1.height )
	end)

	timer.performWithDelay( 2000, function()
		bw1.width, bw1.height = 0, 0
		bw1.anchorX=0
		bw1.anchorY=1
	end)

	timer.performWithDelay( 2100, function()
		print( bw1.width, bw1.height )
	end)

end

run_example1a()


