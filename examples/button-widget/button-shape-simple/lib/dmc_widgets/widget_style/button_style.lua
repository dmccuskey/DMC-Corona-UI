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
--== DMC Widgets : newButtonStyle
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



--====================================================================--
--== Background Style Class
--====================================================================--


local ButtonStyle = newClass( BaseStyle, {name="Background Style"} )

--== Class Constants

--[[

obj - state - part
button1.active.label
button1.disabled.background

button1.labelText="hello"
button1.labelFontSize=native.systemFont
button.anchorX

button1.active.labelText="pressed"

--]]

ButtonStyle.__base_style__ = nil

-- child styles
ButtonStyle.INACTIVE_KEY = 'inactive'
ButtonStyle.INACTIVE_NAME = 'button-inactive-state'
ButtonStyle.ACTIVE_KEY = 'active'
ButtonStyle.ACTIVE_NAME = 'button-active-state'
ButtonStyle.DISABLED_KEY = 'disabled'
ButtonStyle.DISABLED_NAME = 'button-disabled-state'

ButtonStyle._STYLE_DEFAULTS = {
	name='button-default-style',
	debugOn=false,

	width=75,
	height=30,

	align='center',
	anchorX=0.5,
	anchorY=0.5,
	hitMarginX=0,
	hitMarginY=0,
	isHitActive=true,

	-- label={ -- << this is a text widget
	-- 	debugOn=false,

	-- 	width=10,
	-- 	height=10,

	-- 	align='right',
	-- 	anchorX=0.5,
	-- 	anchorY=0.5,
	-- 	font=native.systemFont,
	-- 	fontSize=12,
	-- 	marginX=5,
	-- 	marginY=5,
	-- 	offsetX=5,
	-- 	offsetY=5,
	-- 	textColor={0,1,0,0.5}
	-- },

	-- background={ -- << this is a background widget
	-- 	debugOn=false,

	-- 	width=10,
	-- 	height=10,

	-- 	anchorX=0.5,
	-- 	anchorY=0.5,

	-- 	type='rounded',
	-- 	cornerRadius = 10,
	-- 	fillColor={1,1,1,1},
	-- 	strokeWidth=1,
	-- 	strokeColor={0,0,0,1},
	-- },

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
			view={
				type='rounded',
				cornerRadius = 10,
				fillColor={0,1,1,1},
				strokeWidth=1,
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
			view={
				type='rounded',
				cornerRadius = 10,
				fillColor={0,1,0,1},
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
			view={
				type='rounded',
				cornerRadius = 10,
				fillColor={0,0,1,1},
				strokeWidth=1,
				strokeColor={0,1,0,1},
			},
		}
	},

}



--== Event Constants

ButtonStyle.EVENT = 'background-style-event'

-- from super
-- Class.STYLE_UPDATED


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

	--== Local style properties

	self._width = nil
	self._height = nil

	self._anchorX = nil
	self._anchorY = nil
	self._hitMarginX = nil
	self._hitMarginY = nil
	self._isHitActive = nil

	--== Object Refs ==--

	-- these are other style objects
	-- each button_state_style
	self._inactive = nil
	self._active = nil
	self._disabled = nil

end

-- END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Static Methods


function ButtonStyle.initialize( manager )
	print( "ButtonStyle.initialize", manager )
	Widgets = manager

	ButtonStyle._setDefaults()
end


function ButtonStyle._setDefaults()
	print( "ButtonStyle._setDefaults" )

	local defaults = ButtonStyle._STYLE_DEFAULTS

	defaults = ButtonStyle.pushMissingProperties( defaults )

	local style = ButtonStyle:new{
		data=defaults
	}
	ButtonStyle.__base_style__ = style
end


-- copyMissingProperties()
-- copies properties from src structure to dest structure
-- if property isn't already in dest
-- Note: usually used by OTHER classes
--
function ButtonStyle.copyMissingProperties( dest, src )
	print( "ButtonStyle.copyMissingProperties", dest, src )
	if dest.debugOn==nil then dest.debugOn=src.debugOn end

	if dest.width==nil then dest.width=src.width end
	if dest.height==nil then dest.height=src.height end

	if dest.anchorX==nil then dest.anchorX=src.anchorX end
	if dest.anchorY==nil then dest.anchorY=src.anchorY end
	if dest.fillColor==nil then dest.fillColor=src.fillColor end
	if dest.strokeColor==nil then dest.strokeColor=src.strokeColor end
	if dest.strokeWidth==nil then dest.strokeWidth=src.strokeWidth end
