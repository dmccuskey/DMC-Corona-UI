--====================================================================--
-- dmc_widgets/theme_manager/background_style.lua
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
--== DMC Corona Widgets : Widget Background Style
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
--== DMC Widgets : newBackgroundStyle
--====================================================================--



--====================================================================--
--== Imports


local Objects = require 'dmc_objects'

local BaseStyle = require( widget_find( 'theme_manager.base_style' ) )



--====================================================================--
--== Setup, Constants


local newClass = Objects.newClass
local ObjectBase = Objects.ObjectBase

local TextField -- set later



--====================================================================--
--== Background Style Class
--====================================================================--


local BackgroundStyle = newClass( BaseStyle, {name="Background Style"} )

--== Event Constants

-- Class.EVENT from super

BackgroundStyle.STYLE_UPDATED = 'style-updated'


--======================================================--
--== Start: Setup DMC Objects

function BackgroundStyle:__init__( params )
	-- print( "BackgroundStyle:__init__", params )
	params = params or {}
	self:superCall( '__init__', params )
	--==--

	--== Style Properties ==--

	-- self._name
	-- self._inherit
	-- self._data

	self._x = nil
	self._y = nil

	self._width = nil
	self._height = nil

	self._anchorX = nil
	self._anchorY = nil
	self._fillColor = nil
	self._isHitTestable = nil
	self._strokeColor = nil
	self._strokeWidth = nil

	self._onProperty = nil -- callback
end

--== END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Static Methods


function BackgroundStyle.__setWidgetManager( manager )
	-- print( "BackgroundStyle.__setWidgetManager" )
	Widgets = manager
end


function BackgroundStyle.createDefaultStyle()
	-- print( "BackgroundStyle.createDefaultStyle" )
	local default = {
		name="background-default-style",
		x=0,
		y=0,
		width=150,
		height=75,
		anchorX=0.5,
		anchorY=0.5,
		isHitTestable=true,
		strokeWidth=1,
		strokeColor={0,0,0,1},
		fillColor={0.5,0,0.1,1}
	}

	return BackgroundStyle:new( default )
end



--====================================================================--
--== Public Methods


--== anchorX

function BackgroundStyle.__getters:anchorX()
	local value = self._anchorX
	if value==nil and self._inherit then
		value = self._inherit._anchorX
	end
	return value
end
function BackgroundStyle.__setters:anchorX( value )
	-- print( 'BackgroundStyle.__setters:anchorX', value )
	assert( type(value)=='number' or (value==nil and self._inherit) )
	--==--
	if value==self._anchorX then return end
	self._anchorX = value
	self:_dispatchChangeEvent( 'anchorX', value )
end

--== anchorY

function BackgroundStyle.__getters:anchorY()
	local value = self._anchorY
	if value==nil and self._inherit then
		value = self._inherit._anchorY
	end
	return value
end
function BackgroundStyle.__setters:anchorY( value )
	-- print( 'BackgroundStyle.__setters:anchorY', value )
	assert( type(value)=='number' or (value==nil and self._inherit) )
	--==--
	if value==self._anchorY then return end
	self._anchorY = value
	self:_dispatchChangeEvent( 'anchorY', value )
end

--== fillColor

function BackgroundStyle.__getters:fillColor()
	local value = self._fillColor
	if value==nil and self._inherit then
		value = self._inherit._fillColor
	end
	return value
end
function BackgroundStyle.__setters:fillColor( value )
	-- print( "BackgroundStyle.__setters:fillColor", value )
	assert( value or (value==nil and self._inherit) )
	--==--
	self._fillColor = value
	self:_dispatchChangeEvent( 'fillColor', value )
end

--== X

function BackgroundStyle.__getters:x()
	local value = self._x
	if value==nil and self._inherit then
		value = self._inherit._x
	end
	return value
end
function BackgroundStyle.__setters:x( value )
	-- print( "BackgroundStyle.__setters:x", value )
	assert( type(value)=='number' or (value==nil and self._inherit) )
	--==--
	if value == self._x then return end
	self._x = value
	self:_dispatchChangeEvent( 'x', value )
end

--== Y

