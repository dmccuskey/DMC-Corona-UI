--====================================================================--
-- Table View Simple
--
-- Shows simple use of the DMC Widget: Table View
--
-- by David McCuskey
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2014 David McCuskey. All Rights Reserved.
--====================================================================--

print("---------------------------------------------------")



--===================================================================--
-- Imports
--===================================================================--

local widgets = require( 'dmc_widgets' )


--===================================================================--
-- Setup, Constants
--===================================================================--

local W,H = display.contentWidth, display.contentHeight
local H_CENTER, V_CENTER = W*0.5, H*0.5

local OFFSET = 100

local o, p, f
local x, y, w, h


--===================================================================--
-- Support Functions
--===================================================================--

-- onRender()
-- called when table view needs to display a row
--
local function onRender( event )
	-- print( 'Main:onRender' )

	local view = event.view
	local index = event.data

	local o, d

	o = display.newRect( 0,0, W-OFFSET, 300 )
	o.anchorX, o.anchorY = 0,0
	o.strokeWidth=2
	o:setStrokeColor( 0.5, 0.5, 0 )
	o.x, o.y = 0,0
	view:insert( o )

	d = index % 3
	print( 'Main:onRender ', index, d )
	if d == 1 then
		o:setFillColor( 1, 0, 0 )
	elseif d == 2 then
		o:setFillColor( 0, 1, 0 )
	else
		o:setFillColor( 0, 0, 1 )
	end

	o = display.newText( tostring(index), 40,30, native.systemFont, 32)
	o.anchorX, o.anchorY = 0.5,0
	view:insert( o )

	view._o = o

end

-- onUnrender()
-- called when table view needs to destroy a row
--
local function onUnrender( event )
	-- print( 'Main:onUnrender' )

	local view = event.view
	local o

	o = view._o
	o:removeSelf()

	view._o = nil

end

-- onEvent()
-- called when table view needs to send an event to a row
--
local function onEvent( event )
	-- print( 'onEvent' )

end


--===================================================================--
-- Main
--===================================================================--

y = OFFSET
o = display.newLine( 10, y, W-10, y )
o:setStrokeColor( 1, 0, 0 )
o.strokeWidth = 3

h = H-OFFSET*4
y = OFFSET+h
o = display.newLine( 10, y, W-10, y )
o:setStrokeColor( 1, 0, 0 )
o.strokeWidth = 3



-- create Table View

p = {
	width=W-OFFSET,
	height=h,
}
o = widgets.newTableView( p )
o.x, o.y = OFFSET*0.5, OFFSET

-- create rows

for i = 1, 50 do

	local p = {
		isCategory = false,
		height = 300,
		onItemRender=onRender,
		onItemUnrender=onUnrender,
		onItemEvent=onEvent,
		data = i
	}

	o:insertRow( p )

end

