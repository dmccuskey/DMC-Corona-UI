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
local States = require( dmc_lib_func.find('dmc_states') )


--====================================================================--
-- Setup, Constants
--====================================================================--

-- setup some aliases to make code cleaner
local inheritsFrom = Objects.inheritsFrom
local CoronaBase = Objects.CoronaBase

local LOCAL_DEBUG = false

--====================================================================--
-- Basic Scroller
--====================================================================--

--[[
	need to create this small object so that we can
	easily set x/y offset of the scroller
	(thank you getters and setters !! =)
--]]

local BasicScroller = inheritsFrom( CoronaBase )

function BasicScroller:_init( params )
	-- print( "BasicScroller:_init" )
	self:superCall( "_init", params )
	--==--

	params = params or {}

	if params.x_offset == nil then params.x_offset = 0 end
	if params.y_offset == nil then params.y_offset = 0 end

	self._x_offset = params.x_offset
	self._y_offset = params.y_offset

end

function BasicScroller.__setters:y( value )
	-- print( "BasicScroller.__setters:y" )
	self.view.y = ( value + self._y_offset )
end
function BasicScroller.__getters:y( value )
	-- print( "BasicScroller.__getters:y" )
	return ( self.view.y - self._y_offset )
end
function BasicScroller.__setters:x_offset( value )
	-- print( "BasicScroller.__setters:x_offset" )
	self._x_offset = value
end
function BasicScroller.__setters:y_offset( value )
	-- print( "BasicScroller.__setters:y_offset" )
	self._y_offset = value
end


--====================================================================--
-- Scroller View Base Class
--====================================================================--

local ScrollerBase = inheritsFrom( CoronaBase )
ScrollerBase.NAME = "Scroller View Base Class"

States.mixin( ScrollerBase )


--== Class Constants

-- pixel amount to edges of ScrollerBase in which rows are de-/rendered
ScrollerBase.DEFAULT_RENDER_MARGIN = 100

-- flags used when scroller hits top/bottom of scroll range
ScrollerBase.HIT_TOP_LIMIT = "top_limit_hit"
ScrollerBase.HIT_BOTTOM_LIMIT = "bottom_limit_hit"

-- delta pixel amount before touch event is given up
ScrollerBase.X_TOUCH_LIMIT = 10
ScrollerBase.Y_TOUCH_LIMIT = 10


--== State Constants

ScrollerBase.STATE_CREATE = "state_create"
ScrollerBase.STATE_AT_REST = "state_at_rest"
ScrollerBase.STATE_TOUCH = "state_touch"
ScrollerBase.STATE_RESTRAINT = "state_restraint"
ScrollerBase.STATE_RESTORE = "state_restore"

ScrollerBase.STATE_RESTRAINT_TRANS_TIME = 100
ScrollerBase.STATE_RESTORE_TRANS_TIME = 500


--== Event Constants

ScrollerBase.EVENT = "scroller_view"

ScrollerBase.SLIDE_RENDER = "slide_render_event"
ScrollerBase.TAKE_FOCUS = "take_focus_event"
ScrollerBase.ITEM_SELECTED = "item_selected"




--====================================================================--
--== Start: Setup DMC Objects


