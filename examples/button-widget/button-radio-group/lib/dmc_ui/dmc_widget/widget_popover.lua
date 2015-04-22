--====================================================================--
-- dmc_widget/widget_popover.lua
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

local PopoverView = require( dmc_widget_func.find( 'widget_popover.popover_view' ) )

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

--== Init

function Popover:__init__( params )
	-- print( "Popover:__init__" )
	params = params or {}
	if params.automask==nil then params.automask=true end
	self:superCall( '__init__', params )
	--==--

	--== Sanity Check ==--

	if self.is_class then return end

	assert( params.delegate, "Popover: requires param 'delegate'" )

	--== Create Properties ==--
	self._width = Widgets.WIDTH
	self._height = Widgets.HEIGHT

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
	self._popover_view = nil

	-- visual
	self._bg_touch = nil  -- main touch background
end

function Popover:__undoInit__()
	-- print( "Popover:__undoInit__" )
	self._delegate = nil
	--==--
	self:superCall( '__undoInit__' )
end


--== createView

function Popover:__createView__()
	-- print( "Popover:__createView__" )
	self:superCall( '__createView__' )
	--==--
	local W,H = self._width, self._height
	local H_CENTER, V_CENTER = W*0.5, H*0.5

	local o, dg, tmp  -- object, display group, tmp

	--== setup background

	o = display.newRect(0, 0, W, H )
	o:setFillColor(0,0,0,0)
	if LOCAL_DEBUG then
		o:setFillColor(0.5,0.25,0.5,0.25)
	end
	o.isHitTestable = true
	o.anchorX, o.anchorY = 0,0
	o.x, o.y = 0,0

	self:insert( o ) -- using view because of override
	self._bg_touch = o

	o = PopoverView:new{
		delegate=self._delegate
	}
	self:insert( o.view )
	self._popover_view = o
end

function Popover:__undoCreateView__()
	-- print( "Popover:__undoCreateView__" )
	self._popover_view:removeSelf()
	self._popover_view = nil

	self._bg_touch:removeSelf()
	self._bg_touch = nil
	--==--
	self:superCall( '__undoCreateView__' )
end


--== initComplete

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
	PopoverView.__setWidgetManager( manager )
end



--====================================================================--
--== Public Methods


function Popover:show( pos, params )
	-- print( "Popover:show" )
	assert( pos.x and pos.y )
	--==--
	self.isVisible = true
	self._bg_touch.isHitTestable = true
	self._popover_view:show( pos, params )
end

function Popover:hide()
	-- print( "Popover:hide" )
	self.isVisible = false
	self._bg_touch.isHitTestable = false
	self._popover_view:hide()
end


function Popover.__getters:x( )
	-- print( "Popover.__getters x'" )
	return self._popover_view.x
end

function Popover.__setters:x( value )
	-- print( "Popover.__setters:x", value )
	assert( type(value)=='number' )
	--==--
	self._popover_view.x = value
end


function Popover.__getters:y( )
	-- print( "Popover.__getters y '" )
	return self._popover_view.y
end

function Popover.__setters:y( value )
	-- print( "Popover.__setters:y", value )
	assert( type(value)=='number' )
	--==--
	self._popover_view.y = value
end



--====================================================================--
--== Private Methods


-- none



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

		if self._popover_view:shouldDismiss() then
			self:hide()
		end
	end

	return true
end




return Popover
