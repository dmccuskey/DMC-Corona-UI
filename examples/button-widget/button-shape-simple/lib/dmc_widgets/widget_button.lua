--====================================================================--
-- dmc_widgets/widget_button.lua
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
--== DMC Corona Widgets : Widget Button
--====================================================================--


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.1.0"



--====================================================================--
--== DMC Widgets Setup
--====================================================================--


local dmc_widget_data = _G.__dmc_widget
local dmc_widget_func = dmc_widget_data.func
local widget_find = dmc_widget_func.find



--====================================================================--
--== DMC Widgets : newButton
--====================================================================--



--====================================================================--
--== Imports


local LifecycleMixModule = require 'dmc_lifecycle_mix'
local Objects = require 'dmc_objects'
local StatesMixModule = require 'dmc_states_mix'
local ThemeMixModule = require( dmc_widget_func.find( 'widget_theme_mix' ) )
local Utils = require 'dmc_utils'

-- set later
local Widgets = nil
local ThemeMgr = nil



--====================================================================--
--== Setup, Constants


local newClass = Objects.newClass
local ComponentBase = Objects.ComponentBase

local LifecycleMix = LifecycleMixModule.LifecycleMix
local StatesMix = StatesMixModule.StatesMix
local ThemeMix = ThemeMixModule.ThemeMix



--====================================================================--
--== Support Functions




--====================================================================--
--== Button Widget Class
--====================================================================--


-- ! put ThemeMix first !

local ButtonBase = newClass( {ThemeMix,ComponentBase, StatesMix,LifecycleMix}, {name="Button Base"}  )

--== Class Constants

ButtonBase._SUPPORTED_VIEWS = { 'active', 'inactive', 'disabled' }

--== State Constants

ButtonBase.STATE_INIT = 'state_init'
ButtonBase.STATE_INACTIVE = 'state_inactive'
ButtonBase.STATE_ACTIVE = 'state_active'
ButtonBase.STATE_DISABLED = 'state_disabled'

ButtonBase.INACTIVE = ButtonBase.STATE_INACTIVE
ButtonBase.ACTIVE = ButtonBase.STATE_ACTIVE
ButtonBase.DISABLED = ButtonBase.STATE_DISABLED

--== Theme Constants

ButtonBase.THEME_ID = 'button'
ButtonBase.STYLE_CLASS = nil -- added later

--== Event Constants

ButtonBase.EVENT = 'button-event'

ButtonBase.PRESSED = 'pressed'
ButtonBase.RELEASED = 'released'


--======================================================--
-- Start: Setup DMC Objects

--== Init

function ButtonBase:__init__( params )
	print( "ButtonBase:__init__", params )
	params = params or {}
	if params.x==nil then params.x=0 end
	if params.y==nil then params.y=0 end
	if params.id==nil then params.id="" end
	if params.labelText==nil then params.labelText="Press" end

	self:superCall( LifecycleMix, '__init__', params )
	self:superCall( StatesMix, '__init__', params )
	self:superCall( ComponentBase, '__init__', params )
	self:superCall( ThemeMix, '__init__', params )
	--==--

	--== Sanity Check ==--

	if self.is_class then return end

	--== Create Properties ==--

	-- properties stored in class

	self._x = params.x
	self._x_dirty=true
	self._y = params.y
	self._y_dirty=true

	self._id = params.id
	self._id_dirty=true

	self._labelText = params.text
	self._labelText_dirty=true

	self._data = params.data

	-- properties stored in style

	self._width_dirty=true
	self._height_dirty=true

	self._align_dirty=true
	self._anchorX_dirty=true
	self._anchorY_dirty=true
	self._isHitActive_dirty=true
	self._hitMarginX_dirty=true
	self._hitMarginY_dirty=true
	self._marginX_dirty=true
	self._marginY_dirty=true
	self._offsetX_dirty=true
	self._offsetY_dirty=true

	-- "Virtual" properties

	self._widgetState_dirty=true
	self._widgetViewState = nil
	self._widgetViewState_dirty=true

	self._params = params -- save for view creation

	self._callbacks = {
		onPress = params.onPress,
		onRelease = params.onRelease,
		onEvent = params.onEvent,
	}

	--== Object References ==--

	self._tmp_style = params.style -- save

	self._rctHit = nil -- our rectangle hit area
	self._rctHit_f = nil

	self._wgtBg = nil -- background widget
	self._wgtBg_f = nil -- widget handler
	self._wgtBg_dirty=true

	self._wgtText = nil -- text widget (for both hint and value display)
	self._wgtText_f = nil -- widget handler
	self._wgtText_dirty=true

	-- set initial state
	self:setState( ButtonBase.STATE_INIT )

