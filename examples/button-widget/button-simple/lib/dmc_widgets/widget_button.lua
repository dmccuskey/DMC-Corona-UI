--====================================================================--
-- widget_button.lua
--
-- Documentation: http://docs.davidmccuskey.com/display/docs/newButton.lua
--====================================================================--

--[[

The MIT License (MIT)

Copyright (c) 2014 David McCuskey

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

local FrameView = require( dmc_widget_func.find( 'widget_button.view_frame' ) )
local ShapeView = require( dmc_widget_func.find( 'widget_button.view_shape' ) )



--====================================================================--
--== Setup, Constants

-- setup some aliases to make code cleaner
local inheritsFrom = Objects.inheritsFrom
local CoronaBase = Objects.CoronaBase

local LOCAL_DEBUG = true


--====================================================================--
--== Support Functions

local function getViewTypeClass( params )
	if params.viewClass ~= nil then
		return params.viewClass

	elseif params.sheet ~= nil then
		return FrameView

	else -- default view
		return ShapeView

	end
end


--====================================================================--
--== Button Widget Class
--====================================================================--


local ButtonBase = inheritsFrom( CoronaBase )
ButtonBase.NAME = "Button Base"


ButtonBase._SUPPORTED_VIEWS = nil

ButtonBase.EVENT = 'button-event'
ButtonBase.PHASE_PRESS = 'press'
ButtonBase.PHASE_RELEASE = 'release'

--======================================================--
-- Start: Setup DMC Objects

function ButtonBase:_init( params )
	-- print( "ButtonBase:_init" )
	params = params or {}
	self:superCall( '_init', params )
	--==--

	--== Sanity Check ==--

	if self.is_intermediate then return end
	assert( params.width and params.height, "missing params" )

	--== Create Properties ==--
	self._params = params -- save for view creation

	self._id = params.id
	self._enabled = params.enabled == nil and true or params.enabled

	self._width = params.width
	self._height = params.height

	-- the hit area of the button
	self._hit_width = params.hit_width or params.width
	self._hit_height = params.hit_height or params.height

	self._class = getViewTypeClass( params )
	self._views = {} -- holds individual view objects

	self._callbacks = {
		onPress = params.onPress,
		onRelease = params.onRelease,
		onEvent = params.onEvent,
	}

	--== Display Groups ==--

	self._dg_views = nil -- to put button views in display hierarchy

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
	self:superCall( '_createView' )
	--==--

	local o, p, dg  -- object, display group

	--== hit area
	o = display.newRect(0, 0, self._hit_width, self._hit_height)
	o:setFillColor(0,0,0,0)
	if LOCAL_DEBUG then
		o:setFillColor(0,0.3,0,0.5)
	end
	o.isHitTestable = true
	o.anchorX, o.anchorY = 0.5, 0.5

	self.view:insert( o )
	self._bg_hit = o

	--== display group for button views
	dg = display.newGroup()
	self.view:insert( dg )
	self._dg_views = dg

	--== create individual button views
	for _, name in ipairs( self._SUPPORTED_VIEWS ) do
		self._params.name = name
		o = self._class:new( self._params )
		dg:insert( o.view )
		self._views[ name ] = o
	end
	self._params.name = nil

end

function ButtonBase:_undoCreateView()
	-- print( "ButtonBase:_undoCreateView" )

	local o

	--==--
	self:superCall( '_undoCreateView' )
end


-- _initComplete()
--
function ButtonBase:_initComplete()
	--print( "ButtonBase:_initComplete" )

	local o

	self._params = nil -- get rid of structure

	o = self._bg_hit
	o._f = self:createCallback( self._hitTouchEvent_handler )
	o:addEventListener( 'touch', o._f )

	self:_updateView()
	--==--
	self:superCall( '_initComplete' )
end

function ButtonBase:_undoInitComplete()
	--print( "ButtonBase:_undoInitComplete" )

	o = self._bg_hit
	o:removeEventListener( 'touch', o._f )
	o._f = nil

	--==--
	self:superCall( '_undoInitComplete' )
end

-- END: Setup DMC Objects
--======================================================--





--====================================================================--
--== Public Methods

function ButtonBase.__setters:enabled( value )
	assert( type(value)=='boolean', "expected boolean for property 'enabled'")

	if self._enabled == value then return end
	self._enabled = value
	self:_updateView()
end

--====================================================================--
--== Private Methods

function ButtonBase:_updateView()
	-- print( "ButtonBase:_updateView" )
	local views = self._views

	if not self._enabled then
		views.down.isVisible = false
		views.up.isVisible = false
		views.disabled.isVisible = true

	elseif self._has_focus ~= true then
		views.up.isVisible = true
		views.down.isVisible = false
		views.disabled.isVisible = false

	elseif self._has_focus and self._is_bounded then
		views.up.isVisible = false
		views.down.isVisible = true
		views.disabled.isVisible = false

	elseif self._has_focus and not self._is_bounded then
		views.up.isVisible = true
		views.down.isVisible = false
		views.disabled.isVisible = false

	end
end

function ButtonBase:_handlePressDispatch()
	-- print( "ButtonBase:_handlePressDispatch" )

	if not self._enabled then return end

	local cb = self._callbacks
	local event = {
		target=self,
		id=self._id,
		phase=self.PHASE_PRESS,
	}
	if cb.onPress then cb.onPress( event ) end
	if cb.onEvent then cb.onEvent( event ) end
	self:dispatchEvent( self.EVENT, event )
end
function ButtonBase:_handleReleaseDispatch()
	-- print( "ButtonBase:_handleReleaseDispatch" )

	if not self._enabled then return end

	local cb = self._callbacks
	local event = {
		target=self,
		id=self._id,
		phase=self.PHASE_RELEASE,
	}
	if cb.onRelease then cb.onRelease( event ) end
	if cb.onEvent then cb.onEvent( event ) end
	self:dispatchEvent( self.EVENT, event )
end


--====================================================================--
--== Event Handlers

function ButtonBase:_hitTouchEvent_handler( event )
	-- print( "ButtonBase:_hitTouchEvent_handler", event.phase )
	local target = event.target

	if event.phase == 'began' then
		display.getCurrentStage():setFocus( target )
		self._has_focus = true
		self._is_bounded = true
		self:_updateView()
		self:_handlePressDispatch()
	end

	if not self._has_focus then return end

	local bounds = target.contentBounds
	local x,y = event.x,event.y
	local is_bounded =
		( x >= bounds.xMin and x <= bounds.xMax and
		y >= bounds.yMin and y <= bounds.yMax )

	if event.phase == 'moved' then
		self._is_bounded = is_bounded
		self:_updateView()

	elseif event.phase == 'ended' or event.phase == 'cancelled' then
		display.getCurrentStage():setFocus( nil )
		self._has_focus = false
		self._is_bounded = false
		self:_updateView()

		if is_bounded then
			self:_handleReleaseDispatch()
		end
	end

end



--===================================================================--
--== Push Button Class
--===================================================================--

local PushButton = inheritsFrom( ButtonBase )
PushButton.NAME = "Push Button"

PushButton._SUPPORTED_VIEWS = { 'up', 'down', 'disabled' }


--======================================================--
-- Start: Setup DMC Objects

function PushButton:_init( params )
	-- print( "PushButton:_init" )
	params = params or {}
	self:superCall( '_init', params )
	--==--

end

function PushButton:_initComplete()
	-- print( "PushButton:_initComplete" )

	--==--
	self:superCall( '_initComplete' )
end

-- END: Setup DMC Objects
--======================================================--



--===================================================================--
--== Button Factory
--===================================================================--


local Buttons = {}

-- export class instantiations for direct access
Buttons.ButtonBase = ButtonBase
Buttons.PushButton = PushButton
Buttons.BinaryButton = BinaryButton
Buttons.ToggleButton = ToggleButton
Buttons.RadioButton = RadioButton

-- Button factory method

function Buttons.create( params )
	-- print( "Buttons.create" )
	local button_type = params.type

	if button_type == "radio" then
		return RadioButton:new( params )

	elseif button_type == "toggle" then
		return ToggleButton:new( params )

	else -- default type
		return PushButton:new( params )
	end
end


return Buttons

