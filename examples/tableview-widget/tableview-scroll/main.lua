--====================================================================--
-- TableView Scroll
--
-- Shows basic automated scrolling with the DMC TableView widget
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2015 David McCuskey. All Rights Reserved.
--====================================================================--



print( "\n\n#########################################################\n\n" )



--===================================================================--
--== Imports


local dUI = require 'lib.dmc_ui'



--===================================================================--
--== Setup, Constants


local W, H = dUI.WIDTH, dUI.HEIGHT
local H_CENTER, V_CENTER = W*0.5, H*0.5

local tinsert = table.insert
local tremove = table.remove

local OFFSET = 100
local DIMS = {w=280,h=30} -- dimensions of a row item
local SHOW = 14 -- how many items to display (for masking)

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
	for i = 1, 250000 do
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
local function getRows( self, section )
	-- print( "Main:getRows" )
	return #tableData
end


--- create view for table row.
-- called when table view needs to display a row
--
local function onRender( self, event )
		-- print( "Main:onRender" )
		local view = event.view
		local index = event.index
		local o

		o = display.newText( "row : "..index, 0, 0, native.systemFont, 16 )
		o.anchorX, o.anchorY = 0,0
		o:setFillColor( 0,0,0 )

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
	width=DIMS.w,
	height=DIMS.h*SHOW,
	delegate=delegate,
	estimatedRowHeight=DIMS.h,
	autoMask=true
}
tV.x, tV.y = H_CENTER-DIMS.w*0.5, V_CENTER-(DIMS.h*SHOW)*0.5

tV:reloadData()

-- timer.performWithDelay( 1000, function()
-- 	-- add table row
-- 	local pos = 5
-- 	tinsert( tableData, pos, createRowTemplate( pos ) )
-- 	tV:insertRowAt( pos )
-- end)

-- timer.performWithDelay( 2000, function()
-- 	-- delete table row
-- 	local pos = 5
-- 	tremove( tableData, pos )
-- 	tV:removeRowAt( pos )
-- end)


timer.performWithDelay( 1500, function()
	-- delete table row
	local index = 179431
	tV:scrollToRowAt( index, {position='middle', time=3000} )
end)

