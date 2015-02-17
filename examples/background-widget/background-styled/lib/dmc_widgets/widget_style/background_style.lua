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

local BaseStyle = require( widget_find( 'widget_style.base_style' ) )



--====================================================================--
--== Setup, Constants


local newClass = Objects.newClass
local ObjectBase = Objects.ObjectBase

local Widgets = nil -- set later



--====================================================================--
--== Background Style Class
--====================================================================--


local BackgroundStyle = newClass( BaseStyle, {name="Background Style"} )

--== Class Constants

BackgroundStyle.__base_style__ = nil

BackgroundStyle.DEFAULT = {
	name='background-default-style',

	width=75,
	height=30,

	anchorX=0.5,
	anchorY=0.5,
	debugOn=false,
	fillColor={1,1,1,1},
	hitMarginX=0,
	hitMarginY=0,
	isHitActive=true,
	isHitTestable=true,
	strokeColor={0,0,0,1},
	strokeWidth=0
}

--== Event Constants

BackgroundStyle.EVENT = 'background-style-event'

-- from super
-- Class.STYLE_UPDATED


--======================================================--
--== Start: Setup DMC Objects

function BackgroundStyle:__init__( params )
	-- print( "BackgroundStyle:__init__", params )
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

	self._width = nil
	self._height = nil

	self._anchorX = nil
	self._anchorY = nil
	self._fillColor = nil
	self._hitMarginX = nil
	self._hitMarginY = nil
	self._isHitActive = nil
	self._isHitTestable = nil
	self._strokeColor = nil
	self._strokeWidth = nil
end

--== END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Static Methods



function BackgroundStyle.initialize( manager )
	-- print( "BackgroundStyle.initialize", manager )
	Widgets = manager

	BackgroundStyle._setDefaults()
end



--====================================================================--
--== Public Methods



--== hitMarginX

function BackgroundStyle.__getters:hitMarginX()
	-- print( "BackgroundStyle.__getters:hitMarginX" )
	local value = self._hitMarginX
	if value==nil and self._inherit then
		value = self._inherit.hitMarginX
	end
	return value
end
function BackgroundStyle.__setters:hitMarginX( value )
	-- print( "BackgroundStyle.__setters:hitMarginX", value )
	assert( (type(value)=='number' and value>=0) or (value==nil and self._inherit) )
	--==--
	if value == self._hitMarginX then return end
	self._hitMarginX = value
	self:_dispatchChangeEvent( 'hitMarginX', value )
end

--== hitMarginY

function BackgroundStyle.__getters:hitMarginY()
	-- print( "BackgroundStyle.__getters:hitMarginY" )
	local value = self._hitMarginY
	if value==nil and self._inherit then
		value = self._inherit.hitMarginY
	end
	return value
end
function BackgroundStyle.__setters:hitMarginY( value )
	-- print( "BackgroundStyle.__setters:hitMarginY", value )
	assert( (type(value)=='number' and value>=0) or (value==nil and self._inherit) )
	--==--
	if value == self._hitMarginY then return end
	self._hitMarginY = value
	self:_dispatchChangeEvent( 'hitMarginY', value )
end

--== isHitActive

function BackgroundStyle.__getters:isHitActive()
	-- print( "BackgroundStyle.__getters:isHitActive" )
	local value = self._isHitActive
	if value==nil and self._inherit then
		value = self._inherit.isHitActive
	end
	return value
end
function BackgroundStyle.__setters:isHitActive( value )
	-- print( "BackgroundStyle.__setters:isHitActive", value )
	assert( type(value)=='boolean' or (value==nil and self._inherit) )
	--==--
	if value == self._isHitActive then return end
	self._isHitActive = value
	self:_dispatchChangeEvent( 'isHitActive', value )
end

--== isHitTestable

function BackgroundStyle.__getters:isHitTestable()
	local value = self._isHitTestable
	if value==nil and self._inherit then
		value = self._inherit.isHitTestable
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


--== updateStyle

-- force is used when making exact copy of data
--
function BackgroundStyle:updateStyle( info, params )
	-- print( "BackgroundStyle:updateStyle", info )
	params = params or {}
	if params.force==nil then params.force=true end
	--==--
	local force=params.force

	if info.debugOn~=nil or force then self.debugOn=info.debugOn end

	if info.width~=nil or force then self.width=info.width end
	if info.height~=nil or force then self.height=info.height end

	if info.anchorX~=nil or force then self.anchorX=info.anchorX end
	if info.anchorY~=nil or force then self.anchorY=info.anchorY end
	if info.fillColor~=nil or force then self.fillColor=info.fillColor end
	if info.hitMarginX~=nil or force then self.hitMarginX=info.hitMarginX end
	if info.hitMarginY~=nil or force then self.hitMarginY=info.hitMarginY end
	if info.isHitActive~=nil or force then self.isHitActive=info.isHitActive end
	if info.isHitTestable~=nil or force then self.isHitTestable=info.isHitTestable end
	if info.strokeColor~=nil or force then self.strokeColor=info.strokeColor end
	if info.strokeWidth~=nil or force then self.strokeWidth=info.strokeWidth end
end



--====================================================================--
--== Private Methods


function BackgroundStyle._setDefaults()
	-- print( "BackgroundStyle._setDefaults" )
	local style = BackgroundStyle:new{
		data=BackgroundStyle.DEFAULT
	}
	BackgroundStyle.__base_style__ = style
end



function BackgroundStyle:_checkProperties()
	-- print( "BackgroundStyle._checkProperties" )

	BaseStyle._checkProperties( self )

	assert( self.width, "Style: requires property'width'" )
	assert( self.height, "Style: requires property 'height'" )

	assert( self.anchorX, "Style: requires property'anchorX'" )
	assert( self.anchorY, "Style: requires property 'anchory'" )
	assert( self.fillColor, "Style: requires property 'fillColor'" )
	assert( self.hitMarginX, "Style: requires property 'hitMarginX'" )
	assert( self.hitMarginY, "Style: requires property 'hitMarginY'" )
	assert( self.isHitActive, "Style: requires property 'isHitActive'" )
	assert( self.isHitTestable, "Style: requires property 'isHitTestable'" )
	assert( self.strokeColor, "Style: requires property 'strokeColor'" )
	assert( self.strokeWidth, "Style: requires property 'strokeWidth'" )
end



--====================================================================--
--== Event Handlers


-- none




return BackgroundStyle
