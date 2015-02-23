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

local sformat = string.format
local tinsert = table.insert

--== To be set in initialize()
local Widgets = nil



--====================================================================--
--== Rectangle Background Style Class
--====================================================================--


local RectangleStyle = newClass( BaseStyle, {name="Rectangle Background Style"} )

--== Class Constants

RectangleStyle.TYPE = 'rectangle'

RectangleStyle.__base_style__ = nil -- set in initialize()

RectangleStyle._VALID_PROPERTIES = {
	debugOn=true,
	width=true,
	height=true,
	anchorX=true,
	anchorY=true,

	type=true,
	fillColor=true,
	strokeColor=true,
	strokeWidth=true,
}

RectangleStyle._EXCLUDE_PROPERTY_CHECK = nil

RectangleStyle._STYLE_DEFAULTS = {
	name='rectangle-background-default-style',
	debugOn=false,
	width=75,
	height=30,
	anchorX=0.5,
	anchorY=0.5,

	type=RectangleStyle.TYPE,

	fillColor={1,1,1,1},
	strokeColor={0,0,0,1},
	strokeWidth=0
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
	-- self._width
	-- self._height
	-- self._anchorX
	-- self._anchorY

	self._type = nil

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

	RectangleStyle._setDefaults( RectangleStyle )
end


function RectangleStyle.addMissingDestProperties( dest, src, params )
	-- print( "RectangleStyle.addMissingDestProperties", dest, src )
	params = params or {}
	if params.force==nil then params.force=false end
	assert( dest )
	--==--
	local force=params.force
	local srcs = { RectangleStyle._STYLE_DEFAULTS }
	if src then tinsert( srcs, 1, src ) end

	for i=1,#srcs do
		local src = srcs[i]

		if dest.debugOn==nil or force then dest.debugOn=src.debugOn end

		if dest.width==nil or force then dest.width=src.width end
		if dest.height==nil or force then dest.height=src.height end

		if dest.anchorX==nil or force then dest.anchorX=src.anchorX end
		if dest.anchorY==nil or force then dest.anchorY=src.anchorY end
		if dest.fillColor==nil or force then dest.fillColor=src.fillColor end
		if dest.strokeColor==nil or force then dest.strokeColor=src.strokeColor end
		if dest.strokeWidth==nil or force then dest.strokeWidth=src.strokeWidth end

	end

	return dest
end


function RectangleStyle.copyExistingSrcProperties( dest, src, params )
	-- print( "RectangleStyle.copyExistingSrcProperties", dest, src )
	assert( dest )
	if not src then return end
	params = params or {}
	if params.force==nil then params.force=false end
	--==--
	local force=params.force

	if (src.debugOn~=nil and dest.debugOn==nil) or force then
		src.debugOn=src.debugOn
	end
	if (src.width~=nil and dest.width==nil) or force then
		src.width=src.width
	end
	if (src.height~=nil and dest.height==nil) or force then
		src.height=src.height
	end
	if (src.anchorX~=nil and dest.anchorX==nil) or force then
		src.anchorX=src.anchorX
	end
	if (src.anchorY~=nil and dest.anchorY==nil) or force then
		src.anchorY=src.anchorY
	end
	if (src.fillColor~=nil and dest.fillColor==nil) or force then
		src.fillColor=src.fillColor
	end
	if (src.strokeColor~=nil and dest.strokeColor==nil) or force then
		src.strokeColor=src.strokeColor
	end
	if (src.strokeWidth~=nil and dest.strokeWidth==nil) or force then
		src.strokeWidth=src.strokeWidth
	end

	return dest
end


function RectangleStyle._verifyStyleProperties( src )
	print( "RectangleStyle._verifyStyleProperties", src )
	local emsg = "Style requires property '%s'"

	local is_valid = BaseStyle._verifyStyleProperties( src )

	if not src.fillColor then
		print(sformat(emsg,'fillColor')) ; is_valid=false
	end
	if not src.strokeColor then
		print(sformat(emsg,'strokeColor')) ; is_valid=false
	end
	if not src.strokeWidth then
		print(sformat(emsg,'strokeWidth')) ; is_valid=false
	end

	return is_valid
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
	RectangleStyle.copyExistingSrcProperties( self, src, params )
end

--== verifyProperties

function RectangleStyle:verifyProperties()
	-- print( "RectangleStyle:verifyProperties" )

	--== Check Inheritance

	-- if inheritance is not of similar type then
	-- then make sure we have default data

	local inherit_type = self._inherit and self._inherit.type or nil

	if self.type ~= inherit_type and inherit_type~=nil then
		print( sformat("[NOTICE] Style inheritance mismatch '%s'<>'%s'", tostring(self.type), tostring(inherit_type) ))
		RectangleStyle.addMissingDestProperties( self, RectangleStyle._STYLE_DEFAULTS )
	end

	return RectangleStyle._verifyStyleProperties( self )
end



--====================================================================--
--== Private Methods


-- clear any local modifications on style class
-- called by clearProperties()
--
function RectangleStyle:_clearProperties()
	-- print( "RectangleStyle:_clearProperties" )
	self:superCall( '_clearProperties' )
	self.fillColor=nil
	self.strokeColor=nil
	self.strokeWidth=nil
end



--====================================================================--
--== Event Handlers


-- none



return RectangleStyle