function BackgroundStyle.__getters:y()
	local value = self._y
	if value==nil and self._inherit then
		value = self._inherit._y
	end
	return value
end
function BackgroundStyle.__setters:y( value )
	-- print( "BackgroundStyle.__setters:y", value )
	assert( type(value)=='number' or (value==nil and self._inherit) )
	--==--
	if value == self._y then return end
	self._y = value
	self:_dispatchChangeEvent( 'y', value )
end

--== isHitTestable

function BackgroundStyle.__getters:isHitTestable()
	local value = self._isHitTestable
	if value==nil and self._inherit then
		value = self._inherit._isHitTestable
	end
	return value
end
function BackgroundStyle.__setters:isHitTestable( value )
	-- print( "BackgroundStyle.__setters:isHitTestable", value )
	assert( type(value)=='boolean' or (value==nil and self._inherit) )
	--==--
	if value==self._isHitTestable then return end
	self._isHitTestable = value
	self:_dispatchChangeEvent( 'isHitTestable', value )
end

--== onProperty

function BackgroundStyle.__setters:onProperty( value )
	-- print( "BackgroundStyle.__setters:onProperty", value )
	self._onProperty = value
end

--== width

function BackgroundStyle.__getters:width()
	local value = self._width
	if value==nil and self._inherit then
		value = self._inherit._width
	end
	return value
end
function BackgroundStyle.__setters:width( value )
	-- print( "BackgroundStyle.__setters:width", value )
	assert( type(value)=='number' or (value==nil and self._inherit) )
	--==--
	if value == self._width then return end
	self._width = value
	self:_dispatchChangeEvent( 'width', value )
end

--== height

function BackgroundStyle.__getters:height()
	local value = self._height
	if value==nil and self._inherit then
		value = self._inherit._height
	end
	return value
end
function BackgroundStyle.__setters:height( value )
	-- print( "BackgroundStyle.__setters:height", value )
	assert( type(value)=='number' or (value==nil and self._inherit) )
	--==--
	if value == self._height then return end
	self._height = value
	self:_dispatchChangeEvent( 'height', value )
end

--== strokeColor

function BackgroundStyle.__getters:strokeColor()
	local value = self._strokeColor
	if value==nil and self._inherit then
		value = self._inherit._strokeColor
	end
	return value
end
function BackgroundStyle.__setters:strokeColor( value )
	-- print( "BackgroundStyle.__setters:strokeColor", value )
	assert( value or (value==nil and self._inherit) )
	--==--
	self._strokeColor = value
	self:_dispatchChangeEvent( 'strokeColor', value )
end

--== strokeWidth

function BackgroundStyle.__getters:strokeWidth( value )
	local value = self._strokeWidth
	if value==nil and self._inherit then
		value = self._inherit._strokeWidth
	end
	return value
end
function BackgroundStyle.__setters:strokeWidth( value )
	-- print( "BackgroundStyle.__setters:strokeWidth", value )
	assert( type(value)=='number' or (value==nil and self._inherit) )
	--==--
	if value == self._strokeWidth then return end
	self._strokeWidth = value
	self:_dispatchChangeEvent( 'strokeWidth', value )

end


--== updateStyle

function BackgroundStyle:updateStyle( params )
	-- print( "BackgroundStyle:updateStyle" )

	--== Widget-level
	if params.x~=nil then self.x=params.x end
	if params.y~=nil then self.y=params.y end

end



--====================================================================--
--== Private Methods


function BackgroundStyle:_checkProperties()
	BaseStyle._checkProperties( self )
	assert( self.x, "Style: requires 'x'" )
	assert( self.y, "Style: requires 'y'" )
	assert( self.anchorX, "Style: requires 'anchorX'" )
	assert( self.anchorY, "Style: requires 'anchory'" )
end


function BackgroundStyle:_dispatchChangeEvent( prop, value )
	-- print( 'BackgroundStyle:_dispatchChangeEvent', prop, value )
	--==--
	local e = {
		name=self.EVENT,
		type=self.STYLE_UPDATED,
		property=prop,
		value=value
	}
	if self._onProperty then self._onProperty( e ) end
end



--====================================================================--
--== Event Handlers


-- none




return BackgroundStyle
