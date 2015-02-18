--====================================================================--
-- Background Styled
--
-- Shows styling of the DMC Widget: Background
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2014-2015 David McCuskey. All Rights Reserved.
--====================================================================--



print( "\n\n#########################################################\n\n" )



--===================================================================--
--== Imports


local Widgets = require 'lib.dmc_widgets'



--===================================================================--
--== Setup, Constants


local W, H = display.contentWidth, display.contentHeight
local H_CENTER, V_CENTER = W*0.5, H*0.5



--===================================================================--
--== Support Functions


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

local function onPress_handler( event )
	print( 'Main: onPress_handler: id', event.id )
end

local function onRelease_handler( event )
	print( 'Main: onRelease_handler: id', event.id )
end

local function onEvent_handler( event )
	print( 'Main: onEvent_handler: id', event.id )
end



--===================================================================--
-- Main
--===================================================================--


setupBackground()


--======================================================--
--== create background, default style

local st1, bw1


-- bw1 = Widgets.newBackground{
-- }
-- bw1.x, bw1.y = H_CENTER, V_CENTER-100

-- bw1:setViewFillColor( 1, 1, 0 )
-- bw1:setViewStrokeColor( 1, 0, 0 )
-- bw1.viewStrokeWidth = 5

-- timer.performWithDelay( 1000, function()
-- 	bw1.y=100
-- end)


--======================================================--
--== create background rectangle style

local st2, bw2

st2 = Widgets.newBackgroundStyle{
	debugOn=true,

	width = 125,
	height = 100,

	anchorX=0,
	anchorY=1,
	hitMarginX=5,
	hitMarginY=20,

	view={
		type='rectangle',
		fillColor={ 0,1,0.5,0.5},
		strokeWidth=4,
		strokeColor={ 0,0,0,1 },
	}
}

bw2 = Widgets.newBackground{
	style=st2
}
-- bw2.x, bw2.y = H_CENTER-100, V_CENTER+100
bw2.x, bw2.y = H_CENTER, V_CENTER

-- bw2:setAnchor( {1,1})

-- bw2.width=124

-- timer.performWithDelay( 1000, function()
-- 	print( "\n\nUpdate Properties" )
-- 	print( bw2)
-- 	bw2:setAnchor( {0,0})
-- 	bw2:setAnchor( {0.5,0.5})
-- 	bw2:setAnchor( {1,1})
-- 	bw2.viewStrokeWidth = 1
-- 	bw2:setViewFillColor( 1,0,0,1)
-- 	bw2:setViewStrokeColor( 0,1,0,1)

-- 	-- bw2.width=100
-- 	-- bw2.height=40

-- 	bw2.x, bw2.y = H_CENTER, V_CENTER

-- end)



--======================================================--
--== create background rounded background style

local st3

-- st3 = Widgets.newBackgroundStyle{

-- 	width = 75,
-- 	height = 30,

-- 	type='rounded',

-- 	anchorX=0,
-- 	anchorY=1,

-- 	cornerRadius=4,
-- 	fillColor={1,1,0.5, 0.5},
-- 	strokeWidth=6,
-- 	strokeColor={1,0,0,0.5},
-- }



