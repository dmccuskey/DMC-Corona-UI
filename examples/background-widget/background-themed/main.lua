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

-- handles button-type taps
--
local function widgetEvent_handler( event )
	-- print( 'Main: widgetEvent_handler', event.type )
	local etype= event.type
	local target=event.target

	if etype==target.PRESSED then
		print( "Background: touch started" )
	elseif etype==target.RELEASED then
		print( "Background: touch ended" )
	end

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



--======================================================--
--== create background widget, default style

bg1 = Widgets.newBackground{}
bg1:addEventListener( bg1.EVENT, widgetEvent_handler )
bg1.onProperty = widgetOnPropertyEvent_handler

bg1.x = H_CENTER
bg1.y = V_CENTER

-- bg1:setAnchor( {0,0} )
bg1:setAnchor( {0.5,0.5} )
-- bg1:setAnchor( {1,1} )

bg1.y = 400


timer.performWithDelay( 1000, function()
	bg1.style=nil -- shouldn't change, already default
end)


--======================================================--
--== create background, inline style

bg2 = Widgets.newBackground{
	x=100,
	y=100,

	style={
		width=100,
		height=20,

		anchorX=1,
		anchorY=0.5,
		strokeWidth=5,
		strokeColor={0,0,1},
		fillColor={0.5,1,0.5,0.5}
	}
}
bg2:addEventListener( bg2.EVENT, widgetEvent_handler )
bg2.onProperty = widgetOnPropertyEvent_handler


timer.performWithDelay( 1000, function()
	print( "\n\nUpdate properties" )

	bg2.x = H_CENTER
	bg2.y = V_CENTER

	bg2.width=300
	bg2.height=70

	bg2:setAnchor( {0,1} )

	bg2:setFillColor( 1,0.5,0.2,0.5 )
	bg2:setStrokeColor( 2,0,0,1 )
	bg2.strokeWidth = 1
end)


timer.performWithDelay( 2000, function()
	print( "\n\nUpdate properties" )
	bg2.style=nil
end)


--======================================================--
--== Create Style, add to Widget

-- create a style

style = Widgets.newBackgroundStyle{
	name='my-background-style',

	width=20,
	height=20,

	anchorX=1,
	anchorY=0.5,
	strokeWidth=5,
	strokeColor={0,0,0},
	fillColor={1,1,0.5,0.5}
}

-- add to widget

bg3 = Widgets.newBackground{
	x=H_CENTER,
	y=50,
	style=style
}
bg3:addEventListener( bg3.EVENT, widgetEvent_handler )
bg3.onProperty = widgetOnPropertyEvent_handler


timer.performWithDelay( 2000, function()
	print( "\n\nUpdate properties" )
	bg3.style=nil
	bg3.y=100
	bg3:setFillColor( 0.7, 0.5, 0.6, 1)
end)


--======================================================--
--== create background widget, test hit area

bg4 = Widgets.newBackground{}
bg4:addEventListener( bg4.EVENT, widgetEvent_handler )

bg4.x = H_CENTER
bg4.y = V_CENTER-100

bg4:setFillColor( 0.2,0.6,1, 0.5 )

bg4:setAnchor( {0,0} )
-- bg4:setAnchor( {0.5,0.5} )
-- bg4:setAnchor( {1,1} )

bg4.hitMarginX=5
bg4.hitMarginY=10
-- bg4:setHitMargin( {0,8} )

bg4.isHitActive=true
bg4.debugOn = true

timer.performWithDelay( 1000, function()
	print("\n\nUpdate Properties")
	bg4.hitMarginX=5
	bg4.hitMarginY=10
	bg4:setHitMargin( {3,5} )
end)


timer.performWithDelay( 2000, function()
	bg4.style:clear()
end)





