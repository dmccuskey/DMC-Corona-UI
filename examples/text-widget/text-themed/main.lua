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


-- create widget, default style

text = Widgets.newText{
	text="TKghe",

	style={
		width=150,
		height=35,

		align='right',
		fontSize=20,
		marginX=10,
		fillColor={0.5,0,0.25},
		textColor={1,0,0},
	}
}


text.x = H_CENTER
text.y = V_CENTER

-- text.align='left'
-- text.align='center'
-- text.align='right'

-- text:setAnchor( {0,0} )
text:setAnchor( {0.5,0.5} )
text:setAnchor( {1,1} )


-- timer.performWithDelay( 1000, function()
-- 	text.text="hamburger"
-- 	text.anchorX=0.5
-- 	text.align='center'
-- 	text:setTextColor( 0,1,0 )
-- end)


-- timer.performWithDelay( 2000, function()
-- 	text:removeSelf()
-- end)


-- create a style

style = Widgets.newTextStyle{
	name='my-text-style',
	x=50,
	y=100,
	textColor={1,0,1}
}

-- style:cloneStyle()

-- text2 = Widgets.newText{
-- 	text="hello there"
-- }
-- text2.style = style


-- text3 = Widgets.newText{
-- 	text="one two",
-- 	style=style
-- }
-- text3.x=100
-- text3.y=100


