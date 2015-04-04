--====================================================================--
-- dmc_ui/dmc_widget/widget_tableview.lua
--
-- Documentation: http://docs.davidmccuskey.com/
--====================================================================--

--[[

The MIT License (MIT)

Copyright (c) 2013-2015 David McCuskey

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

--]]



--====================================================================--
--== DMC Corona UI : ScrollView Widget
--====================================================================--


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "2.0.0"



--====================================================================--
--== DMC UI Setup
--====================================================================--


local dmc_ui_data = _G.__dmc_ui
local dmc_ui_func = dmc_ui_data.func
local ui_find = dmc_ui_func.find



--====================================================================--
--== DMC UI : newTableView
--====================================================================--


--- rowItemRecord
-- @field data reference to data given by insert
-- @table rowItemRecord

--====================================================================--
--== Imports


local Objects = require 'dmc_objects'
local TouchMgr = require 'dmc_touchmanager'
local Utils = require 'dmc_utils'

local uiConst = require( ui_find( 'ui_constants' ) )

local ScrollView = require( ui_find( 'dmc_widget.widget_scrollview' ) )



--====================================================================--
--== Setup, Constants


local newClass = Objects.newClass

local mabs = math.abs
local mfloor = math.floor
local tinsert = table.insert
local tremove = table.remove
local tcancel = timer.cancel
local tdelay = timer.performWithDelay

--== To be set in initialize()
local dUI = nil



--====================================================================--
--== Support Function


-- create records
-- tail-call
--
local function createRecords( list, idx, count, tinsert )
	-- print( "createRecords" )
	if idx<=count then
		local rec = {
			yMin=0,
			yMax=0,
			height=0,
			index=0,
			view=nil,
			user={}
		}
		tinsert( list, idx, rec )
		return createRecords( list, idx+1, count, tinsert )
	end
end

local function removeRecords( list, idx, count, tremove )
	-- print( "removeRecords", idx, count )
	if idx<=count then
		tremove( list, idx )
		return removeRecords( list, idx+1, count, tremove )
	end
end



local function indexItems( list, idx, yMin, height )
	-- print( "indexItems" )
	local yMax = yMin+height
	if idx<=#list then
		local rec = list[idx]
		rec.yMin=yMin
		rec.yMax=yMax
		rec.height=height
		rec.index=idx
		return indexItems( list, idx+1, yMax, height )
	end
end




--====================================================================--
--== TableView Widget Class
--====================================================================--


local TableView = newClass( ScrollView, {name="TableView"} )

--== Class Constants

TableView._BOUND_CUT = 'cut'
TableView._BOUND_FULL = 'full'
TableView._BOUND_EXTEND = 'extend'

-- pixel amount to edges in which rows are de-/rendered
TableView._DEFAULT_RENDER_MARGIN = 100

--== Style/Theme Constants

TableView.STYLE_CLASS = nil -- added later
TableView.STYLE_TYPE = uiConst.TABLEVIEW

-- TODO: hook up later
-- ScrollView.DEFAULT = 'default'

-- ScrollView.THEME_STATES = {
-- 	ScrollView.DEFAULT,
-- }

--== Event Constants

TableView.EVENT = 'tableview-event'

TableView.RENDER_ROW = 'row-render-event'
TableView.UNRENDER_ROW = 'row-unrender-event'
TableView.SHOULD_HIGHLIGHT_ROW = 'row-should-highlight-event'
TableView.HIGHLIGHT_ROW = 'row-highlight-event'
TableView.UNHIGHLIGHT_ROW = 'row-unhighlight-event'
TableView.WILL_SELECT_ROW = 'row-will-select-event'
TableView.SELECTED_ROW = 'row-selected-event'


--======================================================--
-- Start: Setup DMC Objects

