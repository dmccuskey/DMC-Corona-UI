--====================================================================--
-- dmc_widgets/base_textfield_style.lua
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
--== DMC Corona Widgets : Widget TextField Style
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
--== DMC Widgets : newTextFieldStyle
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

--== To be set in initialize()
local Widgets = nil



--====================================================================--
--== TextField Style Class
--====================================================================--


local TextFieldStyle = newClass( BaseStyle, {name="TextField Style"} )

--== Class Constants

RectangleStyle.TYPE = 'textfield'

TextFieldStyle.__base_style__ = nil

-- child styles
TextFieldStyle.BACKGROUND_KEY = 'background'
TextFieldStyle.BACKGROUND_NAME = 'textfield-background'
TextFieldStyle.HINT_KEY = 'hint'
TextFieldStyle.HINT_NAME = 'textfield-hint'
TextFieldStyle.DISPLAY_KEY = 'display'
TextFieldStyle.DISPLAY_NAME = 'textfield-display'

TextFieldStyle._VALID_PROPERTIES = {
	debugOn=true,
	width=true,
	height=true,
	anchorX=true,
	anchorY=true,
	backgroundStyle=true,
	inputType=true,
	isHitActive=true,
	isHitTestable=true,
	isSecure=true,
	marginX=true,
	marginY=true,
	returnKey=true,
}

TextFieldStyle._EXCLUDE_PROPERTY_CHECK = nil

TextFieldStyle._STYLE_DEFAULTS = {
	name='textfield-default-style',
	debugOn=false,

	width=200,
	height=40,

	align='center',
	anchorX=0.5,
	anchorY=0.5,
	backgroundStyle='none',
	inputType='default',
	isHitActive=true,
	isHitTestable=true,
	isSecure=false,
	marginX=0,
	marginY=5,
	returnKey='done',

	background={
		--[[
		Copied from TextField
		* width
		* height
		* anchorX/Y
		--]]
		view={
			type='rectangle',

			fillColor={0.5,0.5,0.2,1},
			strokeWidth=2,
			strokeColor={0,0,0,1},
		}
	},
	hint={
		--[[
		Copied from TextField
		* width
		* height
		* align
		* anchorX/Y
		* marginX/Y
		--]]
		fillColor={0,0,0,0},
		font=native.systemFont,
		fontSize=24,
		textColor={0.3,0.3,0.3,1},
	},
	display={
		--[[
		Copied from TextField
		* width
		* height
		* align
		* anchorX/Y
		* marginX/Y
		--]]
		fillColor={0,0,0,0},
		font=native.systemFontBold,
		fontSize=24,
		textColor={0.1,0.1,0.1,1},
	},

}

--== Event Constants

TextFieldStyle.EVENT = 'textfield-style-event'

-- from super
-- Class.STYLE_UPDATED


--======================================================--
-- Start: Setup DMC Objects

function TextFieldStyle:__init__( params )
	-- print( "TextFieldStyle:__init__", params )
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
	self._background = nil -- Background Style
	self._hint = nil  -- Text Style
	self._display = nil  -- Text Style

end

-- END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Static Methods


function TextFieldStyle.initialize( manager )
	-- print( "TextFieldStyle.initialize", manager )
	Widgets = manager

	TextFieldStyle._setDefaults()
end



-- src is "master" source
function TextFieldStyle.addMissingDestProperties( dest, src, params )
	-- print( "TextFieldStyle.addMissingDestProperties", dest, src )
	assert( dest )
	if not src then return end
	params = params or {}
	if params.force==nil then params.force=false end
	--==--
	local force=params.force

	if dest.debugOn==nil or force then dest.debugOn=src.debugOn end

	if dest.width==nil or force then dest.width=src.width end
	if dest.height==nil or force then dest.height=src.height end

	if dest.align==nil or force then dest.align=src.align end
	if dest.anchorX==nil or force then dest.anchorX=src.anchorX end
	if dest.anchorY==nil or force then dest.anchorY=src.anchorY end
	if dest.backgroundStyle==nil or force then dest.backgroundStyle=src.backgroundStyle end
	if dest.inputType==nil or force then dest.inputType=src.inputType end
	if dest.isHitActive==nil or force then dest.isHitActive=src.isHitActive end
	if dest.isHitTestable==nil or force then dest.isHitTestable=src.isHitTestable end
	if dest.isSecure==nil or force then dest.isSecure=src.isSecure end
	if dest.marginX==nil or force then dest.marginX=src.marginX end
	if dest.marginY==nil or force then dest.marginY=src.marginY end
	if dest.returnKey==nil or force then dest.returnKey=src.returnKey end

	return dest
end


