--====================================================================--
-- dmc_widgets/widget_button/button_state_style.lua
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
--== DMC Corona Widgets : Widget Button State Style
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

local BaseStyle = require( widget_find( 'widget_style.base_style' ) )



--====================================================================--
--== Setup, Constants


local newClass = Objects.newClass
local ObjectBase = Objects.ObjectBase

local sformat = string.format

local Widgets = nil -- set later



--====================================================================--
--== Button-State Style Class
--====================================================================--


local ButtonStateStyle = newClass( BaseStyle, {name="Button State Style"} )

--== Class Constants

ButtonStateStyle.__base_style__ = nil

-- child styles
ButtonStateStyle.LABEL_KEY = 'label'
ButtonStateStyle.LABEL_NAME = 'button-state-label'
ButtonStateStyle.BACKGROUND_KEY = 'background'
ButtonStateStyle.BACKGROUND_NAME = 'button-state-background'

ButtonStateStyle._STYLE_DEFAULTS = {
	name='button-state-default-style',
	debugOn=false,

	-- width=100,
	-- height=40,

	align='center',
	anchorX=0.5,
	anchorY=0.5,
	marginX=0,
	marginY=5,

	label={
		textColor={1,0,0},
		font=native.systemFontBold,
		fontSize=10
	},
	background={
		view={
			type='rectangle',
			fillColor={1,1,0.5, 0.5},
			strokeWidth=6,
			strokeColor={1,0,0,0.5},
		}
	}

}

--== Event Constants

ButtonStateStyle.EVENT = 'button-state-style-event'

-- from super
-- Class.STYLE_UPDATED


--======================================================--
-- Start: Setup DMC Objects

function ButtonStateStyle:__init__( params )
	print( "ButtonStateStyle:__init__", params )
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

	self._align = nil
	self._anchorX = nil
	self._anchorY = nil
	self._bgStyle = nil
	self._inputType = nil
	self._isHitActive = nil
	self._isHitTestable = nil
	self._isSecure = nil
	self._marginX = nil
	self._marginY = nil
	self._returnKey = nil

	--== Object Refs ==--

	-- these are other style objects
	self._background = nil
	self._label = nil

end

-- END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Static Methods


function ButtonStateStyle.initialize( manager )
	-- print( "ButtonStateStyle.initialize", manager )
	Widgets = manager

	ButtonStateStyle._setDefaults()
end


function ButtonStateStyle._setDefaults()
	-- print( "ButtonStateStyle._setDefaults" )

	local defaults = ButtonStateStyle._STYLE_DEFAULTS

	defaults = ButtonStateStyle.pushMissingProperties( defaults )

	local style = ButtonStateStyle:new{
		data=defaults
	}
	ButtonStateStyle.__base_style__ = style

end


function ButtonStateStyle.copyMissingProperties( dest, src )
	print( "ButtonStateStyle.copyMissingProperties", dest, src )
end


function ButtonStateStyle.pushMissingProperties( src )
	print("ButtonStateStyle.pushMissingProperties", src )
	if not src then return end

	local StyleClass, dest
	local eStr = "ERROR: Style missing property '%s'"

	-- copy properties to Text substyle 'label'
	StyleClass = Widgets.Style.Text
	dest = src[ ButtonStateStyle.LABEL_KEY ]
	assert( dest, sformat( eStr, ButtonStateStyle.LABEL_KEY ) )
	StyleClass.copyMissingProperties( dest, src )

	-- copy properties to Background substyle 'background'
	StyleClass = Widgets.Style.Background
	dest = src[ ButtonStateStyle.BACKGROUND_KEY ]
	assert( dest, sformat( eStr, ButtonStateStyle.BACKGROUND_KEY ) )
	StyleClass.copyMissingProperties( dest, src )

	return src
end


--====================================================================--
--== Public Methods


--======================================================--
-- Access to sub-styles

function ButtonStateStyle.__getters:background()
	-- print( 'ButtonStateStyle.__getters:background', self._background )
	return self._background
end
function ButtonStateStyle.__setters:background( data )
	print( 'ButtonStateStyle.__setters:background', data )
	assert( data==nil or type( data )=='table' )
	--==--
	local StyleClass = Widgets.Style.Background
	local inherit = self._inherit and self._inherit._background

	self._background = StyleClass:createStyleFrom{
		name=ButtonStateStyle.BACKGROUND_NAME,
		inherit=inherit,
		parent=self,
		data=data
	}
end


function ButtonStateStyle.__getters:label()
	-- print( "ButtonStateStyle.__getters:label", data )
	return self._label
end
function ButtonStateStyle.__setters:label( data )
	print( "ButtonStateStyle.__setters:label", data )
	assert( data==nil or type( data )=='table' )
	--==--
	local StyleClass = Widgets.Style.Text
	local inherit = self._inherit and self._inherit._label

	self._label = StyleClass:createStyleFrom{
		name=ButtonStateStyle.LABEL_NAME,
		inherit=inherit,
		parent=self,
		data=data
	}
end




--======================================================--
-- Access to style properties

--== align

function ButtonStateStyle.__getters:align()
	-- print( "ButtonStateStyle.__getters:align" )
	local value = self._align
	if value==nil and self._inherit then
		value = self._inherit.align
	end
	return value
end
function ButtonStateStyle.__setters:align( value )
	-- print( "ButtonStateStyle.__setters:align", value )
	assert( (value==nil and self._inherit) or type(value)=='string' )
	--==--
	if value == self._align then return end
	self._align = value
end

--== backgroundStyle

