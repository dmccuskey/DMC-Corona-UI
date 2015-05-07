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

	timer.performWithDelay( 1000, function()
		txt1.align='left'
		txt1.fillColor='#000000'
		txt1.font=native.systemFontBold
		txt1.fontSize=30
		txt1.marginX=30
		txt1.strokeWidth=20
	end)

	timer.performWithDelay( 2000, function()
		txt1.align='center'
		txt1:setFillColor( 1,1,0 )
		txt1:setStrokeColor( 0,1,1 )
		txt1:setTextColor( 1,0,0 )
	end)

	timer.performWithDelay( 3000, function()
		txt1.align='right'
		txt1.fillColor=nil
		txt1.font=nil
		txt1.fontSize=nil
		txt1.marginX=nil
		txt1.strokeWidth=nil
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
		transition.to( txt1, {time=2000, width=250, onComplete=function() pause(narrow) end } )
	end
	narrow = function()
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
		transition.to( txt1, {time=maxT, width=maxW, onComplete=function()
			chooseAnchor(txt1)
			chooseFont(txt1)
			pause(narrow)
		end } )
	end
	narrow = function()
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
			height=30,

			align='center',
			fontSize=14,
			fontSizeMinimum=8,
			marginX=0,
			marginY=5,
			fillColor={0.5,0,1},
			textColor={0,0,0},
		}
	}
	txt1.anchorX, txt1.anchorY = 0.5,0.5
	txt1.x, txt1.y = H_CENTER, V_CENTER
	txt1:addEventListener( txt1.EVENT, dimensionChange_handler )

	local narrow, wide, pause

	pause = function( f )
		timer.performWithDelay( 1000, f )
	end

	wide = function()
		transition.to( txt1, {time=2000, width=250, onComplete=function() pause(narrow) end } )
	end
	narrow = function()
		transition.to( txt1, {time=2000, width=40, onComplete=function() pause(wide) end } )
	end

	narrow()

end

run_example4()
