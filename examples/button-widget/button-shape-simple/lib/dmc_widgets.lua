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


-- Widgets
Widget.ButtonGroup = require( PATH .. '.' .. 'button_group' )
Widget.Formatter = require( PATH .. '.' .. 'data_formatters' )
Widget.Popover = require( PATH .. '.' .. 'widget_popover' )
Widget.PopoverMixModule = require( PATH .. '.' .. 'widget_popover.popover_mix' )



--===================================================================--
--== Setup, Constants


local WIDTH, HEIGHT = display.contentWidth, display.contentHeight

local sformat = string.format



--===================================================================--
--== Support Functions


local function initialize( manager )
	-- print( "Widgets.initialize" )

	--== Load Managers

	local FontMgr = require( PATH .. '.' .. 'font_manager' )
	local ThemeMgr = require( PATH .. '.' .. 'theme_manager' )

	Widget.FontMgr = FontMgr
	Widget.StyleMgr = StyleMgr
	Widget.ThemeMgr = ThemeMgr

	--== Load Base Style

	local BaseStyle = require( PATH .. '.' .. 'widget_style.base_style' )
	Widget.Style.Base=BaseStyle

	--== Set UI/UX

	local platformName = system.getInfo( 'platformName' )
	if platformName=='Android' then
		manager.setOS( manager.ANDROID )
	elseif platformName=='WinPhone' then
		manager.setOS( manager.WINDOWS )
	elseif platformName=='iPhone' then
		manager.setOS( manager.IOS )
	else
		manager.setOS( manager.IOS )
	end

end


--====================================================================--
--== Widget Manager
--====================================================================--


-- local Widget = {}

--== Class Constants

Widget.WIDTH = WIDTH
Widget.HEIGHT = HEIGHT

Widget.__os__ = nil -- 'iOS', 'android'
Widget.__osVersion__ = nil -- 'iOS'-'8.0', 'android'-'2.1'

Widget.IOS = 'iOS'
Widget.ANDROID = 'Android'
Widget.WINDOWS = 'WinPhone'

Widget.IOS = 'iOS'

Widget._VALID_OS = {
	[Widget.IOS]=Widget.IOS,
	[Widget.ANDROID]=Widget.ANDROID,
	default=Widget.IOS,
	-- [Widget.WINDOWS]=Widget.WINDOWS
}

Widget.IOS_7x = "7.0.0"
Widget.IOS_8x = "8.0.0"

Widget.ANDROID_20 = "2.0.0"
Widget.ANDROID_21 = "2.1.0"

Widget._VALID_OS_VERSION = {

	[Widget.IOS]={
		default=Widget.IOS_8x,
		[Widget.IOS_8x]=Widget.IOS_8x
	},

	[Widget.ANDROID]={
		default=Widget.ANDROID_21,
		[Widget.ANDROID_20]=Widget.ANDROID_20,
		[Widget.ANDROID_21]=Widget.ANDROID_21
	},
	-- [Widget.WINDOWS]=true
}


--== Access to all style classes (once loaded)

Widget.Style = {}

--== Give widgets access to Widget (do this last)

Widget.Popover.__setWidgetManager( Widget )
Widget.PopoverMixModule.__setWidgetManager( Widget )



--===================================================================--
--== Theme Methods


function Widget.activateTheme( name )
end

function Widget.getTheme( name )
end

function Widget.addTheme( theme )
end

function Widget.deleteTheme( name )
end

function Widget.loadTheme( file )
end

function Widget.unloadTheme( name )
end

function Widget.reloadTheme( name )
end



--===================================================================--
--== Style Methods


function Widget.addStyle( style, theme )
	local s = Widget.StyleMgr:addStyle( style )
	if s.name and theme then
		Widget.ThemeMgr:addStyle( s, theme )
	end
end

function Widget.deleteStyle( name )
end

function Widget.loadStyles( file )
end



--===================================================================--
--== Misc Methods


