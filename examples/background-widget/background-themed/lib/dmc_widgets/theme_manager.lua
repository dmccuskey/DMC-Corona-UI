--====================================================================--
-- dmc_widgets/theme_manager.lua
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
--== DMC Corona Widgets : Theme Manager
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
--== DMC Widgets : Theme Mgr
--====================================================================--



--====================================================================--
--== Imports


local Objects = require 'dmc_objects'



--====================================================================--
--== Setup, Constants


local newClass = Objects.newClass
local ObjectBase = Objects.ObjectBase

local ThemeMgrSingleton = nil

local LOCAL_DEBUG = true



--====================================================================--
--== ThemeMgr Widget Class
--====================================================================--


local ThemeMgr = newClass( ObjectBase, {name="Font Manager"}  )


--======================================================--
--== Start: Setup DMC Objects

function ThemeMgr:__init__( params )
	-- print( "ThemeMgr:__init__", params )
	params = params or {}
	self:superCall( '__init__', params )
	--==--

	-- keyed on theme name
	self._themes = {}

	--[[
		registered widgets and styles
		keyed on widget theme id

		textfield={
		<TextField Style Class>
		<TextField Class>
	--]]
	self._registered = {}

end
function ThemeMgr:__undoInit__()
	-- print( "ThemeMgr:__undoInit__" )
	self._font_metrix=nil
	--==--
	self:superCall( '__undoInit__' )
end

--[[
function ThemeMgr:__initComplete__()
	-- print( "ThemeMgr:__initComplete__" )
	self:superCall( '__initComplete__' )
	--==--
end
--]]
--[[
function ThemeMgr:__undoInitComplete__()
	--print( "ThemeMgr:__undoInitComplete__" )
	--==--
	self:superCall( '__undoInitComplete__' )
end
--]]

--== END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Public Methods


function ThemeMgr:registerWidget( name, widget )
	-- print( 'ThemeMgr:registerWidget', name, widget )
	assert( type(name)=='string' )
	assert( widget )
	--==--
	self._registered[ name ] = widget
end



--====================================================================--
--== Private Methods


function ThemeMgr:_getCacheKey( font, font_size )
	return tostring(font).."::"..tostring(font_size)
end

function ThemeMgr:_addToCache( font, font_size, value )
	-- print( 'ThemeMgr:setFontMetric', font, value )
	local key = self:_getCacheKey( font, font_size )
	self._font_cache[ key ] = value
end

function ThemeMgr:_getFromCache( font, font_size )
	-- print( 'ThemeMgr:setFontMetric', font, value )
	local key = self:_getCacheKey( font, font_size )
	return self._font_cache[ key ]
end



--====================================================================--
--== Event Handlers


-- none




ThemeMgrSingleton = ThemeMgr:new()


return ThemeMgrSingleton
