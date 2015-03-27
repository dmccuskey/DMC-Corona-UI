--====================================================================--
-- dmc_widget.lua
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
--== DMC Corona UI : Widget Interface
--====================================================================--


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "2.0.0"



--====================================================================--
--== DMC UI Setup
--====================================================================--


local dmc_ui_data = _G.__dmc_ui
local dmc_ui_func = dmc_ui_data.func
local ui_find = dmc_ui_func.find



--====================================================================--
--== DMC UI : Widget Interface
--====================================================================--



--===================================================================--
--== Imports


local Kolor = require 'dmc_kolor'
local uiConst = require( ui_find( 'ui_constants' ) )

-- Widget.ButtonGroup = require( PATH .. '.' .. 'button_group' )
-- Widget.Formatter = require( PATH .. '.' .. 'data_formatters' )



--===================================================================--
--== Setup, Constants


-- local WIDTH, HEIGHT = display.contentWidth, display.contentHeight

-- local sfmt = string.format

--== To be set in initialize()
local dUI = nil
local Style = nil



--===================================================================--
--== Support Functions


local initKolors = Kolor.initializeKolorSet



--====================================================================--
--== Widget Interface
--====================================================================--


local Widget = {}



--====================================================================--
--== Widget Static Functions



function Widget.initialize( manager, params )
	-- print( "Widget.initialize" )

	dUI = manager
	Style = dUI.Style

	--== Add API calls

	dUI.newBackground = Widget.newBackground
	dUI.newRectangleBackground = Widget.newRoundedBackground
	dUI.newRoundedBackground = Widget.newRectangleBackground
	dUI.newButton = Widget.newButton
	dUI.newPushButton = Widget.newPushButton
	dUI.newRadioButton = Widget.newRadioButton
	dUI.newToggleButton = Widget.newToggleButton
	dUI.newButtonGroup = Widget.newButtonGroup
	dUI.newFormatter = Widget.newFormatter
	dUI.newNavBar = Widget.newNavBar
	dUI.newNavItem = Widget.newNavItem
	dUI.newPopover = Widget.newPopover
	dUI.newScrollView = Widget.newScrollView
	dUI.newSlideView = Widget.newSlideView
	dUI.newTableView = Widget.newTableView
	dUI.newText = Widget.newText
	dUI.newTextField = Widget.newTextField



	--== Load Components

	-- local FontMgr = require( PATH .. '.' .. 'font_manager' )
	-- Widget.FontMgr=FontMgr

	--== Initialize

	initKolors( function()
		-- FontMgr.initialize( Widget, params )
	end)


end


--====================================================================--
--== Widget Public Functions


--======================================================--
-- UI View Base Support

function Widget.loadViewSupport( params )
	-- print( "Widget.loadViewSupport" )
	if Widget.View then return end
	params = params or {}
	if params.mode==nil then params.mode=uiConst.RUN_MODE end
	--==--

	--== Components

	local View = require( ui_find( 'core.view' ) )

	Widget.View=View

	View.initialize( dUI, params )
end



--===================================================================--
--== Widget Methods


--======================================================--
-- newBackground Support

function Widget._loadBackgroundSupport( params )
	-- print( "Widget._loadBackgroundSupport" )
	if Widget.Background then return end
	params = params or {}
	if params.mode==nil then params.mode=uiConst.RUN_MODE end
	--==--

	--== Dependencies

	Style._loadBackgroundStyleSupport( params )

	--== Components

	local Background = require( ui_find( 'dmc_widget.widget_background' ) )
	local BackgroundViewFactory = require( ui_find( 'dmc_widget.widget_background.view_factory' ) )

	Widget.Background=Background
	Widget.BackgroundFactory=BackgroundViewFactory

	initKolors( function()
		BackgroundViewFactory.initialize( dUI, params )
		Background.initialize( dUI, params )
	end)
end

function Widget.newBackground( options )
	if not Widget.Background then Widget._loadBackgroundSupport() end
	return Widget.Background:new( options )
end

function Widget.newRectangleBackground( options )
	if not Widget.Background then Widget._loadBackgroundSupport() end
	options = options or {}
	options.defaultViewType=uiConst.RECTANGLE
	return Widget.Background:new( options )
end

function Widget.newRoundedBackground( options )
	if not Widget.Background then Widget._loadBackgroundSupport() end
	options = options or {}
	options.defaultViewType=uiConst.ROUNDED
	return Widget.Background:new( options )
end


--======================================================--
-- newButton Support

