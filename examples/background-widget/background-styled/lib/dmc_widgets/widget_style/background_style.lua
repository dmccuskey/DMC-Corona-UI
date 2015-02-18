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
--== DMC Widgets : newBackgroundBase
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

-- Set Later
local Widgets = nil
local StyleFactory = nil



--====================================================================--
--== Background Style Class
--====================================================================--


local BackgroundBase = newClass( BaseStyle, {name="Background Style"} )

--== Class Constants

BackgroundBase.__base_style__ = nil

-- child styles
BackgroundBase.VIEW_KEY = 'view'
BackgroundBase.VIEW_NAME = 'background-view'

BackgroundBase.DEFAULT = {
	name='background-default-style',
	debugOn=false,

	width=75,
	height=30,

	anchorX=0.5,
	anchorY=0.5,
	hitMarginX=0,
	hitMarginY=0,
	isHitActive=true,
	isHitTestable=true,

	view={
		--[[
		Copied from Background
		debugOn
		width
		height
		anchorX
		anchorY
		--]]
		type='rectangle',
		fillColor={0.5,0.5,0.2,1},
		strokeWidth=2,
		strokeColor={1,0,0,0},
	},

}

--== Event Constants

BackgroundBase.EVENT = 'background-style-event'

-- from super
-- Class.STYLE_UPDATED


--======================================================--
-- Start: Setup DMC Objects

function BackgroundBase:__init__( params )
	-- print( "BackgroundBase:__init__", params )
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

	-- other properties are in substyles

	self._width = nil
	self._height = nil

	self._anchorX = nil
	self._anchorY = nil
	self._hitMarginX = nil
	self._hitMarginY = nil
	self._isHitActive = nil
	self._isHitTestable = nil

	--== Object Refs ==--

	-- these are other style objects
	self._view = nil

end

-- END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Static Methods


function BackgroundBase.initialize( manager )
	-- print( "BackgroundBase.initialize", manager )
	Widgets = manager
	StyleFactory = Widgets.Style.BackgroundFactory

	BackgroundBase._setDefaults()
end


function BackgroundBase._setDefaults()
	-- print( "BackgroundBase._setDefaults" )

	local defaults = BackgroundBase.DEFAULT

	defaults = BackgroundBase.pushMissingProperties( defaults )

	-- local src = BackgroundBase.DEFAULT
	-- local StyleClass, dest

	-- -- copy items to substyle 'view'
	-- dest = src[ BackgroundBase.VIEW_KEY ]
	-- StyleClass = StyleFactory.getClass( dest.type )
	-- StyleClass.copyMissingProperties( dest, src )

	local style = BackgroundBase:new{
		data=defaults
	}
	BackgroundBase.__base_style__ = style
end


-- copyMissingProperties()
-- copies properties from src structure to dest structure
-- if property isn't already in dest
-- Note: usually used by OTHER classes
--
function BackgroundBase.copyMissingProperties( dest, src )
	-- print( "BackgroundBase.copyMissingProperties", dest, src )
	if dest.debugOn==nil then dest.debugOn=src.debugOn end

	if dest.width==nil then dest.width=src.width end
	if dest.height==nil then dest.height=src.height end

	if dest.anchorX==nil then dest.anchorX=src.anchorX end
	if dest.anchorY==nil then dest.anchorY=src.anchorY end
	if dest.fillColor==nil then dest.fillColor=src.fillColor end
	if dest.strokeColor==nil then dest.strokeColor=src.strokeColor end
	if dest.strokeWidth==nil then dest.strokeWidth=src.strokeWidth end
end


function BackgroundBase.pushMissingProperties( src )
	-- print("BackgroundBase.pushMissingProperties", src )
	if not src then return end

	local StyleClass, dest

	-- copy items to substyle 'view'
	dest = src[ BackgroundBase.VIEW_KEY ]
	StyleClass = StyleFactory.getClass( dest.type )
	StyleClass.copyMissingProperties( dest, src )

	return src
end



--====================================================================--
--== Public Methods


--======================================================--
-- Access to sub-styles

function BackgroundBase.__getters:view()
	-- print( 'BackgroundBase.__getters:view', self._view )
	return self._view
end
function BackgroundBase.__setters:view( data )
	-- print( 'BackgroundBase.__setters:view', data )
	assert( data==nil or type( data )=='table' )
	--==--
	local inherit = self._inherit and self._inherit._view
	self._view = self:_createStyleFromType{
		name=BackgroundBase.VIEW_NAME,
		inherit=inherit,
		parent=self,
		data=data
	}
end


--======================================================--
-- Access to style properties

--== hitMarginX

function BackgroundBase.__getters:hitMarginX()
	-- print( "BackgroundBase.__getters:hitMarginX" )
	local value = self._hitMarginX
	if value==nil and self._inherit then
		value = self._inherit.hitMarginX
	end
	return value
end
function BackgroundBase.__setters:hitMarginX( value )
	-- print( "BackgroundBase.__setters:hitMarginX", value )
	assert( (type(value)=='number' and value>=0) or (value==nil and self._inherit) )
	--==--
	if value == self._hitMarginX then return end
	self._hitMarginX = value
	self:_dispatchChangeEvent( 'hitMarginX', value )