-- src is "master" source
function TextFieldStyle.copyExistingSrcProperties( dest, src, params)
	-- print( "TextFieldStyle.copyMissingProperties", dest, src )
	assert( dest )
	if not src then return end
	params = params or {}
	if params.force==nil then params.force=false end
	--==--
	local force=params.force

	if (src.debugOn~=nil and dest.debugOn==nil) or force then
		src.debugOn=src.debugOn
	end
	if (src.width~=nil and dest.width==nil) or force then
		src.width=src.width
	end
	if (src.height~=nil and dest.height==nil) or force then
		src.height=src.height
	end
	if (src.align~=nil and dest.align==nil) or force then
		src.align=src.align
	end
	if (src.anchorX~=nil and dest.anchorX==nil) or force then
		src.anchorX=src.anchorX
	end
	if (src.anchorY~=nil and dest.anchorY==nil) or force then
		src.anchorY=src.anchorY
	end
	if (src.backgroundStyle~=nil and dest.backgroundStyle==nil) or force then
		src.backgroundStyle=src.backgroundStyle
	end
	if (src.inputType~=nil and dest.inputType==nil) or force then
		src.inputType=src.inputType
	end
	if (src.isHitActive~=nil and dest.isHitActive==nil) or force then
		src.isHitActive=src.isHitActive
	end
	if (src.fillColor~=nil and dest.fillColor==nil) or force then
		src.fillColor=src.fillColor
	end
	if (src.isHitTestable~=nil and dest.isHitTestable==nil) or force then
		src.isHitTestable=src.isHitTestable
	end
	if (src.isSecure~=nil and dest.isSecure==nil) or force then
		src.isSecure=src.isSecure
	end
	if (src.marginX~=nil and dest.marginX==nil) or force then
		src.marginX=src.marginX
	end
	if (src.marginY~=nil and dest.marginY==nil) or force then
		src.marginY=src.marginY
	end
	if (src.returnKey~=nil and dest.returnKey==nil) or force then
		src.returnKey=src.returnKey
	end

	return dest
end


-- create empty button-state-style structure
function TextFieldStyle.createStateStructure( data )
	-- print( "TextFieldStyle.createStateStructure", data )
	return {
		background=Widgets.Style.Background.createStateStructure( data )
		hint=Widgets.Style.Text.createStateStructure(),
		display=Widgets.Style.Text.createStateStructure(),
	}
end



function TextFieldStyle._pushMissingProperties( src )
	-- print("TextFieldStyle._pushMissingProperties", src )
	if not src then return end

	local eStr = "ERROR: Style missing property '%s'"
	local StyleClass, dest

	dest = src.background
	assert( dest, sformat( eStr, 'background' ) )
	StyleClass = Widgets.Style.Background
	StyleClass.addMissingDestProperties( dest, src )

	dest = src.hint
	assert( dest, sformat( eStr, 'hint' ) )
	StyleClass = Widgets.Style.Text
	StyleClass.addMissingDestProperties( dest, src )

	dest = src.display
	assert( dest, sformat( eStr, 'display' ) )
	StyleClass = Widgets.Style.Text
	StyleClass.addMissingDestProperties( dest, src )

	return src
end



function TextFieldStyle._verifyClassProperties( src )
	-- print("TextFieldStyle._verifyClassProperties", src )
	if not src then return end
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
	if not src.align then
		print(sformat(emsg,'align')) ; is_valid=false
	end
	if not src.anchorX then
		print(sformat(emsg,'anchorX')) ; is_valid=false
	end
	if not src.anchorY then
		print(sformat(emsg,'anchorY')) ; is_valid=false
	end
	if not src.backgroundStyle then print(sformat(emsg,'backgroundStyle')) ; is_valid=false
	end
	if not src.inputType then
		print(sformat(emsg,'inputType')) ; is_valid=false
	end
	if src.isHitActive==nil then
		print(sformat(emsg,'isHitActive')) ; is_valid=false
	end
	if src.isHitTestable==nil then
		print(sformat(emsg,'isHitTestable')) ; is_valid=false
	end
	if src.isSecure==nil then
		print(sformat(emsg,'isSecure')) ; is_valid=false
	end
	if not src.marginX then
		print(sformat(emsg,'marginX')) ; is_valid=false
	end
	if not src.marginY then
		print(sformat(emsg,'marginY')) ; is_valid=false
	end
	if not src.returnKey then
		print(sformat(emsg,'returnKey')) ; is_valid=false
	end

	-- check sub-styles

	local StyleClass

	StyleClass = src._background.class
	-- if not StyleClass._checkProperties( src._background ) then is_valid=false end

	StyleClass = src._hint.class
	-- if not StyleClass._checkProperties( src._hint ) then is_valid=false end

	StyleClass = src._display.class
	-- if not StyleClass._checkProperties( self._display ) then is_valid=false end

	return is_valid
