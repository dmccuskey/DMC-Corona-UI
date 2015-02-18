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

local Widgets = nil -- set later



--====================================================================--
--== TextField Style Class
--====================================================================--


local TextFieldStyle = newClass( BaseStyle, {name="TextField Style"} )

--== Class Constants

TextFieldStyle.__base_style__ = nil

-- child styles
TextFieldStyle.BACKGROUND_KEY = 'background'
TextFieldStyle.BACKGROUND_NAME = 'textfield-background'
TextFieldStyle.HINT_KEY = 'hint'
TextFieldStyle.HINT_NAME = 'textfield-hint'
TextFieldStyle.DISPLAY_KEY = 'display'
TextFieldStyle.DISPLAY_NAME = 'textfield-display'

TextFieldStyle.DEFAULT = {
	name='textfield-default-style',
	debugOn=false,

	width=200,
	height=40,

	align='center',
	anchorX=0.5,
	anchorY=0.5,
	backgroundStyle='none',
	inputType='password',
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
		fillColor={0.5,0.5,0.2,1},
		isHitTestable=true,
		strokeWidth=2,
		strokeColor={0,0,0,0},
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

	-- other properties are in substyles

	self._width = nil
	self._height = nil

	self._align = nil
	self._anchorX = nil
	self._anchorY = nil
	self._bgStyle = nil
	self._inputType = nil
	self._marginX = nil
	self._marginY = nil
	self._returnKey = nil

	--== Object Refs ==--

	-- these are other style objects
	self._background = nil
	self._hint = nil
	self._display = nil

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




function TextFieldStyle._setDefaults()
	-- print( "TextFieldStyle._setDefaults" )

	local src = TextFieldStyle.DEFAULT
	local StyleClass, dest

	-- copy properties to Background substyle 'background'
	StyleClass = Widgets.Style.Background
	dest = src[ TextFieldStyle.BACKGROUND_KEY ]
	StyleClass.copyMissingProperties( dest, src )

	-- copy properties to Text substyle 'hint'
	StyleClass = Widgets.Style.Text
	dest = src[ TextFieldStyle.HINT_KEY ]
	StyleClass.copyMissingProperties( dest, src )

	-- copy properties to Text substyle 'display'
	StyleClass = Widgets.Style.Text
	dest = src[ TextFieldStyle.DISPLAY_KEY ]
	StyleClass.copyMissingProperties( dest, src )

	local style = TextFieldStyle:new{
		data=defaults
	}
	TextFieldStyle.__base_style__ = style

end



--====================================================================--
--== Public Methods


--== inherit

-- Style Class
--
function TextFieldStyle.__setters:inherit( value )
	-- print( "TextFieldStyle.__setters:inherit", value )
	assert( value:isa(TextFieldStyle) )
	--==--
	self._inherit = value

	self._background.inherit = value.background
	self._hint.inherit = value.hint
	self._display.inherit = value.display
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



--== other styles

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


--== updateStyle

-- force is used when making exact copy of data
--
function TextFieldStyle:updateStyle( info, params )
	-- print( "TextFieldStyle:updateStyle" )
	params = params or {}
	if params.force==nil then params.force=true end
	--==--
	local force=params.force

	if info.debugOn~=nil or force then self.debugOn=info.debugOn end

	--== Widget-level
	if info.width or force then self.width=info.width end
	if info.height or force then self.height=info.height end

	if info.align or force then self.align=info.align end
	if info.anchorX or force then self.anchorX=info.anchorX end
	if info.anchorY or force then self.anchorY=info.anchorY end
	if info.backgroundStyle or force then self.backgroundStyle=info.backgroundStyle end
	if info.inputType or force then self.inputType=info.inputType end
	if info.marginX or force then self.marginX=info.marginX end
	if info.marginY or force then self.marginY=info.marginY end
	if info.returnKey or force then self.returnKey=info.returnKey end

	--== Text-level
	if info.displayColor or force then self.display.textColor=info.displayColor end
	if info.displayFont or force then self.display.font=info.displayFont end
	if info.displayFontSize or force then self.display.fontSize=info.displayFontSize end
	--== Hint-level
	if info.hintColor or force then self.hint.textColor=info.hintColor end
	if info.hintFont or force then self.hint.font=info.hintFont end
	if info.hintFontSize or force then self.hint.fontSize=info.hintFontSize end

	--== Background-level
	if info.marginX or force then self.background.marginX=info.marginX end
	if info.marginY or force then self.background.marginY=info.marginY end

end



--====================================================================--
--== Private Methods


function TextFieldStyle:_prepareData( data )
	-- print("TextFieldStyle:_prepareData", data )
	if not data then return end

	-- copy down data elements to subviews
	local src, dest = data, data.view
	TextFieldStyle.pushMissingProperties( src, dest )

	return data
end


function TextFieldStyle:_checkChildren()
	-- print( "TextFieldStyle:_checkChildren" )
	-- using setters !!!
	if self._background==nil then self.background=nil end
	if self._hint==nil then self.hint=nil end
	if self._display==nil then self.display=nil end
end


function TextFieldStyle:_checkProperties()
	-- print( "TextFieldStyle:_checkProperties" )
	BaseStyle._checkProperties( self )

	-- TODO: add more tests

	assert( self.width, "Style: requires 'width'" )
	assert( self.height, "Style: requires 'height'" )

	assert( self.align, "Style: requires 'align'" )
	assert( self.anchorY, "Style: requires 'anchory'" )
	assert( self.anchorX, "Style: requires 'anchorX'" )
	assert( self.backgroundStyle, "Style: requires 'backgroundStyle'" )
	assert( self.inputType, "Style: requires 'inputType'" )
	assert( self.marginX, "Style: requires 'marginX'" )
	assert( self.marginY, "Style: requires 'marginY'" )
	assert( self.returnKey, "Style: requires 'returnKey'" )

	assert( self._background.strokeWidth, "Style: requires 'background.strokeWidth'" )
	assert( self._background.fillColor, "Style: requires 'background.fillColor'" )
	assert( self._background.strokeColor, "Style: requires 'background.strokeColor'" )

	assert( self.hint.font, "Style: requires 'hint.font'" )
	assert( self.hint.fontSize, "Style: requires 'hint.fontSize'" )
	assert( self.hint.textColor, "Style: requires 'hint.textColor'" )

	assert( self.display.font, "Style: requires 'display.font'" )
	assert( self.display.fontSize, "Style: requires 'display.fontSize'" )
	assert( self.display.textColor, "Style: requires 'display.textColor'" )

end



--====================================================================--
--== Event Handlers


-- none




return TextFieldStyle
