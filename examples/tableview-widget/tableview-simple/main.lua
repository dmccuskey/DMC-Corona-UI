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

local OFFSET = 100
local DIMS = {w=200,h=100} -- dimensions of a row item
local SHOW = 3 -- how many items to display (for masking)



--===================================================================--
--== Support Functions


-- onRender()
-- called when table view needs to display a row
--
local function onRender( event )
	-- print( 'Main:onRender' )

	local view = event.view
	local index = event.data

	local o

	o = display.newText( tostring(index), 40,30, native.systemFont, 32)
	o.anchorX, o.anchorY = 0.5, 0

	view:insert( o )
	view._o = o

end

-- onUnrender()
-- called when table view needs to destroy a row
--
local function onUnrender( event )
	-- print( 'Main:onUnrender' )

	local view = event.view
	local o

	o = view._o
	o:removeSelf()
	view._o = nil

end

-- onEvent()
-- called when table view needs to send an event to a row
--
local function onEvent( event )
	-- print( 'onEvent', event.type )
	local etype = event.type
	local tv = event.target -- our table view

	if etype == tv.ITEMS_MODIFIED then
		print( "Items Modified" )
	elseif etype == tv.TAKE_FOCUS then
		print( "Take Focus" )
	elseif etype == tv.SCROLLING then
		print( "View Scrolling", event.x, event.y, event.velocity )
	elseif etype == tv.SCROLLED then
		print( "View Scrolled", event.x, event.y, event.velocity )
	else
		print( 'onEvent', event.type )
	end

end


local function getData()
	local list = {}

	for i = 1, 50 do
		local row_template = {
			index=i,
			type='row-data'
		}

		tinsert( list, row_template )
	end

	return list
end

-- -- create rows



--===================================================================--
--== Main
--===================================================================--


local data = getData()


-- setup tableview delegate/helper

local delegate = {

	numberOfRows=function( self, section )
		-- print( "numberOfRows" )
		return #data
	end,

	onRowRender=function( self, event )
		-- print( "rowOnRender", event )
		local group = event.view
		local index = event.index
		local o, f, p  -- object, function, params

		o = display.newText( "row : "..index, 0, 0, native.systemFont, 16 )
		o.anchorX, o.anchorY = 0,0
		o.x, o.y = 0,0
		o:setFillColor( 1,1,1 )

		group:insert( o )
		group._txt = o
	end,

	onRowUnrender=function( self, event )
		-- print( "rowOnUnrender", event )
		local group = event.view
		group._txt:removeSelf( )
		group._txt=nil
	end

}


-- create Table View

local tV = dUI.newTableView{
	width=DIMS.w,
	height=DIMS.h*3,
	delegate=delegate,
	dataSource=data,
	rowHeight=30,
	estimatedRowHeight=30
}
tV.x, tV.y = OFFSET*0.5, OFFSET*0.5+50

tV:addEventListener( tV.EVENT, onEvent )

tV:reloadData()