end

function ButtonBase:__undoInit__()
	-- print( "ButtonBase:__undoInit__" )
	--==--
	self:superCall( ThemeMix, '__undoInit__' )
	self:superCall( ComponentBase, '__undoInit__' )
	self:superCall( StatesMix, '__undoInit__' )
	self:superCall( LifecycleMix, '__undoInit__' )
end


--== createView

function ButtonBase:__createView__()
	-- print( "ButtonBase:__createView__" )
	self:superCall( ComponentBase, '__createView__' )
	--==--
	local o = display.newRect( 0,0,0,0 )
	o.anchorX, o.anchorY = 0.5,0.5
	self:insert( o )
	self._rctHit = o
end

function ButtonBase:__undoCreateView__()
	-- print( "ButtonBase:__undoCreateView__" )
	self._rctHit:removeSelf()
	self._rctHit=nil
	--==--
	self:superCall( ComponentBase, '__undoCreateView__' )
end


--== initComplete

function ButtonBase:__initComplete__()
	-- print( "ButtonBase:__initComplete__" )
	self:superCall( ComponentBase, '__initComplete__' )
	--==--
	self._rctHit_f = self:createCallback( self._hitAreaTouch_handler )
	self._rctHit:addEventListener( 'touch', self._rctHit_f )

	-- self._textStyle_f = self:createCallback( self.textStyleChange_handler )
	-- self._wgtText_f = self:createCallback( self._wgtTextWidgetUpdate_handler )

	self.style = self._tmp_style

	if is_active then
		self:gotoState( ButtonBase.STATE_ACTIVE )
	else
		self:gotoState( ButtonBase.STATE_INACTIVE )
	end
end

function ButtonBase:__undoInitComplete__()
	--print( "ButtonBase:__undoInitComplete__" )

	o = self._bg_hit
	o:removeEventListener( 'touch', o._f )
	o._f = nil

	--==--
	self:superCall( ComponentBase, '__undoInitComplete__' )
end

-- END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Public Methods


--======================================================--
-- Local Properties

-- .X
--
function ButtonBase.__getters:x()
	return self._x
end
function ButtonBase.__setters:x( value )
	-- print( 'ButtonBase.__setters:x', value )
	assert( type(value)=='number' )
	--==--
	self._x = value
	self._x_dirty=true
	self:__invalidateProperties__()
end

-- .Y
--
function ButtonBase.__getters:y()
	return self._y
end
function ButtonBase.__setters:y( value )
	-- print( 'ButtonBase.__setters:y', value )
	assert( type(value)=='number' )
	--==--
	self._y = value
	self._y_dirty=true
	self:__invalidateProperties__()
end

-- .labelText
--
function ButtonBase.__getters:labelText()
	return self._labelText
end
function ButtonBase.__setters:labelText( value )
	-- print( "ButtonBase.__setters:labelText", value )
	if value == self._labelText then return end
	self._labelText = value
	self._labelText_dirty=true
	self:__invalidateProperties__()
end



--======================================================--
-- Background Style Properties


-- .strokeWidth
--
function ButtonBase.__getters:strokeWidth()
	return self.curr_style.background.strokeWidth
end
function ButtonBase.__setters:strokeWidth( value )
	-- print( 'ButtonBase.__setters:strokeWidth', value )
	self.curr_style.inactive.strokeWidth = value
end

function ButtonBase.__getters:strokeColor()
	return self.curr_style.background.strokeWidth
end
function ButtonBase.__setters:strokeColor( value )
	-- print( 'ButtonBase.__setters:strokeColor', value )
	self.curr_style.inactive.strokeColor = value
end

