--====================================================================--
-- dmc_widgets/widget_navbar.lua
--
-- Documentation: http://docs.davidmccuskey.com/
--====================================================================--

--[[

The MIT License (MIT)

Copyright (c) 2015 David McCuskey

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
--== DMC Corona Widgets : Widget Nav Bar
--====================================================================--


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.1.0"



--====================================================================--
--== DMC Widgets Setup
--====================================================================--


local dmc_widget_data, dmc_widget_func
dmc_widget_data = _G.__dmc_widget
dmc_widget_func = dmc_widget_data.func



--====================================================================--
--== DMC Widgets : newNavBar
--====================================================================--



--====================================================================--
--== Imports


local Objects = require 'dmc_objects'

--== Components

local Widgets -- set later
local NavItem -- set later



--====================================================================--
--== Setup, Constants


-- setup some aliases to make code cleaner
local newClass = Objects.newClass
local ComponentBase = Objects.ComponentBase

local tinsert = table.insert
local tremove = table.remove

local LOCAL_DEBUG = false



--====================================================================--
--== Nav Bar Widget Class
--====================================================================--


local NavBar = newClass( ComponentBase, {name="Nav Bar"}  )

--== Class Constants

NavBar.HEIGHT = 40
NavBar.MARGINS = {x=5,y=0}

NavBar.FORWARD = 'forward-trans'
NavBar.REVERSE = 'reverse-trans'
NavBar.TRANSITION_TIME = 400


--== Event Constants

NavBar.EVENT = 'button-event'


--======================================================--
-- Start: Setup DMC Objects

function NavBar:__init__( params )
	-- print( "NavBar:__init__" )
	params = params or {}
	if params.height==nil then params.height=NavBar.HEIGHT end
	if params.transition_time==nil then params.transition_time=NavBar.TRANSITION_TIME end
	self:superCall( '__init__', params )
	--==--

	--== Sanity Check ==--

	if self.is_class then return end

	assert( params.width, "NavBar: requires param 'width'" )

	--== Create Properties ==--

	self._width = params.width
	self._height = params.height

	self._trans_time = params.transition_time

	self._items = {} -- stack of nav items

	--== Object References ==--

	self._nav_controller = nil -- dmc navigator

	self._root_item = nil
	self._back_item = nil
	self._top_item = nil
	self._new_item = nil

	self._bg_touch = nil

end

function NavBar:__undoInit__()
	-- print( "NavBar:__undoInit__" )
	self._root_item = nil
	self._back_item = nil
	self._top_item = nil
	self._new_item = nil
	--==--
	self:superCall( '__undoInit__' )
end


-- __createView__()
--
function NavBar:__createView__()
	-- print( "NavBar:__createView__" )
	self:superCall( '__createView__' )
	--==--
	local W,H = self._width, self._height
	-- local H_CENTER, V_CENTER = W*0.5, H*0.5

	local o

	-- setup background

	o = display.newRect(0, 0, W, H)
	o:setFillColor(1,1,1,1)
	if LOCAL_DEBUG then
		o:setFillColor(1,0,0,0.5)
	end
	o.isHitTestable = true
	o.anchorX, o.anchorY = 0.5,0
	o.x, o.y = 0,0

	self.view:insert( o ) -- using view because of override
	self._bg_touch = o
end

function NavBar:__undoCreateView__()
	-- print( "NavBar:__undoCreateView__" )
	local o

	o = self._bg_touch
	o:removeSelf()
	self._bg_touch = nil

	--==--
	self:superCall( '__undoCreateView__' )
end


--== initComplete

function NavBar:__initComplete__()
	--print( "NavBar:__initComplete__" )
	self:superCall( '__initComplete__' )
	--==--
	self:setTouchBlock( self._bg_touch )
end

function NavBar:__undoInitComplete__()
	--print( "NavBar:__undoInitComplete__" )
	self:unsetTouchBlock( self._bg_touch )
	--==--
	self:superCall( '__undoInitComplete__' )
end

-- END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Static Methods


function NavBar.__setWidgetManager( manager )
	-- print( "NavBar.__setWidgetManager" )
	Widgets = manager
	NavItem = manager.NavItem
end



--====================================================================--
--== Public Methods


-- setter: set background color of table view
--
function NavBar.__setters:bg_color( color )
	-- print( "NavBar.__setters:bg_color", color )
	assert( type(color)=='table', "color must be a table of values" )
	self._bg_touch:setFillColor( unpack( color ) )
end

function NavBar.__setters:controller( obj )
	-- print( "NavBar.__setters:controller", obj )
	-- assert( type(color)=='table', "color must be a table of values" )
	self._nav_controller = obj
end


function NavBar:pushNavItem( item, params )
	-- print( "NavBar:pushNavItem", item )
	params = params or {}
	assert( type(item)=='table' and item.isa and item:isa( NavItem ), "pushNavItem: item must be a NavItem" )
	--==--
	self:_setNextItem( item, params )
	self:_gotoNext( params.animate )
end


function NavBar:popNavItemAnimated()
	-- print( "NavBar:popNavItemAnimated" )
	self:_gotoPrev( true )
end



--====================================================================--
--== Private Methods


-- private method used by dmc-navigator
--
function NavBar:_pushNavItemGetTransition( item, params )
	self:_setNextItem( item, params )
	return self:_getNextTrans()
end

-- private method used by dmc-navigator
--
function NavBar:_popNavItemGetTransition()
	return self:_getPrevTrans()
end


function NavBar:_setNextItem( item, params )
	params = params or {}
	if params.animate==nil then params.animate=true end
	--==--
	if self._root_item then
		-- pass
	else
		self._root_item = item
		self._top_item = nil
		params.animate = false
	end
	self._new_item = item
end


function NavBar:_addToView( item )
	-- print( "NavBar:_addToView", item )
	local W, H = self._width, self._height
	local H_CENTER, V_CENTER = W*0.5, H*0.5

	local back, left, right = item.back_button, item.left_button, item.right_button
	local title = item.title

	if back then
		self:insert( back.view )
		back.y = V_CENTER
		back.isVisible=false
	end
	if left then
		self:insert( left.view )
		left.y = V_CENTER
		left.isVisible=false
	end
	if title then
		self:insert( title.view )
		title.y = V_CENTER
		title.isVisible=false
	end
	if right then
		self:insert( right.view )
		right.y = V_CENTER
		right.isVisible=false
	end

end

function NavBar:_removeFromView( item )
	-- print( "NavBar:_removeFromView", item )
	if item.removeSelf then item:removeSelf() end
end


function NavBar:_startEnterFrame( func )
	Runtime:addEventListener( 'enterFrame', func )
end

function NavBar:_stopEnterFrame( func )
	Runtime:removeEventListener( 'enterFrame', func )
end


function NavBar:_startReverse( func )
	local start_time = system.getTimer()
	local duration = self.TRANSITION_TIME
	local rev_f

	rev_f = function(e)
		local delta_t = e.time-start_time
		local perc = 100-(delta_t/duration*100)
		if perc < 0 then
			perc = 0
			self:_stopEnterFrame( rev_f )
		end
		func( perc )
	end
	self:_startEnterFrame( rev_f )
end

function NavBar:_startForward( func )
	local start_time = system.getTimer()
	local duration = self.TRANSITION_TIME
	local frw_f

	frw_f = function(e)
		local delta_t = e.time-start_time
		local perc = delta_t/duration*100
		if perc > 100 then
			perc = 100
			self:_stopEnterFrame( frw_f )
		end
		func( perc )
	end
	self:_startEnterFrame( frw_f )
end


-- can be retreived by another object (ie, NavBar)
function NavBar:_getNextTrans()
	-- print( "NavBar:_getNextTrans" )
	return self:_getTransition( self._top_item, self._new_item, self.FORWARD )
end

function NavBar:_gotoNext( animate )
	-- print( "NavBar:_gotoNext" )
	local func = self:_getNextTrans()
	if not animate then
		func(100)
	else
		self:_startForward( func )
	end
end


-- can be retreived by another object (ie, NavBar)
function NavBar:_getPrevTrans()
	-- print( "NavBar:_getPrevTrans" )
	return self:_getTransition( self._back_item, self._top_item, self.REVERSE )
end

function NavBar:_gotoPrev( animate )
	-- print( "NavBar:_gotoPrev" )
	local func = self:_getPrevTrans()
	if not animate then
		func( 0 )
	else
		self:_startReverse( func )
	end
end


function NavBar:_getTransition( from_item, to_item, direction )
	-- print( "NavBar:_getTransition", from_item, to_item, direction )
	local W, H = self._width, self._height
	local H_CENTER, V_CENTER = W*0.5, H*0.5
	local MARGINS = self.MARGINS

	-- display(left/back), back, left, title, right
	local f_d, f_b, f_l, f_t, f_r
	local t_d, t_b, t_l, t_t, t_r
	local callback

	-- setup from_item vars
	if from_item then
		f_b, f_l, f_r = from_item.back_button, from_item.left_button, from_item.right_button
		f_t = from_item.title
		f_d = f_b
		if f_l then
			f_b.isVisible = false
			f_d = f_l
		end
	end

	-- setup to_item vars
	if to_item then
		t_b, t_l, t_r = to_item.back_button, to_item.left_button, to_item.right_button
		t_t = to_item.title
		t_d = t_b
		if t_l then
			t_b.isVisible=false
			t_d = t_l
		end
	end

	-- calcs for showing left/back buttons
	local stack_offset = 0
	if direction==self.FORWARD then
		self:_addToView( to_item )
		stack_offset = 0
	else
		stack_offset = 1
	end

	local stack, stack_size = self._items, #self._items

	callback = function( percent )
		-- print( "NavBar:transition", percent )
		local dec_p = percent/100
		local from_a, to_a = 1-dec_p, dec_p
		local X_OFF = H_CENTER*dec_p

		if percent==0 then
			--== edge of transition ==--

			--== Finish up

			if direction==self.REVERSE then
				local item = tremove( stack )
				self:_removeFromView( item )

				self._top_item = from_item
				self._new_item = nil
				self._back_item = stack[ #stack-1 ] -- get previous
			end

			--== Left/Back

			if t_d then
				t_d.isVisible = false
			end

			if f_l or #self._items>1 then
				f_d.isVisible = true
				f_d.x = -H_CENTER+f_d.width/2+MARGINS.x
				f_d.alpha = 1
			else
				f_d.isVisible = false
			end

			--== Title

			if t_t then
				t_t.isVisible = false
			end

			if f_t then
				f_t.isVisible = true
				f_t.x = 0
				f_t.alpha = 1
			end

			--== Right

			if t_r then
				t_r.isVisible = false
			end

			if f_r then
				f_r.isVisible = true
				f_r.x = H_CENTER
				f_r.alpha = 1
			end


		elseif percent==100 then
			--== edge of transition ==--

			--== Left/Back

			-- checking if Left exists or Stack, still use t_d
			if t_l or stack_size>0 then
				t_d.x = -H_CENTER+t_d.width/2+MARGINS.x
				t_d.isVisible = true
				t_d.alpha = 1
			else
				t_d.isVisible = false
			end

			if f_d then
				f_d.isVisible = false
			end

			--== Title

			if t_t then
				t_t.x = 0
				t_t.isVisible = true
				t_t.alpha = 1
			end

			if f_t then
				f_t.isVisible = false
			end

			--== Right

			if t_r then
				t_r.x = H_CENTER
				t_r.isVisible = true
				t_r.alpha = 1
			end

			if f_r then
				f_r.isVisible = false
			end

			--== Finish up

			if direction==self.FORWARD then
				self._back_item = from_item
				self._new_item = nil
				self._top_item = to_item

				tinsert( self._items, to_item )
			end

		else
			--== middle of transition ==--

			--== Left/Back

			if t_l or stack_size>(0+stack_offset) then
				t_d.isVisible = true
				t_d.x = -X_OFF+t_d.width/2+MARGINS.x
				t_d.alpha = to_a
			else
				t_d.isVisible = false
			end

			if f_l or stack_size>(1+stack_offset) then
				f_d.isVisible = true
				f_d.x = -H_CENTER-X_OFF+f_d.width/2+MARGINS.x
				f_d.alpha = from_a
			else
				f_d.isVisible = false
			end

			--== Title

			if t_t then
				t_t.isVisible = true
				-- t_t.x, t_t.y = H_CENTER-X_OFF, V_CENTER
				t_t.x = H_CENTER-X_OFF
				t_t.alpha = to_a
			end
			if f_t then
				f_t.isVisible = true
				f_t.x = 0-X_OFF
				f_t.alpha = from_a
			end

			--== Right

			if t_r then
				t_r.isVisible = true
				t_r.x = W-X_OFF
				t_r.alpha = to_a
			end

			if f_r then
				f_r.isVisible = true
				f_r.x = H_CENTER-X_OFF
				f_r.alpha = from_a
			end

		end
	end

	return callback
end



--====================================================================--
--== Event Handlers


-- none




return NavBar
