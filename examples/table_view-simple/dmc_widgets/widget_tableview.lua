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
-- DMC Widgets Setup
--====================================================================--

local dmc_widget_data, dmc_widget_func
dmc_widget_data = _G.__dmc_widget
dmc_widget_func = dmc_widget_data.func



--====================================================================--
-- DMC Widgets : newTableView
--====================================================================--



--====================================================================--
-- Imports
--====================================================================--

local Utils = require( dmc_lib_func.find('dmc_utils') )
local Objects = require( dmc_lib_func.find('dmc_objects') )

local ScrollerViewBase = require( dmc_widget_func.find( 'scroller_view_base' ) )
local easingx = require( dmc_widget_func.find( 'easingx' ) )



--====================================================================--
-- Setup, Constants
--====================================================================--

-- setup some aliases to make code cleaner
local inheritsFrom = Objects.inheritsFrom
local CoronaBase = Objects.CoronaBase



--====================================================================--
-- Table View Widget Class
--====================================================================--

local TableView = inheritsFrom( ScrollerViewBase )
TableView.NAME = "Table View Widget Class"


--== Class Constants



--== Event Constants

-- STATE_CREATE = "state_create"
-- STATE_AT_REST = "state_at_rest"
-- STATE_TOUCH = "state_touch"
-- STATE_RESTRAINT = "state_touch"
-- STATE_RESTORE = "state_touch"
TableView.STATE_SCROLL = "state_scroll"

TableView.STATE_SCROLL_TRANS_TIME = 1000




--====================================================================--
--== Start: Setup DMC Objects


function TableView:_init( params )
	-- print( "TableView:_init" )
	self:superCall( "_init", params )
	--==--

	--== Sanity Check ==--

	params = params or { }


	--== Create Properties ==--

	-- self._width = params.width or display.contentWidth
	-- self._height = params.height or display.contentHeight

	-- self._current_category = nil

	-- self._total_row_height = 0

	-- self._event_tmp = nil

	-- self._scroll_limit = nil -- type of limit, HIT_TOP_LIMIT, HIT_BOTTOM_LIMIT

	-- self._velocity = { value=0, vector=1 }

	-- self._transition = nil -- handle of active transition



	--== Display Groups ==--

	-- self._dg_scroller = nil  -- moveable item with rows
	-- self._dg_scroller_f = nil  -- ref to touch callback

	-- self._dg_gui = nil  -- fixed items over table (eg, scrollbar)


	--== Object References ==--

	-- self._primer = nil

	-- self._bg = nil

	-- --[[
	-- 	array of row data
	-- 	this is all of the rows we know about
	-- --]]
	-- self._rows = nil

	-- --[[
	-- 	array of rendered row data
	-- 	this is only list of visible *rendered* rows
	-- --]]
	-- self._rendered_rows = nil

	-- self._categories = nil -- array of category data

	-- self._category_view = nil
	-- self._inactive_dots = {}

	self._h_scroll_enabled = false
	self._v_scroll_enabled = true

end

function TableView:_undoInit()
	-- print( "TableView:_undoInit" )

	--==--
	self:superCall( "_undoInit" )
end



--== END: Setup DMC Objects
--====================================================================--




--====================================================================--
--== Public Methods



-- set method on our object, make lookup faster
TableView.insertRow = ScrollerViewBase.insertItem




--====================================================================--
--== Private Methods



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
	item_data.yMax = item_data.yMin + item_data.width

	table.insert( self._items, item_data )
	item_data.index = #self._items

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



function TableView:_isBounded( scroller, item )
	-- print( "TableView:_isBounded", scroller, item )

	local result = false

	if item.yMin < scroller.yMin and scroller.yMin < item.yMax then
		-- cut on top
		result = true
	elseif item.yMin < scroller.yMax and scroller.yMax < item.yMax then
		-- cut on bottom
		result = true
	elseif item.yMin > scroller.yMin and item.yMax < scroller.yMax  then
		-- fully in view
		result = true
	elseif item.yMin < scroller.yMin and scroller.yMax < item.yMax then
		-- extends over view
		result = true
	end

	return result
end





--======================================================--
--== START: TABLEVIEW STATE MACHINE



-- set method on our object, make lookup faster
TableView._getNextState = ScrollerViewBase._getNextState



