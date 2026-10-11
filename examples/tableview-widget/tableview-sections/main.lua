--====================================================================--
-- TableView Sections
--
-- A table view whose rows have different heights: a list of names with
-- a short grey header before each letter, and rows which open. The
-- delegate's heightForRow says how high a row is (a header 24, an open
-- row 84; it returns nothing for the others, which are as high as the
-- table view's rowHeight, 44). A header is a row like any other: the
-- delegate draws it differently, and keeps it from being highlighted.
-- Tap a name and its row opens to show a second line, tap it again and
-- it closes: the app changes its list, then calls reloadRowAt(), and the
-- rows below move. The app opens the second name by itself after a
-- second. The table view fills the screen below the status bar.
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
local ROW_HEIGHT = 44
local HEADER_HEIGHT = 24
local OPEN_HEIGHT = 84

local NAMES = {
	"Ada", "Alan", "Anita", "Barbara", "Bjarne", "Brian", "Claude", "Dennis",
	"Donald", "Edsger", "Frances", "Grace", "Guido", "Hedy", "John", "Katherine",
	"Ken", "Linus", "Margaret", "Niklaus", "Radia", "Roberto", "Tim", "Yukihiro",
}

local tableData = nil -- later



--===================================================================--
--== Support Functions


--- create our array of data for the tableview: an entry for each row,
-- a header before the first name of each letter.
-- the content of an entry is not important to the TableView
--
local function createDataArray()
	local list = {}
	local letter = nil
	for i, name in ipairs( NAMES ) do
		local first = name:sub( 1, 1 )
		if first~=letter then
			letter = first
			tinsert( list, { isHeader=true, title=letter } )
		end
		tinsert( list, { name=name, note="name "..i.." of "..#NAMES, isOpen=false } )
	end
	return list
end


--======================================================--
-- Delegate Functions

--- return number of data rows.
-- called by table view when figuring data
--
local function getRows( self, tableview, section )
	return #tableData
end


--- return the height of a row.
-- called once for every row at reloadData(), and for the one row
-- at insertRowAt() and reloadRowAt(). nothing: the table view's rowHeight
--
local function getHeight( self, event )
	local item = tableData[ event.index ]
	if item.isHeader then
		return HEADER_HEIGHT
	elseif item.isOpen then
		return OPEN_HEIGHT
	end
end


--- create view for table row.
-- called when table view needs to display a row
--
local function onRender( self, event )
	local row = event.row
	local view = event.view
	local item = tableData[ event.index ]
	local o

	if item.isHeader then
		row:setBackgroundColor( 0.9, 0.9, 0.92 )

		o = display.newText( item.title, 0, 0, native.systemFontBold, 14 )
		o.anchorX, o.anchorY = 0, 0.5
		o.x, o.y = 15, HEADER_HEIGHT/2
		o:setFillColor( 0.35, 0.35, 0.4 )
		view:insert( o )

	else
		row:setLineColor( 0.8, 0.8, 0.8 )

		o = display.newText( item.name, 0, 0, native.systemFont, 18 )
		o.anchorX, o.anchorY = 0, 0.5
		o.x, o.y = 15, ROW_HEIGHT/2
		o:setFillColor( 0, 0, 0 )
		view:insert( o )

		if item.isOpen then
			o = display.newText( item.note .. ". Tap to close.", 0, 0, native.systemFont, 14 )
			o.anchorX, o.anchorY = 0, 0.5
			o.x, o.y = 15, ROW_HEIGHT + ( OPEN_HEIGHT-ROW_HEIGHT )/2 - 4
			o:setFillColor( 0.4, 0.4, 0.4 )
			view:insert( o )
		end
	end
	-- no onRowUnrender: a row's view is removed with everything in it
end


--- a header takes no touch.
--
local function shouldHighlight( self, event )
	return not tableData[ event.index ].isHeader
end


--- a row was tapped: open or close it.
-- change the list, then tell the table view which row to make again
--
local function onSelect( self, event )
	local item = tableData[ event.index ]
	if item.isHeader then return end
	item.isOpen = not item.isOpen
	event.target:reloadRowAt( event.index )
	print( item.name, item.isOpen and "opened" or "closed" )
end



--===================================================================--
--== Main
--===================================================================--


-- get our table view data

tableData = createDataArray()

-- setup tableview delegate/helper

local delegate = {
	numberOfRows=getRows,
	heightForRow=getHeight,
	onRowRender=onRender,
	shouldHighlightRow=shouldHighlight,
	didSelectRow=onSelect,
}

-- create Table View

local tV = dUI.newTableView{
	width=SCREEN_W,
	height=SCREEN_H-STATUS_BAR_H,
	delegate=delegate,
	rowHeight=ROW_HEIGHT,
	autoMask=true -- clip the rows to the table view
}
tV.x, tV.y = SCREEN_X, SCREEN_Y+STATUS_BAR_H

tV:reloadData()

-- open the second name, to show a row of another height
timer.performWithDelay( 1000, function()
	tableData[3].isOpen = true
	tV:reloadRowAt( 3 )
end )