-- setBackgroundStrokeColor()
--
function ButtonBase:setBackgroundStrokeColor( ... )
	-- print( 'ButtonBase:setBackgroundStrokeColor' )
	self.curr_style.background.strokeColor = {...}
end



--======================================================--
-- Label Style Properties

-- .hintFont
--
function ButtonBase.__setters:labelFont( value )
	-- print( 'ButtonBase.__setters:labelFont', value )
	local style = self.curr_style
	style.inactive.font = value
	style.active.font = value
	style.disabled.font = value
end

-- .labelFontSize
--
function ButtonBase.__setters:labelFontSize( value )
	-- print( 'ButtonBase.__setters:labelFontSize', value )
	local style = self.curr_style
	style.inactive.fontSize = value
	style.active.fontSize = value
	style.disabled.fontSize = value
end

-- setLabelColor()
--
function ButtonBase:setLabelColor( ... )
	-- print( 'ButtonBase:setLabelColor' )
	local args={...}
	local style = self.curr_style
	style.inactive.textColor = args
	style.active.textColor = args
	style.disabled.textColor = args
end


--======================================================--
-- Theme Methods

-- clearStyle()
--
function ButtonBase:clearStyle()
	local style=self.curr_style
	-- TODO: propagate this in style inheritance/parent
	style:clearProperties()
	style.inactive:clearProperties()
	style.active:clearProperties()
	style.disabled:clearProperties()
end


-- afterAddStyle()
--
function ButtonBase:afterAddStyle()
	-- print( "ButtonBase:afterAddStyle", self )
	self._widgetStyle_dirty=true
	self:__invalidateProperties__()
end

-- beforeRemoveStyle()
--
function ButtonBase:beforeRemoveStyle()
	-- print( "ButtonBase:beforeRemoveStyle", self )
	self._widgetStyle_dirty=true
	self:__invalidateProperties__()
end





--======================================================--
-- Button Methods




function ButtonBase.__getters:isEnabled()
	return ( self:getState() ~= ButtonBase.STATE_DISABLED )
end
function ButtonBase.__setters:isEnabled( value )
	assert( type(value)=='boolean', "newButton: expected boolean for property 'enabled'")
	--==--
	if self.curr_style.isHitActive == value then return end

	if value == true then
		self:gotoState( ButtonBase.STATE_INACTIVE, { isEnabled=value } )
	else
		self:gotoState( ButtonBase.STATE_DISABLED, { isEnabled=value } )
	end
end

function ButtonBase.__getters:is_active()
	return ( self:getState() == self.STATE_ACTIVE )
end


function ButtonBase.__getters:id()
	return self._id
end
function ButtonBase.__setters:id( value )
	assert( type(value)=='string' or type(value)=='nil', "expected string or nil for button id")
	self._id = value
end


function ButtonBase.__setters:onPress( value )
	assert( type(value)=='function' or type(value)=='nil', "expected function or nil for onPress")
	self._callbacks.onPress = value
end
function ButtonBase.__setters:onRelease( value )
	assert( type(value)=='function' or type(value)=='nil', "expected function or nil for onRelease")
	self._callbacks.onRelease = value
end
function ButtonBase.__setters:onEvent( value )
	assert( type(value)=='function' or type(value)=='nil', "expected function or nil for onEvent")
	self._callbacks.onEvent = value
end


function ButtonBase.__getters:value()
	return self._value
end
function ButtonBase.__setters:value( value )
	self._value = value
end


function ButtonBase.__getters:views()
	return self._views
end

-- Method to programmatically press the button
--
function ButtonBase:press()
	local bounds = self.contentBounds
	-- setup fake touch event
	local evt = {
		target=self.view,
		x=bounds.xMin,
		y=bounds.yMin,
	}

	evt.phase = 'began'
	self:_hitAreaTouch_handler( evt )
	evt.phase = 'ended'
	self:_hitAreaTouch_handler( evt )
end



--====================================================================--
--== Private Methods