end

--== hitMarginY

function BackgroundBase.__getters:hitMarginY()
	-- print( "BackgroundBase.__getters:hitMarginY" )
	local value = self._hitMarginY
	if value==nil and self._inherit then
		value = self._inherit.hitMarginY
	end
	return value
end
function BackgroundBase.__setters:hitMarginY( value )
	-- print( "BackgroundBase.__setters:hitMarginY", value )
	assert( (type(value)=='number' and value>=0) or (value==nil and self._inherit) )
	--==--
	if value == self._hitMarginY then return end
	self._hitMarginY = value
	self:_dispatchChangeEvent( 'hitMarginY', value )
end

--== isHitActive

function BackgroundBase.__getters:isHitActive()
	-- print( "BackgroundBase.__getters:isHitActive" )
	local value = self._isHitActive
	if value==nil and self._inherit then
		value = self._inherit.isHitActive
	end
	return value
end
function BackgroundBase.__setters:isHitActive( value )
	-- print( "BackgroundBase.__setters:isHitActive", value )
	assert( type(value)=='boolean' or (value==nil and self._inherit) )
	--==--
	if value == self._isHitActive then return end
	self._isHitActive = value
	self:_dispatchChangeEvent( 'isHitActive', value )
end

--== isHitTestable

function BackgroundBase.__getters:isHitTestable()
	local value = self._isHitTestable
	if value==nil and self._inherit then
		value = self._inherit.isHitTestable
	end
	return value
end
function BackgroundBase.__setters:isHitTestable( value )
	-- print( "BackgroundBase.__setters:isHitTestable", value )
	assert( type(value)=='boolean' or (value==nil and self._inherit) )
	--==--
	if value==self._isHitTestable then return end
	self._isHitTestable = value
	self:_dispatchChangeEvent( 'isHitTestable', value )
end


--======================================================--
-- Misc

--== inherit

function BackgroundBase.__setters:inherit( value )
	-- print( "BackgroundBase.__setters:inherit", value )
	assert( value:isa(BackgroundBase) )
	--==--
	self._inherit = value

	self._view.inherit = value.view
end


--== updateStyle

-- force is used when making exact copy of data
--
function BackgroundBase:updateStyle( src, params )
	-- print( "BackgroundBase:updateStyle", src )
	params = params or {}
	if params.force==nil then params.force=true end
	--==--
	local force=params.force

	if src.debugOn~=nil or force then self.debugOn=src.debugOn end

	if src.width~=nil or force then self.width=src.width end
	if src.height~=nil or force then self.height=src.height end

	if src.anchorX~=nil or force then self.anchorX=src.anchorX end
	if src.anchorY~=nil or force then self.anchorY=src.anchorY end
	if src.hitMarginX~=nil or force then self.hitMarginX=src.hitMarginX end
	if src.hitMarginY~=nil or force then self.hitMarginY=src.hitMarginY end
	if src.isHitActive~=nil or force then self.isHitActive=src.isHitActive end
	if src.isHitTestable~=nil or force then self.isHitTestable=src.isHitTestable end
end



--====================================================================--
--== Private Methods


function BackgroundBase:_prepareData( data )
	-- print("BackgroundBase:_prepareData", data )
	if not data then return end

	return BackgroundBase.pushMissingProperties( data )
end

function BackgroundBase:_checkChildren()
	-- print( "BackgroundBase:_checkChildren" )

	-- using setters !!!
	if self._view==nil then self.view=nil end
end

function BackgroundBase:_checkProperties()
	-- print( "BackgroundBase._checkProperties" )

	BaseStyle._checkProperties( self )

	assert( self.width, "Style: requires property 'width'" )
	assert( self.height, "Style: requires property 'height'" )

	assert( self.anchorX, "Style: requires property 'anchorX'" )
	assert( self.anchorY, "Style: requires property 'anchory'" )
	assert( self.hitMarginX>=0, "Style: requires property 'hitMarginX'" )
	assert( self.hitMarginY>=0, "Style: requires property 'hitMarginY'" )
	assert( self.isHitActive~=nil, "Style: requires property 'isHitActive'" )
	assert( self.isHitTestable~=nil, "Style: requires property 'isHitTestable'" )

	-- TODO: add substyle check
end


-- _createStyleFromType()
-- looks for style class based on view type
-- then calls to create the style
--
function BackgroundBase:_createStyleFromType( params )
	-- print( "BackgroundBase:_createStyleFromType", params )
	params = params or {}
	--==--
	local data = params.data
	local style_type, StyleClass

	-- look around for our style 'type'
	if data==nil then
		style_type = StyleFactory.Rectangle.TYPE
	elseif data.type then
		style_type = data.type
	end
	assert( style_type and type(style_type)=='string', "Style: missing style property 'type'" )

	StyleClass = StyleFactory.getClass( style_type )

	-- Utils.print( params )
	return StyleClass:createStyleFrom( params )
end



--====================================================================--
--== Event Handlers


-- none




return BackgroundBase
