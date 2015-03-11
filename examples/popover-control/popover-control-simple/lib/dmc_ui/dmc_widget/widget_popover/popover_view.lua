--====================================================================--
-- dmc_widget/widget_popover/popover_view.lua
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
--== DMC Corona Widgets : PopoverView
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
--== DMC Widgets : newPopoverView
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

local LOCAL_DEBUG = false



--====================================================================--
--== PopoverView Widget Class
--====================================================================--


local PopoverView = newClass( ComponentBase, {name="PopoverView"} )


--======================================================--
-- Start: Setup DMC Objects

--== init

function PopoverView:__init__( params )
	-- print( "PopoverView:__init__" )
	params = params or {}
	if params.automask==nil then params.automask=true end
	self:superCall( '__init__', params )
	--==--

	--== Sanity Check ==--

	if self.is_class then return end

	assert( params.delegate, "PopoverView: requires param 'delegate'" )

	--== Create Properties ==--

	self._width = params.delegate.width
	self._height = params.delegate.height

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
	self._bg_main = nil  -- main visual background
	self._pointer = nil -- pointer element

	-- auto masking
	if params.automask then
		self:_setView( display.newContainer( self._width, self._height ) )
		self.view.anchorChildren = false
		self.view.anchorX, self.view.anchorY = 0.5, 0
	end

end

function PopoverView:__undoInit__()
	-- print( "PopoverView:__undoInit__" )
	self._delegate = nil
	--==--
	self:superCall( '__undoInit__' )
end

--== createView

function PopoverView:__createView__()
	-- print( "PopoverView:__createView__" )
	self:superCall( '__createView__' )
	--==--
	local W,H = self._width, self._height
	local H_CENTER, V_CENTER = W*0.5, H*0.5

	local o, dg  -- object, display group

	-- group for background elements

	dg = display.newGroup()
	self:insert( dg )
	self._dg_bg = dg

	-- group for main elements

	dg = display.newGroup()
	self:insert( dg )
	self._dg_main = dg

	-- viewable background

	o = display.newRect(0, 0, W, H)
	o:setFillColor(1,1,1,0.8)
	if LOCAL_DEBUG then
		o:setFillColor(0,1,1,1)
	end
	o.anchorX, o.anchorY = 0.5,0
	o.x, o.y = 0,0

	self._dg_bg:insert( o )
	self._bg_main = o

	-- delegate view

	self._dg_main:insert( self._delegate.view )

end

function PopoverView:__undoCreateView__()
	-- print( "PopoverView:__undoCreateView__" )
	self._bg_main:removeSelf()
	self._bg_main = nil

	self._dg_main:removeSelf()
	self._dg_main = nil

	self._dg_bg:removeSelf()
	self._dg_bg = nil
	--==--
	self:superCall( '__undoCreateView__' )
end


--== initComplete

function PopoverView:__initComplete__()
	--print( "PopoverView:__initComplete__" )
	self:superCall( '__initComplete__' )
	--==--
	self:setTouchBlock( self._bg_main )
end

function PopoverView:__undoInitComplete__()
	--print( "PopoverView:__undoInitComplete__" )
	self:unsetTouchBlock( self._bg_main )
	--==--
	self:superCall( '__undoInitComplete__' )
end

-- END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Static Methods


function PopoverView.__setWidgetManager( manager )
	-- print( "PopoverView.__setWidgetManager" )
	Widgets = manager
end



--====================================================================--
--== Public Methods


function PopoverView:show( pos, params )
	-- print( "PopoverView:show", pos )
	assert( pos.x and pos.y )
	--==--
	self.x, self.y = pos.x, pos.y
	self.isVisible = true
end

function PopoverView:hide()
	-- print( "PopoverView:hide" )
	local d = self._delegate
	self.isVisible = false
	if d and d.isDismissed then
		timer.performWithDelay( 1, function() d:isDismissed() end)
	end
end



--====================================================================--
--== Private Methods


function PopoverView:shouldDismiss()
	-- print( "PopoverView:shouldDismiss" )
	local del = self._delegate
	if del and del.shouldDismiss then
		return del.shouldDismiss()
	else
		return true
	end
end

-- TODO: make fancier
function PopoverView:_calculatePosition()
	-- print( "PopoverView:_calculatePosition'" )
	local _x, _y = self._x_pos, self._y_pos
	self.x, self.y = _x, _y
end



--====================================================================--
--== Event Handlers


-- none




return PopoverView
