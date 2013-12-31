--====================================================================--
-- widget_tableview.lua
--
--
-- by David McCuskey
-- Documentation: http://docs.davidmccuskey.com/display/docs/newTableView.lua
--====================================================================--

--[[

Copyright (C) 2013-2014 David McCuskey. All Rights Reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in the
Software without restriction, including without limitation the rights to use, copy,
modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
and to permit persons to whom the Software is furnished to do so, subject to the
following conditions:

The above copyright notice and this permission notice shall be included in all copies
or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.

--]]


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "1.0.0"



--====================================================================--
-- DMC Library Setup
--====================================================================--

local dmc_lib_data, dmc_lib_func
dmc_lib_data = _G.__dmc_library
dmc_lib_func = dmc_lib_data.func



--====================================================================--
-- DMC Widgets : newTableView
--====================================================================--



--====================================================================--
-- Imports
--====================================================================--

local Utils = require( dmc_lib_func.find('dmc_utils') )
local Objects = require( dmc_lib_func.find('dmc_objects') )



--====================================================================--
-- Setup, Constants
--====================================================================--

-- setup some aliases to make code cleaner
local inheritsFrom = Objects.inheritsFrom
local CoronaBase = Objects.CoronaBase



--====================================================================--
-- Table View Widget Class
--====================================================================--

local TableView = inheritsFrom( CoronaBase )
TableView.NAME = "View Pager Widget Class"

--== Class Constants

-- pixel amount to edges of tableView in which rows are de-/rendered
TableView.DEFAULT_RENDER_MARGIN = 100
TableView.DEFAULT_FRICTION = 0.92
TableView.DEFAULT_MASS = 10

TableView.MARGIN = 20
TableView.RADIUS = 5

TableView.HIT_TOP_LIMIT = "top_limit_hit"
TableView.HIT_BOTTOM_LIMIT = "bottom_limit_hit"


--== Event Constants

TableView.EVENT = "table_view_event"

TableView.ROW_RENDER = "row_render_event"



--== Start: Setup DMC Objects


function TableView:_init( params )
	print( "TableView:_init" )
	self:superCall( "_init", params )
	--==--

	params = params or { }

	--== Create Properties ==--

	self._width = params.width or display.contentWidth
	self._height = params.height or display.contentHeight

	self._current_category = nil

	self._total_row_height = 0

	self._event_tmp = nil

	self._scroll_limit = nil -- type of limit, HIT_TOP_LIMIT, HIT_BOTTOM_LIMIT

	self._velocity = { value=0, vector=1 }

	self._transition = nil -- handle of active transition


	--== Display Groups ==--

	self._dg_scroller = nil  -- moveable item with rows
	self._dg_gui = nil  -- fixed items over table (eg, scrollbar)


	--== Object References ==--

	self._primer = nil

	self._bg = nil

	--[[
		array of row data
	--]]
	self._rows = nil

	--[[
		array of rendered row data
	--]]
	self._rendered_rows = nil

	self._categories = nil -- array of category data

	self._category_view = nil
	self._inactive_dots = {}

end

function TableView:_undoInit()
	print( "TableView:_undoInit" )

	--==--
	self:superCall( "_undoInit" )
end



-- _createView()
--
function TableView:_createView()
	print( "TableView:_createView" )
	self:superCall( "_createView" )
	--==--

	local W,H = self._width, self._height
	local H_CENTER, V_CENTER = W*0.5, H*0.5

	local o, dg, tmp  -- object, display group, tmp


	-- primer

	o = display.newRect( 0,0, self._width, self._height )
	o:setFillColor( 0, 1, 1, 1 )
	o.anchorX, o.anchorY = 0,0
	o.x,o.y = 0, 0

	self:insert( o )
	self._primer = o

	self.anchorX, self.anchorY = 0,0

	o.x,o.y = 0, 0


	-- container for rows/background

	dg = display.newGroup()
	self:insert( dg )
	self._dg_scroller = dg

	-- background
	o = display.newRect( 0,0, self._width, self._height )
	o:setFillColor( 0.5, 0.5, 0.5, 1 )

	o.anchorX, o.anchorY = 0, 0
	o.x,o.y = 0, 0

	dg:insert( o )
	self._bg = o

	dg.anchorX, dg.anchorY = 0,0
	dg.x, dg.y = 0, 0



end

function TableView:_undoCreateView()
	print( "TableView:_undoCreateView" )

	local o

	o = self._primer
	o:removeSelf()
	self._primer = nil

	o = self._dg
	o:removeSelf()
	self._dg = nil

	--==--
	self:superCall( "_undoCreateView" )
