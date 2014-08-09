--====================================================================--
-- button_group.lua
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
--== newButton: Button Groups
--====================================================================--


--====================================================================--
--== Imports

local Objects = require 'dmc_objects'
local Utils = require 'dmc_utils'


--====================================================================--
--== Setup, Constants

-- setup some aliases to make code cleaner
local inheritsFrom = Objects.inheritsFrom
local ObjectBase = Objects.ObjectBase

local LOCAL_DEBUG = false



--====================================================================--
--== Button Group Base Class
--====================================================================--


local GroupBase = inheritsFrom( ObjectBase )
GroupBase.NAME = "Button Group Base"

GroupBase.EVENT = 'button_group_event'
GroupBase.CHANGED = 'group_change'


--======================================================--
-- Start: Setup DMC Objects

function GroupBase:_init( params )
	-- print( "GroupBase:_init" )
	params = params or { }
	self:superCall( '_init', params )
	--==--

	--== Sanity Check ==--

	if self.is_intermediate then return end

	--== Create Properties ==--

	self._set_first_active = params.set_first_active == nil and true or params.set_first_active

	-- container for group buttons
	-- hashed on obj id
	self._buttons = {}
	self._selected = nil -- the selected button object

end

function GroupBase:_undoInit( params )
	-- print( "GroupBase:_undoInit" )

	self._selected = nil
	--==--
	self:superCall( '_undoInit' )
end

-- _initComplete()
--
function GroupBase:_initComplete()
	--print( "GroupBase:_initComplete" )
	self:superCall( '_initComplete' )
	--==--
	self._button_handler = self:createCallback( self._buttonEvent_handler )
end

function GroupBase:_undoInitComplete()
	--print( "GroupBase:_undoInitComplete" )
	self:_removeAllButtons()

	self._button_handler = nil
	--==--
	self:superCall( '_undoInitComplete' )
end

-- END: Setup DMC Objects
--======================================================--


--====================================================================--
--== Public Methods

-- we only want items inserted into proper layer
function GroupBase:add( obj, params )
	-- print( "GroupBase:add" )
	params = params or {}
	params.set_active = params.set_active == nil and false or params.set_active
	--==--
	local num = Utils.tableSize( self._buttons )

	if params.set_active or ( self._set_first_active and num==0 ) then
		obj:gotoState( obj.STATE_ACTIVE )
		self._selected = obj
	end

	obj:addEventListener( obj.EVENT, self._button_handler )
	local key = tostring( obj )
	self._buttons[ key ] = obj

end

function GroupBase:remove( obj )
	-- print( "GroupBase:remove" )

	local key = tostring( obj )
	self._buttons[ key ] = nil
	obj:removeEventListener( obj.EVENT, self._button_handler )

end

function GroupBase.__getters:selected()
	-- print( "GroupBase.__getters:selected" )
	return self._selected
end


--====================================================================--
--== Private Methods

function GroupBase:_setButtonGroupState( state )
	-- print( "GroupBase:_setButtonGroupState" )
	for _, button in pairs( self._buttons ) do
		button:gotoState( state )
	end
end

function GroupBase:_removeAllButtons()
	-- print( "GroupBase:_removeAllButtons" )
	for _, button in pairs( self._buttons ) do
		self:remove( button )
	end
end

function GroupBase:_dispatchChangeEvent( button )
	-- print( "GroupBase:_dispatchChangeEvent" )
	local evt = {
		button=button,
		id=button.id,
		state=button:getState()
	}
	self:dispatchEvent( self.CHANGED, evt )
end


--====================================================================--
--== Event Handlers

function GroupBase:_buttonEvent_handler( event )
	error( "OVERRIDE: GroupBase:_buttonEvent_handler" )
end





--====================================================================--
--== Radio Group Class
--====================================================================--


local RadioGroup = inheritsFrom( GroupBase )
RadioGroup.NAME = "Radio Group"

RadioGroup.TYPE = 'radio'


--======================================================--
-- Start: Setup DMC Objects

function RadioGroup:_init( params )
	-- print( "RadioGroup:_init" )
	params = params or { }
	self:superCall( '_init', params )
	--==--

	--== Create Properties ==--

	self._set_first_active = true
end

-- END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Private Methods


--====================================================================--
--== Event Handlers

function RadioGroup:_buttonEvent_handler( event )
	-- print( "RadioGroup:_buttonEvent_handler", event.phase )
	local button = event.target

	if self._selected == button then return end

	if event.phase ~= button.RELEASED then return end

	self:_setButtonGroupState( button.STATE_INACTIVE )
	button:gotoState( button.STATE_ACTIVE )

	self._selected = button
	self:_dispatchChangeEvent( button )
end




--====================================================================--
--== Toggle Group Class
--====================================================================--


local ToggleGroup = inheritsFrom( GroupBase )
ToggleGroup.NAME = "Toggle Group"

ToggleGroup.TYPE = 'toggle'


--======================================================--
-- Start: Setup DMC Objects

function ToggleGroup:_init( params )
	-- print( "ToggleGroup:_init" )
	params = params or {}
	self:superCall( '_init', params )
	--==--

	--== Create Properties ==--

	self._set_first_active = params.set_first_active == nil and false or params.set_first_active
end

-- END: Setup DMC Objects
--======================================================--


--====================================================================--
--== Public Methods


--====================================================================--
--== Private Methods


--====================================================================--
--== Event Handlers

function ToggleGroup:_buttonEvent_handler( event )
	-- print( "ToggleGroup:_buttonEvent_handler", event.phase )
	local button = event.target
	local state = button:getState()

	if event.phase ~= button.RELEASED then return end
	if self._selected ~= button and state == button.STATE_ACTIVE then
		self:_setButtonGroupState( button.STATE_INACTIVE )

		self._selected = button
		button:gotoState( button.STATE_ACTIVE )

	elseif self._selected == button and state == button.STATE_INACTIVE then
		self._selected = nil
	end

	self:_dispatchChangeEvent( button )
end





--===================================================================--
--== Button Group Factory
--===================================================================--


local ButtonGroup = {}

-- export class instantiations for direct access
ButtonGroup.GroupBase = GroupBase
ButtonGroup.RadioGroup = RadioGroup
ButtonGroup.ToggleGroup = ToggleGroup

function ButtonGroup.create( params )
	assert( params.type, "newButtonGroup: expected param 'type'" )
	--==--
	if params.type == RadioGroup.TYPE then
		return RadioGroup:new( params )

	elseif params.type == ToggleGroup.TYPE then
		return ToggleGroup:new( params )

	else
		error( "newButton: unknown button type: " .. tostring( params.type ) )

	end
end

return ButtonGroup