end



function TextFieldStyle._setDefaults()
	-- print( "TextFieldStyle._setDefaults" )

	local defaults = TextFieldStyle._STYLE_DEFAULTS

	defaults = TextFieldStyle._pushMissingProperties( defaults )

	local style = TextFieldStyle:new{
		data=defaults
	}
	TextFieldStyle.__base_style__ = style

end


--====================================================================--
--== Public Methods


--======================================================--
-- Access to sub-styles

--== Background

function TextFieldStyle.__getters:background()
	-- print( 'TextFieldStyle.__getters:background', self._background )
	return self._background
end
function TextFieldStyle.__setters:background( data )
	-- print( 'TextFieldStyle.__setters:background', data )
	assert( data==nil or type( data )=='table' )
	--==--
	local StyleClass = Widgets.Style.Background
	local inherit = self._inherit and self._inherit._background

	self._background = StyleClass:createStyleFrom{
		name=TextFieldStyle.BACKGROUND_NAME,
		inherit=inherit,
		parent=self,
		data=data
	}
end

--== Hint

function TextFieldStyle.__getters:hint()
	-- print( "TextFieldStyle.__getters:hint", data )
	return self._hint
end
function TextFieldStyle.__setters:hint( data )
	-- print( "TextFieldStyle.__setters:hint", data )
	assert( data==nil or type( data )=='table' )
	--==--
	local StyleClass = Widgets.Style.Text
	local inherit = self._inherit and self._inherit._hint

	self._hint = StyleClass:createStyleFrom{
		name=TextFieldStyle.HINT_NAME,
		inherit=inherit,
		parent=self,
		data=data
	}
end

--== Display

function TextFieldStyle.__getters:display()
	return self._display
end
function TextFieldStyle.__setters:display( data )
	-- print( 'TextFieldStyle.__setters:display', data )
	assert( data==nil or type( data )=='table' )
	--==--
	local StyleClass = Widgets.Style.Text
	local inherit = self._inherit and self._inherit._display

	self._display = StyleClass:createStyleFrom{
		name=TextFieldStyle.DISPLAY_NAME,
		inherit=inherit,
		parent=self,
		data=data
	}
end


--======================================================--
-- Access to style properties

--== align

function TextFieldStyle.__getters:align()
	-- print( "TextFieldStyle.__getters:align" )
	local value = self._align
	if value==nil and self._inherit then
		value = self._inherit.align
	end
	return value
end
function TextFieldStyle.__setters:align( value )
	-- print( "TextFieldStyle.__setters:align", value )
	assert( (value==nil and self._inherit) or type(value)=='string' )
	--==--
	if value == self._align then return end
	self._align = value
end

--== backgroundStyle

function TextFieldStyle.__getters:backgroundStyle()
	-- print( "TextFieldStyle.__getters:backgroundStyle" )
	local value = self._bgStyle
	if value==nil and self._inherit then
		value = self._inherit.backgroundStyle
	end
	return value
end
function TextFieldStyle.__setters:backgroundStyle( value )
	-- print( "TextFieldStyle.__setters:backgroundStyle", value )
	assert( (value==nil and self._inherit) or type(value)=='string' )
	--==--
	if value == self._bgStyle then return end
	self._bgStyle = value
end

--== inputType

function TextFieldStyle.__getters:inputType()
	-- print( "TextFieldStyle.__getters:inputType" )
	local value = self._inputType
	if value==nil and self._inherit then
		value = self._inherit.inputType
	end
	return value
end
function TextFieldStyle.__setters:inputType( value )
	-- print( "TextFieldStyle.__setters:inputType", value )
	assert( (value==nil and self._inherit) or type(value)=='string' )
	--==--
	if value == self._inputType then return end
	self._inputType = value
end

--== isHitActive

function TextFieldStyle.__getters:isHitActive()
	-- print( "TextFieldStyle.__getters:isHitActive" )
	local value = self._isHitActive
	if value==nil and self._inherit then
		value = self._inherit.isHitActive
	end
	return value
end
function TextFieldStyle.__setters:isHitActive( value )
	-- print( "TextFieldStyle.__setters:isHitActive", value )
	assert( type(value)=='boolean' or (value==nil and self._inherit) )
	--==--
	if value == self._isHitActive then return end
	self._isHitActive = value
	self:_dispatchChangeEvent( 'isHitActive', value )
end

--== isHitTestable

function TextFieldStyle.__getters:isHitTestable()
	-- print( "TextFieldStyle.__getters:isHitTestable" )
	local value = self._isHitTestable
	if value==nil and self._inherit then
		value = self._inherit.isHitTestable
	end
	return value
