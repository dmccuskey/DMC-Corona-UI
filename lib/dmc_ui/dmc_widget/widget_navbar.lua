--====================================================================--
-- dmc_widget/widget_navbar.lua
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
--== DMC Corona UI : NavBar Widget
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
--== DMC UI : newNavBar
--====================================================================--



--====================================================================--
--== Imports


local LifecycleMixModule = require 'dmc_lifecycle_mix'
local Objects = require 'dmc_objects'
local StyleMixModule = require( ui_find( 'dmc_style.style_mix' ) )
local uiConst = require( ui_find( 'ui_constants' ) )



--====================================================================--
--== Setup, Constants


local newClass = Objects.newClass
local ComponentBase = Objects.ComponentBase

local LifecycleMix = LifecycleMixModule.LifecycleMix
local StyleMix = StyleMixModule.StyleMix

local tinsert = table.insert
local tremove = table.remove

--== To be set in initialize()
local dUI = nil
local Widget = nil



--====================================================================--
--== Nav Bar Widget Class
--====================================================================--


-- ! put StyleMix first !

local NavBar = newClass(
	{ StyleMix, ComponentBase, LifecycleMix }, {name="Nav Bar Widget"}
)
--== Class Constants

NavBar.FORWARD = 'forward-trans'
NavBar.REVERSE = 'reverse-trans'
NavBar.TRANSITION_TIME = 400

--== Style/Theme Constants

NavBar.STYLE_CLASS = nil -- added later
NavBar.STYLE_TYPE = uiConst.NAVBAR

--== Event Constants

NavBar.EVENT = 'button-event'
NavBar.BACK_BUTTON = 'back-button-released-event'


--======================================================--
-- Start: Setup DMC Objects

--== Init

function NavBar:__init__( params )
	-- print( "NavBar:__init__" )
	params = params or {}
	if params.x==nil then params.x=0 end
	if params.y==nil then params.y=0 end
	if params.transitionTime==nil then params.transitionTime=NavBar.TRANSITION_TIME end

	self:superCall( LifecycleMix, '__init__', params )
	self:superCall( ComponentBase, '__init__', params )
	self:superCall( StyleMix, '__init__', params )
	--==--

	--== Create Properties ==--

	-- properties stored in Class

	self._x = params.x
	self._x_dirty=true
	self._y = params.y
	self._y_dirty=true

	self._trans_time = params.transitionTime
	self._items = {} -- stack of nav items

	self._animation = nil
	self._animation_dirty=false

	self._enterFrame_f = nil

	-- properties stored in Style

	self._debugOn_dirty=true
	self._width_dirty=true
	self._height_dirty=true
	self._anchorX_dirty=true
	self._anchorY_dirty=true

	-- "Virtual" properties

	self._widgetStyle_dirty=true
	self._wgtBgStyle_dirty=true

	--== Object References ==--

	self._tmp_style = params.style -- save

	self._delegate = params.delegate

	self._dgBg = nil -- main group, for background
	self._dgMain = nil -- main group, for buttons, etc

	-- references to Nav Items
	self._root_item = nil
	self._back_item = nil
	self._top_item = nil
	self._new_item = nil

	self._wgtBg = nil -- background widget
	self._wgtBg_dirty=true

	self._rctHit = nil  -- background touch object

end

function NavBar:__undoInit__()
	-- print( "NavBar:__undoInit__" )
	self._root_item = nil
	self._back_item = nil
	self._top_item = nil
	self._new_item = nil
	--==--
	self:superCall( StyleMix, '__undoInit__' )
	self:superCall( ComponentBase, '__undoInit__' )
	self:superCall( LifecycleMix, '__undoInit__' )
end


--== createView

function NavBar:__createView__()
	-- print( "NavBar:__createView__" )
	self:superCall( '__createView__' )
	--==--
	local o = display.newRect( 0,0,0,0 )
	o.isHitTestable = true
	o.anchorX, o.anchorY = 0.5,0.5
	self.view:insert( o ) -- using view because of override
	self._rctHit = o

	o = display.newGroup()
	self.view:insert( o ) -- using view because of override
	self._dgBg = o

	o = display.newGroup()
	self.view:insert( o ) -- using view because of override
	self._dgMain = o

end

function NavBar:__undoCreateView__()
	-- print( "NavBar:__undoCreateView__" )
	self._rctHit:removeSelf()
	self._rctHit=nil
	--==--
	self:superCall( '__undoCreateView__' )
end


--== initComplete

