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
	if params.estimatedRowHeight==nil then params.estimatedRowHeight = ROW end
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

	assert_equal( 0, #w._rowItemRecords )
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
	assert_equal( 6, #w._rowItemRecords )
	assert_equal( 6, select( 3, renderedRows( w ) ) )
	assertRowsInPlace( w )

	d.count = 7
	w:insertRowAt( 7 )
	frame( w )
	assert_equal( 6*ROW, w._rowItemRecords[7]._yMin )
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
	assert_equal( 7, #w._rowItemRecords )
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
	assert_equal( 49, #w._rowItemRecords )
	assert_equal( 49*ROW, w.scrollHeight )
	assertRowsInPlace( w )

	-- a rendered one
	first = renderedRows( w )
	d.count = 48
	w:removeRowAt( first+2 )
	frame( w )
	assertRowsInPlace( w )
	assert_equal( 48, #w._rowItemRecords )
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

	local rec = w._rowItemRecords[3]
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
