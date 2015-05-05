--====================================================================--
-- Simple Segmented Control Widget
--
-- Shows basic use of the DMC Widget: Segmented Control
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

local mrandom = math.random

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


local function segmentEvent_handler( event )
	print( "Main:segmentEvent_handler" )
	local target = event.target

	print( "Selected: ", event.index )
end


--===================================================================--
--== Main
--===================================================================--


setupBackground()


--======================================================--
--== create widget

function run_example1()

	local sc1

	sc1 = dUI.newSegmentedControl{
		style={

			offsetLeft=2,
			offsetRight=1,
			offsetTop=2,
			offsetBottom=1,

			sheetInfo='asset.segment-sheet',
			sheetImage='asset/segment-sheet.png',
		}
	}
	sc1.x, sc1.y = H_CENTER, V_CENTER

	sc1.anchorX, sc1.anchorY=0,1
	sc1:addEventListener( sc1.EVENT, segmentEvent_handler )

	sc1:insertSegment( 'hello' )
	sc1:insertSegment( 'world' )
	sc1:insertSegment( 'folks' )
	sc1.selected = 1

	timer.performWithDelay( 1000, function()
		sc1.selected = 2
			sc1.anchorX, sc1.anchorY = 0, 0
	end)

	timer.performWithDelay( 2000, function()
		sc1:insertSegment( 2, 'dude' )
		sc1:removeSegment( 1 )
	end)

	timer.performWithDelay( 3000, function()
		sc1.selected = 0
		sc1.anchorX, sc1.anchorY = 0.5, 0
	end)

end

run_example1()


