--====================================================================--
-- dmc_ui/dmc_control/core/view_control.lua
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
--== DMC Corona UI : View Control Base
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


local LifecycleMixModule = require 'dmc_lifecycle_mix'
local Objects = require 'dmc_objects'
local Patch = require 'dmc_patch'
local uiConst = require( ui_find( 'ui_constants' ) )



--====================================================================--
--== Setup, Constants


Patch.addPatch( 'table-pop' )

-- setup some aliases to make code cleaner
local newClass = Objects.newClass
local ComponentBase = Objects.ComponentBase

local LifecycleMix = LifecycleMixModule.LifecycleMix

local tpop = table.pop

--== To be set in initialize()
local dUI = nil



--====================================================================--
--== View Control Base Class
--====================================================================--


local ViewControl = newClass(
	{ ComponentBase, LifecycleMix }, {name="View Control"}
)

--== Event Constants

ViewControl.EVENT = 'view-control-event'


--======================================================--
-- Start: Setup DMC Objects

function ViewControl:__init__( params )
	-- print( "ViewControl:__init__" )
	params = params or {}
	if params.x==nil then params.x=0 end
	if params.y==nil then params.y=0 end

	self:superCall( LifecycleMix, '__init__', params )
	self:superCall( ComponentBase, '__init__', params )
	--==--

	--== Create Properties ==--

	self._width = params.width or dUI.WIDTH
	self._height = params.height or dUI.HEIGHT

	self._modalStyle = params.modalStyle
	self._preferredContentSize = params.preferredContentSize

	--[[
	the Control's parent, or nil if Control is presented
	--]]
	self._parentControl = nil

	--[[
	the popover view control in the hierarchy
	nil if not presented by popover
	--]]
	self._popoverControl = nil

	--[[
	the Control being presented
	--]]
	self._presentedControl = nil

end

function ViewControl:__undoInit__()
	--print( "ViewControl:__undoInit__" )
	--==--
	self:superCall( ComponentBase, '__undoInit__' )
	self:superCall( LifecycleMix, '__undoInit__' )
end


function ViewControl:__createView__()
	-- print( "ViewControl:__createView__" )
	self:superCall( ComponentBase, '__createView__' )
	--==--
end

function ViewControl:__undoCreateView__()
	-- print( "ViewControl:__undoCreateView__" )
	--==--
	self:superCall( ComponentBase, '__undoCreateView__' )
end


--== initComplete

function ViewControl:__initComplete__()
	-- print( "ViewControl:__initComplete__" )
	self:superCall( ComponentBase, '__initComplete__' )
	--==--
end

function ViewControl:__undoInitComplete__()
	-- print( "ViewControl:__undoInitComplete__" )
	--==--
	self:superCall( ComponentBase, '__undoInitComplete__' )
end

-- END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Static Methods


function ViewControl.initialize( manager )
	-- print( "ViewControl.initialize" )
	dUI = manager
end



--====================================================================--
--== Public Methods


--== .width

function ViewControl:_widthChanged()
	-- print( "OVERRIDE ViewControl:_widthChanged" )
end
function ViewControl.__getters:width()
	return self._width
end
function ViewControl.__setters:width( value )
	self._width = value
	self:_widthChanged()
end

--== .height

function ViewControl:_heightChanged()
	-- print( "OVERRIDE ViewControl:_heightChanged" )
end
function ViewControl.__getters:height()
	return self._height
end
function ViewControl.__setters:height( value )
	-- print( "ViewControl.__setters:height", value )
	self._height = value
	self:_heightChanged()
end

--== .modalStyle

function ViewControl.__getters:modalStyle()
	-- print( "ViewControl.__getters:modalStyle" )
	return self._modalStyle
end
function ViewControl.__setters:modalStyle( value )
	-- print( "ViewControl.__setters:modalStyle" )
	if value == self._modalStyle then return end

	self._modalStyle = value

	if value == dUI.POPOVER then
		self:_createPopoverControl()
	else
		self._destroyPopoverControl()
	end
end

--== .preferredContentSize

function ViewControl.__getters:preferredContentSize()
	-- print( "ViewControl.__getters:preferredContentSize" )
	return self._preferredContentSize
end
function ViewControl.__setters:preferredContentSize( value )
	-- print( "ViewControl.__setters:preferredContentSize" )
	value = value or {}
	assert( value.width and value.height )
	--==--
	self._preferredContentSize = value
end

--== .popoverControl

function ViewControl.__getters:popoverControl()
	-- print( "ViewControl.__getters:popoverControl" )
	return self._popoverControl
end

--== .presentedControl

function ViewControl.__getters:presentedControl( value )
	-- print( "ViewControl.__getters:presentedControl" )
	self._presentedControl = value
end



function ViewControl:presentControl( params )
	-- print( "ViewControl:presentControl" )
	params = params or {}
	if params.animated==nil then params.animated=true end
	if params.control==nil then params.control = self end
	-- params.onComplete = params.onComplete
	--==--
	local control = tpop( params, 'control' )

	-- set vars on object
	self._parentControl = nil
	self._presentedControl = control

	-- resize control view
	local pcS = self.preferredContentSize
	control.width, control.height = pcS.width, 400 --pcS.height

	local popCtl = self._popoverControl
	popCtl:init( self._presentedControl, self )
	popCtl:presentControl( params )
end

function ViewControl:dismissControl( params )
	-- print( "ViewControl:dismissControl" )
	params = params or {}
	if params.animated==nil then params.animated=true end
	-- params.onComplete = params.onComplete
	--==--
	self._popoverControl:dismissControl( params )
end


--[[
function ViewControl:viewIsVisible( value )
	-- print( "ViewControl:viewIsVisible" )
	local o = self._current_view
	if o and o.viewIsVisible then o:viewIsVisible( value ) end
end

function ViewControl:viewInMotion( value )
	-- print( "ViewControl:viewInMotion" )
	local o = self._current_view
	if o and o.viewInMotion then o:viewInMotion( value ) end
end
--]]



--====================================================================--
--== Private Methods


function ViewControl:_destroyPopoverControl()
	-- print( "ViewControl:_destroyPopoverControl" )
	local o = self._popoverControl
	if not o then return end
	o:removeSelf()
	self._popoverControl = nil
end


function ViewControl:_createPopoverControl()
	-- print( "ViewControl:_createPopoverControl" )
	self:_destroyPopoverControl()
	self._popoverControl = dUI.Control.newPopoverControl()
	self.preferredContentSize = uiConst.POPOVER_PREFERRED_SIZE
end



--======================================================--
-- DMC Lifecycle Methods

function ViewControl:__commitProperties__()
	-- print( "ViewControl:__commitProperties__" )
end



--====================================================================--
--== Event Handlers


-- none



return ViewControl
