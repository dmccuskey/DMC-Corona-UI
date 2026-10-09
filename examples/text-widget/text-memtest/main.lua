--====================================================================--
-- Text Memory Test
--
-- Creates and removes a Text every 50 ms and prints memory use with
-- dmc-performance; run_example1() and 2() do the same with a text style
-- (new, and copyStyle()). The line at the bottom counts the cycles.
-- The backdrop fills the screen on any device.
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


-- the screen, as the device reports it: config.lua asks for 320x480
-- 'letterbox', so a taller or a wider screen has room around the content
local SCREEN_W, SCREEN_H = display.actualContentWidth, display.actualContentHeight
local SCREEN_Y = display.screenOriginY
local H_CENTER, V_CENTER = display.contentCenterX, display.contentCenterY
local STATUS_BAR_H = display.topStatusBarContentHeight

-- the line at the bottom, later
local status = nil

local tdelay = timer.performWithDelay



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

	o = display.newText( "Text Memory Test", H_CENTER, SCREEN_Y+STATUS_BAR_H+30, native.systemFontBold, 20 )

	status = display.newText( "", H_CENTER, SCREEN_Y+SCREEN_H-30, native.systemFont, 16 )

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
			setStatus( "cycles completed: "..count )
		end
		tdelay( DELAY, function()
			createItem()
		end)
	end

	print( "Main: Starting" )
	setStatus( "running" )
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
			setStatus( "cycles completed: "..count )
		end
		tdelay( DELAY, function()
			createItem()
		end)
	end

	print( "Main: Starting" )
	setStatus( "running" )
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
		o = dUI.newText{ text="memtest" }
		o.x, o.y = H_CENTER, V_CENTER
		tdelay( DELAY, function()
			destroyItem()
		end)
	end

	destroyItem = function()
		o:removeSelf()
		o = nil

		if count%10==0 then
			print( "cycles completed: ", count )
			setStatus( "cycles completed: "..count )
		end
		tdelay( DELAY, function()
			createItem()
		end)
	end

	print( "Main: Starting" )
	setStatus( "running" )
	Perf.watchMemory( 2500 )
	createItem()

end

run_example3()

