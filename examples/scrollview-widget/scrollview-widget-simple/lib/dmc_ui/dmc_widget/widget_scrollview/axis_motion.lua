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

-- number of items to use for velocity calculation
AxisMotion.VELOCITY_STACK_LENGTH = 4

AxisMotion.RESTRAINT_TRANS_TIME = 1000
AxisMotion.RESTORE_TRANS_TIME = 1000
AxisMotion.LIMIT_LENGTH = 100
AxisMotion.DECELERATE_TRANS_TIME = 1000

AxisMotion.HIT_UPPER_LIMIT = 'upper_limit_hit'
AxisMotion.HIT_LOWER_LIMIT = 'lower_limit_hit'


AxisMotion.SCROLLING = 'scrolling'
AxisMotion.SCROLLED = 'scrolled'


--== State Constants

AxisMotion.STATE_CREATE = 'state_create'
AxisMotion.STATE_AT_REST = 'state_at_rest'
AxisMotion.STATE_DECELERATE = 'state_decelerate'
AxisMotion.STATE_RESTORE = 'state_restore'
AxisMotion.STATE_RESTRAINT = 'state_restraint'
AxisMotion.STATE_TOUCH = 'state_touch'


--======================================================--
-- Start: Setup DMC Objects

function AxisMotion:__init__( params )
	-- print( "AxisMotion:__init__" )
	params = params or {}
	if params.length==nil then params.length = 0 end
	if params.scrollLength==nil then params.scrollLength = 0 end
	if params.upperOffset==nil then params.upperOffset = 0 end
	if params.lowerOffset==nil then params.lowerOffset = 0 end

	self:superCall( '__init__', params )
	--==--

	-- value is current position, eg x/y
	self._value = 0

	self._length = params.length
	self._scrollLength = params.scrollLength
	self._lowerOffset = params.lowerOffset
	self._upperOffset = params.upperOffset

	self._limit = params.length/1 -- << 3

	self._id = params.id
	self._callback = params.callback

	-- eg, HIT_UPPER_LIMIT, HIT_LOWER_LIMIT
	self._scrollLimit = nil

	-- last Touch Event, used for calculating deltas
	self._tmpTouchEvt = nil
	-- last enterFrame event, used for calculating deltas
	self._tmpFrameEvent = nil

	self._touchEvtStack = {}
	self._velocity = { value=0, vector=0 }

	self._enterFrameIterator = nil

	self._bounceIsActive = true
	self._alwaysBounce = false
	self._scrollEnabled = true


	self:setState( AxisMotion.STATE_CREATE )
end

--== createView

function AxisMotion:__initComplete__()
	-- print( "AxisMotion:__initComplete__" )
	self:superCall( '__initComplete__' )
	--==--
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




--====================================================================--
--== Private Methods



--== _checkScrollBounds()

