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


local Widgets = require 'lib.dmc_widgets'



--===================================================================--
--== Setup, Constants


local W, H = display.contentWidth, display.contentHeight
local H_CENTER, V_CENTER = W*0.5, H*0.5

local text

local FontMgr = Widgets.FontMgr


--===================================================================--
-- Support Functions


local function textOnUpdate_handler( event )
	print( 'Main: textOnUpdate_handler', event.id, event.phase )
	local text = event.target
	print( "size", text.width, text.height )
end



--===================================================================--
--== Main
--===================================================================--

local p = {
	sizes = { 12, 16, 25, 50, 100 },
	[12] = { offsetX=0, offsetY=0 },
	[16] = { offsetX=0, offsetY=-5 },
	[25] = { offsetX=0, offsetY=-5 },
	[50] = { offsetX=10, offsetY=-5 },
	[100] = { offsetX=0, offsetY=-5 }
}

FontMgr:setFontMetric( native.systemFontBold, p )


local o = display.newRect( 0,0,W,H)
o.x, o.y = H_CENTER, V_CENTER

o = display.newRect( 0,0,10,10)
o.x, o.y = H_CENTER, V_CENTER
o:setFillColor(1,0,0)

-- create text

text = Widgets.newText{
	text = "hello there",
	font = native.systemFontBold,
	fontSize = 12,
	fillColor = nil,
	marginY=5
}
text.onUpdate = textOnUpdate_handler

text.width = 125
text:setBgFillColor( 0.5,0.2,0.7 )

text.x = H_CENTER
text.y = V_CENTER

-- text:setAnchor( {0.5,1})
text.anchorX = 0.5
text.anchorY = 0.5

text.text = "hello there"

text.fontSize = 12

text.fontSize = 12
text.font = native.systemFont
text.font = native.systemFontBold
text.align = text.RIGHT
-- text.align = text.CENTER
text.align = text.LEFT

text.marginX = 20
text.marginX = 5
text.marginY = 5

-- text.width = 100

-- text.width = nil

text:setFillColor( 1,0,0,0.5 )
text:setFillColor( 0,1,1,0.5 )
