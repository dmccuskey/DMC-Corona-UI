--====================================================================--
-- dmc_ui/dmc_control/navigation_control.lua
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
--== DMC Corona UI : Navigation Control
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
--== DMC UI : newNavigationControl
--====================================================================--



--====================================================================--
--== Imports


local Objects = require 'dmc_objects'
local uiConst = require( ui_find( 'ui_constants' ) )

local ViewControl = require( ui_find( 'dmc_control.core.view_control' ) )



--====================================================================--
--== Setup, Constants


local newClass = Objects.newClass

local tinsert = table.insert
local tremove = table.remove

local LOCAL_DEBUG = false

--== To be set in initialize()
local dUI = nil



--====================================================================--
--== Navigation Control Class
--====================================================================--


local NavControl = newClass( ViewControl, {name="Navigation Control"}
)

--== Class Constants

NavControl.ANCHOR = { x=0.5,y=0 }

NavControl.FORWARD = 'forward-direction'
NavControl.REVERSE = 'reverse-direction'

--== Event Constants

NavControl.REMOVED_VIEW = 'removed-view-event'


--======================================================--
-- Start: Setup DMC Objects

function NavControl:__init__( params )
	-- print( "NavControl:__init__" )
	params = params or {}
	if params.transitionTime==nil then params.transitionTime=uiConst.NAVBAR_TRANSITION_TIME end

	self:superCall( '__init__', params )
	--==--

	--== Create Properties ==--

	-- properties stored in Class

	self._animation = nil
	self._animation_dirty=false

	self._enterFrame_f = nil

	self._trans_time = params.transitionTime

	self._views = {} -- slide list, in order

	--== Display Groups ==--

	self._dgBg = nil -- group for background
	self._dgViews = nil -- group for views
	self._dgUI = nil -- group for nav bar

	--== Object References ==--

	self._root_view = nil
	self._back_view = nil
	self._top_view = nil
	self._new_view = nil
	self._visible_view = nil

	self._primer = nil
	self._navBar = nil

end

function NavControl:__undoInit__()
	--print( "NavControl:__undoInit__" )
	self._root_view = nil
	self._back_view = nil
	self._top_view = nil
	self._new_view = nil
	self._visible_view = nil

	--==--
	self:superCall( '__undoInit__' )
end


function NavControl:__createView__()
	-- print( "NavControl:__createView__" )
	self:superCall( '__createView__' )
	--==--
	local ANCHOR = NavControl.ANCHOR
	local W, H = self._width, self._height
	local o, dg  -- object, display group

	--== Setup display layers

	dg = display.newGroup()
	self:insert( dg )
	self._dgBg = dg

	dg = display.newGroup()
	self:insert( dg )
	self._dgViews = dg

	dg = display.newGroup()
	self:insert( dg )
	self._dgUI = dg

	--== Setup display objects

	-- background

	o = display.newRect( 0, 0, W, H )
	o:setFillColor(0,0,0,0)
	if LOCAL_DEBUG then
		o:setFillColor(1,0,0,0.2)
	end
	o.anchorX, o.anchorY = ANCHOR.x, ANCHOR.y

	self._dgBg:insert( o )
	self._primer = o

	-- navbar

	o = dUI.newNavBar{
		delegate = self
	}
	o.anchorX, o.anchorY = ANCHOR.x, ANCHOR.y

	self._dgUI:insert( o.view )
	self._navBar = o

end

function NavControl:__undoCreateView__()
	-- print( "NavControl:__undoCreateView__" )

	self._primer:removeSelf()
	self._primer = nil

	self._dgUI:removeSelf()
	self._dgUI = nil

	self._dgViews:removeSelf()
	self._dgViews = nil

	self._dgBg:removeSelf()
	self._dgBg = nil

	--==--
	self:superCall( '__undoCreateView__' )
end


--== initComplete

--[[
function NavControl:__initComplete__()
	-- print( "NavControl:__initComplete__" )
	self:superCall( '__initComplete__' )
	--==--
end
--]]