function AxisMotion:_checkScrollBounds( value )
	-- print( "AxisMotion:_checkScrollBounds", value )
	local calcs = { min=0, max=0 }

	if self._scrollEnabled and value then
		local upper = 0 - self._upperOffset
		local lower = (self._length-self._scrollLength) - self._lowerOffset
		calcs.min=upper
		calcs.max=lower

		-- print( "CSB", upper, lower )
		if value > upper then
			self._scrollLimit = AxisMotion.HIT_UPPER_LIMIT
		elseif value < lower then
			self._scrollLimit = AxisMotion.HIT_LOWER_LIMIT
		else
			self._scrollLimit = nil
		end
	end

	-- print( "CB", self._scrollLimit )
	return calcs
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
		self:_checkScrollBounds( self._value )

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
	print( "AxisMotion:touch", event.phase )
	local phase = event.phase

	local canScroll = self._scrollEnabled

	if not canScroll then return end

	Utils.print( event )
	tinsert( self._touchEvtStack, event )

	if phase=='began' then

		-- save this event for later, movement calculations
		self._tmpTouchEvt = event
		self:gotoState( AxisMotion.STATE_TOUCH )


	elseif phase == 'moved' then

		local LIMIT = self._limit
		local _mabs = mabs

		local val = self._value
		local tmpTouchEvt = self._tmpTouchEvt
		local deltaVal

		-- direction multipliers
		local factor = 1
		local d, t, s
		local absDeltaVal

		--== Determine if we need to reliquish the touch
		-- @TODO

		absDeltaVal = _mabs( event.start - event.value )
		--[[
		if not touch lock and delta > touch limit then ...

		if not touch lock and not scroll enabled then
			if over touch limit, take focus
		--]]

		self._isMoving = true

		--== Calculate new position

		local newVal = 0

		if canScroll and not self._scrollBlocked then
			local scrollLimit = self._scrollLimit
			local isBounceActive = self._bounceIsActive
			deltaVal = event.value - tmpTouchEvt.value
			newVal = val + deltaVal

			local calcs = self:_checkScrollBounds( newVal )

			if scrollLimit==self.HIT_UPPER_LIMIT then
				if not isBounceActive then
					newVal=calcs.min
				else
					factor = 1 - (newVal/LIMIT)
					newVal = val + ( deltaVal * factor )
				end

			elseif scrollLimit==self.HIT_LOWER_LIMIT then
				if not isBounceActive then
					newVal=calcs.max
				else
					s = (self._length - self._scrollLength) - newVal
					factor = 1 - (s/LIMIT)
					newVal = val + ( deltaVal * factor )
				end
			end

			-- print( ">>>", deltaVal, event.start, event.value, newVal )

			self._value = newVal
		end

		self._tmpTouchEvt = event


	elseif phase=='ended' or phase=='cancelled' then

		self._tmpTouchEvt = event

		-- maybe we have ended without moving
		-- so need to give back ended as a touch to our item

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

	local s, p -- state, params
	print( "GNS>>", velocity.value, scrollLimit )
	if velocity.value <= 0 and not scrollLimit then
		s = AxisMotion.STATE_AT_REST
		p = { event=params.event }

	elseif velocity.value > 0 and not scrollLimit then
		s = AxisMotion.STATE_DECELERATE
		p = { event=params.event }

	elseif velocity.value <= 0 and scrollLimit then
		s = AxisMotion.STATE_RESTORE
		p = { event=params.event }

	elseif velocity.value > 0 and scrollLimit then
		s = AxisMotion.STATE_RESTRAINT
		p = { event=params.event }

	end

	return s, p
end



--== State Init

function AxisMotion:state_create( next_state, params )
	-- print( "AxisMotion:state_create: >> ", next_state )

	if next_state == AxisMotion.STATE_AT_REST then
		self:do_state_at_rest( params )

	else
		pwarn( sfmt( "AxisMotion:state_create unknown trans '%s'", tstr( next_state )))
	end
end



function AxisMotion:do_state_at_rest( params )
	print( "AxisMotion:do_state_at_rest", params )
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
	print( "AxisMotion:state_at_rest: >> ", next_state )

	if next_state == AxisMotion.STATE_TOUCH then
		self:do_state_touch( params )

	else
		pwarn( sfmt( "AxisMotion:state_at_rest unknown trans '%s'", tstr( next_state )))
	end

end





