--====================================================================--
-- dmc_widgets/style_manager.lua
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
--== DMC Corona Widgets : Style Manager
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
--== DMC Widgets : Style Manager
--====================================================================--



--====================================================================--
--== Imports


local Objects = require 'dmc_objects'
local LuaPatch = require 'lib.dmc_lua.lua_patch'



--====================================================================--
--== Setup, Constants


LuaPatch.addPatch( 'table-pop' )

local sfmt = string.format
local tpop = table.pop

local newClass = Objects.newClass
local ObjectBase = Objects.ObjectBase

local StyleMgrSingleton = nil

local LOCAL_DEBUG = true

--== To be set in initialize()
local Widget = nil
local BaseStyle = nil



--===================================================================--
--== Support Functions


local function initialize( manager )
	-- print( "initialize Style Manager" )
	Widget = manager

	if not StyleMgrSingleton then
		StyleMgrSingleton = manager:new()
	end

	return StyleMgrSingleton
end



--====================================================================--
--== Style Manager Class
--====================================================================--


local StyleMgr = newClass( ObjectBase, {name="Style Manager"}  )


--======================================================--
-- Start: Setup DMC Objects

function StyleMgr:__init__( params )
	-- print( "StyleMgr:__init__", params )
	params = params or {}
	self:superCall( '__init__', params )
	--==--

	--[[
	keyed on Style/Widget type, then name
	{
		Button={
			'home-page'
		}
		NavBar={
			'home-page'
		}
	}
	--]]
	self._style = {}

	-- keyed on theme name
	self._theme = {}

	--[[
		registered widgets and styles
		keyed on widget theme id

		textfield={
		<TextField Style Class>
		<TextField Class>
	--]]
	self._registered = {}

end
function StyleMgr:__undoInit__()
	-- print( "StyleMgr:__undoInit__" )
	--==--
	self:superCall( '__undoInit__' )
end

--[[
function StyleMgr:__initComplete__()
	-- print( "StyleMgr:__initComplete__" )
	self:superCall( '__initComplete__' )
	--==--
end
--]]
--[[
function StyleMgr:__undoInitComplete__()
	--print( "StyleMgr:__undoInitComplete__" )
	--==--
	self:superCall( '__undoInitComplete__' )
end
--]]

-- END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Static Methods


function StyleMgr.initialize( manager, params )
	-- print( "StyleMgr.initialize" )
	-- params = params or {}
	-- if params.mode==nil then params.mode=BaseStyle.RUN_MODE end
	--==--
	Widget = manager
	BaseStyle = Widget.Style.Base

end



--====================================================================--
--== Public Methods


--======================================================--
-- Style Methods

function StyleMgr:purgeStyles()
	-- print( "StyleMgr:purgeStyles" )
	self._style = {}
end


function StyleMgr:registerWidget( widget )
	-- print( "StyleMgr:registerWidget", widget, widget.STYLE_TYPE )
	assert( widget and type(widget.STYLE_TYPE)=='string' )
	--==--
	local wType = widget.STYLE_TYPE
	self._registered[ wType ] = widget
end


function StyleMgr:getStyle( style, name )
	-- print( "StyleMgr:getStyle", name )
	assert( type(style)=='string' or type(style)=='table', sfmt("StyleMgr:getStyle arg 'style' must be a string or table got '%s'", tostring(style) ) )
	assert( type(name)=='string', sfmt("StyleMgr:getStyle arg 'name' must be a string, got '%s'", tostring(name) ) )
	--==--
	local sType
	if type(style)=='string' then
		sType = style
	elseif type(style)=='table' then
		assert( type(style.TYPE)=='string', sfmt("StyleMgr:getStyle arg 'name' must be a string, got '%s'", tostring(name) ) )
		sType = style.TYPE
	end
	local styles = self._style[ sType ] or {}
	return styles[ name ]
end


function StyleMgr:addStyle( style )
	-- print( "StyleMgr:addStyle", style )
	assert( style, "StyleMgr:addStyle missing arg 'style'" )
	assert( style.isa and style:isa(BaseStyle), "StyleMgr:addStyle wrong type for 'style'" )
	--==--
	local name = style.name
	local sType = style.TYPE
	local styles

	if type(sType)~='string' then
		print( sfmt( "[NOTICE] StyleMgr:addStyle improper TYPE on Style, got '%s'", tostring( type(sType) ) ))
		return
	end
	if type(name)~='string' then
		print( sfmt( "[NOTICE] StyleMgr:addStyle expected string name, got '%s'", tostring( type(name) ) ))
		return
	end
	if #name==0 then
		print( sfmt( "[NOTICE] StyleMgr:addStyle name too short '%s'", tostring(name) ))
		return
	end

	styles = self._style[ sType ]
	if not styles then
		self._style[ sType ] = {}
		styles = self._style[ sType ]
	end

	if styles[ name ] then
		print( sfmt( "[NOTICE] StyleMgr:addStyle already have style with name '%s'", name ))
		return
	end

	styles[ name ] = style
end


function StyleMgr:removeStyle( style, name )
	-- print( "StyleMgr:removeStyle", style, name )
	assert( type(style)=='string' or type(style)=='table', sfmt("StyleMgr:getStyle arg 'name' must be a string, got '%s'", tostring(name) ) )
	assert( type(name)=='string', "StyleMgr:removeStyle arg 'name' must be string" )
	--==--
	local sType
	if type(style)=='string' then
		sType = style
	elseif type(style)=='table' then
		assert( type(style.TYPE)=='string', sfmt("StyleMgr:getStyle arg 'name' must be a string, got '%s'", tostring(name) ) )
		sType = style.TYPE
	end

	local styles = self._style[ sType ] or {}
	return tpop( styles, name )
end



--======================================================--
-- Theme Methods

function StyleMgr:addThemeStyle( theme_id, style, name )
	print( "StyleMgr:addThemeStyle", theme_id, style, name )
	assert( style, "StyleMgr:addThemeStyle missing arg 'style'" )
	assert( style.isa and style:isa(BaseStyle), "StyleMgr:addThemeStyle wrong type for 'style'" )
	--==--

end


--====================================================================--
--== Private Methods


-- none



--====================================================================--
--== Event Handlers


-- none



return initialize( StyleMgr )