function NavBar:__initComplete__()
	-- print( "NavBar:__initComplete__" )
	self:superCall( StyleMix, '__initComplete__' )
	self:superCall( ComponentBase, '__initComplete__' )
	--==--
	self.style = self._tmp_style
	self:setTouchBlock( self._rctHit )

	self._back_f = self:createCallback( self._backButtonEvent_handler )

end

function NavBar:__undoInitComplete__()
	-- print( "NavBar:__undoInitComplete__" )
	self:unsetTouchBlock( self._rctHit )
	self.style = nil
	--==--
	self:superCall( ComponentBase, '__undoInitComplete__' )
	self:superCall( StyleMix, '__undoInitComplete__' )
end

-- END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Static Methods


function NavBar.initialize( manager )
	-- print( "NavBar.initialize" )
	dUI = manager
	Widget = dUI.Widget

	local Style = dUI.Style
	NavBar.STYLE_CLASS = Style.NavBar

	Style.registerWidget( NavBar )
end



--====================================================================--
--== Public Methods


--======================================================--
-- Local Properties

--== .X

function NavBar.__getters:x()
	return self._x
end
function NavBar.__setters:x( value )
	-- print( "NavBar.__setters:x", value )
	assert( type(value)=='number' )
	--==--
	if self._x == value then return end
	self._x = value
	self._x_dirty=true
	self:__invalidateProperties__()
end

--== .Y

function NavBar.__getters:y()
	return self._y
end
function NavBar.__setters:y( value )
	-- print( "NavBar.__setters:y", value )
	assert( type(value)=='number' )
	--==--
	if self._y == value then return end
	self._y = value
	self._y_dirty=true
	self:__invalidateProperties__()
end


--======================================================--
-- Nav Bar Methods

function NavBar.__setters:delegate( obj )
	-- print( "NavBar.__setters:delegate", obj )
	self._delegate = obj
end


function NavBar:pushNavItem( item, params )
	-- print( "NavBar:pushNavItem", item )
	params = params or {}
	assert( type(item)=='table' and item.isa and item:isa( Widget.NavItem ), "pushNavItem: item must be a NavItem" )
	--==--
	if self._enterFrame_f then
		error("[ERROR] Animation already in progress !!!")
	end
	self:_setNextItem( item, params ) -- params.animate set here
	self:_gotoNextItem( params.animate )
end

function NavBar:popNavItemAnimated()
	-- print( "NavBar:popNavItemAnimated" )
	if self._enterFrame_f then
		error("[ERROR] Animation already in progress !!!")
	end
	self:_gotoPrevItem( true )
end


--== methods used by dUI.NavigationControl

function NavBar:pushNavItemGetTransition( item, params )
	self:_setNextItem( item, params )
	return self:_getNextTrans()
end

function NavBar:popNavItemGetTransition()
	return self:_getPrevTrans()
end



--======================================================--
-- Theme Methods

-- afterAddStyle()
--
function NavBar:afterAddStyle()
	-- print( "NavBar:afterAddStyle", self )
	self._widgetStyle_dirty=true
	self:__invalidateProperties__()
end

-- beforeRemoveStyle()
--
function NavBar:beforeRemoveStyle()
	-- print( "NavBar:beforeRemoveStyle", self )
	self._widgetStyle_dirty=true
	self:__invalidateProperties__()
end



--====================================================================--
--== Private Methods


--======================================================--
-- Item Methods

