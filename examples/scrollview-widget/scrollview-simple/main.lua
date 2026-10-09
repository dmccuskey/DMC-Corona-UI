--====================================================================--
-- ScrollView Simple
--
-- A scroll view which fills the screen below the status bar, whatever the
-- device, over NUM_ROWS numbered rows, masked to its size (autoMask). Drag
-- or flick it up and down; it bounces at the edges. The rows fit its
-- width, so horizontal scrolling is off. After a second it scrolls to
-- row 2 (setContentPosition()); after four scrolling is locked; after
-- eight it is back, and the content rests 10 higher (upperVerticalOffset).
-- A scroll indicator shows on the right while the content moves.
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2015 David McCuskey. All Rights Reserved.
--====================================================================--



print( '\n\n##############################################\n\n' )



--====================================================================--
--== Imports


local dUI = require 'lib.dmc_ui'



--====================================================================--
--== Setup, Constants


local tdelay = timer.performWithDelay

-- the screen, as the device reports it: config.lua asks for 320x480
-- 'letterbox', so a taller or a wider screen has room around the content
local SCREEN_W, SCREEN_H = display.actualContentWidth, display.actualContentHeight
local SCREEN_X, SCREEN_Y = display.screenOriginX, display.screenOriginY
local STATUS_BAR_H = display.topStatusBarContentHeight

-- the content
local NUM_ROWS = 20
local ROW_HEIGHT = 80



--===================================================================--
--== Main
--===================================================================--


local function callback()
	print( "here in motion callback" )
end

local widget = dUI.newScrollView{
	width=SCREEN_W,
	height=SCREEN_H-STATUS_BAR_H,
	scrollWidth=SCREEN_W,
	scrollHeight=NUM_ROWS*ROW_HEIGHT,
	-- the content is no wider than the scroll view: without this,
	-- it could still be pulled sideways, and bounce back
	horizontalScrollEnabled=false,
	autoMask=true, -- clip the content to the scroll view
}
widget.x, widget.y = SCREEN_X, SCREEN_Y+STATUS_BAR_H

-- the content: the rows, added to the scroller

for i = 0, NUM_ROWS-1 do
	local shade = i/(NUM_ROWS-1)
	local y = i*ROW_HEIGHT

	local row = display.newRect( 0, y, SCREEN_W, ROW_HEIGHT-2 )
	row.anchorX, row.anchorY = 0, 0
	row:setFillColor( 0.2+shade*0.7, 0.5, 0.9-shade*0.7 )
	widget.scroller:insert( row )

	local label = display.newText( "row "..i, SCREEN_W/2, y+ROW_HEIGHT/2, native.systemFont, 20 )
	widget.scroller:insert( label )
end


tdelay( 1000, function()
	print("start – move scroller")
	widget:setContentPosition{
		y=-2*ROW_HEIGHT, onComplete=callback
	}
end)

tdelay( 4000, function()
	print("start 2 – lock scroller")
	widget.verticalScrollEnabled = false
end)


tdelay( 8000, function()
	print("start 3 – unlock scroller ")
	widget.verticalScrollEnabled = true
	widget.upperVerticalOffset = -10
end)
