--====================================================================--
-- TableView Modify
--
-- Rows added to and removed from a table view which fills the screen below
-- the status bar. It starts with NUM_ROWS rows, fewer than fill it. After
-- two seconds a row is inserted at 5 (insertRowAt()), after four another
-- is added below the last one, after six row 5 is removed again
-- (removeRowAt()). The app changes its own data first, then tells the
-- table view, which asks the delegate for the rows again. Each row shows
-- its number in the list and the name of its item, so the rows below a
-- change count up or down. The rows are gray with a red line
-- (setBackgroundColor(), setLineColor() on the row); below them the table
-- view's own color shows (fillColor in its style, transparent by default).
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


local W, H = dUI.WIDTH, dUI.HEIGHT

local tinsert = table.insert
local tremove = table.remove
local tdelay = timer.performWithDelay

-- the screen, as the device reports it
local STATUS_BAR_H = display.topStatusBarContentHeight

-- the content
local NUM_ROWS = 8
local ROW_HEIGHT = 44

local tableData = nil -- later



--===================================================================--
--== Support Functions


-- this structure is not important to the TableView
--
local function createRowTemplate( name )
	return {
		name=name,
		data=system.getTimer()
	}
end

-- create our array of data
-- this could be from a server, or local
--
local function createDataArray()
	local list = {}
	for i = 1, NUM_ROWS do
		local row_template = createRowTemplate( "item "..i )
		tinsert( list, row_template )
	end
	return list
end


--======================================================--
-- Delegate Functions

-- getRows()
-- called by table view when figuring data
--
local function getRows( self, tableview, section )
	-- print( "numberOfRows" )
	return #tableData
end

-- onRender()
-- called when table view needs to display a row
--
local function onRender( self, event )
	-- print( "rowOnRender", event )
	local row = event.row
	local view = event.view
	local index = event.index
	local o

	o = display.newText( "ROW "..index.." : "..tableData[index].name, 0, 0, native.systemFont, 18 )
	o.anchorX, o.anchorY = 0,0.5
	o.x, o.y = 15, ROW_HEIGHT/2
	o:setFillColor( 1,1,1 )

	row:setBackgroundColor( 0.4,0.4,0.4 )
	row:setLineColor( 1,0,0,0.5 )

	view:insert( o )
	view._txt = o
end

-- onUnrender()
-- called when table view needs to destroy a row
--
local function onUnrender( self, event )
	-- print( "rowOnUnrender", event )
	local view = event.view

	view._txt:removeSelf()
	view._txt=nil
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
	onRowUnrender=onUnrender
}

-- create Table View

local tV = dUI.newTableView{
	width=W,
	height=H-STATUS_BAR_H,
	delegate=delegate,
	estimatedRowHeight=ROW_HEIGHT,
	autoMask=true, -- clip the rows to the table view
	style={ fillColor={ 0.2, 0.2, 0.25, 1 } } -- behind the rows
}
tV.x, tV.y = 0, STATUS_BAR_H

tV:reloadData()

tdelay( 2000, function()
	-- add table row
	local pos = 5
	tinsert( tableData, pos, createRowTemplate( "inserted" ) )
	tV:insertRowAt( pos )
end)

tdelay( 4000, function()
	-- add table row, after the last one
	local pos = #tableData+1
	tinsert( tableData, pos, createRowTemplate( "added at the end" ) )
	tV:insertRowAt( pos )
end)

tdelay( 6000, function()
	-- delete table row
	local pos = 5
	tremove( tableData, pos )
	tV:removeRowAt( pos )
end)
