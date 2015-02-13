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
--== DMC Corona Widgets : Base Widget TextFieldStyle
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
--== DMC Widgets : newTextFieldStyle Base
--====================================================================--



--====================================================================--
--== Imports


local Objects = require 'dmc_objects'

-- -- these are set later
-- local Widgets = nil
-- local FontMgr = nil



--====================================================================--
--== Setup, Constants


-- setup some aliases to make code cleaner
local newClass = Objects.newClass
local ObjectBase = Objects.ObjectBase



--====================================================================--
--== TextFieldStyle Widget Class
--====================================================================--


local TextFieldStyle = newClass( ObjectBase, {name="TextFieldStyle Style"}  )



--======================================================--
--== Start: Setup DMC Objects

--== Init

function TextFieldStyle:__init__( params )
	-- print( "TextFieldStyle:__init__", params )
	params = params or {}
	self:superCall( '__init__', params )
	--==--

	--== Sanity Check ==--

	if self.is_class then return end

	-- assert( params.text, "TextFieldStyle: requires param 'text'" )

	self._name = ""
	self._properties = {}

end

function TextFieldStyle:__undoInit__()
	-- print( "TextFieldStyle:__undoInit__" )
	--==--
	self:superCall( '__undoInit__' )
end



--== initComplete

--[[
function TextFieldStyle:__initComplete__()
	-- print( "TextFieldStyle:__initComplete__" )
	self:superCall( '__initComplete__' )
	--==--
end

function TextFieldStyle:__undoInitComplete__()
	--print( "TextFieldStyle:__undoInitComplete__" )
	--==--
	self:superCall( '__undoInitComplete__' )
end
--]]

--== END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Static Methods


function TextFieldStyle.__setWidgetManager( manager )
	-- print( "TextFieldStyle.__setWidgetManager" )
	-- Widgets = manager
	-- FontMgr = Widgets.FontMgr
end



--====================================================================--
--== Public Methods



function TextFieldStyle.__getters:placeholder( value )
	return self._name
end
function TextFieldStyle.__setters:placeholder( value )
	-- print( 'TextFieldStyle.__setters:x', value )
	assert( value:isa( TextStyle ) )
	--==--
	if value == self._name then return end
	self._name = value
end


function TextFieldStyle.__getters:text( value )
	return self._name
end
function TextFieldStyle.__setters:text( value )
	-- print( 'TextFieldStyle.__setters:x', value )
	assert( type(value)=='string' )
	--==--
	if value == self._name then return end
	self._name = value
end


function TextFieldStyle.__getters:background( value )
	return self._name
end
function TextFieldStyle.__setters:background( value )
	-- print( 'TextFieldStyle.__setters:x', value )
	assert( type(value)=='string' )
	--==--
	if value == self._name then return end
	self._name = value
end





--====================================================================--
--== Private Methods




--====================================================================--
--== Event Handlers


-- none




return TextFieldStyle
