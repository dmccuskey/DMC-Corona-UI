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

BackgroundStyle._VALID_PROPERTIES = {
	debugOn=true,
	width=true,
	height=true,
	anchorX=true,
	anchorY=true
}

BackgroundStyle.EXCLUDE_PROPERTY_CHECK = nil

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

-- BackgroundStyle._VIEW_DEFAULTS = {
-- 	rounded=nil,
-- 	rectangle=nil,
-- 	polygon=nil,
-- 	shape=nil
-- }

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

	self._width = nil
	self._height = nil

	self._anchorX = nil
	self._anchorY = nil

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

	BackgroundStyle._setDefaults()
end


-- create empty Background Style structure
function BackgroundStyle.createStateStructure( data )
	-- print( "BackgroundStyle.createStateStructure", data )
	return {
		view={
			type=data
		}
	}
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


function BackgroundStyle._setDefaults()
	-- print( "BackgroundStyle._setDefaults" )

	local defaults = BackgroundStyle._STYLE_DEFAULTS

	defaults = BackgroundStyle._addMissingChildProperties( defaults, defaults )
	-- Utils.print( defaults )

	local style = BackgroundStyle:new{
		data=defaults
	}
	BackgroundStyle.__base_style__ = style
end




function BackgroundStyle._verifyClassProperties( src )
	-- print( "BackgroundStyle._verifyClassProperties" )
	assert( src )
	--==--
	local emsg = "Style: requires property '%s'"

	local is_valid = BaseStyle._verifyClassProperties( src )

	if not src.width then
		print(sformat(emsg,'width')) ; is_valid=false
	end
	if not src.height then
		print(sformat(emsg,'height')) ; is_valid=false
	end
	if not src.anchorX then
		print(sformat(emsg,'anchorX')) ; is_valid=false
	end
	if not src.anchorY then
		print(sformat(emsg,'anchorY')) ; is_valid=false
	end

	-- check sub-styles ??

	local StyleClass

	StyleClass = src._view.class
	-- TODO
	-- if not StyleClass._checkProperties( self._view ) then is_valid=false end

	return is_valid
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
	BackgroundStyle.copyExistingSrcProperties( self, src, params )
end


function BackgroundStyle:verifyClassProperties()
	-- print( "BackgroundStyle:verifyClassProperties" )
	return BackgroundStyle._verifyClassProperties( self )
end



--====================================================================--
--== Private Methods


-- we could have nil, Lua structure, or Instance
--
function BackgroundStyle:_prepareData( data )
	-- print("BackgroundStyle:_prepareData", data, self )
	if not data then return end

	if data.isa and data:isa( BackgroundStyle ) then
		--== Instance
		local o = data
		data = { view=o.view.type } -- setting to string, special case

	else
		--== Lua structure
		local StyleClass
		local src, dest = data, nil

		dest = src.view
		if dest==nil then
			dest = { type=StyleFactory.Rectangle.TYPE }
			print( "[WARNING] Defaulting to Rectangle style", type(dest.type) )
			src.view = dest
		end
		StyleClass = StyleFactory.getClass( dest.type )
		StyleClass.copyExistingSrcProperties( dest, src )

	end

	return data
end

function BackgroundStyle:_checkChildren()
	-- print( "BackgroundStyle:_checkChildren" )

	-- using setters !!!
	if self._view==nil then self.view=nil end
end



--====================================================================--
--== Event Handlers


-- none




return BackgroundStyle
