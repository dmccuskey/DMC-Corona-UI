--====================================================================--
-- Styled Background
--
-- Styles on backgrounds: default styles changed through viewStyle, a shared
-- style made with newBackgroundStyle(), and a moving widget whose style is
-- swapped (rounded, rectangle, then rounded again). debugOn=true covers a
-- widget in translucent red. The backdrop fills the screen on any device.
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2014-2015 David McCuskey. All Rights Reserved.
--====================================================================--



print( "\n\n#########################################################\n\n" )



--===================================================================--
--== Imports


local dUI = require 'lib.dmc_ui'



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



--===================================================================--
--== Support Functions


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

	o = display.newText( "Styled Background", H_CENTER, SCREEN_Y+STATUS_BAR_H+30, native.systemFontBold, 20 )

	status = display.newText( "", H_CENTER, SCREEN_Y+SCREEN_H-30, native.systemFont, 16 )

	o = display.newRect( H_CENTER, V_CENTER, 104, 54 )

	o = display.newRect( H_CENTER, V_CENTER, 10, 10 )
	o:setFillColor( 1, 0, 0 )
end

local function setStatus( text )
	status.text = text
end



--===================================================================--
-- Main
--===================================================================--


setupBackground()


--======================================================--
--== create background, default style

function run_example1a()

	local bw1

	bw1 = dUI.newBackground{}
	bw1.x, bw1.y = H_CENTER, V_CENTER-50

	bw1.viewStyle:setFillColor( 1, 1, 0 )
	bw1.viewStyle:setStrokeColor( 1, 0, 0 )
	bw1.viewStyle.strokeWidth = 5

	timer.performWithDelay( 1000, function()
		bw1.y = V_CENTER-140
	end)

end

run_example1a()


--======================================================--
--== create background, default style

function run_example1b()

	local bw1

	bw1 = dUI.newRoundedBackground{}
	bw1.x, bw1.y = H_CENTER, V_CENTER-100

end

run_example1b()


--======================================================--
--== create background, default style

function run_example1c()

	local bw1

	bw1 = dUI.newRectangleBackground{}
	bw1.x, bw1.y = H_CENTER, V_CENTER+100

end

run_example1c()


--======================================================--
--== create background rectangle style

function run_example2()

	local st2, bw2

	st2 = dUI.newBackgroundStyle{
		debugOn=true,

		width = 125,
		height = 50,

		anchorX=0.5,
		anchorY=0.5,

		type='rectangle',
		view={
			fillColor={ 0,1,0.5,0.5},
			strokeWidth=4,
			strokeColor={ 0,0,0,1 },
		}
	}

	-- apply style to widgete

	bw2 = dUI.newBackground{
		style=st2
	}

	-- make some updates

	-- bw2.x, bw2.y = H_CENTER-100, V_CENTER+100
	bw2.x, bw2.y = H_CENTER, V_CENTER

	bw2:setAnchor( {1,1})
	bw2.width=124


	-- make more updates after time

	timer.performWithDelay( 1000, function()
		bw2:setAnchor( {0,0} )
		bw2:setAnchor( {0.5,0.5} )
		bw2:setAnchor( {1,1} )
		bw2.viewStyle.strokeWidth = 1
		bw2.viewStyle:setFillColor( 1,0,0,1 )
		bw2.viewStyle:setStrokeColor( 0,1,0,1 )

		-- bw2.width=100
		-- bw2.height=40

		bw2.x, bw2.y = H_CENTER, V_CENTER

	end)

end

run_example2()


--======================================================--
--== create background rounded background style

function run_example3()

	local st2, st3, bw3

	st2 = dUI.newBackgroundStyle{
		debugOn=true,

		width = 125,
		height = 50,

		anchorX=1,
		anchorY=1,

		type='rectangle',
		view={
			fillColor={ 0,1,0.5,0.5},
			strokeWidth=4,
			strokeColor={ 0,0,0,1 },
		}
	}

	st3 = dUI.newBackgroundStyle{
		debugOn=true,

		width = 125,
		height = 50,

		anchorX=1,
		anchorY=1,

		type='rounded',
		view = {
			cornerRadius=4,
			fillColor={ 0,1,0.5,0.5},
			strokeWidth=4,
			strokeColor={ 0,0,0,1 },
		}
	}


	bw3 = dUI.newBackground{
		style=st3
	}
	-- bw3.x, bw3.y = H_CENTER-100, V_CENTER+100
	bw3.x, bw3.y = H_CENTER, V_CENTER+100

	-- bw3:setAnchor( {1,1})
	-- bw3.width=124

	transition.to( bw3, {time=5000, y=V_CENTER-120})

	timer.performWithDelay( 1000, function()
		bw3:setAnchor( {0,0})
		-- bw3:setAnchor( {0.5,0.5})
		-- bw3:setAnchor( {1,1})
		bw3.viewStyle:setFillColor( 1,0,0,1)
		bw3.viewStyle:setStrokeColor( 0,1,0,1)
		bw3.viewStyle.cornerRadius = 20

		-- bw3.width=100
		-- bw3.height=40

		-- bw3.x, bw3.y = H_CENTER, V_CENTER-100

	end)

	timer.performWithDelay( 1500, function()
		print("\n\nUpdate New Style")
		bw3.style = st2
	end)


	timer.performWithDelay( 3000, function()
		print("\n\nUpdate New Style")
		bw3.style = st3
	end)

end

run_example3()

setStatus( "default, shared and swapped styles" )


--======================================================--
--== create background, 3 inheritance, block type in middle

function run_example4()

	local st1, st2, st3, bw3

	st1 = dUI.newBackgroundStyle{
		debugOn=true,

		width = 130,
		height = 20,

		anchorX=1,
		anchorY=1,

		type='rounded',
		view={
			fillColor={ 0,1,0.5,0.5},
			strokeWidth=4,
			strokeColor={ 0,0,0,1 },
		}
	}

	st2 = dUI.newBackgroundStyle()
	st2.inherit = st1

	st3 = dUI.newBackgroundStyle()
	st3.inherit = st2

	bw3 = dUI.newBackground{
		style=st3
	}
	-- bw3.x, bw3.y = H_CENTER-100, V_CENTER+100
	bw3.x, bw3.y = H_CENTER, V_CENTER-100

	-- bw3:setAnchor( {1,1})
	-- bw3.width=124


	timer.performWithDelay( 1000, function()
		-- bw3:setAnchor( {0,0})
		-- bw3:setAnchor( {0.5,0.5})
		-- bw3:setAnchor( {1,1})
		st2.type='rectangle'

	end)

	timer.performWithDelay( 2500, function()
		-- bw3:setAnchor( {0,0})
		-- bw3:setAnchor( {0.5,0.5})
		-- bw3:setAnchor( {1,1})

		st2.type=nil

		bw3.width=110
		bw3.height=40

	end)



end

-- run_example4()