end
function TextFieldStyle.__setters:isHitTestable( value )
	-- print( "TextFieldStyle.__setters:isHitTestable", value )
	assert( type(value)=='boolean' or (value==nil and self._inherit) )
	--==--
	if value==self._isHitTestable then return end
	self._isHitTestable = value
	self:_dispatchChangeEvent( 'isHitTestable', value )
end

--== isSecure

function TextFieldStyle.__getters:isSecure()
	-- print( "TextFieldStyle.__getters:isSecure" )
	local value = self._isSecure
	if value==nil and self._inherit then
		value = self._inherit.isSecure
	end
	return value
end
function TextFieldStyle.__setters:isSecure( value )
	-- print( "TextFieldStyle.__setters:isSecure", value )
	assert( type(value)=='boolean' or (value==nil and self._inherit) )
	--==--
	if value==self._isSecure then return end
	self._isSecure = value
	self:_dispatchChangeEvent( 'isSecure', value )
end

--== marginX

function TextFieldStyle.__getters:marginX()
	-- print( "TextFieldStyle.__getters:marginX" )
	local value = self._marginX
	if value==nil and self._inherit then
		value = self._inherit.marginX
	end
	return value
end
function TextFieldStyle.__setters:marginX( value )
	-- print( "TextFieldStyle.__setters:marginX", value )
	assert( (type(value)=='number' and value>=0) or (value==nil and self._inherit) )
	--==--
	if value == self._marginX then return end
	self._marginX = value
	self:_dispatchChangeEvent( 'marginX', value )
end

--== marginY

function TextFieldStyle.__getters:marginY()
	-- print( "TextFieldStyle.__getters:marginY" )
	local value = self._marginY
	if value==nil and self._inherit then
		value = self._inherit.marginY
	end
	return value
end
function TextFieldStyle.__setters:marginY( value )
	-- print( "TextFieldStyle.__setters:marginY", value )
	assert( (type(value)=='number' and value>=0) or (value==nil and self._inherit) )
	--==--
	if value == self._marginY then return end
	self._marginY = value
	self:_dispatchChangeEvent( 'marginY', value )
end

--== returnKey

function TextFieldStyle.__getters:returnKey()
	-- print( "TextFieldStyle.__getters:returnKey" )
	local value = self._returnKey
	if value==nil and self._inherit then
		value = self._inherit.returnKey
	end
	return value
end
function TextFieldStyle.__setters:returnKey( value )
	-- print( "TextFieldStyle.__setters:returnKey", value )
	assert( (value==nil and self._inherit) or type(value)=='string' )
	--==--
	if value == self._inputType then return end
	self._returnKey = value
end


--======================================================--
-- Proxy Methods





--======================================================--
-- Misc

--== inherit

function TextFieldStyle.__setters:inherit( value )
	-- print( "TextFieldStyle.__setters:inherit", value )
	BaseStyle.__setters.inherit( self, value )
	--==--
	-- if value
		self._background.inherit = value and value.background or nil
		self._hint.inherit = value and value.hint or nil
		self._display.inherit = value and value.display or nil
end


--== updateStyle

-- force is used when making exact copy of data
--
function TextFieldStyle:updateStyle( src, params )
	-- print( "TextFieldStyle:updateStyle" )
	TextFieldStyle.copyExistingSrcProperties( self, src, params )
end

function TextFieldStyle:verifyClassProperties()
	-- print( "TextFieldStyle:verifyClassProperties" )
	return TextFieldStyle._verifyClassProperties( self )
end



--====================================================================--
--== Private Methods


function TextFieldStyle:_prepareData( data )
	-- print("TextFieldStyle:_prepareData", data )
	if not data then return end
	--==--
	local createStruct = TextFieldStyle.createStateStructure

	if data.isa and data:isa( TextFieldStyle ) then
		--== Instance
		local o = data
		data = createStruct( o.background.view.type )

	else
		--== Lua structure
		local StyleClass
		local src, dest = data, nil

		dest = src.background
		StyleClass = Widgets.Style.Background
		StyleClass.copyExistingSrcProperties( dest, src )

		dest = src.hint
		StyleClass = Widgets.Style.Text
		StyleClass.copyExistingSrcProperties( dest, src )

		dest = src.display
		StyleClass = Widgets.Style.Text
		StyleClass.copyExistingSrcProperties( dest, src )

	end

	return data
end

function TextFieldStyle:_checkChildren()
	-- print( "TextFieldStyle:_checkChildren" )

	-- using setters !!!
	if self._background==nil then self.background=nil end
	if self._hint==nil then self.hint=nil end
	if self._display==nil then self.display=nil end
end



--====================================================================--
--== Event Handlers


-- none




return TextFieldStyle