end


-- _initComplete()
--
function TableView:_initComplete()
	--print( "TableView:_initComplete" )

	local o, f
	self._rows = {}
	self._rendered_rows = {}


	f = self:createCallback( self._touch_handler )
	self._dg_scroller:addEventListener( "touch", f )


	--==--
	self:superCall( "_initComplete" )
end

function TableView:_undoInitComplete()
	--print( "TableView:_undoInitComplete" )

	--==--
	self:superCall( "_undoInitComplete" )
end


--== END: Setup DMC Objects





--====================================================================--
--== Public Methods




function TableView:insertRow( row_info )
	-- print( "TableView:insertRow" )

	local o
	local x,y

	local row_data = {
		data = row_info,

		xMin=0,
		xMax=0,
		width=0,

		yMin=0,
		yMax=0,
		height=0,

		isRendered=false,
		index=0
	}

	-- use global row render functions if not local

	if not row_info.onRowRender then row_info.onRowRender = self._onRowRender end
	if not row_info.onRowUnrender then row_info.onRowUnrender = self._onRowUnrender end


	-- category setup

	if row_info.isCategory then

		self._current_category = row_data
		table.insert( self._categories, row_data )

	else

		if self._current_category then
			row_info._category = self._current_category
		end

	end

	-- configure row data of new row element

	row_data.height = row_info.height
	row_data.yMin = self._total_row_height
	row_data.yMax = row_data.yMin + row_data.height

	table.insert( self._rows, row_data )
	row_data.index = #self._rows

	-- print( 'row insert', row_data.yMin, row_data.yMax )


	-- adjust background height

	self._total_row_height = self._total_row_height + row_data.height

	o = self._bg
	x,y = o.x, o.y -- temp
	o.height = self._total_row_height
	o.anchorX, o.anchorY = 0,0
	o.x, o.y = x, y


	-- update display with changes

	self:_updateDisplay()

end





--====================================================================--
--== Private Methods

function TableView:_contentBounds()
	-- print( 'tableView:_contentBounds')

	local W,H = self._width, self._height
	local H_CENTER, V_CENTER = W*0.5, H*0.5

	local bounds = self._primer.contentBounds
	local x_offset = self._dg_scroller.x
	local y_offset = self._dg_scroller.y

	-- print( self._primer.y, self._primer.height )
	local o = self._primer


	-- print( y_offset )
	-- print( bounds.xMin, bounds.xMax, bounds.yMin, bounds.yMax )
	-- print( bounds.yMin, bounds.yMax )

	local MARGIN = TableView.DEFAULT_RENDER_MARGIN

	return {
		xMin = bounds.xMin + x_offset - MARGIN,
		xMax = bounds.xMax + x_offset + MARGIN,
		yMin = o.y - y_offset - MARGIN,
		yMax = o.y + o.height - y_offset + MARGIN,
	}

end