-- dispatch 'press' events
--
-- TODO: use create event
function ButtonBase:_doPressEventDispatch()
	-- print( "ButtonBase:_doPressEventDispatch" )

	if not self.isEnabled then return end

	local cb = self._callbacks
	local event = {
		name=self.EVENT,
		phase=self.PRESSED,
		target=self,
		id=self._id,
		value=self._value,
		state=self:getState()
	}

	if cb.onPress then cb.onPress( event ) end
	if cb.onEvent then cb.onEvent( event ) end
	self:dispatchEvent( event )
end

-- dispatch 'release' events
--
function ButtonBase:_doReleaseEventDispatch()
	print( "ButtonBase:_doReleaseEventDispatch" )

	if not self.isEnabled then return end

	local cb = self._callbacks
	local event = {
		name=self.EVENT,
		phase=self.RELEASED,
		target=self,
		id=self._id,
		value=self._value,
		state=self:getState()
	}

	if cb.onRelease then cb.onRelease( event ) end
	if cb.onEvent then cb.onEvent( event ) end
	self:dispatchEvent( event )
end


--====================================================================--
--== Private Methods




--== Create/Destroy Background Widget

function ButtonBase:_removeBackground()
	-- print( "ButtonBase:_removeBackground" )
	local o = self._wgtBg
	if not o then return end
	o:removeSelf()
	self._wgtBg = nil
end

function ButtonBase:_createBackground()
	-- print( "ButtonBase:_createBackground" )

	self:_removeBackground()

	local o = Widgets.newBackground()
	self:insert( o.view )
	self._wgtBg = o

	--== Reset properties

	self._wgtBgStyle_dirty=true
end


function ButtonBase:__commitProperties__()
	print( 'ButtonBase:__commitProperties__' )

	--== Update Widget Components ==--

	if self._wgtBg_dirty then
		self:_createBackground()
		self._wgtBg_dirty = false
	end

	--== Update Widget View ==--

	local style = self.curr_style
	-- local state = self:getState()
	local view = self.view
	local hit = self._rctHit
	local bg = self._wgtBg
	local text = self._wgtText

	--== View

	-- x/y

	if self._x_dirty then
		view.x = self._x
		self._x_dirty=false
	end
	if self._y_dirty then
		view.y = self._y
		self._y_dirty=false
	end

	-- width/height

	if self._width_dirty then
		local width = style.width
		hit.width = width
		style.inactive.width = width
		style.active.width = width
		style.disabled.width = width
		self._width_dirty=false
	end
	if self._height_dirty then
		local height = style.height
		hit.height = height
		style.inactive.height = height
		style.active.height = height
		style.disabled.height = height
		self._height_dirty=false
	end


	--== Set Styles

	if self._widgetStyle_dirty or self._widgetViewState_dirty then
		local state = self._widgetViewState
		if state==ButtonBase.INACTIVE then
			bg:setActiveStyle( style.inactive.background, {copy=false} )
		elseif state==ButtonBase.ACTIVE then
			bg:setActiveStyle( style.active.background, {copy=false} )
		else
			bg:setActiveStyle( style.disabled.background, {copy=false} )
		end
		self._widgetStyle_dirty=false
		self._widgetViewState_dirty=false
	end

	--== Hit

	if self._isHitTestable then
		hit.isHitTestable=style.isHitTestable
		self._isHitTestable=false
	end

	-- debug on

	if self._debugOn_dirty then
		if style.debugOn then
			hit:setFillColor( 1,0,0,0.5 )
		else
			hit:setFillColor( 0,0,0,0 )
		end
		self._debugOn_dirty=false
	end

end


--====================================================================--
--== Event Handlers


