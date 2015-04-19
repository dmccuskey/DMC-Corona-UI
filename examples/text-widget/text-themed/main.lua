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



--===================================================================--
--== Setup, Constants


local W, H = display.contentWidth, display.contentHeight
local H_CENTER, V_CENTER = W*0.5, H*0.5



--===================================================================--
-- Support Functions


-- Setup Visual Screen Items
--
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

	-- load theme file(s)
	-- either one at a time
	-- or read from a directory

	-- dUI.loadTheme( 'theme/red-theme.lua' )
	-- dUI.loadTheme( 'theme/green-theme.lua' )
	-- dUI.loadTheme( 'theme/blue-theme.lua' )

	dUI.loadThemes( 'theme' )


	local txt1, txt2

	txt1 = dUI.newText{
		style='home-text'
	}
	txt1.text = "One Two Three"
	txt1.x, txt1.y = H_CENTER, V_CENTER-100

	txt2 = dUI.newText{
		style='home-text'
	}
	txt2.text = "Four Five"
	txt2.x, txt2.y = H_CENTER, V_CENTER+100


	timer.performWithDelay( 1000, function()
		local id = dUI.getActiveThemeId()
		local tList = dUI.getAvailableThemeIds()
		for i=#tList, 1, -1 do
			local tId = tList[i]
			if id==tId then
				table.remove( tList, i )
			end
		end
		local nextTheme = tList[ math.random( #tList ) ]
		-- print("Main:activating", nextTheme )
		dUI.activateTheme( nextTheme )
	end, 0)

end

run_example1()


