--====================================================================--
-- TableView Scroll
--
-- Scrolling to a row with scrollToRowAt(), in a table view which fills the
-- screen below the status bar over NUM_ROWS (250,000) rows. After a second
-- and a half it scrolls for three seconds, until row TARGET_ROW is in the
-- middle of the view; that row is marked. On the way the rows pass too
-- fast to read: the table view only makes the ones near the screen. The
-- scroll indicator on the right is at its shortest, with so many rows.
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


local tinsert = table.insert
local tdelay = timer.performWithDelay

-- the screen, as the device reports it: config.lua asks for 320x480
-- 'letterbox', so a taller or a wider screen has room around the content
local SCREEN_W, SCREEN_H = display.actualContentWidth, display.actualContentHeight
local SCREEN_X, SCREEN_Y = display.screenOriginX, display.screenOriginY
local STATUS_BAR_H = display.topStatusBarContentHeight

-- the content
local NUM_ROWS = 250000
local ROW_HEIGHT = 44
local TARGET_ROW = 179431

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
--
local function onRender( self, event )
	-- print( "Main:onRender" )
	local row = event.row
	local view = event.view
	local index = event.index
	local o

	o = display.newText( "row : "..index, 0, 0, native.systemFont, 18 )
	o.anchorX, o.anchorY = 0, 0.5
	o.x, o.y = 15, ROW_HEIGHT/2
	o:setFillColor( 0,0,0 )

	row:setLineColor( 0.8,0.8,0.8 )
	if index==TARGET_ROW then
		row:setBackgroundColor( 1,0.9,0.5 )
	end

	view:insert( o )
	view._txt = o
end


--- onUnrender()
-- called when table view needs to destroy a row
--
local function onUnrender( self, event )
	-- print( "Main:onUnrender" )
	local view = event.view
	view._txt:removeSelf()
	view._txt = nil
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


tdelay( 1500, function()
	-- scroll to a row
	tV:scrollToRowAt( TARGET_ROW, {position='middle', time=3000} )
end)
