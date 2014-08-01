--====================================================================--
-- widget_button/view_shape.lua
--
-- Documentation: http://docs.davidmccuskey.com/display/docs/newButton.lua
--====================================================================--

--[[

Copyright (C) 2013-2014 David McCuskey. All Rights Reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in the
Software without restriction, including without limitation the rights to use, copy,
modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
and to permit persons to whom the Software is furnished to do so, subject to the
following conditions:

The above copyright notice and this permission notice shall be included in all copies
or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.

--]]


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.1.0"



--====================================================================--
--== DMC Widgets Setup
--====================================================================--

local dmc_widget_data, dmc_widget_func
dmc_widget_data = _G.__dmc_widget
dmc_widget_func = dmc_widget_data.func



--====================================================================--
--== DMC Widgets : Button Shape View
--====================================================================--



--====================================================================--
--== Imports

local Objects = require 'dmc_objects'
local Utils = require 'dmc_utils'


--====================================================================--
--== Setup, Constants

-- setup some aliases to make code cleaner
local inheritsFrom = Objects.inheritsFrom
local CoronaBase = Objects.CoronaBase

local LOCAL_DEBUG = false



--====================================================================--
--== Button Shape View Class
--====================================================================--


local ShapeView = inheritsFrom( CoronaBase )
ShapeView.NAME = "Shape View"

ShapeView.TYPE_RECT = 'rect'
ShapeView.TYPE_ROUNDED_RECT = 'roundedRect'
ShapeView.TYPE_CIRCLE = 'circle'
ShapeView.TYPE_POLYGON = 'polygon'



--======================================================--
-- Start: Setup DMC Objects

function ShapeView:_init( params )
	-- print( "ShapeView:_init" )
	params = params or { }
	self:superCall( "_init", params )
	--==--

	--== Sanity Check ==--

	if self.is_intermediate then return end

	--== Create Properties ==--

	self._type =
	--== Display Groups ==--

	--== Object References ==--

	-- visual

end

-- function ShapeView:_undoInit()
-- 	-- print( "ShapeView:_undoInit" )
-- 	--==--
-- 	self:superCall( "_undoInit" )
-- end


-- _createView()
--
function ShapeView:_createView()
	-- print( "ShapeView:_createView" )
	self:superCall( "_createView" )
	--==--

	local WIDTH, HEIGHT = display.contentWidth, display.contentHeight

	local W,H = self._width, self._height
	local H_CENTER, V_CENTER = W*0.5, H*0.5

	local o, dg, tmp  -- object, display group, tmp

	--== setup background

	o = display.newRect(0, 0, WIDTH, HEIGHT)
	o:setFillColor(0,0,0,0)
	if LOCAL_DEBUG then
		o:setFillColor(0,255,0,255)
	end
	o.isHitTestable = true
	o.anchorX, o.anchorY = 0,0
	o.x, o.y = 0,0

	self.view:insert( o )
	self._bg_touch = o


	dg = display.newGroup()
	self.view:insert( dg )
	self._dg_bg = dg

	-- viewable background

	o = display.newRect(0, 0, W, H)
	o:setFillColor(1,1,1,0.8)
	if LOCAL_DEBUG then
		o:setFillColor(0,255,0,255)
	end
	o.anchorX, o.anchorY = 0,0
	o.x, o.y = 0,0

	dg:insert( o )
	self._bg_main = o

	--== setup main group

	dg = display.newGroup()
	self.view:insert( dg )
	self._dg_main = dg

end

function ShapeView:_undoCreateView()
	-- print( "ShapeView:_undoCreateView" )

	local o

	--==--
	self:superCall( "_undoCreateView" )
end


-- _initComplete()
--
function ShapeView:_initComplete()
	--print( "ShapeView:_initComplete" )

	local o, f

	o = self._bg_touch
	o._f = self:createCallback( self._bgTouchEvent_handler )
	o:addEventListener( 'touch', o._f )

	self:_updateView()
	--==--
	self:superCall( "_initComplete" )
end

function ShapeView:_undoInitComplete()
	--print( "ShapeView:_undoInitComplete" )

	o = self._bg_touch
	o:removeEventListener( 'touch', o._f )
	o._f = nil

	--==--
	self:superCall( "_undoInitComplete" )
end


--== END: Setup DMC Objects





--====================================================================--
--== Public Methods

-- we only want items inserted into proper layer
function ShapeView:insert( ... )
	print( "ShapeView:insert" )
	self._dg_main:insert( ... )
end

function ShapeView:show()
	-- print( "ShapeView:show" )
	self.view.isVisible = true
	self._bg_touch.isHitTestable = true
end
function ShapeView:hide()
	-- print( "ShapeView:hide" )
	self.view.isVisible = false
	self._bg_touch.isHitTestable = false
end

function ShapeView.__setters:x( value )
	self._dg_bg.x = value
	self._dg_main.x = value
end
function ShapeView.__setters:y( value )
	self._dg_bg.y = value
	self._dg_main.y = value
end


--====================================================================--
--== Private Methods

function ShapeView:_updateView()
	print( "ShapeView:_updateView" )
end

function ShapeView:_doCancelCallback()
	print( "ShapeView:_doCancelCallback" )
	if type(self._onCancel)~='function' then return end
	local event = {}
	self._onCancel( event )
end

function ShapeView:_doDoneCallback()
	print( "ShapeView:_doDoneCallback" )
	if type(self._onDone)~='function' then return end
	local event = {}
	self._onDone( event )
end


--====================================================================--
--== Event Handlers

function ShapeView:_bgTouchEvent_handler( event )
	print( "ShapeView:_bgTouchEvent_handler", event.phase )
	local target = event.target

	if event.phase == 'began' then
		display.getCurrentStage():setFocus( target )
		self._has_focus = true
	end

	if not self._has_focus then return end

	if event.phase == 'ended' or event.phase == 'canceled' then
		if self._outsideTouchAction == ShapeView.TOUCH_DONE then
			self:_doDoneCallback()
		elseif self._outsideTouchAction == ShapeView.TOUCH_CANCEL then
			self:_doCancelCallback()
		else
			-- pass
		end
		self._has_focus = false
	end

end



return ShapeView
