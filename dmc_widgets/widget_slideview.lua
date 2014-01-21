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
-- DMC Widgets : newSlideView
--====================================================================--

local args = { ... }
local PATH = args[1]



--====================================================================--
-- Module Support
--====================================================================--





--====================================================================--
-- Imports
--====================================================================--

local Utils = require( dmc_lib_func.find('dmc_utils') )
local Objects = require( dmc_lib_func.find('dmc_objects') )
local States = require( dmc_lib_func.find('dmc_states') )


--== Find Local Path

local PATH_PARTS =  Utils.split( PATH, '%.' )
if #PATH_PARTS > 0 then table.remove( PATH_PARTS, #PATH_PARTS ) end
PATH = table.concat( PATH_PARTS, '.' )
if PATH ~= '' then PATH = PATH .. '.' end


--== View Components

local ScrollerViewBase = require( PATH .. 'scroller_view_base' )


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

States.mixin( SlideView )


--== Class Constants

-- pixel amount to edges of SlideView in which rows are de-/rendered
SlideView.DEFAULT_RENDER_MARGIN = display.contentWidth
SlideView.DEFAULT_FRICTION = 0.92
SlideView.DEFAULT_MASS = 10

SlideView.MARGIN = 20
SlideView.RADIUS = 5

SlideView.HIT_TOP_LIMIT = "top_limit_hit"
SlideView.HIT_BOTTOM_LIMIT = "bottom_limit_hit"


--== State Constants

-- STATE_CREATE = "state_create"
-- STATE_AT_REST = "state_at_rest"
-- STATE_TOUCH = "state_touch"
-- STATE_RESTRAINT = "state_touch"
-- STATE_RESTORE = "state_touch"
SlideView.STATE_MOVE_TO_NEAREST_SLIDE = "move_to_nearest_slide"
SlideView.STATE_MOVE_TO_NEXT_SLIDE = "move_to_next_slide"


--== Event Constants

SlideView.EVENT = "slide_view_event"

SlideView.SLIDE_RENDER = "slide_render_event"



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

	self._horizontal_scroll_enabled = true
	self._vertical_scroll_enabled = false

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



SlideView.insertSlide = ScrollerViewBase.insertItem



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


	-- adjust background height

	total_dim = total_dim + item_data.width

	o = self._bg
	x, y = o.x, o.y -- temp
	o.width = total_dim
	o.anchorX, o.anchorY = 0,0
	o.x, o.y = x, y

	self._total_item_dimension = total_dim

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



--====================================================================--
--== Private Methods




function SlideView:_isBounded( scroller, item )
	print( "SlideView:_isBounded", scroller, item )

	local b = {
		view=1.0,  -- if item is in the view rectangle, percentage offset from center
		widget=true -- if item is in widget render rectangle
	}

	print( scroller.xMin, item.xMin, item.xMax, scroller.xMax )
	return ( scroller.xMin <= item.xMin and item.xMax < scroller.xMax )
end


-- set method on our object, make lookup faster
SlideView.enterFrame = ScrollerViewBase.enterFrame




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
	function SlideView:state_touch( next_state, params )
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
	local evt_tmp = params.event

	local TIME = self.TRANSITION_TIME *0.5

	local scr = self._dg_scroller
	local pos = scr.x

	local item, dist = self:_findClosestSlide()

	-- print( dist, scr.x )

	local enterFrameFunc = function( e )
		-- print( "enterFrameFunc: move to nearest slide" )

		local delta_time = e.time - evt_tmp.time

		if delta_time < TIME then
			scr.x = pos - ( delta_time/TIME ) * dist
		else
			-- final state
			scr.x = pos - dist
			self:gotoState( self.STATE_AT_REST )
		end
	end

	if self._enterFrameIterator == nil then
		Runtime:addEventListener( 'enterFrame', self )
	end
	self._enterFrameIterator = enterFrameFunc

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

	local TIME = self.TRANSITION_TIME *0.5
	local evt_tmp = params.event

	local scr = self._dg_scroller
	local pos = scr.x

	local item, dist = self:_findNextSlide()

	-- print( dist, scr.x )

	local enterFrameFunc = function( e )
		-- print( "enterFrameFunc: move to next slide" )

		local delta_time = e.time - evt_tmp.time

		if delta_time < TIME then
			scr.x = pos - ( delta_time/TIME ) * dist
		else
			-- final state
			scr.x = pos - dist
			self:gotoState( self.STATE_AT_REST )
		end
	end

	if self._enterFrameIterator == nil then
		Runtime:addEventListener( 'enterFrame', self )
	end
	self._enterFrameIterator = enterFrameFunc

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
	local evt_tmp = params.event

	local M, F = self._mass, self._friction
	local k = self._spring

	local v = self._h_velocity
	local scr = self._dg_scroller
	local pos = scr.x

	local enterFrameFunc = function( e )
		-- print( "enterFrameFunc: restraint movement" )

		local delta_time = e.time - evt_tmp.time

		local V, x_delta
		local s

		--== Calculation

		-- adjust for friction
		-- F=ma, v=Fmt
		V = F * M * (delta_time/1000)
		v.value = v.value - V

		-- adjust for spring resistance
		-- .5 * k * s^2
		-- print ( math.pow( scr.x, 2 ) * 5 )
		if self._h_scroll_limit == self.HIT_TOP_LIMIT then
			s = scr.x
		else
			s = ( self._width - self._total_item_dimension ) - scr.x
		end
		V = 0.5 * k * math.pow( s, 2 )
		v.value = v.value - V

		-- calculate value
		x_delta = v.value * delta_time

		--== Action

		if v.value > 0 then
			scr.x = scr.x + ( x_delta * v.vector )

		else
			-- final state
			v.value = 0
			self:gotoState( self.STATE_RESTORE, { event=e } )
		end
	end

	if self._enterFrameIterator == nil then
		Runtime:addEventListener( 'enterFrame', self )
	end
	self._enterFrameIterator = enterFrameFunc

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
	local evt_tmp = params.event

	local TIME = self.TRANSITION_TIME

	local limit = self._h_scroll_limit
	local scr = self._dg_scroller
	local pos = scr.x

	local dist
	if limit == self.HIT_TOP_LIMIT then
		-- positive value
		dist = scr.x
	else
		-- negative value
		dist = pos - ( self._width - self._total_item_dimension )
	end

	-- print( limit, dist, pos )

	local enterFrameFunc = function( e )
		-- print( "enterFrameFunc: restore movement" )

		local delta_time = e.time - evt_tmp.time

		--== Calculation / Action

		if delta_time < TIME then
			scr.x = pos - ( delta_time/TIME ) * dist
		else
			-- final state
			scr.x = pos - dist
			self:gotoState( self.STATE_AT_REST )
		end
	end

	if self._enterFrameIterator == nil then
		Runtime:addEventListener( 'enterFrame', self )
	end
	self._enterFrameIterator = enterFrameFunc

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






return SlideView