function NavBar:_pushStackItem( item )
	-- print("NavBar:_pushStackItem", #self._items )
	tinsert( self._items, item )
end

function NavBar:_popStackItem( notify )
	-- print("NavBar:_popStackItem", #self._items )
	return tremove( self._items )
end

function NavBar:_getPreviousItem()
	return self._items[ #self._items-1 ]
end


function NavBar:_setNextItem( item, params )
	params = params or {}
	if params.animate==nil then params.animate=true end
	--==--
	if not self._root_item then
		-- first item added to NavBar
		self._root_item = item
		self._top_item = nil
		params.animate = false
	end
	self._new_item = item

	self._newItemSet_dirty=true
	self:__invalidateProperties__()
end


function NavBar:_addItemToNavBar( item )
	-- print( "NavBar:_addItemToNavBar", item )
	local dg = self._dgMain
	local o

	o = item.title
	if o then
		dg:insert( o.view )
		o.isVisible=false
	end
	o = item.backButton
	if o then
		dg:insert( o.view )
		o.isVisible=false
	end
	o = item.leftButton
	if o then
		dg:insert( o.view )
		o.isVisible=false
	end
	o = item.rightButton
	if o then
		dg:insert( o.view )
		o.isVisible=false
	end

end

function NavBar:_removeItemFromNavBar( item )
	-- print( "NavBar:_removeItemFromNavBar", item )
	if item.removeSelf then item:removeSelf() end
end


--======================================================--
-- Animation Methods

function NavBar:_startEnterFrame( func )
	self._enterFrame_f = func
	Runtime:addEventListener( 'enterFrame', func )
end

function NavBar:_stopEnterFrame()
	if not self._enterFrame_f then return end
	Runtime:removeEventListener( 'enterFrame', self._enterFrame_f )
	self._enterFrame_f = nil
end


function NavBar:_startForward( func )
	local start_time = system.getTimer()
	local duration = self._trans_time
	local frw_f -- forward

	frw_f = function(e)
		local delta_t = e.time-start_time
		local perc = delta_t/duration*100
		if perc > 100 then
			perc = 100
			self:_stopEnterFrame()
		end
		func( perc, true )
	end
	self:_startEnterFrame( frw_f )
end

function NavBar:_startReverse( func )
	local start_time = system.getTimer()
	local duration = self._trans_time
	local rev_f -- forward

	rev_f = function(e)
		local delta_t = e.time-start_time
		local perc = 100-(delta_t/duration*100)
		if perc < 0 then
			perc = 0
			self:_stopEnterFrame()
		end
		func( perc, true )
	end
	self:_startEnterFrame( rev_f )
end


function NavBar:_gotoNextItem( animate )
	-- print( "NavBar:_gotoNextItem" )
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

function NavBar:_gotoPrevItem( animate )
	-- print( "NavBar:_gotoPrevItem" )
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

function NavBar:_getNextTrans()
	-- print( "NavBar:_getNextTrans" )
	return self:_getTransition( self._top_item, self._new_item, self.FORWARD )
end

function NavBar:_getPrevTrans()
	-- print( "NavBar:_getPrevTrans" )
	return self:_getTransition( self._back_item, self._top_item, self.REVERSE )
end


function NavBar:_getTransition( from_item, to_item, direction )
	-- print( "NavBar:_getTransition", from_item, to_item, direction )
	local style = self.curr_style
	local W, H = style.width, style.height
	local H_CENTER, V_CENTER = W*0.5, H*0.5
	local MARGINS = {x=5,y=0}
	local isAtEdge = true -- if we're at the start/edge of our transition

	-- display(left/back), back, left, title, right
	local f_d, f_b, f_l, f_t, f_r
	local fHasLeft=false
	local t_d, t_b, t_l, t_t, t_r
	local tHasLeft=false

	local animationFunc
	local animationHasStarted = false
	local animationIsFinished = false

	-- setup from_item vars
	if from_item then
		f_b, f_l, f_r = from_item.backButton, from_item.leftButton, from_item.rightButton
		f_t = from_item.title
		f_d = f_b
		if f_l then
			fHasLeft=true
			f_b.isVisible = false
			f_d = f_l
		end
	end

	-- setup to_item vars
	if to_item then
		t_b, t_l, t_r = to_item.backButton, to_item.leftButton, to_item.rightButton
		t_t = to_item.title
		t_d = t_b
		if t_l then
			tHasLeft=true
			t_b.isVisible=false
			t_d = t_l
		end
	end

	-- calcs for showing left/back buttons
	local stack_offset = 0
	if direction==self.FORWARD then
		self:_addItemToNavBar( to_item )
		stack_offset = 0
	else
		stack_offset = 1
	end

	local stack_size = #self._items
	local anchorX, anchorY = style.anchorX, style.anchorY
	local mX_OFF = W*(0.5-anchorX) -- master offset

	animationFunc = function( percent, animate )
		-- print( "NavBar:transition", percent )
		local dec_p = percent/100
		local from_a, to_a = 1-dec_p, dec_p

		local aX_OFF = H_CENTER*dec_p -- animation offset

		if animate and not animationHasStarted then
			-- TODO: unattach current listener
			animationHasStarted = true
		end

		if percent==0 then
			--== edge of transition ==--

			--[[
			if not animate then
				-- we jumped here without going through middle of trans
			end
			--]]

			--== Finish up

			if direction==self.REVERSE then
				--popstack has to be before #self._items check below

				local item = self:_popStackItem()
				self:_removeItemFromNavBar( item )

				self._top_item = from_item
				self._new_item = nil
				self._back_item = self:_getPreviousItem()

				if to_item then
					self:_detachBackListener( to_item.backButton )
				end
				if from_item then
					self:_attachBackListener( from_item.backButton )
				end


			--== Left/Back

			if t_d then
				t_d.isVisible = false
			end

			if fHasLeft or #self._items>1 then
				f_d.isVisible = true
				f_d.x = mX_OFF-H_CENTER+MARGINS.x
				f_d.alpha = 1
			else
				f_d.isVisible = false
			end

			--== Title

			if t_t then
				t_t.isVisible = false
			end

			if f_t then
				f_t.isVisible = true
				f_t.x = mX_OFF
				f_t.alpha = 1
			end

			--== Right

			if t_r then
				t_r.isVisible = false
			end

			if f_r then
				f_r.isVisible = true
				f_r.x = mX_OFF+H_CENTER
				f_r.alpha = 1
			end


			end


		elseif percent==100 then
			--== edge of transition ==--

			if animate and animationHasStarted then
				animationIsFinished = true
			end
			--[[
			if not animate then
				-- we jumped here without going through middle of trans
			end
			--]]

			--== Left/Back

			-- checking if Left exists or Stack, still use t_d
			if tHasLeft or stack_size>0 then
				t_d.x = mX_OFF-H_CENTER+MARGINS.x
				t_d.isVisible = true
				t_d.alpha = 1
				-- attach listener
			else
				t_d.isVisible = false
			end

			if f_d then
				f_d.isVisible = false
			end

			--== Title

			if t_t then
				t_t.x = mX_OFF
				t_t.isVisible = true
				t_t.alpha = 1
			end

			if f_t then
				f_t.isVisible = false
			end

			--== Right

			if t_r then
				t_r.x = mX_OFF+H_CENTER-MARGINS.x
				t_r.isVisible = true
				t_r.alpha = 1
			end

			if f_r then
				f_r.isVisible = false
			end

			--== Finish up

			if direction==self.FORWARD then

				self._back_item = from_item
				self._new_item = nil
				self._top_item = to_item

				if from_item then
					self:_detachBackListener( from_item.backButton )
				end
				if to_item then
					self:_attachBackListener( to_item.backButton )
				end

				self:_pushStackItem( to_item )
			end


		else
			--== middle of transition ==--

			--== Left/Back

			if tHasLeft or stack_size>(0+stack_offset) then
				t_d.isVisible = true
				t_d.x = mX_OFF-aX_OFF+MARGINS.x
				t_d.alpha = to_a
			else
				t_d.isVisible = false
			end

			if fHasLeft or stack_size>(1+stack_offset) then
				f_d.isVisible = true
				f_d.x = mX_OFF-H_CENTER-aX_OFF+MARGINS.x
				f_d.alpha = from_a
			else
				f_d.isVisible = false
			end

			--== Title

			if t_t then
				t_t.isVisible = true
				-- t_t.x, t_t.y = H_CENTER-X_OFF, V_CENTER
				t_t.x = mX_OFF+H_CENTER-aX_OFF
				t_t.alpha = to_a
			end
			if f_t then
				f_t.isVisible = true
				f_t.x = mX_OFF-aX_OFF
				f_t.alpha = from_a
			end

			--== Right

			if t_r then
				t_r.isVisible = true
				t_r.x = mX_OFF+W-aX_OFF
				t_r.alpha = to_a
			end

			if f_r then
				f_r.isVisible = true
				f_r.x = mX_OFF+H_CENTER-aX_OFF
				f_r.alpha = from_a
			end

		end
	end

	return animationFunc
end


--======================================================--
-- DMC Lifecycle Methods

--== Create/Destroy Background Widget

function NavBar:_removeBackground()
	-- print( "NavBar:_removeBackground" )
	local o = self._wgtBg
	if not o then return end
	o:removeSelf()
	self._wgtBg = nil
end

function NavBar:_createBackground()
	-- print( "NavBar:_createBackground" )

	self:_removeBackground()
	local dg = self._dgBg

	local o = Widget.newBackground()
	dg:insert( o.view )
	self._wgtBg = o

	--== Reset properties

	self._wgtBgStyle_dirty=true
end


function NavBar:__commitProperties__()
	-- print( 'NavBar:__commitProperties__' )

	--== Update Widget Components ==--

	if self._wgtBg_dirty then
		self:_createBackground()
		self._wgtBg_dirty = false
	end

	--== Update Widget View ==--

	local style = self.curr_style
	local view = self.view
	local hit = self._rctHit
	local bg = self._wgtBg

	-- x/y

	if self._x_dirty then
		view.x = self._x
		self._x_dirty=false
	end
	if self._y_dirty then
		view.y = self._y
		self._y_dirty=false
	end

	-- width/height

	if self._width_dirty then
		local width = style.width
		hit.width = width
		self._width_dirty=false
	end
	if self._height_dirty then
		local height = style.height
		hit.height = height
		self._height_dirty=false
	end

	-- anchorX/anchorY

	if self._anchorX_dirty then
		hit.anchorX = style.anchorX
		self._anchorX_dirty = false

		self._stackItemsAnchors_dirty=true
	end
	if self._anchorY_dirty then
		hit.anchorY = style.anchorY
		self._anchorY_dirty = false

		self._stackItemsAnchors_dirty=true
	end

	--== Virtual

	if self._widgetStyle_dirty then
		self._widgetStyle_dirty=false

		self._wgtBgStyle_dirty=true
	end

	--== Set Styles

	if self._wgtBgStyle_dirty then
		bg:setActiveStyle( style.background, {copy=false} )
		self._wgtBgStyle_dirty=false
	end

	-- debug on

	if self._debugOn_dirty then
		if style.debugOn==true then
			hit:setFillColor( 1,1,0,0.3 )
		else
			hit:setFillColor( 0,0,0,0 )
		end
		self._debugOn_dirty=false
	end


	if self._stackItemsAnchors_dirty then
		-- TODO: if anchor changes while view is set
		-- will this ever happen ?
		self._stackItemsAnchors_dirty=false
	end

	if self._newItemSet_dirty then
		local anchorX, anchorY = style.anchorX, style.anchorY
		local item = self._new_item
		local o
		o = item.title
		if o then
			o.y = 0
			o.anchorX, o.anchorY = 0.5, anchorY
		end
		o = item.backButton
		if o then
			o.y = 0
			o.anchorX, o.anchorY = 0, anchorY
		end
		o = item.leftButton
		if o then
			o.y = 0
			o.anchorX, o.anchorY = 0, anchorY
		end
		o = item.rightButton
		if o then
			o.y = 0
			o.anchorX, o.anchorY = 0, anchorY
		end
		self._newItemSet_dirty=false
	end

	if self._animation_dirty then
		self._animation()
	end

end


--======================================================--
-- Misc Methods

function NavBar:_attachBackListener( back )
	-- print( "NavBar:_attachBackListener" )
	if not back then return end
	back:addEventListener( back.EVENT, self._back_f )
end

function NavBar:_detachBackListener( back )
	-- print( "NavBar:_detachBackListener" )
	if not back then return end
	back:removeEventListener( back.EVENT, self._back_f )
end



--====================================================================--
--== Event Handlers


function NavBar:_backButtonEvent_handler( event )
	-- print( "NavBar:_backButtonEvent_handler", event.property, event.value )
	local target = event.target
	local phase = event.phase
	local del = self._delegate

	if phase==target.RELEASED then
		local f
		local shouldPopItem = true
		f = del and del.shouldPopItem
		if f then shouldPopItem = f( del, self, self._top_item ) end

		if shouldPopItem then
			self:popNavItemAnimated()
		end

		f = del and del.didPopItem
		if f then f( del, self, self._top_item ) end

		self:dispatchEvent( NavBar.BACK_BUTTON )
	end
end


function NavBar:stylePropertyChangeHandler( event )
	-- print( "NavBar:stylePropertyChangeHandler", event.property, event.value )
	local style = event.target
	local etype= event.type
	local property= event.property
	local value = event.value

	-- Utils.print( event )

	-- print( "Style Changed", etype, property, value )

	if etype==style.STYLE_RESET then
		self._debugOn_dirty = true
		self._width_dirty=true
		self._height_dirty=true
		self._anchorX_dirty=true
		self._anchorY_dirty=true

		property = etype

	else
		if property=='debugActive' then
			self._debugOn_dirty=true
		elseif property=='width' then
			self._width_dirty=true
		elseif property=='height' then
			self._height_dirty=true
		elseif property=='anchorX' then
			self._anchorX_dirty=true
		elseif property=='anchorY' then
			self._anchorY_dirty=true
		end

	end

	self:__invalidateProperties__()
	self:__dispatchInvalidateNotification__( property, value )
end



return NavBar
