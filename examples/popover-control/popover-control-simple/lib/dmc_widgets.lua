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


local Kolor = require 'dmc_kolor'

-- Widgets
Widget.ButtonGroup = require( PATH .. '.' .. 'button_group' )
Widget.Formatter = require( PATH .. '.' .. 'data_formatters' )



--===================================================================--
--== Setup, Constants


-- group layer used by Popover, etc
local OVERLAY_GROUP = display.getCurrentStage()

-- default width/height for widgets
local WIDTH, HEIGHT = display.contentWidth, display.contentHeight

local sfmt = string.format



--===================================================================--
--== Support Functions


local function initKolors( func )
	local format = Kolor.getColorFormat()
	Kolor.setColorFormat( Kolor.dRGBA )
	func()
	Kolor.setColorFormat( format )
end


local function initialize( manager, params )
	-- print( "Widgets.initialize" )

	--== Load Components

	local BaseStyle = require( PATH .. '.' .. 'widget_style.base_style' )
	local StyleMixModule = require( PATH .. '.' .. 'widget_style_mix' )
	local FontMgr = require( PATH .. '.' .. 'font_manager' )
	local StyleMgr = require( PATH .. '.' .. 'style_manager' )

	Widget.Style.Base=BaseStyle
	Widget.FontMgr=FontMgr
	Widget.StyleMgr=StyleMgr
	Widget.StyleMix=StyleMixModule.StyleMix

	--== Initialize

	initKolors( function()
		BaseStyle.initialize( Widget, params )
		StyleMgr.initialize( Widget, params )
		-- FontMgr.initialize( Widget, params )
		StyleMixModule.initialize( Widget, params )
	end)

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



--===================================================================--
--== Style Methods


function Widget.getStyle( style, name )
	return Widget.StyleMgr:getStyle( style, name )
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
		print( sfmt( "[WARNING] Widgets.setOS() unknown OS '%s'", tostring(platform) ))
		print( sfmt( "Setting to default '%s'", tostring( os ) ) )
	end
	Widget.__os__ = os

	--== Set OS Version

	local versions = Widget._VALID_OS_VERSION[ os ]
	local value = versions[ version ]
	if not value then
		value = versions.default
		if LOCAL_DEBUG then
			print( sfmt( "[WARNING] Widgets.setOS() unknown OS Version '%s'", tostring( version )))
			print( sfmt( "Setting to default '%s'", tostring( value ) ) )
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
-- newBackground Support

function Widget._loadBackgroundSupport( params )
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

	initKolors( function()
		--== Reverse order
		BackgroundViewFactory.initialize( Widget, params )
		BackgroundStyleFactory.initialize( Widget, params )
		BackgroundStyle.initialize( Widget, params )
		Background.initialize( Widget, params )
	end)
end


function Widget.newBackground( options )
	if not Widget.Background then Widget._loadBackgroundSupport() end
	return Widget.Background:new( options )
end

function Widget.newRectangleBackground( options )
	if not Widget.Background then Widget._loadBackgroundSupport() end
	options = options or {}
	options.defaultViewType=Widget.Style.BackgroundFactory.Rectangle.TYPE
	return Widget.Background:new( options )
end

function Widget.newRoundedBackground( options )
	if not Widget.Background then Widget._loadBackgroundSupport() end
	options = options or {}
	options.defaultViewType=Widget.Style.BackgroundFactory.Rounded.TYPE
	return Widget.Background:new( options )
end


function Widget.newBackgroundStyle( style_info, params )
	-- print( "Widget.newBackgroundStyle" )
	style_info = style_info or {}
	params = params or {}
	--==--
	params.data = style_info
	if not Widget.Style.Background then Widget._loadBackgroundSupport() end
	return Widget.Style.Background:createStyleFrom( params )
end

function Widget.newRectangleBackgroundStyle( style_info, params )
	style_info = style_info or {}
	params = params or {}
	--==--
	if not Widget.Background then Widget._loadBackgroundSupport() end
	style_info.type = Widget.Style.BackgroundFactory.Rectangle.TYPE
	return Widget.newBackgroundStyle( style_info, params )
end

function Widget.newRoundedBackgroundStyle( style_info, params )
	style_info = style_info or {}
	params = params or {}
	--==--
	if not Widget.Background then Widget._loadBackgroundSupport() end
	style_info.type = Widget.Style.BackgroundFactory.Rounded.TYPE
	return Widget.newBackgroundStyle( style_info, params )
end


--======================================================--
-- newButton Support

function Widget._loadButtonSupport( params )
	-- print( "Widget._loadButtonSupport" )

	--== Dependencies

	Widget._loadBackgroundSupport( params )
	Widget._loadTextSupport( params )

	--== Button Components

	local Button = require( PATH .. '.' .. 'widget_button' )
	local ButtonStyle = require( PATH .. '.' .. 'widget_style.button_style' )
	local ButtonStateStyle = require( PATH .. '.' .. 'widget_style.button_state' )

	Widget.Button=Button
	Widget.Style.Button=ButtonStyle
	Widget.Style.ButtonState=ButtonStateStyle

	initKolors( function()
		--== Reverse order
		ButtonStateStyle.initialize( Widget, params )
		ButtonStyle.initialize( Widget, params )
		Button.initialize( Widget, params )
	end)
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


function Widget.newButtonStyle( style_info, params )
	-- print("Widget.newButtonStyle")
	style_info = style_info or {}
	params = params or {}
	--==--
	params.data = style_info
	if not Widget.Style.Button then Widget._loadButtonSupport() end
	return Widget.Style.Button:createStyleFrom( params )
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