function AxisMotion:do_state_touch( params )
	print( "AxisMotion:do_state_touch" )
	params = params or {}
	--==--

	local VEL_STACK_LENGTH = AxisMotion.VELOCITY_STACK_LENGTH
	local _mabs = mabs

	local axisVel = self._velocity
	local velStack = {}

	local evtTmp = nil -- enter frame event, updated each frame
	local lastTouchEvt = nil -- touch events, reset for each calculation

	local enterFrameFunc1, enterFrameFunc2


	--[[
	enterFrameFunc2

	work to do after the initial enterFrame
	this is mostly about calculating velocity
	--]]
	enterFrameFunc2 = function( e )
		print( "enterFrameFunc: enterFrameFunc2 state touch " )

		local teStack = self._touchEvtStack
		local evtCount = #teStack

		local deltaVal, deltaT

		--== process incoming touch events

		if evtCount == 0 then
			tinsert( velStack, 1, 0 )

		else
			deltaT = ( e.time-evtTmp.time ) / evtCount

			for i, tEvt in ipairs( teStack ) do
				deltaVal = tEvt.value - lastTouchEvt.value

				print( "events >> ", i, (deltaVal/deltaT), tEvt.value, lastTouchEvt.value )
				tinsert( velStack, 1, (deltaVal/deltaT) )

				lastTouchEvt = tEvt
			end

		end

		--== do calculations

		local aveVel = 0
		for i = #velStack, 1, -1 do
			-- calculate average velocity and
			-- clean off velocity stack at same time
			if i > VEL_STACK_LENGTH then
				print("clean", i )
				tremove( velStack, i )
			else
				aveVel = aveVel + velStack[i]
				print( "show", i, velStack[i] )
			end
		end
		print( 'Touch Vel1 ', aveVel, #velStack )
		aveVel = aveVel / #velStack
		print( 'Touch Vel2 ', aveVel, #velStack )

		axisVel.value = _mabs( aveVel )
		if aveVel < 0 then
			axisVel.vector = -1
		elseif aveVel > 0 then
			axisVel.vector = 1
		else
			axisVel.vector = 0
		end


		--== prep for next frame

		self._touchEvtStack = {}
		evtTmp = e

	end


	--[[
	enterFrameFunc1
	this is only for the first enterFrame on a touch event
	we're grabbing the 'begin' event
	--]]
	enterFrameFunc1 = function( e )
		print( "enterFrameFunc: enterFrameFunc1 touch " )

		axisVel.value, axisVel.vector = 0, 0
		print( #self._touchEvtStack )
		lastTouchEvt = tremove( self._touchEvtStack, #self._touchEvtStack )
		Utils.print( lastTouchEvt )
		evtTmp = e

		-- switch to other iterator
		self._enterFrameIterator = enterFrameFunc2
	end

	if self._enterFrameIterator == nil then
		Runtime:addEventListener( 'enterFrame', self )
	end

	self._enterFrameIterator = enterFrameFunc1

	self:setState( AxisMotion.STATE_TOUCH )
end


function AxisMotion:state_touch( next_state, params )
	-- print( "AxisMotion:state_touch: >> ", next_state )

	if next_state == AxisMotion.STATE_RESTORE then
		self:do_state_restore( params )

	elseif next_state == AxisMotion.STATE_RESTRAINT then
		self:do_state_restraint( params )

	elseif next_state == AxisMotion.STATE_AT_REST then
		self:do_state_at_rest( params )

	elseif next_state == AxisMotion.STATE_DECELERATE then
		self:do_state_decelerate( params )

	else
		pwarn( sfmt( "AxisMotion:state_touch unknown trans '%s'", tstr( next_state )))
	end

end






-- when object has neither velocity nor limit
-- we scroll to closest slide
--
function AxisMotion:do_state_decelerate( params )
	print( "AxisMotion:do_state_decelerate" )
	params = params or {}
	--==--
	local TIME = AxisMotion.DECELERATE_TRANS_TIME
	local ease_f = easingx.easeOut
	local _mabs = mabs

	local startEvt = params.event

	local vel = self._velocity

	local velocity = vel.value
	local deltaVel = -velocity

	self._isMoving = true

	local enterFrameFunc = function( e )
		print( "AxisMotion: enterFrameFunc: do_state_decelerate" )

		local frameEvt = self._tmpFrameEvent
		local scrollLimit = self._scrollLimit

		local deltaStart = e.time - startEvt.time
		local deltaFrame = e.time - frameEvt.time
		local deltaVal

		--== Calculation

		vel.value = ease_f( deltaStart, TIME, velocity, deltaVel )
		deltaVal = vel.value * vel.vector * deltaFrame

		--== Action

		print( self._value, deltaVal, vel.value, scrollLimit )

		if vel.value > 0 and scrollLimit then
			-- we hit edge while moving
			self:gotoState( AxisMotion.STATE_RESTRAINT, { event=e } )

		elseif deltaStart < TIME and _mabs(deltaVal) >= 1 then
			-- movement is too small to see (pixel)
			self._value = self._value + deltaVal

		else
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
	print( "AxisMotion:state_decelerate: >> ", next_state )

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







-- when object has neither velocity nor limit
-- we scroll to closest slide
--
function AxisMotion:do_state_restore( params )
	print( "AxisMotion:do_state_restore" )
	params = params or {}
	--==--
	local startEvt = params.event

	local TIME = AxisMotion.RESTORE_TRANS_TIME
	local ease_f = easingx.easeOut

	local val = self._value
	local vel = self._velocity
	local scrollLimit = self._scrollLimit

	self._isMoving = true

	local delta

	-- calculate restore distance

	if scrollLimit == AxisMotion.HIT_UPPER_LIMIT then
		delta = val - self._upperOffset
	else
		delta = val - (self._scrollLength - self._length - self._lowerOffset)
	end

	-- take negative, return in other direction
	delta = -delta

	self._isMoving = true

	local enterFrameFunc = function( e )
		-- print( "AxisMotion: enterFrameFunc: do_state_restore " )

		--== Calculation

		local deltaT = e.time - startEvt.time
		local deltaV = ease_f( deltaT, TIME, val, delta )

		-- print( "ax", deltaV, deltaT, e.time, startEvt.time )

		--== Action

		if deltaT < TIME then
			self._value = deltaV
		else
			self._value = val + delta
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
	print( "AxisMotion:state_restore: >> ", next_state )

	if next_state == AxisMotion.STATE_TOUCH then
		self:do_state_touch( params )

	elseif next_state == AxisMotion.STATE_AT_REST then
		self:do_state_at_rest( params )

	else
		print( "WARNING :: AxisMotion:state_restore > " .. tostring( next_state ) )
	end

end





-- when object has velocity and hit limit
-- we constrain its motion away from limit
--
function AxisMotion:do_state_restraint( params )
	print( "AxisMotion:do_state_restraint" )
	params = params or {}
	--==--
	local TIME = AxisMotion.RESTRAINT_TRANS_TIME
	local ease_f = easingx.easeOut
	local _mabs = mabs

	-- startEvt could be Touch or enterFrame event
	-- we just need the 'time'
	local startEvt = params.event

	local vel = self._velocity
	local val = self._value

	local velocity = vel.value * vel.vector
	local deltaVel = -velocity

	self._isMoving = true


	local enterFrameFunc = function( e )
		print( "AxisMotion: enterFrameFunc: do_state_restraint" )

		local frameEvt = self._tmpFrameEvent

		local deltaStart = e.time - startEvt.time -- total
		local deltaFrame = e.time - frameEvt.time
		local deltaVal

		--== Calculation

		vel.value = ease_f( deltaStart, TIME, velocity, deltaVel )
		deltaVal = vel.value * deltaFrame

		--== Action

		if deltaStart < TIME and _mabs(deltaVal) >= 1 then
			self._value = val + deltaVal

		else
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
	print( "AxisMotion:state_restraint: >> ", next_state )

	if next_state == self.STATE_TOUCH then
		self:do_state_touch( params )

	elseif next_state == self.STATE_RESTORE then
		self:do_state_restore( params )

	else
		print( "WARNING :: AxisMotion:state_restraint > " .. tostring( next_state ) )
	end

end


return AxisMotion
