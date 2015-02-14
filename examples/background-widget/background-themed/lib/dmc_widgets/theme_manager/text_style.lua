--====================================================================--
-- dmc_widgets/field_style.lua
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
--== DMC Corona Widgets : Widget Text Style
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
--== DMC Widgets : newTextStyle
--====================================================================--



--====================================================================--
--== Imports


local Objects = require 'dmc_objects'

local BaseStyle = require( widget_find( 'theme_manager.base_style' ) )



--====================================================================--
--== Setup, Constants


local newClass = Objects.newClass
local ObjectBase = Objects.ObjectBase


local Text -- set later



--====================================================================--
--== Text Style Class
--====================================================================--


TextStyle = newClass( BaseStyle, {name="Text Style"}  )

--== Class Constants

-- style state names
TextStyle.DEFAULT = 'default'
TextStyle.DISABLED = 'disabled'
TextStyle.INVALID = 'invalid'


--======================================================--
--== Start: Setup DMC Objects

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


--== END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Static Methods


function TextStyle.__setWidgetManager( manager )
	print( "TextStyle.__setWidgetManager" )
	Widgets = manager
	TextField = Widgets.TextField
end


function TextStyle.createDefaultStyle()
	print( "TextStyle.createDefaultStyle" )
	local default = {
		name="text-basic-style",

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

	return TextStyle:new( default )
end



--====================================================================--
--== Public Methods


function TextStyle.__getters:font()
	return self._font
end
function TextStyle.__setters:font( value )
	print( 'TextStyle.font:x', value )
	assert( type(value)=='string' or type(value)=='userdata' )
	--==--
	if value == self._font then return end
	self._font = value
end


function TextStyle.__getters:fontSize()
	return self._fontSize
end
function TextStyle.__setters:fontSize( value )
	print( 'TextStyle.__setters:fontSize:x', value )
	assert( type(value)=='number' )
	--==--
	if value == self._fontSize then return end
	self._fontSize = value
end


function TextStyle.__getters:color( value )
	return self._color
end
function TextStyle.__setters:color( value )
	print( 'TextStyle.color:x', value )
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
--== Private Methods




--====================================================================--
--== Event Handlers


-- none




return TextStyle