function TableView:__init__( params )
	-- print( "TableView:__init__" )
	params = params or {}
	-- params.dataSource=params.dataSource
	-- params.delegate=params.delegate
	if params.estimatedRowHeight==nil then params.estimatedRowHeight=20 end
	if params.renderMargin==nil then params.renderMargin=TableView._DEFAULT_RENDER_MARGIN end

	self:superCall( '__init__', params )
	--==--

	--== Create Properties ==--

	self._estimatedRowHeight = params.estimatedRowHeight

	self._upperHorizontalOffset = 0
	self._lowerHorizontalOffset = 0
	self._upperVerticalOffset = 50
	self._lowerVerticalOffset = 50

	self._renderMargin = params.renderMargin

	--[[
	array of data records for each row
	this is all of the items which have been added to scroller
	data is plain Lua object, added from onRender() (item_info rec)
	--]]
	self._rowItemRecords = {}

	--[[
	array of rendered items
	this is list of item which have been rendered
	data is plain Lua object
	--]]
	self._renderedTableCells = nil

	-- saved Touch Event, usually 'began'
	-- to enable motion "from beginning"
	self._tmpTouchEvt = nil

	--== Display Groups ==--

	--== Object References ==--


	self._tableCellHighlight_timer = nil
	self._tableCellTouch_f = nil

	self._delegate = params.delegate
	self._dataSource = params.dataSource

end

-- function TableView:_undoInit()
-- 	-- print( "TableView:_undoInit" )
-- 	--==--
-- 	self:superCall( "_undoInit" )
-- end


--== initComplete

function TableView:__initComplete__()
	-- print( "TableView:__initComplete__" )
	self:superCall( '__initComplete__' )
	--==--
	local o, f

	self._is_rendered = false

	self._rowItemRecords = {}
	self._renderedTableCells = {}

	self._tableCellTouch_f = self:createCallback( TableView._tableCellTouch_handler )

	--== Use Setters
	self.dataSource = self._dataSource
	self.delegate = self._delegate
	self.renderMargin = self._renderMargin
	self.scrollWidth = self._width

end

--== initComplete

function TableView:__undoInitComplete__()
	-- print( "TableView:__undoInitComplete__" )
	local o, f

	self:deleteAllItems()

	self._rowItemRecords = nil
	self._renderedTableCells = nil

	self._is_rendered = false

	--==--
	self:superCall( '__undoInitComplete__' )
end

-- END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Static Methods


function TableView.initialize( manager, params )
	-- print( "TableView.initialize" )
	dUI = manager

	local Style = dUI.Style
	TableView.STYLE_CLASS = Style.TableView

	Style.registerWidget( TableView )
end



--====================================================================--
--== Public Methods


-- block horizontal motion
--
function TableView.__setters:horizontalScrollEnabled( value )
	-- print( "TableView.__setters:horizontalScrollEnabled", value )
	assert( type(value)=='boolean' )
	--==--
	self._canScrollH = false
end

-- block width
--
function TableView.__setters:scrollWidth( value )
	-- print( "TableView.__setters:scrollWidth", value )
	if self._scrollWidth==self._width then return end
	self._scrollWidth = self._width
	self._scrollWidth_dirty=true
end


--== .contentPosition

function TableView.__getters:contentPosition()
	-- print( "TableView.__getters:contentPosition" )
	return self._scroller.y
end

--== .delegate

function TableView.__getters:delegate()
	-- print( "TableView.__getters:delegate" )
	return self._delegate
end
function TableView.__setters:delegate( value )
	-- print( "TableView.__setters:delegate", value )
	self._delegate = value
end


--== .dataSource

function TableView.__getters:dataSource()
	-- print( "TableView.__getters:dataSource" )
	return self._dataSource
end
function TableView.__setters:dataSource( value )
	-- print( "TableView.__setters:dataSource", value )
	self._dataSource = value
end


--== .estimatedRowHeight

function TableView.__getters:estimatedRowHeight()
	-- print( "TableView.__getters:estimatedRowHeight" )
	return self._estimatedRowHeight
end
function TableView.__setters:estimatedRowHeight( value )
	-- print( "TableView.__setters:estimatedRowHeight", value )
	assert( type(value)=='number' and value > 0 )
	self._estimatedRowHeight = value
