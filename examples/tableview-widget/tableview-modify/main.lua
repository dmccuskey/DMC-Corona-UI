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
local SHOW = 10 -- how many items to display (for masking)

local tabledata = nil -- later



--===================================================================--
--== Support Functions


-- this structure is not important to the TableView
--
local function createRowTemplate( idx )
	return {
		index=idx,
		type='row-data', -- this is our template type
		data=system.getTimer()
	}
end

-- create our array of data
-- this could be from a server, or local
--
local function createDataArray()
	local list = {}
	for i = 1, 20 do
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
	return #tabledata
end

-- onRender()
-- called when table view needs to display a row
--
local function onRender( self, event )
		-- print( "rowOnRender", event )
		local group = event.view
		local index = event.index
		local data = event.data
		local o, f, p  -- object, function, params
		local d = tabledata[index].data

		o = display.newText( "row : "..d, 0, 0, native.systemFont, 16 )
		o.anchorX, o.anchorY = 0,0
		o.x, o.y = 0,0
		o:setFillColor( 1,1,1 )

		group:insert( o )
		group._txt = o
	end

-- onUnrender()
-- called when table view needs to destroy a row
--
local function onUnrender( self, event )
	-- print( "rowOnUnrender", event )
	local group = event.view

	group._txt:removeSelf()
	group._txt=nil
end



--===================================================================--
--== Main
--===================================================================--


-- get our table view data

tabledata = createDataArray()

-- setup tableview delegate/helper

local delegate = {
	numberOfRows=getRows,
	onRowRender=onRender,
	onRowUnrender=onUnrender
}

-- create Table View

local tV = dUI.newTableView{
	width=DIMS.w,
	height=DIMS.h*SHOW,
	delegate=delegate,
	dataSource=tabledata,
	estimatedRowHeight=DIMS.h
}
tV.x, tV.y = OFFSET*0.5, OFFSET*0.5+50

tV:reloadData()

timer.performWithDelay( 1000, function()
	-- add table row
	local pos = 5
	tinsert( tabledata, pos, createRowTemplate( pos ) )
	tV:insertRowAt( pos )
end)

timer.performWithDelay( 2000, function()
	-- delete table row
	local pos = 5
	tremove( tabledata, pos )
	tV:removeRowAt( pos )
end)


