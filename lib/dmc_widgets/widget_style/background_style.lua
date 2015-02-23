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
local tinsert = table.insert

--== To be set in initialize()
local Widgets = nil
local StyleFactory = nil



--====================================================================--
--== Background Style Class
--====================================================================--


local BackgroundStyle = newClass( BaseStyle, {name="Background Style"} )

--== Class Constants

BackgroundStyle.TYPE = 'background'

BackgroundStyle.__base_style__ = nil

-- child styles
BackgroundStyle.VIEW_KEY = 'view'
BackgroundStyle.VIEW_NAME = 'background-view'

BackgroundStyle._DEFAULT_VIEWTYPE = nil -- set later

-- create multiple base-styles for Background class
-- one for each available view
--
BackgroundStyle._BASE_STYLES = {}

BackgroundStyle._CHILDREN = {
	view=true
}

BackgroundStyle._VALID_PROPERTIES = {
	debugOn=true,
	width=true,
	height=true,
	anchorX=true,
	anchorY=true,
	type=true
}

BackgroundStyle._EXCLUDE_PROPERTY_CHECK = nil

BackgroundStyle._STYLE_DEFAULTS = {
	name='background-default-style',
	debugOn=false,
	width=75,
	height=30,
	anchorX=0.5,
	anchorY=0.5,

	type=nil, -- set later to DEFAULT

	view = {
		--[[
		Copied from Background
		debugOn
		width
		height
		anchorX
		anchorY
		--]]
		fillColor={1,1,1,1},
		strokeWidth=1,
		strokeColor={0,0,0,1},
	},

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
	-- self._width
	-- self._height
	-- self._anchorX
	-- self._anchorY

	self._type = nil

	--== Object Refs ==--

	self._view = nil -- Background View Style

end

-- END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Static Methods


function BackgroundStyle.initialize( manager )
	-- print( "BackgroundStyle.initialize", manager )
	Widgets = manager
	StyleFactory = Widgets.Style.BackgroundFactory

	-- set LOCAL defaults before creating classes next
	BackgroundStyle._DEFAULT_VIEWTYPE = StyleFactory.Rounded.TYPE
	BackgroundStyle._STYLE_DEFAULTS.type = BackgroundStyle._DEFAULT_VIEWTYPE

	BackgroundStyle._setDefaults( BackgroundStyle )
end


-- create empty Background Style structure
function BackgroundStyle.createStyleStructure( data )
	-- print( "BackgroundStyle.createStyleStructure", data )
	data = data or self._DEFAULT_VIEWTYPE
	return {
		view={
			type=data
		}
	}
end


function BackgroundStyle.addMissingDestProperties( dest, src, params )
	-- print( "BackgroundStyle.addMissingDestProperties", dest, src )
	params = params or {}
	if params.force==nil then params.force=false end
	assert( dest )
	--==--
	local force=params.force
	local srcs = { BackgroundStyle._STYLE_DEFAULTS }
	if src then tinsert( srcs, 1, src ) end

	for i=1,#srcs do
		local src = srcs[i]

		if dest.debugOn==nil or force then dest.debugOn=src.debugOn end

		if dest.width==nil or force then dest.width=src.width end
		if dest.height==nil or force then dest.height=src.height end

		if dest.anchorX==nil or force then dest.anchorX=src.anchorX end
		if dest.anchorY==nil or force then dest.anchorY=src.anchorY end

	end

	BackgroundStyle._addMissingChildProperties( dest, src )

	return dest
end



-- to a new stucture
function BackgroundStyle.copyExistingSrcProperties( dest, src, params )
	-- print( "BackgroundStyle.copyExistingSrcProperties", dest, src )
	if not src then return end
	params = params or {}
	if params.force==nil then params.force=false end
	assert( dest )
	--==--
	local force=params.force

	if (src.debugOn~=nil and dest.debugOn==nil) or force then
		dest.debugOn=src.debugOn
	end

	if (src.width~=nil and dest.width==nil) or force then
		dest.width=src.width
	end
	if (src.height~=nil and dest.height==nil) or force then
		dest.height=src.height
	end

	if (src.anchorX~=nil and dest.anchorX==nil) or force then
		dest.anchorX=src.anchorX
	end
	if (src.anchorY~=nil and dest.anchorY==nil) or force then
		dest.anchorY=src.anchorY
	end

	return dest
end

--
-- copy properties to sub-styles
--
function BackgroundStyle._addMissingChildProperties( dest, src  )
	-- print("BackgroundStyle._addMissingChildProperties", dest, src  )
	local eStr = "ERROR: Style missing property '%s'"
	local StyleClass, child

	child = dest.view
	assert( child, sformat( eStr, 'view' ) )
	StyleClass = StyleFactory.getClass( child.type )
	StyleClass.addMissingDestProperties( child, src )

	return dest
end



function BackgroundStyle._verifyStyleProperties( src )
	-- print( "BackgroundStyle._verifyStyleProperties" )
	local emsg = "Style requires property '%s'"

	local is_valid = BaseStyle._verifyStyleProperties( src )

	if not src.type then
		print(sformat(emsg,'type')) ; is_valid=false
	end

	local StyleClass

	StyleClass = src._view.class
	-- TODO
	-- if not StyleClass._checkProperties( self._view ) then is_valid=false end

	return is_valid
end


-- _setDefaults()
-- create one of each style
--
function BackgroundStyle._setDefaults( StyleClass )
	-- print( "BackgroundStyle._setDefaults", StyleClass )
	local BASE_STYLES = StyleClass._BASE_STYLES
	local defaults = StyleClass._STYLE_DEFAULTS

	local classes = StyleFactory.getStyleClasses()

	for _, Cls in ipairs( classes ) do
		local cls_type = Cls.TYPE
		local def = Utils.extend( defaults, {view={type=cls_type}} )
		StyleClass._addMissingChildProperties( def, def )
		BASE_STYLES[ cls_type ] = StyleClass:new{ data=def }
	end

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
	self._view.inherit = value and value.view or nil
end


-- createStyleFromType()
-- method processes data from the 'view' setter
-- looks for style class based on type
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
		style_type = self._DEFAULT_VIEWTYPE
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
	BackgroundStyle.copyExistingSrcProperties( self, src, params )
end


function BackgroundStyle:verifyProperties()
	-- print( "BackgroundStyle:verifyProperties" )
	return BackgroundStyle._verifyStyleProperties( self )
end


--== type

function BackgroundStyle.__getters:type()
	-- print( 'BackgroundStyle.__getters:type', self._inherit )
	local value = self._type
	if value==nil and self._inherit then
		value = self._inherit.type
	end
	return value
end
function BackgroundStyle.__setters:type( value )
	-- print( 'BackgroundStyle.__setters:type', value )
	assert( (value==nil and self._inherit) or type(value)=='string' )
	--==--
	if value == self._type then return end
	self._type = value
end



--====================================================================--
--== Private Methods


function BackgroundStyle:_getBaseStyle( data )
	-- print( "BackgroundStyle:_getBaseStyle", self, data )
	local BASE_STYLES = self._BASE_STYLES
	local viewType, style

	if data==nil then
		viewType = self._DEFAULT_VIEWTYPE
	elseif type(data)=='string' then
		viewType = data
	elseif data.isa and data:isa( BackgroundStyle ) then
		--== Instance
		viewType = data.type
	else
		--== Lua structure
		viewType = data.type
	end

	style = BASE_STYLES[ viewType ]
	if not style then
		style = BASE_STYLES[ self._DEFAULT_VIEWTYPE ]
	end

	return style
end


-- this would clear any local modifications on style class
-- called by clearProperties()
--
function BackgroundStyle:_clearProperties()
	-- print( "BackgroundStyle:_clearProperties" )
	self:superCall( '_clearProperties' )
	--== no local properties to update
end


-- we could have nil, Lua structure, or Instance
--
function BackgroundStyle:_prepareData( data )
	-- print( "BackgroundStyle:_prepareData", data, self )
	if not data then return end
	--==--

	if data.isa and data:isa( BackgroundStyle ) then
		--== Instance
		local o = data
		data = {view=o.type}

	else
		--== Lua structure
		local StyleClass
		local src, dest = data, nil

		if src.type==nil then
			src.type = self._DEFAULT_VIEWTYPE
			print( "[WARNING] Defaulting to style: ", src.type )
		end

		dest = src.view
		if not dest then
			src.view = src.type -- using string
		else
			dest.type = src.type -- add our type to view
			StyleClass = StyleFactory.getClass( src.type )
			StyleClass.copyExistingSrcProperties( dest, src )
		end


	end

	return data
end



--====================================================================--
--== Event Handlers


-- none




return BackgroundStyle
