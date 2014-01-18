--====================================================================--
-- scroller_view_base.lua
--
--
-- by David McCuskey
--====================================================================--

--[[

Copyright (C) 2014 David McCuskey. All Rights Reserved.

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
-- Scroller View Base Class
--====================================================================--

local ScrollerBase = inheritsFrom( CoronaBase )
ScrollerBase.NAME = "Scroller View Base Class"


--== Class Constants

-- pixel amount to edges of ScrollerBase in which rows are de-/rendered
ScrollerBase.DEFAULT_RENDER_MARGIN = 100
ScrollerBase.DEFAULT_FRICTION = 0.92
ScrollerBase.DEFAULT_MASS = 10
ScrollerBase.SPRING_CONST = 5

ScrollerBase.MARGIN = 20

ScrollerBase.TRANSITION_TIME = 350


ScrollerBase.HIT_TOP_LIMIT = "top_limit_hit"
ScrollerBase.HIT_BOTTOM_LIMIT = "bottom_limit_hit"


--== State Constants

ScrollerBase.STATE_CREATE = "state_create"
ScrollerBase.STATE_AT_REST = "state_at_rest"
ScrollerBase.STATE_TOUCH = "state_touch"
ScrollerBase.STATE_RESTRAINT = "state_restraint"
ScrollerBase.STATE_RESTORE = "state_restore"


--== Event Constants

ScrollerBase.EVENT = "slide_view_event"

ScrollerBase.SLIDE_RENDER = "slide_render_event"



--== Start: Setup DMC Objects


function ScrollerBase:_init( params )
	-- print( "ScrollerBase:_init" )
	self:superCall( "_init", params )
	--==--

	params = params or { }

	--== Create Properties ==--

	self._width = params.width or display.contentWidth
	self._height = params.height or display.contentHeight

	self._current_category = nil

	self._total_item_dimension = 0 -- dimension in scroll direction

	self._event_tmp = nil

	self._v_scroll_limit = nil -- type of limit, HIT_TOP_LIMIT, HIT_BOTTOM_LIMIT
	self._h_scroll_limit = nil -- type of limit, HIT_TOP_LIMIT, HIT_BOTTOM_LIMIT

	self._v_velocity = { value=0, vector=1 }
	self._h_velocity = { value=0, vector=1 }

	self._transition = nil -- handle of active transition

	self._mass = params.mass or self.DEFAULT_MASS
	self._friction = params.friction or self.DEFAULT_FRICTION
	self._spring = params.spring_cons or self.SPRING_CONST

	--== Display Groups ==--

	self._dg_scroller = nil  -- moveable item with rows
	self._dg_gui = nil  -- fixed items over table (eg, scrollbar)


	--== Object References ==--

	self._primer = nil

	self._bg = nil

	--[[
		array of row data
	--]]
	self._items = nil

	--[[
		array of rendered row data
	--]]
	self._rendered_items = nil

	self._touch_evt_stack = nil


	self._categories = nil -- array of category data

	self._category_view = nil
	self._inactive_dots = {}

end

function ScrollerBase:_undoInit()
	-- print( "ScrollerBase:_undoInit" )

	--==--
	self:superCall( "_undoInit" )
end



-- _createView()
--
function ScrollerBase:_createView()
	-- print( "ScrollerBase:_createView" )
	self:superCall( "_createView" )
	--==--

	local W,H = self._width, self._height
	local H_CENTER, V_CENTER = W*0.5, H*0.5

	local o, dg, tmp  -- object, display group, tmp


	-- primer

	o = display.newRect( 0,0, self._width, self._height )
	o:setFillColor( 0, 1, 1, 1 )
	o.anchorX, o.anchorY = 0, 0
	o.x,o.y = 0, 0

	self:insert( o )
	self._primer = o

	self.anchorX, self.anchorY = 0,0

	o.x,o.y = 0, 0


	-- container for scroll items/background

	dg = display.newGroup()
	self:insert( dg )
	self._dg_scroller = dg

	-- background
	o = display.newRect( 0,0, self._width, self._height )
	o:setFillColor( 0.5, 0.5, 0.5, 1 )
	o.isVisible = true

	o.anchorX, o.anchorY = 0, 0
	o.x,o.y = 0, 0

	dg:insert( o )
	self._bg = o

	dg.anchorX, dg.anchorY = 0,0
	dg.x, dg.y = 0, 0

end

function ScrollerBase:_undoCreateView()
	-- print( "ScrollerBase:_undoCreateView" )

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
function ScrollerBase:_initComplete()
	--print( "ScrollerBase:_initComplete" )

	local o, f

	-- setup containers
	self._items = {}
	self._rendered_items = {}
	self._touch_evt_stack = {}

	f = self:createCallback( self._touch_handler )
	self._dg_scroller:addEventListener( "touch", f )


	--==--
	self:superCall( "_initComplete" )
end

function ScrollerBase:_undoInitComplete()
	--print( "ScrollerBase:_undoInitComplete" )

	--==--
	self:superCall( "_undoInitComplete" )
end


--== END: Setup DMC Objects





--====================================================================--
--== Public Methods




function ScrollerBase:insertItem( item_info  )
	-- print( "ScrollerBase:insertSlide", item_info )

	local o
	local x,y

	local item_data = {
		data = item_info,

		xMin=0,
		xMax=0,
		width=0,

		yMin=0,
		yMax=0,
		height=0,

		isRendered=false,
		index=0
	}

	if not item_info.height then item_info.height = self._height end
	if not item_info.width then item_info.width = self._width end

	-- use global row render functions if not local

	if not item_info.onItemRender then item_info.onItemRender = self._onItemRender end
	if not item_info.onItemUnrender then item_info.onItemUnrender = self._onItemUnrender end


	-- category setup

	if item_info.isCategory then

		self._current_category = item_data
		table.insert( self._categories, item_data )

	else

		if self._current_category then
			item_info._category = self._current_category
		end

	end

	-- updates after change

	self:_updateDimensions( item_info, item_data )
	self:_updateDisplay()

end





--====================================================================--
--== Private Methods

function ScrollerBase:_contentBounds()
	-- print( 'ScrollerBase:_contentBounds')

	local bounds = self._primer.contentBounds
	local scr_x_offset = self._dg_scroller.x
	local scr_y_offset = self._dg_scroller.y

	-- print( self._primer.y, self._primer.height )
	local o = self._primer


	-- print( scr_x_offset )
	-- print( o.x, o.width )
	-- print( bounds.yMin, bounds.yMax )

	local MARGIN = self.DEFAULT_RENDER_MARGIN

	return {
		xMin = o.x - scr_x_offset - MARGIN,
		xMax = o.x + o.width - scr_x_offset + MARGIN,
		yMin = o.y - scr_y_offset - MARGIN,
		yMax = o.y + o.height - scr_y_offset + MARGIN,
	}

end




function ScrollerBase:_updateDisplay()
	-- print( "ScrollerBase:_updateDisplay" )

	local bounds = self:_contentBounds()

	local bounded_f = self._isBounded
	local rendered = self._rendered_items

	-- print( 'back >> ', bounds.yMin, bounds.yMax )


	local min_visible_row, max_visible_row = nil, nil
	local row

	-- check if current rows are valid
	-- print( 'checking valid rows', #self._rendered_items )

	if #rendered > 0 then
		for i = #rendered, 1, -1 do
			local data = rendered[ i ]
			local is_bounded = bounded_f( self, bounds, data )
			-- print( i, 'rendered row', data.index, is_bounded )

			if not is_bounded then self:_unRenderItem( data, { index=i } ) end

		end
	end

	-- print('after cull')
	--[[
	for i,v in ipairs( self._rendered_items ) do
		print( i, v.index )
	end
	--]]

	-- if no rows are valid, find the top one
	if #rendered == 0 then
		min_visible_row = nil
		max_visible_row = self:_findFirstVisibleItem()

		row = self:_renderItem( max_visible_row, { head=true } )

	else

		min_visible_row = rendered[1]
		max_visible_row = rendered[ #rendered ]

		-- print( 'row', min_visible_row.index )
		-- print( #self._rendered_items, max_visible_row.index )

	end

	if min_visible_row then
		-- search up until off screen

		local row_data, index
		index = min_visible_row.index - 1
		-- print( 'searching up from index', index )
		if index >= 1 then

			for i = index, 1, -1 do
				row_data = self._items[ i ]
				local is_bounded = bounded_f( self, bounds, row_data )

				if not is_bounded then
					-- print( 'not bounded breaking' )
					break
				end

				self:_renderItem( row_data, { head=true  }   )

			end

		end



	end


	if max_visible_row then
		-- search down until off screen

		local is_bounded
		local row_data, index
		index = max_visible_row.index + 1

		-- print( 'searching down from index', index )

		if index <= #self._items then

			for i = index, #self._items do
				row_data = self._items[ i ]
				if not row_data then print("no row data!!") ; break end
				is_bounded = bounded_f( self, bounds, row_data )

				if not is_bounded then
					-- print( 'not bounded breaking' )
					break
				end

				self:_renderItem( row_data, { head=false } )

			end  -- for
		end -- if

	end -- if max_visible_row


end


function ScrollerBase:_findFirstVisibleItem()
	print( "ScrollerBase:_findFirstVisibleItem" )

	return self._items[1]
end





--[[

un-/render row event


local e = {}
e.name = "ScrollerBase_rowRender"
e.type = "unrender"
e.parent = self	-- ScrollerBase that this row belongs to
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


function ScrollerBase:_renderItem( row_data, options )
	-- print( "ScrollerBase:_renderItem", row_data, row_data.index )

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
		name = ScrollerBase.EVENT,
		type = ScrollerBase.ROW_RENDER,

		parent = self,
		target = row_info,
		row = row_info,
		view = view,
		background = bg,
		line = line,
		data = row_info.data,
		index = row_data.index,
	}
	row_info.onItemRender( e )


	--== Update Row

	-- print( 'render ', row_data.yMin, row_data.yMax )
	view.x, view.y = row_data.xMin, row_data.yMin

	local idx = 1
	if options.head == false then idx = #self._rendered_items+1 end

	-- print( 'insert', #self._rendered_items, idx )
	table.insert( self._rendered_items, idx, row_data )

end



function ScrollerBase:_unRenderItem( item_data, options )
	-- print( "ScrollerBase:_unRenderItem", item_data.index )

	-- Utils.print( item_data )

	-- if no item view then no need to unrender
	if not item_data.view then return end

	local dg = self._dg_scroller
	local row_info = item_data.data

	local view, bg, line


	--== Remove Rendered Item

	view = item_data.view
	bg = item_data.background

	table.remove( self._rendered_items, options.index )

	local e ={
		name = ScrollerBase.EVENT,
		type = ScrollerBase.ROW_RENDER,

		parent = self,
		target = row_info,
		row = row_info,
		view = view,
		background = bg,
		line = line,
		data = row_info.data,
		index = item_data.index,
	}
	row_info.onItemUnrender( e )


	bg = item_data.background
	bg:removeSelf()
	item_data.background = nil

	view = item_data.view
	view:removeSelf()
	item_data.view = nil

end


function ScrollerBase:_checkScrollBounds()
	-- print( 'ScrollerBase:_checkScrollBounds' )

	local scr = self._dg_scroller
	-- print( "scr.y, ", scr.y , (self._height - self._total_item_dimension) )

	if self._horizontal_scroll_enabled then
		if scr.x > 0 then
			self._h_scroll_limit = ScrollerBase.HIT_TOP_LIMIT
		elseif scr.x <  self._width - self._total_item_dimension then
			self._h_scroll_limit = ScrollerBase.HIT_BOTTOM_LIMIT
		else
			self._h_scroll_limit = nil
		end
	end

	if self._vertical_scroll_enabled then
		if scr.y > 0 then
			self._v_scroll_limit = ScrollerBase.HIT_TOP_LIMIT
		elseif scr.y <  self._height - self._total_item_dimension then
			self._v_scroll_limit = ScrollerBase.HIT_BOTTOM_LIMIT
		else
			self._v_scroll_limit = nil
		end
	end

	-- print( self._h_scroll_limit, self._v_scroll_limit )
end




--======================================================--
--== START: SCROLLER BASE STATE MACHINE


function ScrollerBase:_getNextState()

	error( "override _getNextState" )
	local state, params

	return state, params
end



-- state_create()
--
function ScrollerBase:state_create( next_state, params )
	-- print( "ScrollerBase:state_create: >> ", next_state )

	if next_state == self.STATE_AT_REST then
		self:do_state_at_rest( params )

	else
		print( "WARNING :: ScrollerBase:state_create > " .. tostring( next_state ) )
	end
end



function ScrollerBase:do_state_at_rest( params )
	-- print( "ScrollerBase:do_state_at_rest" )

	params = params or {}

	local h_v, v_v = self._h_velocity, self._v_velocity

	h_v.value, h_v.vector = 0, 1
	v_v.value, v_v.vector = 0, 1

	self._enterFrameIterator = nil
	Runtime:removeEventListener( 'enterFrame', self )

	self:setState( self.STATE_AT_REST )
end

function ScrollerBase:state_at_rest( next_state, params )
	-- print( "ScrollerBase:state_at_rest: >> ", next_state )

	if next_state == self.STATE_TOUCH then
		self:do_state_touch( params )

	else
		print( "WARNING :: ScrollerBase:state_at_rest > " .. tostring( next_state ) )
	end

end




function ScrollerBase:do_state_touch( params )
	-- print( "ScrollerBase:do_state_touch" )

	params = params or {}

	local VEL_STACK_LENGTH = 4 -- number of items to use for velocity calculation

	local h_v, v_v = self._h_velocity, self._v_velocity
	local vel_stack = {}

	local evt_tmp = nil
	local last_tevt = nil

	local enterFrameFunc1, enterFrameFunc2


	-- work to do after first event
	--
	enterFrameFunc2 = function( e )
		-- print( "enterFrameFunc: enterFrameFunc2" )

		local te_stack = self._touch_evt_stack
		local num_evts = #te_stack

		local x_delta, y_delta, t_delta


		--== process incoming touch events

		if num_evts == 0 then
			table.insert( vel_stack, 1, { 0, 0 }  )

		else
			t_delta = ( e.time-evt_tmp.time ) / num_evts

			for i, tevt in ipairs( te_stack ) do
				x_delta = tevt.x - last_tevt.x
				y_delta = tevt.y - last_tevt.y

				-- print( "events >> ", i, ( x_delta/t_delta ), ( y_delta/t_delta ) )
				table.insert( vel_stack, 1, { ( x_delta/t_delta ), ( y_delta/t_delta ) }  )

				last_tevt = tevt
			end

		end

		self._touch_evt_stack = {}



		--== do calculations
		-- calculate average velocity and clean off
		-- velocity stack at same time

		local h_v_ave, v_v_ave = 0, 0
		local vel

		for i = #vel_stack, 1, -1 do
			if i > VEL_STACK_LENGTH then
				table.remove( vel_stack, i )
			else
				vel = vel_stack[i]
				h_v_ave = h_v_ave + vel[1]
				v_v_ave = v_v_ave + vel[2]
				-- print(i, vel, vel[1], vel[2] )
			end
		end
		h_v_ave = h_v_ave / #vel_stack
		v_v_ave = v_v_ave / #vel_stack
		-- print( h_v_ave, v_v_ave )

		v_v.value = math.abs( v_v_ave )
		v_v.vector = 1
		if v_v_ave < 0 then v_v.vector = -1 end

		h_v.value = math.abs( h_v_ave )
		h_v.vector = 1
		if h_v_ave < 0 then h_v.vector = -1 end


		--== prep for next frame

		self._touch_evt_stack = {}
		evt_tmp = e

	end


	-- this is only for the first enterFrame on a touch event
	-- only have one touch event, so can't calculate velocity
	--
	enterFrameFunc1 = function( e )
		-- print( "enterFrameFunc: enterFrameFunc1" )

		v_v.value, v_v.vector = 0, 1
		h_v.value, h_v.vector = 0, 1

		last_tevt = table.remove( self._touch_evt_stack, 1 )
		self._touch_evt_stack = {}

		evt_tmp = e

		-- switch to other iterator
		self._enterFrameIterator = enterFrameFunc2
	end


	self._enterFrameIterator = enterFrameFunc1
	Runtime:addEventListener( 'enterFrame', self )

	self:setState( self.STATE_TOUCH )
end

function ScrollerBase:state_touch( next_state, params )
	print( "ScrollerBase:state_touch: >> ", next_state )

end


--== END: SCROLLER BASE STATE MACHINE
--======================================================--





function ScrollerBase:enterFrame( event )
	-- print( 'ScrollerBase:enterFrame' )

	local f = self._enterFrameIterator

	if not f then
		Runtime:removeEventListener( 'enterFrame', self )
	else
		f( event )
		self._event_tmp = event
		self:_updateDisplay()
	end

end





function ScrollerBase:_touch_handler( event )
	-- print( "ScrollerBase:_touch_handler", event.phase )

	local phase = event.phase
	local x_delta, y_delta
	local LIMIT = 200

	table.insert( self._touch_evt_stack, event )

	if phase == "began" then

		-- stop any active movement

		self:gotoState( self.STATE_TOUCH )

		-- save event for movement calculations
		self._tch_event_tmp = event

		-- handle touch
		display.getCurrentStage():setFocus( self._dg_scroller, event.id )

	end


	if phase == "moved" then
		-- Utils.print( event )

		local scr = self._dg_scroller
		local h_v = self._h_velocity
		local v_v = self._v_velocity
		local h_mult, v_mult
		local d, t, s

		self:_checkScrollBounds()

		s = 0
		if self._h_scroll_limit == self.HIT_TOP_LIMIT then
			s = scr.x
		elseif self._h_scroll_limit == self.HIT_BOTTOM_LIMIT then
			s = ( self._width - self._total_item_dimension ) - scr.x
		end
		h_mult = 1 - (s/LIMIT)

		s = 0
		if self._v_scroll_limit == self.HIT_TOP_LIMIT then
			s = scr.y
		elseif self._v_scroll_limit == self.HIT_BOTTOM_LIMIT then
			s = ( self._height - self._total_item_dimension ) - scr.y
		end
		v_mult = 1 - (s/LIMIT )

		-- move scroller

		if self._horizontal_scroll_enabled then
			x_delta = event.x - self._tch_event_tmp.x
			scr.x = scr.x + ( x_delta * h_mult )
		end

		if self._vertical_scroll_enabled then
			y_delta = event.y - self._tch_event_tmp.y
			scr.y = scr.y + ( y_delta * v_mult )
		end


		self:_updateDisplay()

		-- save event for movement calculation
		self._tch_event_tmp = event
	end


	if "ended" == phase or "cancelled" == phase then

		-- validate our location
		self:_checkScrollBounds()

		-- clean up
		display.getCurrentStage():setFocus( nil, event.id )


		-- add system time, we can re-use this event for Runtime
		self._tch_event_tmp = event
		-- event.time = system.getTimer()


		local next_state, next_params = self:_getNextState( { event=event } )
		self:gotoState( next_state, next_params )

	end

	return true

end





-- function  SlideView:_trans_not_v_not_l()

-- 	local v = self._h_velocity

-- 	local f = function( e )
-- 		-- print( "in _trans_not_v_not_l" )

-- 		v.value = 0
-- 		v.vector = 1

-- 		self._enterFrameIterator = nil
-- 	end

-- 	return f

-- end


-- function  SlideView:_trans_v_not_l()
-- 	-- print( "SlideView:_trans_v_not_l" )

-- 	local scr = self._dg_scroller
-- 	local v = self._h_velocity
-- 	local M, F = 3, 0.871


-- 	local f = function( e )
-- 		-- print( "in _trans_v_not_l" )

-- 		local evt_tmp = self._event_tmp

-- 		local delta_time = e.time - evt_tmp.time

-- 		local x_delta

-- 		-- adjust for friction
-- 		-- F=ma, v=Fmt
-- 		V = F * M * (delta_time/1000)
-- 		v.value = v.value - V

-- 		-- adjust for kinetic energy
-- 		-- .5 * m * v^2   or
-- 		-- v.value = v.value - 0

-- 		-- check if to switch to another
-- 		if v.value <= 0 or self._h_scroll_limit then
-- 			self:_getEnterFrameTransition( event )

-- 		else
-- 			x_delta = v.value * delta_time
-- 			if x_delta > 100 then x_delta = 100 end -- clamp speed
-- 			scr.x = scr.x + ( x_delta * v.vector )

-- 		end

-- 	end

-- 	return f
-- end





--====================================================================--
--== Event Handlers





-- _dispatchEvent
--
function ScrollerBase:_dispatchEvent( e_type, data )
--print( "ScrollerBase:_dispatchEvent ", e_type )

	params = params or {}

	-- setup custom event
	local e = {
		name = ScrollerBase.EVENT,
		type = e_type,
		data = data
	}

	self:dispatchEvent( e )
end





return ScrollerBase





