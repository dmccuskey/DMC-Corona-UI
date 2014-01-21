--====================================================================--
-- widget_SlideView.lua
--
--
-- by David McCuskey
-- Documentation: http://docs.davidmccuskey.com/display/docs/newSlideView.lua
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
-- DMC Widgets : newSlideView
--====================================================================--



--====================================================================--
-- Imports
--====================================================================--

local Utils = require( dmc_lib_func.find('dmc_utils') )
local Objects = require( dmc_lib_func.find('dmc_objects') )
local States = require( dmc_lib_func.find('dmc_states') )

local ScrollerViewBase = require( dmc_widget_func.find( 'scroller_view_base' ) )
local easingx = require( dmc_widget_func.find( 'easingx' ) )



--====================================================================--
-- Setup, Constants
--====================================================================--

-- setup some aliases to make code cleaner
local inheritsFrom = Objects.inheritsFrom
local CoronaBase = Objects.CoronaBase



--====================================================================--
-- Slide View Widget Class
--====================================================================--

local SlideView = inheritsFrom( ScrollerViewBase )
SlideView.NAME = "Slide View Widget Class"


--== Class Constants


--== State Constants

-- STATE_CREATE = "state_create"
-- STATE_AT_REST = "state_at_rest"
-- STATE_TOUCH = "state_touch"
-- STATE_RESTRAINT = "state_touch"
-- STATE_RESTORE = "state_touch"
SlideView.STATE_MOVE_TO_NEAREST_SLIDE = "move_to_nearest_slide"
SlideView.STATE_MOVE_TO_NEXT_SLIDE = "move_to_next_slide"

SlideView.STATE_MOVE_TO_NEAREST_SLIDE_TRANS_TIME = 250
SlideView.STATE_MOVE_TO_NEXT_SLIDE_TRANS_TIME = 250


--== Event Constants



--====================================================================--
--== Start: Setup DMC Objects


function SlideView:_init( params )
	-- print( "SlideView:_init" )
	self:superCall( "_init", params )
	--==--

	params = params or { }

	--== Create Properties ==--

	-- self._width = 0
	-- self._height = 0
	-- self._total_item_dimension = 0
	-- self._scroll_limit = nil -- type of limit, HIT_TOP_LIMIT, HIT_BOTTOM_LIMIT

	-- self._current_category = nil

	-- self._total_row_height = 0

	-- self._event_tmp = nil


	-- self._velocity = { value=0, vector=1 }

	-- self._transition = nil -- handle of active transition


	-- --== Display Groups ==--

	-- self._dg_scroller = nil  -- moveable item with rows
	-- self._dg_gui = nil  -- fixed items over table (eg, scrollbar)


	-- --== Object References ==--

	-- self._primer = nil

	-- self._bg = nil

	-- --[[
	-- 	array of row data
	-- --]]
	-- self._rows = nil

	-- --[[
	-- 	array of rendered row data
	-- --]]
	-- self._rendered_rows = nil

	-- self._categories = nil -- array of category data

	-- self._category_view = nil
	-- self._inactive_dots = {}

	self._h_scroll_enabled = true
	self._v_scroll_enabled = false

end

function SlideView:_undoInit()
	-- print( "SlideView:_undoInit" )

	--==--
	self:superCall( "_undoInit" )
end



-- _createView()
--
function SlideView:_createView()
	-- print( "SlideView:_createView" )
	self:superCall( "_createView" )
	--==--

	local W,H = self._width, self._height
	local H_CENTER, V_CENTER = W*0.5, H*0.5

	local o, dg, tmp  -- object, display group, tmp

end

function SlideView:_undoCreateView()
	-- print( "SlideView:_undoCreateView" )

	local o

	--==--
	self:superCall( "_undoCreateView" )
end


-- _initComplete()
--
function SlideView:_initComplete()
	--print( "SlideView:_initComplete" )

	local o, f
	self._rows = {}
	self._rendered_rows = {}


	self:setState( self.STATE_CREATE )
	self:gotoState( self.STATE_AT_REST )

	--==--
	self:superCall( "_initComplete" )
end

function SlideView:_undoInitComplete()
	--print( "SlideView:_undoInitComplete" )

	--==--
	self:superCall( "_undoInitComplete" )
end


--== END: Setup DMC Objects





--====================================================================--
--== Public Methods



-- set method on our object, make lookup faster
SlideView.insertSlide = ScrollerViewBase.insertItem




--====================================================================--
--== Private Methods



-- calculate horizontal direction
--
function SlideView:_updateDimensions( item_info, item_data )
	-- print( "SlideView:_updateDimensions", item_info )

	local total_dim = self._total_item_dimension

	local o
	local x, y


	-- configure item data of new item element

	item_data.width = item_info.width
	item_data.xMin = self._total_item_dimension
	item_data.xMax = item_data.xMin + item_data.width

	table.insert( self._items, item_data )
	item_data.index = #self._items

	-- print( 'item insert', item_data.xMin, item_data.xMax )

	total_dim = total_dim + item_data.width
	self._total_item_dimension = total_dim


	-- adjust background width

	if total_dim < self._width then
		total_dim = self._width
	end

	o = self._bg
	x, y = o.x, o.y -- temp
	o.width = total_dim
	o.anchorX, o.anchorY = 0,0
	o.x, o.y = x, y

