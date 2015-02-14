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
--== DMC Widgets : newTextStyle
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


local TextStyle = newClass( BaseStyle, {name="Background Style"} )

--== Event Constants

-- Class.EVENT from super

TextStyle.STYLE_UPDATED = 'style-updated'

TextStyle.DEFAULT = {
	name='text-default-style',
	x=0,
	y=0,
	width=nil,
	height=nil,
	align='center',
	anchorX=0.5,
	anchorY=0.5,
	fillColor={1,1,1,0},
	font=native.systemFont,
	fontSize=24,
	marginX=0,
	marginY=0,
	strokeColor={0,0,0,1},
	strokeWidth=0,
	textColor={0,0,0,1}
}


--======================================================--
--== Start: Setup DMC Objects

function TextStyle:__init__( params )
	-- print( "TextStyle:__init__", params )
	params = params or {}
	self:superCall( '__init__', params )
	--==--

	--== Style Properties ==--

	-- self._data
	-- self._inherit

	-- self._name
	-- self._x
	-- self._y

	self._width = nil
	self._height = nil

	self._align = nil
	self._anchorX = nil
	self._anchorY = nil
	self._fillColor = nil
	self._font = nil
	self._fontSize = nil
	self._marginX = nil
	self._marginY = nil
	self._strokeColor = nil
	self._strokeWidth = nil
	self._textColor = nil

	self._onProperty = nil -- callback
end

--== END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Static Methods


function TextStyle.setDefaults()
	-- print( "TextStyle.setDefaults" )
	local def = TextStyle.DEFAULT

	TextStyle._name=def.name

	TextStyle._x=def.x
	TextStyle._y=def.y
	TextStyle._width=def.width
	TextStyle._height=def.height

	TextStyle._align=def.align
	TextStyle._anchorX=def.anchorX
	TextStyle._anchorY=def.anchorY
	TextStyle._fillColor=def.fillColor
	TextStyle._font=def.font
	TextStyle._fontSize=def.fontSize
	TextStyle._marginX=def.marginX
	TextStyle._marginY=def.marginY
	TextStyle._strokeColor=def.strokeColor
	TextStyle._strokeWidth=def.strokeWidth
	TextStyle._textColor=def.textColor
end

function TextStyle.__setWidgetManager( manager )
	-- print( "TextStyle.__setWidgetManager" )
	Widgets = manager
end


function TextStyle.copyStyle()
	local o = TextStyle:new()
	o.inherit = TextStyle
	return o
end

-- make a copy of the current style setting
-- same information and inheritance
--
function TextStyle:clone()
	local o = TextStyle:new()
	o:updateStyle( self, true )
	o.inherit = self._inherit
	return o
end

-- create a new style setting
-- inheritance to current style
--
function TextStyle:inherit()
	local o = TextStyle:new()
	o.inherit = self
	return o
end


--== updateStyle

-- force is used when making exact copy of data
--
function TextStyle:updateStyle( info, force )
	-- print( "TextStyle:updateStyle" )
	if force==nil then force=true end
	--==--
	if info.x~=nil then self.x=info.x end
	if info.y~=nil then self.y=info.y end
	if info.width~=nil then self.width=info.width end
	if info.height~=nil then self.height=info.height end

	if info.align~=nil then self.align=info.align end
	if info.anchorX~=nil then self.anchorX=info.anchorX end
	if info.anchorY~=nil then self.anchorY=info.anchorY end
	if info.fillColor~=nil then self.fillColor=info.fillColor end
	if info.font~=nil then self.font=info.font end
	if info.fontSize~=nil then self.fontSize=info.fontSize end
	if info.marginX~=nil then self.marginX=info.marginX end
	if info.marginY~=nil then self.marginY=info.marginY end
	if info.strokeColor~=nil then self.strokeColor=info.strokeColor end
	if info.strokeWidth~=nil then self.strokeWidth=info.strokeWidth end
	if info.textColor~=nil then self.textColor=info.textColor end
end



--====================================================================--
--== Public Methods


--== onProperty

-- callback, on property change
--
function TextStyle.__setters:onProperty( value )
	-- print( "TextStyle.__setters:onProperty", value )
	self._onProperty = value
end


--== align

function TextStyle.__getters:align()
	local value = self._align
	if value==nil and self._inherit then
		value = self._inherit._align
	end
	return value
end
function TextStyle.__setters:align( value )
	-- print( 'TextStyle.__setters:align', value )
	assert( type(value)=='string' or (value==nil and self._inherit) )
	--==--
	if value==self._align then return end
	self._align = value
	self:_dispatchChangeEvent( 'align', value )
end

--== anchorX

function TextStyle.__getters:anchorX()
	local value = self._anchorX
	if value==nil and self._inherit then
		value = self._inherit._anchorX
	end
	return value
end
function TextStyle.__setters:anchorX( value )
	-- print( 'TextStyle.__setters:anchorX', value )
	assert( type(value)=='number' or (value==nil and self._inherit) )
	--==--
	if value==self._anchorX then return end
	self._anchorX = value
	self:_dispatchChangeEvent( 'anchorX', value )
end

--== anchorY

function TextStyle.__getters:anchorY()
	local value = self._anchorY
	if value==nil and self._inherit then
		value = self._inherit._anchorY
	end
	return value
