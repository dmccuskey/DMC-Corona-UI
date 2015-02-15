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

local background
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


-- create background widget, default style

-- background = Widgets.newBackground{}

-- background.x = H_CENTER
-- background.y = V_CENTER

-- background:setAnchor( {0,0} )
-- background:setAnchor( {0.5,0.5} )
-- background:setAnchor( {1,1} )

-- background.y = 400

-- create a style

style = Widgets.newBackgroundStyle{
	name='background-style',
	anchorX=0.5,
	anchorY=0.5,
	width=100,
	height=20,
	strokeWidth=5,
	strokeColor={0,0,1},
	fillColor={0.5,0.5,0.5}
}


-- create background widget, based on style

bg2 = Widgets.newBackground{
	x=100,
	y=100,
	style=style,
}




-- background:addEventListener( background.EVENT, widgetEvent_handler )
-- background.onProperty = widgetOnPropertyEvent_handler

-- background.x = H_CENTER
-- background.y = V_CENTER

-- background:setAnchor( {0,0})
-- background:setAnchor( {0.5,0.5})
-- background:setAnchor( {1,1})

-- background.y = 400



bg3 = Widgets.newBackground{
	style={
		fillColor={1,1,0,1}
	},
}

-- -- bg3.x, bg3.y = 200, 100
-- bg3:setAnchor( {0,0})

-- bg3.strokeWidth = 2

-- bg3:setFillColor( 0,1,0,0.5 )


