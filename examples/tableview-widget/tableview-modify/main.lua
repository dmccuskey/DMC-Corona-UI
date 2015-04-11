--====================================================================--
-- TableView Simple
--
-- Shows basic use of the DMC TableView widget
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2014-2015 David McCuskey. All Rights Reserved.
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
local DIMS = {w=200,h=30} -- dimensions of a row item
local SHOW = 6 -- how many items to display (for masking)

local tableData = nil -- later



--===================================================================--
--== Support Functions


-- this structure is not important to the TableView
--
local function createRowTemplate( idx )
	return {
		index=idx,
		data=system.getTimer()
	}
end

-- create our array of data
-- this could be from a server, or local
--
local function createDataArray()
	local list = {}
	for i = 1, 12 do
		local row_template = createRowTemplate( i )
		tinsert( list, row_template )
	end
	return list
end


--======================================================--
-- Delegate Functions

-- getRows()
-- called by table view when figuring data
--
local function getRows( self, section )
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
		local data = event.data
		local o, f, p  -- object, function, params
		local d = tableData[index].data

		o = display.newText( "ROW : "..index.." "..d, 0, 0, native.systemFont, 16 )
		o.anchorX, o.anchorY = 0,0.5
		o.x, o.y = 10, view.height/2
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
}

local dataSource = {
	numberOfRows=getRows,
	onRowRender=onRender,
	onRowUnrender=onUnrender
}

-- create Table View

local tV = dUI.newTableView{
	width=DIMS.w,
	height=DIMS.h*SHOW,
	delegate=delegate,
	dataSource=dataSource,
	estimatedRowHeight=DIMS.h
}
tV.x, tV.y = OFFSET*0.5, OFFSET*0.5+50

tV:reloadData()

timer.performWithDelay( 1000, function()
	-- add table row
	local pos = 5
	tinsert( tableData, pos, createRowTemplate( pos ) )
	tV:insertRowAt( pos )
end)

timer.performWithDelay( 2000, function()
	-- delete table row
	local pos = 5
	tremove( tableData, pos )
	tV:removeRowAt( pos )
end)



