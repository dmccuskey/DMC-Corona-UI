--====================================================================--
-- dmc_ui/dmc_control.lua
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
--== DMC Corona UI : Control Interface
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
--== DMC UI : Control Interface
--====================================================================--



--====================================================================--
--== Imports


local Kolor = require 'dmc_kolor'



--====================================================================--
--== Setup, Constants


--== To be set in initialize()
local dUI = nil



--===================================================================--
--== Support Functions


local initKolors = Kolor.initializeKolorSet



--====================================================================--
--== Control Interface
--====================================================================--


local Control = {}



--====================================================================--
--== Control Static Functions


function Control.initialize( manager, params )
	-- params = params or {}
	-- if params.mode==nil then params.mode=BaseControl.RUN_MODE end
	--==--
	dUI = manager

	--== Load Components

	-- local ControlMgr = require( ui_find( 'dmc_style.style_manager' ) )
	-- local ControlMixModule = require( ui_find( 'dmc_style.style_mix' ) )

	-- Control.Manager=ControlMgr
	-- Control.ControlMix=ControlMixModule.ControlMix

	-- ControlMgr.initialize( Control, params )
	-- ControlMixModule.initialize( Control, params )

end



--====================================================================--
--== Control Public Functions


--======================================================--
-- newBackgroundControl Support

function Control._loadBackgroundControlSupport( params )
	-- print( "Control._loadBackgroundControlSupport" )

	--== Components

	local BackgroundControl = require( PATH .. '.' .. 'dmc_style.background_style' )
	local RectangleControl = require( PATH .. '.' .. 'background_style.rectangle_style' )
	local RoundedControl = require( PATH .. '.' .. 'background_style.rounded_style' )
	local BackgroundControlFactory = require( PATH .. '.' .. 'background_style.style_factory' )

	Control.Background=BackgroundControl
	Control.BackgroundFactory=BackgroundControlFactory

	initKolors( function()
		BackgroundControlFactory.initialize( Control, params )
		BackgroundControl.initialize( Control, params )
	end)
end

function Control.newBackgroundControl( style_info, params )
	-- print( "Control.newBackgroundControl" )
	style_info = style_info or {}
	params = params or {}
	--==--
	params.data = style_info
	if not Control.Control.Background then Control._loadBackgroundControlSupport() end
	return Control.Control.Background:createControlFrom( params )
end

function Control.newRectangleBackgroundControl( style_info, params )
	style_info = style_info or {}
	params = params or {}
	--==--
	if not Control.Background then Control._loadBackgroundControlSupport() end
	style_info.type = Control.Control.BackgroundFactory.Rectangle.TYPE
	return Control.newBackgroundControl( style_info, params )
end

function Control.newRoundedBackgroundControl( style_info, params )
	style_info = style_info or {}
	params = params or {}
	--==--
	if not Control.Background then Control._loadBackgroundControlSupport() end
	style_info.type = Control.Control.BackgroundFactory.Rounded.TYPE
	return Control.newBackgroundControl( style_info, params )
end


--======================================================--
-- newButtonControl Support

function Control._loadButtonControlSupport( params )
	-- print( "Control._loadButtonControlSupport" )

	--== Dependencies

	Control._loadBackgroundSupport( params )
	Control._loadTextSupport( params )

	--== Components

	local ButtonControl = require( PATH .. '.' .. 'dmc_style.button_style' )
	local ButtonStateControl = require( PATH .. '.' .. 'dmc_style.button_state' )

	Control.Button=ButtonControl
	Control.ButtonState=ButtonStateControl

	initKolors( function()
		ButtonStateControl.initialize( Control, params )
		ButtonControl.initialize( Control, params )
	end)
end

function Control.newButtonControl( style_info, params )
	-- print("Control.newButtonControl")
	style_info = style_info or {}
	params = params or {}
	--==--
	params.data = style_info
	if not Control.Control.Button then Control._loadButtonControlSupport() end
	return Control.Control.Button:createControlFrom( params )
end


--======================================================--
-- newNavBarControl Support

function Control._loadNavBarControlSupport( params )
	-- print( "Control._loadNavBarControlSupport" )

	--== Dependencies

	Control._loadBackgroundControlSupport( params )
	Control._loadButtonControlSupport( params )

	--== Components

	local NavBarControl = require( PATH .. '.' .. 'dmc_style.navbar_style' )
	local NavItemControl = require( PATH .. '.' .. 'dmc_style.navitem_style' )

	Control.NavBar=NavBarControl
	Control.NavItem=NavItemControl

	initKolors( function()
		NavItemControl.initialize( Control, params )
		NavBarControl.initialize( Control, params )
	end)
end

function Control.newNavBarControl( style_info, params )
	-- print( "Control.newNavBarControl" )
	style_info = style_info or {}
	params = params or {}
	--==--
	params.data = style_info
	if not Control.NavBar then Control._loadNavBarControlSupport() end
	return Control.NavBar:createControlFrom( params )
end

function Control.newNavItemControl( style_info, params )
	-- print( "Control.newNavItemControl" )
	style_info = style_info or {}
	params = params or {}
	--==--
	params.data = style_info
	if not Control.NavItem then Control._loadNavBarControlSupport() end
	return Control.NavItem:createControlFrom( params )
end


--======================================================--
-- newTextControl Support

function Control._loadTextControlSupport( params )
	-- print( "Control._loadTextControlSupport" )

	--== Components

	local TextControl = require( PATH .. '.' .. 'dmc_style.text_style' )

	Control.Text=TextControl

	initKolors( function()
		TextControl.initialize( Control, params )
	end)
end

function Control.newTextControl( style_info, params )
	-- print( "Control.newTextControl" )
	style_info = style_info or {}
	params = params or {}
	--==--
	params.data = style_info
	if not Control.Text then Control._loadTextControlSupport() end
	return Control.Text:createControlFrom( params )
end


--======================================================--
-- newTextFieldControl Support

function Control._loadTextFieldControlSupport( params )
	-- print( "Control._loadTextFieldControlSupport" )

	--== Dependencies

	Control._loadBackgroundControlSupport( params )
	Control._loadTextControlSupport( params )

	--== TextField Control Components

	local TextFieldControl = require( PATH .. '.' .. 'dmc_style.textfield_style' )

	Control.TextField=TextField
	Control.TextField=TextFieldControl

	initKolors( function()
		TextFieldControl.initialize( Control, params )
	end)
end

function Control.newTextFieldControl( style_info, params )
	-- print( "Control.newTextFieldControl" )
	style_info = style_info or {}
	params = params or {}
	--==--
	params.data = style_info
	if not Control.TextField then Control._loadTextFieldControlSupport() end
	return Control.TextField:createControlFrom( params )
end



--====================================================================--
--== Private Functions


-- none



--====================================================================--
--== Event Handlers


-- none



return Control