-- stylePropertyChangeHandler()
-- this is the standard property event handler
-- needed by any DMC Widget
-- it listens for changes in the Widget Style Object
-- and reponds with the appropriate message
--
function ButtonBase:stylePropertyChangeHandler( event )
	print( "\n\n\n>>>>>> ButtonBase:stylePropertyChangeHandler", event )
	local target = event.target
	local etype= event.type
	local property= event.property
	local value = event.value

	-- Utils.print( event )

	print( "Style Changed", etype, property, value )

	if etype == target.STYLE_RESET then
		self._debugOn_dirty = true

		self._width_dirty=true
		self._height_dirty=true

		self._align_dirty=true
		self._anchorX_dirty=true
		self._anchorY_dirty=true
		self._backgroundStyle_dirty = true
		self._inputType_dirty=true
		self._isHitActive_dirty=true
		self._isHitTestable_dirty=true
		self._isSecure_dirty=true
		self._marginX_dirty=true
		self._marginY_dirty=true
		self._returnKey_dirty=true

		self._wgtText_dirty=true
		self._widgetViewState_dirty=true

		property = etype

	else
		if property=='debugActive' then
			self._debugOn_dirty=true

		elseif property=='width' then
			self._width_dirty=true
		elseif property=='height' then
			self._height_dirty=true

		elseif property=='align' then
			self._align_dirty=true
		elseif property=='anchorX' then
			self._anchorX_dirty=true
		elseif property=='anchorY' then
			self._anchorY_dirty=true
		elseif property=='backgroundStyle' then
			self._backgroundStyle_dirty=true
		elseif property=='inputType' then
			self._inputType_dirty=true
		elseif property=='isHitActive' then
			self._isHitActive_dirty=true
		elseif property=='isHitTestable' then
			self._isHitTestable_dirty=true
		elseif property=='isSecure' then
			self._isSecure_dirty=true
		elseif property=='marginX' then
			self._marginX_dirty=true
		elseif property=='marginY' then
			self._marginY_dirty=true
		elseif property=='returnKey' then
			self._returnKey_dirty=true
		end

	end

	self:__invalidateProperties__()
	self:__dispatchInvalidateNotification__( property, value )
end



--====================================================================--
--== State Machine

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
		print( "[WARNING] ButtonBase:state_init " .. tostring( next_state ) )
	end
end

--== State: Active

function ButtonBase:do_state_active( params )
	-- print( "ButtonBase:do_state_active" )
	params = params or {}
	params.set_state = params.set_state == nil and true or params.set_state
	--==--
	if params.set_state == true then
		self:setState( ButtonBase.STATE_ACTIVE )
	end
	self._widgetViewState=ButtonBase.STATE_ACTIVE
	self._widgetViewState_dirty=true
	self:__invalidateProperties__()
end

function ButtonBase:state_active( next_state, params )
	-- print( "ButtonBase:state_active >>", next_state )
	params = params or {}
	--==--

	if next_state == ButtonBase.STATE_ACTIVE then
		self:do_state_active( params )

	elseif next_state == ButtonBase.STATE_INACTIVE then
		self:do_state_inactive( params )

	elseif next_state == ButtonBase.STATE_DISABLED then
		self:do_state_disabled( params )

	else
		print( "[WARNING] ButtonBase:state_active " .. tostring( next_state ) )
	end
end

--== State: Inactive

function ButtonBase:do_state_inactive( params )
	-- print( "ButtonBase:do_state_inactive" )
	params = params or {}
	params.set_state = params.set_state == nil and true or params.set_state
	--==--
	if params.set_state == true then
		self:setState( ButtonBase.STATE_INACTIVE )
	end
	self._widgetViewState=ButtonBase.STATE_INACTIVE
	self._widgetViewState_dirty=true
	self:__invalidateProperties__()
end

function ButtonBase:state_inactive( next_state, params )
	-- print( "ButtonBase:state_inactive >>", next_state )
	params = params or {}
	--==--

	if next_state == ButtonBase.STATE_ACTIVE then
		self:do_state_active( params )

	elseif next_state == ButtonBase.STATE_INACTIVE then
		self:do_state_inactive( params )

	elseif next_state == ButtonBase.STATE_DISABLED then
		self:do_state_disabled( params )

	else
		print( "[WARNING] ButtonBase:state_inactive " .. tostring( next_state ) )
	end
end

--== State: Disabled

function ButtonBase:do_state_disabled( params )
	-- print( "ButtonBase:do_state_disabled" )
	params = params or {}
	--==--
	self:setState( ButtonBase.STATE_DISABLED )
	self._widgetViewState=ButtonBase.STATE_DISABLED
	self._widgetViewState_dirty=true
	self:__invalidateProperties__()
end

