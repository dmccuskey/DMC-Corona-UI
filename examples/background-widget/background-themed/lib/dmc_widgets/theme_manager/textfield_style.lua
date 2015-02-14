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

local BaseStyle = require( widget_find( 'theme_manager.base_style' ) )


--====================================================================--
--== Setup, Constants


local newClass = Objects.newClass
local ObjectBase = Objects.ObjectBase

local TextField -- set later


--====================================================================--
--== TextField Style Class
--====================================================================--


local TextFieldStyle = newClass( BaseStyle, {name="TextField Style"} )


-- style state names
TextFieldStyle.DEFAULT = 'default'
TextFieldStyle.DISABLED = 'disabled'
TextFieldStyle.INVALID = 'invalid'

--======================================================--
--== Start: Setup DMC Objects

function TextFieldStyle:__init__( params )
	print( "TextFieldStyle:__init__", params )
	params = params or {}
	self:superCall( '__init__', params )
	--==--

	--== Sanity Check ==--

	if self.is_class then return end

	-- assert( params.text, "TextFieldStyle: requires param 'text'" )

	--== Style Properties ==--

	-- self._name
	-- self._inherit
	-- self._data

	self._align = nil
	self._anchorX = nil
	self._anchorY = nil

	self._width = nil
	self._height = nil

	self._returnKey = nil
	self._inputType = nil

	self._hint = nil
	self._text = nil
	self._background = nil

end

--== END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Static Methods


function TextFieldStyle.__setWidgetManager( manager )
	print( "TextFieldStyle.__setWidgetManager" )
	Widgets = manager
	TextField = Widgets.TextField
end

function TextFieldStyle.createDefaultStyle()
	print( "TextFieldStyle.createDefaultStyle" )
	local default = {
		name="text-field-basic-style",

		width=250,
		height=40,
		align=TextField.CENTER,
		returnKey='done',
		inputType='password',
		anchorX=0.5,
		anchorY=0.5,
		bgStyle=TextField.BG_STYLE_NONE,

		hint={
			align=TextField.CENTER,
			color={0.4,0.4,0.4,1},
			font=native.systemFont,
			fontSize=22,
		},
		text={
			align=TextField.CENTER,
			color={0,0,0,1},
			font=native.systemFont,
			fontSize=22,
		},
		background={
			strokeWidth=0,
			strokeColor={1,1,0,0.5},
			color={1,0,0,0.5},
			marginX=5,
			marginY=5
		}
	}

	return TextFieldStyle:new( default )
end




--====================================================================--
--== Public Methods


function TextFieldStyle.__getters:align()
	local value = self._align
	if value==nil and self._inherit then
		value = self._inherit._align
	end
	return value
end
function TextFieldStyle.__setters:align( value )
	-- print( 'TextFieldStyle.__setters:align', value )
	assert( (value==nil and self._inherit) or type(value)=='string' )
	--==--
	if value == self._align then return end
	self._align = value
end


function TextFieldStyle.__getters:width( value )
	local value = self._width
	if value==nil and self._inherit then
		value = self._inherit._width
	end
	return value
end
function TextFieldStyle.__setters:width( value )
	print( 'TextFieldStyle.__setters:widthx', value )
	assert( type(value)=='number' )
	--==--
	if value == self._width then return end
	self._width = value
end

function TextFieldStyle.__getters:height( value )
	local value = self._height
	if value==nil and self._inherit then
		value = self._inherit._height
	end
	return value
end
function TextFieldStyle.__setters:height( value )
	-- print( 'TextFieldStyle.__setters:widthx', value )
	assert( type(value)=='number' )
	--==--
	if value == self._height then return end
	self._height = value
end


function TextFieldStyle.__getters:hint( value )
	return self._hint
end
function TextFieldStyle.__setters:hint( value )
	print( 'TextFieldStyle.hint:x', value )
	assert( type(value)=='table' )
	--==--
	if value.isa then
		assert( value:isa( Widgets.TextStyle ) )
		self._hint = value
	else
		value.child=true
		self._hint = Widgets.newTextStyle( value )
	end
end


function TextFieldStyle.__getters:text( value )
	return self._text
end
function TextFieldStyle.__setters:text( value )
	print( 'TextFieldStyle.text:x', value )
	assert( type(value)=='table' )
	--==--
	if value.isa then
		assert( value:isa( Widgets.TextStyle ) )
		self._text = value
	else
		value.child=true
		self._text = Widgets.newTextStyle( value )
	end
end


function TextFieldStyle.__getters:background( value )
	local value = self._background
	if value==nil and self._inherit then
		value = self._inherit._background
	end
	return value
end
function TextFieldStyle.__setters:background( value )
	print( 'TextFieldStyle.background:x', value )
	assert( (value==nil and self._inherit) or type(value)=='table' )
	--==--
	if value==nil then
		-- pass, no processing
	elseif value.isa then
		assert( value:isa( Widgets.BackgroundStyle ) )
	else
		value.child=true
		print("create bck")
		value = Widgets.newBackgroundStyle( value )
	end
	self._background = value
end


function TextFieldStyle:updateStyle( params )
	-- print( "TextFieldStyle:updateStyle" )

	--== Widget-level
	if params.width then self.width=params.width end
	if params.height then self.height=params.height end
	if params.align then self.align=params.align end
	if params.returnKey then self.returnKey=params.returnKey end
	if params.inputType then self.inputType=params.inputType end

	--== Text-level
	if params.textColor then self.text.color=params.textColor end
	if params.textFont then self.text.font=params.textFont end
	if params.textFontSize then self.text.fontSize=params.textFontSize end
	--== Hint-level
	if params.hintColor then self.hint.color=params.hintColor end
	if params.hintFont then self.hint.font=params.hintFont end
	if params.hintFontSize then self.hint.fontSize=params.hintFontSize end

	--== Background-level
	if params.marginX then self.background.marginX=params.marginX end
	if params.marginY then self.background.marginY=params.marginY end

end



--====================================================================--
--== Private Methods




--====================================================================--
--== Event Handlers


-- none




return TextFieldStyle
