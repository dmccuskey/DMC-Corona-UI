--====================================================================--
-- Themed Text
--
-- Shows theme setup and selection
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2015 David McCuskey. All Rights Reserved.
--====================================================================--



print( "\n\n#########################################################\n\n" )



--===================================================================--
--== Imports


local dUI = require 'lib.dmc_ui'

local Path = require 'dmc_path'

local Perf = require 'lib.dmc_corona.dmc_performance'



--===================================================================--
--== Setup, Constants


local W, H = display.contentWidth, display.contentHeight
local H_CENTER, V_CENTER = W*0.5, H*0.5

local tdelay = timer.performWithDelay



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
--== stress test Text Style

function run_example1()

	local createItem, destroyItem
	local DELAY = 100
	local count = 0
	local o

	createItem = function()
		count=count+1
		o = dUI.newTextStyle{}
		tdelay( DELAY, function()
			destroyItem()
		end)
	end

	destroyItem = function()
		o:removeSelf()
		o = nil
		if count%10==0 then
			print( "cycles completed: ", count )
		end
		tdelay( DELAY, function()
			createItem()
		end)
	end

	print( "Main: Starting" )
	Perf.watchMemory( 2500 )
	createItem()

end

-- run_example1()



--======================================================--
--== stress test Text Style

function run_example2()

	local createItem, destroyItem
	local DELAY = 25
	local count = 0
	local ts = dUI.newTextStyle{}

	local o

	createItem = function()
		count=count+1
		o = ts:copyStyle()
		tdelay( DELAY, function()
			destroyItem()
		end)
	end

	destroyItem = function()
		o:removeSelf()
		o = nil
		if count%10==0 then
			print( "cycles completed: ", count )
		end
		tdelay( DELAY, function()
			createItem()
		end)
	end

	print( "Main: Starting" )
	Perf.watchMemory( 2500 )
	createItem()

end

-- run_example2()


--======================================================--
--== stress test Text Style

function run_example3()

	local createItem, destroyItem
	local DELAY = 50
	local count = 0
	local o

	createItem = function()
		count=count+1
		o = dUI.newText()
		tdelay( DELAY, function()
			destroyItem()
		end)
	end

	destroyItem = function()
		o:removeSelf()
		o = nil

		if count%10==0 then
			print( "cycles completed: ", count )
		end
		tdelay( DELAY, function()
			createItem()
		end)
	end

	print( "Main: Starting" )
	Perf.watchMemory( 2500 )
	createItem()

end

run_example3()