function Widget.setOS( platform, version )
	-- print( "Widget.setOS", platform, version )

	--== Set OS

	local os = Widget._VALID_OS[ platform ]
	if not os then
		os = Widget._VALID_OS.default
		print( sformat( "[WARNING] Widgets.setOS() unknown OS '%s'", tostring(platform) ))
		print( sformat( "Setting to default '%s'", tostring( os ) ) )
	end
	Widget.__os__ = os

	--== Set OS Version

	local versions = Widget._VALID_OS_VERSION[ os ]
	local value = versions[ version ]
	if not value then
		value = versions.default
		if LOCAL_DEBUG then
			print( sformat( "[WARNING] Widgets.setOS() unknown OS Version '%s'", tostring( version )))
			print( sformat( "Setting to default '%s'", tostring( value ) ) )
		end
	end
	Widget.__osVersion__ = value

	if LOCAL_DEBUG then
		print( "Widget theme set for ", os, value )
	end

end



--===================================================================--
--== Widget Methods


--======================================================--
-- newText Support

function Widget._loadBackgroundSupport()
	-- print( "Widget._loadBackgroundSupport" )

	--== Background Components

	local Background = require( PATH .. '.' .. 'widget_background' )
	local BackgroundStyle = require( PATH .. '.' .. 'widget_style.background_style' )
	local RectangleStyle = require( PATH .. '.' .. 'widget_background.rectangle_style' )
	local RoundedStyle = require( PATH .. '.' .. 'widget_background.rounded_style' )
	local BackgroundStyleFactory = require( PATH .. '.' .. 'widget_background.style_factory' )
	local BackgroundViewFactory = require( PATH .. '.' .. 'widget_background.view_factory' )

	Widget.Background=Background
	Widget.BackgroundFactory=BackgroundViewFactory
	Widget.Style.Background=BackgroundStyle
	Widget.Style.BackgroundFactory=BackgroundStyleFactory

	--== Reverse order
	BackgroundViewFactory.initialize( Widget )
	BackgroundStyleFactory.initialize( Widget )
	BackgroundStyle.initialize( Widget )
	Background.initialize( Widget )
end

function Widget.newBackground( options )
	if not Widget.Background then Widget._loadBackgroundSupport() end
	return Widget.Background:new( options )
end

function Widget.newBackgroundStyle( style_info )
	-- print("Widget.newBackgroundStyle")
	-- assert( type(style_info)=='table' and style_info.type, "newBackgroundStyle: missing style property 'type'" )
	if not Widget.Style.Background then Widget._loadBackgroundSupport() end
	return Widget.Style.Background:createStyleFrom{ data=style_info }
end


--======================================================--
-- newButton Support

function Widget._loadButtonSupport()
	-- print( "Widget._loadButtonSupport" )

	--== Dependencies

	Widget._loadBackgroundSupport()
	Widget._loadTextSupport()

	--== Button Components

	local Button = require( PATH .. '.' .. 'widget_button' )
	local ButtonStyle = require( PATH .. '.' .. 'widget_style.button_style' )
	local ButtonStateStyle = require( PATH .. '.' .. 'widget_button.button_state_style' )

	Widget.Button=Button
	Widget.Style.Button=ButtonStyle
	Widget.Style.ButtonState=ButtonStateStyle

	--== Reverse order
	ButtonStateStyle.initialize( Widget )
	ButtonStyle.initialize( Widget )
	Button.initialize( Widget )
end

function Widget.newButton( options )
	if not Widget.Button then Widget._loadButtonSupport() end
	return Widget.Button.create( options )
end

function Widget.newPushButton( options )
	if not Widget.Button then Widget._loadButtonSupport() end
	options = options or {}
	options.action = Widget.Button.PushButton.TYPE
	--==--
	return Widget.Button.create( options )
end

function Widget.newRadioButton( options )
	if not Widget.Button then Widget._loadButtonSupport() end
	options = options or {}
	options.action = Widget.Button.RadioButton.TYPE
	--==--
	return Widget.Button.create( options )
end

function Widget.newToggleButton( options )
	if not Widget.Button then Widget._loadButtonSupport() end
	options = options or {}
	options.action = Widget.Button.ToggleButton.TYPE
	--==--
	return Widget.Button.create( options )
end


--======================================================--
-- newButtonGroup Support

function Widget.newButtonGroup( options )
	return Widget.ButtonGroup.create( options )
