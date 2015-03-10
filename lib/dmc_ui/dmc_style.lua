--====================================================================--
-- dmc_ui/dmc_style.lua
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
--== DMC Corona UI : Style Interface
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
--== DMC UI : Style Interface
--====================================================================--



--====================================================================--
--== Imports


local Kolor = require 'dmc_kolor'
local uiConst = require( ui_find( 'ui_constants' ) )



--====================================================================--
--== Setup, Constants


--== To be set in initialize()
local dUI = nil



--===================================================================--
--== Support Functions


local initKolors = Kolor.initializeKolorSet



--====================================================================--
--== Style Interface
--====================================================================--


local Style = {}



--====================================================================--
--== Style Static Functions


function Style.initialize( manager, params )
	-- print( "Style.initialize", manager )
	params = params or {}
	if params.mode==nil then params.mode=uiConst.RUN_MODE end
	--==--

	dUI = manager

	--== Base Components

	local StyleMgr = require( ui_find( 'dmc_style.style_manager' ) )
	local StyleMixModule = require( ui_find( 'dmc_style.style_mix' ) )

	Style.Manager=StyleMgr
	Style.StyleMix=StyleMixModule.StyleMix

	StyleMixModule.initialize( Style, params )
	StyleMgr.initialize( Style, params )

	--== Add API calls

	-- Style Manager

	dUI.addStyle = Style.addStyle
	dUI.addThemeStyle = Style.addThemeStyle
	dUI.createTheme = Style.createTheme
	dUI.getStyle = Style.getStyle
	dUI.purgeStyles = Style.purgeStyles
	dUI.registerWidget = Style.registerWidget
	dUI.removeStyle = Style.removeStyle

	-- Style Interface

	dUI.newBackgroundStyle = Style.newBackgroundStyle
	dUI.newButtonStyle = Style.newButtonStyle
	dUI.newNavBarStyle = Style.newNavBarStyle
	dUI.newNavItemStyle = Style.newNavItemStyle
	dUI.newRectangleBackgroundStyle = Style.newRectangleBackgroundStyle
	dUI.newRoundedBackgroundStyle = Style.newRoundedBackgroundStyle
	dUI.newTextFieldStyle = Style.newTextFieldStyle
	dUI.newTextStyle = Style.newTextStyle

end



--====================================================================--
--== Style Public Functions


--======================================================--
-- newBackgroundStyle Support

function Style._loadBackgroundStyleSupport( params )
	-- print( "Style._loadBackgroundStyleSupport" )
	if Style.Background then return end
	params = params or {}
	if params.mode==nil then params.mode=uiConst.RUN_MODE end
	--==--
	local kmode
	if params.mode==uiConst.TEST_MODE then
		kmode = Kolor.hRGBA
	end

	--== Dependencies

	Style._loadBaseStyleSupport( params )

	--== Components

	local BackgroundStyle = require( ui_find( 'dmc_style.background_style' ) )
	local RectangleStyle = require( ui_find( 'dmc_style.background_style.rectangle_style' ) )
	local RoundedStyle = require( ui_find( 'dmc_style.background_style.rounded_style' ) )
	local BackgroundStyleFactory = require( ui_find( 'dmc_style.background_style.style_factory' ) )

	Style.Background=BackgroundStyle
	Style.BackgroundFactory=BackgroundStyleFactory

	initKolors(
		function()
			BackgroundStyleFactory.initialize( Style, params )
			BackgroundStyle.initialize( Style, params )
		end,
		kmode
	)
end

function Style.newBackgroundStyle( style_info, params )
	-- print( "Style.newBackgroundStyle" )
	style_info = style_info or {}
	params = params or {}
	--==--
	params.data = style_info
	if not Style.Background then Style._loadBackgroundStyleSupport() end
	return Style.Background:createStyleFrom( params )
end

function Style.newRectangleBackgroundStyle( style_info, params )
	style_info = style_info or {}
	params = params or {}
	--==--
	if not Style.Background then Style._loadBackgroundStyleSupport() end
	style_info.type = Style.BackgroundFactory.Rectangle.TYPE
	return Style.newBackgroundStyle( style_info, params )
end

function Style.newRoundedBackgroundStyle( style_info, params )
	style_info = style_info or {}
	params = params or {}
	--==--
	if not Style.Background then Style._loadBackgroundStyleSupport() end
	style_info.type = Style.BackgroundFactory.Rounded.TYPE
	return Style.newBackgroundStyle( style_info, params )
end


--======================================================--
-- newButtonStyle Support

function Style._loadButtonStyleSupport( params )
	-- print( "Style._loadButtonStyleSupport" )
	if Style.Button then return end
	params = params or {}
	if params.mode==nil then params.mode=uiConst.RUN_MODE end
	--==--
	local kmode
	if params.mode==uiConst.TEST_MODE then
		kmode = Kolor.hRGBA
	end

	--== Dependencies

	Style._loadBaseStyleSupport( params )
	Style._loadBackgroundStyleSupport( params )
	Style._loadTextStyleSupport( params )

	--== Components

	local ButtonStyle = require( ui_find( 'dmc_style.button_style' ) )
	local ButtonStateStyle = require( ui_find( 'dmc_style.button_state' ) )

	Style.Button=ButtonStyle
	Style.ButtonState=ButtonStateStyle

	initKolors(
		function()
			ButtonStateStyle.initialize( Style, params )
			ButtonStyle.initialize( Style, params )
		end,
		kmode
	)