function ButtonStateStyle.__getters:backgroundStyle()
	-- print( "ButtonStateStyle.__getters:backgroundStyle" )
	local value = self._bgStyle
	if value==nil and self._inherit then
		value = self._inherit.backgroundStyle
	end
	return value
end
function ButtonStateStyle.__setters:backgroundStyle( value )
	-- print( "ButtonStateStyle.__setters:backgroundStyle", value )
	assert( (value==nil and self._inherit) or type(value)=='string' )
	--==--
	if value == self._bgStyle then return end
	self._bgStyle = value
end

--== marginX

function ButtonStateStyle.__getters:marginX()
	-- print( "ButtonStateStyle.__getters:marginX" )
	local value = self._marginX
	if value==nil and self._inherit then
		value = self._inherit.marginX
	end
	return value
end
function ButtonStateStyle.__setters:marginX( value )
	-- print( "ButtonStateStyle.__setters:marginX", value )
	assert( (type(value)=='number' and value>=0) or (value==nil and self._inherit) )
	--==--
	if value == self._marginX then return end
	self._marginX = value
	self:_dispatchChangeEvent( 'marginX', value )
end

--== marginY

function ButtonStateStyle.__getters:marginY()
	-- print( "ButtonStateStyle.__getters:marginY" )
	local value = self._marginY
	if value==nil and self._inherit then
		value = self._inherit.marginY
	end
	return value
end
function ButtonStateStyle.__setters:marginY( value )
	-- print( "ButtonStateStyle.__setters:marginY", value )
	assert( (type(value)=='number' and value>=0) or (value==nil and self._inherit) )
	--==--
	if value == self._marginY then return end
	self._marginY = value
	self:_dispatchChangeEvent( 'marginY', value )
end



--======================================================--
-- Proxy Methods





--======================================================--
-- Misc

--== inherit

function ButtonStateStyle.__setters:inherit( value )
	print( "ButtonStateStyle.__setters:inherit", value )
	BaseStyle.__setters.inherit( self, value )
	--==--
	if self._background then
		self._background.inherit = value and value.background or value
	end
	if self._label then
		self._label.inherit = value and value.label or value
	end
end


--== updateStyle

-- force is used when making exact copy of data
--
function ButtonStateStyle:updateStyle( info, params )
	print( "ButtonStateStyle:updateStyle" )
	params = params or {}
	if params.force==nil then params.force=true end
	--==--
	local force=params.force

	if info.debugOn~=nil or force then self.debugOn=info.debugOn end

	if info.width or force then self.width=info.width end
	if info.height or force then self.height=info.height end

	if info.align or force then self.align=info.align end
	if info.anchorX or force then self.anchorX=info.anchorX end
	if info.anchorY or force then self.anchorY=info.anchorY end
	if info.backgroundStyle or force then self.backgroundStyle=info.backgroundStyle end
	if info.inputType or force then self.inputType=info.inputType end
	if info.isHitActive or force then self.isHitActive=info.isHitActive end
	if info.isHitTestable or force then self.isHitTestable=info.isHitTestable end
	if info.isSecure or force then self.isSecure=info.isSecure end
	if info.marginX or force then self.marginX=info.marginX end
	if info.marginY or force then self.marginY=info.marginY end
	if info.returnKey or force then self.returnKey=info.returnKey end

	-- --== Text-level
	-- if info.displayColor or force then self.display.textColor=info.displayColor end
	-- if info.displayFont or force then self.display.font=info.displayFont end
	-- if info.displayFontSize or force then self.display.fontSize=info.displayFontSize end
	-- --== Hint-level
	-- if info.hintColor or force then self.hint.textColor=info.hintColor end
	-- if info.hintFont or force then self.hint.font=info.hintFont end
	-- if info.hintFontSize or force then self.hint.fontSize=info.hintFontSize end

	-- --== Background-level
	-- if info.marginX or force then self.background.marginX=info.marginX end
	-- if info.marginY or force then self.background.marginY=info.marginY end

end



--====================================================================--
--== Private Methods


function ButtonStateStyle:_prepareData( data )
	print("ButtonStateStyle:_prepareData", data )
	if not data then return end
	return ButtonStateStyle.pushMissingProperties( data )
end

function ButtonStateStyle:_checkChildren()
	print( "ButtonStateStyle:_checkChildren" )

	-- using setters !!!
	if self._background==nil then self.background=nil end
	if self._label==nil then self.label=nil end
end

function ButtonStateStyle:_checkProperties()
	print( "ButtonStateStyle:_checkProperties" )
	local emsg = "Style: requires property '%s'"
	local is_valid = BaseStyle._checkProperties( self )

	-- TODO: add more tests

	if not self.width then print(sformat(emsg,'width')) ; is_valid=false end
	if not self.height then print(sformat(emsg,'height')) ; is_valid=false end

	if not self.align then print(sformat(emsg,'align')) ; is_valid=false end
	if not self.anchorX then print(sformat(emsg,'anchorX')) ; is_valid=false end
	if not self.anchorY then print(sformat(emsg,'anchorY')) ; is_valid=false end
	if not self.marginX then print(sformat(emsg,'marginX')) ; is_valid=false end
	if not self.marginY then print(sformat(emsg,'marginY')) ; is_valid=false end

	-- check sub-styles

	local StyleClass

	StyleClass = self._background.class
	-- if not StyleClass._checkProperties( self._background ) then is_valid=false end

	StyleClass = self._label.class
	-- if not StyleClass._checkProperties( self._label ) then is_valid=false end

	return is_valid
end



--====================================================================--
--== Event Handlers


-- none




return ButtonStateStyle
