--====================================================================--
-- dmc_ui/dmc_widget/widget_scrollview/axis_motion.lua
--
-- Documentation:
--====================================================================--

--[[

The MIT License (MIT)

Copyright (C) 2015 David McCuskey. All Rights Reserved.

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
--== DMC Corona UI : Axis Motion
--====================================================================--


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.1.0"



--====================================================================--
--== DMC Corona UI Setup
--====================================================================--


local dmc_ui_data = _G.__dmc_ui
local dmc_ui_func = dmc_ui_data.func
local ui_find = dmc_ui_func.find



--====================================================================--
--== DMC UI :
--====================================================================--



--====================================================================--
--== Imports


local Objects = require 'dmc_objects'
local StatesMixModule = require 'dmc_states_mix'
local Utils = require 'dmc_utils'

local uiConst = require( ui_find( 'ui_constants' ) )
local easingx = require( ui_find( 'dmc_widget.lib.easingx' ) )



--====================================================================--
--== Setup, Constants


local newClass = Objects.newClass
local ObjectBase = Objects.ObjectBase

local mabs = math.abs
local mfloor = math.floor
local sfmt = string.format
local tinsert = table.insert
local tremove = table.remove
local tstr = tostring



--====================================================================--
--== Axis Motion Class
--====================================================================--


local AxisMotion = newClass( ObjectBase, {name="Axis Motion"} )

StatesMixModule.patch( AxisMotion )

--== Class Constants

-- max number of items for velocity calculation
AxisMotion.VELOCITY_STACK_LENGTH = 4
-- speed limit
AxisMotion.VELOCITY_LIMIT = 1

AxisMotion.DECELERATE_TRANS_TIME = 3000 -- test 1000 / def 1000
AxisMotion.RESTORE_TRANS_TIME = 400 -- test 1000 / def 400
AxisMotion.RESTRAINT_TRANS_TIME = 350  -- test 1000 / def 100
AxisMotion.SCROLLTO_TRANS_TIME = 500  -- test 1000 / def 100

AxisMotion.SCROLLBACK_FACTOR = 1/3

AxisMotion.HIT_UPPER_LIMIT = 'upper_limit_hit'
AxisMotion.HIT_LOWER_LIMIT = 'lower_limit_hit'

--== State Constants

AxisMotion.STATE_CREATE = 'state_create'
AxisMotion.STATE_AT_REST = 'state_at_rest'
AxisMotion.STATE_DECELERATE = 'state_decelerate'
AxisMotion.STATE_RESTORE = 'state_restore'
AxisMotion.STATE_RESTRAINT = 'state_restraint'
AxisMotion.STATE_TOUCH = 'state_touch'

--== Event Constants

AxisMotion.SCROLLING = 'scrolling'
AxisMotion.SCROLLED = 'scrolled'


--======================================================--
-- Start: Setup DMC Objects

function AxisMotion:__init__( params )
	-- print( "AxisMotion:__init__" )
	params = params or {}
	if params.bounceIsActive==nil then params.bounceIsActive = true end
	if params.length==nil then params.length = 0 end
	if params.lowerOffset==nil then params.lowerOffset = 0 end
	if params.scrollbackFactor==nil then params.scrollbackFactor = AxisMotion.SCROLLBACK_FACTOR end
	if params.scrollIsEnabled==nil then params.scrollIsEnabled = true end
	if params.scrollLength==nil then params.scrollLength = 0 end
	if params.upperOffset==nil then params.upperOffset = 0 end

	self:superCall( '__init__', params )
	--==--

	-- value is current position, eg x/y
	self._value = 0

	self._length = params.length
	self._scrollLength = params.scrollLength

	self._lowerOffset = params.lowerOffset
	self._upperOffset = params.upperOffset

	self._scrollbackFactor = params.scrollbackFactor
	self._scrollbackLimit = params.length/3 -- << test 1 / def 3

	self._id = params.id
	self._callback = params.callback

	self._didBegin = false

	--== Internal Properties

	-- eg, HIT_UPPER_LIMIT, HIT_LOWER_LIMIT
	self._scrollLimit = nil

	-- last Touch Event, used for calculating deltas
	self._tmpTouchEvt = nil

	-- last enterFrame event, used for calculating deltas
	self._tmpFrameEvent = nil

	-- self._touchEvtStack = {}
	self._velocityStack = {0,0}
	self._velocity = { value=0, vector=0 }

	self._enterFrameIterator = nil

	self._bounceIsActive = params.bounceIsActive
	self._alwaysBounce = false
	self._scrollEnabled = params.scrollIsEnabled

	self:setState( AxisMotion.STATE_CREATE )
end

--== createView

function AxisMotion:__initComplete__()
	-- print( "AxisMotion:__initComplete__" )
	self:superCall( '__initComplete__' )
	--==--

	--== Use Setters
	self.bounceIsActive = self._bounceIsActive
	self.length = self._length
	self.lowerOffset = self._lowerOffset
	self.scrollIsEnabled = self._scrollEnabled
	self.scrollLength = self._scrollLength
	self.scrollbackFactor = self._scrollbackFactor
	self.upperOffset = self._upperOffset

	self:gotoState( AxisMotion.STATE_AT_REST )
end

function AxisMotion:__undoInitComplete__()
	-- print( "AxisMotion:__undoInitComplete__" )
	--==--
	self:superCall( '__undoInitComplete__' )
end

-- END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Public Methods


-- whether to bounce on constraint
function AxisMotion.__getters:bounceIsActive()
	return self._bounceIsActive
end
function AxisMotion.__setters:bounceIsActive( value )
	assert( type(value)=='boolean' )
	--==--
	self._bounceIsActive = value
end


-- this is the length of the view port
function AxisMotion.__getters:length()
	return self._length
end
function AxisMotion.__setters:length( value )
	assert( type(value)=='number' and value > 0 )
	--==--
	self._length = value
	self:_setScrollbackLimit()
end


function AxisMotion.__getters:lowerOffset()
	return self._lowerOffset
end
function AxisMotion.__setters:lowerOffset( value )
	assert( type(value)=='number' )
	--==--
	self._lowerOffset = value
end


-- decimal fraction (1/3)
function AxisMotion.__setters:scrollbackFactor( value )
	self._scrollbackFactor = value
	self:_setScrollbackLimit()
end


function AxisMotion.__getters:scrollIsEnabled()
	return self._scrollEnabled
end
function AxisMotion.__setters:scrollIsEnabled( value )
	assert( type(value)=='boolean' )
	--==--
	self._scrollEnabled = value
end


-- this is the maximum dimension of the scroller
function AxisMotion.__getters:scrollLength()
	return self._scrollLength
end
function AxisMotion.__setters:scrollLength( value )
	assert( type(value)=='number' and value > 0 )
	--==--
	self._scrollLength = value
end


function AxisMotion.__getters:upperOffset()
	return self._upperOffset
end
function AxisMotion.__setters:upperOffset( value )
	assert( type(value)=='number' )
	--==--
	self._upperOffset = value
end


-- current position/location
function AxisMotion.__getters:value()
	return self._value
end


function AxisMotion:scrollToPosition( pos, params )
	-- print( "AxisMotion:scrollToPosition", pos )
	params = params or {}
	-- params.onComplete=params.onComplete
	if params.time==nil then params.time=AxisMotion.SCROLLTO_TRANS_TIME end
	if params.limitIsActive==nil then params.limitIsActive=false end
	--==--
	local eFI

	if params.time==0 then

		eFI = function()
			self._value = pos
			self._isMoving=false
			self._hasMoved=true
			self._enterFrameIterator=nil
			if params.onComplete then params.onComplete() end
		end

	else
		local time = params.time
		local ease_f = easingx.easeOut
		local val = self._value
		local startEvt = {
			time=system.getTimer()
		}
		self._isMoving = true
		local delta = self._value + pos
		if params.limitIsActive then
			local velocity = mabs( delta/time )
			if velocity > AxisMotion.VELOCITY_LIMIT then
				time = mfloor( mabs(delta/AxisMotion.VELOCITY_LIMIT) )
			end
		end

		eFI = function( e )
			local deltaT = e.time - startEvt.time
			local deltaV = ease_f( deltaT, time, val, delta )

			if deltaT < time then
				self._value = deltaV
			else
				self._isMoving = false
				self._hasMoved = true
				self._value = delta
				self._enterFrameIterator=nil
				if params.onComplete then params.onComplete() end
			end
		end

	end

	self._enterFrameIterator = eFI
	Runtime:addEventListener( 'enterFrame', self )

end



--====================================================================--
--== Private Methods


-- set how far table can be scrolled against a boundary limit
--
function AxisMotion:_setScrollbackLimit()
	self._scrollbackLimit = self._length * self._scrollbackFactor
end


-- check if position is at a limit
--
function AxisMotion:_checkScrollBounds( value )
	-- print( "AxisMotion:_checkScrollBounds", value )
	local calcs = { min=0, max=0 }

	if self._scrollEnabled and value then
		local upper = 0 + self._upperOffset
		local lower = (self._length-self._scrollLength) - self._lowerOffset

		calcs.min=upper
		calcs.max=lower

		if value > upper then
			self._scrollLimit = AxisMotion.HIT_UPPER_LIMIT
		elseif value < lower then
			self._scrollLimit = AxisMotion.HIT_LOWER_LIMIT
		else
			self._scrollLimit = nil
		end
	end

	return calcs
end


-- ensure position stays within boundaries
--
function AxisMotion:_constrainPosition( value, delta )
	-- print( "AxisMotion:_constrainPosition", value, delta )
	local isBounceActive = self._bounceIsActive
	local LIMIT = self._scrollbackLimit
	local scrollLimit, newVal, calcs, s, factor

	newVal = value + delta
	calcs = self:_checkScrollBounds( newVal )
	scrollLimit = self._scrollLimit -- after check bounds

	if scrollLimit==AxisMotion.HIT_UPPER_LIMIT then
		if not isBounceActive then
			newVal=calcs.min
		else
			s = newVal-self._upperOffset
			factor = 1 - (s/LIMIT)
			if factor < 0 then factor = 0 end
			newVal = value + ( delta * factor )
			-- check bounds again
			self:_checkScrollBounds( newVal )
		end

	elseif scrollLimit==AxisMotion.HIT_LOWER_LIMIT then
		if not isBounceActive then
			newVal=calcs.max
		else
			s = (self._length - self._scrollLength) - newVal - self._lowerOffset
			factor = 1 - (s/LIMIT)
			if factor < 0 then factor = 0 end
			newVal = value + ( delta * factor )
			-- check bounds again
			self:_checkScrollBounds( newVal )
		end

	end

	return newVal
end


-- clamp max velocity, calculate average velocity
--
function AxisMotion:_updateVelocity( value )
	-- print( "AxisMotion:_updateVelocity", value )
	local VEL_STACK_LENGTH = AxisMotion.VELOCITY_STACK_LENGTH
	local LIMIT = AxisMotion.VELOCITY_LIMIT
	local _mabs = mabs
	local velStack = self._velocityStack
	local vel = self._velocity
	local vector, aveVel = 0,0

	if _mabs(value) > LIMIT then
		-- clamp velocity
		vector = (value>=0) and 1 or -1
		value = LIMIT*vector
	end

	tinsert( velStack, 1, value )

	for i = #velStack, 1, -1 do
		-- calculate average velocity and
		-- clean off velocity stack at same time
		if i > VEL_STACK_LENGTH then
			tremove( velStack, i )
		else
			aveVel = aveVel + velStack[i]
		end
	end
	aveVel = aveVel / #velStack

	vel.value = _mabs( aveVel )
	if aveVel~=0 then
		vel.vector = (aveVel>0) and -1 or 1
	else
		vel.vector = 0
	end

end



--====================================================================--
--== Event Handlers


function AxisMotion:enterFrame( event )
	-- print( "AxisMotion:enterFrame" )

	local f = self._enterFrameIterator

	if not f then
		Runtime:removeEventListener( 'enterFrame', self )

	else
		f( event )
		self._tmpFrameEvent = event

		if self._isMoving then
			local vel = self._velocity
			self._callback{
				id=self._id,
				state=AxisMotion.SCROLLING,
				value=self._value,
				velocity = vel.value * vel.vector,
			}
			self._hasMoved = true
		end

		-- look at "full" 'enterFrameIterator' in case value
		-- was changed during last call to interator
		if not self._enterFrameIterator and self._hasMoved then
			self._callback{
				id=self._id,
				state = AxisMotion.SCROLLED,
				value = self._value,
				velocity = 0
			}
			self._hasMoved = false
		end

	end
end


function AxisMotion:touch( event )
	-- print( "AxisMotion:touch", event.phase, event.value )
	local phase = event.phase

	if not self._scrollEnabled then return end

	local evt = {
		-- make a "copy" of the event
		time=event.time,
		start=event.start,
		value=event.value
	}

	if phase=='began' then
		local vel = self._velocity
		local velStack = self._velocityStack

		-- @TODO, probably check to see state we're in
		vel.value, vel.vector = 0, 0

		if #velStack==0 then
			tinsert( velStack, 1, 0 )
		end

		self._tmpTouchEvt = evt
		self._didBegin = true
		self:gotoState( AxisMotion.STATE_TOUCH )

	end

	if not self._didBegin then return end

	if phase == 'moved' then

		local tmpTouchEvt = self._tmpTouchEvt
		local constrain = AxisMotion._constrainPosition

		local deltaVal = event.value - tmpTouchEvt.value
		local deltaT = event.time - tmpTouchEvt.time
		local oldVal, newVal

		self._isMoving = true

		--== Calculate new position/velocity

		oldVal = self._value
		newVal = constrain( self, oldVal, deltaVal )
		self:_updateVelocity( (oldVal-newVal)/deltaT )

		self._value = newVal
		self._tmpTouchEvt = evt

	elseif phase=='ended' or phase=='cancelled' then

		self._tmpTouchEvt = evt
		self._didBegin = false

		local next_state, next_params = self:_getNextState{ event=event }
		self:gotoState( next_state, next_params )

	end

end



--====================================================================--
--== State Machine


function AxisMotion:_getNextState( params )
	-- print( "AxisMotion:_getNextState" )
	params = params or {}
	--==--
	local scrollLimit = self._scrollLimit
	local velocity = self._velocity
	local isBounceActive = self._bounceIsActive
	local s, p -- state, params

	-- print( "gNS>>", velocity.value, scrollLimit, isBounceActive )

	if velocity.value > 0 and not scrollLimit then
		s = AxisMotion.STATE_DECELERATE
		p = { event=params.event }

	elseif velocity.value <= 0 and scrollLimit and isBounceActive then
		s = AxisMotion.STATE_RESTORE
		p = { event=params.event }

	elseif velocity.value > 0 and scrollLimit and isBounceActive then
		s = AxisMotion.STATE_RESTRAINT
		p = { event=params.event }

	else
		s = AxisMotion.STATE_AT_REST
		p = { event=params.event }

	end

	return s, p
end


--== State Create

function AxisMotion:state_create( next_state, params )
	-- print( "AxisMotion:state_create: >> ", next_state )

	if next_state == AxisMotion.STATE_AT_REST then
		self:do_state_at_rest( params )

	else
		pwarn( sfmt( "AxisMotion:state_create unknown trans '%s'", tstr( next_state )))
	end
end


--== State At-Rest

function AxisMotion:do_state_at_rest( params )
	-- print( "AxisMotion:do_state_at_rest", params )
	params = params or {}
	--==--
	local vel = self._velocity
	vel.value, vel.vector = 0, 0
	self._isMoving = false

	self._enterFrameIterator = nil
	Runtime:removeEventListener( 'enterFrame', self )

	self:setState( AxisMotion.STATE_AT_REST )
end

function AxisMotion:state_at_rest( next_state, params )
	-- print( "AxisMotion:state_at_rest: >> ", next_state )

	if next_state == AxisMotion.STATE_TOUCH then
		self:do_state_touch( params )

	else
		pwarn( sfmt( "AxisMotion:state_at_rest unknown trans '%s'", tstr( next_state )))
	end

end


--== State Touch

function AxisMotion:do_state_touch( params )
	-- print( "AxisMotion:do_state_touch" )
	-- params = params or {}
	-- --==--

	local enterFrameFunc1 = function( e )
		-- print( "enterFrameFunc: enterFrameFunc1 state touch " )
		self:_updateVelocity( 0 )
	end

	-- start animation

	if self._enterFrameIterator == nil then
		Runtime:addEventListener( 'enterFrame', self )
	end
	self._enterFrameIterator = enterFrameFunc1

	-- set current state
	self:setState( AxisMotion.STATE_TOUCH )
end

function AxisMotion:state_touch( next_state, params )
	print( "AxisMotion:state_touch: >> ", next_state )

	if next_state == AxisMotion.STATE_RESTORE then
		self:do_state_restore( params )

	elseif next_state == AxisMotion.STATE_RESTRAINT then
		self:do_state_restraint( params )

	elseif next_state == AxisMotion.STATE_AT_REST then
		self:do_state_at_rest( params )

	elseif next_state == AxisMotion.STATE_DECELERATE then
		self:do_state_decelerate( params )

	else
		print( sfmt( "AxisMotion:state_touch unknown trans '%s'", tstr( next_state )))
	end

end


--== State Decelerate

function AxisMotion:do_state_decelerate( params )
	-- print( "AxisMotion:do_state_decelerate" )
	params = params or {}
	--==--
	local TIME = AxisMotion.DECELERATE_TRANS_TIME
	local constrain = AxisMotion._constrainPosition
	local ease_f = easingx.easeOutQuad
	local _mabs = mabs

	local startEvt = params.event
	local vel = self._velocity
	local velocity = vel.value
	local deltaVel = -velocity

	self._isMoving = true

	local enterFrameFunc = function( e )
		-- print( "AxisMotion: enterFrameFunc: do_state_decelerate" )

		local frameEvt = self._tmpFrameEvent
		local scrollLimit = self._scrollLimit

		local deltaStart = e.time - startEvt.time
		local deltaFrame = e.time - frameEvt.time
		local deltaVal, oldVal, newVal

		--== Calculation

		vel.value = ease_f( deltaStart, TIME, velocity, deltaVel )
		deltaVal = vel.value * vel.vector * deltaFrame

		--== Action

		oldVal = self._value
		newVal = constrain( self, oldVal, deltaVal )
		self._value = newVal

		if vel.value > 0 and scrollLimit then
			-- hit edge while moving
			self:gotoState( AxisMotion.STATE_RESTRAINT, { event=e } )

		elseif deltaStart >= TIME or _mabs( newVal-oldVal ) < 1 then
			-- over time or movement too small to see (pixel)
			self:gotoState( AxisMotion.STATE_AT_REST )

		end

	end

	-- start animation

	if self._enterFrameIterator == nil then
		Runtime:addEventListener( 'enterFrame', self )
	end
	self._enterFrameIterator = enterFrameFunc

	-- set current state
	self:setState( AxisMotion.STATE_DECELERATE )

end

function AxisMotion:state_decelerate( next_state, params )
	-- print( "AxisMotion:state_decelerate: >> ", next_state )

	if next_state == self.STATE_TOUCH then
		self:do_state_touch( params )

	elseif next_state == self.STATE_AT_REST then
		self:do_state_at_rest( params )

	elseif next_state == self.STATE_RESTRAINT then
		self:do_state_restraint( params )

	else
		print( "WARNING :: AxisMotion:state_decelerate > " .. tostring( next_state ) )
	end

end


--== State Restore

function AxisMotion:do_state_restore( params )
	-- print( "AxisMotion:do_state_restore" )
	params = params or {}
	--==--
	local TIME = AxisMotion.RESTORE_TRANS_TIME
	local constrain = AxisMotion._constrainPosition
	local ease_f = easingx.easeOut

	local startEvt = params.event
	local val = self._value
	local vel = self._velocity

	local delta, offset

	-- calculate restore distance
	if self._scrollLimit == AxisMotion.HIT_UPPER_LIMIT then
		offset = self._upperOffset
	else
		offset = (self._length - self._scrollLength - self._lowerOffset)
	end
	delta = offset-val

	self._isMoving = true

	local enterFrameFunc = function( e )
		-- print( "AxisMotion: enterFrameFunc: do_state_restore " )

		--== Calculation

		local deltaT = e.time - startEvt.time
		local deltaV = ease_f( deltaT, TIME, val, delta )

		--== Action

		if deltaT < TIME then
			self._value = deltaV
		else
			self._value = offset
			self:gotoState( AxisMotion.STATE_AT_REST )
		end
	end

	-- start animation

	if self._enterFrameIterator == nil then
		Runtime:addEventListener( 'enterFrame', self )
	end
	self._enterFrameIterator = enterFrameFunc

	-- set current state
	self:setState( AxisMotion.STATE_RESTORE )
end

function AxisMotion:state_restore( next_state, params )
	-- print( "AxisMotion:state_restore: >> ", next_state )

	if next_state == AxisMotion.STATE_TOUCH then
		self:do_state_touch( params )

	elseif next_state == AxisMotion.STATE_AT_REST then
		self:do_state_at_rest( params )

	else
		print( "WARNING :: AxisMotion:state_restore > " .. tostring( next_state ) )
	end

end


--== State Restraint

-- when object has velocity and hit limit
-- we constrain its motion away from limit
--
function AxisMotion:do_state_restraint( params )
	-- print( "AxisMotion:do_state_restraint" )
	params = params or {}
	--==--
	local TIME = AxisMotion.RESTRAINT_TRANS_TIME
	local constrain = AxisMotion._constrainPosition
	local ease_f = easingx.easeOut
	local _mabs = mabs

	-- startEvt could be Touch or enterFrame event
	-- of importance is the 'time' param
	local startEvt = params.event

	local vel = self._velocity
	local velocity = vel.value * vel.vector
	local deltaVel = -velocity

	self._isMoving = true

	local enterFrameFunc = function( e )
		-- print( "AxisMotion: enterFrameFunc: do_state_restraint" )

		local frameEvt = self._tmpFrameEvent

		local deltaStart = e.time - startEvt.time -- total
		local deltaFrame = e.time - frameEvt.time
		local deltaVal, oldVal, newVal

		--== Calculation

		vel.value = ease_f( deltaStart, TIME, velocity, deltaVel )
		deltaVal = vel.value * deltaFrame

		--== Action

		oldVal = self._value
		newVal = constrain( self, oldVal, deltaVal )
		self._value = newVal

		if deltaStart >= TIME or _mabs( newVal-oldVal ) < 1 then
			vel.value, vel.vector = 0, 0
			self:gotoState( AxisMotion.STATE_RESTORE, { event=e } )

		end

	end

	-- start animation

	if self._enterFrameIterator == nil then
		Runtime:addEventListener( 'enterFrame', self )
	end
	self._enterFrameIterator = enterFrameFunc

	-- set current state
	self:setState( AxisMotion.STATE_RESTRAINT )
end

function AxisMotion:state_restraint( next_state, params )
	-- print( "AxisMotion:state_restraint: >> ", next_state )

	if next_state == self.STATE_TOUCH then
		self:do_state_touch( params )

	elseif next_state == self.STATE_RESTORE then
		self:do_state_restore( params )

	else
		print( "WARNING :: AxisMotion:state_restraint > " .. tostring( next_state ) )
	end

end




return AxisMotion
