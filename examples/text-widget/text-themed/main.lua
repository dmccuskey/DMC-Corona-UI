--====================================================================--
-- Themed Background
--
-- Shows themed use of the DMC Widget: Background
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2015 David McCuskey. All Rights Reserved.
--====================================================================--



print( "\n\n#########################################################\n\n" )



--===================================================================--
--== Imports


local Widgets = require 'lib.dmc_widgets'



--===================================================================--
--== Setup, Constants


local W, H = display.contentWidth, display.contentHeight
local H_CENTER, V_CENTER = W*0.5, H*0.5

local text
local theme, style



--===================================================================--
-- Support Functions


local function widgetOnPropertyEvent_handler( event )
	print( 'Main: widgetOnPropertyEvent_handler', event.id, event.phase )
	local etype= event.type
	local property= event.property
	local value = event.value

	print( "Widget Property Changed", etype, property, value )

end

local function widgetEvent_handler( event )
	print( 'Main: widgetEvent_handler', event.id, event.phase )
	local etype= event.type

	print( "Widget Event", etype )

end



--===================================================================--
--== Main
--===================================================================--


local width, height = 100, 36
local o

--== Setup Visual Screen Items

o = display.newRect(0,0,W,H)
o:setFillColor(0.5,0.5,0.5)
o.x, o.y = H_CENTER, V_CENTER

o = display.newRect(0,0,width+4,height+4)
-- o:setFillColor(1,0,0)
o:setStrokeColor(0,0,0)
o.strokeWidth=2
o.x, o.y = H_CENTER, V_CENTER

o = display.newRect( 0,0,10,10)
o:setFillColor(1,0,0)
o.x, o.y = H_CENTER, V_CENTER


--== Setup Widget


--== create widget, default style

text1 = Widgets.newText{}
text1.text = "default style"
text1.x, text1.y = H_CENTER, 25


--== Create Widget, inline style

text2 = Widgets.newText{
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

text2.x = H_CENTER
text2.y = V_CENTER

text2.align='left'
-- text2.align='center'
-- text2.align='right'

text2:setAnchor( {0,0} )
-- text2:setAnchor( {0.5,0.5} )
-- text2:setAnchor( {1,1} )

timer.performWithDelay( 1000, function()
	text2.style=nil
end)


-- timer.performWithDelay( 1000, function()
-- 	print( "\n\nUpdate properties" )

-- 	text2.text="hamburger"

-- 	text2.width=300
-- 	text2.height=70

-- 	text2.align='right'

-- 	text2:setAnchor( {1,1} )

-- 	text2:setFillColor( 1,0,0,0.5 )
-- 	text2:setTextColor( 1,0,0,0.5 )

-- 	text2.font = native.systemFontBold

-- 	text2:setStrokeColor( 0,0,0,0.5 )
-- 	text2.strokeWidth = 4

-- 	text2.fontSize = 18
-- 	text2.marginX = 15
-- 	text2.marginY = 15

-- end)

-- timer.performWithDelay( 2000, function()
-- 	print( "\n\nUpdate properties" )

-- 	text2.x=100

-- 	text2.text="pizza"

-- 	text2.width=nil
-- 	text2.height=nil

-- 	text2.align='center'
-- 	text2:setAnchor( {0.5,0.5} )

-- 	text2.strokeWidth = 2
-- 	text2:setStrokeColor( 1,0,0,1 )

-- 	text2.font = native.systemFontBold
-- 	text2.fontSize = 30

-- 	text2:setFillColor( 0,0,0.5,0.8 )
-- 	text2:setTextColor( 1,0,1,0.5 )

-- end)



-- timer.performWithDelay( 2000, function()
-- 	text:removeSelf()
-- end)


--== create style, widget

-- style = Widgets.newTextStyle{
-- 	name='my-text-style',
-- 	fillColor={1,0,0},
-- 	textColor={1,1,1}
-- }

-- text3 = Widgets.newText{
-- 	text="third style"
-- }
-- text3.style = style
-- text3.x, text3.y = 150, 100

-- text3:setFillColor( 1,0.5,0.5,0.5 )
-- text3:setTextColor( 1,0,0,0.5 )
-- text3.align='left'
-- text3.width=200

-- text3 = Widgets.newText{
-- 	text="one two",
-- 	style=style
-- }
-- text3.x=100
-- text3.y=100


