--====================================================================--
-- TableViewCell
--
-- TableViewCell rows in a table view which fills the screen below the
-- status bar: each has a flag (imageView), a title and a detail line (the
-- 'subtitle' layout) and a disclosure indicator on the right (the default
-- accessory). One TableViewCell style, made once, sizes the text for rows
-- of ROW_HEIGHT. The cells are reused: a row which leaves the screen puts
-- its cell in a cache, and the next row to appear takes it. Touch a row
-- and it is highlighted (the style's 'active' state); tap it and the app
-- prints its number (the delegate's didSelectRow).
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


local W, H = dUI.WIDTH, dUI.HEIGHT

local mrandom = math.random
local tinsert, tremove = table.insert, table.remove
local tstr = tostring

math.randomseed( os.time() )

-- the screen, as the device reports it
local STATUS_BAR_H = display.topStatusBarContentHeight

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
		tc = dUI.newTableViewCell{ width=W, height=ROW_HEIGHT, style=cellStyle }
	end

	tc.textLabel.text = rowData.title
	tc.textDetail.text = rowData.detail

	tc.imageView = display.newImageRect( rowData.image, 30, 30 )

	view:insert( tc.view )
	view.cell = tc -- the table view highlights a row's 'cell'

end


--- destroy view for table row.
-- called when table view is removing a row
--
local function onUnrender( self, event )
	-- print( "Main:onUnrender" )
	local view = event.view
	local tc, img

	-- keep the cell for another row
	tc = view.cell
	display.getCurrentStage():insert( tc.view )
	tc.isVisible = false
	tinsert( cellCache, tc )

	img = tc.imageView
	assert( img )
	img:removeSelf()
	tc.imageView=nil

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


-- get our table view data

tableData = createDataArray()

-- one style for every cell: taller rows than the default style is laid
-- out for, so the two lines of text are placed and sized here

cellStyle = dUI.newTableViewCellStyle{
	inactive={
		labelY=14,
		detailY=31,
		label={ fontSize=15 },
		detail={ fontSize=11 },
	},
	active={
		labelY=14,
		detailY=31,
		label={ fontSize=15 },
		detail={ fontSize=11 },
	}
}

-- setup tableview delegate/datasource helpers

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


-- create Table View

local tV = dUI.newTableView{
	width=W,
	height=H-STATUS_BAR_H,
	delegate=delegate,
	estimatedRowHeight=ROW_HEIGHT,
	autoMask=true -- clip the rows to the table view
}
tV.x, tV.y = 0, STATUS_BAR_H

tV:reloadData()
