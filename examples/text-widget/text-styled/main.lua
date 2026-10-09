--====================================================================--
-- Styled Text
--
-- An inline style, then the default style (style=nil); then "hamburger" in
-- a 150x70 box anchored at its bottom-right, then "pizza" sized to its text
-- and anchored at its top-left: a step every two seconds, named by the line
-- at the bottom. The red dot marks the Text's position, at the center of the
-- screen. run_example1() to 6() show the default style, shared and named
-- styles, clearStyle() and long text. The backdrop fills the screen on any
-- device.
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

	o = display.newText( "Styled Text", H_CENTER, SCREEN_Y+STATUS_BAR_H+30, native.systemFontBold, 20 )

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
--== create widget, default style

function run_example1()

	local txt1

	txt1 = dUI.newText{}
	txt1.text = "default style"
	txt1.x, txt1.y = H_CENTER, V_CENTER
	setStatus( "the default style" )

end

-- run_example1()


--======================================================--
--== Create Widget, inline style

function run_example2()

	local txt2

	txt2 = dUI.newText{
		text="inline style",

		style={
			width=225,
			height=35,

			align='right',
			fontSize=26,
			marginX=5,
			fillColor={0.5,0,0.25},
			textColor={1,0,0},
		}
	}

	txt2.x = H_CENTER
	txt2.y = V_CENTER

	txt2.align='left'
	txt2.align='center'
	-- txt2.align='right'

	txt2:setAnchor( {0,0} )
	txt2:setAnchor( {0.5,0.5} )
	-- txt2:setAnchor( {1,1} )
	setStatus( "an inline style" )


	-- timer.performWithDelay( 1000, function()
	-- 	txt2.style=nil -- clear style, to default
	-- end)


	-- timer.performWithDelay( 2000, function()
	-- 	print( "\n\nUpdate properties" )

	-- 	transition.to( txt2, {time=5000, x=100, y=400})

	-- 	txt2.text="hamburger"

	-- 	txt2.width=300
	-- 	txt2.height=70

	-- 	txt2.align='right'

	-- 	txt2:setAnchor( {1,1} )

	-- 	txt2:setFillColor( 1,0,0,0.5 )
	-- 	txt2:setTextColor( 1,0,0,0.5 )

	-- 	txt2.font = native.systemFontBold

	-- 	txt2:setStrokeColor( 0,0,0,0.5 )
	-- 	txt2.strokeWidth = 4

	-- 	txt2.fontSize = 18
	-- 	txt2.marginX = 15
	-- 	txt2.marginY = 15

	-- end)

	timer.performWithDelay( 3000, function()
		print( "\n\nUpdate properties" )

		-- txt2.x=100

		txt2.text="pizza"

		txt2.width=nil
		txt2.height=nil

		txt2.align='center'
		-- txt2:setAnchor( {0.5,0.5} )

		txt2.strokeWidth = 2
		txt2:setStrokeColor( 1,0,0,1 )

		txt2.font = native.systemFontBold
		txt2.fontSize = 30

		txt2:setFillColor( 0,0,0.5,0.8 )
		txt2:setTextColor( 1,0,1,0.5 )
		setStatus( "restyled, sized to its text" )

	end)


end

-- run_example2()



--======================================================--
--== create style, apply to widget

function run_example3()

	local st3, txt3, txt4

	st3 = dUI.newTextStyle{
		name='my-text-style',
		fillColor={0.5,0.8,0.2},
		marginX=5,
		marginY=10,
		textColor={0,0,0},
	}

	txt3 = dUI.newText{
		text="Text One"
	}
	txt3.style = st3
	txt3.x, txt3.y = H_CENTER, V_CENTER-100
	setStatus( "a style object, on one Text" )


	-- add another text widget, with same style

	timer.performWithDelay( 1500, function()
		print( "\n\nUpdate Properties" )

		txt4 = dUI.newText{
			text="Text Two",
			style=st3
		}
		txt4.x=H_CENTER
		txt4.y=V_CENTER+100
		setStatus( "a second Text, the same style" )

	end)

	-- change some styles on one widget

	timer.performWithDelay( 3000, function()
		print( "\n\nUpdate Properties" )

		txt3:setFillColor( 1,0.5,0.5,0.5 )
		txt3:setTextColor( 1,0,0,0.5 )
		txt3.align='left'
		txt3.width=200

		txt3:setTextColor( 0.5,0.2,0,0.5 )

		-- st3:setFillColor(1,0,0)
		setStatus( "Text One: its own color, align, width" )

	end)


	-- then reset both to original look

	timer.performWithDelay( 4500, function()
		print( "\n\nUpdate Properties" )

		txt3:clearStyle()
		txt4:clearStyle()
		setStatus( "clearStyle(): both as the style says" )
	end)


	-- remove a widget

	timer.performWithDelay( 10000, function()
		print( "\n\nRemoving Widget" )
		txt3:removeSelf()
		setStatus( "Text One removed" )
	end)

end

-- run_example3()


--======================================================--
--== create style, apply to widgets, change style

function run_example4()

	local st4, txt3, txt5

	st4 = dUI.newTextStyle{
		name='my-text-style',

		width=120,
		fontSize=20,
		fillColor={0.5,0.8,0.2},
		marginX=0,
		marginY=0,
		textColor={1,0,0},
	}

	-- add text widget, give style

	txt3 = dUI.newText{
		text="Text One",
		style=st4
	}
	txt3.x, txt3.y = H_CENTER-70, V_CENTER-100

	-- add another text widget, give same style

	txt5 = dUI.newText{
		text="Text Two"
	}
	txt5.style = st4
	txt5.x, txt5.y = H_CENTER+70, V_CENTER-100
	setStatus( "two Texts, one style" )

	-- add another text widget, with same style

