--====================================================================--
-- dmc_widgets/widget_style/button_style.lua
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
--== DMC Widgets : newButtonStyle
--====================================================================--



--====================================================================--
--== Imports


local Objects = require 'dmc_objects'
local Utils = require 'dmc_utils'
local WidgetUtils = require(widget_find( 'widget_utils' ))

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
--== Button Style Class
--====================================================================--


local ButtonStyle = newClass( BaseStyle, {name="Button Style"} )

--== Class Constants

ButtonStyle.TYPE = 'button'

ButtonStyle.__base_style__ = nil  -- set in initialize()

ButtonStyle._CHILDREN = {
	inactive=true,
	active=true,
	disabled=true
}

ButtonStyle._VALID_PROPERTIES = {
	debugOn=true,
	width=true,
	height=true,
	anchorX=true,
	anchorY=true,

	align=true,
	hitMarginX=true,
	hitMarginY=true,
	isHitActive=true,
	marginX=true,
	marginY=true,
}

ButtonStyle._EXCLUDE_PROPERTY_CHECK = {
	-- label/background, they can be copied from
	label=true,
	background=true
}

ButtonStyle._STYLE_DEFAULTS = {
	name='button-default-style',
	debugOn=false,
	width=75,
	height=30,
	anchorX=0.5,
	anchorY=0.5,

	align='center',
	hitMarginX=0,
	hitMarginY=0,
	isHitActive=true,
	marginX=0,
	marginY=5,

	--[[
	When defining a style in code, 'label' and 'background'
	can be placed in your button style and used to
	to copy defaults to sub-styles

	label={
	}
	background={
	}
	--]]

	inactive={ -- << this is a Button Style State
		--[[
		Can be copied from Button
		* debugOn
		* width
		* height
		* anchorX/anchorY
		* label
		* background
		--]]
		label={
			align='right',
			font=native.systemFont,
			fontSize=12,
			textColor={0,1,0,0.5}
		},
		background={
			type='rectangle',
			view={
				fillColor={0,1,1,1},
				strokeWidth=2.5,
				strokeColor={1,0,0,1},
			}
		}
	},

	active={
		--[[
		Can be copied from Button
		* debugOn
		* width
		* height
		* anchorX/anchorY
		* label
		* background
		--]]
		label={
			textColor={1,0,0},
			font=native.systemFontBold,
			fontSize=10
		},
		background={
			type='rectangle',
			view={
				fillColor={0,1,0,1},
				strokeWidth=3.5,
				strokeColor={0,0,0,1},
			},
		}
	},

	disabled={
		--[[
		Can be copied from Button
		* debugOn
		* width
		* height
		* type
		* align
		* anchorX
		* anchorY
		* label
		--]]
		label={
			textColor={1,0,0},
			font=native.systemFontBold,
			fontSize=10
		},
		background={
			type='rounded',
			view={
				cornerRadius=10,
				fillColor={0,0,1,1},
				strokeWidth=4.5,
				strokeColor={0,1,0,1},
			},
		}
	},

}

--== Event Constants

ButtonStyle.EVENT = 'background-style-event'


--======================================================--
-- Start: Setup DMC Objects

function ButtonStyle:__init__( params )
	-- print( "ButtonStyle:__init__", params )
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

	self._hitMarginX = nil
	self._hitMarginY = nil
	self._isHitActive = nil
	self._marginX = nil
	self._marginY = nil

	--== Object Refs ==--

	-- these are other style objects
	-- each Button State Style
	self._inactive = nil
	self._active = nil
	self._disabled = nil

end

-- END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Static Methods


function ButtonStyle.initialize( manager )
	-- print( "ButtonStyle.initialize", manager )
	Widgets = manager

	ButtonStyle._setDefaults( ButtonStyle )
end


-- create empty style structure
-- param data string, type of background view
--
function ButtonStyle.createStyleStructure( data )
	-- print( "ButtonStyle.createStyleStructure", data )
	return {
		inactive=Widgets.Style.ButtonState.createStyleStructure( data ),
		active=Widgets.Style.ButtonState.createStyleStructure( data ),
		disabled=Widgets.Style.ButtonState.createStyleStructure( data )
	}
end


function ButtonStyle.addMissingDestProperties( dest, srcs )
	-- print( "ButtonStyle.addMissingDestProperties", dest, srcs )
	assert( dest )
	srcs = srcs or {}
	local lsrc = Utils.extend( srcs, {} )
	if lsrc.parent==nil then lsrc.parent=dest end
	if lsrc.main==nil then lsrc.main=ButtonStyle._STYLE_DEFAULTS end
	lsrc.widget = ButtonStyle._STYLE_DEFAULTS
	--==--

	dest = BaseStyle.addMissingDestProperties( dest, lsrc )

	for _, key in ipairs( { 'main', 'parent', 'widget' } ) do
		local src = lsrc[key] or {}

		if dest.align==nil then dest.align=src.align end
		if dest.hitMarginX==nil then dest.hitMarginX=src.hitMarginX end
		if dest.hitMarginY==nil then dest.hitMarginY=src.hitMarginY end
		if dest.isHitActive==nil then dest.isHitActive=src.isHitActive end
		if dest.marginX==nil then dest.marginX=src.marginX end
		if dest.marginY==nil then dest.marginY=src.marginY end

		--== Additional properties to be handed down to children
		if dest.font==nil then dest.font=src.font end

	end

	dest = ButtonStyle._addMissingChildProperties( dest, lsrc )

	return dest