--[[
params.isEnabled is to make sure that we have been enabled
since someone else might ask us to change state eg, to ACTIVE
when we are disabled (like a button group)
--]]
function ButtonBase:state_disabled( next_state, params )
	-- print( "ButtonBase:state_disabled >>", next_state )
	params = params or {}
	params.isEnabled = params.isEnabled == nil and false or params.isEnabled
	--==--
	if next_state == ButtonBase.STATE_ACTIVE and params.isEnabled==true then
		self:do_state_active( params )

	elseif next_state == ButtonBase.STATE_INACTIVE and params.isEnabled==true then
		self:do_state_inactive( params )
	elseif next_state == ButtonBase.STATE_DISABLED then
		self:do_state_disabled( params )

	else
		print( "[WARNING] ButtonBase:state_disabled " .. tostring( next_state ) )
	end
end

-- END: State Machine
--======================================================--








--===================================================================--
--== Push Button Class
--===================================================================--


local PushButton = newClass( ButtonBase, {name="Push Button"} )

PushButton.TYPE = 'push'


--======================================================--
-- Start: Setup DMC Objects

-- END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Public Methods


-- none



--====================================================================--
--== Private Methods


-- none



--====================================================================--
--== Event Handlers


function PushButton:_hitAreaTouch_handler( event )
	-- print( "PushButton:_hitAreaTouch_handler", event.phase )

	if not self.curr_style.isHitActive then return true end

	local phase = event.phase
	local button = event.target

	if phase == 'began' then
		display.getCurrentStage():setFocus( button )
		self._has_focus = true

		self:gotoState( self.STATE_ACTIVE )
		self:_doPressEventDispatch()
	end

	if not self._has_focus then return end

	local bounds = button.contentBounds
	local x,y = event.x,event.y
	local is_bounded =
		( x >= bounds.xMin and x <= bounds.xMax and
		y >= bounds.yMin and y <= bounds.yMax )

	if phase == 'moved' then
		if is_bounded then
			self:gotoState( self.STATE_ACTIVE )
		else
			self:gotoState( self.STATE_INACTIVE )
		end

	elseif phase == 'ended' or phase == 'canceled' then
		display.getCurrentStage():setFocus( nil )
		self._has_focus = false
		self:gotoState( self.STATE_INACTIVE )

		if is_bounded then
			self:_doReleaseEventDispatch()
		end
	end

	return true
end



--===================================================================--
--== Toggle Button Class
--===================================================================--


local ToggleButton = newClass( ButtonBase, {name="Toggle Button"}  )

ToggleButton.TYPE = 'toggle'


--======================================================--
-- Start: Setup DMC Objects

-- END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Public Methods


-- none



--====================================================================--
--== Private Methods


function ToggleButton:_getNextState()
	-- print( "ToggleButton:_getNextState" )
	if self:getState() == self.STATE_ACTIVE then
		return self.STATE_INACTIVE
	else
		return self.STATE_ACTIVE
	end
end



--====================================================================--
--== Event Handlers


function ToggleButton:_hitAreaTouch_handler( event )
	print( "ToggleButton:_hitAreaTouch_handler", event.phase )

	if not self.isEnabled then return true end

	local target = event.target
	local bounds = target.contentBounds
	local x,y = event.x,event.y
	local is_bounded =
		( x >= bounds.xMin and x <= bounds.xMax and
		y >= bounds.yMin and y <= bounds.yMax )
	local curr_state = self:getState()
	local next_state = self:_getNextState()

	if event.phase == 'began' then
		display.getCurrentStage():setFocus( target )
		self._has_focus = true
		self:gotoState( next_state, { set_state=false } )
		self:_doPressEventDispatch()

		return true
	end

	if not self._has_focus then return end

	if event.phase == 'moved' then
		if is_bounded then
			self:gotoState( next_state, { set_state=false } )
		else
			self:gotoState( curr_state, { set_state=false } )
		end

	elseif event.phase == 'ended' or event.phase == 'canceled' then
		display.getCurrentStage():setFocus( nil )
		self._has_focus = false
		if is_bounded then
			self:gotoState( next_state )
			self:_doReleaseEventDispatch()
		else
			self:gotoState( curr_state )
		end

	end

	return true
end



--===================================================================--
--== Radio Button Class
--===================================================================--


local RadioButton = newClass( ToggleButton, {name="Radio Button"} )

