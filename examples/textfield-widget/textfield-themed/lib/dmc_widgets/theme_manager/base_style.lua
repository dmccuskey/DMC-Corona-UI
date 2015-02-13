--====================================================================--
-- dmc_widgets/base_style.lua
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
--== DMC Corona Widgets : Base Widget Style
--====================================================================--


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.1.0"



--====================================================================--
--== DMC Widgets Setup
--====================================================================--


local dmc_widget_data, dmc_widget_func
dmc_widget_data = _G.__dmc_widget
dmc_widget_func = dmc_widget_data.func



--====================================================================--
--== DMC Widgets : newStyle Base
--====================================================================--



--====================================================================--
--== Imports


local Objects = require 'dmc_objects'

-- these are set later
local Widgets = nil
local TextField = nil



--====================================================================--
--== Setup, Constants


-- setup some aliases to make code cleaner
local newClass = Objects.newClass
local ObjectBase = Objects.ObjectBase


local Style, TextStyle, TextFieldStyle
local BackgroundStyle



--====================================================================--
--== Style Base Class
--====================================================================--


Style = newClass( ObjectBase, {name="Style Base"}  )

function Style:__init__( params )
	-- print( "Style:__init__", params )
	params = params or {}
	self:superCall( '__init__', params )
	--==--

	if self.is_class then return end

	assert( params.child==true or params.name, "Style: requires param 'name'" )

	self._name = params.name
	self._inherit = nil
	self._data = params

	--== Style Properties

end

function Style:__initComplete__()
	self:superCall( '__initComplete__' )

	self:_parseData( self._data )
end



--====================================================================--
--== Public Methods


--== name, getter/setter

function Style.__getters:name( value )
	return self._name
end
function Style.__setters:name( value )
	-- print( 'Style.__setters:name', value )
	assert( type(value)=='string' )
	--==--
	if value == self._name then return end
	self._name = value
end

function Style:_parseData( data )
	-- print( "Style:_parseData")

	for k,v in pairs( data ) do
		-- print(k,v)
		self[k]=v
	end
end




--====================================================================--
--== TextStyle Widget Class
--====================================================================--


TextStyle = newClass( Style, {name="TextStyle Style"}  )

function TextStyle:__init__( params )
	-- print( "TextStyle:__init__", params )
	params = params or {}
	self:superCall( '__init__', params )
	--==--

	--== Sanity Check ==--

	if self.is_class then return end

	-- assert( params.text, "TextStyle: requires param 'text'" )

	--== Style Properties ==--
	-- self._name
	-- self._inherit
	-- self._data

	self._font = nil
	self._fontSize = nil
	self._color = nil
	self._align = nil

end



--====================================================================--
--== Public Methods


function TextStyle.__getters:font()
	return self._font
end
function TextStyle.__setters:font( value )
	-- print( 'TextStyle.font:x', value )
	assert( type(value)=='string' or type(value)=='userdata' )
	--==--
	if value == self._font then return end
	self._font = value
end


function TextStyle.__getters:fontSize()
	return self._fontSize
end
function TextStyle.__setters:fontSize( value )
	-- print( 'TextStyle.__setters:fontSize:x', value )
	assert( type(value)=='number' )
	--==--
	if value == self._fontSize then return end
	self._fontSize = value
end


function TextStyle.__getters:color( value )
	return self._color
end
function TextStyle.__setters:color( value )
	-- print( 'TextStyle.color:x' )
	self._color = value
end


function TextStyle.__getters:align( value )
	return self._align
end
function TextStyle.__setters:align( value )
	-- print( 'TextStyle.align:x', value )
	assert( type(value)=='string' )
	--==--
	if value == self._align then return end
	self._align = value
end








--====================================================================--
--== TextField Style Class
--====================================================================--


TextFieldStyle = newClass( Style, {name="TextField Style"} )


function TextFieldStyle:__init__( params )
	-- print( "TextFieldStyle:__init__", params )
	params = params or {}
	self:superCall( '__init__', params )
	--==--

	--== Sanity Check ==--

	if self.is_class then return end

	-- assert( params.text, "TextFieldStyle: requires param 'text'" )

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



--====================================================================--
--== Public Methods


function TextFieldStyle.__getters:walign( value )
	return self._walign
end
function TextFieldStyle.__setters:walign( value )
	-- print( 'TextFieldStyle.__setters:align', value )
	assert( type(value)=='string' )
	--==--
	if value == self._align then return end
	self._walign = value
end