end


function ButtonStyle.pushMissingProperties( src )
	print("ButtonStyle.pushMissingProperties", src )
	if not src then return end

	local StyleClass, dest
	local eStr = "ERROR: Style missing property '%s'"

	-- copy items to substyle 'inactive'
	dest = src[ ButtonStyle.INACTIVE_KEY ]
	StyleClass = Widgets.Style.ButtonState
	StyleClass.copyMissingProperties( dest, src )

	-- copy items to substyle 'active'
	dest = src[ ButtonStyle.ACTIVE_KEY ]
	StyleClass = Widgets.Style.ButtonState
	StyleClass.copyMissingProperties( dest, src )

	-- copy items to substyle 'disabled'
	dest = src[ ButtonStyle.DISABLED_KEY ]
	StyleClass = Widgets.Style.ButtonState
	StyleClass.copyMissingProperties( dest, src )

	return src
end



--====================================================================--
--== Public Methods


--======================================================--
-- Access to sub-styles

--== Inactive

function ButtonStyle.__getters:inactive()
	-- print( "ButtonStyle.__getters:inactive", self._inactive )
	return self._inactive
end
function ButtonStyle.__setters:inactive( data )
	print( "\n\nButtonStyle.__setters:inactive", data )
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

--== Active

function ButtonStyle.__getters:active()
	-- print( "ButtonStyle.__getters:active", self._active )
	return self._active
end
function ButtonStyle.__setters:active( data )
	print( "\n\nButtonStyle.__setters:active", data )
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

--== Disabled

function ButtonStyle.__getters:disabled()
	-- print( "ButtonStyle.__getters:disabled", self._disabled )
	return self._disabled
end
function ButtonStyle.__setters:disabled( data )
	print( "\n\nButtonStyle.__setters:disabled", data )
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

--== hitMarginX

-- function ButtonStyle.__getters:hitMarginX()
-- 	-- print( "ButtonStyle.__getters:hitMarginX" )
-- 	local value = self._hitMarginX
-- 	if value==nil and self._inherit then
-- 		value = self._inherit.hitMarginX
-- 	end
-- 	return value
-- end
-- function ButtonStyle.__setters:hitMarginX( value )
-- 	-- print( "ButtonStyle.__setters:hitMarginX", value )
-- 	assert( (type(value)=='number' and value>=0) or (value==nil and self._inherit) )
-- 	--==--
-- 	if value == self._hitMarginX then return end
-- 	self._hitMarginX = value
-- 	self:_dispatchChangeEvent( 'hitMarginX', value )
-- end

-- --== hitMarginY

-- function ButtonStyle.__getters:hitMarginY()
-- 	-- print( "ButtonStyle.__getters:hitMarginY" )
-- 	local value = self._hitMarginY
-- 	if value==nil and self._inherit then
-- 		value = self._inherit.hitMarginY
-- 	end
-- 	return value
-- end
-- function ButtonStyle.__setters:hitMarginY( value )
-- 	-- print( "ButtonStyle.__setters:hitMarginY", value )
-- 	assert( (type(value)=='number' and value>=0) or (value==nil and self._inherit) )
-- 	--==--
-- 	if value == self._hitMarginY then return end
-- 	self._hitMarginY = value
-- 	self:_dispatchChangeEvent( 'hitMarginY', value )
-- end

-- --== isHitActive

-- function ButtonStyle.__getters:isHitActive()
-- 	-- print( "ButtonStyle.__getters:isHitActive" )
-- 	local value = self._isHitActive
-- 	if value==nil and self._inherit then
-- 		value = self._inherit.isHitActive
-- 	end
-- 	return value
-- end
-- function ButtonStyle.__setters:isHitActive( value )
-- 	-- print( "ButtonStyle.__setters:isHitActive", value )
-- 	assert( type(value)=='boolean' or (value==nil and self._inherit) )
-- 	--==--
-- 	if value == self._isHitActive then return end
-- 	self._isHitActive = value
-- 	self:_dispatchChangeEvent( 'isHitActive', value )
-- end

