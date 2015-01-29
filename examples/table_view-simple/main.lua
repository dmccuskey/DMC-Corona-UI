--====================================================================--
-- Table View Simple
--
-- Shows simple use of the DMC Widget: Table View
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2014 David McCuskey. All Rights Reserved.
--====================================================================--


print("---------------------------------------------------")


--===================================================================--
-- Imports

local widgets = require 'dmc_widgets'


--===================================================================--
-- Setup, Constants

local OFFSET = 100
<<<<<<< HEAD

local o, p, f
local x, y, w, h
=======
local DIMS = {w=200,h=100} -- dimensions of a row item
local SHOW = 3 -- how many items to display (for masking)
>>>>>>> 6ab88f79c3d0df3502524a361fae10e175363f8c


--===================================================================--
-- Support Functions

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
	o.anchorX, o.anchorY = 0.5, 0

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

<<<<<<< HEAD
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
=======

-- create Table View

local o = widgets.newTableView{
	width=DIMS.w,
	height=DIMS.h*SHOW,
	automask=false
}
o.x, o.y = OFFSET*0.5, OFFSET*0.5

>>>>>>> 6ab88f79c3d0df3502524a361fae10e175363f8c

-- create rows

for i = 1, 50 do

	local row_template = {
		isCategory = false,
<<<<<<< HEAD
		height = 300,
=======
		height = DIMS.h,
>>>>>>> 6ab88f79c3d0df3502524a361fae10e175363f8c
		onItemRender=onRender,
		onItemUnrender=onUnrender,
		onItemEvent=onEvent,
		bgColor={0.5,0,1},
		data = i
	}

	o:insertRow( row_template )

end