end


--======================================================--
-- newFormatter Support

function Widget.newFormatter( options )
	if type(options)=='string' then
		-- wrap option in a params table
		options = { type=options }
	end
	return Widget.Formatter.create( options )
end


--======================================================--
-- newNavBar Support

function Widget._loadNavBarSupport()
	-- print( "Widget._loadNavBarSupport" )

	--== Dependencies

	Widget._loadButtonSupport()

	--== Nav Bar Components

	local NavBar = require( PATH .. '.' .. 'widget_navbar' )
	local NavItem = require( PATH .. '.' .. 'widget_navitem' )

	Widget.NavBar=NavBar
	Widget.NavItem=NavItem

	--== Reverse order
	NavItem.initialize( Widget )
	NavBar.initialize( Widget )
end

function Widget.newNavBar( options )
	if not Widget.Background then Widget._loadNavBarSupport() end
	return Widget.NavBar:new( options )
end

function Widget.newNavItem( options )
	if not Widget.Background then Widget._loadNavBarSupport() end
	return Widget.NavItem:new( options )
end


--======================================================--
-- newPopover Support

function Widget.newPopover( options )
	local theme = nil
	local widget = Widget.Popover
	return widget:new( options, theme )
end


--======================================================--
-- newScroller Support

-- function Widget.newScroller( options )
-- 	local theme = nil
-- 	local _library = require( PATH .. '.' .. 'widget_scroller' )
-- 	return _library:new( options, theme )
-- end


--======================================================--
-- newSlideView Support

function Widget.newSlideView( options )
	local theme = nil
	local _library = require( PATH .. '.' .. 'widget_slideview' )
	return _library:new( options, theme )
end


--======================================================--
-- newTableView Support

function Widget.newTableView( options )
	local theme = nil
	local _library = require( PATH .. '.' .. 'widget_tableview' )
	return _library:new( options, theme )
end


--======================================================--
-- newText Support

function Widget._loadTextSupport()
	-- print( "Widget._loadTextSupport" )

	--== Text Components

	local Text = require( PATH .. '.' .. 'widget_text' )
	local TextStyle = require( PATH .. '.' .. 'widget_style.text_style' )

	Widget.Text=Text
	Widget.Style.Text=TextStyle

	--== Reverse order
	TextStyle.initialize( Widget )
	Text.initialize( Widget )
end

function Widget.newText( options )
	-- print( "Widget.newText" )
	if not Widget.Text then Widget._loadTextSupport() end
	return Widget.Text:new( options )
end

function Widget.newTextStyle( style_info )
	-- print( "Widget.newTextStyle" )
	if not Widget.Style.Text then Widget._loadTextSupport() end
	return Widget.Style.Text:createStyleFrom{ data=style_info }
end


--======================================================--
-- TextField Support

function Widget._loadTextFieldSupport()
	-- print( "Widget._loadTextFieldSupport" )

	--== Dependencies

	Widget._loadBackgroundSupport()
	Widget._loadTextSupport()

	--== TextField Components

	local TextField = require( PATH .. '.' .. 'widget_textfield' )
	local TextFieldStyle = require( PATH .. '.' .. 'widget_style.textfield_style' )

	Widget.TextField=TextField
	Widget.Style.TextField=TextFieldStyle

	--== Reverse order
	TextFieldStyle.initialize( Widget )
	TextField.initialize( Widget )
end

function Widget.newTextField( options )
	-- print( "Widget.newTextField" )
	if not Widget.TextField then Widget._loadTextFieldSupport() end
	return Widget.TextField:new( options )
end

function Widget.newTextFieldStyle( style_info )
	-- print( "Widget.newTextFieldStyle" )
	if not Widget.Style.TextField then Widget._loadTextFieldSupport() end
	return Widget.Style.TextField:createStyleFrom{ data=style_info }
end


--======================================================--
-- newViewPager Support

-- function Widget.newViewPager( options )
-- 	local theme = nil
-- 	local _library = require( PATH .. '.' .. 'widget_viewpager' )
-- 	return _library:new( options, theme )
-- end



--====================================================================--
--== Init Widgets
--====================================================================--


initialize( Widget )


return Widget