end


--== .renderMargin

function TableView.__setters:renderMargin( value )
	-- print( "TableView.__setters:renderMargin", value )
	-- TODO, use setters
	self._renderMargin = value
	-- self._upperHorizontalOffset = value
	-- self._lowerHorizontalOffset = value
	-- self._upperVerticalOffset = value
	-- self._lowerVerticalOffset = value
end


--- returns the row view reference.
-- the row view or nil if not visible
--
-- @returns row view or nil if the row is not visible
--
function TableView:getRowAt( idx )
	-- print( "TableView:getRowAt", pos )
	local records = self._rowItemRecords
	local rec = records[idx]
	return rec and rec.view
end


function TableView:insertRowAt( idx )
	-- print( "TableView:insertRowAt", idx )
	assert( type(idx)=='number', "TableView:insertRowAt arg must be a number" )
	--==--
	local records = self._rowItemRecords
	local rec = records[idx]
	local yMin = rec and rec.yMin or 0
	local eRH = self._estimatedRowHeight

	self.scrollHeight = self.scrollHeight + eRH
	createRecords( records, idx, idx, tinsert )
	indexItems( records, idx, yMin, eRH )
	self:_renderDisplay{ clearAll=true }
end

function TableView:removeRowAt( idx )
	-- print( "TableView:removeRowAt", idx )
	assert( type(idx)=='number', "TableView:removeRowAt arg must be a number" )
	--==--
	local records = self._rowItemRecords
	local rec = records[idx]
	local yMin = rec and rec.yMin or 0
	local eRH = self._estimatedRowHeight

	self.scrollHeight = self.scrollHeight - eRH
	local removed = self:_unrenderTableCell( rec )
	removeRecords( records, idx, idx, tremove )
	indexItems( records, idx, yMin, eRH )
	if removed then
		self:_renderDisplay{ clearAll=true }
	end
end


function TableView:reloadData()
	-- print( "TableView:reloadData" )
	assert( self._dataSource and self._delegate, "TableView:reloadData missing data source or delegate" )
	--==--
	local eRH = self._estimatedRowHeight
	local num = self._delegate:numberOfRows()
	local records = {}
	local yMin = 0

	self.scrollHeight = num*eRH
	createRecords( records, 1, num, tinsert )
	indexItems( records, 1, yMin, eRH )
	self._rowItemRecords = records

	self:_renderDisplay{ clearAll=true }
end



function TableView:scrollToRowAt( idx, params )
	-- print( "TableView:scrollToRowAt" )
	assert( type(idx)=='number' )
	params = params or {}
	if params.time==nil then params.time=0 end
	if params.position==nil then params.position='none' end
	if params.limitIsActive==nil then params.limitIsActive=false end
	--==--
	local record = self._rowItemRecords[ idx ]
	assert( record )

	local pos = self:_calculateScrollPosition( record, params.position )

	if params.time then
		-- set scroll in motion
		self._axis_y:scrollToPosition( pos, params )
	else
		self:_unrenderAllTableCells()
		self._axis_y:scrollToPosition( pos, params )
		self:_renderDisplay{ clearAll=false }
	end

end



--====================================================================--
--== Private Methods


-- _viewportBounds()
-- calculates "viewport" bounding box on entire scroll list
-- based on scroll position and RENDER_MARGIN
-- used to determine if a item should be rendered
--  (xMin, xMax, yMin, yMax)
--
function TableView:_viewportBounds()
	-- print( "TableView:_viewportBounds" )
	local bounds =  {
		yMin = nil,
		yMax = nil,
	}
	local o = self._axis_y
	local rM = self._renderMargin
	if o then
		bounds.yMin = 0 - o.value - rM
		bounds.yMax = 0 + o.length - o.value + rM
	end
	-- print( bounds.yMin, bounds.yMax )
	return bounds
end


