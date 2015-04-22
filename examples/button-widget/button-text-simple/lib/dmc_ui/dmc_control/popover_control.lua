--====================================================================--
-- dmc_ui/dmc_control/popover_control.lua
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
--== DMC Corona UI : Popover Control
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

--== To be set in initialize()
local dUI = nil



--====================================================================--
--== Popover Control Widget Class
--====================================================================--


local PopControl = newClass( PresentationControl, {name="Popover Control"} )


--======================================================--
-- Start: Setup DMC Objects

--== init

function PopControl:__init__( params )
	-- print( "PopControl:__init__" )
	params = params or {}
	-- params.automask=true

	self:superCall( '__init__', params )
	--==--

	--== Create Properties ==--

	-- properties stored in Class

	self._arrowDirs = params.arrowDirections
	self._arrowDirs_dirty=true

	self._buttonItem = params.buttonItem
	self._buttonItem_dirty=true

	-- this is the position of the activating button
	self._x_pos = params.x_pos
	self._y_pos = params.y_pos

end
--[[
function PopControl:__undoInit__()
	-- print( "PopControl:__undoInit__" )
	--==--
	self:superCall( '__undoInit__' )
end
--]]

--== createView

--[[
function PopControl:__createView__()
	print( "PopControl:__createView__" )
	self:superCall( '__createView__' )
	--==--
end
function PopControl:__undoCreateView__()
	print( "PopControl:__undoCreateView__" )
	--==--
	self:superCall( '__undoCreateView__' )
end
--]]


--== initComplete

--[[
function PopControl:__initComplete__()
	--print( "PopControl:__initComplete__" )
	self:superCall( '__initComplete__' )
	--==--
end

function PopControl:__undoInitComplete__()
	--print( "PopControl:__undoInitComplete__" )
	--==--
	self:superCall( '__undoInitComplete__' )
end
--]]

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


function PopControl.__setters:buttonItem( value )
	assert( value )
	--==--
	self._buttonItem = value
	self:_recalculatePresentedViewLayout()
end



function PopControl:show( pos, params )
	-- print( "PopControl:show", pos )
	assert( pos.x and pos.y )
	--==--
	self.x, self.y = pos.x, pos.y
	self.isVisible = true
end

function PopControl:hide()
	-- print( "PopControl:hide" )
	local d = self._delegate
	self.isVisible = false
	if d and d.isDismissed then
		timer.performWithDelay( 1, function() d:isDismissed() end)
	end
end


--======================================================--
-- Delegate Methods

-- replaces: prepareForPopoverPresentation
--
function PopControl:presentationWillBegin()
	local del = self._delegate
	local f = del and del.presentationWillBegin
	if f then return f( del, self ) end
end

-- replaces: popoverPresentationControllerShouldDismissPopover
--
function PopControl:shouldDismissPopover()
	-- print( "PopControl:shouldDismissPopover" )
	local result = true
	local del = self._delegate
	local f = del and del.shouldDismissPopover
	if f then result = f( del, self ) end
	return result
end

-- replaces: popoverPresentationControllerDidDismissPopover
--
function PopControl:dismissalEnded()
	local del = self._delegate
	local f = del and del.dismissalEnded
	if f then return f( del, self ) end
end

-- replaces: willRepositionPopoverToRect
--
function PopControl:_willRepositionPopover( params )
	local del = self._delegate
	local f = del and del.willRepositionPopover
	if f then
		return f( del, self, params )
	else
		return params
	end
end





--====================================================================--
--== Private Methods


function PopControl:_recalculateAnchorPosition( params )
	-- TODO: hook up to rectangle
	-- TODO: make much smarter
	local posX, posY = 0, 0
	if self._buttonItem then
		local o = self._buttonItem
		local bXc, bYc = o:localToContent( 0,0 )
		local bW, bH = o.width, o.height
		posX = (bXc-bW*0.5)
		posY = (bYc-bH*0.5)
	end
	params.posX, params.posY = posX, posY
end

function PopControl:_recalculateDimensions( params )
	-- TODO: hook up to keyboard event
	local pc = self._presentedControl
	local pcS = pc.preferredContentSize
	local keyboard = false
	local W, H = pcS.width, pcS.height
	if keyboard then
		local kbh = uiConst.getKeyboardHeight()
		H = H - kbh
	end
	params.width, params.height = W, H
end

function PopControl:_recalculatePosition( params )
	-- TODO: hook up to keyboard event
	local W, H = dUI.WIDTH, dUI.HEIGHT
	local H_CENTER, V_CENTER = W*0.5, H*0.5
	local pc = self._presentedControl
	local keyboard = false
	local posX, posY = params.posX, params.posY
	local MARGIN = { x=20,y=40 }
	local X, Y
	if keyboard then
		local kbh = uiConst.getKeyboardHeight()
		H = H - kbh
	end
	params.x = posX-H_CENTER-MARGIN.x-pc.width*0.5
	params.y = posY-MARGIN.y

end


function PopControl:_recalculatePresentedViewLayout()
	-- print( "PopControl:_recalculatePresentedViewLayout" )
	if not self._presentedControl or not self._presentedControlSetView then return end
	--==--
	local pc = self._presentedControl
	local oldW, oldH = pc.width, pc.height
	local dg = self._presentedControlSetView
	local oldX, oldY = dg.x, dg.y

	local params = {
		posX=0, posY=0,
		x=dg.x, y=dg.y,
		width=self._preferredWidth, height=self._preferredHeight,
		view=dg
	}

	self:_recalculateAnchorPosition( params )
	self:_recalculateDimensions( params )
	self:_recalculatePosition( params )

	params = self:_willRepositionPopover( params )

	if params.x~=oldX or params.y~=oldY then
		self._presentedControlPos = {
			x=params.x, y=params.y
		}
		self._presentedControlPos_dirty=true
		self:__invalidateProperties__()
	end

	if params.width~=oldW or params.height~=oldH then
		pc.width, pc.height = params.width, params.height
		self._dgMain_dirty=true
		self:__invalidateProperties__()
	end

	if params.view ~= self._presentedControlSetView then
		self._presentedControlSetView = params.view
		self._presentedControlSetView_dirty=true
		self:__invalidateProperties__()
	end

end



--====================================================================--
--== Event Handlers


-- none




return PopControl