end
function TextStyle.__setters:anchorY( value )
	-- print( 'TextStyle.__setters:anchorY', value )
	assert( type(value)=='number' or (value==nil and self._inherit) )
	--==--
	if value==self._anchorY then return end
	self._anchorY = value
	self:_dispatchChangeEvent( 'anchorY', value )
end

--== fillColor

function TextStyle.__getters:fillColor()
	local value = self._fillColor
	if value==nil and self._inherit then
		value = self._inherit._fillColor
	end
	return value
end
function TextStyle.__setters:fillColor( value )
	-- print( "TextStyle.__setters:fillColor", value )
	assert( value or (value==nil and self._inherit) )
	--==--
	self._fillColor = value
	self:_dispatchChangeEvent( 'fillColor', value )
end

--== font

function TextStyle.__getters:font()
	local value = self._font
	if value==nil and self._inherit then
		value = self._inherit._font
	end
	return value
end
function TextStyle.__setters:font( value )
	-- print( "TextStyle.__setters:font", value )
	assert( value or (value==nil and self._inherit) )
	--==--
	self._font = value
	self:_dispatchChangeEvent( 'font', value )
end

--== fontSize

function TextStyle.__getters:fontSize()
	local value = self._fontSize
	if value==nil and self._inherit then
		value = self._inherit._fontSize
	end
	return value
end
function TextStyle.__setters:fontSize( value )
	-- print( "TextStyle.__setters:fontSize", value )
	assert( type(value)=='number' or (value==nil and self._inherit) )
	--==--
	self._fontSize = value
	self:_dispatchChangeEvent( 'fontSize', value )
end

--== marginX

function TextStyle.__getters:marginX()
	local value = self._marginX
	if value==nil and self._inherit then
		value = self._inherit._marginX
	end
	return value
end
function TextStyle.__setters:marginX( value )
	-- print( "TextStyle.__setters:marginX", value )
	assert( type(value)=='number' or (value==nil and self._inherit) )
	--==--
	self._marginX = value
	self:_dispatchChangeEvent( 'marginX', value )
end

--== marginY

function TextStyle.__getters:marginY()
	local value = self._marginY
	if value==nil and self._inherit then
		value = self._inherit._marginY
	end
	return value
end
function TextStyle.__setters:marginY( value )
	-- print( "TextStyle.__setters:marginY", value )
	assert( type(value)=='number' or (value==nil and self._inherit) )
	--==--
	self._marginY = value
	self:_dispatchChangeEvent( 'marginY', value )
end

--== strokeColor

function TextStyle.__getters:strokeColor()
	local value = self._strokeColor
	if value==nil and self._inherit then
		value = self._inherit._strokeColor
	end
	return value
end
function TextStyle.__setters:strokeColor( value )
	-- print( "TextStyle.__setters:strokeColor", value )
	assert( value or (value==nil and self._inherit) )
	--==--
	self._strokeColor = value
	self:_dispatchChangeEvent( 'strokeColor', value )
end

--== strokeWidth

function TextStyle.__getters:strokeWidth( value )
	local value = self._strokeWidth
	if value==nil and self._inherit then
		value = self._inherit._strokeWidth
	end
	return value
end
function TextStyle.__setters:strokeWidth( value )
	-- print( "TextStyle.__setters:strokeWidth", value )
	assert( type(value)=='number' or (value==nil and self._inherit) )
	--==--
	if value == self._strokeWidth then return end
	self._strokeWidth = value
	self:_dispatchChangeEvent( 'strokeWidth', value )

end

--== textColor

function TextStyle.__getters:textColor()
	local value = self._textColor
	if value==nil and self._inherit then
		value = self._inherit._textColor
	end
	return value
end
function TextStyle.__setters:textColor( value )
	-- print( "TextStyle.__setters:textColor", value )
	assert( value or (value==nil and self._inherit) )
	--==--
	if value == self._textColor then return end
	self._textColor = value
	self:_dispatchChangeEvent( 'textColor', value )
end



--====================================================================--
--== Private Methods


function TextStyle:_checkProperties()
	BaseStyle._checkProperties( self )
	assert( self.x, "Style: requires 'x'" )
	assert( self.y, "Style: requires 'y'" )
	--[[
	we don't check for width/height because we'll
	just use width/height of the text object
	-- assert( self.width, "Style: requires 'width'" )
	-- assert( self.height, "Style: requires 'height'" )
	--]]
	assert( self.align, "Style: requires 'align'" )
	assert( self.anchorY, "Style: requires 'anchory'" )
	assert( self.anchorX, "Style: requires 'anchorX'" )
	assert( self.fillColor, "Style: requires 'fillColor'" )
	assert( self.font, "Style: requires 'font'" )
	assert( self.fontSize, "Style: requires 'fontSize'" )
	assert( self.marginX, "Style: requires 'marginX'" )
	assert( self.marginY, "Style: requires 'marginY'" )
	assert( self.strokeColor, "Style: requires 'strokeColor'" )
	assert( self.strokeWidth, "Style: requires 'strokeWidth'" )
	assert( self.textColor, "Style: requires 'textColor'" )
end


function TextStyle:_dispatchChangeEvent( prop, value )
	-- print( 'TextStyle:_dispatchChangeEvent', prop, value )
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


TextStyle.setDefaults()




return TextStyle
