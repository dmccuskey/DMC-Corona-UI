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
local Utils = require 'dmc_utils'

local BaseStyle = require( widget_find( 'widget_style.base_style' ) )



--====================================================================--
--== Setup, Constants


local newClass = Objects.newClass
local ObjectBase = Objects.ObjectBase

local sformat = string.format

-- these set in initialize()
local Widgets = nil
local StyleFactory = nil



--====================================================================--
--== Background Style Class
--====================================================================--


local BackgroundStyle = newClass( BaseStyle, {name="Background Style"} )

--== Class Constants

BackgroundStyle.__base_style__ = nil

-- child styles
BackgroundStyle.VIEW_KEY = 'view'
BackgroundStyle.VIEW_NAME = 'background-view'

BackgroundStyle._STYLE_DEFAULTS = {
	name='background-default-style',
	debugOn=false,

	width=75,
	height=30,

	anchorX=0.5,
	anchorY=0.5,

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
		fillColor={1,1,1,1},
		strokeWidth=1,
		strokeColor={0,0,0,1},
	},

}

BackgroundStyle._VIEW_DEFAULTS = {
	rounded=nil,
	rectangle=nil,
	polygon=nil,
	shape=nil
}

--== Event Constants

BackgroundStyle.EVENT = 'background-style-event'

-- from super
-- Class.STYLE_UPDATED


--======================================================--
-- Start: Setup DMC Objects

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

	--== Local style properties

	-- other properties are in substyles

	self._width = nil
	self._height = nil

	self._anchorX = nil
	self._anchorY = nil

	--== Object Refs ==--

	-- these are other style objects
	self._view = nil

end

-- END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Static Methods


function BackgroundStyle.initialize( manager )
	-- print( "BackgroundStyle.initialize", manager )
	Widgets = manager
	StyleFactory = Widgets.Style.BackgroundFactory

	BackgroundStyle._setDefaults()
end


function BackgroundStyle._setDefaults()
	-- print( "BackgroundStyle._setDefaults" )

	local defaults = BackgroundStyle._STYLE_DEFAULTS

	defaults = BackgroundStyle.pushMissingProperties( defaults )

	local style = BackgroundStyle:new{
		data=defaults
	}
	BackgroundStyle.__base_style__ = style
end


-- copyMissingProperties()
-- copies properties from src structure to dest structure
-- if property isn't already in dest
-- Note: usually used by OTHER classes
--
function BackgroundStyle.copyMissingProperties( dest, src )
	-- print( "BackgroundStyle.copyMissingProperties", dest, src )
	if dest.debugOn==nil then dest.debugOn=src.debugOn end

	if dest.width==nil then dest.width=src.width end
	if dest.height==nil then dest.height=src.height end

	if dest.anchorX==nil then dest.anchorX=src.anchorX end
	if dest.anchorY==nil then dest.anchorY=src.anchorY end
	if dest.fillColor==nil then dest.fillColor=src.fillColor end
	if dest.strokeColor==nil then dest.strokeColor=src.strokeColor end
	if dest.strokeWidth==nil then dest.strokeWidth=src.strokeWidth end
end


function BackgroundStyle.pushMissingProperties( src )
	-- print("BackgroundStyle.pushMissingProperties", src )
	if not src then return end

	local StyleClass, dest
	local eStr = "ERROR: Style missing property '%s'"

	-- copy items to substyle 'view'
	dest = src[ BackgroundStyle.VIEW_KEY ]
	StyleClass = StyleFactory.getClass( dest.type )
	StyleClass.copyMissingProperties( dest, src )

	return src
end



--====================================================================--
--== Public Methods


--======================================================--
-- Access to sub-styles

function BackgroundStyle.__getters:view()
	-- print( 'BackgroundStyle.__getters:view', self._view )
	return self._view
end
function BackgroundStyle.__setters:view( data )
	-- print( 'BackgroundStyle.__setters:view', data )
	assert( data==nil or type(data)=='string' or type( data )=='table' )
	--==--
	local inherit = self._inherit and self._inherit._view
	self._view = self:createStyleFromType{
		name=BackgroundStyle.VIEW_NAME,
		inherit=inherit,
		parent=self,
		data=data
	}
end


--======================================================--
-- Misc

--== inherit

function BackgroundStyle.__setters:inherit( value )
	-- print( "BackgroundStyle.__setters:inherit", value )
	BaseStyle.__setters.inherit( self, value )
	--==--
	self._view.inherit = value and value.view or value
end


-- createStyleFromType()
-- looks for style class based on view type
-- then calls to create the style
--
function BackgroundStyle:createStyleFromType( params )
	-- print( "BackgroundStyle:createStyleFromType", params )
	params = params or {}
	--==--
	local data = params.data
	local style_type, StyleClass

	-- look around for our style 'type'
	if data==nil then
		style_type = StyleFactory.Rectangle.TYPE
	elseif type(data)=='string' then
		-- we have type already
		style_type = data
		params.data=nil
	elseif type(data)=='table' then
		style_type = data.type
	end
	assert( style_type and type(style_type)=='string', "Style: missing style property 'type'" )

	StyleClass = StyleFactory.getClass( style_type )

	return StyleClass:createStyleFrom( params )
end



--== updateStyle

-- force is used when making exact copy of data
--
function BackgroundStyle:updateStyle( src, params )
	-- print( "BackgroundStyle:updateStyle", src )
	params = params or {}
	if params.force==nil then params.force=true end
	--==--
	local force=params.force

	if src.debugOn~=nil or force then self.debugOn=src.debugOn end

	if src.width~=nil or force then self.width=src.width end
	if src.height~=nil or force then self.height=src.height end

	if src.anchorX~=nil or force then self.anchorX=src.anchorX end
	if src.anchorY~=nil or force then self.anchorY=src.anchorY end
end



--====================================================================--
--== Private Methods


-- we could have nil, Lua structure, or Instance
--
function BackgroundStyle:_prepareData( data )
	-- print("BackgroundStyle:_prepareData", data, self )
	if not data then return end

	if data.isa and data:isa(BackgroundStyle) then
		-- Instance
		data = { view=data.view.type }
	else
		-- Lua structure
		local key = BackgroundStyle.VIEW_KEY
		if data[key]==nil then
			data[key] = { type=StyleFactory.Rectangle.TYPE }
			print( "[WARNING] Defaulting to Rectangle style", type(data[key].type) )
		end
		data = BackgroundStyle.pushMissingProperties( data )
	end
	return data
end

function BackgroundStyle:_checkChildren()
	-- print( "BackgroundStyle:_checkChildren" )

	-- using setters !!!
	if self._view==nil then self.view=nil end
end

function BackgroundStyle:_checkProperties()
	-- print( "BackgroundStyle._checkProperties" )
	local emsg = "Style: requires property '%s'"
	local is_valid = BaseStyle._checkProperties( self )

	if not self.width then print(sformat(emsg,'width')) ; is_valid=false end
	if not self.height then print(sformat(emsg,'height')) ; is_valid=false end

	if not self.anchorX then print(sformat(emsg,'anchorX')) ; is_valid=false end
	if not self.anchorY then print(sformat(emsg,'anchorY')) ; is_valid=false end

	-- check sub-styles ??

	local StyleClass

	StyleClass = self._view.class
	-- TODO
	-- if not StyleClass._checkProperties( self._view ) then is_valid=false end

	return is_valid
end



--====================================================================--
--== Event Handlers


-- none




return BackgroundStyle