-- when object has neither velocity nor limit
-- we scroll to closest slide
--
function TableView:do_state_scroll( params )
	-- print( "TableView:do_state_scroll" )

	params = params or {}
	local evt_start = params.event

	local TIME = self.STATE_SCROLL_TRANS_TIME
	local ease_f = easingx.easeOut

	local v = self._v_velocity
	local scr = self._dg_scroller

	local velocity = v.value
	local v_delta = -velocity


	local enterFrameFunc = function( e )
		-- print( "TableView: enterFrameFunc: do_state_scroll" )

		local evt_frame = self._event_tmp
		local limit = self._v_scroll_limit

		local start_time_delta = e.time - evt_start.time
		local frame_time_delta = e.time - evt_frame.time

		local y_delta


		--== Calculation

		v.value = ease_f( start_time_delta, TIME, velocity, v_delta )
		y_delta = v.value * v.vector * frame_time_delta


		--== Action

		if v.value > 0 and limit then
			-- we hit edge while moving
			self:gotoState( self.STATE_RESTRAINT, { event=e } )

		elseif start_time_delta < TIME then
			scr.y = scr.y + y_delta

		else
			v.value = 0
			self:gotoState( self.STATE_AT_REST, { event=e } )

		end
	end

	-- start animation

	if self._enterFrameIterator == nil then
		Runtime:addEventListener( 'enterFrame', self )
	end
	self._enterFrameIterator = enterFrameFunc


	-- set current state
	self:setState( self.STATE_SCROLL )
end

function TableView:state_scroll( next_state, params )
	-- print( "TableView:state_scroll: >> ", next_state )

	if next_state == self.STATE_TOUCH then
		self:do_state_touch( params )

	elseif next_state == self.STATE_AT_REST then
		self:do_state_at_rest( params )

	elseif next_state == self.STATE_RESTRAINT then
		self:do_state_restraint( params )

	else
		print( "WARNING :: TableView:state_scroll > " .. tostring( next_state ) )
	end

end






-- when object has neither velocity nor limit
-- we scroll to closest slide
--
function TableView:do_state_restore( params )
	print( "TableView:do_state_restore" )

	params = params or {}
	local evt_start = params.event

	local TIME = self.STATE_RESTORE_TRANS_TIME
	local ease_f = easingx.easeOut

	local limit = self._v_scroll_limit
	local scr = self._dg_scroller
	local background = self._bg

	local pos = scr.y
	local dist, delta

	if limit == self.HIT_TOP_LIMIT then
		dist = scr.y
	else
		dist = pos - ( self._height - background.height )
	end

	delta = -dist

	print( limit )

	local enterFrameFunc = function( e )
		print( "TableView: enterFrameFunc: do_state_restore" )

		local evt_frame = self._event_tmp

		local start_time_delta = e.time - evt_start.time -- total

		local y_delta


		--== Calculation

		y_delta = ease_f( start_time_delta, TIME, pos, delta )


		--== Action

		if start_time_delta < TIME then
			scr.y = y_delta

		else
			-- final state
			scr.y = pos + delta
			self:gotoState( self.STATE_AT_REST )

		end
	end

	-- start animation

	if self._enterFrameIterator == nil then
		Runtime:addEventListener( 'enterFrame', self )
	end
	self._enterFrameIterator = enterFrameFunc

	-- set current state
	self:setState( self.STATE_RESTORE )
end

function TableView:state_restore( next_state, params )
	-- print( "TableView:state_restore: >> ", next_state )

	if next_state == self.STATE_TOUCH then
		self:do_state_touch( params )

	elseif next_state == self.STATE_AT_REST then
		self:do_state_at_rest( params )

	else
		print( "WARNING :: TableView:state_restore > " .. tostring( next_state ) )
	end

end







-- when object has velocity and hit limit
-- we constrain its motion away from limit
--
function TableView:do_state_restraint( params )
	print( "TableView:do_state_restraint" )

	params = params or {}
	local evt_start = params.event

	local TIME = self.STATE_RESTRAINT_TRANS_TIME
	local ease_f = easingx.easeOut

	local v = self._v_velocity
	local scr = self._dg_scroller

	local velocity = v.value * v.vector
	local v_delta = -velocity


	local enterFrameFunc = function( e )
		print( "TableView: enterFrameFunc: do_state_restraint" )

		local evt_frame = self._event_tmp
		local limit = self._v_scroll_limit

		local start_time_delta = e.time - evt_start.time -- total
		local frame_time_delta = e.time - evt_frame.time

		local y_delta


		--== Calculation

		v.value = ease_f( start_time_delta, TIME, velocity, v_delta )
		y_delta = v.value * frame_time_delta


		--== Action

		if start_time_delta < TIME then
			scr.y = scr.y + y_delta

		else
			v.value = 0
			self:gotoState( self.STATE_RESTORE, { event=e } )

		end
	end

	-- start animation

	if self._enterFrameIterator == nil then
		Runtime:addEventListener( 'enterFrame', self )
	end
	self._enterFrameIterator = enterFrameFunc

	-- set current state
	self:setState( self.STATE_RESTRAINT )
end

function TableView:state_restraint( next_state, params )
	-- print( "TableView:state_restraint: >> ", next_state )

	if next_state == self.STATE_TOUCH then
		self:do_state_touch( params )

	elseif next_state == self.STATE_RESTORE then
		self:do_state_restore( params )

	else
		print( "WARNING :: TableView:state_restraint > " .. tostring( next_state ) )
	end

end




--====================================================================--
--== Event Handlers



-- set method on our object, make lookup faster
TableView.enterFrame = ScrollerViewBase.enterFrame




return TableView
