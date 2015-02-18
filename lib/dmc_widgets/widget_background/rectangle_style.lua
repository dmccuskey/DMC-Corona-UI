--====================================================================--
-- dmc_widgets/widget_style/rectangle_style.lua
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
--== DMC Corona Widgets : Rectangle Background Style
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
--== DMC Widgets : newRectangleBackgroundStyle
--====================================================================--



--====================================================================--
--== Imports


local Objects = require 'dmc_objects'
local Utils = require 'dmc_utils'

local BaseStyle = require( widget_find( 'widget_style.base_style' ) )



--====================================================================--
--== Setup, Constants


local newClass = Objects.newClass
local ObjectBase = Objects.ObjectBase

local Widgets = nil -- set later



--====================================================================--
--== Rectangle Background Style Class
--====================================================================--


local RectangleStyle = newClass( BaseStyle, {name="Rectangle Background Style"} )

--== Class Constants

RectangleStyle.TYPE = 'rectangle'

RectangleStyle.__base_style__ = nil

RectangleStyle.DEFAULT = {
	name='rectangle-background-default-style',
	debugOn=false,

	width=75,
	height=30,

	type=RectangleStyle.TYPE,

	anchorX=0.5,
	anchorY=0.5,
	fillColor={1,1,1,1},
	strokeColor={0,0,0,1},
	strokeWidth=0,
}

--== Event Constants

RectangleStyle.EVENT = 'rectangle-background-style-event'

-- from super
-- Class.STYLE_UPDATED


--======================================================--
-- Start: Setup DMC Objects

function RectangleStyle:__init__( params )
	-- print( "RectangleStyle:__init__", params )
	params = params or {}
	self:superCall( '__init__', params )
	--==--

	--== Style Properties ==--

	-- self._data
	-- self._inherit
	-- self._widget
	-- self._parent
	-- self._onProperty

	-- self._name
	-- self._debugOn

	--== Local style properties

	self._width = nil
	self._height = nil

	self._type = nil

	self._anchorX = nil
	self._anchorY = nil
	self._fillColor = nil
	self._strokeColor = nil
	self._strokeWidth = nil
end

-- END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Static Methods


function RectangleStyle.initialize( manager )
	-- print( "RectangleStyle.initialize", manager )
	Widgets = manager

	RectangleStyle._setDefaults()
end


function RectangleStyle._setDefaults()
	-- print( "RectangleStyle._setDefaults" )
	local defaults = RectangleStyle.DEFAULT
	local style = RectangleStyle:new{
		data=defaults
	}
	RectangleStyle.__base_style__ = style
end



-- copyMissingProperties()
-- copies properties from src structure to dest structure
-- if property isn't already in dest
-- Note: usually used by OTHER classes
--
function RectangleStyle.copyMissingProperties( dest, src )
	-- print( "RectangleStyle.copyMissingProperties", dest, src )
	-- Utils.print( src )
	if dest.debugOn==nil then dest.debugOn=src.debugOn end

	if dest.width==nil then dest.width=src.width end
	if dest.height==nil then dest.height=src.height end

	if dest.anchorX==nil then dest.anchorX=src.anchorX end
	if dest.anchorY==nil then dest.anchorY=src.anchorY end
	if dest.fillColor==nil then dest.fillColor=src.fillColor end
	if dest.strokeColor==nil then dest.strokeColor=src.strokeColor end
	if dest.strokeWidth==nil then dest.strokeWidth=src.strokeWidth end
end



--====================================================================--
--== Public Methods


--======================================================--
-- Access to style properties

--== type

function RectangleStyle.__getters:type()
	-- print( "RectangleStyle.__getters:type" )
	local value = self._type
	-- TODO, check inheritance
	if value==nil and self._inherit then
		value = self._inherit.type
	end
	return value
end
function RectangleStyle.__setters:type( value )
	-- print( "RectangleStyle.__setters:type", value )
	assert( type(value)=='string' or (value==nil and self._inherit) )
	--==--
	if value==self._type then return end
	self._type = value
	self:_dispatchChangeEvent( 'type', value )
end


--======================================================--
-- Misc

--== updateStyle

-- force is used when making exact copy of data
--
function RectangleStyle:updateStyle( src, params )
	-- print( "RectangleStyle:updateStyle", src )
	params = params or {}
	if params.force==nil then params.force=true end
	--==--
	local force=params.force

	if src.debugOn~=nil or force then self.debugOn=src.debugOn end

	if src.width~=nil or force then self.width=src.width end
	if src.height~=nil or force then self.height=src.height end

	if src.anchorX~=nil or force then self.anchorX=src.anchorX end
	if src.anchorY~=nil or force then self.anchorY=src.anchorY end
	if src.fillColor~=nil or force then self.fillColor=src.fillColor end
	if src.strokeColor~=nil or force then self.strokeColor=src.strokeColor end
	if src.strokeWidth~=nil or force then self.strokeWidth=src.strokeWidth end
end



--====================================================================--
--== Private Methods


function RectangleStyle:_checkProperties()
	-- print( "RectangleStyle._checkProperties" )

	BaseStyle._checkProperties( self )

	assert( self.width, "Style: requires property'width'" )
	assert( self.height, "Style: requires property 'height'" )

	assert( self.type, "Style: requires property 'type'" )

	assert( self.anchorX, "Style: requires property'anchorX'" )
	assert( self.anchorY, "Style: requires property 'anchory'" )
	assert( self.fillColor, "Style: requires property 'fillColor'" )
	assert( self.strokeColor, "Style: requires property 'strokeColor'" )
	assert( self.strokeWidth, "Style: requires property 'strokeWidth'" )
end



--====================================================================--
--== Event Handlers


-- none




return RectangleStyle
