--====================================================================--
-- dmc_widgets/base_style.lua
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
--== DMC Corona Widgets : Base Widget Style
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
--== DMC Widgets : newStyle Base
--====================================================================--



--====================================================================--
--== Imports


local Objects = require 'dmc_objects'



--====================================================================--
--== Setup, Constants


-- setup some aliases to make code cleaner
local newClass = Objects.newClass
local ObjectBase = Objects.ObjectBase



--====================================================================--
--== Style Base Class
--====================================================================--


local Style = newClass( ObjectBase, {name="Style Base"}  )

Style.EVENT = 'style-event'

Style.STYLE_UPDATED = 'style-updated-event'


--======================================================--
--== Start: Setup DMC Objects

function Style:__init__( params )
	-- print( "Style:__init__", params )
	params = params or {}
	self:superCall( '__init__', params )
	--==--
	self._inherit = params.inherit
	self._data = params

	self._onProperty = nil
	self._name = params.name
end

function Style:__initComplete__()
	-- print( "Style:__initComplete__" )
	self:superCall( '__initComplete__' )
	--==--
	self:_parseData( self._data )
	self:_checkProperties()
end



--====================================================================--
--== Public Methods


-- make a copy of the current style setting
-- same information and inheritance
--
function Style:cloneStyle()
	local o = self.class:new({inherit=self._inherit})
	o:updateStyle( self, true )
	return o
end


-- create a new style, setting
-- inheritance to current style
--
function Style:copyStyle()
	local o = self.class:new({inherit=self})
	return o
end
Style.inheritStyle=Style.copyStyle


--== onProperty

-- callback, on property change
--
function Style.__setters:onProperty( value )
	-- print( "Style.__setters:onProperty", value )
	self._onProperty = value
end



--== name, getter/setter

function Style.__getters:name()
	-- print( 'Style.__getters:name', self._inherit )
	local value = self._name
	if value==nil and self._inherit then
		value = self._inherit.name
	end
	return value
end
function Style.__setters:name( value )
	-- print( 'Style.__setters:name', value )
	assert( (value==nil and self._inherit) or type(value)=='string' )
	--==--
	if value == self._name then return end
	self._name = value
end


--== X

function Style.__getters:x()
	local value = self._x
	if value==nil and self._inherit then
		value = self._inherit._x
	end
	return value
end
function Style.__setters:x( value )
	-- print( "Style.__setters:x", value )
	assert( type(value)=='number' or (value==nil and self._inherit) )
	--==--
	if value == self._x then return end
	self._x = value
	self:_dispatchChangeEvent( 'x', value )
end

--== Y

function Style.__getters:y()
	local value = self._y
	if value==nil and self._inherit then
		value = self._inherit._y
	end
	return value
end
function Style.__setters:y( value )
	-- print( "Style.__setters:y", value )
	assert( type(value)=='number' or (value==nil and self._inherit) )
	--==--
	if value == self._y then return end
	self._y = value
	self:_dispatchChangeEvent( 'y', value )
end

--== width

function Style.__getters:width()
	local value = self._width
	if value==nil and self._inherit then
		value = self._inherit._width
	end
	return value
end
function Style.__setters:width( value )
	-- print( "Style.__setters:width", value )
	assert( type(value)=='number' or (value==nil and self._inherit) )
	--==--
	if value == self._width then return end
	self._width = value
	self:_dispatchChangeEvent( 'width', value )
end

--== height

function Style.__getters:height()
	local value = self._height
	if value==nil and self._inherit then
		value = self._inherit._height
	end
	return value
end
function Style.__setters:height( value )
	-- print( "Style.__setters:height", value )
	assert( type(value)=='number' or (value==nil and self._inherit) )
	--==--
	if value == self._height then return end
	self._height = value
	self:_dispatchChangeEvent( 'height', value )
end




--====================================================================--
--== Private Methods


function Style:_dispatchChangeEvent( prop, value )
	-- print( 'Style:_dispatchChangeEvent', prop, value )
	--==--
	local e = {
		name=self.EVENT,
		type=self.STYLE_UPDATED,
		property=prop,
		value=value
	}
	if self._onProperty then self._onProperty( e ) end
end


function Style:_createDefaultStyle()
	assert( self.name, "Style: requires a namex" )
end


function Style:_checkProperties()
	assert( self.name, "Style: requires a name" )
end


function Style:_parseData( data )
	-- print( "Style:_parseData", data )
	for k,v in pairs( data ) do
		-- print(k,v)
		self[k]=v
	end
end



--====================================================================--
--== Event Handlers


-- none



return Style
