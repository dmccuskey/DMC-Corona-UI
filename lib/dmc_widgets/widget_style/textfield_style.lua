--====================================================================--
-- dmc_widgets/widget_style/textfield_style.lua
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
--== DMC Corona Widgets : TextField Widget Style
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



--====================================================================--
--== TextField Style Class
--====================================================================--


local TextFieldStyle = newClass( BaseStyle, {name="TextField Style"} )

--== Class Constants

TextFieldStyle.TYPE = 'textfield'

TextFieldStyle.__base_style__ = nil

TextFieldStyle._CHILDREN = {
	background=true,
	hint=true,
	display=true
}

TextFieldStyle._VALID_PROPERTIES = {
	debugOn=true,
	width=true,
	height=true,
	anchorX=true,
	anchorY=true,

	align=true,
	backgroundStyle=true,
	inputType=true,
	isHitActive=true,
	isHitTestable=true,
	isSecure=true,
	marginX=true,
	marginY=true,
	returnKey=true,
}

TextFieldStyle._EXCLUDE_PROPERTY_CHECK = {
	background=true,
	hint=true,
	display=true
}

TextFieldStyle._STYLE_DEFAULTS = {
	name='textfield-default-style',
	debugOn=false,
	width=200,
	height=40,
	anchorX=0.5,
	anchorY=0.5,

	align='center',
	backgroundStyle='none',
	inputType='default',
	isHitActive=true,
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
		type='rectangle',
		view={
			fillColor={0.7,0.7,0.7,1},
			strokeWidth=1,
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
		fontSize=18,
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
		font=native.systemFont,
		fontSize=18,
		textColor={0.1,0.1,0.1,1},
	},

}