end


-- _addMissingChildProperties()
-- copy properties to sub-styles
--
function ButtonStyle._addMissingChildProperties( dest, srcs )
	-- print("ButtonStyle._addMissingChildProperties", dest, srcs )
	assert( dest )
	srcs = srcs or {}
	local lsrc = { parent = dest }
	--==--
	local eStr = "ERROR: Style (ButtonStyle) missing property '%s'"
	local StyleClass, child

	child = dest.inactive
	-- assert( child, sformat( eStr, 'inactive' ) )
	StyleClass = Widgets.Style.ButtonState
	lsrc.main = srcs.main and srcs.main.inactive
	dest.inactive = StyleClass.addMissingDestProperties( child, lsrc )

	child = dest.active
	-- assert( child, sformat( eStr, 'active' ) )
	StyleClass = Widgets.Style.ButtonState
	lsrc.main = srcs.main and srcs.main.active
	dest.active = StyleClass.addMissingDestProperties( child, sources )

	child = dest.disabled
	-- assert( child, sformat( eStr, 'disabled' ) )
	StyleClass = Widgets.Style.ButtonState
	lsrc.main = srcs.main and srcs.main.disabled
	dest.disabled = StyleClass.addMissingDestProperties( child, sources )

	return dest
end


function ButtonStyle.copyExistingSrcProperties( dest, src, params )
	-- print( "ButtonStyle.copyExistingSrcProperties", dest, src )
	assert( dest )
	if not src then return end
	params = params or {}
	if params.force==nil then params.force=false end
	--==--
	local force=params.force

	dest = BaseStyle.copyExistingSrcProperties( dest, src, params )

	if (src.align~=nil and dest.align==nil) or force then
		dest.align=src.align
	end
	if (src.hitMarginX~=nil and dest.hitMarginX==nil) or force then
		dest.hitMarginX=src.hitMarginX
	end
	if (src.hitMarginY~=nil and dest.hitMarginY==nil) or force then
		dest.hitMarginY=src.hitMarginY
	end
	if (src.isHitActive~=nil and dest.isHitActive==nil) or force then
		dest.isHitActive=src.isHitActive
	end
	if (src.marginX~=nil and dest.marginX==nil) or force then
		dest.marginX=src.marginX
	end
	if (src.marginY~=nil and dest.marginY==nil) or force then
		dest.marginY=src.marginY
	end

	return dest
end


function ButtonStyle._verifyStyleProperties( src )
	-- print( "ButtonStyle._verifyStyleProperties", src )
	local emsg = "Style (ButtonStyle) requires property '%s'"

	local is_valid = BaseStyle._verifyStyleProperties( src )

	if not src.align then
		print(sformat(emsg,'align')) ; is_valid=false
	end
	if not src.hitMarginX then
		print(sformat(emsg,'hitMarginX')) ; is_valid=false
	end
	if not src.hitMarginY then
		print(sformat(emsg,'hitMarginY')) ; is_valid=false
	end
	if not src.isHitActive then
		print(sformat(emsg,'isHitActive')) ; is_valid=false
	end
	if not src.marginX then
		print(sformat(emsg,'marginX')) ; is_valid=false
	end
	if not src.marginY then
		print(sformat(emsg,'marginY')) ; is_valid=false
	end

	local child, StyleClass

	child = src._inactive
	StyleClass = child.class
	if not StyleClass._verifyStyleProperties( child, exclude ) then
		is_valid=false
	end

	child = src._active
	StyleClass = child.class
	if not StyleClass._verifyStyleProperties( child, exclude ) then
		is_valid=false
	end

	child = src._disabled
	StyleClass = child.class
	if not StyleClass._verifyStyleProperties( child, exclude ) then
		is_valid=false
	end

	return is_valid
end



--====================================================================--
--== Public Methods


--======================================================--
-- Access to sub-styles

--== .inactive

function ButtonStyle.__getters:inactive()
	-- print( "ButtonStyle.__getters:inactive", self._inactive )
	return self._inactive
end
function ButtonStyle.__setters:inactive( data )
	-- print( "ButtonStyle.__setters:inactive", data )
	assert( data==nil or type(data)=='string' or type( data )=='table' )
	--==--
	local StyleClass = Widgets.Style.ButtonState
	local inherit = self._inherit and self._inherit._inactive

	self._inactive = StyleClass:createStyleFrom{
		name=ButtonStyle.INACTIVE_NAME,
		inherit=inherit,
		parent=self,
		data=data
	}
end

--== .active

function ButtonStyle.__getters:active()
	-- print( "ButtonStyle.__getters:active", self._active )
	return self._active
