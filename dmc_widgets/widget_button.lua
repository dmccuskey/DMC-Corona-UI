--====================================================================--
-- widget_button.lua
--
-- Documentation: http://docs.davidmccuskey.com/display/docs/newButton.lua
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

local VERSION = "0.1.0"



--====================================================================--
--== DMC Widgets Setup
--====================================================================--

local dmc_widget_data, dmc_widget_func
dmc_widget_data = _G.__dmc_widget
dmc_widget_func = dmc_widget_data.func



--====================================================================--
--== DMC Widgets : newButton
--====================================================================--



--====================================================================--
--== Imports

local Objects = require 'dmc_objects'
local Utils = require 'dmc_utils'

--== Button View Components

local ShapeView = require( dmc_widget_func.find( 'widget_button.view_shape' ) )



--====================================================================--
--== Setup, Constants

-- setup some aliases to make code cleaner
local inheritsFrom = Objects.inheritsFrom
local CoronaBase = Objects.CoronaBase

-- local VIEW_TYPE_SHAPE = 'shape-type'
-- local VIEW_TYPE_IMAGE = 'image-type'
-- local VIEW_TYPE_FRAME = 'frame-type'
-- local VIEW_TYPE_9SLICE = '9-slice-type'

local LOCAL_DEBUG = false


--====================================================================--
--== Support Functions


local function getViewTypeClass( params )
	params = params or {}
	if params.sheet ~= nil then
		return VIEW_TYPE_FRAME
	else
		return ShapeView
	end

end


--====================================================================--
--== Button Widget Class
--====================================================================--


local ButtonBase = inheritsFrom( CoronaBase )
ButtonBase.NAME = "Button Base"

ButtonBase.PHASE_PRESS = 'press'
ButtonBase.PHASE_RELEASE = 'release'

ButtonBase._SUPPORTED_VIEWS = nil


--======================================================--
-- Start: Setup DMC Objects

function ButtonBase:_init( params )
	-- print( "ButtonBase:_init" )
	params = params or { }
	self:superCall( "_init", params )
	--==--

	--== Sanity Check ==--

	if self.is_intermediate then return end
	assert( params.width and params.height, "missing params" )

	--== Create Properties ==--

	-- the hit area of the button
	self._hit_width = params.hit_width or params.width
	self._hit_height = params.hit_height or params.height

	self._state = '' -- holds state string

	self._views = {} -- holds individual view objects

	self._callbacks = {
		onPress = nil,
		onRelease = nil,
		onEvent = nil,
	}

	--== Display Groups ==--

	self._dg_views = nil -- to put button views in display hierarchy


	self._view_class = getViewTypeClass( params )

end

-- function ButtonBase:_undoInit()
-- 	-- print( "ButtonBase:_undoInit" )
-- 	--==--
-- 	self:superCall( "_undoInit" )
-- end


-- _createView()
--
function ButtonBase:_createView()
	-- print( "ButtonBase:_createView" )
	self:superCall( "_createView" )
	--==--

	local WIDTH, HEIGHT = display.contentWidth, display.contentHeight

	local W,H = self._width, self._height
	local H_CENTER, V_CENTER = W*0.5, H*0.5

	local o, dg  -- object, display group

	--== hit area
	o = display.newRect(0, 0, self._hit_width, self._hit_height)
	o:setFillColor(0,0,0,0)
	if LOCAL_DEBUG then
		o:setFillColor(0,1,0,0.5)
	end
	o.isHitTestable = true
	o.anchorX, o.anchorY = 0,0
	o.x, o.y = 0,0

	self.view:insert( o )
	self._bg_hit = o

	--== display group for button views
	dg = display.newGroup()
	self.view:insert( dg )
	self._dg_views = dg

	--== create individual button views
	for _, name in ipairs( self._SUPPORTED_VIEWS ) do
		o = self._view_class:new( params )
		dg:insert( o.view )
		self._view[ name ] = o
	end

end

function ButtonBase:_undoCreateView()
	-- print( "ButtonBase:_undoCreateView" )

	local o

	--==--
	self:superCall( "_undoCreateView" )
end


-- _initComplete()
--
function ButtonBase:_initComplete()
	--print( "ButtonBase:_initComplete" )

	local o, f

	o = self._bg_hit
	o._f = self:createCallback( self._hitTouchEvent_handler )
	o:addEventListener( 'touch', o._f )

	self:_updateView()
	--==--
	self:superCall( "_initComplete" )
end

function ButtonBase:_undoInitComplete()
	--print( "ButtonBase:_undoInitComplete" )

	o = self._bg_hit
	o:removeEventListener( 'touch', o._f )
	o._f = nil

	--==--
	self:superCall( "_undoInitComplete" )
end


--== END: Setup DMC Objects





--====================================================================--
--== Public Methods



--====================================================================--
--== Private Methods

function ButtonBase:_updateView()
	print( "ButtonBase:_updateView" )
end

function ButtonBase:_handleDispatch()
	print( "ButtonBase:_handleDispatch" )
end


--====================================================================--
--== Event Handlers

function ButtonBase:_hitTouchEvent_handler( event )
	print( "ButtonBase:_hitTouchEvent_handler", event.phase )
	local target = event.target

	if event.phase == 'began' then
		display.getCurrentStage():setFocus( target )
		self._has_focus = true
	end

	if not self._has_focus then return end

	if event.phase == 'ended' or event.phase == 'canceled' then
		display.getCurrentStage():setFocus( nil )
		self._has_focus = false

		self._handleDispatch()
	end

end



return ButtonBase
