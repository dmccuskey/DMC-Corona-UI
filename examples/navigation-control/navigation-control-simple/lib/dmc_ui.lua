--====================================================================--
-- dmc_ui.lua
--
-- entry point into dmc-corona-ui
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
--== DMC UI
--====================================================================--


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "1.1.0"



--====================================================================--
--== DMC UI Config
--====================================================================--


local args = { ... }
local PATH = args[1]

local dmc_ui_data, dmc_ui_func

if _G.__dmc_ui == nil then

	_G.__dmc_ui = {}
	dmc_ui_data = _G.__dmc_ui

	dmc_ui_data.func = {}
	dmc_ui_func = dmc_ui_data.func
	dmc_ui_func.find = function( name )
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


-- boot dmc_corona with boot script or
-- setup basic defaults if not available
--
if false == pcall( function() require 'dmc_corona_boot' end ) then
	_G.__dmc_corona = {
		dmc_corona={},
	}
end



--===================================================================--
--== Imports


local uiConst = require( PATH .. '.' .. 'ui_constants' )
local UIUtils = require( PATH .. '.' .. 'ui_utils' )



--===================================================================--
--== Setup, Constants


local WIDTH, HEIGHT = display.contentWidth, display.contentHeight

local sfmt = string.format

local LOCAL_DEBUG = false

local UI = {}

UI.stage = nil


--===================================================================--
--== Support Functions


local function createUIStage()
	local W, H = WIDTH, HEIGHT
	local H_CENTER, V_CENTER = W*0.5, H*0.5

	-- create main layer
	local dg = display.newGroup()
	dg.x, dg.y = H_CENTER, 0
	UI.stage = dg
end

local function initialize( params )
	-- print( "UI.initialize" )

	local Style = require( PATH .. '.' .. 'dmc_style' )
	local Widget = require( PATH .. '.' .. 'dmc_widget' )
	local Control = require( PATH .. '.' .. 'dmc_control' )

	UI.Style = Style
	UI.Widget = Widget
	UI.Control = Control

	--== Initialize

	Style.initialize( UI, params )
	Widget.initialize( UI, params )
	Control.initialize( UI, params )

	--== Set UI/UX

	if uiConst.IS_ANDROID then
		UI.setOS( uiConst.ANDROID )
	elseif uiConst.IS_WINDOWS then
		UI.setOS( uiConst.WINDOWS )
	elseif uiConst.IS_IOS then
		UI.setOS( uiConst.IOS )
	else
		UI.setOS( uiConst.IOS )
	end

	createUIStage()
end



--====================================================================--
--== UI Manager
--====================================================================--


--== Class Constants

UI.WIDTH = WIDTH
UI.HEIGHT = HEIGHT

UI.__os__ = nil -- 'iOS', 'android'
UI.__osVersion__ = nil -- 'iOS'-'8.0', 'android'-'2.1'

UI._VALID_OS = {
	[uiConst.IOS]=uiConst.IOS,
	[uiConst.ANDROID]=uiConst.ANDROID,
	default=uiConst.IOS,
	-- [uiConst.WINDOWS]=uiConst.WINDOWS
}

UI._VALID_OS_VERSION = {

	[uiConst.IOS]={
		default=uiConst.IOS_8x,
		[uiConst.IOS_8x]=uiConst.IOS_8x
	},

	[uiConst.ANDROID]={
		default=uiConst.ANDROID_21,
		[uiConst.ANDROID_20]=uiConst.ANDROID_20,
		[uiConst.ANDROID_21]=uiConst.ANDROID_21
	},
	-- [uiConst.WINDOWS]=true
}

UI.RUN_MODE = uiConst.RUN_MODE
UI.TEST_MODE = uiConst.TEST_MODE

UI.ROUNDED = uiConst.ROUNDED
UI.RECTANGLE = uiConst.RECTANGLE

-- Control Modal Types

UI.POPOVER = uiConst.POPOVER


--===================================================================--
--== Interface Functions

--[[
Each of the sections (Style, Widget, Control) add their
functions to this UI object
All methods are available with easier maintenance
--]]



--===================================================================--
--== Misc Functions


function UI.setOS( platform, version )
	-- print( "UI.setOS", platform, version )

	--== Set OS

	local os = UI._VALID_OS[ platform ]
	if not os then
		os = UI._VALID_OS.default
		print( sfmt( "[WARNING] UIs.setOS() unknown OS '%s'", tostring(platform) ))
		print( sfmt( "Setting to default '%s'", tostring( os ) ) )
	end
	UI.__os__ = os

	--== Set OS Version

	local versions = UI._VALID_OS_VERSION[ os ]
	local value = versions[ version ]
	if not value then
		value = versions.default
		if LOCAL_DEBUG then
			print( sfmt( "[WARNING] UIs.setOS() unknown OS Version '%s'", tostring( version )))
			print( sfmt( "Setting to default '%s'", tostring( value ) ) )
		end
	end
	UI.__osVersion__ = value

	if LOCAL_DEBUG then
		print( "UI theme set for ", os, value )
	end

end



--====================================================================--
--== Init UIs
--====================================================================--


initialize()


return UI