end



function SlideView:_isBounded( scroller, item )
	-- print( "SlideView:_isBounded", scroller, item )

	local result = false

	if item.xMin < scroller.xMin and scroller.xMin < item.xMax then
		-- cut on top
		result = true
	elseif item.xMin < scroller.xMax and scroller.xMax < item.xMax then
		-- cut on bottom
		result = true
	elseif item.xMin > scroller.xMin and item.xMax < scroller.xMax  then
		-- fully in view
		result = true
	elseif item.xMin < scroller.xMin and scroller.xMax < item.xMax then
		-- extends over view
		result = true
	end

	return result
end



function SlideView:_findClosestSlide()
	-- print( "SlideView:_findClosestSlide" )

	local item, pos, idx  = nil, 999, 0
	local rendered = self._rendered_items
	local bounds = self:_contentBounds()
	local scr = self._dg_scroller

	for i,v in ipairs( rendered ) do
		-- print(i,v)
		local dist = math.abs( v.xMin + scr.x )
		-- print( v.xMin, scr.x, dist, pos )
		if dist < pos then
			item = v
			pos = dist
			idx = i
		end
	end

	return item, (item.xMin + scr.x), idx
end



function SlideView:_findNextSlide()
	-- print( "SlideView:_findNextSlide" )

	local scr = self._dg_scroller
	local v = self._h_velocity
	local rendered = self._rendered_items

	local close, dist, index = self:_findClosestSlide()

	local idx, item

	if v.vector == -1 then
		idx = index + 1
	else
		idx = index - 1
	end

	item = rendered[ idx ]
	if not item then item = rendered[ index ] end

	-- print( close.index, idx, item )
	return item, (item.xMin + scr.x)
end




--======================================================--
--== START: SLIDEVIEW STATE MACHINE



function SlideView:_getNextState( params )
	-- print( "SlideView:_getNextState" )

	params = params or {}

	local limit = self._h_scroll_limit
	local v = self._h_velocity

	local s, p -- state, params

	if v.value <= 0 and not limit then
		s = self.STATE_MOVE_TO_NEAREST_SLIDE
		p = { event=params.event }

	elseif v.value > 0 and not limit then
		s = self.STATE_MOVE_TO_NEXT_SLIDE
		p = { event=params.event }

	elseif v.value <= 0 and limit then
		s = self.STATE_RESTORE
		p = { event=params.event }

	elseif v.value > 0 and limit then
		s = self.STATE_RESTRAINT
		p = { event=params.event }

	end

	return s, p
end



--[[
-- from parent
function SlideView:do_state_touch( next_state, params )
end
--]]

function SlideView:state_touch( next_state, params )
	-- print( "SlideView:state_touch: >> ", next_state )

	if next_state == self.STATE_RESTORE then
		self:do_state_restore( params )

	elseif next_state == self.STATE_RESTRAINT then
		self:do_state_restraint( params )

	elseif next_state == self.STATE_MOVE_TO_NEAREST_SLIDE then
		self:do_move_to_nearest_slide( params )

	elseif next_state == self.STATE_MOVE_TO_NEXT_SLIDE then
		self:do_move_to_next_slide( params )

	else
		print( "WARNING :: SlideView:state_touch > " .. tostring( next_state ) )
	end

end



-- when object has neither velocity nor limit
-- we scroll to closest slide
--
function SlideView:do_move_to_nearest_slide( params )
	-- print( "SlideView:do_move_to_nearest_slide" )

	params = params or {}
	local evt_start = params.event

	local TIME = self.STATE_MOVE_TO_NEAREST_SLIDE_TRANS_TIME
	local ease_f = easingx.easeOut

	local scr = self._dg_scroller
	local pos = scr.x

	local item, dist = self:_findClosestSlide()

	local delta = -dist


	local enterFrameFunc = function( e )
		-- print( "SlideView: enterFrameFunc: do_move_to_nearest_slide" )

		local evt_frame = self._event_tmp

		local start_time_delta = e.time - evt_start.time -- total

		local x_delta

		--== Calculation

		x_delta = ease_f( start_time_delta, TIME, pos, delta )


		--== Action

		if start_time_delta < TIME then
			scr.x = x_delta

		else
			-- final state
			scr.x = pos + delta
			self:gotoState( self.STATE_AT_REST )

		end
	end

	-- start animation

	if self._enterFrameIterator == nil then
		Runtime:addEventListener( 'enterFrame', self )
	end
	self._enterFrameIterator = enterFrameFunc

	-- set current state
	self:setState( self.STATE_MOVE_TO_NEAREST_SLIDE )
end