function TableView:_updateDisplay()
	-- print( "TableView:_updateDisplay" )

	local bounds = self:_contentBounds()

	-- print( 'back >> ', bounds.yMin, bounds.yMax )

	local bg_height = bounds.yMax - bounds.yMin

	local min_visible_row, max_visible_row = nil, nil
	local row

	-- check if current rows are valid
	-- print( 'checking valid rows', #self._rendered_rows )

	if #self._rendered_rows > 0 then
	for i = #self._rendered_rows, 1, -1 do
		local data = self._rendered_rows[ i ]
		local is_bounded = bounds.yMin <= data.yMin and data.yMax < bounds.yMax
		-- print( i, 'rendered row', data.index, data.data.data, is_bounded )

		if not is_bounded then self:_unRenderRow( data, { index=i } ) end

	end
	end

	-- print('after cull')
	for i,v in ipairs( self._rendered_rows ) do
		-- print( i, v.index )
	end

	-- if no rows are valid, find the top one
	if #self._rendered_rows == 0 then
		min_visible_row = nil
		max_visible_row = self:_findFirstVisibleRow()

		row = self:_renderRow( max_visible_row, { head=true } )

	else

		min_visible_row = self._rendered_rows[1]
		max_visible_row = self._rendered_rows[ #self._rendered_rows ]

		-- print( 'row', min_visible_row.index )
		-- print( #self._rendered_rows, max_visible_row.index )

	end

	if min_visible_row then
		-- search up until off screen

		local row_data, index
		index = min_visible_row.index - 1
		-- print( 'searching up from index', index )
		if index >= 1 then

			for i = index, 1, -1 do
				row_data = self._rows[ i ]
				local is_bounded = bounds.yMin <= row_data.yMin and row_data.yMax < bounds.yMax

				-- print( i, is_bounded, bounds.yMin, row_data.yMin, row_data.yMax, bounds.yMax )

				if not is_bounded then
					-- print( 'not bounded breaking' )
					break
				end

				self:_renderRow( row_data, { head=true  }   )

			end

		end



	end

	if max_visible_row then
		-- search down until off screen


		local is_bounded
		local row_data, index
		index = max_visible_row.index + 1

		-- print( 'searching down from index', index )

		if index <= #self._rows then

			for i = index, #self._rows do
				row_data = self._rows[ i ]
				if not row_data then print("no row data!!") ; break end
				is_bounded = bounds.yMin <= row_data.yMin and row_data.yMax < bounds.yMax
				-- print( i, is_bounded, bounds.yMin, row_data.yMin, row_data.yMax, bounds.yMax )

				if not is_bounded then
					-- print( 'not bounded breaking' )
					break
				end

				self:_renderRow( row_data, { head=false } )

			end  -- for
		end -- if

	end -- if max_visible_row


end


function TableView:_findFirstVisibleRow()
	print( "TableView:_findFirstVisibleRow" )



	return self._rows[1]
end





--[[

un-/render row event


local e = {}
e.name = "tableView_rowRender"
e.type = "unrender"
e.parent = self	-- tableView that this row belongs to
e.target = row
e.row = row
e.id = row.id
e.view = row.view
e.background = row.view.background
e.line = row.view.line
e.data = row.data
e.phase = "unrender"		-- phases: unrender, render, press, release, swipeLeft, swipeRight
e.index = row.index



--]]


function TableView:_renderRow( row_data, options )
	-- print( "TableView:_renderRow", row_data, row_data.index )

	local row_info = row_data.data

	if row_data.view then print("already rendered") ; return end

	local dg = self._dg_scroller
	local view, bg, line

	--== Create View Items

	-- create view for this row
	view = display.newGroup()
	dg:insert( view )

	-- create background
	bg = display.newRect( 0, 0, self._width, row_info.height )
	bg.anchorX, bg.anchorY = 0,0
	bg:setFillColor( 1, 0, 0, 0.5 )
	bg:setStrokeColor( 0, 0, 0, 0.5 )
	bg.strokeWidth = 1
	view:insert( bg )

	-- create bottom-line


	-- save items

	row_data.view = view
	row_data.background = bg


	--== Render View

	local e ={
		name = TableView.EVENT,
		type = TableView.ROW_RENDER,

		parent = self,
		target = row_info,
		row = row_info,
		view = view,
		background = bg,
		line = line,
		data = row_info.data,
		index = row_data.index,
	}
	row_info.onRowRender( e )


	--== Update Row

	-- print( 'render ', row_data.yMin, row_data.yMax )
	view.x, view.y = row_data.xMin, row_data.yMin

	local idx = 1
	if options.head == false then idx = #self._rendered_rows+1 end

	-- print( 'insert', #self._rendered_rows, idx )
	table.insert( self._rendered_rows, idx, row_data )

end



function TableView:_unRenderRow( row_data, options )
	-- print( "TableView:_unRenderRow", row_data.index )

	-- Utils.print( row_data )

	if not row_data.view then print("note rendered") ; return end


	local row_info = row_data.data

	local dg = self._dg_scroller
	local view, bg, line

	-- print( 'removing ', row_data.index )

	--== Remove Rendered Item

	view = row_data.view
	bg = row_data.background


	table.remove( self._rendered_rows, options.index )

	local e ={
		name = TableView.EVENT,
		type = TableView.ROW_RENDER,

		parent = self,
		target = row_info,
		row = row_info,
		view = view,
		background = bg,
		line = line,
		data = row_info.data,
		index = row_data.index,
	}
	row_info.onRowUnrender( e )


	bg = row_data.background
	bg:removeSelf()
	row_data.background = nil

	view = row_data.view
	view:removeSelf()
	row_data.view = nil

end


function TableView:_checkScrollBounds()
	-- print( 'tableView:_checkScrollBounds' )

	local scr = self._dg_scroller
	-- print( "scr.y, ", scr.y , (self._height - self._total_row_height) )
	if scr.y > 0 then
		self._scroll_limit = TableView.HIT_TOP_LIMIT
	elseif scr.y <  self._height - self._total_row_height then
		self._scroll_limit = TableView.HIT_BOTTOM_LIMIT
	else
		self._scroll_limit = nil
	end
end


function TableView:enterFrame( event )
	-- print( 'TableView:enterFrame' )

	local M, V, F
	M = 3
	F = 0.871

	local v = self._velocity
	local scr = self._dg_scroller
	local evt_tmp = self._event_tmp
	local delta_time = event.time - evt_tmp.time
	local y_delta

	self:_checkScrollBounds()


	if v.value <= 0 and not self._scroll_limit then
		-- print( 'valiue < 0 not banded')

		v.value = 0
		v.vector = 1
		Runtime:removeEventListener( 'enterFrame', self )


	elseif v.value <= 0 and self._scroll_limit then
		-- print( 'valiue <= 0', self._scroll_limit)

		local f = function()
			self:_checkScrollBounds()
		end

		if self._scroll_limit == TableView.HIT_TOP_LIMIT then
			transition.to( scr, { y=0, time=500, onComplete=f })
		else
			transition.to( scr, { y=(self._height - self._total_row_height), time=500,  onComplete=f  })
		end

		v.value = 0
		v.vector = 1
		Runtime:removeEventListener( 'enterFrame', self )


	elseif v.value > 0 and not self._scroll_limit then
		-- print( 'valiue > 0 not banded')

		-- calculate velocity adjustment

		-- adjust for friction
		-- F=ma, v=Fmt
		V = F * M * (delta_time/1000)
		v.value = v.value - V

		-- adjust for kinetic energy
		-- .5 * m * v^2   or
		-- v.value = v.value - 0

		y_delta = v.value * delta_time
		if y_delta > 100 then y_delta = 100 end -- clamp speed

		scr.y = scr.y + ( y_delta * v.vector )

		-- print( " value, vector, ", v.value, v.vector, scr.y, y_delta )


	elseif v.value > 0 and self._scroll_limit then
		-- print( 'valiue > 0', self._scroll_limit )

		local f = function()
			self:_checkScrollBounds()
		end

		if self._scroll_limit == TableView.HIT_TOP_LIMIT then
			transition.to( scr, { y=0, time=500, onComplete=f })
		else
			transition.to( scr, { y=(self._height - self._total_row_height), time=500,  onComplete=f  })
		end

		v.value = 0
		v.vector = 1
		Runtime:removeEventListener( 'enterFrame', self )

	end


	self._event_tmp = event
	self:_updateDisplay()

end




function TableView:_touch_handler( event )
	-- print( "TableView:_touch_handler", event.phase )

	local phase = event.phase
	local y_delta = event.y - event.yStart



	if phase == "began" then

		-- stop any active movement

		self._velocity = { value=0, vector=1 }
		Runtime:removeEventListener( 'enterFrame', self )

		-- save event for movement calculations
		self._event_tmp = event

		-- handle touch
		display.getCurrentStage():setFocus( self._dg_scroller, event.id )

	end


	if phase == "moved" then
		-- Utils.print( event )

		local scr = self._dg_scroller
		local v = self._velocity
		local mult = 1
		local d, t

		self:_checkScrollBounds()
		if self._scroll_limit then mult = 0.3 end


		-- move scroller

		y_delta = event.y - self._event_tmp.y
		scr.y = scr.y + ( y_delta * mult )

		self:_updateDisplay()


		-- calculate velocity

		d = event.y-self._event_tmp.y
		t = (event.time-self._event_tmp.time)

		v.value = math.abs( d/t )

		v.vector = 1
		if d < 0 then v.vector = -1 end

		-- print( 'velocity: d, t, vect, val', d, t, v.vector, v.value )

		-- save event for movement calculation

		self._event_tmp = event
	end


	if "ended" == phase or "cancelled" == phase then

		-- validate our location
		self:_checkScrollBounds()

		-- clean up
		display.getCurrentStage():setFocus( nil, event.id )


		-- add system time, we can re-use this event for Runtime
		self._event_tmp = event
		event.time = system.getTimer()

		Runtime:addEventListener( 'enterFrame', self )


		-- local v = self._velocity
		-- print( 'velocity: d, t, vect, val', v.vector, v.value )
		-- print( 'bounded ', self._scroll_limit )

	end

	return true

end







--====================================================================--
--== Event Handlers





-- _dispatchEvent
--
function TableView:_dispatchEvent( e_type, data )
--print( "TableView:_dispatchEvent ", e_type )

	params = params or {}

	-- setup custom event
	local e = {
		name = TableView.EVENT,
		type = e_type,
		data = data
	}

	self:dispatchEvent( e )
end





return TableView





