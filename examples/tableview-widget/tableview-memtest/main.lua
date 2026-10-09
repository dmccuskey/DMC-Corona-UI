--====================================================================--
-- TableView Memtest
--
-- Stress test for TableView and TableViewCell: creates a table view as
-- wide as the screen, between the name and the line at the bottom, with
-- TableViewCell rows, and removes it DELAY (100) ms later, over and over,
-- and prints memory use with dmc-performance. run_example1() to 3() do
-- the same with a TableView style, a TableViewCell style and a single
-- TableViewCell. The line at the bottom counts the cycles. The backdrop
-- fills the screen on any device.
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2015 David McCuskey. All Rights Reserved.
--====================================================================--



print( '\n\n##############################################\n\n' )



--====================================================================--
--== Imports


local dUI = require 'lib.dmc_ui'

local Perf = require 'lib.dmc_corona.dmc_performance'



--====================================================================--
--== Setup, Constants


local mrandom = math.random
local tinsert, tremove = table.insert, table.remove
local tstr = tostring
local tdelay = timer.performWithDelay
math.randomseed( os.time() )

-- the screen, as the device reports it: config.lua asks for 320x480
-- 'letterbox', so a taller or a wider screen has room around the content
local SCREEN_W, SCREEN_H = display.actualContentWidth, display.actualContentHeight
local SCREEN_X, SCREEN_Y = display.screenOriginX, display.screenOriginY
local H_CENTER, V_CENTER = display.contentCenterX, display.contentCenterY
local STATUS_BAR_H = display.topStatusBarContentHeight

-- the name at the top and the line at the bottom (later) each take a band
local BAND_H = 60
local status = nil

-- the content
local NUM_ROWS = 50
local ROW_HEIGHT = 50

local tableData = nil -- later
local cellStyle = nil

local cellCache = {}

local images = {
	'assets/flag/Arabia.png',
	'assets/flag/Argentina.png',
	'assets/flag/Australia.png',
	'assets/flag/Brasil.png',
	'assets/flag/Canada.png',
	'assets/flag/Catalunya-Catalonia.png',
	'assets/flag/Chile.png',
	'assets/flag/Colombia.png',
	'assets/flag/Danmark-Denmark.png',
	'assets/flag/Deutschland-Germany.png',
	'assets/flag/Eire-Ireland.png',
	'assets/flag/Ellas-Greece.png',
	'assets/flag/Espanya-Spain.png',
	'assets/flag/Extremadura.png',
	'assets/flag/France.png',
	'assets/flag/Guatemala.png',
	'assets/flag/Island.png',
	'assets/flag/Italia.png',
	'assets/flag/Libya.png',
	'assets/flag/Masr-Egypt.png',
	'assets/flag/Mexico.png',
	'assets/flag/Nederlands-Netherlands.png',
	'assets/flag/NewZealand.png',
	'assets/flag/Nihon-Japan.png',
	'assets/flag/Norge-Norway.png',
	'assets/flag/Polska-Poland.png',
	'assets/flag/Rossiya-Russia.png',
	'assets/flag/Suomi-Finland.png',
	'assets/flag/Sverige-Sweden.png',
	'assets/flag/UK.png',
	'assets/flag/USA.png',
	'assets/flag/Venezuela.png',
	'assets/flag/Zambia.png',
	'assets/flag/Zhongguo-China.png'
}




--===================================================================--
--== Support Functions


--======================================================--
-- Setup Visual Screen Items

-- a backdrop the size of the screen, the example's name at the top
-- and a line at the bottom which counts the cycles (setStatus())
--
local function setupBackground()
	local o

	o = display.newRect( H_CENTER, V_CENTER, SCREEN_W, SCREEN_H )
	o:setFillColor( 0.17, 0.24, 0.31 )

	o = display.newText( "TableView Memtest", H_CENTER, SCREEN_Y+STATUS_BAR_H+30, native.systemFontBold, 20 )

	status = display.newText( "", H_CENTER, SCREEN_Y+SCREEN_H-30, native.systemFont, 16 )
end

local function setStatus( text )
	status.text = text
end