-- --== isHitTestable

-- function ButtonStyle.__getters:isHitTestable()
-- 	local value = self._isHitTestable
-- 	if value==nil and self._inherit then
-- 		value = self._inherit.isHitTestable
-- 	end
-- 	return value
-- end
-- function ButtonStyle.__setters:isHitTestable( value )
-- 	-- print( "ButtonStyle.__setters:isHitTestable", value )
-- 	assert( type(value)=='boolean' or (value==nil and self._inherit) )
-- 	--==--
-- 	if value==self._isHitTestable then return end
-- 	self._isHitTestable = value
-- 	self:_dispatchChangeEvent( 'isHitTestable', value )
-- end


--======================================================--
-- Misc

--== inherit

function ButtonStyle.__setters:inherit( value )
	print( "ButtonStyle.__setters:inherit", value )
	BaseStyle.__setters.inherit( self, value )
	--==--
	self._defalt.inherit = value and value.defalt or value
	self._active.inherit = value and value.active or value
	self._disabled.inherit = value and value.disabled or value
end


--== updateStyle

-- force is used when making exact copy of data
--
function ButtonStyle:updateStyle( src, params )
	print( "ButtonStyle:updateStyle", src )
	params = params or {}
	if params.force==nil then params.force=true end
	--==--
	local force=params.force

	if src.debugOn~=nil or force then self.debugOn=src.debugOn end

	if src.width~=nil or force then self.width=src.width end
	if src.height~=nil or force then self.height=src.height end

	if src.anchorX~=nil or force then self.anchorX=src.anchorX end
	if src.anchorY~=nil or force then self.anchorY=src.anchorY end
	-- if src.hitMarginX~=nil or force then self.hitMarginX=src.hitMarginX end
	-- if src.hitMarginY~=nil or force then self.hitMarginY=src.hitMarginY end
	-- if src.isHitActive~=nil or force then self.isHitActive=src.isHitActive end
	-- if src.isHitTestable~=nil or force then self.isHitTestable=src.isHitTestable end
end



--====================================================================--
--== Private Methods


-- we could have nil, Lua structure, or Instance
--
function ButtonStyle:_prepareData( data )
	print("ButtonStyle:_prepareData", data, self )
	if not data then return end
	return ButtonStyle.pushMissingProperties( data )
end

function ButtonStyle:_checkChildren()
	print( "ButtonStyle:_checkChildren" )

	-- using setters !!!
	if self._inactive==nil then self.inactive=nil end
	if self._active==nil then self.active=nil end
	if self._disabled==nil then self.disabled=nil end
end

function ButtonStyle:_checkProperties()
	print( "ButtonStyle._checkProperties" )
	local emsg = "Style: requires property '%s'"
	local is_valid = BaseStyle._checkProperties( self )

	if not self.width then print(sformat(emsg,'width')) ; is_valid=false end
	if not self.height then print(sformat(emsg,'height')) ; is_valid=false end

	if not self.anchorX then print(sformat(emsg,'anchorX')) ; is_valid=false end
	if not self.anchorY then print(sformat(emsg,'anchorY')) ; is_valid=false end
	-- if self.hitMarginX<0 then print(sformat(emsg,'hitMarginX')) ; is_valid=false end
	-- if self.hitMarginY<0 then print(sformat(emsg,'hitMarginY')) ; is_valid=false end
	-- if not type(self.isHitActive)=='boolean' then print(sformat(emsg,'isHitActive')) ; is_valid=false end
	-- if not type(self.isHitTestable)=='boolean' then print(sformat(emsg,'isHitTestable')) ; is_valid=false end

	-- check sub-styles ??

	local StyleClass

	StyleClass = self._inactive.class
	-- if not StyleClass._checkProperties( self._inactive ) then is_valid=false end

	StyleClass = self._active.class
	-- if not StyleClass._checkProperties( self._active ) then is_valid=false end

	StyleClass = self._disabled.class
	-- if not StyleClass._checkProperties( self._disabled ) then is_valid=false end

	return is_valid
end



--====================================================================--
--== Event Handlers


-- none




return ButtonStyle