-- determine if record is inside of Table View bounds
--
function TableView:_isWithinBounds( bounds, item )
	-- print( "TableView:_isWithinBounds", bounds, item.index )

	local result = false
	local bType = 'none'

	if item.yMin < bounds.yMin and bounds.yMin <= item.yMax then
		-- item cut on top
		bType = 'cut'
		result = true
	elseif item.yMin <= bounds.yMax and bounds.yMax < item.yMax then
		-- item cut on bottom
		bType = 'cut'
		result = true
	elseif item.yMin >= bounds.yMin and item.yMax <= bounds.yMax  then
		-- item fully in view
		bType = 'full'
		result = true
	elseif item.yMin < bounds.yMin and bounds.yMax < item.yMax then
		-- item extends over view
		bType = 'extend'
		result = true
	end

	return result, bType
end


-- search for an item which should be visible.
-- usually used when there are no visible table cells
-- uses binary search
-- @table records array of data items
--
function TableView:_findVisibleItem( records, min, max )
	-- print( "TableView:_findVisibleItem", min, max  )

	if #records == 0 then return end
	local _mfloor = mfloor
	local low, high = 1, #records
	local mid

	while( low <= high ) do
		mid = _mfloor( low + ( (high-low)*0.5 ) )
		if records[mid].yMin > max then
			high = mid - 1
		elseif records[mid].yMin < min then
			low = mid + 1
		else
			return mid  -- found
		end
	end

	return nil
end


-- renders table cells.
-- adds cells starting at Top, moving Up
--
function TableView:_renderUp( records, index, bounds )
	-- print( "TableView:_renderUp", index, bounds )

	if index < 1 or index > #records then return end

	local isBounded_f = self._isWithinBounds
	local renderCell_f = self._renderTableCell
	local cut = TableView._BOUND_CUT
	local record, isBounded, bType

	repeat
		record = records[ index ]
		if not record then break end
		isBounded, bType = isBounded_f( self, bounds, record )
		-- print( "rU", index, bType, record, record.yMin, isBounded )
		if not isBounded or bType==cut then
			break
		else
			renderCell_f( self, record, { putAtHead=true } )
			index = index - 1
		end
	until false

end

-- renders table cells.
-- adds cells starting at Bottom, moving Down
--
function TableView:_renderDown( records, index, bounds )
	-- print( "TableView:_renderDown", index, bounds )

	if index < 1 or index > #records then return end

	local isBounded_f = self._isWithinBounds
	local renderCell_f = self._renderTableCell
	local cut = TableView._BOUND_CUT
	local record, isBounded, bType

	repeat
		record = records[ index ]
		if not record then break end
		isBounded, bType = isBounded_f( self, bounds, record )
		-- print( "rD", index, bType, record, record.yMax, isBounded )
		if not isBounded or bType==cut then
			break
		else
			renderCell_f( self, record, { putAtHead=false } )
			index = index + 1
		end
	until false

end


-- removes rendered table cells
-- starts check from Bottom and moves Up
--
function TableView:_unrenderUpFromBottom( bounds )
	-- print( "TableView:_unrenderUpFromBottom"  )

	local isBounded_f = self._isWithinBounds
	local unrenderCell_f = self._unrenderTableCell
	local renderedCells = self._renderedTableCells
	local index, record, isBounded, bType

	index = #renderedCells
	record = renderedCells[ index ]
	while record do
		isBounded, bType = isBounded_f( self, bounds, record )
		if isBounded then
			break
		else
			unrenderCell_f( self, record, { index=index } )
			index = #renderedCells
			record = renderedCells[ index ]
		end
	end

end

-- removes rendered table cells
-- starts check from Top and moves Down
--
function TableView:_unrenderDownFromTop( bounds )
	-- print( "TableView:_unrenderDownFromTop"  )

	local isBounded_f = self._isWithinBounds
	local unrenderCell_f = self._unrenderTableCell
	local renderedCells = self._renderedTableCells
	local record, isBounded, bType

	-- the index never changes
	record = renderedCells[ 1 ]
	while record do
		isBounded, bType = isBounded_f( self, bounds, record )
		if isBounded then
			break
		else
			unrenderCell_f( self, record, { index=1 } )
			record = renderedCells[ 1 ]
		end
	end

