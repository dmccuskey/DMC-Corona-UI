--====================================================================--
-- dmc_ui/dmc_control/core/presentation_control.lua
--
-- Documentation:
--====================================================================--

--[[

The MIT License (MIT)

Copyright (C) 2015 David McCuskey. All Rights Reserved.

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
--== DMC Corona UI : Presentation Control
--====================================================================--


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.1.0"



--====================================================================--
--== DMC Corona UI Setup
--====================================================================--


local dmc_ui_data = _G.__dmc_ui
local dmc_ui_func = dmc_ui_data.func
local ui_find = dmc_ui_func.find



--====================================================================--
--== DMC UI :
--====================================================================--



--====================================================================--
--== Imports


local LifecycleMixModule = require 'dmc_lifecycle_mix'
local Objects = require 'dmc_objects'
local uiConst = require( ui_find( 'ui_constants' ) )
local Utils = require 'dmc_utils'



--====================================================================--
--== Setup, Constants


-- setup some aliases to make code cleaner
local newClass = Objects.newClass
local ComponentBase = Objects.ComponentBase

local LifecycleMix = LifecycleMixModule.LifecycleMix

--== To be set in initialize()
local dUI = nil



--====================================================================--
--== Presentation Control Base Class
--====================================================================--


local Presentation = newClass(
	{ ComponentBase, LifecycleMix }, {name="Presentation Control"}
)

--== Event Constants

Presentation.EVENT = 'navigation-control-event'

--======================================================--
-- Start: Setup DMC Objects

--== init

function Presentation:__init__( params )
	-- print( "Presentation:__init__" )
	params = params or {}
	if params.automask==nil then params.automask=false end

	self:superCall( LifecycleMix, '__init__', params )
	self:superCall( ComponentBase, '__init__', params )
	--==--

	if self.is_class then return end

	--== Create Properties ==--

	-- properties stored in Class

	self._animation = nil
	self._animation_dirty=false

	self._automask = params.automask
	self._automask_dirty=true

	self._initialize_dirty=true

	self._preferredWidth=params.width
	self._preferredHeight=params.height

	--== Display Groups ==--

	--[[
	group for presentation background elements
	--]]
	self._dgBg = nil

	--[[
	group for presented view
	--]]
	self._dgMain = nil
	self._dgMain_dirty=true

	--== Object References ==--

	--[[
	Control which was starting point of presentation
	--]]
	self._presentingControl = nil
	self._presentingControl_dirty=true

	--[[
	Control which was passed with presentControl
	--]]
	self._presentedControl = nil
	self._presentedControl_dirty=true
	self._presentedControlSetView = nil
	self._presentedControlSetView_dirty=true
	self._presentedControlPos = {x=0,y=0}
	self._presentedControlPos_dirty=true

	--[[
	View in which the presentation occurs
	--]]
	self._containerView = nil
	self._containerView_dirty=true

	--[[
	delegate object for managing adaptive presentations
	--]]
	self._delegate = params.delegate

	--== Visual

	-- main visual background
	self._rctDim = nil
	self._rctDim_dirty=true

	self._pointer = nil -- pointer element

end
function Presentation:__undoInit__()
	--print( "Presentation:__undoInit__" )
	self._delegate = nil
	--==--
	self:superCall( ComponentBase, '__undoInit__' )
	self:superCall( LifecycleMix, '__undoInit__' )
end

--== createView

function Presentation:__createView__()
	-- print( "Presentation:__createView__" )
	self:superCall( ComponentBase, '__createView__' )
	--==--
	local dg = display.newGroup()
	self:insert( dg )
	self._dgBg = dg
end
function Presentation:__undoCreateView__()
	-- print( "Presentation:__undoCreateView__" )
	self._dgBg:removeSelf()
	self._dgBg = nil
	--==--
	self:superCall( ComponentBase, '__undoCreateView__' )
end

--== initComplete

function Presentation:__initComplete__()
	-- print( "Presentation:__initComplete__" )
	self:superCall( ComponentBase, '__initComplete__' )
	--==--
	-- self:setTouchBlock( self._rctMain )
end
function Presentation:__undoInitComplete__()
	-- print( "Presentation:__undoInitComplete__" )
	self:_unsetPresentedControlFromView()
	self:_destroyDimmingView()
	self:_destroyDgMain()
	-- self:unsetTouchBlock( self._rctMain )
	--==--
	self:superCall( ComponentBase, '__undoInitComplete__' )
end

-- END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Static Methods


function Presentation.initialize( manager )
	-- print( "Presentation.initialize" )
	dUI = manager
end



--====================================================================--
--== Public Methods

-- init
-- initialize the presentation, call presentControl() after
--
function Presentation:init( presentedControl, presentingControl )
	-- print( "Presentation:init" )
	assert( presentedControl )
	assert( presentingControl )
	--==--
	self._presentedControl = presentedControl
	self._presentedControl.alpha = 0
	self._presentingControl = presentingControl

	self._initialize_dirty=true
	self._presentingControl_dirty=true
	self._presentedControl_dirty=true
end


function Presentation:presentControl( params )
	-- print( "Presentation:presentControl" )
	self._animation = self:_createShowFunc( params )
	self._animation_dirty=true
	self:__invalidateProperties__()
end

function Presentation:dismissControl( params )
	-- print( "Presentation:dismissControl" )
	self._animation = self:_createDismissFunc( params )
	self._animation_dirty=true
	self:__invalidateProperties__()
end


function Presentation:presentedControlView()
	-- print( "Presentation:presentedControlView" )
	return self._presentedControl.view
end



--====================================================================--
--== Private Methods


function Presentation:_presentationWillBegin() end
function Presentation:_presentationEnded() end

function Presentation:_createShowFunc( params )
	-- print( "Presentation:_createShowFunc" )
	params = params or {}
	--==--
	local tcf = Utils.getTransitionCompleteFunc( 2, function()
		self._animation=nil
		self:_presentationEnded()
		if params.onComplete then params.onComplete() end
	end)
	local animFunc = function( animate )
		local time = uiConst.PRESENT_CONTROL_TRANSITION_TIME
		self:_presentationWillBegin()
		local p = {time=time, alpha=1, onComplete=tcf}
		transition.to( self._rctDim, p )
		transition.to( self._presentedControl, p )
	end
	return animFunc
end


function Presentation:_dismissalWillBegin() end
function Presentation:_dismissalEnded() end

function Presentation:_createDismissFunc( params )
	-- print( "Presentation:_createDismissFunc" )
	params = params or {}
	--==--
	local tcf = Utils.getTransitionCompleteFunc( 2, function()
		self._animation=nil
		self:_dismissalEnded()
		if params.onComplete then params.onComplete() end
	end)
	local animFunc = function( animate )
		local time = uiConst.PRESENT_CONTROL_TRANSITION_TIME
		self:_dismissalWillBegin()
		transition.to( self._rctDim, {time=time, alpha=0, onComplete=tcf} )
		transition.to( self._presentedControl, {time=time, alpha=0, onComplete=tcf} )
	end
	return animFunc
end


function Presentation:_willRepositionPopover()

end

function Presentation:_recalculatePresentedViewLayout()
	-- print( "Presentation:_recalculatePresentedViewLayout" )
	if not self._presentedControl or not self._presentedControlSetView then return end
	--==--
	-- TODO: link with keyboard event
	local pc = self._presentedControl
	local oldW, oldH = pc.width, pc.height
	local dg = self._presentedControlSetView
	local oldX, oldY = dg.x, dg.y

	--[[
	do recalculations here
	--]]
	local params = {
		x=dg.x,y=dg.y,
		width=pc.width,height=pc.height,
		view=self._presentedControlSetView
	}

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



--======================================================--
-- DMC Lifecycle Methods

function Presentation:_setContainerView()
	-- print( "Presentation:_setContainerView" )
	local dg = dUI.stage
	dg:insert( self.view )
	self._containerView = dg
end


function Presentation:_destroyDgMain()
	local o = self._dgMain
	if not o then return end
	o:removeSelf()
	self._dgMain = nil
end

function Presentation:_createDgMain()
	-- print( "Presentation:_createDgMain" )
	local pc = self._presentedControl
	local dg

	if self._dgMain and self._dgMain==self._presentedControlSetView then
		-- store temporarily while current view is being deleted
		local view = self:presentedControlView()
		self.view:insert( view )
		self._presentedControlSetView=nil
	end

	self:_destroyDgMain()

	if self._automask then
		dg = display.newContainer( pc.width, pc.height )
		dg.anchorChildren = false
	else
		dg = display.newGroup()
	end
	dg.anchorX, dg.anchorY = 0.5, 0

	self:insert( dg )
	self._dgMain = dg

	if not self._presentedControlSetView then
		self._presentedControlSetView = dg
	end

	self._presentedControlSetView_dirty=true
end


function Presentation:_destroyDimmingView()
	-- print( "Presentation:_destroyDimmingView" )
	local o = self._rctDim
	if not o then return end
	o:removeSelf()
	self._rctDim = nil
end

function Presentation:_createDimmingView()
	-- print( "Presentation:_createDimmingView" )
	local o

	self:_destroyDimmingView()

	o = display.newRect( 0, 0, dUI.WIDTH, dUI.HEIGHT )
	o:setFillColor(1,1,1,0.8)
	if true then
		o:setFillColor(1,0,0,0.1)
	end
	o.alpha = 0
	o.anchorX, o.anchorY = 0.5,0

	self._dgBg:insert( o )
	self._rctDim = o

	--== Reset properties

end


function Presentation:_updatePresentedControlPosition()
	-- print( "Presentation:_updatePresentedControlPosition" )
	local dg = self._presentedControlSetView
	local pos = self._presentedControlPos
	dg.x, dg.y = pos.x, pos.y
end

function Presentation:_unsetPresentedControlFromView()
	-- print( "Presentation:_unsetPresentedControlFromView" )
	local pc = self._presentedControl
	if not pc then return end
	-- TODO: do remove stuff
	self._presentedControl = nil
end

function Presentation:_setPresentedControlInView()
	-- print( "Presentation:_setPresentedControlInView" )
	local view = self:presentedControlView()
	self._presentedControlSetView:insert( view )
end


function Presentation:__commitProperties__()
	-- print( "Presentation:__commitProperties__" )

	if self._initialize_dirty then
		self._initialize_dirty=false

		self._rctDim_dirty=true
		self._presentedControlCalculations_dirty=true
	end

	if self._containerView_dirty then
		self:_setContainerView()
		self._containerView_dirty=false
	end

	if self._dgMain_dirty then
		self:_createDgMain()
		self._dgMain_dirty=false
	end

	if self._rctDim_dirty then
		self:_createDimmingView()
		self._rctDim_dirty = false
	end

	if self._presentingControl_dirty then
		self._presentingControl_dirty=false
	end

	if self._presentedControlSetView_dirty then
		self:_setPresentedControlInView()
		self._presentedControlSetView_dirty=false

		self._presentedControlPos_dirty=true
	end

	if self._presentedControlCalculations_dirty then
		self:_recalculatePresentedViewLayout()
		self._presentedControlCalculations_dirty=true
	end

	if self._presentedControlPos_dirty then
		self:_updatePresentedControlPosition()
		self._presentedControlPos_dirty=false
	end

	if self._animation_dirty then
		self._animation()
		self._animation_dirty=false
	end

end



--====================================================================--
--== Event Handlers


-- TODO: hook this into keyboard event
--
function Presentation:_keyboardEvent_handler( event )
	self._recalculatePresentedViewLayout()
end



return Presentation
