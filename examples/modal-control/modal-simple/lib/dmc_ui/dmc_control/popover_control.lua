--====================================================================--
-- dmc_ui/dmc_control/popover_control.lua
--
-- Documentation: https://github.com/dmccuskey/DMC-Corona-UI
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
--== DMC Corona UI : Popover Control
--====================================================================--



-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.2.0"



--====================================================================--
--== DMC UI Setup
--====================================================================--


local dmc_ui_data = _G.__dmc_ui
local dmc_ui_func = dmc_ui_data.func
local ui_find = dmc_ui_func.find



--====================================================================--
--== DMC UI : newPopoverControl
--====================================================================--



--====================================================================--
--== Imports


local Objects = require 'dmc_objects'
local uiConst = require( ui_find( 'ui_constants' ) )

local PresentationControl = require( ui_find( 'dmc_control.core.presentation_control' ) )



--====================================================================--
--== Setup, Constants


local newClass = Objects.newClass

local mmax = math.max
local mmin = math.min

--== To be set in initialize()
local dUI = nil



--====================================================================--
--== Popover Control Widget Class
--====================================================================--


local PopControl = newClass( PresentationControl, {name="Popover Control"} )

--== Class Constants

PopControl.DEFAULT_TRANSITION = uiConst.FADE
PopControl.DEFAULT_DISMISS_ON_TAP_OUTSIDE = true

PopControl.MARGIN = 10 -- between the panel and the screen's edge, the button


--======================================================--
-- Start: Setup DMC Objects

--== init

function PopControl:__init__( params )
	-- print( "PopControl:__init__" )
	params = params or {}

	self:superCall( '__init__', params )
	--==--

	if self.is_class then return end

	--== Create Properties ==--

	self._arrowDirs = params.arrowDirections

	-- the display object the popover belongs to
	self._buttonItem = params.buttonItem

end

function PopControl:__undoInit__()
	-- print( "PopControl:__undoInit__" )
	self._buttonItem = nil
	--==--
	self:superCall( '__undoInit__' )
end

-- END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Static Methods


function PopControl.initialize( manager )
	-- print( "PopControl.initialize" )
	dUI = manager
end



--====================================================================--
--== Public Methods


--== .buttonItem

-- the display object the popover belongs to, eg the button which opens it
--
function PopControl.__getters:buttonItem()
	return self._buttonItem
end
function PopControl.__setters:buttonItem( value )
	self._buttonItem = value
	self:_layout()
end

--== .arrowDirections

function PopControl.__getters:arrowDirections()
	return self._arrowDirs
end
function PopControl.__setters:arrowDirections( value )
	self._arrowDirs = value
	self:_layout()
end



--====================================================================--
--== Private Methods


-- the panel's frame: the control's preferred size, below the button
-- and kept on the screen; centered without a button
--
function PopControl:_getPanelFrame( screen )
	local MARGIN = PopControl.MARGIN
	local frame = PresentationControl._getPanelFrame( self, screen )
	local o = self._buttonItem
	if not o or not o.contentBounds then return frame end

	local b = o.contentBounds
	local w, h = frame.width, frame.height
	local xMin, xMax = screen.x+MARGIN+w*0.5, screen.x+screen.width-MARGIN-w*0.5
	local yMin, yMax = screen.top+MARGIN, screen.y+screen.height-MARGIN-h

	frame.x = mmax( xMin, mmin( xMax, ( b.xMin+b.xMax )*0.5 ) )
	frame.y = mmax( yMin, mmin( yMax, b.yMax+MARGIN ) )
	return frame
end



return PopControl
