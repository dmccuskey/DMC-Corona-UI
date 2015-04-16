--====================================================================--
-- dmc_ui/dmc_style/style_manager.lua
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
--== DMC Corona UI : Style Manager
--====================================================================--


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.1.0"



--====================================================================--
--== DMC UI Setup
--====================================================================--


local dmc_ui_data = _G.__dmc_ui
local dmc_ui_func = dmc_ui_data.func
local ui_find = dmc_ui_func.find



--====================================================================--
--== DMC UI : Style Manager
--====================================================================--



--====================================================================--
--== Imports


local LuaPatch = require 'lib.dmc_lua.lua_patch'



--====================================================================--
--== Setup, Constants


LuaPatch.addPatch( 'table-pop' )

local sfmt = string.format
local tpop = table.pop

--== To be set in initialize()
local Style = nil



--===================================================================--
--== Support Functions




--====================================================================--
--== Style Manager Class
--====================================================================--


local StyleMgr = {}


--[[
keyed on Style/dUI type, then name
{
	Button={
		'home-page'
	}
	NavBar={
		'home-page'
	}
}
--]]
StyleMgr._style = {}

-- keyed on theme name
StyleMgr._theme = {}

--[[
	registered widgets and styles
	keyed on widget theme id

	textfield={
	<TextField Style Class>
	<TextField Class>
--]]
StyleMgr._registered = {}



--====================================================================--
--== Static Functions


function StyleMgr.initialize( manager, params )
	-- params = params or {}
	-- if params.mode==nil then params.mode=uiConst.RUN_MODE end
	--==--
	Style = manager

	--== Add API calls

	Style.addStyle = StyleMgr.addStyle
	Style.addThemeStyle = StyleMgr.addThemeStyle
	Style.createTheme = StyleMgr.createTheme
	Style.getStyle = StyleMgr.getStyle
	Style.purgeStyles = StyleMgr.purgeStyles
	Style.registerWidget = StyleMgr.registerWidget
	Style.removeStyle = StyleMgr.removeStyle

end



--====================================================================--
--== Public Functions


--======================================================--
-- Style Functions

function StyleMgr.purgeStyles()
	-- print( "StyleMgr.purgeStyles" )
	StyleMgr._style = {}
end


function StyleMgr.addStyle( style )
	-- print( "StyleMgr.addStyle", style )
	assert( style, "StyleMgr.addStyle missing arg 'style'" )
	assert( style.isa and style:isa(Style.Base), "StyleMgr.addStyle wrong type for 'style'" )
	--==--
	local name = style.name
	local sType = style.TYPE
	local styles

	if type(sType)~='string' then
		print( sfmt( "[NOTICE] StyleMgr.addStyle improper TYPE on Style, got '%s'", tostring( type(sType) ) ))
		return
	end
	if type(name)~='string' then
		print( sfmt( "[NOTICE] StyleMgr.addStyle expected string name, got '%s'", tostring( type(name) ) ))
		return
	end
	if #name==0 then
		print( sfmt( "[NOTICE] StyleMgr.addStyle name too short '%s'", tostring(name) ))
		return
	end

	styles = StyleMgr._style[ sType ]
	if not styles then
		StyleMgr._style[ sType ] = {}
		styles = StyleMgr._style[ sType ]
	end

	if styles[ name ] then
		print( sfmt( "[NOTICE] StyleMgr.addStyle already have style with name '%s'", name ))
		return
	end

	styles[ name ] = style
end


function StyleMgr.getStyle( style, name )
	-- print( "StyleMgr.getStyle", name )
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
	local styles = StyleMgr._style[ sType ] or {}
	return styles[ name ]
end


function StyleMgr.removeStyle( style, name )
	-- print( "StyleMgr.removeStyle", style, name )
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

	local styles = StyleMgr._style[ sType ] or {}
	return tpop( styles, name )
end



--======================================================--
-- Theme Methods

function StyleMgr.addThemeStyle( theme_id, style, name )
	-- print( "StyleMgr.addThemeStyle", theme_id, style, name )
	assert( style, "StyleMgr:addThemeStyle missing arg 'style'" )
	assert( style.isa and style:isa(Style.Base), "StyleMgr:addThemeStyle wrong type for 'style'" )
	--==--

end



function StyleMgr.createTheme( theme_id, style, name )

end


--======================================================--
-- Misc Functions

function StyleMgr.registerWidget( widget )
	-- print( "StyleMgr.registerWidget", widget, widget.STYLE_TYPE )
	assert( widget and type(widget.STYLE_TYPE)=='string' )
	--==--
	local wType = widget.STYLE_TYPE
	StyleMgr._registered[ wType ] = widget
end



--[[

--===================================================================--
--== Theme Methods


function Widget.activateTheme( theme_id )
end

function Widget.availableThemes()
end

function Widget.availableThemeNames()
end

function Widget.availableThemeIds()
end

-- struct or name/dir
function Widget.createTheme( theme, dir )
end

function Widget.getTheme( theme_id )
end

function Widget.getActiveTheme()
end

function Widget.deleteTheme( theme_id )
end

function Widget.addThemeStyle( theme_id, style, name )
	return Widget.StyleMgr:addThemeStyle( theme_id, style, name )
end

function Widget.getThemeStyle( theme_id, style, name )
end

function Widget.removeThemeStyle( theme_id, style, name )
end

function Widget.loadTheme( file )
end

function Widget.unloadTheme( theme_id )
end

function Widget.reloadTheme( theme_id )
end

--]]
--====================================================================--
--== Private Functions


-- none



--====================================================================--
--== Event Handlers


-- none



return StyleMgr