RadioButton.TYPE = 'radio'


--======================================================--
-- Start: Setup DMC Objects

-- END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Public Methods


-- none



--====================================================================--
--== Private Methods


function RadioButton:_getNextState()
	-- print( "RadioButton:_getNextState" )
	return self.STATE_ACTIVE
end



--====================================================================--
--== Event Handlers


-- none



--===================================================================--
--== Button Factory
--===================================================================--



local function initializeButtons( manager )
	print( "Buttons.initialize" )
	Widgets = manager
	ThemeMgr = Widgets.ThemeMgr

	ButtonBase.STYLE_CLASS = Widgets.Style.Button

	ThemeMgr:registerWidget( ButtonBase.THEME_ID, ButtonBase )
end



local Buttons = {}

Buttons.initialize = initializeButtons

-- export class instantiations for direct access
Buttons.ButtonBase = ButtonBase
Buttons.PushButton = PushButton
Buttons.ToggleButton = ToggleButton
Buttons.RadioButton = RadioButton

-- Button factory method

function Buttons.create( params )
	-- print( "Buttons.create", params.type )
	assert( params.action, "newButton: expected param 'action'" )
	--==--
	local action = params.action

	if action == PushButton.TYPE then
		return PushButton:new( params )

	elseif action == RadioButton.TYPE then
		return RadioButton:new( params )

	elseif action == ToggleButton.TYPE then
		return ToggleButton:new( params )

	else
		error( "newButton: unknown button type: " .. tostring( action ) )

	end
end




--[[
getters sttters



--== hitMarginX

-- function Background.__getters:hitMarginX()
-- 	-- print( "Background.__getters:hitMarginX" )
-- 	return self.curr_style.hitMarginX
-- end
-- function Background.__setters:hitMarginX( value )
-- 	-- print( "Background.__setters:hitMarginX", value )
-- 	self.curr_style.hitMarginX = value
-- end

-- --== hitMarginY

-- function Background.__getters:hitMarginY()
-- 	-- print( "Background.__getters:hitMarginY" )
-- 	return self.curr_style.hitMarginY
-- end
-- function Background.__setters:hitMarginY( value )
-- 	-- print( "Background.__setters:hitMarginY", value )
-- 	self.curr_style.hitMarginY = value
-- end


-- --== setHitMargin

-- function Background:setHitMargin( ... )
-- 	-- print( 'Background:setHitMargin' )
-- 	local args = {...}

-- 	if type( args[1] ) == 'table' then
-- 		self.hitMarginX, self.hitMarginY = unpack( args[1] )
-- 	end
-- 	if type( args[1] ) == 'number' then
-- 		self.hitMarginX = args[1]
-- 	end
-- 	if type( args[2] ) == 'number' then
-- 		self.hitMarginY = args[2]
-- 	end
-- end

-- --== isHitActive

-- function Background.__getters:isHitActive()
-- 	-- print( "Background.__getters:isHitActive" )
-- 	return self.curr_style.isHitActive
-- end
-- function Background.__setters:isHitActive( value )
-- 	-- print( "Background.__setters:isHitActive", value )
-- 	self.curr_style.isHitActive = value
-- end



complete prperties

-- if self._hitX_dirty or self._anchorX_dirty then
-- 	local width = style.width
-- 	hit.x = width/2+(-width*style.anchorX)
-- 	self._hitX_dirty=false
-- 	self._anchorX_dirty=false
-- end
-- if self._hitY_dirty or self._anchorY_dirty then
-- 	local height = style.height
-- 	hit.y = height/2+(-height*style.anchorY)
-- 	self._hitY_dirty=false
-- 	self._anchorY_dirty=false
-- end


-- hit testable

-- if self._isHitTestable_dirty then
-- 	hit.isHitTestable = style.isHitTestable
-- 	self._isHitTestable_dirty=false
-- end




in event handler


elseif property=='hitMarginX' then
	self._hitMarginX_dirty=true
elseif property=='hitMarginY' then
	self._hitMarginY_dirty=true
elseif property=='isHitActive' then
	self._isHitActive_dirty=true
elseif property=='isHitTestable' then
	self._isHitTestable_dirty=true

--]]


return Buttons

