--====================================================================--
-- Test: TableView Widget
--====================================================================--

module(..., package.seeall)


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.1.0"



--====================================================================--
--== Imports


local dUI = require 'lib.dmc_ui'



--====================================================================--
--== Support Functions


local ROW = 40 -- row height

local widgets

local function track( w )
	widgets[ #widgets+1 ] = w
	return w
end

-- run the widget's pending commit now, instead of on the next frame
local function commit( w )
	w:__validate__()
	return w
end

-- run one frame of the widget's motion objects, 'ms' from now
-- (they move on enterFrame; a test doesn't wait for frames)
local function frame( w, ms )
	local e = { name='enterFrame', time=system.getTimer()+( ms or 0 ) }
	commit( w )
	w._axisX:enterFrame( e )
	w._axisY:enterFrame( e )
	commit( w )
end

-- a delegate for 'count' rows, which counts its calls
local function newDelegate( count )
	return {
		count=count,
		rendered=0,
		unrendered=0,
		numberOfRows=function( self, tableview, section )
			return self.count
		end,
		onRowRender=function( self, event )
			self.rendered = self.rendered + 1
		end,
		onRowUnrender=function( self, event )
			self.unrendered = self.unrendered + 1
			self.lastUnrender = event
		end,
	}
end

-- the style specs load the base styles with their test defaults
-- (anchorX 101, ...): give each table view usable values.
-- 300 x 400, rows of 40: ten rows in view
local function newTableView( count, params )
	params = params or {}
	if params.width==nil then params.width = 300 end
	if params.height==nil then params.height = 400 end
	if params.rowHeight==nil and params.estimatedRowHeight==nil then params.rowHeight = ROW end
	if params.delegate==nil then params.delegate = newDelegate( count ) end
	params.style = {
		debugOn=false, anchorX=0, anchorY=0, fillColor={ 1, 1, 1, 1 },
	}
	local w = commit( track( dUI.newTableView( params ) ) )
	frame( w )
	if count then
		w:reloadData()
		frame( w )
	end
	return w, params.delegate
end

-- the indexes of the first and last rendered rows, and how many
local function renderedRows( w )
	local cells = w._renderedTableCells
	if #cells==0 then return nil, nil, 0 end
	return cells[1]._index, cells[#cells]._index, #cells
end

-- every rendered row is where its record says, in index order
local function assertRowsInPlace( w )
	local cells = w._renderedTableCells
	for i, rec in ipairs( cells ) do
		assert_equal( rec._yMin, rec._view.y, "position of row " .. rec._index )
		assert_equal( ( rec._index-1 )*ROW, rec._yMin, "top of row " .. rec._index )
		if i > 1 then
			assert_equal( cells[i-1]._index+1, rec._index, "rows in order" )
		end
	end
end



--====================================================================--
--== Module Testing
--====================================================================--


function setup()
	widgets = {}
end

function teardown()
	for _, w in ipairs( widgets ) do
		if w.view then w:removeSelf() end
	end
	widgets = nil
end



--====================================================================--
--== Test TableView


--[[
only the rows in view, and within the render margin (100), are made
--]]
function test_rendersRowsInView()
	local w, d = newTableView( 50 )
	local first, last, count = renderedRows( w )

	assert_equal( 50*ROW, w.scrollHeight )
	assert_equal( 1, first )
	-- 400 of view and 100 of margin: rows 1-13 (13 is cut by the margin)
	assert_equal( 13, last )
	assert_equal( 13, d.rendered )
	assertRowsInPlace( w )

	w:setContentPosition{ y=-1000, time=0 }
	frame( w )
	first, last = renderedRows( w )
	-- bounds 900 to 1500
	assert_equal( 23, first )
	assert_equal( 38, last )
	assertRowsInPlace( w )
	assert_equal( 100, w.renderMargin )
end


--[[
a row which is only partly inside the render bounds is made too
(it wasn't: with a small margin a row showed once fully in view)
--]]
function test_renderMarginZero()
	local w = newTableView( 50, { renderMargin=0 } )
	w:setContentPosition{ y=-20, time=0 }
	frame( w )
	local first, last = renderedRows( w )
	assert_equal( 1, first )
	assert_equal( 11, last, "the row cut by the lower edge" )

	w:setContentPosition{ y=-100, time=0 }
	frame( w )
	first, last = renderedRows( w )
	assert_equal( 3, first )
	assert_equal( 13, last )
	assertRowsInPlace( w )
end


--[[
a table view without rows can be emptied and removed
(removeAllRows() asserted on an empty list)
--]]
function test_emptyTable()
	local w = newTableView()
	w:removeAllRows()
	w:removeSelf()
	assert_nil( w.view )

	w = newTableView( 0 )
	assert_equal( 0, select( 3, renderedRows( w ) ) )
	w:removeSelf()
	assert_nil( w.view )
end


--[[
removeAllRows() leaves nothing to scroll
--]]
function test_removeAllRows()
	local w, d = newTableView( 50 )
	w:setContentPosition{ y=-200, time=0 }
	frame( w )
	w:removeAllRows()
	frame( w )

	assert_equal( 0, w._rowLayout:count() )
	assert_equal( 0, select( 3, renderedRows( w ) ) )
	assert_equal( d.rendered, d.unrendered )
	assert_equal( 400, w.scrollHeight, "the view's height" )
	assert_equal( 0, w:getContentPosition() )

	-- and rows again
	d.count = 3
	w:reloadData()
	frame( w )
	assert_equal( 3, select( 3, renderedRows( w ) ) )
end


--[[
reloadData() with fewer rows than the position needs: the content
comes back in range and the rows are made
--]]
function test_reloadWithFewerRows()
	local w, d = newTableView( 50 )
	w:setContentPosition{ y=-1500, time=0 }
	frame( w )

	d.count = 12
	w:reloadData()
	frame( w )
	assert_equal( 400-12*ROW, w:getContentPosition() )
	local first, last = renderedRows( w )
	assert_equal( 1, first )
	assert_equal( 12, last )
	assertRowsInPlace( w )
end


--[[
insertRowAt(): in the middle, and after the last row
(a row added at the end was put on top of row 1)
--]]
function test_insertRowAt()
	local w, d = newTableView( 5 )

	d.count = 6
	w:insertRowAt( 3 )
	frame( w )
	assert_equal( 6, w._rowLayout:count() )
	assert_equal( 6, select( 3, renderedRows( w ) ) )
	assertRowsInPlace( w )

	d.count = 7
	w:insertRowAt( 7 )
	frame( w )
	assert_equal( 6*ROW, w._rowLayout:top( 7 ) )
	assert_equal( 6*ROW, w:getRowAt( 7 ).y )
	assertRowsInPlace( w )

	-- into an empty table
	local w2, d2 = newTableView( 0 )
	d2.count = 1
	w2:insertRowAt( 1 )
	assert_equal( 0, w2:getRowAt( 1 ).y )

	-- not past the end, which left a gap in the rows
	assert_error( function() w:insertRowAt( 10 ) end )
	assert_error( function() w:insertRowAt( 0 ) end )
	assert_equal( 7, w._rowLayout:count() )
end


--[[
removeRowAt(): the rows below move up, also when the row removed
is above the ones on screen (they stayed a row too low)
--]]
function test_removeRowAt()
	local w, d = newTableView( 50 )
	w:setContentPosition{ y=-1160, time=0 }
	frame( w )
	local first = renderedRows( w )
	assert_gt( 1, first )

	d.count = 49
	w:removeRowAt( 1 )
	frame( w )
	assert_equal( 49, w._rowLayout:count() )
	assert_equal( 49*ROW, w.scrollHeight )
	assertRowsInPlace( w )

	-- a rendered one
	first = renderedRows( w )
	d.count = 48
	w:removeRowAt( first+2 )
	frame( w )
	assertRowsInPlace( w )
	assert_equal( 48, w._rowLayout:count() )
end


--[[
scrollToRowAt() puts a row at the top, middle or bottom, inside the
scroll limits (row 1 in the 'middle' left the list pulled down)
--]]
function test_scrollToRowAt()
	local w = newTableView( 50 )
	local lower = 400-50*ROW

	w:scrollToRowAt( 30, { position='top' } )
	frame( w )
	assert_equal( -29*ROW, w:getContentPosition() )
	assert_not_nil( w:getRowAt( 30 ) )
	assertRowsInPlace( w )

	w:scrollToRowAt( 30, { position='bottom' } )
	frame( w )
	assert_equal( 400-30*ROW, w:getContentPosition() )

	w:scrollToRowAt( 30, { position='middle' } )
	frame( w )
	assert_equal( 200-29*ROW, w:getContentPosition() )

	w:scrollToRowAt( 1, { position='middle' } )
	frame( w )
	assert_equal( 0, w:getContentPosition() )

	w:scrollToRowAt( 50, { position='top' } )
	frame( w )
	assert_equal( lower, w:getContentPosition() )
	assert_not_nil( w:getRowAt( 50 ) )

	-- animated: there when the time is up, wherever it started
	local done = 0
	w:scrollToRowAt( 10, { position='top', time=300, onComplete=function() done = done + 1 end } )
	frame( w, 100 )
	assert_gt( lower, w:getContentPosition() )
	frame( w, 400 )
	assert_equal( -9*ROW, w:getContentPosition() )
	assert_equal( 1, done )
	assertRowsInPlace( w )

	assert_error( function() w:scrollToRowAt( 99 ) end )
end


--[[
a new width reaches the rows on screen
--]]
function test_widthChange()
	local w = newTableView( 20 )
	assert_equal( 300, w:getRowAt( 1 ).__bg.width )

	w.width = 200
	frame( w )
	local view = w:getRowAt( 1 )
	assert_equal( 200, view.__bg.width )
	assert_equal( 200, view.__hit.width )
	assertRowsInPlace( w )

	-- a taller view shows more rows
	local _, last = renderedRows( w )
	w.height = 600
	frame( w )
	local _, last2 = renderedRows( w )
	assert_equal( last+5, last2 )
end


--[[
the delegate's onRowUnrender is optional; given, it gets the row
--]]
function test_onRowUnrender()
	local w, d = newTableView( 20 )
	w:setContentPosition{ y=-400, time=0 }
	frame( w )
	assert_gt( 0, d.unrendered )
	assert_equal( w, d.lastUnrender.target )
	assert_not_nil( d.lastUnrender.row )
	assert_not_nil( d.lastUnrender.view )

	local w2 = newTableView( 20, { delegate={
		numberOfRows=function() return 20 end,
		onRowRender=function() end,
	} } )
	w2:setContentPosition{ y=-400, time=0 }
	frame( w2 )
	w2:removeSelf()
	assert_nil( w2.view )
end


--======================================================--
-- Row Heights

-- heights for a list with headers: of every five rows the first is
-- a header of 20, the third is 60 high, and the others have no height
-- of their own (so rowHeight, 40). five rows are 200 high
local function heightOf( index )
	local n = index % 5
	if n==1 then return 20 end
	if n==3 then return 60 end
	return nil
end

-- the top of a row in such a list
local function topOf( index )
	local top = 0
	for i = 1, index-1 do
		top = top + ( heightOf( i ) or ROW )
	end
	return top
end

-- a table view whose delegate gives the heights above,
-- and counts how often it is asked
local function newVariableTableView( count, params )
	params = params or {}
	local d = newDelegate( count )
	d.asked = 0
	d.heightOf = heightOf
	d.heightForRow = function( self, event )
		self.asked = self.asked + 1
		self.lastHeightEvent = event
		return self.heightOf( event.index )
	end
	params.delegate = d
	return newTableView( count, params )
end

-- every rendered row is where the delegate's heights put it, as high
-- as it should be, and they are the rows in view (with the margin)
local function assertVariableRowsInPlace( w, count, margin )
	local cells = w._renderedTableCells
	local d = w.delegate
	local y = w:getContentPosition()
	local yMin, yMax = -y-margin, -y+400+margin
	local first, last
	local top = 0
	for i = 1, count do
		local height = d.heightOf( i ) or ROW
		if top <= yMax and top+height >= yMin then
			first = first or i
			last = i
		end
		top = top + height
	end
	assert_equal( top, math.max( w.scrollHeight, 400 ), "the height of the list" )
	assert_equal( first, cells[1]._index, "the first row rendered" )
	assert_equal( last, cells[#cells]._index, "the last row rendered" )
	assert_equal( last-first+1, #cells )
	for i, rec in ipairs( cells ) do
		local index = first+i-1
		assert_equal( index, rec._index, "rows in order" )
		assert_equal( topOf( index ), rec._view.y, "top of row " .. index )
		assert_equal( d.heightOf( index ) or ROW, rec._view.__hit.height, "height of row " .. index )
	end
end


--[[
rowHeight is the height of every row; estimatedRowHeight is
its older name
--]]
function test_rowHeight()
	local w = newTableView( 10, { rowHeight=30 } )
	assert_equal( 30, w.rowHeight )
	assert_equal( 30, w.estimatedRowHeight )
	assert_equal( 400, w.scrollHeight, "300 of rows: the view's height" )
	assert_equal( 30, w:getRowAt( 2 ).y )
	assert_equal( 30, w:getRowAt( 2 ).__hit.height )

	-- a new one, by either name, from the next reloadData()
	w.estimatedRowHeight = 50
	assert_equal( 50, w.rowHeight )
	assert_equal( 30, w:getRowAt( 2 ).y )
	w:reloadData()
	frame( w )
	assert_equal( 500, w.scrollHeight )
	assert_equal( 50, w:getRowAt( 2 ).y )
	assert_error( function() w.rowHeight = 0 end )
	assert_error( function() w.rowHeight = '40' end )

	-- the older name as an option, and neither: 20
	local w2 = newTableView( 10, { estimatedRowHeight=25 } )
	assert_equal( 25, w2.rowHeight )
	local w3 = commit( track( dUI.newTableView{ width=300, height=400, delegate=newDelegate( 3 ),
		style={ debugOn=false, anchorX=0, anchorY=0, fillColor={ 1, 1, 1, 1 } } } ) )
	assert_equal( 20, w3.rowHeight )
end


--[[
rows of one height: nothing is kept for the rows out of view, however
long the list, and a row far away is found by arithmetic
--]]
function test_uniformLongList()
	local w, d = newTableView( 1000000 )
	assert_true( w._rowLayout.isUniform )
	assert_equal( 1000000*ROW, w.scrollHeight )
	assert_equal( 13, select( 3, renderedRows( w ) ) )
	local n = 0
	for _ in pairs( w._rowData ) do n = n + 1 end
	assert_equal( 13, n, "data for the rows seen only" )

	w:scrollToRowAt( 500000, { position='top' } )
	frame( w )
	assert_equal( -499999*ROW, w:getContentPosition() )
	local first, last = renderedRows( w )
	assert_equal( 499997, first )
	assert_equal( 500012, last )
	assertRowsInPlace( w )
	assert_nil( w:getRowAt( 1 ) )
	assert_not_nil( w:getRowAt( 500000 ) )

	d.count = 1000001
	w:insertRowAt( 1 )
	frame( w )
	assert_equal( 1000001*ROW, w.scrollHeight )
	assertRowsInPlace( w )
end


--[[
a row's data table is made when the row is first rendered and stays
with it: out of view and back, and to its new index when rows are
added or removed above it. reloadData() starts again
--]]
function test_rowData()
	local w, d = newTableView( 50 )
	local seen = {}
	d.onRowRender = function( self, event ) seen[ event.index ] = event.data end
	w:reloadData()
	frame( w )
	local data3, data5 = seen[3], seen[5]
	assert_table( data3 )
	assert_not_equal( data3, data5 )
	data3.name = 'three'

	-- away and back
	w:setContentPosition{ y=-1200, time=0 }
	frame( w )
	assert_nil( w:getRowAt( 3 ) )
	seen = {}
	w:setContentPosition{ y=0, time=0 }
	frame( w )
	assert_equal( data3, seen[3] )

	-- a row added above: it is row 4 now, and the new row 3 starts empty
	d.count = 51
	seen = {}
	w:insertRowAt( 2 )
	frame( w )
	assert_equal( data3, seen[4] )
	assert_equal( data5, seen[6] )
	assert_nil( seen[2].name )
	assert_not_equal( data3, seen[3] )

	-- rows removed above, and then the row itself
	d.count = 50
	seen = {}
	w:removeRowAt( 1 )
	frame( w )
	assert_equal( data3, seen[3] )
	assert_equal( data5, seen[5] )
	d.count = 49
	seen = {}
	w:removeRowAt( 3 )
	frame( w )
	assert_not_equal( data3, seen[3] )
	assert_equal( data5, seen[4] )

	-- the events for a row use the same table
	local selected
	d.didSelectRow = function( self, event ) selected = event end
	w:_dispatchSelectedRow( w._renderedTableCells[4] )
	assert_equal( data5, selected.data )
	-- also for a row out of view, picked by willSelectRow
	d.willSelectRow = function( self, event ) return 40 end
	w:_dispatchSelectedRow( w._renderedTableCells[4] )
	assert_equal( 40, selected.index )
	assert_nil( selected.view )
	assert_table( selected.data )
	local data40 = selected.data
	w:scrollToRowAt( 40 )
	frame( w )
	assert_equal( data40, w._renderedTableCells[ 40-renderedRows( w )+1 ]._user )

	seen = {}
	w:reloadData()
	frame( w )
	assert_not_equal( data40, seen[ renderedRows( w ) ] )
end


--[[
a delegate with heightForRow gives each row its own height: asked once
for every row at reloadData(), rowHeight where it returns nothing.
the rows are where the heights put them, wherever the list is
--]]
function test_variableHeights()
	local w, d = newVariableTableView( 50 )
	assert_false( w._rowLayout.isUniform )
	assert_equal( 50, d.asked )
	assert_equal( w, d.lastHeightEvent.target )
	assert_equal( w.HEIGHT_FOR_ROW, d.lastHeightEvent.type )
	assert_equal( 2000, w.scrollHeight )
	assertVariableRowsInPlace( w, 50, 100 )

	for _, y in ipairs{ -10, -95, -100, -333, -1000, -1600, 0, -1250 } do
		w:setContentPosition{ y=y, time=0 }
		frame( w )
		assertVariableRowsInPlace( w, 50, 100 )
	end
	assert_equal( 50, d.asked, "not asked again while scrolling" )

	-- without a margin, a row which the edge of the view touches is made too
	local w2 = newVariableTableView( 50, { renderMargin=0 } )
	for _, y in ipairs{ 0, -20, -60, -61, -1600 } do
		w2:setContentPosition{ y=y, time=0 }
		frame( w2 )
		assertVariableRowsInPlace( w2, 50, 0 )
	end

	-- a row by its place in the view
	w:scrollToRowAt( 13, { position='top' } )
	frame( w )
	assert_equal( -topOf( 13 ), w:getContentPosition() )
	w:scrollToRowAt( 13, { position='bottom' } )
	frame( w )
	assert_equal( 400-( topOf( 13 )+60 ), w:getContentPosition() )
	w:scrollToRowAt( 50, { position='top' } )
	frame( w )
	assert_equal( -1600, w:getContentPosition(), "as far as the list scrolls" )

	-- a height which is no height
	d.heightOf = function( index ) return 0 end
	assert_error( function() w:reloadData() end )
	d.heightOf = function( index ) return '40' end
	assert_error( function() w:reloadData() end )

	-- fewer rows than the view
	local w3 = newVariableTableView( 3 )
	assert_equal( 400, w3.scrollHeight )
	assert_equal( 3, select( 3, renderedRows( w3 ) ) )
	assert_equal( 60, w3:getRowAt( 3 ).y )
end


--[[
with heights of their own, a row which is added is asked for its
height (the one row only), and the rows below a row added or removed
move by that row's height
--]]
function test_variableInsertRemove()
	local w, d = newVariableTableView( 50 )
	-- the list as the app has it: the height of each row
	-- (false for none of its own: no holes in the list)
	local heights = {}
	for i = 1, 50 do heights[i] = heightOf( i ) or false end
	d.heightOf = function( index ) return heights[ index ] or nil end
	local function assertInPlace()
		local top = 0
		for i = 1, d.count do
			local rec = w:_getRenderedRecord( i )
			if rec then assert_equal( top, rec._view.y, "top of row " .. i ) end
			top = top + ( heights[i] or ROW )
		end
		assert_equal( top, w.scrollHeight )
		return top
	end

	d.asked = 0
	table.insert( heights, 2, 100 )
	d.count = 51
	w:insertRowAt( 2 )
	frame( w )
	assert_equal( 1, d.asked )
	assert_equal( 2, d.lastHeightEvent.index )
	assert_equal( 2100, assertInPlace() )
	assert_equal( 100, w:getRowAt( 2 ).__hit.height )
	assert_equal( 120, w:getRowAt( 3 ).y )

	-- at the end, and far below the rows in view
	table.insert( heights, 52, 70 )
	d.count = 52
	w:insertRowAt( 52 )
	frame( w )
	assert_equal( 2170, assertInPlace() )
	w:scrollToRowAt( 52, { position='bottom' } )
	frame( w )
	assert_equal( 2100, w:getRowAt( 52 ).y )
	assertInPlace()

	-- remove a row above the ones in view, and one of them
	d.asked = 0
	table.remove( heights, 2 )
	d.count = 51
	w:removeRowAt( 2 )
	frame( w )
	assert_equal( 2070, assertInPlace() )
	local first = renderedRows( w )
	table.remove( heights, first+1 )
	d.count = 50
	w:removeRowAt( first+1 )
	frame( w )
	assertInPlace()
	assert_equal( 0, d.asked, "a remove asks for nothing" )

	-- all of them, then a first row again
	w:removeAllRows()
	frame( w )
	assert_equal( 400, w.scrollHeight )
	heights = { 75 }
	d.count = 1
	w:insertRowAt( 1 )
	frame( w )
	assert_equal( 75, w:getRowAt( 1 ).__hit.height )
	assert_false( w._rowLayout.isUniform )
end


--[[
reloadRowAt() makes a row again with the height it has now:
the rows below move, and the row keeps its data
--]]
function test_reloadRowAt()
	local w, d = newVariableTableView( 50 )
	local heights = {}
	for i = 1, 50 do heights[i] = heightOf( i ) end
	d.heightOf = function( index ) return heights[ index ] end
	local data
	d.onRowRender = function( self, event )
		self.rendered = self.rendered + 1
		if event.index==2 then data = event.data end
	end
	w:reloadData()
	frame( w )
	local first = data
	first.open = true
	assert_equal( 60, w:getRowAt( 3 ).y )

	heights[2] = 140
	d.asked = 0
	data = nil
	w:reloadRowAt( 2 )
	frame( w )
	assert_equal( 1, d.asked )
	assert_equal( first, data, "made again, with its data" )
	assert_equal( 140, w:getRowAt( 2 ).__hit.height )
	assert_equal( 20, w:getRowAt( 2 ).y )
	assert_equal( 160, w:getRowAt( 3 ).y )
	assert_equal( 2100, w.scrollHeight )
	assert_equal( d.rendered-d.unrendered, select( 3, renderedRows( w ) ) )

	-- a row out of view: the list is the right height when it comes
	heights[40] = 10
	w:reloadRowAt( 40 )
	frame( w )
	assert_equal( 2070, w.scrollHeight )

	assert_error( function() w:reloadRowAt( 0 ) end )
	assert_error( function() w:reloadRowAt( 51 ) end )

	-- with one height for all it makes the row again, nothing more
	local w2, d2 = newTableView( 20 )
	local count = d2.rendered
	w2:reloadRowAt( 2 )
	frame( w2 )
	assert_lt( d2.rendered, count )
	assert_equal( 20*ROW, w2.scrollHeight )
	assertRowsInPlace( w2 )
end


--[[
the two layouts agree: rows of one height through the variable layout
are where the uniform one puts them, and each finds the same rows for
a part of the list
--]]
function test_rowLayouts()
	local RowLayout = require 'lib.dmc_ui.dmc_widget.widget_tableview.row_layout'
	local heights = {}
	for i = 1, 200 do heights[i] = 30 end
	local uniform = RowLayout.Uniform.new( 200, 30 )
	local variable = RowLayout.Variable.new( heights )

	assert_equal( 200, variable:count() )
	assert_equal( uniform:totalHeight(), variable:totalHeight() )
	assert_equal( uniform:top( 77 ), variable:top( 77 ) )
	assert_equal( uniform:height( 77 ), variable:height( 77 ) )

	local ranges = {
		{ -100, 500 }, { 0, 0 }, { 30, 30 }, { 29, 31 }, { 31, 59 }, { 5970, 6000 }, { 6000, 6100 },
		{ 5999, 9000 }, { -500, -1 }, { 6001, 7000 }, { -50, 0 }, { 100, 1234 }, { 45, 45 },
	}
	for _, r in ipairs( ranges ) do
		local name = r[1] .. ' to ' .. r[2]
		-- the rows which are in the range or touch it, one by one
		local first, last
		for i = 1, 200 do
			if ( i-1 )*30 <= r[2] and i*30 >= r[1] then
				first = first or i
				last = i
			end
		end
		local uFirst, uLast = uniform:range( r[1], r[2] )
		local vFirst, vLast = variable:range( r[1], r[2] )
		assert_equal( first, uFirst, name )
		assert_equal( last, uLast, name )
		assert_equal( first, vFirst, name )
		assert_equal( last, vLast, name )
	end

	uniform:insert( 5 )
	variable:insert( 5, 30 )
	uniform:remove( 1 )
	variable:remove( 1 )
	uniform:remove( 100 )
	variable:remove( 100 )
	assert_equal( 199, uniform:count() )
	assert_equal( 199, variable:count() )
	assert_equal( uniform:top( 150 ), variable:top( 150 ) )
	variable:setHeight( 10, 50 )
	assert_equal( uniform:top( 10 ), variable:top( 10 ) )
	assert_equal( uniform:top( 11 )+20, variable:top( 11 ) )
	assert_equal( uniform:totalHeight()+20, variable:totalHeight() )

	-- no rows
	local empty = RowLayout.Variable.new( {} )
	assert_nil( empty:range( 0, 100 ) )
	assert_equal( 0, empty:totalHeight() )
	assert_nil( RowLayout.Uniform.new( 0, 30 ):range( 0, 100 ) )
end


--[[
selecting a row asks willSelectRow, which can pick another or none
--]]
function test_selectRow()
	local w, d = newTableView( 20 )
	local calls = {}
	local answer = function( index ) return index end
	d.shouldHighlightRow=function( self, e ) calls[#calls+1]='should'..e.index return true end
	d.didHighlightRow=function( self, e ) calls[#calls+1]='hi'..e.index end
	d.didUnhighlightRow=function( self, e ) calls[#calls+1]='unhi'..e.index end
	d.willSelectRow=function( self, e ) calls[#calls+1]='will'..e.index return answer( e.index ) end
	d.didSelectRow=function( self, e ) calls[#calls+1]='did'..e.index end

	local rec = w._renderedTableCells[3]
	assert_equal( 3, rec._index )
	w:_dispatchHighlightRow( rec )
	w:_dispatchUnhighlightRow( rec )
	w:_dispatchSelectedRow( rec )
	assert_equal( 'should3,hi3,unhi3,will3,did3', table.concat( calls, ',' ) )

	calls = {}
	answer = function( index ) return 5 end
	w:_dispatchSelectedRow( rec )
	assert_equal( 'will3,did5', table.concat( calls, ',' ) )

	calls = {}
	answer = function( index ) return nil end
	w:_dispatchSelectedRow( rec )
	assert_equal( 'will3', table.concat( calls, ',' ) )

	-- a row which left the screen meanwhile
	calls = {}
	w:setContentPosition{ y=-400, time=0 }
	frame( w )
	assert_nil( rec._view )
	w:_dispatchHighlightRow( rec )
	w:_dispatchUnhighlightRow( rec )
	assert_equal( '', table.concat( calls, ',' ) )
end


--[[
the delegate's scroll methods: the rows for a position exist when
didScroll is called for it
--]]
function test_scrollDelegate()
	local w, d = newTableView( 50 )
	local calls, last, rowSeen = {}, nil, nil
	d.willBeginScrolling=function( self, e ) calls[#calls+1] = 'begin' end
	d.didScroll=function( self, e )
		calls[#calls+1] = 'scroll'
		rowSeen = e.target:getRowAt( 30 )
	end
	d.didEndScrolling=function( self, e ) calls[#calls+1] = 'end' ; last = e end

	w:scrollToRowAt( 30, { position='top' } )
	frame( w )
	assert_equal( 'begin,scroll,end', table.concat( calls, ',' ) )
	assert_not_nil( rowSeen )
	assert_equal( -29*ROW, last.y )
	assert_nil( last.verticalLimit )

	w:scrollToRowAt( 50 )
	frame( w )
	assert_equal( w.HIT_BOTTOM_LIMIT, last.verticalLimit )
	assert_nil( last.horizontalLimit )
end


--[[
TableView's own properties stay off ScrollView
(the file defined them on its parent class)
--]]
function test_propertiesOnTableViewOnly()
	local w = newTableView( 5 )
	assert_true( w.scrollEnabled )
	w.scrollEnabled = false
	assert_false( w.verticalScrollEnabled )

	local sv = track( dUI.newScrollView{ width=50, height=50,
		style={ debugOn=false, anchorX=0, anchorY=0, fillColor={ 1, 1, 1, 1 } } } )
	assert_nil( sv.scrollEnabled )
end



--====================================================================--
--== Test TableViewCell


local function newCell( params )
	local c = commit( track( dUI.newTableViewCell( params ) ) )
	return c
end


--[[
the options: size and the two texts (all four were ignored)
--]]
function test_cellOptions()
	local c = newCell{ width=300, height=44, labelText="Label", detailText="Detail" }
	assert_equal( 300, c.width )
	assert_equal( 44, c.height )
	assert_equal( "Label", c.textLabel.text )
	assert_equal( "Detail", c.textDetail.text )
	commit( c._wgtBg )
	assert_equal( 300, c._wgtBg.width )
	assert_equal( 44, c._wgtBg.height )
end


--[[
a size set later reaches the background and the accessory
--]]
function test_cellSizeChange()
	local c = newCell{ width=300, height=44 }
	c.accessory = c.CHECKMARK
	commit( c )
	c.width = 200
	c.height = 60
	commit( c )
	commit( c._wgtBg )
	assert_equal( 200, c._wgtBg.width )
	assert_equal( 60, c._wgtBg.height )
	assert_equal( 200-c.cellMargin, c._accessoryObject.x )
	assert_equal( 30, c._accessoryObject.y )
end


--[[
accessory, cellLayout, cellMargin, contentMargin can be read and set
on the cell (the setters changed nothing, the getters gave nil)
--]]
function test_cellProperties()
	local c = newCell{ width=300, height=44 }

	c.accessory = c.DISCLOSURE_INDICATOR
	commit( c )
	local first = c._accessoryObject
	assert_not_nil( first )
	assert_equal( c.DISCLOSURE_INDICATOR, c.accessory )

	c.accessory = c.NONE
	commit( c )
	assert_nil( c._accessoryObject )

	c.cellLayout = c.SUBTITLE
	commit( c )
	assert_true( c.textDetail.isVisible )
	c.cellLayout = c.DEFAULT
	commit( c )
	assert_false( c.textDetail.isVisible )
	assert_equal( c.DEFAULT, c.cellLayout )

	c.cellMargin = 20
	c.contentMargin = 4
	commit( c )
	assert_equal( 20, c.cellMargin )
	assert_equal( 24, c.textLabel.x )

	-- highlighted, the cell uses its 'active' state, with the same values
	c.highlight = true
	commit( c )
	assert_equal( 24, c.textLabel.x )
	assert_false( c.textDetail.isVisible )
end


--[[
a style written inline keeps the cell's background type
(it became Background's own default, 'rounded')
--]]
function test_cellInlineStyle()
	local plain = newCell{ width=300, height=44 }
	local c = newCell{ width=300, height=44, style={ cellMargin=12 } }
	assert_equal( plain.style.inactive.background.type, c.style.inactive.background.type )
	assert_equal( plain.style.active.background.type, c.style.active.background.type )
	assert_equal( 12, c.cellMargin )
end


--[[
a new position moves the view at once, not at the next commit
(a table view made in a timer callback was drawn for a frame
where it was before)
--]]
function test_positionSetAtOnce()
	local w = newTableView( 5 )

	w.x, w.y = 100, 200
	assert_equal( 100, w.view.x )
	assert_equal( 200, w.view.y )

	commit( w )
	assert_equal( 100, w.view.x )
	assert_equal( 200, w.view.y )
end