function SlideView:move_to_nearest_slide( next_state, params )
	-- print( "SlideView:move_to_nearest_slide: >> ", next_state )

	if next_state == self.STATE_TOUCH then
		self:do_state_touch( params )

	elseif next_state == self.STATE_AT_REST then
		self:do_state_at_rest( params )

	else
		print( "WARNING :: SlideView:move_to_nearest_slide > " .. tostring( next_state ) )
	end

end



-- when object has neither velocity nor limit
-- we scroll to closest slide
--
function SlideView:do_move_to_next_slide( params )
	-- print( "SlideView:do_move_to_next_slide" )

	params = params or {}
	local evt_start = params.event

	local TIME = self.STATE_MOVE_TO_NEXT_SLIDE_TRANS_TIME
	local ease_f = easingx.easeOut

	local scr = self._dg_scroller
	local pos = scr.x

	local item, dist = self:_findNextSlide()

	local delta = -dist


	local enterFrameFunc = function( e )
		-- print( "SlideView: enterFrameFunc: do_move_to_next_slide" )

		local evt_frame = self._event_tmp

		local start_time_delta = e.time - evt_start.time -- total

		local x_delta

		--== Calculation

		x_delta = ease_f( start_time_delta, TIME, pos, delta )


		--== Action

		if start_time_delta < TIME then
			scr.x = x_delta

		else
			-- final state
			scr.x = pos + delta
			self:gotoState( self.STATE_AT_REST )

		end
	end

	-- start animation

	if self._enterFrameIterator == nil then
		Runtime:addEventListener( 'enterFrame', self )
	end
	self._enterFrameIterator = enterFrameFunc

	-- set current state
	self:setState( self.STATE_MOVE_TO_NEXT_SLIDE )
end

function SlideView:move_to_next_slide( next_state, params )
	-- print( "SlideView:move_to_next_slide: >> ", next_state )

	if next_state == self.STATE_TOUCH then
		self:do_state_touch( params )

	elseif next_state == self.STATE_AT_REST then
		self:do_state_at_rest( params )

	else
		print( "WARNING :: SlideView:move_to_next_slide > " .. tostring( next_state ) )
	end

end



-- when object has velocity and hit limit
-- we constrain its motion away from limit
--
function SlideView:do_state_restraint( params )
	-- print( "SlideView:do_state_restraint" )

	params = params or {}
	local evt_start = params.event

	local TIME = self.STATE_RESTRAINT_TRANS_TIME
	local ease_f = easingx.easeOut

	local v = self._h_velocity
	local scr = self._dg_scroller

	local velocity = v.value * v.vector
	local v_delta = -velocity


	local enterFrameFunc = function( e )
		-- print( "SlideView: enterFrameFunc: do_state_restraint" )

		local evt_frame = self._event_tmp
		local limit = self._v_scroll_limit

		local start_time_delta = e.time - evt_start.time -- total
		local frame_time_delta = e.time - evt_frame.time

		local x_delta


		--== Calculation

		v.value = ease_f( start_time_delta, TIME, velocity, v_delta )
		x_delta = v.value * frame_time_delta


		--== Action

		if start_time_delta < TIME then
			scr.x = scr.x + x_delta

		else
			-- final state
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

function SlideView:state_restraint( next_state, params )
	-- print( "SlideView:state_restraint: >> ", next_state )

	if next_state == self.STATE_TOUCH then
		self:do_state_touch( params )

	elseif next_state == self.STATE_RESTORE then
		self:do_state_restore( params )

	else
		print( "WARNING :: SlideView:state_restraint > " .. tostring( next_state ) )
	end

end





-- when object has neither velocity nor limit
-- we scroll to closest slide
--
function SlideView:do_state_restore( params )
	-- print( "SlideView:do_state_restore" )

	params = params or {}
	local evt_start = params.event

	local TIME = self.STATE_RESTORE_TRANS_TIME
	local ease_f = easingx.easeOut

	local limit = self._h_scroll_limit
	local scr = self._dg_scroller
	local background = self._bg

	local pos = scr.x
	local dist, delta

	if limit == self.HIT_TOP_LIMIT then
		dist = scr.x
	else
		dist = pos - ( self._width - background.width )
	end

	delta = -dist


	local enterFrameFunc = function( e )
		-- print( "SlideView: enterFrameFunc: do_state_restore" )

		local evt_frame = self._event_tmp

		local start_time_delta = e.time - evt_start.time -- total

		local x_delta


		--== Calculation

		x_delta = ease_f( start_time_delta, TIME, pos, delta )


		--== Action

		if start_time_delta < TIME then
			scr.x = x_delta

		else
			-- final state
			scr.x = pos + delta
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

function SlideView:state_restore( next_state, params )
	-- print( "SlideView:state_restore: >> ", next_state )

	if next_state == self.STATE_TOUCH then
		self:do_state_touch( params )

	elseif next_state == self.STATE_AT_REST then
		self:do_state_at_rest( params )

	else
		print( "WARNING :: SlideView:state_restore > " .. tostring( next_state ) )
	end

end




--====================================================================--
--== Event Handlers



-- set method on our object, make lookup faster
SlideView.enterFrame = ScrollerViewBase.enterFrame




return SlideView