function Widget._loadNavBarSupport( params )
	-- print( "Widget._loadNavBarSupport" )

	--== Dependencies

	Widget._loadBackgroundSupport( params )
	Widget._loadButtonSupport( params )

	--== Nav Bar Components

	local NavBar = require( PATH .. '.' .. 'widget_navbar' )
	local NavItem = require( PATH .. '.' .. 'widget_navitem' )
	local NavBarStyle = require( PATH .. '.' .. 'widget_style.navbar_style' )
	local NavItemStyle = require( PATH .. '.' .. 'widget_style.navitem_style' )

	Widget.NavBar=NavBar
	Widget.NavItem=NavItem
	Widget.Style.NavBar=NavBarStyle
	Widget.Style.NavItem=NavItemStyle

	--== Reverse order
	initKolors( function()
		NavItemStyle.initialize( Widget, params )
		NavBarStyle.initialize( Widget, params )
		NavItem.initialize( Widget, params )
		NavBar.initialize( Widget, params )
	end)
end

function Widget.newNavBar( options )
	if not Widget.NavBar then Widget._loadNavBarSupport() end
	return Widget.NavBar:new( options )
end

function Widget.newNavItem( options )
	if not Widget.NavItem then Widget._loadNavBarSupport() end
	return Widget.NavItem:new( options )
end


function Widget.newNavBarStyle( style_info, params )
	-- print( "Widget.newNavBarStyle" )
	style_info = style_info or {}
	params = params or {}
	--==--
	params.data = style_info
	if not Widget.Style.NavBar then Widget._loadNavBarSupport() end
	return Widget.Style.NavBar:createStyleFrom( params )
end

function Widget.newNavItemStyle( style_info, params )
	-- print( "Widget.newNavItemStyle" )
	style_info = style_info or {}
	params = params or {}
	--==--
	params.data = style_info
	if not Widget.Style.NavItem then Widget._loadNavBarSupport() end
	return Widget.Style.NavItem:createStyleFrom( params )
end


--======================================================--
-- newPopover Support

function Widget._loadPopoverSupport( params )
	-- print( "Widget._loadPopoverSupport" )

	--== Popover Components

	local PopoverPresenter = require( PATH .. '.' .. 'widget_popover.popover_presenter' )
	local Popover = require( PATH .. '.' .. 'widget_popover' )
	local PopoverControl = require( PATH .. '.' .. 'view_controller.popover_controller' )
	-- local PopoverStyle = require( PATH .. '.' .. 'widget_style.popover_style' )

	-- Widget.PopoverMixModule = require( PATH .. '.' .. 'widget_popover.popover_mix' )

	Widget.PopoverPresenter=PopoverPresenter
	Widget.Popover=Popover
	-- Widget.Style.Popover=PopoverStyle

	--== Reverse order
	initKolors( function()
		-- PopoverStyle.initialize( Widget, params )
		Popover.initialize( Widget, params )
		PopoverControl.initialize( Widget, params )
		PopoverPresenter.initialize( Widget, params )
	end)
end

function Widget.newPopover( options )
	if not Widget.Popover then Widget._loadPopoverSupport() end
	return Widget.Popover:new( options )
end

function Widget.newPopoverControl( options )
	if not Widget.PopoverControl then Widget._loadPopoverSupport() end
	return Widget.PopoverControl:new( options )
end


function Widget.newPopoverStyle( style_info, params )
	style_info = style_info or {}
	params = params or {}
	--==--
	params.data = style_info
	if not Widget.Style.Popover then Widget._loadPopoverSupport() end
	return Widget.Style.Popover:createStyleFrom( params )
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

function Widget._loadTextSupport( params )
	-- print( "Widget._loadTextSupport" )

	--== Text Components

	local Text = require( PATH .. '.' .. 'widget_text' )
	local TextStyle = require( PATH .. '.' .. 'widget_style.text_style' )

	Widget.Text=Text
	Widget.Style.Text=TextStyle

	--== Reverse order
	initKolors( function()
		TextStyle.initialize( Widget, params )
		Text.initialize( Widget, params )
	end)
end

function Widget.newText( options )
	-- print( "Widget.newText" )
	if not Widget.Text then Widget._loadTextSupport() end
	return Widget.Text:new( options )
end

function Widget.newTextStyle( style_info, params )
	-- print( "Widget.newTextStyle" )
	style_info = style_info or {}
	params = params or {}
	--==--
	params.data = style_info
	if not Widget.Style.Text then Widget._loadTextSupport() end
	return Widget.Style.Text:createStyleFrom( params )
end


--======================================================--
-- TextField Support

function Widget._loadTextFieldSupport( params )
	-- print( "Widget._loadTextFieldSupport" )

	--== Dependencies

	Widget._loadBackgroundSupport( params )
	Widget._loadTextSupport( params )

	--== TextField Components

	local TextField = require( PATH .. '.' .. 'widget_textfield' )
	local TextFieldStyle = require( PATH .. '.' .. 'widget_style.textfield_style' )

	Widget.TextField=TextField
	Widget.Style.TextField=TextFieldStyle

	--== Reverse order
	initKolors( function()
		TextFieldStyle.initialize( Widget, params )
		TextField.initialize( Widget, params )
	end)
end

function Widget.newTextField( options )
	-- print( "Widget.newTextField" )
	if not Widget.TextField then Widget._loadTextFieldSupport() end
	return Widget.TextField:new( options )
end

function Widget.newTextFieldStyle( style_info, params )
	-- print( "Widget.newTextFieldStyle" )
	style_info = style_info or {}
	params = params or {}
	--==--
	params.data = style_info
	if not Widget.Style.TextField then Widget._loadTextFieldSupport() end
	return Widget.Style.TextField:createStyleFrom( params )
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
