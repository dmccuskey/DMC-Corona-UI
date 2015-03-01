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
-- local WidgetUtils = require(widget_find( 'widget_utils' ))

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

	align='left',
	hitMarginX=0,
	hitMarginY=0,
	isHitActive=true,
	marginX=0,
	marginY=0,

	font=native.systemFontBold,
	fontSize=16,

	inactive={ -- << this is a Button Style State
		--[[
		Can be copied from Button
		* debugOn
		* width
		* height
		* anchorX/anchorY
		* align
		* isHitActive
		* marginX/marginY
		--]]
		label={
			--[[
			Can be copied from Button State
			* align
			* font*
			* fontSize
			* marginX/marginY
			* offsetX/offsetY
			* textColor
			--]]
			textColor={1,0,0},
		},
		background={
			type='rounded',
			view={
				cornerRadius=3,
				fillColor={0.8,0.8,0.8,1},
				strokeWidth=1,
				strokeColor={0,0,0,1},
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
		* align
		* isHitActive
		* marginX/marginY
		* offsetX/offsetY
		--]]
		label={
			textColor={1,0,0},
		},
		background={
			type='rounded',
			view={
				cornerRadius=3,
				fillColor={0.3,0.3,0.3,1},
				strokeWidth=1,
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
		* anchorX/anchorY
		* align
		* isHitActive
		* marginX/marginY
		* offsetX/offsetY
		--]]
		label={
			textColor={0.3,0.3,0.3,1},
		},
		background={
			type='rounded',
			view={
				cornerRadius=3,
				fillColor={0.8,0.7,0.7,1},
				strokeWidth=1,
				strokeColor={0.4,0.4,0.4,1},
			},
		}
	},

}

ButtonStyle._TEST_DEFAULTS = {
	name='button-test-style',
	debugOn=false,
	width=401,
	height=402,
	anchorX=403,
	anchorY=404,

	align='button-left',
	hitMarginX=401,
	hitMarginY=402,
	isHitActive=true,
	marginX=400,
	marginY=402,

	font=native.systemFontBold,
	fontSize=401,

	inactive={ -- << this is a Button Style State
		align='state-left',
		--[[
		Can be copied from Button
		* debugOn
		* width
		* height
		* anchorX/anchorY
		* align
		* isHitActive
		* marginX/marginY
		--]]
		label={
			--[[
			Can be copied from Button State
			* align
			* font*
			* fontSize
			* marginX/marginY
			* offsetX/offsetY
			* textColor
			--]]
			textColor={410,410,410,410}
		},
		background={
			type='rounded',
			view={
				fillColor={420,420,420,420},
				strokeWidth=420,
				strokeColor={421,421,421,421},
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
		* align
		* isHitActive
		* marginX/marginY
		* offsetX/offsetY
		--]]
		label={
			textColor={412,412,412,412},
			font=native.systemFontBold,
			fontSize=412
		},
		background={
			type='rectangle',
			view={
				fillColor={424,424,424,424},
				strokeWidth=430,
				strokeColor={426,426,426,426},
			},
		}
	},

	disabled={
		--[[
		Can be copied from Button
		* debugOn
		* width
		* height
		* anchorX/anchorY
		* align
		* isHitActive
		* marginX/marginY
		* offsetX/offsetY
		--]]
		label={
			textColor={411,431,441,451},
			font=native.systemFontBold,
			fontSize=430
		},
		background={
			type='rounded',
			view={
				cornerRadius=431,
				fillColor={434,434,434,434},
				strokeWidth=434,
				strokeColor={434,434,434,434},
			},
		}
	},

}

ButtonStyle.MODE = BaseStyle.RUN_MODE
ButtonStyle._DEFAULTS = ButtonStyle._STYLE_DEFAULTS

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


function ButtonStyle.initialize( manager, params )
	-- print( "ButtonStyle.initialize", manager )
	params = params or {}
	if params.mode==nil then params.mode=BaseStyle.RUN_MODE end
	--==--
	Widgets = manager

	if params.mode==BaseStyle.TEST_MODE then
		ButtonStyle.MODE = BaseStyle.TEST_MODE
		ButtonStyle._DEFAULTS = ButtonStyle._TEST_DEFAULTS
	end
	local defaults = ButtonStyle._DEFAULTS

	ButtonStyle._setDefaults( ButtonStyle, {defaults=defaults} )
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
	if lsrc.main==nil then lsrc.main=ButtonStyle._DEFAULTS end
	lsrc.widget = ButtonStyle._DEFAULTS
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
	dest.active = StyleClass.addMissingDestProperties( child, lsrc )

	child = dest.disabled
	-- assert( child, sformat( eStr, 'disabled' ) )
	StyleClass = Widgets.Style.ButtonState
	lsrc.main = srcs.main and srcs.main.disabled
	dest.disabled = StyleClass.addMissingDestProperties( child, lsrc )

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


function ButtonStyle._verifyStyleProperties( src, exclude )
	-- print( "ButtonStyle._verifyStyleProperties", src )
	local emsg = "Style (ButtonStyle) requires property '%s'"

	local is_valid = BaseStyle._verifyStyleProperties( src, exclude )

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
	assert( (type(value)=='number' and value>=0) or (value==nil and (self._inherit or self._isClearing)) )
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
	assert( (type(value)=='number' and value>=0) or (value==nil and (self._inherit or self._isClearing)) )
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
	assert( type(value)=='boolean' or (value==nil and (self._inherit or self._isClearing)) )
	--==--
	if value == self._isHitActive then return end
	self._isHitActive = value
	self:_dispatchChangeEvent( 'isHitActive', value )
end


--======================================================--
-- Misc

function ButtonStyle:_doChildrenInherit( value )
	-- print( "ButtonStyle:_doChildrenInherit", value, self )
	if not self._isInitialized then return end

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


function ButtonStyle:_destroyChildren()
	print( 'ButtonStyle:_destroyChildren', self )

	self._inactive:removeSelf()
	self._inactive=nil

	self._active:removeSelf()
	self._active=nil

	self._disabled:removeSelf()
	self._disabled=nil
end


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