function ScrollerBase:_init( params )
	-- print( "ScrollerBase:_init" )
	self:superCall( "_init", params )
	--==--

	--== Sanity Check ==--

	params = params or { }

	if params.x_offset == nil then params.x_offset = 0 end
	if params.y_offset == nil then params.y_offset = 0 end

	self._params = params -- save for later


	--== Create Properties ==--

	self._width = params.width or display.contentWidth
	self._height = params.height or display.contentHeight

	self._current_category = nil

	self._total_item_dimension = 0 -- dimension in scroll direction

	self._event_tmp = nil

	self._v_scroll_limit = nil -- type of limit, HIT_TOP_LIMIT, HIT_BOTTOM_LIMIT
	self._h_scroll_limit = nil -- type of limit, HIT_TOP_LIMIT, HIT_BOTTOM_LIMIT

	self._h_scroll_enabled = true
	self._v_scroll_enabled = true

	self._h_touch_limit = 10
	self._h_touch_lock = false
	self._v_touch_limit = 10
	self._v_touch_lock = false

	self._v_velocity = { value=0, vector=1 }
	self._h_velocity = { value=0, vector=1 }

	self._transition = nil -- handle of active transition


	--== Display Groups ==--

	self._dg_scroller = nil  -- moveable item with rows
	self._dg_gui = nil  -- fixed items over table (eg, scrollbar)


	--== Object References ==--

	self._primer = nil

	self._bg = nil

	--[[
		array of item data objects
	--]]
	self._items = nil

	--[[
		array of rendered items
	--]]
	self._rendered_items = nil

	-- used when calculating velocity
	self._touch_evt_stack = nil

	self._categories = nil -- array of category data

	self._category_view = nil

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

	local o, dg, tmp, p   -- object, display group, tmp


	-- primer

	o = display.newRect( 0,0, self._width, self._height )
	o:setFillColor( 0, 0, 0, 0 )
	if LOCAL_DEBUG then
		o:setFillColor( 0, 1, 1, 1 )
	end
	o.anchorX, o.anchorY = 0, 0
	o.x,o.y = 0, 0

	self:insert( o )
	self._primer = o

	self.anchorX, self.anchorY = 0,0

	o.x,o.y = 0, 0


	-- container for scroll items/background

	p = {
		x_offset= self._params.x_offset,
		y_offset = self._params.y_offset
	}
	dg = BasicScroller:new( p )
	self:insert( dg.view )
	self._dg_scroller = dg


	-- background

	o = display.newRect( 0, 0, self._width, self._height )
	o:setFillColor( 0, 0, 0, 0 )
	if LOCAL_DEBUG then
		o:setFillColor( 1, 0.5, 0.5, 1 )
	end
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
	self:superCall( "_initComplete" )
	--==--

	local o, f

	-- setup containers
	self._items = {}
	self._rendered_items = {}
	self._touch_evt_stack = {}

	self._dg_scroller:addEventListener( "touch", self )


	self:setState( self.STATE_CREATE )
	self:gotoState( self.STATE_AT_REST )


end

function ScrollerBase:_undoInitComplete()
	--print( "ScrollerBase:_undoInitComplete" )

	--==--
	self:superCall( "_undoInitComplete" )
end


--== END: Setup DMC Objects





--====================================================================--
--== Public Methods




function ScrollerBase:deleteAllItems()
	print( "ScrollerBase:deleteAllItems" )

	print( "IMPLMENT DELETE ALL ROWS" )

end




function ScrollerBase:takeFocus( event )
	print( "ScrollerBase:takeFocus" )

	display.getCurrentStage():setFocus( nil )

	event.phase = 'began'
	event.target = self._dg_scroller

	self._dg_scroller_f( event )