TextFieldStyle._TEST_DEFAULTS = {
	name='textfield-test-style',
	debugOn=false,
	width=501,
	height=502,
	anchorX=503,
	anchorY=504,

	align='textf-center',
	backgroundStyle='textf-none',
	inputType='textf-default',
	isHitActive=true,
	isSecure=false,
	marginX=510,
	marginY=511,
	returnKey='done',

	background={
		--[[
		Copied from TextField
		* width
		* height
		* anchorX/Y
		--]]
		type='rectangle',
		view={
			fillColor={501,502,503,504},
			strokeWidth=505,
			strokeColor={511,512,513,514},
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
		fillColor={521,522,523,524},
		font=native.systemFont,
		fontSize=524,
		textColor={523,524,525,526},
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
		fillColor={531,532,533,534},
		font=native.systemFontBold,
		fontSize=534,
		textColor={533,534,535,536},
	},

}

TextFieldStyle.MODE = BaseStyle.RUN_MODE
TextFieldStyle._DEFAULTS = TextFieldStyle._STYLE_DEFAULTS

--== Event Constants

TextFieldStyle.EVENT = 'textfield-style-event'


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
	-- self._width
	-- self._height
	-- self._anchorX
	-- self._anchorY

	self._align = nil
	self._bgStyle = nil
	self._inputType = nil
	self._isHitActive = nil
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


function TextFieldStyle.initialize( manager, params )
	-- print( "TextFieldStyle.initialize", manager )
	params = params or {}
	if params.mode==nil then params.mode=BaseStyle.RUN_MODE end
	--==--
	Widgets = manager

	if params.mode==BaseStyle.TEST_MODE then
		TextFieldStyle.MODE = BaseStyle.TEST_MODE
		TextFieldStyle._DEFAULTS = TextFieldStyle._TEST_DEFAULTS
	end
	local defaults = TextFieldStyle._DEFAULTS

	TextFieldStyle._setDefaults( TextFieldStyle, {defaults=defaults} )

end


function TextFieldStyle.createStyleStructure( src )
	-- print( "TextFieldStyle.createStyleStructure", src )
	src = src or {}
	--==--
	return {
		background=Widgets.Style.Background.createStyleStructure( src.background ),
		hint=Widgets.Style.Text.createStyleStructure( src.hint ),
		display=Widgets.Style.Text.createStyleStructure( src.display ),
	}
end


function TextFieldStyle.addMissingDestProperties( dest, srcs )
	-- print( "TextFieldStyle.addMissingDestProperties", dest, srcs )
	assert( dest )
	srcs = srcs or {}
	local lsrc = { main=srcs.main, parent=srcs.parent, widget=srcs.widget }
	if lsrc.main==nil then lsrc.main=TextFieldStyle._DEFAULTS end
	if lsrc.parent==nil then lsrc.parent=dest end
	lsrc.widget = TextFieldStyle._DEFAULTS
	--==--

	dest = BaseStyle.addMissingDestProperties( dest, lsrc )

	for _, key in ipairs( { 'main', 'parent', 'widget' } ) do
		local src = lsrc[key] or {}

		if dest.align==nil then dest.align=src.align end
		if dest.backgroundStyle==nil then dest.backgroundStyle=src.backgroundStyle end
		if dest.inputType==nil then dest.inputType=src.inputType end
		if dest.isHitActive==nil then dest.isHitActive=src.isHitActive end
		if dest.isSecure==nil then dest.isSecure=src.isSecure end
		if dest.marginX==nil then dest.marginX=src.marginX end
		if dest.marginY==nil then dest.marginY=src.marginY end
		if dest.returnKey==nil then dest.returnKey=src.returnKey end

	end

	dest = TextFieldStyle._addMissingChildProperties( dest, lsrc )

	return dest
end


-- _addMissingChildProperties()
-- copy properties to sub-styles
--
function TextFieldStyle._addMissingChildProperties( dest, srcs )
	-- print("TextFieldStyle._addMissingChildProperties", dest, srcs )
	assert( dest )
	srcs = srcs or {}
	local lsrc = { parent = dest }
	--==--
	local eStr = "ERROR: Style (BackgroundStyle) missing property '%s'"
	local StyleClass, child

	child = dest.background
	-- assert( child, sformat( eStr, 'background' ) )
	StyleClass = Widgets.Style.Background
	lsrc.main = srcs.main and srcs.main.background
	dest.background = StyleClass.addMissingDestProperties( child, lsrc )

	child = dest.hint
	-- assert( child, sformat( eStr, 'hint' ) )
	StyleClass = Widgets.Style.Text
	lsrc.main = srcs.main and srcs.main.hint
	dest.hint = StyleClass.addMissingDestProperties( child, lsrc )

	child = dest.display
	-- assert( child, sformat( eStr, 'display' ) )
	StyleClass = Widgets.Style.Text
	lsrc.main = srcs.main and srcs.main.display
	dest.display = StyleClass.addMissingDestProperties( child, lsrc )

	return dest
end


function TextFieldStyle.copyExistingSrcProperties( dest, src, params)
	-- print( "TextFieldStyle.copyMissingProperties", dest, src )
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
	if (src.backgroundStyle~=nil and dest.backgroundStyle==nil) or force then
		dest.backgroundStyle=src.backgroundStyle
	end
	if (src.inputType~=nil and dest.inputType==nil) or force then
		dest.inputType=src.inputType
	end
	if (src.isHitActive~=nil and dest.isHitActive==nil) or force then
		dest.isHitActive=src.isHitActive
	end
	if (src.isSecure~=nil and dest.isSecure==nil) or force then
		dest.isSecure=src.isSecure
	end
	if (src.marginX~=nil and dest.marginX==nil) or force then
		dest.marginX=src.marginX
	end
	if (src.marginY~=nil and dest.marginY==nil) or force then
		dest.marginY=src.marginY
	end
	if (src.returnKey~=nil and dest.returnKey==nil) or force then
		dest.returnKey=src.returnKey
	end

	return dest
end


function TextFieldStyle._verifyStyleProperties( src, exclude )
	-- print("TextFieldStyle._verifyStyleProperties", src, exclude )
	assert( src, "TextFieldStyle:verifyStyleProperties requires source" )
	--==--
	local emsg = "Style (TextFieldStyle) requires property '%s'"

	local is_valid = BaseStyle._verifyStyleProperties( src, exclude )

	if not src.align then
		print(sformat(emsg,'align')) ; is_valid=false
	end
	if not src.backgroundStyle then
		print(sformat(emsg,'backgroundStyle')) ; is_valid=false
	end
	if not src.inputType then
		print(sformat(emsg,'inputType')) ; is_valid=false
	end
	if src.isHitActive==nil then
		print(sformat(emsg,'isHitActive')) ; is_valid=false
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

	local child, StyleClass

	child = src.background
	if not child then
		print( "TextFieldStyle child test skipped for 'background'" )
		is_valid=false
	else
		StyleClass = Widgets.Style.Background
		if not StyleClass._verifyStyleProperties( child, exclude ) then
			is_valid=false
		end
	end

	child = src.hint
	if not child then
		print( "TextFieldStyle child test skipped for 'hint'" )
		is_valid=false
	else
		StyleClass = Widgets.Style.Text
		if not StyleClass._verifyStyleProperties( child, exclude ) then
			is_valid=false
		end
	end

	child = src.display
	if not child then
		print( "TextFieldStyle child test skipped for 'display'" )
		is_valid=false
	else
		StyleClass = Widgets.Style.Text
		if not StyleClass._verifyStyleProperties( child, exclude ) then
			is_valid=false
		end
	end

	return is_valid
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
	local inherit = self._inherit and self._inherit._background or self._inherit

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
	local inherit = self._inherit and self._inherit._hint or self._inherit

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
	local inherit = self._inherit and self._inherit._display or self._inherit

	self._display = StyleClass:createStyleFrom{
		name=TextFieldStyle.DISPLAY_NAME,
		inherit=inherit,
		parent=self,
		data=data
	}
end


--======================================================--
-- Background Style Properties

--== fillColor

function TextFieldStyle.__getters:backgroundFillColor()
	-- print( "TextFieldStyle.__getters:backgroundFillColor" )
	return self._background.fillColor
end
function TextFieldStyle.__setters:backgroundFillColor( value )
	-- print( "TextFieldStyle.__setters:backgroundFillColor", value )
	self._background.fillColor = value
end

--== strokeColor

function TextFieldStyle.__getters:backgroundStrokeColor()
	-- print( "TextFieldStyle.__getters:backgroundStrokeColor" )
	return self._background.strokeColor
end
function TextFieldStyle.__setters:backgroundStrokeColor( value )
	-- print( "TextFieldStyle.__setters:backgroundStrokeColor", value )
	self._background.strokeColor = value
end

--== strokeWidth

function TextFieldStyle.__getters:backgroundStrokeWidth()
	-- print( "TextFieldStyle.__getters:backgroundStrokeWidth" )
	return self._background.strokeWidth
end
function TextFieldStyle.__setters:backgroundStrokeWidth( value )
	-- print( "TextFieldStyle.__setters:backgroundStrokeWidth", value )
	self._background.strokeWidth = value
end


--======================================================--
-- Hint Style Properties

--== font

function TextFieldStyle.__getters:hintFont()
	-- print( "TextFieldStyle.__getters:hintFont" )
	return self._hint.font
end
function TextFieldStyle.__setters:hintFont( value )
	-- print( "TextFieldStyle.__setters:hintFont", value )
	self._hint.font = value
end

--== fontSize

function TextFieldStyle.__getters:hintFontSize()
	-- print( "TextFieldStyle.__getters:hintFontSize" )
	return self._hint.fontSize
end
function TextFieldStyle.__setters:hintFontSize( value )
	-- print( "TextFieldStyle.__setters:hintFontSize", value )
	self._hint.fontSize = value
end

--== textColor

function TextFieldStyle.__getters:hintTextColor()
	-- print( "TextFieldStyle.__getters:hintTextColor" )
	return self._hint.textColor
end
function TextFieldStyle.__setters:hintTextColor( value )
	-- print( "TextFieldStyle.__setters:hintTextColor", value )
	self._hint.textColor = value
end


--======================================================--
-- Display Style Properties

--== font

function TextFieldStyle.__getters:displayFont()
	-- print( "TextFieldStyle.__getters:displayFont" )
	return self._display.font
end
function TextFieldStyle.__setters:displayFont( value )
	-- print( "TextFieldStyle.__setters:displayFont", value )
	self._display.font = value
end

--== fontSize

function TextFieldStyle.__getters:displayFontSize()
	-- print( "TextFieldStyle.__getters:displayFontSize" )
	return self._display.fontSize
end
function TextFieldStyle.__setters:displayFontSize( value )
	-- print( "TextFieldStyle.__setters:displayFontSize", value )
	self._display.fontSize = value
end

--== textColor

function TextFieldStyle.__getters:displayTextColor()
	-- print( "TextFieldStyle.__getters:displayTextColor" )
	return self._display.textColor
end
function TextFieldStyle.__setters:displayTextColor( value )
	-- print( "TextFieldStyle.__setters:displayTextColor", value )
	self._display.textColor = value
end


--======================================================--
-- Access to style properties

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
	assert( type(value)=='string' or (value==nil and (self._inherit or self._isClearing))  )
	--==--
	if value == self._bgStyle then return end
	self._bgStyle = value
	self:_dispatchChangeEvent( 'backgroundStyle', value )
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
	assert( type(value)=='string' or (value==nil and (self._inherit or self._isClearing))  )
	--==--
	if value == self._inputType then return end
	self._inputType = value
	self:_dispatchChangeEvent( 'inputType', value )
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
	assert( type(value)=='boolean' or (value==nil and (self._inherit or self._isClearing)) )
	--==--
	if value == self._isHitActive then return end
	self._isHitActive = value
	self:_dispatchChangeEvent( 'isHitActive', value )
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
	assert( type(value)=='boolean' or (value==nil and (self._inherit or self._isClearing)) )
	--==--
	if value==self._isSecure then return end
	self._isSecure = value
	self:_dispatchChangeEvent( 'isSecure', value )
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
	assert( (value==nil and (self._inherit or self._isClearing)) or type(value)=='string' )
	--==--
	if value == self._inputType then return end
	self._returnKey = value
end


--======================================================--
-- Misc



--====================================================================--
--== Private Methods


function TextFieldStyle:_doChildrenInherit( value )
	-- print( "TextFieldStyle:_doChildrenInherit", value )
	if not self._isInitialized then return end

	self._background.inherit = value and value.background or value
	self._hint.inherit = value and value.hint or value
	self._display.inherit = value and value.display or value
end


function TextFieldStyle:_clearChildrenProperties( style, params )
	-- print( "TextFieldStyle:_clearChildrenProperties", style, self )
	assert( style==nil or type(style)=='table' )
	if style and type(style.isa)=='function' then
		assert( style:isa(TextFieldStyle) )
	end
	--==--
	local substyle

	substyle = style and style.background
	self._background:_clearProperties( substyle, params )

	substyle = style and style.hint
	self._hint:_clearProperties( substyle, params )

	substyle = style and style.display
	self._display:_clearProperties( substyle, params )
end


function TextFieldStyle:_destroyChildren()
	self._background:removeSelf()
	self._background=nil

	self._hint:removeSelf()
	self._hint=nil

	self._display:removeSelf()
	self._display=nil
end



-- TODO: more work when inheriting, etc (Background Style)
function TextFieldStyle:_prepareData( data, dataSrc, params )
	-- print("TextFieldStyle:_prepareData", data, self )
	params = params or {}
	--==--
	local inherit = params.inherit
	local StyleClass
	local src, dest, tmp

	if not data then
		data = TextFieldStyle.createStyleStructure( dataSrc )
	end

	src, dest = data, nil

	--== make sure we have structure for children

	StyleClass = Widgets.Style.Background
	if not src.background then
		tmp = dataSrc and dataSrc.background
		src.background = StyleClass.createStyleStructure( tmp )
	end

	StyleClass = Widgets.Style.Text
	if not src.hint then
		tmp = dataSrc and dataSrc.hint
		src.hint = StyleClass.createStyleStructure( tmp )
	end
	if not src.display then
		tmp = dataSrc and dataSrc.display
		src.display = StyleClass.createStyleStructure( tmp )
	end

	--== process depending on inheritance

	if not inherit then
		src = TextFieldStyle.addMissingDestProperties( src, {main=dataSrc} )

	else
		dest = src.background
		src.background = StyleClass.copyExistingSrcProperties( dest, src )

		dest = src.hint
		src.hint = StyleClass.copyExistingSrcProperties( dest, src )

		dest = src.display
		src.display = StyleClass.copyExistingSrcProperties( dest, src )

	end

	return data
end



--====================================================================--
--== Event Handlers


-- none




return TextFieldStyle