end
function ButtonStyle.__setters:active( data )
	-- print( "ButtonStyle.__setters:active", data )
	assert( data==nil or type(data)=='string' or type( data )=='table' )
	--==--
	local StyleClass = Widgets.Style.ButtonState
	local inherit = self._inherit and self._inherit._active

	self._active = StyleClass:createStyleFrom{
		name=ButtonStyle.ACTIVE_NAME,
		inherit=inherit,
		parent=self,
		data=data
	}
end

--== .disabled

function ButtonStyle.__getters:disabled()
	-- print( "ButtonStyle.__getters:disabled", self._disabled )
	return self._disabled
end
function ButtonStyle.__setters:disabled( data )
	-- print( "ButtonStyle.__setters:disabled", data )
	assert( data==nil or type(data)=='string' or type( data )=='table' )
	--==--
	local StyleClass = Widgets.Style.ButtonState
	local inherit = self._inherit and self._inherit._disabled

	self._disabled = StyleClass:createStyleFrom{
		name=ButtonStyle.DISABLED_NAME,
		inherit=inherit,
		parent=self,
		data=data
	}
end


--======================================================--
-- Access to style properties

--== .hitMarginX

function ButtonStyle.__getters:hitMarginX()
	-- print( "ButtonStyle.__getters:hitMarginX", self._inherit )
	local value = self._hitMarginX
	if value==nil and self._inherit then
		value = self._inherit.hitMarginX
	end
	return value
end
function ButtonStyle.__setters:hitMarginX( value )
	-- print( "ButtonStyle.__setters:hitMarginX", value, self._inherit )
	assert( (type(value)=='number' and value>=0) or (value==nil and self._inherit) )
	--==--
	if value == self._hitMarginX then return end
	self._hitMarginX = value
	self:_dispatchChangeEvent( 'hitMarginX', value )
end

--== .hitMarginY

function ButtonStyle.__getters:hitMarginY()
	-- print( "ButtonStyle.__getters:hitMarginY" )
	local value = self._hitMarginY
	if value==nil and self._inherit then
		value = self._inherit.hitMarginY
	end
	return value
end
function ButtonStyle.__setters:hitMarginY( value )
	-- print( "ButtonStyle.__setters:hitMarginY", value, self )
	assert( (type(value)=='number' and value>=0) or (value==nil and self._inherit) )
	--==--
	if value==self._hitMarginY then return end
	self._hitMarginY = value
	self:_dispatchChangeEvent( 'hitMarginY', value )
end

--== .isHitActive

function ButtonStyle.__getters:isHitActive()
	-- print( "ButtonStyle.__getters:isHitActive" )
	local value = self._isHitActive
	if value==nil and self._inherit then
		value = self._inherit.isHitActive
	end
	return value
end
function ButtonStyle.__setters:isHitActive( value )
	-- print( "ButtonStyle.__setters:isHitActive", value )
	assert( type(value)=='boolean' or (value==nil and self._inherit) )
	--==--
	if value == self._isHitActive then return end
	self._isHitActive = value
	self:_dispatchChangeEvent( 'isHitActive', value )
end


--======================================================--
-- Misc

function ButtonStyle:_doChildrenInherit( value )
	-- print( "ButtonStyle:_doChildrenInherit", value, self )
	self._inactive.inherit = value and value.inactive
	self._active.inherit = value and value.active
	self._disabled.inherit = value and value.disabled
end


function ButtonStyle:_clearChildrenProperties( style )
	-- print( "ButtonStyle:_clearChildrenProperties", style, self )
	assert( style==nil or type(style)=='table' )
	if style and type(style.isa)=='function' then
		assert( style:isa(ButtonStyle) )
	end
	--==--
	local substyle

	substyle = style and style.active
	self._inactive:_clearProperties( substyle )

	substyle = style and style.inactive
	self._active:_clearProperties( substyle )

	substyle = style and style.disabled
	self._disabled:_clearProperties( substyle )
end



--====================================================================--
--== Private Methods


-- we could have nil, Lua structure, or Instance
--
function ButtonStyle:_prepareData( data )
	-- print("ButtonStyle:_prepareData", data, self )
	if not data then return end
	--==--
	local StyleClass = Widgets.Style.ButtonState
	local createStruct = StyleClass.createStyleStructure

	if data.isa and data:isa( ButtonStyle ) then
		--== Instance
		local o = data
		data = {
			inactive=createStruct(o.inactive.background.view.type),
			active=createStruct(o.active.background.view.type),
			disabled=createStruct(o.disabled.background.view.type)
		}

	else
		--== Lua structure
		local src, dest = data, nil

		dest = src.inactive
		if dest==nil then
			dest = createStruct()
			src.inactive = dest
		end
		StyleClass.copyExistingSrcProperties( dest, src )

		dest = src.active
		if dest==nil then
			dest = createStruct()
			src.active = dest
		end
		StyleClass.copyExistingSrcProperties( dest, src )

		dest = src.disabled
		if dest==nil then
			dest = createStruct()
			src.disabled = dest
		end
		StyleClass.copyExistingSrcProperties( dest, src )

	end

	return data
end



--====================================================================--
--== Event Handlers


-- none




return ButtonStyle
