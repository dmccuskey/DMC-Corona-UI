--====================================================================--
-- TableView Simple
--
-- A table view which fills the screen below the status bar, whatever the
-- device, over NUM_ROWS rows of ROW_HEIGHT, masked to its size (autoMask).
-- Drag or flick it up and down; it bounces at the edges, and a scroll
-- indicator shows on the right while it moves. A delegate supplies the
-- rows: how many there are, and what a row shows when the table view
-- asks for it (only the rows near the screen exist). Tap a row and the
-- app prints its number; when the list comes to rest it prints where
-- (the delegate's didEndScrolling), and whether that is an end of the list.
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2014-2015 David McCuskey. All Rights Reserved.
--====================================================================--



print( '\n\n##############################################\n\n' )



--====================================================================--
--== Imports


local dUI = require 'lib.dmc_ui'



--====================================================================--
--== Setup, Constants


local tinsert = table.insert

-- the screen, as the device reports it: config.lua asks for 320x480
-- 'letterbox', so a taller or a wider screen has room around the content
local SCREEN_W, SCREEN_H = display.actualContentWidth, display.actualContentHeight
local SCREEN_X, SCREEN_Y = display.screenOriginX, display.screenOriginY
local STATUS_BAR_H = display.topStatusBarContentHeight

-- the content
local NUM_ROWS = 50
local ROW_HEIGHT = 44

local tableData = nil -- later



--===================================================================--
--== Support Functions


--- create data structure for the row.
-- the content of the data structure is not important to the TableView
--
local function createRowStructure( idx )
	return {
		index=idx,
		data=system.getTimer()
	}
end


--- create our array of data for the tableview
-- this could be from a server or local
--
local function createDataArray()
	local list = {}
	for i = 1, NUM_ROWS do
		local row_template = createRowStructure( i )
		tinsert( list, row_template )
	end
	return list
end


--======================================================--
-- Delegate Functions

--- return number of data rows.
-- called by table view when figuring data
--
local function getRows( self, tableview, section )
	-- print( "Main:getRows" )
	return #tableData
end


--- create view for table row.
-- called when table view needs to display a row
local function onRender( self, event )
	-- print( 'Main:onRender' )
	local row = event.row
	local view = event.view
	local index = event.index
	local o

	o = display.newText( "row : "..index, 0, 0, native.systemFont, 18 )
	o.anchorX, o.anchorY = 0, 0.5
	o.x, o.y = 15, ROW_HEIGHT/2
	o:setFillColor(0,0,0)

	row:setLineColor( 0.8,0.8,0.8 )

	view:insert( o )
	view._txt = o
end


-- onUnrender()
-- called when table view needs to destroy a row
--
local function onUnrender( self, event )
	-- print( 'Main:onUnrender' )
	local view = event.view

	view._txt:removeSelf()
	view._txt = nil

end


--- a row was tapped.
--
local function onSelect( self, event )
	print( "Selected row", event.index )
end


--- the list came to rest.
-- willBeginScrolling and didScroll (each move) get the same event
--
local function onEndScrolling( self, event )
	local tv = event.target -- our table view
	local where = ""
	if event.verticalLimit==tv.HIT_TOP_LIMIT then
		where = "(the top)"
	elseif event.verticalLimit==tv.HIT_BOTTOM_LIMIT then
		where = "(the bottom)"
	end
	print( "Scrolled to", event.y, where )
end




--===================================================================--
--== Main
--===================================================================--


-- get our table view data

tableData = createDataArray()

-- setup tableview delegate/helper

local delegate = {
	numberOfRows=getRows,
	onRowRender=onRender,
	onRowUnrender=onUnrender,
	didSelectRow=onSelect,
	didEndScrolling=onEndScrolling,
}

-- create Table View

local tV = dUI.newTableView{
	width=SCREEN_W,
	height=SCREEN_H-STATUS_BAR_H,
	delegate=delegate,
	estimatedRowHeight=ROW_HEIGHT,
	autoMask=true -- clip the rows to the table view
}
tV.x, tV.y = SCREEN_X, SCREEN_Y+STATUS_BAR_H

tV:reloadData()
