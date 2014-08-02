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
local StatesMix = require 'lua_states'

-- Button View Components
local ImageView = require( dmc_widget_func.find( 'widget_button.view_image' ) )
local ShapeView = require( dmc_widget_func.find( 'widget_button.view_shape' ) )


--====================================================================--
--== Setup, Constants

-- setup some aliases to make code cleaner
local inheritsFrom = Objects.inheritsFrom
local CoronaBase = Objects.CoronaBase

local LOCAL_DEBUG = false


--====================================================================--
--== Support Functions

local function getViewTypeClass( params )
	if params.viewClass ~= nil then
		return params.viewClass

	elseif params.shape ~= nil then
		return ShapeView

	elseif params.file ~= nil then
		return ImageView

	elseif params.sheet ~= nil then
		return FrameView

	else -- default view
		error( "newButton: view type not found" )

	end
end


--====================================================================--
--== Button Widget Class
--====================================================================--


local ButtonBase = inheritsFrom( CoronaBase )
ButtonBase.NAME = "Button Base"

StatesMix.mixin( ButtonBase )

--== Class Constants

ButtonBase._SUPPORTED_VIEWS = { 'active', 'inactive', 'disabled' }

--== Class States

ButtonBase.STATE_INIT = 'state_init'
ButtonBase.STATE_ACTIVE = 'state_active'
ButtonBase.STATE_INACTIVE = 'state_inactive'
ButtonBase.STATE_DISABLED = 'state_disabled'

--== Class events

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
	assert( params.width and params.height, "newButton: expected params 'width' and 'height'" )

	--== Create Properties ==--

	self._params = params -- save for view creation

	self._id = params.id

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


	-- set initial state
	self:setState( ButtonBase.STATE_INIT )

end

function ButtonBase:_undoInit()
	-- print( "ButtonBase:_undoInit" )

	self._callbacks = nil
	self._views = nil

	--==--
	self:superCall( "_undoInit" )
end


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

	for name, view in pairs( self._views ) do
		view:removeSelf()
		self._views[ name ] = nil
	end

	o = self._dg_views
	o:removeSelf()
	self._dg_views = nil

	o = self._bg_hit
	o:removeSelf()
	self._bg_hit = nil

	--==--
	self:superCall( '_undoCreateView' )
end


-- _initComplete()
--
function ButtonBase:_initComplete()
	--print( "ButtonBase:_initComplete" )
	self:superCall( '_initComplete' )
	--==--

	local is_active = self._params.is_active == nil and false or self._params.is_active
	local o

	o = self._bg_hit
	o._f = self:createCallback( self._hitTouchEvent_handler )
	o:addEventListener( 'touch', o._f )

	if is_active then
		self:gotoState( ButtonBase.STATE_ACTIVE )
	else
		self:gotoState( ButtonBase.STATE_INACTIVE )
	end

	self._params = nil -- get rid of temp structure
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

function ButtonBase.__getters:enabled()
	return ( self:getState() ~= self.STATE_DISABLED )
end
function ButtonBase.__setters:enabled( value )
	assert( type(value)=='boolean', "newButton: expected boolean for property 'enabled'")
	--==--
	if self.enabled == value then return end

	if value == true then
		self:gotoState( ButtonBase.STATE_INACTIVE )
	else
		self:gotoState( ButtonBase.STATE_DISABLED )
	end
end


--====================================================================--
--== Private Methods

-- handle 'press' events
--
function ButtonBase:_handlePressDispatch()
	-- print( "ButtonBase:_handlePressDispatch" )

	if not self.enabled then return end

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

-- handle 'release' events
--
function ButtonBase:_handleReleaseDispatch()
	-- print( "ButtonBase:_handleReleaseDispatch" )

	if not self.enabled then return end

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


--======================================================--
-- START: State Machine

--== State: Init

function ButtonBase:state_init( next_state, params )
	-- print( "ButtonBase:state_init >>", next_state )
	params = params or {}
	--==--

	if next_state == ButtonBase.STATE_ACTIVE then
		self:do_state_active( params )

	elseif next_state == ButtonBase.STATE_INACTIVE then
		self:do_state_inactive( params )

	elseif next_state == ButtonBase.STATE_DISABLED then
		self:do_state_disabled( params )

	else
		print( "WARNING :: WebSocket:state_create " .. tostring( next_state ) )
	end
