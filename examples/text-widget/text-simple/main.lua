--====================================================================--
-- Simple Text
--
-- A purple Text whose width animates between 40 and 250. With fontSizeMinimum,
-- text that doesn't fit first shrinks (down to size 10), then ends in "...".
-- It starts sized to its text: its size event (DIMENSION_CHANGED) prints that.
-- run_example1() changes properties on a timer, then sets them back to nil;
-- 2() and 3() animate the width (3() also anchor, align, font and colors).
-- The backdrop fills the screen on any device, and a line at the bottom
-- says what the Text shows.
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


-- the screen, as the device reports it: config.lua asks for 320x480
-- 'letterbox', so a taller or a wider screen has room around the content
local SCREEN_W, SCREEN_H = display.actualContentWidth, display.actualContentHeight
local SCREEN_Y = display.screenOriginY
local H_CENTER, V_CENTER = display.contentCenterX, display.contentCenterY
local STATUS_BAR_H = display.topStatusBarContentHeight

-- the line at the bottom, later
local status = nil

local mrandom = math.random

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

	o = display.newText( "Simple Text", H_CENTER, SCREEN_Y+STATUS_BAR_H+30, native.systemFontBold, 20 )

	status = display.newText( "", H_CENTER, SCREEN_Y+SCREEN_H-30, native.systemFont, 16 )

	o = display.newRect( H_CENTER, V_CENTER, 104, 54 )

	o = display.newRect( H_CENTER, V_CENTER, 10, 10 )
	o:setFillColor( 1, 0, 0 )
end

local function setStatus( text )
	status.text = text
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



local function dimensionChange_handler( event )
	print( "Main:dimensionChange_handler" )
	print( ">", event.type, event.width, event.height )
end



--===================================================================--
--== Main
--===================================================================--


setupBackground()


--======================================================--
--== create widget

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
	txt1.x, txt1.y = H_CENTER, V_CENTER-100
	setStatus( "225 wide, aligned right" )

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

	timer.performWithDelay( 1000, function()
		txt1.align='left'
		txt1.fillColor='#000000'
		txt1.font=native.systemFontBold
		txt1.fontSize=30
		txt1.marginX=30
		txt1.strokeWidth=20
		setStatus( "aligned left, bold 30, black fill" )
	end)

	timer.performWithDelay( 2000, function()
		txt1.align='center'
		txt1:setFillColor( 1,1,0 )
		txt1:setStrokeColor( 0,1,1 )
		txt1:setTextColor( 1,0,0 )
		setStatus( "centered, colors by method" )
	end)

	timer.performWithDelay( 3000, function()
		txt1.align='right'
		txt1.fillColor=nil
		txt1.font=nil
		txt1.fontSize=nil
		txt1.marginX=nil
		txt1.strokeWidth=nil
		setStatus( "properties set to nil: the defaults again" )
	end)

end

-- run_example1()


--======================================================--
--== shrink and expand

function run_example2()

	local txt1

	txt1 = dUI.newText{
		text = "hello there Kangaroo !!",
		style={
			width=250,
			height=35,

			align='right',
			fontSize=13,
			marginX=5,
			fillColor={0.5,0,0.25},
			textColor={1,1,0.5},
		}
	}
	txt1.x, txt1.y = H_CENTER, V_CENTER-75

	local narrow, wide, pause

	pause = function( f )
		timer.performWithDelay( 1000, f )
	end

	wide = function()
		setStatus( "widening to 250" )
		transition.to( txt1, {time=2000, width=250, onComplete=function() pause(narrow) end } )
	end
	narrow = function()
		setStatus( "narrowing to 40: ends in \"...\"" )
		transition.to( txt1, {time=2000, width=40, onComplete=function() pause(wide) end } )
	end

	narrow()

end

-- run_example2()



--======================================================--
--== shrink and expand

function run_example3()

	local txt1
	local maxW, minW = 250, 80
	local maxT, minT = 3000, 1000

	local narrow, wide, pause
	local chooseAnchor, chooseAlign
	local chooseFont, chooseColor
	local fontNames = native.getFontNames()

	local anchorIter = getIter( {
			{ 0, H_CENTER-maxW*0.5 },
			{ 0.5, H_CENTER },
			{ 1, H_CENTER+maxW*0.5 }
		} )
	local sizeIter = getIter( { 12, 16, 20, 24, 30 } )
	local alignIter = getIter(  {'left','center','right'} )
	local fillIter = getIter( {
		'#ebe3e0','#edd5d1','#e3d6c6','#dde0cd','#f9a646',
		'#fff2e7','#d0cabf', '#f0f0f0','#92dce0'
	})
	local textIter = getIter( {
		'#393939','#ff5a09','#f3843e','#ff9900','#e9bc1b',
		'#e05151','#75a3d1','#0092d7','#57102c','#b08b0d'
	})

	chooseAnchor = function(o)
		local v = anchorIter()
		o.anchorX = v[1]
		o.x = v[2]
	end
	chooseAlign = function(o)
		o.align = alignIter()
	end
	chooseFont = function(o)
		o.font = fontNames[mrandom(#fontNames)]
		o.fontSize = sizeIter()
	end
	chooseColor = function(o)
		local s = { 16, 20, 24, 30 }
		local font = fontNames[mrandom(#fontNames)]
		local fontSize =s[mrandom(#s)]
		o:setTextColor( textIter() )
		o:setFillColor( fillIter() )
	end

	txt1 = dUI.newText{
		text = "Marsupial Madness",
		style={
			width=maxW,
			-- height=35,

			align=alignIter(),
			fontSize=sizeIter(),
			marginX=5,
			fillColor={0.5,0,0.25},
			textColor={1,1,0.5},
		}
	}
	txt1.x, txt1.y = H_CENTER, V_CENTER+75

	pause = function( f )
		timer.performWithDelay( minT, f )
	end

	wide = function()
		setStatus( "widening to "..maxW )
		transition.to( txt1, {time=maxT, width=maxW, onComplete=function()
			chooseAnchor(txt1)
			chooseFont(txt1)
			pause(narrow)
		end } )
	end
	narrow = function()
		setStatus( "narrowing to "..minW..", fonts and colors change" )
		transition.to( txt1, {time=maxT, width=minW, onComplete=function()
			chooseAlign(txt1)
			pause(wide)
		end } )
	end

	timer.performWithDelay( minT/2, function()
		chooseColor(txt1)
		chooseFont(txt1)
	end, 0 )

	narrow()

end

-- run_example3()



--======================================================--
--== shrink and expand

function run_example4()

	local txt1

	txt1 = dUI.newText{
		text = "hello there Kangarooo !!",
		style={
			debugOn=false,
			width=0,
			height=36,

			align='center',
			fontSize=18,
			fontSizeMinimum=10,
			marginX=0,
			marginY=5,
			fillColor=dUI.Palette.purple,
			textColor={1,1,1},
		}
	}
	txt1.anchorX, txt1.anchorY = 0.5,0.5
	txt1.x, txt1.y = H_CENTER, V_CENTER
	txt1:addEventListener( txt1.EVENT, dimensionChange_handler )
	setStatus( "sized to its text" )

	local narrow, wide, pause

	pause = function( f )
		timer.performWithDelay( 1000, f )
	end

	wide = function()
		setStatus( "widening to 250" )
		transition.to( txt1, {time=2000, width=250, onComplete=function() pause(narrow) end } )
	end
	narrow = function()
		setStatus( "narrowing to 40: shrinks, then \"...\"" )
		transition.to( txt1, {time=2000, width=40, onComplete=function() pause(wide) end } )
	end

	pause( narrow )

end

run_example4()