function NavControl:__undoInitComplete__()
	-- print( "NavControl:__undoInitComplete__" )
	self:_cleanUp()
	--==--
	self:superCall( '__undoInitComplete__' )
end

-- END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Static Methods


function NavControl.initialize( manager )
	-- print( "NavControl.initialize" )
	dUI = manager
end



--====================================================================--
--== Public Methods


function NavControl:pushView( view, params )
	-- print( "NavControl:pushView" )
	params = params or {}
	assert( view, "[ERROR] NavControl:pushView requires a view object" )
	-- assert( type(item)=='table' and item.isa and item:isa( NavItem ), "pushNavItem: item must be a NavItem" )
	--==--
	if self._enterFrame_f then
		error("[ERROR] Animation already in progress !!!")
	end
	self:_setNextView( view, params ) -- params.animate set here
	self:_gotoNextView( params.animate )
end

function NavControl:popViewAnimated()
	if self._enterFrame_f then
		error("[ERROR] Animation already in progress !!!")
	end
	self:_gotoPrevView( true )
end



--====================================================================--
--== Private Methods


function NavControl:_widthChanged()
	-- print( "NavControl:_widthChanged", self._width )
	local w = self._width
	self._primer.width = w
	self._navBar.width = w
	self:_modifyViews( function( i, v )
		v.__obj.width = w
	end)
end

function NavControl:_heightChanged()
	-- print( "NavControl:_heightChanged", self._height )
	local h = self._height
	self._primer.height = h
	self:_modifyViews( function( i, v )
		v.__obj.height = h
	end)
end


function NavControl:_modifyViews( func )
	local views = self._views
	for i=#views, 1, -1 do func( i, views[i] ) end
end


function NavControl:_cleanUp()
	-- print( "NavControl:_cleanUp" )
	self:_stopEnterFrame()
	self:_removeAllViews()
end


--======================================================--
-- View Methods

function NavControl:_pushStackView( view )
	tinsert( self._views, view )
end

function NavControl:_popStackView( notify )
	return tremove( self._views )
end