-- txt5.debugOn = true

	timer.performWithDelay( 1000, function()
		print( "\n\nUpdate Properties" )
		st4.align='left'
		st4.fontSize=12
		st4.textColor={0,0,0,1}
		st4.fillColor={0.2,0.2,0.2}

		-- -- set property on one text
		txt5:setFillColor( 1,0.5,0.2,1 )
		setStatus( "style changed; Text Two's own fill" )
	end)

	timer.performWithDelay( 2000, function()
		print( "\n\nUpdate Properties" )
		st4.align='center'
		setStatus( "style: aligned center" )
	end)

	timer.performWithDelay( 3000, function()
		print( "\n\n Clear Style" )
		-- reset local changes to text widget
		txt5:clearStyle()
		setStatus( "clearStyle() on Text Two" )
	end)



end

-- run_example4()



--======================================================--
--== create style, apply to widget

function run_example5()

	local st3, txt3, txt4

	st3 = dUI.newTextStyle{
		name='my-text-style',
		fillColor={0.5,0.8,0.2},
		marginX=0,
		marginY=0,
		textColor={0,0,0},
	}

	txt3 = dUI.newText{
		text="Text One"
	}
	txt3.style = st3
	txt3.x, txt3.y = H_CENTER, V_CENTER-100
	setStatus( "a style object, on one Text" )


	-- add another text widget, with same style

	timer.performWithDelay( 2000, function()
		print( "\n\n Update Properties" )

		txt4 = dUI.newText{
			text="Text Two",
			style=st3
		}
		txt4.x=H_CENTER
		txt4.y=V_CENTER+100
		setStatus( "a second Text, the same style" )

	end)

	-- change some styles on one widget

	timer.performWithDelay( 4000, function()
		print( "\n\n Update Properties" )

		txt3:setFillColor( 1,0.5,0.5,0.5 )
		txt3:setTextColor( 1,0,0,0.5 )
		txt3.align='left'
		txt3.width=200

		txt3:setTextColor( 0.5,0.2,0,0.5 )
		setStatus( "Text One: its own color, align, width" )

	end)


	-- then reset both to original look

	timer.performWithDelay( 6000, function()
		print( "\n\n Clear Style Properties" )

		st3:clearProperties()
		txt4:clearStyle()
		setStatus( "the style: clearProperties()" )
	end)

	timer.performWithDelay( 8000, function()
		print( "\n\n Clear Widget Properties" )

		-- st3:clearProperties()
		txt4:clearStyle()
		txt3:clearStyle()
		setStatus( "clearStyle() on both Texts" )
	end)


	-- remove a widget

	timer.performWithDelay( 12000, function()
		print( "\n\n Removing Widget" )
		txt3:removeSelf()
		setStatus( "Text One removed" )
	end)

end

-- run_example5()



--======================================================--
--== create widget, long text, put elipses in place

function run_example6()

	local w1

	w1 = dUI.newText{}
	w1.width = 60
	w1.text = "this is long text too long to fit"
	w1.x, w1.y = H_CENTER, V_CENTER
	setStatus( "60 wide: ends in \"...\"" )

	timer.performWithDelay( 1000, function()
		print( "\n\n Main:Increase length" )
		w1.width = 100
		setStatus( "100 wide: more of the text" )
	end)

end

-- run_example6()



--======================================================--
--== create widget, test anchors

function run_example7()

	local txt2

	txt2 = dUI.newText{
		text="inline style",

		style={
			width=225,
			height=35,

			align='right',
			fontSize=26,
			marginX=5,
			fillColor=dUI.Palette.blueDark,
			textColor={1,1,1},
		}
	}

	txt2.x = H_CENTER
	txt2.y = V_CENTER
	txt2.align='center'
	-- txt2.align='right'

	txt2:setAnchor( {0,0} )
	txt2:setAnchor( {0.5,0.5} )
	-- txt2:setAnchor( {1,1} )
	setStatus( "an inline style, anchored at its center" )


	timer.performWithDelay( 2000, function()
		txt2.style=nil -- clear style, to default
		-- the default is small black text without a fill: make it easy to see
		-- (it lies on the white marker, so a color which reads on white)
		txt2:setTextColor( unpack( dUI.Palette.purple ) )
		txt2.fontSize = 22
		setStatus( "style=nil: the default, in purple at 22" )
	end)


	timer.performWithDelay( 4000, function()
		print( "\n\nUpdate properties" )

		txt2.text="hamburger"

		txt2.width=150
		txt2.height=70

		txt2.align='right'

		txt2:setAnchor( {1,1} )

		txt2:setFillColor( 1,0,0,0.5 )
		txt2:setTextColor( 1,1,1 )

		txt2.font = native.systemFontBold

		txt2:setStrokeColor( 0,0,0,0.5 )
		txt2.strokeWidth = 4

		txt2.fontSize = 18
		txt2.marginX = 15
		txt2.marginY = 15
		setStatus( "150x70, anchored at its bottom right" )

	end)

	timer.performWithDelay( 6000, function()
		print( "\n\nUpdate properties" )

		-- txt2.x=100

		txt2.text="pizza"

		txt2.width=300
		txt2.width=60
		txt2.width=nil
		txt2.height=nil

		txt2:setAnchor( {0,0} )

		txt2.align='left'
		-- txt2:setAnchor( {0.5,0.5} )

		txt2.strokeWidth = 2
		txt2:setStrokeColor( 1,0,0,1 )

		txt2.font = native.systemFontBold
		txt2.fontSize = 30

		txt2:setFillColor( 0,0,0.5,0.8 )
		txt2:setTextColor( unpack( dUI.Palette.yellow ) )
		setStatus( "sized to its text, anchored at its top left" )

	end)

end

run_example7()

