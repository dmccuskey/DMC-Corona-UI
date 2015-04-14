--====================================================================--
-- TableViewCell
--
-- Shows basic use of TableViewCell with TableView, with Cell cache
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


display.setStatusBar( display.HiddenStatusBar )

math.randomseed( os.time() )

local W, H = dUI.WIDTH, dUI.HEIGHT
local H_CENTER, V_CENTER = W*0.5, H*0.5

local mrandom = math.random
local mfloor = math.floor
local tinsert = table.insert
local tremove = table.remove
local tstr = tostring

local OFFSET = 100
local DIMS = {w=200,h=30} -- dimensions of a row item
local SHOW = 10 -- how many items to display (for masking)

local tableData = nil -- later

local cellCache = {}

local images = {
	'./assets/flag/Arabia.png',
	'./assets/flag/Argentina.png',
	'./assets/flag/Australia.png',
	'./assets/flag/Brasil.png',
	'./assets/flag/Canada.png',
	'./assets/flag/Catalunya-Catalonia.png',
	'./assets/flag/Chile.png',
	'./assets/flag/Colombia.png',
	'./assets/flag/Danmark-Denmark.png',
	'./assets/flag/Deutschland-Germany.png',
	'./assets/flag/Eire-Ireland.png',
	'./assets/flag/Ellas-Greece.png',
	'./assets/flag/Espanya-Spain.png',
	'./assets/flag/Extremadura.png',
	'./assets/flag/France.png',
	'./assets/flag/Guatemala.png',
	'./assets/flag/Island.png',
	'./assets/flag/Italia.png',
	'./assets/flag/Libya.png',
	'./assets/flag/Masr-Egypt.png',
	'./assets/flag/Mexico.png',
	'./assets/flag/Nederlands-Netherlands.png',
	'./assets/flag/NewZealand.png',
	'./assets/flag/Nihon-Japan.png',
	'./assets/flag/Norge-Norway.png',
	'./assets/flag/Polska-Poland.png',
	'./assets/flag/Rossiya-Russia.png',
	'./assets/flag/Suomi-Finland.png',
	'./assets/flag/Sverige-Sweden.png',
	'./assets/flag/UK.png',
	'./assets/flag/USA.png',
	'./assets/flag/Venezuela.png',
	'./assets/flag/Zambia.png',
	'./assets/flag/Zhongguo-China.png'
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
		detail = "some detail explaination",
		type='row-data', -- this is our template type
		data=system.getTimer()
	}
end

--- create our array of data for the tableview
-- this could be from a server or local
--
local function createDataArray()
	local list = {}
	for i = 1, 50 do
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
--
local function onRender( self, event )
	-- print( "Main:onRender" )
	-- local target = event.target -- the delegate
	-- local data = event.data -- user data area
	local view = event.view
	local index = event.index
	local tc

	local rowData = tableData[ index ] -- our data source

	local w, h = view.width, view.height

	if #cellCache>0 then
		tc = tremove( cellCache, 1 )
		tc.isVisible = true
	else
		tc = dUI.newTableViewCell{ width=w, height=h }
	end

	tc.textLabel.text = rowData.title
	tc.textDetail.text = rowData.detail

	tc.imageView = display.newImageRect( rowData.image, 26, 26 )

	view:insert( tc.view )
	view.cell = tc

end


--- destroy view for table row.
-- called when table view is removing a row
--
local function onUnrender( self, event )
	-- print( "Main:onUnrender" )
	-- local target = event.target -- the delegate
	-- local data = event.data -- user data area
	-- local index = event.index
	local view = event.view
	local tc, img

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
-- called when table view needs to send an event to a row
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
			return event.index
		elseif etype == tv.SELECTED_ROW then
			print( "Selected ", event.index )
		elseif etype == tv.SCROLLED then
			print( "View Scrolled", event.x, event.y, event.velocity )
	else
		print( 'onEvent', event.type )
	end

end




--===================================================================--
--== Main
--===================================================================--


-- get our table view data

tableData = createDataArray()

-- setup tableview delegate/datasource helpers

local delegate = {
	shouldHighlightRow=onEvent,
	didHighlightRow=onEvent,
	didUnhighlightRow=onEvent,
	willSelectRow=onEvent,
	didSelectRow=onEvent,
}

local dataSource = {
	numberOfRows=getRows,
	onRowRender=onRender,
	onRowUnrender=onUnrender,
}


-- create Table View

local tV = dUI.newTableView{
	width=DIMS.w,
	height=DIMS.h*SHOW,
	delegate=delegate,
	dataSource=dataSource,
	estimatedRowHeight=DIMS.h,
	autoMask=true
}
tV.x, tV.y = OFFSET*0.5, OFFSET*0.5+50

tV:addEventListener( tV.EVENT, onEvent )

tV:reloadData()