function NavControl:_getPreviousView()
	return self._views[ #self._views-1 ]
end

function NavControl:_removeAllViews()
	for i=1, #self._views do
		local view = self:_popStackView()
		self:_removeViewFromNavControl( view )
	end
end


function NavControl:_setNextView( view, params )
	params = params or {}
	if params.animate==nil then params.animate=true end
	--==--
	if not self._root_view then
		-- first view
		self._root_view = view
		self._top_view = nil
		self._visible_view = nil
		params.animate = false
	end
	view.parent = self
	self._new_view = view

	-- support various types of objects
	-- looking around for the View
	local o = view
	if o.view then
		o = o.view
	elseif o.display then
		o = o.display
	end
	view.__view = o
	-- pre-calc who to talk with
	if view.isa then
		-- dmc object
		view.__obj = view
	else
		-- plain Lua obj
		view.__obj = view.__view
	end
	view.__obj.isVisible=false

	self._newViewSet_dirty=true
	self:__invalidateProperties__()
end


function NavControl:_addViewToNavControl( view )
	-- print( "NavControl:_addViewToNavControl", view )
	local f = view.willBeAdded
	if f then f( view ) end

	self._dgViews:insert( view.__view )
end

function NavControl:_removeViewFromNavControl( view )
	-- print( "NavControl:_removeViewFromNavControl", view )
	view.__obj = nil
	view.__view = nil
	view.isVisible=false
	local f = view.willBeRemoved
	if f then f( view ) end

	self:_dispatchRemovedView( view )
end


--======================================================--
-- Animation Methods

function NavControl:_startEnterFrame( func )
	self._enterFrame_f = func
	Runtime:addEventListener( 'enterFrame', func )
end

function NavControl:_stopEnterFrame()
	if not self._enterFrame_f then return end
	Runtime:removeEventListener( 'enterFrame', self._enterFrame_f )
	self._enterFrame_f = nil
end


function NavControl:_startForward( func )
	local start_time = system.getTimer()
	local duration = self._trans_time
	local frw_f -- forward

	frw_f = function(e)
		local delta_t = e.time-start_time
		local perc = delta_t/duration*100
		if perc >= 100 then
			perc = 100
			self:_stopEnterFrame()
		end
		func( perc, true )
	end
	self:_startEnterFrame( frw_f )
end

function NavControl:_startReverse( func )
	local start_time = system.getTimer()
	local duration = self._trans_time
	local rev_f -- forward

	rev_f = function(e)
		local delta_t = e.time-start_time
		local perc = 100-(delta_t/duration*100)
		if perc <= 0 then
			perc = 0
			self:_stopEnterFrame()
		end
		func( perc, true )
	end
	self:_startEnterFrame( rev_f )
end


function NavControl:_gotoNextView( animate )
	-- print( "NavControl:_gotoNextView", animate )
	local func = self:_getNextTrans()

	local animFunc = function()
		if not animate then
			func( 100, animate )
		else
			self:_startForward( func )
		end
	end

	self._animation = animFunc
	self._animation_dirty=true
	self:__invalidateProperties__()
end

function NavControl:_gotoPrevView( animate )
	-- print( "NavControl:_gotoPrevView" )
	local func = self:_getPrevTrans()

	local animFunc = function()
		if not animate then
			func( 0, animate )
		else
			self:_startReverse( func )
		end
	end

	self._animation = animFunc
	self._animation_dirty=true
	self:__invalidateProperties__()
end


--======================================================--
-- Transition Methods

function NavControl:_getNavBarNextTransition( view, params )
	-- print( "NavControl:_getNavBarNextTransition", view )
	params = params or {}
	--==--
	local o = view.navItem
	if not o then
		o = dUI.newNavItem{
			titleText=view.title or "Unknown"
		}
		view.navItem = o
	end
	return self._navBar:pushNavItemGetTransition( o )
end

function NavControl:_getNextTrans()
	-- print( "NavControl:_getNextTrans" )
	local nB_f = self:_getNavBarNextTransition( self._new_view )
	local nC_f = self:_getTransition( self._top_view, self._new_view, self.FORWARD )
	-- make function which wraps both
	return function( percent, animate )
		nB_f( percent, animate )
		nC_f( percent, animate )
	end
end


function NavControl:_getNavBarPrevTransition()
	-- print( "NavControl:_getNavBarPrevTransition" )
	params = params or {}
	--==--
	return self._navBar:popNavItemGetTransition( params )
end

function NavControl:_getPrevTrans()
	-- print( "NavControl:_getPrevTrans" )
	local nB_f = self:_getNavBarPrevTransition()
	local nC_f = self:_getTransition( self._back_view, self._top_view, self.REVERSE )
	-- make function which wraps both
	return function( percent, animate )
		nB_f( percent, animate )
		nC_f( percent, animate )
	end
end


function NavControl:_getTransition( from_view, to_view, direction )
	-- print( "NavControl:_getTransition", from_view, to_view, direction )
	local W, H = self._width, self._height
	local H_CENTER, V_CENTER = W*0.5, H*0.5
	local MARGINS = self.MARGINS

	local animationFunc, notifyInMotion
	local animationHasStarted = false
	local animationIsFinished = false

	local stack = self._views

	if direction==self.FORWARD then
		self:_addViewToNavControl( to_view )
	end

	animationFunc = function( percent, animate )
		-- print( "animationFunc", percent )
		local dec_p = percent/100
		local FROM_X_OFF = H_CENTER/2*dec_p
		local TO_X_OFF = W*dec_p
		local obj = nil

		-- notify views motion has started

		if animate and not animationHasStarted then
			notifyInMotion( true )
			animationHasStarted = true
		end

		if percent==0 then
			--== edge of transition ==--

			if from_view then
				obj = from_view.__obj
				obj.isVisible = true
				obj.x = 0
			end

			if to_view then
				obj = to_view.__obj
				obj.isVisible = false
			end

			--== Finish up

			if animate and animationHasStarted then
				animationIsFinished = true
				notifyInMotion( false )
			end
			--[[
			if not animate then
				-- we jumped here without going through middle of trans
			end
			--]]

			if direction==self.REVERSE then

				local f
				if from_view then
					f = from_view.viewDidAppear
					if f then f( from_view ) end
				end
				if to_view then
					f = to_view.viewDidDisappear
					if f then f( to_view ) end
				end

				local view = self:_popStackView()
				self:_removeViewFromNavControl( view )

				self._top_view = from_view
				self._new_view = nil
				self._back_view = self:_getPreviousView()
			end


		elseif percent==100 then
			--== edge of transition ==--

			if animate and animationHasStarted then
				animationIsFinished = true
				notifyInMotion( false )
			end
			--[[
			if not animate then
				-- we jumped here without going through middle of trans
			end
			--]]

			if to_view then
				obj = to_view.__obj
				obj.isVisible = true
				obj.x = 0
			end

			if from_view then
				obj = from_view.__obj
				obj.isVisible = false
				obj.x = 0-FROM_X_OFF
			end

			--== Finish up

			if direction==self.FORWARD then

				self._back_view = from_view
				self._new_view = nil
				self._top_view = to_view

				local f
				if from_view then
					f = from_view.viewDidDisappear
					if f then f( from_view ) end
				end
				if to_view then
					f = to_view.viewDidAppear
					if f then f( to_view ) end
				end

				self:_pushStackView( to_view )
			end


		else
			--== middle of transition ==--

			if to_view then
				obj = to_view.__obj
				obj.isVisible = true
				obj.x = W-TO_X_OFF
			end

			if from_view then
				obj = from_view.__obj
				obj.isVisible = true
				obj.x = 0-FROM_X_OFF
			end

		end

	end

	notifyInMotion = function( value )
		if from_view then
			f = from_view.viewInMotion
			if f then f( from_view, value ) end
		end
		if to_view then
			f = to_view.viewInMotion
			if f then f( to_view, value ) end
		end
	end

	return animationFunc
end


--======================================================--
-- DMC Lifecycle Methods

function NavControl:__commitProperties__()
	-- print( 'NavControl:__commitProperties__' )

	--== Update Widget Components ==--

	if self._newViewSet_dirty then
		local w, h = self._width, self._height
		local ANCHOR = NavControl.ANCHOR
		local nb_height = self._navBar.height
		local view_height = h - nb_height
		local view1 = self._new_view
		local obj
		if view1 then
			obj = view1.__obj
			obj.height = view_height
			obj.width = w
			obj.y = nb_height
			obj.anchorX, obj.anchorY = ANCHOR.x, ANCHOR.y
		end
		self._newViewSet_dirty=true
	end

	if self._animation_dirty then
		self._animation()
		self._animation_dirty=false
	end
end


--======================================================--
-- NavBar Delegate Methods

function NavControl:shouldPushItem( navBar, navItem )
	-- print( "NavControl:shouldPushItem" )
	return true
end

function NavControl:didPushItem( navBar, navItem )
	-- print( "NavControl:didPushItem" )
end

function NavControl:shouldPopItem( navBar, navItem )
	-- print( "NavControl:shouldPopItem" )
	self:popViewAnimated()
	return false
end

function NavControl:didPopItem( navBar, navItem )
	-- print( "NavControl:didPopItem" )
end


--======================================================--
-- Misc Methods

function NavControl:_dispatchRemovedView( view )
	-- print( "NavControl:_dispatchRemovedView", view )
	self:dispatchEvent( self.REMOVED_VIEW, {view=view}, {merge=true} )
end



--====================================================================--
--== Event Handlers


-- none



return NavControl