end

function Style.newButtonStyle( style_info, params )
	-- print("Style.newButtonStyle")
	style_info = style_info or {}
	params = params or {}
	--==--
	params.data = style_info
	if not Style.Button then Style._loadButtonStyleSupport() end
	return Style.Button:createStyleFrom( params )
end


--======================================================--
-- newNavBarStyle Support

function Style._loadNavBarStyleSupport( params )
	-- print( "Style._loadNavBarStyleSupport" )
	if Style.NavBar then return end
	params = params or {}
	if params.mode==nil then params.mode=uiConst.RUN_MODE end
	--==--
	local kmode
	if params.mode==uiConst.TEST_MODE then
		kmode = Kolor.hRGBA
	end

	--== Dependencies

	Style._loadBaseStyleSupport( params )
	Style._loadBackgroundStyleSupport( params )
	Style._loadButtonStyleSupport( params )

	--== Components

	local NavBarStyle = require( ui_find( 'dmc_style.navbar_style' ) )
	local NavItemStyle = require( ui_find( 'dmc_style.navitem_style' ) )

	Style.NavBar=NavBarStyle
	Style.NavItem=NavItemStyle

	initKolors(
		function()
			NavItemStyle.initialize( Style, params )
			NavBarStyle.initialize( dUI, params )
		end,
		kmode
	)
end

function Style.newNavBarStyle( style_info, params )
	-- print( "Style.newNavBarStyle" )
	style_info = style_info or {}
	params = params or {}
	--==--
	params.data = style_info
	if not Style.NavBar then Style._loadNavBarStyleSupport() end
	return Style.NavBar:createStyleFrom( params )
end

function Style.newNavItemStyle( style_info, params )
	-- print( "Style.newNavItemStyle" )
	style_info = style_info or {}
	params = params or {}
	--==--
	params.data = style_info
	if not Style.NavItem then Style._loadNavBarStyleSupport() end
	return Style.NavItem:createStyleFrom( params )
end


--======================================================--
-- newTextStyle Support

function Style._loadTextStyleSupport( params )
	-- print( "Style._loadTextStyleSupport" )
	if Style.Text then return end
	params = params or {}
	if params.mode==nil then params.mode=uiConst.RUN_MODE end
	--==--
	local kmode
	if params.mode==uiConst.TEST_MODE then
		kmode = Kolor.hRGBA
	end

	--== Dependencies

	Style._loadBaseStyleSupport( params )

	--== Components

	local TextStyle = require( ui_find( 'dmc_style.text_style' ) )

	Style.Text=TextStyle

	initKolors(
		function()
			TextStyle.initialize( Style, params )
		end,
		kmode
	)
end

function Style.newTextStyle( style_info, params )
	-- print( "Style.newTextStyle" )
	style_info = style_info or {}
	params = params or {}
	--==--
	params.data = style_info
	if not Style.Text then Style._loadTextStyleSupport() end
	return Style.Text:createStyleFrom( params )
end


--======================================================--
-- newTextFieldStyle Support

function Style._loadTextFieldStyleSupport( params )
	-- print( "Style._loadTextFieldStyleSupport" )
	if Style.TextField then return end
	params = params or {}
	if params.mode==nil then params.mode=uiConst.RUN_MODE end
	--==--
	local kmode
	if params.mode==uiConst.TEST_MODE then
		kmode = Kolor.hRGBA
	end

	--== Dependencies

	Style._loadBaseStyleSupport( params )
	Style._loadBackgroundStyleSupport( params )
	Style._loadTextStyleSupport( params )

	--== Components

	local TextFieldStyle = require( ui_find( 'dmc_style.textfield_style' ) )

	Style.TextField=TextFieldStyle

	initKolors(
		function()
			TextFieldStyle.initialize( Style, params )
		end,
		kmode
	)
end

function Style.newTextFieldStyle( style_info, params )
	-- print( "Style.newTextFieldStyle" )
	style_info = style_info or {}
	params = params or {}
	--==--
	params.data = style_info
	if not Style.TextField then Style._loadTextFieldStyleSupport() end
	return Style.TextField:createStyleFrom( params )
end



--====================================================================--
--== Private Functions


function Style._loadBaseStyleSupport( params )
	-- print( "Style._loadBaseStyleSupport" )
	if Style.Base then return end
	params = params or {}
	if params.mode==nil then params.mode=uiConst.RUN_MODE end
	--==--
	local kmode
	if params.mode==uiConst.TEST_MODE then
		kmode = Kolor.hRGBA
	end

	local BaseStyle = require( ui_find( 'dmc_style.base_style' ) )
	Style.Base=BaseStyle
	initKolors(
		function()
			BaseStyle.initialize( Style, params )
		end,
		kmode
	)
end



--====================================================================--
--== Event Handlers


-- none



return Style
