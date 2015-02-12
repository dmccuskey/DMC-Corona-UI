--====================================================================--
-- dmc_widgets/widget_popover/popover_mixin.lua
--
-- Documentation: http://docs.davidmccuskey.com/
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
--== DMC Corona Widgets : Popover Mixin
--====================================================================--


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.1.0"


--====================================================================--
--== imports


local Widgets = nil -- set later



--====================================================================--
--== Support Functions


function _patch( obj )

	obj = obj or {}

	-- add properties
	Popover.__init__( obj )

	-- add methods
	obj.resetPopover = Popover.resetPopover
	obj.setPopover = Popover.setPopover
	obj.setDebug = Popover.setDebug

	return obj
end



--====================================================================--
--== Popover Mixin
--====================================================================--


Popover = {}

Popover.NAME = "Popover Mixin"

--======================================================--
-- START: Mixin Setup for DMC Objects

function Popover.__init__( self, params )
	-- print( "Popover.__init__" )
	params = params or {}
	--==--
	Popover.resetPopover( self, params )
end

function Popover.__undoInit__( self )
	-- print( "Popover.__undoInit__" )
	Popover.resetPopover( self )
end

-- END: Mixin Setup for DMC Objects
--======================================================--



--====================================================================--
--== Public Methods


function Popover.resetPopover( self, params )
	params = params or {}
	if params.debug_on==nil then params.debug_on=false end
	--==--
	if self.__debug_on then
		print( outStr( "resetPopover: resetting popover" ) )
	end
	self.__popover = nil
	self.__debug_on = params.debug_on

	-- need to do these manually, because in setters/getters
	self.__setters.x = Popover.setX
	self.__getters.x = Popover.getX
	self.__setters.y = Popover.setY
	self.__getters.y = Popover.getY
end


--== Set/Remove

function Popover.createPopover( self, params )
	local o = Widgets.newPopover{
		delegate=self
	}
	self.__popover = o
	return o
end

function Popover.removePopover( self )
	self.__popover:removeSelf()
	self.__popover = nil
end


--== Show/Hide

function Popover.showPopover( self, pos, params )
	assert( pos, "PopoverMix:showPopover requires position object" )
	self.__popover:show( pos, params )
end

function Popover.hidePopover( self, params )
	self.__popover:hide( params )
end


--== X

function Popover.setX( self, value )
	assert( type(value)=='number' )
	self.__popover.x = value
end

function Popover.getX( self )
	return self.__popover.x
end


--== Y

function Popover.setY( self, value )
	assert( type(value)=='number' )
	self.__popover.y = value
end

function Popover.getY( self )
	return self.__popover.y
end


--== Dismiss

function Popover.isDismissed( self )
	-- pass
end

function Popover.shouldDismiss( self )
	return true
end




function Popover.setDebug( self, value )
	self.__debug_on = value
end



--====================================================================--
--== Popover Facade
--====================================================================--


local function setWidgetManager( manager )
	-- print( "setWidgetManager" )
	Widgets = manager
end


return {
	__setWidgetManager=setWidgetManager,
	PopoverMix=Popover,
	patch=_patch,
}