end

--== State: Active

function ButtonBase:do_state_active( params )
	-- print( "ButtonBase:do_state_active" )
	params = params or {}
	--==--
	local views = self._views

	views.inactive.isVisible = false
	views.active.isVisible = true
	views.disabled.isVisible = false

	self:setState( ButtonBase.STATE_ACTIVE )
end

function ButtonBase:state_active( next_state, params )
	-- print( "ButtonBase:state_active >>", next_state )
	params = params or {}
	--==--

	if next_state == ButtonBase.STATE_ACTIVE then
		-- pass

	elseif next_state == ButtonBase.STATE_INACTIVE then
		self:do_state_inactive( params )

	elseif next_state == ButtonBase.STATE_DISABLED then
		self:do_state_disabled( params )

	else
		print( "WARNING :: WebSocket:state_create " .. tostring( next_state ) )
	end
end

--== State: Inactive

function ButtonBase:do_state_inactive( params )
	-- print( "ButtonBase:do_state_inactive" )
	params = params or {}
	--==--
	local views = self._views

	views.inactive.isVisible = true
	views.active.isVisible = false
	views.disabled.isVisible = false

	self:setState( ButtonBase.STATE_INACTIVE )
end

function ButtonBase:state_inactive( next_state, params )
	-- print( "ButtonBase:state_inactive >>", next_state )
	params = params or {}
	--==--

	if next_state == ButtonBase.STATE_ACTIVE then
		self:do_state_active( params )

	elseif next_state == ButtonBase.STATE_INACTIVE then
		-- pass

	elseif next_state == ButtonBase.STATE_DISABLED then
		self:do_state_disabled( params )

	else
		print( "WARNING :: WebSocket:state_create " .. tostring( next_state ) )
	end
end


--== State: Disabled

function ButtonBase:do_state_disabled( params )
	-- print( "ButtonBase:do_state_disabled" )
	params = params or {}
	--==--
	local views = self._views

	views.inactive.isVisible = false
	views.active.isVisible = false
	views.disabled.isVisible = true

	self:setState( ButtonBase.STATE_DISABLED )
end

function ButtonBase:state_disabled( next_state, params )
	-- print( "ButtonBase:state_disabled >>", next_state )
	params = params or {}
	--==--

	if next_state == ButtonBase.STATE_ACTIVE then
		-- pass

	elseif next_state == ButtonBase.STATE_INACTIVE then
		self:do_state_inactive( params )

	elseif next_state == ButtonBase.STATE_DISABLED then
		-- pass

	else
		print( "WARNING :: WebSocket:state_create " .. tostring( next_state ) )
	end
end

-- END: State Machine
--======================================================--



--====================================================================--
--== Event Handlers

function ButtonBase:_hitTouchEvent_handler( event )
	-- print( "ButtonBase:_hitTouchEvent_handler", event.phase )
	local target = event.target

	if not self.enabled then return true end

	if event.phase == 'began' then
		display.getCurrentStage():setFocus( target )
		self._has_focus = true
		self:gotoState( self.STATE_ACTIVE )
		self:_handlePressDispatch()

		return true
	end

	if not self._has_focus then return end

	local bounds = target.contentBounds
	local x,y = event.x,event.y
	local is_bounded =
		( x >= bounds.xMin and x <= bounds.xMax and
		y >= bounds.yMin and y <= bounds.yMax )

	if event.phase == 'moved' then
		if is_bounded then
			self:gotoState( self.STATE_ACTIVE )
		else
			self:gotoState( self.STATE_INACTIVE )
		end

	elseif event.phase == 'ended' or event.phase == 'cancelled' then
		display.getCurrentStage():setFocus( nil )
		self._has_focus = false
		self:gotoState( self.STATE_INACTIVE )

		if is_bounded then
			self:_handleReleaseDispatch()
		end
	end

	return true
end



--===================================================================--
--== Push Button Class
--===================================================================--

local PushButton = inheritsFrom( ButtonBase )
PushButton.NAME = "Push Button"


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