function Widget._loadButtonSupport( params )
	-- print( "Widget._loadButtonSupport" )
	if Widget.ButtonFactory then return end
	params = params or {}
	if params.mode==nil then params.mode=uiConst.RUN_MODE end
	--==--

	--== Dependencies

	Style._loadButtonStyleSupport( params )

	Widget._loadBackgroundSupport( params )
	Widget._loadTextSupport( params )

	--== Components

	local ButtonFactory = require( ui_find( 'dmc_widget.widget_button' ) )

	Widget.ButtonFactory=ButtonFactory

	initKolors( function()
		ButtonFactory.initialize( dUI, params )
	end)
end

function Widget.newButton( options )
	if not Widget.ButtonFactory then Widget._loadButtonSupport() end
	return Widget.ButtonFactory.create( options )
end

function Widget.newPushButton( options )
	if not Widget.ButtonFactory then Widget._loadButtonSupport() end
	options = options or {}
	options.action = Widget.ButtonFactory.PushButton.TYPE
	--==--
	return Widget.ButtonFactory.create( options )
end

function Widget.newRadioButton( options )
	if not Widget.ButtonFactory then Widget._loadButtonSupport() end
	options = options or {}
	options.action = Widget.Button.RadioButton.TYPE
	--==--
	return Widget.ButtonFactory.create( options )
end

function Widget.newToggleButton( options )
	if not Widget.ButtonFactory then Widget._loadButtonSupport() end
	options = options or {}
	options.action = Widget.ButtonFactory.ToggleButton.TYPE
	--==--
	return Widget.ButtonFactory.create( options )
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
	if Widget.NavBar then return end
	params = params or {}
	if params.mode==nil then params.mode=uiConst.RUN_MODE end
	--==--

	--== Dependencies

	Style._loadNavBarStyleSupport( params )

	Widget._loadBackgroundSupport( params )
	Widget._loadButtonSupport( params )

	--== Components

	local NavBar = require( ui_find( 'dmc_widget.widget_navbar' ) )
	local NavItem = require( ui_find( 'dmc_widget.widget_navitem' ) )

	Widget.NavBar=NavBar
	Widget.NavItem=NavItem

	initKolors( function()
		NavItem.initialize( dUI, params )
		NavBar.initialize( dUI, params )
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
-- newScrollView Support

function Widget.loadScrollViewSupport( params )
	-- print( "Widget.loadScrollViewSupport" )
	if Widget.ScrollView then return end
	params = params or {}
	if params.mode==nil then params.mode=uiConst.RUN_MODE end
	--==--

	--== Dependencies

	Style.loadScrollViewStyleSupport( params )

	Widget.loadViewSupport( params )

	--== Components

	local ScrollView = require( ui_find( 'dmc_widget.widget_scrollview' ) )

	Widget.ScrollView=ScrollView

	initKolors( function()
		ScrollView.initialize( dUI, params )
	end)
end

function Widget.newScrollView( options )
	-- print( "Widget.newText" )
	if not Widget.ScrollView then Widget.loadScrollViewSupport() end
	return Widget.ScrollView:new( options )
end


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
	if Widget.Text then return end
	params = params or {}
	if params.mode==nil then params.mode=uiConst.RUN_MODE end
	--==--

	--== Dependencies

	Style._loadTextStyleSupport( params )

	--== Components

	local Text = require( ui_find( 'dmc_widget.widget_text' ) )

	Widget.Text=Text

	initKolors( function()
		Text.initialize( dUI, params )
	end)
end

function Widget.newText( options )
	-- print( "Widget.newText" )
	if not Widget.Text then Widget._loadTextSupport() end
	return Widget.Text:new( options )
end


--======================================================--
-- TextField Support

function Widget._loadTextFieldSupport( params )
	-- print( "Widget._loadTextFieldSupport" )
	if Widget.TextField then return end
	params = params or {}
	if params.mode==nil then params.mode=uiConst.RUN_MODE end
	--==--

	--== Dependencies

	Style._loadTextFieldStyleSupport( params )

	Widget._loadBackgroundSupport( params )
	Widget._loadTextSupport( params )

	--== TextField Components

	local TextField = require( ui_find( 'dmc_widget.widget_textfield' ) )

	Widget.TextField=TextField

	initKolors( function()
		TextField.initialize( dUI, params )
	end)
end

function Widget.newTextField( options )
	-- print( "Widget.newTextField" )
	if not Widget.TextField then Widget._loadTextFieldSupport() end
	return Widget.TextField:new( options )
end


--======================================================--
-- newViewPager Support

-- function Widget.newViewPager( options )
-- 	local theme = nil
-- 	local _library = require( PATH .. '.' .. 'widget_viewpager' )
-- 	return _library:new( options, theme )
-- end



--====================================================================--
--== Private Functions


-- none



--====================================================================--
--== Event Handlers


-- none



return Widget
