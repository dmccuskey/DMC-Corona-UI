--====================================================================--
-- dmc_widgets.lua
--
-- entry point into dmc-corona-widgets
--
-- Documentation: http://docs.davidmccuskey.com/
--====================================================================--

--[[

The MIT License (MIT)

Copyright (c) 2013-2015 David McCuskey

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
--== DMC Widgets
--====================================================================--


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "1.1.0"



--====================================================================--
--== DMC Widgets Config
--====================================================================--


local Widget = {}

local args = { ... }
local PATH = args[1]

local dmc_widget_data, dmc_widget_func

if _G.__dmc_widget == nil then

	_G.__dmc_widget = {}
	dmc_widget_data = _G.__dmc_widget

	dmc_widget_data.func = {}
	dmc_widget_func = dmc_widget_data.func
	dmc_widget_func.find = function( name )
		local loc = ''
		if PATH then loc = PATH end
		if loc ~= '' and string.sub( loc, -1 ) ~= '.' then
			loc = loc .. '.'
		end
		return loc .. name
	end

end



--====================================================================--
--== DMC Corona Library Config
--====================================================================--


local dmc_lib_data, dmc_lib_info

-- boot dmc_corona with boot script or
-- setup basic defaults if it doesn't exist
--
if false == pcall( function() require 'dmc_corona_boot' end ) then
	_G.__dmc_corona = {
		dmc_corona={},
	}
end

dmc_lib_data = _G.__dmc_corona
dmc_lib_info = dmc_lib_data.dmc_corona



--===================================================================--
--== Imports

-- Managers
Widget.FontMgr = require( PATH .. '.' .. 'font_manager' )
Widget.ThemeMgr = require( PATH .. '.' .. 'theme_manager' )

-- Styles
local BaseStyle = require( PATH .. '.' .. 'theme_manager.base_style' )


-- Widgets
Widget.Button = require( PATH .. '.' .. 'widget_button' )
Widget.ButtonGroup = require( PATH .. '.' .. 'button_group' )
Widget.Formatter = require( PATH .. '.' .. 'data_formatters' )
Widget.NavBar = require( PATH .. '.' .. 'widget_navbar' )
Widget.NavItem = require( PATH .. '.' .. 'widget_navitem' )
Widget.Popover = require( PATH .. '.' .. 'widget_popover' )
Widget.PopoverMixModule = require( PATH .. '.' .. 'widget_popover.popover_mix' )



--===================================================================--
--== Setup, Constants


Widget.WIDTH = display.contentWidth
Widget.HEIGHT = display.contentHeight

Widget.Style = {
	Base=BaseStyle.Base
}

--== Give widgets access to Widget (do this last)

Widget.NavBar.__setWidgetManager( Widget )
Widget.NavItem.__setWidgetManager( Widget )
Widget.Popover.__setWidgetManager( Widget )
Widget.PopoverMixModule.__setWidgetManager( Widget )



--===================================================================--
--== newText widget


local function loadBackgroundSupport()
	-- print("loadBackgroundSupport")

	local Background = require( PATH .. '.' .. 'widget_background' )
	local BackgroundStyle = require( PATH .. '.' .. 'theme_manager.background_style' )

	Widget.Background=Background
	Widget.Style.Background=BackgroundStyle

	Background.__setWidgetManager( Widget )
end


function Widget.newBackground( options )
	if not Widget.Background then loadBackgroundSupport() end
	return Widget.Background:new( options )
end

function Widget.newBackgroundStyle( style )
	-- print("Widget.newBackgroundStyle")
	if not Widget.Style.Background then loadBackgroundSupport() end
	return Widget.Style.Background:new( style )
end



--===================================================================--
--== newButton widget


function Widget.newButton( options )
	local theme = nil
	local widget = Widget.Button
	return widget.create( options, theme )
end



--===================================================================--
--== newButtonGroup widget


function Widget.newButtonGroup( options )
	return Widget.ButtonGroup.create( options )
end



--===================================================================--
--== newFormatter widget


function Widget.newFormatter( options )
	if type(options)=='string' then
		options = { type=options }
	end
	return Widget.Formatter.create( options )
end



--===================================================================--
--== newNavBar widget


function Widget.newNavBar( options )
	return Widget.NavBar:new( options )
end



--===================================================================--
--== newNavItem widget


function Widget.newNavItem( options )
	return Widget.NavItem:new( options )
end



--===================================================================--
--== newPopover widget


function Widget.newPopover( options )
	local theme = nil
	local widget = Widget.Popover
	return widget:new( options, theme )
end



--===================================================================--
--== newPushButton widget


function Widget.newPushButton( options )
	options = options or {}
	--==--
	local theme = nil
	options.type = Widget.Button.PushButton.TYPE
	return Widget.Button.create( options, theme )
end



--===================================================================--
--== newScroller widget


-- function Widget.newScroller( options )
-- 	local theme = nil
-- 	local _library = require( PATH .. '.' .. 'widget_scroller' )
-- 	return _library:new( options, theme )
-- end



--===================================================================--
--== newSlideView widget


function Widget.newSlideView( options )
	local theme = nil
	local _library = require( PATH .. '.' .. 'widget_slideview' )
	return _library:new( options, theme )
end



--===================================================================--
--== newTableView widget


function Widget.newTableView( options )
	local theme = nil
	local _library = require( PATH .. '.' .. 'widget_tableview' )
	return _library:new( options, theme )
end



--===================================================================--
--== newText widget


local function loadTextSupport()
	-- print("loadTextSupport")
	local Text = require( PATH .. '.' .. 'widget_text' )
	local TextStyle = require( PATH .. '.' .. 'theme_manager.text_style' )

	Widget.Text=Text
	Widget.Style.Text=TextStyle

	Text.__setWidgetManager( Widget )
end


function Widget.newText( options )
	-- print("Widget.newText")
	if not Widget.Text then loadTextSupport() end
	return Widget.Text:new( options )
end

function Widget.newTextStyle( style )
	-- print("Widget.newTextStyle")
	if not Widget.Style.Text then loadTextSupport() end
	return Widget.Style.Text:new( style )
end



--===================================================================--
--== TextField support


local function loadTextFieldSupport()
	-- print("loadTextFieldSupport")
	TextField = require( PATH .. '.' .. 'widget_textfield' )
	TextFieldStyle = require( PATH .. '.' .. 'theme_manager.textfield_style' )

	Widget.TextField=TextField
	Widget.Style.TextField=TextFieldStyle

	TextField.__setWidgetManager( Widget )
end


function Widget.newTextField( options )
	-- print("Widget.newTextField")
	if not Widget.TextField then loadTextFieldSupport() end
	return Widget.TextField:new( options )
end

function Widget.newTextFieldStyle( style )
	-- print("Widget.newTextFieldStyle")
	if not Widget.Style.TextField then loadTextFieldSupport() end
	return Widget.Style.TextField:new( style )
end


--===================================================================--
--== newTextFieldStyle





--===================================================================--
--== newToggleButton widget


function Widget.newToggleButton( options )
	options = options or {}
	--==--
	local theme = nil
	options.type = Widget.Button.ToggleButton.TYPE
	return Widget.Button.create( options, theme )
end



--===================================================================--
--== newViewPager widget


-- function Widget.newViewPager( options )
-- 	local theme = nil
-- 	local _library = require( PATH .. '.' .. 'widget_viewpager' )
-- 	return _library:new( options, theme )
-- end




return Widget
