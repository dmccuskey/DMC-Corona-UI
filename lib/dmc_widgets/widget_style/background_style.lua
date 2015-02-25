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

BackgroundStyle._EXCLUDE_PROPERTY_CHECK = {
	type=true,
	view=true
}

BackgroundStyle._STYLE_DEFAULTS = {
	name='background-default-style',
	debugOn=false,
	width=75,
	height=30,
	anchorX=0.5,
	anchorY=0.5,

	-- these values can change
	type=nil,
	view=nil
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

	BackgroundStyle._setDefaults( BackgroundStyle )
end


-- create empty Background Style structure
function BackgroundStyle.createStyleStructure( data )
	-- print( "BackgroundStyle.createStyleStructure", data )
	data = data or BackgroundStyle._DEFAULT_VIEWTYPE
	return {
		type=data,
		view={}
	}
end


function BackgroundStyle.addMissingDestProperties( dest, srcs, params )
	-- print( "BackgroundStyle.addMissingDestProperties", dest, srcs )
	srcs = srcs or {}
	assert( dest )
	params = params or {}
	--==--
	tinsert( srcs, #srcs+1, BackgroundStyle._STYLE_DEFAULTS )

	dest = BaseStyle.addMissingDestProperties( dest, srcs, params )

	for i=1,#srcs do
		local src = srcs[i]

		if dest.type==nil or force then dest.type=src.type end

	end

	dest = BackgroundStyle._addMissingChildProperties( dest, {dest}, params )

	return dest
end


-- _addMissingChildProperties()
-- copy properties to sub-styles
--
function BackgroundStyle._addMissingChildProperties( dest, srcs, params  )
	-- print( "BackgroundStyle._addMissingChildProperties", dest, srcs )
	local eStr = "ERROR: Style (BackgroundStyle) missing property '%s'"
	local StyleClass, child
	srcs = srcs or {}
	tinsert( srcs, #srcs+1, BackgroundStyle._STYLE_DEFAULTS )

	child = dest.view
	assert( child, sformat( eStr, 'view' ) )
	StyleClass = StyleFactory.getClass( dest.type )
	dest.view = StyleClass.addMissingDestProperties( child, srcs, params )

	return dest
end


-- to a new stucture
function BackgroundStyle.copyExistingSrcProperties( dest, src, params )
	-- print( "BackgroundStyle.copyExistingSrcProperties", dest, src )
	assert( dest )
	if not src then return end
	params = params or {}
	if params.force==nil then params.force=false end
	--==--
	local force=params.force

	dest = BaseStyle.copyExistingSrcProperties( dest, src, params )

	if (src.type~=nil and dest.type==nil) or force then
		dest.type=src.type
	end

	return dest
end


function BackgroundStyle._verifyStyleProperties( src, exclude )
	-- print( "BackgroundStyle._verifyStyleProperties", src, exclude )
	local emsg = "Style (BackgroundStyle) requires property '%s'"

	local is_valid = BaseStyle._verifyStyleProperties( src, exclude )

	if not src.type then
		print(sformat(emsg,'type')) ; is_valid=false
	end

	local child, StyleClass

	child = src.view
	StyleClass = child.class
	if not StyleClass._verifyStyleProperties( child, exclude ) then
		is_valid=false
	end

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
		local struct = BackgroundStyle.createStyleStructure( cls_type )
		local def = Utils.extend( defaults, struct )
		StyleClass._addMissingChildProperties( def, {def} )
		local style = StyleClass:new{ data=def }
		BASE_STYLES[ cls_type ] = style
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
	local inherit = self._inherit and self._inherit._view or nil
	self._view = self:createStyleFromType{
		name=BackgroundStyle.VIEW_NAME,
		inherit=inherit,
		parent=self,
		data=data
	}
end

--[[
.inherit  (check type, if not same type, then create new view)
link inheritance

if set type, then recreate view, or use current
if current, pull vars from inherited
if new view, then populate with defaults

if unset type:
if same type, then clear properties
	if different type then recreate view, relink
--]]


--======================================================--
-- Misc

--== inherit

function BackgroundStyle:_doChildrenInherit( value )
	-- print( "BackgroundStyle_doChildrenInherit", value, self )
	self:_updateViewStyle()
	self._view.inherit = value and value._view or nil
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
		-- Lua structure, of View
		style_type = self.type
	end
	assert( style_type and type(style_type)=='string', "Style: missing style property 'type'" )

	StyleClass = StyleFactory.getClass( style_type )

	return StyleClass:createStyleFrom( params )
end


-- checks to maek sure things are equal
--
function BackgroundStyle:_updateViewStyle( params )
	-- print( "BackgroundStyle:_updateViewStyle", params )
	params = params or {}
	if params.reset==nil then params.reset = false end
	--==--
	if not self.type then error("no type here") ; return end
	local inheritanceInactive = (self._type==nil)
	local haveInheritedStyle = (self._inherit~=nil)
	local viewStyle = self._view
	local inherit = self._inherit
	local myType = self.type
	local StyleClass

	-- create a new view if one we have is of different type

	if not viewStyle or viewStyle.type~=myType then
		-- creating new view, same type as parent
		self._view = self:createStyleFromType{
			name=nil,
			inherit=nil,
			parent=self,
			data=self.type
		}
		viewStyle = self._view
	end

	if self.inheritIsActive then
		-- clear properties for inheritance action
		viewStyle.inherit=self._inherit._view
		-- viewStyle:_clearProperties() -- think this will be automatci

	else
		-- fill style with properties
		-- from current inherit or Style Class
		viewStyle.inherit=nil
		StyleClass = viewStyle.class
		local source = inherit and inherit.view
		StyleClass.copyExistingSrcProperties( viewStyle, source )

	end

	self:_dispatchResetEvent()
end

--== updateStyle

-- force is used when making exact copy of data
--
function BackgroundStyle:updateStyle( src, params )
	-- print( "BackgroundStyle:updateStyle", src )
	BackgroundStyle.copyExistingSrcProperties( self, src, params )
end


function BackgroundStyle:verifyProperties()
	-- print( "BackgroundStyle:verifyProperties", self )
	return BackgroundStyle._verifyStyleProperties( self )
end


function BackgroundStyle.__getters:inheritIsActive()
	return (self._inherit~=nil and self._type==nil)
end

--== type

function BackgroundStyle.__getters:type()
	-- print( "BackgroundStyle.__getters:type", self._inherit )
	local value = self._type
	if value==nil and self.inheritIsActive then
		value = self._inherit.type
	end
	return value
end
function BackgroundStyle.__setters:type( value )
	-- print( "BackgroundStyle.__setters:type", value, self )
	assert( (value==nil and self._inherit) or type(value)=='string' )
	--==--
	if value == self._type then return end
	self._type = value
	if self._is_initialized then
		self:_updateViewStyle()
	end
end



--====================================================================--
--== Private Methods


function BackgroundStyle:getBaseStyle( data )
	-- print( "BackgroundStyle:getBaseStyle", self, data )
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


-- copyProperties()
-- copy properties from a source
-- if no source, then copy from Base Style
--
function BackgroundStyle:copyProperties( src, params )
	-- print( "BackgroundStyle:copyProperties", src, self )
	params = params or {}
	if params.force==nil then params.force=false end
	--==--
	local StyleClass = self.class
	if not src then src=StyleClass:getBaseStyle( self.type ) end
	StyleClass.copyExistingSrcProperties( self, src, params )
end



--[[
Prepare Data
we could have nil, Lua structure, or Instance

no data, no inherit - create structure, set default type
no data, inherit - create structure, use inherit value, unset type
data, inherit - inherit.type (unset) or data.type (set) or default (set)
--]]
-- _prepareData()
--
function BackgroundStyle:_prepareData( data )
	-- print( "BackgroundStyle:_prepareData", data, self )
	local inherit = self._inherit

	if not data then
		data = BackgroundStyle.createStyleStructure()
		if inherit then
			data.type = nil -- unset for inheritance
			data.view = inherit.type -- notify of type
		end

	elseif data.isa and data:isa( BackgroundStyle ) then
		--== Instance
		local o = data
		data = BackgroundStyle.createStyleStructure( o.type )
		if inherit then
			data.type = nil -- unset for inheritance
			data.view = inherit.type -- notify of type
		end

	else
		--== Lua structure
		local StyleClass
		local src, dest = data, nil
		local stype

		if inherit then
			stype = inherit.type
			src.type = nil -- unset for inheritance
		elseif src.type then
			stype = src.type
		else
			stype = self._DEFAULT_VIEWTYPE
			src.type = stype
		end

		if stype then
			--== set child properties

			StyleClass = StyleFactory.getClass( stype )

			-- before we copy our defaults, make sure
			-- structure for 'view' exists
			dest = src.view
			if not dest then
				dest = StyleClass.createStyleStructure()
				src.view = dest
			end
			StyleClass.copyExistingSrcProperties( dest, src )
		end

	end

	return data
end



--====================================================================--
--== Event Handlers


-- none




return BackgroundStyle
