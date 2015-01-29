--====================================================================--
-- Table View Simple
--
-- Shows simple use of the DMC Widget: Table View
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2014=2015 David McCuskey. All Rights Reserved.
--====================================================================--



print( "\n\n#########################################################\n\n" )



--===================================================================--
--== Imports


local Widgets = require 'lib.dmc_widgets'



--===================================================================--
--== Setup, Constants


local OFFSET = 100
local DIMS = {w=200,h=100} -- dimensions of a row item
local SHOW = 3 -- how many items to display (for masking)



--===================================================================--
--== Support Functions


-- onRender()
-- called when table view needs to display a row
--
local function onRender( event )
	-- print( 'Main:onRender' )

	local view = event.view
	local index = event.data

	local o

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
--== Main
--===================================================================--


-- create Table View

local o = Widgets.newTableView{
	width=DIMS.w,
	height=DIMS.h*SHOW,
	automask=false
}
o.x, o.y = OFFSET*0.5, OFFSET*0.5


-- create rows

for i = 1, 5 do

	local row_template = {
		isCategory = false,
		height = DIMS.h,
		onItemRender=onRender,
		onItemUnrender=onUnrender,
		onItemEvent=onEvent,
		bgColor={0.5,0,1},
		data = i
	}

	o:insertRow( row_template )

end

