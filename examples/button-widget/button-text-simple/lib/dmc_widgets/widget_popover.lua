--====================================================================--
-- dmc_widgets/widget_popover.lua
--
-- Documentation: http://docs.davidmccuskey.com/
--====================================================================--

--[[

The MIT License (MIT)

Copyright (c) 2014-2015 David McCuskey

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
--== DMC Corona Widgets : Popover
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
--== DMC Widgets : newPopover
--====================================================================--



--====================================================================--
--== Imports


local Objects = require 'dmc_objects'
local Utils = require 'dmc_utils'

local Widgets -- set later



--====================================================================--
--== Setup, Constants


-- setup some aliases to make code cleaner
local newClass = Objects.newClass
local ComponentBase = Objects.ComponentBase

local LOCAL_DEBUG = true



--====================================================================--
--== Popover Widget Class
--====================================================================--


local Popover = newClass( ComponentBase, {name="Popover"} )


--======================================================--
-- Start: Setup DMC Objects

function Popover:__init__( params )
	-- print( "Popover:__init__" )
	params = params or {}
	self:superCall( '__init__', params )
	--==--

	--== Sanity Check ==--

	if self.is_class then return end

	assert( params.delegate, "Popover: requires param 'delegate'" )

	--== Create Properties ==--

	self._width = params.delegate.width
	self._height = params.delegate.height

	-- we don't move our core group
	-- so we save x/y separately
	self._x = 0
	self._y = 0

	-- this is the position of the activating button
	self._x_pos = params.x_pos
	self._y_pos = params.y_pos

	--== Display Groups ==--

	-- group for popover background elements
	self._dg_bg = nil

	-- group for all main elements
	self._dg_main = nil

	--== Object References ==--

	self._delegate = params.delegate

	-- visual
	self._bg_touch = nil  -- main touch background
	self._bg_main = nil  -- main visual background
	self._pointer = nil -- pointer element

end

--[[
function Popover:_undoInit()
	-- print( "Popover:_undoInit" )
	--==--
	self:superCall( "_undoInit" )
end
--]]


-- __createView__()
--
function Popover:__createView__()
	-- print( "Popover:__createView__" )
	self:superCall( '__createView__' )
	--==--
	local WIDTH, HEIGHT = Widgets.WIDTH, Widgets.HEIGHT
	local W,H = self._width, self._height
	local H_CENTER, V_CENTER = W*0.5, H*0.5

	local o, dg, tmp  -- object, display group, tmp

	--== setup background

	o = display.newRect(0, 0, WIDTH, HEIGHT)
	o:setFillColor(0,0,0,0)
	if LOCAL_DEBUG then
		o:setFillColor(1,0,0,0.5)
	end
	o.isHitTestable = true
	o.anchorX, o.anchorY = 0,0
	o.x, o.y = 0,0

	self.view:insert( o ) -- using view because of override
	self._bg_touch = o

	-- background group

	dg = display.newGroup()
	self.view:insert( dg ) -- using view because of override
	self._dg_bg = dg

	-- main group

	dg = display.newGroup()
	self.view:insert( dg )
	self._dg_main = dg

	-- delegate view

	dg = self._dg_bg
	dg:insert( self._delegate.view )

	-- viewable background

	dg = self._dg_bg
	o = display.newRect(0, 0, W, H)
	o:setFillColor(1,1,1,0.8)
	if LOCAL_DEBUG then
		o:setFillColor(0,1,0,0.5)
	end
	o.anchorX, o.anchorY = 0.5,0
	o.x, o.y = 0,0

	dg:insert( o )
	self._bg_main = o

end

--[[
function Popover:__undoCreateView__()
	-- print( "Popover:__undoCreateView__" )
	--==--
	self:superCall( '__undoCreateView__' )
end
--]]


-- __initComplete__()
--
function Popover:__initComplete__()
	--print( "Popover:__initComplete__" )
	self:superCall( '__initComplete__' )
	--==--
	local o
	o = self._bg_touch
	o._f = self:createCallback( self._bgTouchEvent_handler )
	o:addEventListener( 'touch', o._f )
end

function Popover:__undoInitComplete__()
	--print( "Popover:__undoInitComplete__" )
	local o
	o = self._bg_touch
	o:removeEventListener( 'touch', o._f )
	o._f = nil
	--==--
	self:superCall( '__undoInitComplete__' )
end

-- END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Static Methods


function Popover.__setWidgetManager( manager )
	-- print( "Popover.__setWidgetManager" )
	Widgets = manager
end



--====================================================================--
--== Public Methods


-- -- we only want items inserted into proper layer
-- function Popover.__setters:delegate( obj )
-- 	-- print( "Popover.__setters:delegate" )
-- 	self._dg_main:insert( obj.view )
-- 	self._delegate = obj
-- end


-- we only want items inserted into proper layer
function Popover:insert( ... )
	-- print( "Popover:insert" )
	self._dg_main:insert( ... )
end

function Popover:show( pos, params )
	-- print( "Popover:show" )
	assert( pos.x and pos.y )
	--==--
	self.x, self.y = pos.x, pos.y
	self.view.isVisible = true
	self._bg_touch.isHitTestable = true
end
function Popover:hide()
	-- print( "Popover:hide" )
	local d = self._delegate
	self.view.isVisible = false
	self._bg_touch.isHitTestable = false
	if d and d.isDismissed then
		timer.performWithDelay( 1, function() d:isDismissed() end)
	end
end

function Popover.__getters:x( )
	-- print( "Popover.__getters x'" )
	return self._x
end
function Popover.__setters:x( value )
	-- print( "Popover.__settersx x'", value )
	assert( type(value)=='number' )
	--==--
	self._dg_bg.x = value
	self._dg_main.x = value
	self._x = value
end
function Popover.__getters:y( )
	-- print( "Popover.__getters y '" )
	return self._y
end
function Popover.__setters:y( value )
	-- print( "Popover.__setters y'", value )
	assert( type(value)=='number' )
	--==--
	self._dg_bg.y = value
	self._dg_main.y = value
	self._y = value
end

function Popover.__setters:onDone( func )
	assert( func==nil or type(func)=='function' )
	--==--
	self._onDone = func
end
function Popover.__setters:onCancel( func )
	assert( func==nil or type(func)=='function' )
	--==--
	self._onCancel = func
end



--====================================================================--
--== Private Methods


function Popover:_shouldDismiss()
	return true
end

-- TODO: make fancier
function Popover:_calculatePosition()
	local _x, _y = self._x_pos, self._y_pos

	self.x, self.y = _x, _y
end



--====================================================================--
--== Event Handlers


function Popover:_bgTouchEvent_handler( event )
	-- print( "Popover:_bgTouchEvent_handler", event.phase )
	local target = event.target

	if event.phase == 'began' then
		display.getCurrentStage():setFocus( target )
		self._has_focus = true
		return true
	end

	if not self._has_focus then return false end

	if event.phase == 'ended' or event.phase == 'canceled' then
		display.getCurrentStage():setFocus( nil )
		self._has_focus = false

		local dismiss_f = self._shouldDismiss
		local d = self._delegate
		if d and d.shouldDismiss then
			dismiss_f = d.shouldDismiss
		end
		if dismiss_f() then self:hide() end
	end

	return true
end




return Popover