function TextFieldStyle.__getters:width( value )
	return self._width
end
function TextFieldStyle.__setters:width( value )
	-- print( 'TextFieldStyle.__setters:widthx', value )
	assert( type(value)=='number' )
	--==--
	if value == self._width then return end
	self._width = value
end

function TextFieldStyle.__getters:height( value )
	return self._height
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
	-- print( 'TextFieldStyle.hint:x', value )
	assert( type(value)=='table' )
	--==--
	if value.isa then
		assert( value:isa( TextStyle ) )
	else
		value.child=true
		TextStyle:new( value )
	end
	self._hint = value
end


function TextFieldStyle.__getters:text( value )
	return self._text
end
function TextFieldStyle.__setters:text( value )
	-- print( 'TextFieldStyle.text:x', value )
	assert( type(value)=='table' )
	--==--
	if value.isa then
		assert( value:isa( TextStyle ) )
		self._text = value
	else
		value.child=true
		self._text = TextStyle:new( value )
	end
end


function TextFieldStyle.__getters:background( value )
	return self._background
end
function TextFieldStyle.__setters:background( value )
	-- print( 'TextFieldStyle.background:x', value )
	assert( type(value)=='table' )
	--==--
	if value.isa then
		assert( value:isa( BackgroundStyle ) )
		self._background = value
	else
		value.child=true
		self._background = BackgroundStyle:new( value )
	end
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

function TextFieldStyle:createDefaultStyle()
	-- print( "TextFieldStyle:createDefaultStyle" )
	local default = {
		name="text-field-basic",

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
--== Background Style Class
--====================================================================--


BackgroundStyle = newClass( Style, {name="Background Style"}  )

function BackgroundStyle:__init__( params )
	-- print( "BackgroundStyle:__init__", params )
	params = params or {}
	self:superCall( '__init__', params )
	--==--

	--== Sanity Check ==--

	if self.is_class then return end

	-- assert( params.text, "BackgroundStyle: requires param 'text'" )

	--== Style Properties ==--
	-- self._name
	-- self._inherit
	-- self._data

	self._color = nil
	self._marginX = nil
	self._marginY = nil
	self._style = nil
	self._strokeColor = nil
	self._strokeWidth = nil

end



--====================================================================--
--== Public Methods


function BackgroundStyle.__getters:align( value )
	return self._align
end
function BackgroundStyle.__setters:align( value )
	-- print( 'BackgroundStyle.__setters:x', value )
	assert( type(value)=='string' )
	--==--
	if value == self._align then return end
	self._align = value
end



function BackgroundStyle.__getters:color()
	return self._color
end
function BackgroundStyle.__setters:color( value )
	-- print( 'BackgroundStyle.fillColor:x', value )
	--==--
	self._color = value
end


function BackgroundStyle.__getters:marginX()
	return self._marginX
end
function BackgroundStyle.__setters:marginX( value )
	-- print( 'BackgroundStyle.marginX:x', value )
	assert( type(value)=='number' )
	--==--
	if value == self._marginX then return end
	self._marginX = value
end



function BackgroundStyle.__getters:marginY()
	return self._marginY
end
function BackgroundStyle.__setters:marginY( value )
	-- print( 'BackgroundStyle.marginY:x', value )
	assert( type(value)=='number' )
	--==--
	if value == self._marginY then return end
	self._marginY = value
end



function BackgroundStyle.__getters:style()
	return self._style
end
function BackgroundStyle.__setters:style( value )
	-- print( 'BackgroundStyle.__setters:x', value )
	assert( type(value)=='string' )
	--==--
	if value == self._style then return end
	self._style = value
end


function BackgroundStyle.__getters:strokeWidth( value )
	return self._strokeWidth
end
function BackgroundStyle.__setters:strokeWidth( value )
	-- print( 'BackgroundStyle.__setters:x', value )
	assert( type(value)=='number' )
	--==--
	if value == self._strokeWidth then return end
	self._strokeWidth = value
end


function BackgroundStyle.__getters:strokeColor()
	return self._strokeColor
end
function BackgroundStyle.__setters:strokeColor( value )
	-- print( 'BackgroundStyle.__setters:x', value )
	--==--
	self._strokeColor = value
end





local function setWidgetManager( manager )

	Widgets = manager
	TextField = Widgets.TextField
end




return {
	__setWidgetManager=setWidgetManager,


	Base=Style,
	Text=TextStyle,
	TextField=TextFieldStyle,
	Background=BackgroundStyle,

}