local function getRandomImage()
	local idx = mrandom( 1, #images )
	return images[idx]
end


--- create data structure for the row.
-- the content of the data structure is not important to the TableView
--
local function createRowStructure( idx )
	return {
		index=idx,
		title = "Row title for "..tstr( idx ),
		image = getRandomImage(),
		detail = "some detail explanation",
		type='row-data', -- this is our template type
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
	local view = event.view
	local index = event.index
	local tc

	local rowData = tableData[ index ] -- our data source

	-- a cell from a row which left the screen, or a new one
	if #cellCache>0 then
		tc = tremove( cellCache, 1 )
		tc.isVisible = true
	else
		tc = dUI.newTableViewCell{ width=SCREEN_W, height=ROW_HEIGHT, style=cellStyle }
	end

	tc.textLabel.text = rowData.title
	tc.textDetail.text = rowData.detail

	view:insert( tc.view )
	view.cell = tc -- the table view highlights a row's 'cell'

end


--- destroy view for table row.
-- called when table view is removing a row
--
local function onUnrender( self, event )
	-- print( "Main:onUnrender" )
	local view = event.view
	local tc

	-- keep the cell for another row
	tc = view.cell
	display.getCurrentStage():insert( tc.view )
	tc.isVisible = false
	tinsert( cellCache, tc )

	view.cell = nil
end


--- onEvent()
-- called when table view tells about a row
--
local function onEvent( self, event )
	-- print( "Main:onEvent", event.type )
	local etype = event.type
	local tv = event.target -- our table view

	if etype == tv.SHOULD_HIGHLIGHT_ROW then
		-- print( "should highlight" )
		return true -- << this is important, true/false
	elseif etype == tv.HIGHLIGHT_ROW then
		-- print( "row did highlight" )
	elseif etype == tv.UNHIGHLIGHT_ROW then
		-- print( "row did UNhighlight" )
	elseif etype == tv.WILL_SELECT_ROW then
		-- print( "Will Select ", event.index )
		return event.index -- << this row, another, or nil for none
	elseif etype == tv.SELECTED_ROW then
		print( "Selected ", event.index )
	else
		print( 'onEvent', event.type )
	end

end



--===================================================================--
--== Main
--===================================================================--


setupBackground()

tableData = createDataArray()

local delegate = {
	numberOfRows=getRows,
	onRowRender=onRender,
	onRowUnrender=onUnrender,

	shouldHighlightRow=onEvent,
	didHighlightRow=onEvent,
	didUnhighlightRow=onEvent,
	willSelectRow=onEvent,
	didSelectRow=onEvent,
}


--======================================================--
--== stress test TableView Style

function run_example1()

	local createItem, destroyItem
	local DELAY = 50
	local count = 0
	local o

	createItem = function()
		count=count+1
		o = dUI.newTableViewStyle()

		tdelay( DELAY, function()
			destroyItem()
		end)
	end

	destroyItem = function()
		o:removeSelf()
		o = nil
		if count%10==0 then
			print( "cycles completed: ", count )
			setStatus( "cycles completed: "..count )
		end
		tdelay( DELAY, function()
			createItem()
		end)
	end

	print( "Main: Starting" )
	setStatus( "running" )
	createItem()
	Perf.watchMemory( 2500 )

end

-- run_example1()


--======================================================--
--== stress test TableViewCell Style

function run_example2()

	local createItem, destroyItem
	local DELAY = 250
	local count = 0
	local o

	createItem = function()
		count=count+1
		o = dUI.newTableViewCellStyle()

		tdelay( DELAY, function()
			destroyItem()
		end)
	end

	destroyItem = function()
		o:removeSelf()
		o = nil
		if count%10==0 then
			print( "cycles completed: ", count )
			setStatus( "cycles completed: "..count )
		end
		tdelay( DELAY, function()
			createItem()
		end)
	end

	print( "Main: Starting" )
	setStatus( "running" )
	createItem()
	Perf.watchMemory( 2500 )

end

-- run_example2()


--======================================================--
--== stress test TableViewCell

function run_example3()

	local createItem, destroyItem
	local DELAY = 100
	local count = 0
	local o

	createItem = function()
		count=count+1
		o = dUI.newTableViewCell{ width=SCREEN_W, height=ROW_HEIGHT, labelText="cell "..count }
		o.x, o.y = SCREEN_X, SCREEN_Y+STATUS_BAR_H+BAND_H

		tdelay( DELAY, function()
			destroyItem()
		end)
	end

	destroyItem = function()
		o:removeSelf()
		o = nil
		if count%10==0 then
			print( "cycles completed: ", count )
			setStatus( "cycles completed: "..count )
		end
		tdelay( DELAY, function()
			createItem()
		end)
	end

	print( "Main: Starting" )
	setStatus( "running" )
	createItem()
	Perf.watchMemory( 2500 )

end

-- run_example3()


--======================================================--
--== stress test TableView

function run_example4()

	local createItem, destroyItem
	local DELAY = 100
	local count = 0
	local o

	createItem = function()
		count=count+1
		o = dUI.newTableView{
			width=SCREEN_W,
			height=SCREEN_H-STATUS_BAR_H-2*BAND_H,
			delegate=delegate,
			estimatedRowHeight=ROW_HEIGHT,
			autoMask=true -- clip the rows to the table view
		}
		o.x, o.y = SCREEN_X, SCREEN_Y+STATUS_BAR_H+BAND_H
		o:reloadData()

		tdelay( DELAY, function()
			destroyItem()
		end)
	end

	destroyItem = function()
		o:removeSelf()
		-- the cells its rows left in the cache
		for i=#cellCache, 1, -1 do
			tremove( cellCache, i ):removeSelf()
		end
		o = nil
		if count%10==0 then
			print( "cycles completed: ", count )
			setStatus( "cycles completed: "..count )
		end
		tdelay( DELAY, function()
			createItem()
		end)
	end

	print( "Main: Starting" )
	setStatus( "running" )
	createItem()
	Perf.watchMemory( 2500 )

end

run_example4()