end


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
	-- print( "ScrollerBase:_findFirstVisibleItem" )

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
	local f

	--== Create View Items

	-- create view for this row
	view = display.newGroup()
	dg:insert( view )


	-- create background
	bg = display.newRect( 0, 0, self._width, row_info.height )
	bg.anchorX, bg.anchorY = 0,0
	bg:setFillColor( 1, 1, 0, 0.5 )
	bg:setStrokeColor( 0, 0, 0, 0.5 )
	bg.strokeWidth = 1
	view:insert( bg )

	bg._data = row_info

	bg:addEventListener( 'touch', self )


	-- create bottom-line


	-- save items

	row_data.view = view
	row_data.background = bg


	--== Render View

	local e ={
		name = self.EVENT,
		type = self.ROW_RENDER,

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
		name = self.EVENT,
		type = self.ROW_RENDER,

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

	if self._h_scroll_enabled then
		if scr.x > 0 then
			self._h_scroll_limit = ScrollerBase.HIT_TOP_LIMIT
		elseif scr.x <  self._width - self._total_item_dimension then
			self._h_scroll_limit = ScrollerBase.HIT_BOTTOM_LIMIT
		else
			self._h_scroll_limit = nil
		end
	end

	if self._v_scroll_enabled then
		if scr.y > 0 then
			self._v_scroll_limit = ScrollerBase.HIT_TOP_LIMIT
		elseif scr.y <  self._height - self._total_item_dimension - scr._y_offset then
			self._v_scroll_limit = ScrollerBase.HIT_BOTTOM_LIMIT
		else
			self._v_scroll_limit = nil
		end
	end

	-- print( self._h_scroll_limit, self._v_scroll_limit )
end




--======================================================--
--== START: SCROLLER BASE STATE MACHINE



function ScrollerBase:_getNextState( params )
	-- print( "ScrollerBase:_getNextState" )

	params = params or {}

	local limit = self._v_scroll_limit
	local v = self._v_velocity

	local s, p -- state, params

	if v.value <= 0 and not limit then
		s = self.STATE_AT_REST
		p = { event=params.event }

	elseif v.value > 0 and not limit then
		s = self.STATE_SCROLL
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

	if self._enterFrameIterator == nil then
		Runtime:addEventListener( 'enterFrame', self )
	end

	self._enterFrameIterator = enterFrameFunc1

	self:setState( self.STATE_TOUCH )
end


function ScrollerBase:state_touch( next_state, params )
	-- print( "ScrollerBase:state_touch: >> ", next_state )

	if next_state == self.STATE_RESTORE then
		self:do_state_restore( params )

	elseif next_state == self.STATE_RESTRAINT then
		self:do_state_restraint( params )

	elseif next_state == self.STATE_AT_REST then
		self:do_state_at_rest( params )

	elseif next_state == self.STATE_SCROLL then
		self:do_state_scroll( params )

	else
		print( "WARNING :: ScrollerBase:state_touch > " .. tostring( next_state ) )
	end

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
		self:_checkScrollBounds()
	end

end





function ScrollerBase:touch( event )
	-- print( "ScrollerBase:touch", event.phase )

	local phase = event.phase
	local x_delta, y_delta
	local LIMIT = 200

	table.insert( self._touch_evt_stack, event )

	if phase == "began" then

		self._touch_target = event.target
		local scr = self._dg_scroller

		self._v_touch_lock = false
		self._h_touch_lock = false

		-- stop any active movement

		self:gotoState( self.STATE_TOUCH )

		-- save event for movement calculations
		self._tch_event_tmp = event

		-- handle touch
		display.getCurrentStage():setFocus( scr.view, event.id )

	end


	if phase == "moved" then
		-- Utils.print( event )

		local scr = self._dg_scroller
		local h_v = self._h_velocity
		local v_v = self._v_velocity
		local h_mult, v_mult
		local d, t, s
		local x_delta, y_delta


		--== Check to see if we need to reliquish the touch

		x_delta = math.abs( event.xStart - event.x )
		if not self._v_touch_lock and x_delta > self._h_touch_limit then
			self._h_touch_lock = true
		end
		if not self._v_touch_lock and not self._h_scroll_enabled then
			if x_delta > self._h_touch_limit then
				self:_dispatchEvent( self.TAKE_FOCUS, event )
			end
		end

		y_delta = math.abs( event.yStart - event.y )
		if not self._h_touch_lock and y_delta > self._v_touch_limit then
			self._v_touch_lock = true
		end
		if not self._h_touch_lock and not self._v_scroll_enabled then
			if y_delta > self._v_touch_limit then
				self:_dispatchEvent( self.TAKE_FOCUS, event )
			end
		end

		self:_checkScrollBounds()


		--== Calculate motion multiplier

		-- horizonal
		s = 0
		if self._h_scroll_limit == self.HIT_TOP_LIMIT then
			s = scr.x
		elseif self._h_scroll_limit == self.HIT_BOTTOM_LIMIT then
			s = ( self._width - self._total_item_dimension ) - scr.x
		end
		h_mult = 1 - (s/LIMIT)

		-- vertical
		s = 0
		if self._v_scroll_limit == self.HIT_TOP_LIMIT then
			s = scr.y
		elseif self._v_scroll_limit == self.HIT_BOTTOM_LIMIT then
			s = ( self._height - self._total_item_dimension ) - scr.y
		end
		v_mult = 1 - (s/LIMIT)


		--== Move scroller

		if self._h_scroll_enabled and not self._v_touch_lock then
			x_delta = event.x - self._tch_event_tmp.x
			scr.x = scr.x + ( x_delta * h_mult )
		end

		if self._v_scroll_enabled and not self._h_touch_lock then
			y_delta = event.y - self._tch_event_tmp.y
			scr.y = scr.y + ( y_delta * v_mult )
		end


		--== The Rest

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

		if not self._h_touch_lock and not self._v_touch_lock then
			self:_dispatchEvent( self.ITEM_SELECTED, self._touch_target._data )
		end

		self._touch_target = nil

	end

	return true

end




--====================================================================--
--== Event Handlers



ScrollerBase._dispatchEvent = CoronaBase._dispatchEvent




return ScrollerBase
