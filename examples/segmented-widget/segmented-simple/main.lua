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


local function getIter( list, dir, idx )
	idx = idx or 0
	dir = dir or 1
	return function()
		if idx==#list then
			dir = -1
		elseif idx==1 then
			dir = 1
		end
		idx=idx+dir
		return list[idx]
	end
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
			anchorX=1,
			anchorY=1,
			height=40,
			segmentWidth=0,
			segmentHeight=44,

			sheetInfo='asset.segment-sheet',
			sheetImage='asset/segment-sheet.png',
			spriteFrames = {
				leftInactive=1,
				middleInactive=2,
				rightInactive=3,
				leftActive=4,
				middleActive=5,
				rightActive=6,
				dividerInactiveInactive=7,
				dividerInactiveActive=8,
				dividerActiveActive=9,
				dividerActiveInactive=10,
			},

		}
	}
	sc1.x, sc1.y = H_CENTER, V_CENTER

	sc1:insertSegment( 'hello' )
	sc1:insertSegment( 'world' )
	sc1:insertSegment( 'folks' )

	-- timer.performWithDelay( 1000, function()
	-- 	txt1.align='left'
	-- 	txt1.fillColor='#000000'
	-- 	txt1.font=native.systemFontBold
	-- 	txt1.fontSize=30
	-- 	txt1.marginX=30
	-- 	txt1.strokeWidth=20
	-- end)

	-- timer.performWithDelay( 2000, function()
	-- 	txt1.align='center'
	-- 	txt1:setFillColor( 1,1,0 )
	-- 	txt1:setStrokeColor( 0,1,1 )
	-- 	txt1:setTextColor( 1,0,0 )
	-- end)

	-- timer.performWithDelay( 3000, function()
	-- 	txt1.align='right'
	-- 	txt1.fillColor=nil
	-- 	txt1.font=nil
	-- 	txt1.fontSize=nil
	-- 	txt1.marginX=nil
	-- 	txt1.strokeWidth=nil
	-- end)

end

run_example1()