end


function TableView:_renderDisplay( params )
	-- print( "TableView:_renderDisplay" )
	params = params or {}
	if params.clearAll==nil then params.clearAll=false end
	--==--

	local records = self._rowItemRecords
	if #records == 0 then return end

	if params.clearAll then
		self:_unrenderAllTableCells( self._renderedTableCells )
	end

	local isBounded_f = self._isWithinBounds
	local full = TableView._BOUND_FULL
	local renderedCells = self._renderedTableCells

	local bounds = self:_viewportBounds()
	local record, isBounded, bType

	local function renderAllCells( recs, bnds )
		local idx = self:_findVisibleItem( recs, bnds.yMin, bnds.yMax )
		if idx then
			local rec = recs[ idx ]
			self:_renderTableCell( rec )
			self:_renderUp( recs, rec.index-1, bnds )
			self:_renderDown( recs, rec.index+1, bnds )
		end
	end

	--== Check top of rendered list ==--

	if #renderedCells==0 then
		renderAllCells( records, bounds )
	else
		record = renderedCells[ 1 ]
		isBounded, bType = isBounded_f( self, bounds, record )
		if not isBounded then
			-- this item scrolled off screen so check others below
			self:_unrenderDownFromTop( bounds )
		elseif bType==full then
			self:_renderUp( records, record.index-1, bounds )
		end
	end

	--== Check bottom of rendered list ==--

	if #renderedCells==0 then
		renderAllCells( records, bounds )
	else
		record = renderedCells[ #renderedCells ]
		isBounded, bType = isBounded_f( self, bounds, record )
		if not isBounded then
			-- this item scrolled off screen so check others above
			self:_unrenderUpFromBottom( bounds )
		elseif bType==full then
			self:_renderDown( records, record.index+1, bounds )
		end
	end

	--== Final Check ==--

	if #renderedCells==0 then
		renderAllCells( records, bounds )
	end

end




function TableView:_startHighlightTimer( record )
	-- print( "TableView:_startHighlightTimer", record )
	local f = function(e)
		self:_dispatchHighlightRow( record )
		self._tableCellHighlight_timer=nil
	end
	self._tableCellHighlight_timer = tdelay( 10, f )

end
function TableView:_stopHighlightTimer()
	-- print( "TableView:_startHighlightTimer" )
	local t = self._tableCellHighlight_timer
	if not t then return end
	tcancel( t )
	self._tableCellHighlight_timer = nil
end


--- create callback function for returnFocus
-- this is how ScrollView will communicate
--
function TableView:_getReturnFocusCallback( method )
	-- print( "TableView:_getReturnFocusCallback" )
	return function( event )
		event.focusBack = true
		method( self, event )
	end
end

function TableView:_tableCellTouch_handler( event )
	-- print( "TableView:_tableCellTouch_handler", event.phase )
	local phase = event.phase
	local target = event.target -- hit area
	local record = target.__rec

	if event.phase == 'began' and not event.focusBack then
		-- this is initial pass through Touch Handler
		-- give Touch Event to ScrollView right away (takeFocus)
		--
		event.returnFocus = self:_getReturnFocusCallback( self._tableCellTouch_handler )
		event.returnTarget = target
		self:takeFocus( event )

	elseif event.phase == 'began' then
		-- this is second pass through Touch Handler
		-- being here means ScrollView didn't use
		-- Touch Event, so gave it back (returnFocus)
		--
		TouchMgr.setFocus( target, event.id )
		self:_startHighlightTimer( record )
		-- save initial 'began' Event in case we need to
		-- give back again. this enables better looking motion
		self._tmpTouchEvt = event

	elseif phase == 'moved' then
		local threshold = uiConst.TABLEVIEW_TOUCH_THRESHOLD
		local hasScrolled = (mabs( event.yStart - event.y ) > threshold)
		if hasScrolled then
			-- movement has surpassed threshold
			-- give Touch Event back to ScrollView
			self:_stopHighlightTimer( record )
			self:_dispatchUnhighlightRow( record )
			self:takeFocus( self._tmpTouchEvt )
			self._tmpTouchEvt = nil
		end

	elseif phase == 'ended' then
		TouchMgr.unsetFocus( target, event.id )
		self:_stopHighlightTimer( record )
		self:_dispatchUnhighlightRow( record )
		self:_dispatchSelectedRow( record )
		self._tmpTouchEvt = nil
	end

	return true
end



-- setup creation of new Table Cell
-- creates visual holder for User's TableCell
--
-- @param record an record for a row item
--
function TableView:_renderTableCell( record, options )
	-- print( "TableView:_renderTableCell", record, record.index )
	options = options or {}
	if options.putAtHead==nil then options.putAtHead=true end
	--==--

	if record.view then --[[ print("already rendered") ; --]] return end

	local width = self._width
	local delegate = self._delegate
	local renderedCells = self._renderedTableCells
	local scr = self._scroller
	local view, hit

	--== Create View Items

	-- create view for this item
	view = display.newGroup()
	record.view = view

	-- create hit background
	hit = display.newRect( 0, 0, width, record.height )
	hit.anchorX, hit.anchorY = 0,0
	hit.isVisible = true
	hit:setFillColor( 0,0,1,0.3 )
	hit.isHitTestable = true

	TouchMgr.register( hit, self._tableCellTouch_f )

	view:insert( hit )
	view.__hit = hit
	hit.__rec = record

	--== Render View

	local e = {
		name=TableView.EVENT,
		type=TableView.RENDER_ROW,

		target=self,
		view=view,
		index=record.index,
		data=record.user,
	}
	delegate:onRowRender( e )

	scr:insertItem( view )
	view.x, view.y = 0, record.yMin

	-- save rendered record
	local idx = #renderedCells+1
	if options.putAtHead==true then idx=1 end
	tinsert( renderedCells, idx, record )

end


-- setup deleation of existing Table Cell
-- deletes visual holder for User's TableCell
--
-- @param record an record for a row item
--
function TableView:_unrenderTableCell( record, options )
	-- print( "TableView:_unrenderTableCell", record, record.index )
	options = options or {}
	options.index=options.index
	--==--
	if not record.view then return false end

	local delegate = self._delegate
	local renderedCells = self._renderedTableCells
	local scr = self._scroller
	local index = options.index
	local view, hit

	if index==nil then
		-- find the index
		for i=1,#renderedCells do
			if record==renderedCells[i] then index=i ; break end
		end
	end

	--== Remove Rendered Item

	view = record.view

	tremove( renderedCells, index )

	scr:removeItem( view )

	local e ={
		name = TableView.EVENT,
		type = TableView.UNRENDER_ROW,

		target=self,
		view=view,
		data=record.user,
		index=record.index,
	}
	delegate:onRowUnrender( e )

	hit = view.__hit
	TouchMgr.unregister( hit, self._tableCellTouch_f )
	hit:removeSelf()
	view.__hit=nil

	view:removeSelf()
	record.view = nil

	return true
end

function TableView:_unrenderAllTableCells( rendered )
	-- print( "TableView:_unrenderAllTableCells", #rendered )
	local unrenderCell_f = TableView._unrenderTableCell
	for i=#rendered, 1, -1 do
		local record = tremove( rendered, i )
		unrenderCell_f( self, record, {index=i} )
	end
end



function TableView:_updateBackground()
	-- print( "TableView:_updateBackground" )

	local items = self._item_data_recs
	local o = self._bg

	local total_dim, item
	local x, y

	-- set our total item dimension

	if #items == 0 then
		total_dim = 0
	else
		item = items[ #items ]
		total_dim = item.yMax
	end

	self._total_item_dimension = total_dim


	-- set background height, make at least height of window

	if total_dim < self._height then
		total_dim = self._height
	end

	x, y = o.x, o.y
	o.height = total_dim
	o.anchorX, o.anchorY = 0,0
	o.x, o.y = x, y

end


-- calculate vertical direction
--
function TableView:_updateDimensions( item_info, item_data )
	-- print( "TableView:_updateDimensions", item_info )

	local total_dim = self._total_item_dimension

	local o
	local x, y


	-- configure item data of new item element

	item_data.height = item_info.height
	item_data.yMin = self._total_item_dimension
	item_data.yMax = item_data.yMin + item_data.height

	table.insert( self._item_data_recs, item_data )
	item_data.index = #self._item_data_recs

	-- print( 'item insert', item_data.yMin, item_data.yMax )

	total_dim = total_dim + item_data.height

	self._total_item_dimension = total_dim


	-- adjust background height

	if total_dim < self._height then
		total_dim = self._height
	end

	o = self._bg
	x, y = o.x, o.y -- temp
	o.height = total_dim
	o.anchorX, o.anchorY = 0,0
	o.x, o.y = x, y

end



function TableView:_calculateScrollPosition( record, position )
	-- print( "TableView:_calculateScrollPosition", record, position )
	local value = 0
	local offset = 0

	if position=='top' then
		offset = 0+self._upperVerticalOffset
		value = offset-record.yMin
	elseif position=='middle' then
		offset = self._height/2
		value = offset-record.yMin
	elseif position=='bottom' then
		offset = self._height-self._lowerVerticalOffset
		value = offset-(record.yMin+record.height)
	else
		offset = self._height/2
		value = offset-record.yMin
	end

	return value
end


--======================================================--
-- Event Dispatch

function TableView:_dispatchHighlightRow( record )
	-- print( "TableView:_dispatchHighlightRow" )
	local delegate = self._delegate
	local cell = record.view.cell
	local f, evt

	evt = {
		name=TableView.EVENT,
		type=TableView.SHOULD_HIGHLIGHT_ROW,

		target=self,
		index=record.index,
		view=record.view,
		data=record.user
	}

	f = delegate and delegate.shouldHighlightRow
	if f then
		if not f( delegate, evt ) then return end
	end

	if cell then
		cell.highlight=true
	end

	f = delegate and delegate.didHighlightRow
	evt.type = TableView.HIGHLIGHT_ROW
	if f then f( delegate, evt ) end

end

function TableView:_dispatchUnhighlightRow( record )
	-- print( "TableView:_dispatchUnhighlightRow" )
	-- if highlight then tell
	local delegate = self._delegate
	local cell = record.view.cell
	local f, evt

	if cell then
		cell.highlight=false
	end

	evt = {
		name=TableView.EVENT,
		type=TableView.UNHIGHLIGHT_ROW,

		target=self,
		index=record.index,
		view=record.view,
		data=record.user
	}
	f = delegate and delegate.didUnhighlightRow
	if f then f( delegate, evt ) end

end


function TableView:_dispatchSelectedRow( record )
	-- print( "TableView:_dispatchSelectedRow" )
	-- if highlight then tell
	local delegate = self._delegate
	local f, evt
	local rowIdx = record.index

	evt = {
		name=TableView.EVENT,
		type=TableView.WILL_SELECT_ROW,

		target=self,
		index=record.index,
		view=record.view,
		data=record.user
	}

	f = delegate and delegate.willSelectRow
	if f then
		rowIdx = f( delegate, evt )
		if rowIdx==nil then return end
	end
	if rowIdx~=record.index then
		-- get alternate record
		record = self._rowItemRecords[ rowIdx ]
		if not record then return end
		evt.index=record.index
		evt.view=record.view
		evt.data=record.user
	end

	evt.type=TableView.SELECTED_ROW
	f = delegate and delegate.didSelectRow
	if f then f( delegate, evt ) end

end



--====================================================================--
--== Event Handlers


function TableView:_axisEvent_handler( event )
	-- print( "TableView:_axisEvent_handler" )
	if event.id=='y' then
		self._scroller.y = event.value
	end
	self:_renderDisplay()
end






return TableView
