--====================================================================--
-- dmc_widgets/widget_background.lua
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
--== DMC Corona Widgets : Widget Background
--====================================================================--


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.1.0"



--====================================================================--
--== DMC Widgets Setup
--====================================================================--


local dmc_widget_data = _G.__dmc_widget
local dmc_widget_func = dmc_widget_data.func
local widget_find = dmc_widget_func.find



--====================================================================--
--== DMC Widgets : newBackground
--====================================================================--



--====================================================================--
--== Imports


local Objects = require 'dmc_objects'
local LifecycleMixModule = require 'dmc_lifecycle_mix'
local StyleMixModule = require( widget_find( 'widget_style_mix' ) )

--== To be set in initialize()
local Widgets = nil
local ThemeMgr = nil
local ViewFactory = nil



--====================================================================--
--== Setup, Constants


local newClass = Objects.newClass
local ComponentBase = Objects.ComponentBase

local LifecycleMix = LifecycleMixModule.LifecycleMix
local StyleMix = StyleMixModule.StyleMix



--====================================================================--
--== Background Widget Class
--====================================================================--


-- ! put StyleMix first !

local Background = newClass(
	{ StyleMix, ComponentBase, LifecycleMix },
	{name="Background Widget"}
)

--== Theme Constants

Background.THEME_ID = 'background'
Background.STYLE_CLASS = nil -- added later

-- TODO: hook up later
-- Background.DEFAULT = 'default'

-- Background.THEME_STATES = {
-- 	Background.DEFAULT,
-- }

--== Event Constants

Background.EVENT = 'background-widget-event'

Background.PRESSED = 'touch-press-event'
Background.RELEASED = 'touch-release-event'


--======================================================--
-- Start: Setup DMC Objects

--== Init

function Background:__init__( params )
	-- print( "Background:__init__", params )
	params = params or {}
	if params.x==nil then params.x=0 end
	if params.y==nil then params.y=0 end

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

	-- properties stored in Style

	self._debugOn_dirty=true
	self._width_dirty=true
	self._height_dirty=true
	self._anchorX_dirty=true
	self._anchorY_dirty=true

	-- "Virtual" properties

	self._wgtViewStyle_dirty=true

	--== Object References ==--

	self._tmp_style = params.style -- save later

	self._wgtView = nil -- background view
	self._wgtView_dirty=true

end

function Background:__undoInit__()
	-- print( "Background:__undoInit__" )
	--==--
	self:superCall( StyleMix, '__undoInit__' )
	self:superCall( ComponentBase, '__undoInit__' )
	self:superCall( LifecycleMix, '__undoInit__' )
end


--[[
--== createView

function Background:__createView__()
	-- print( "Background:__createView__" )
	self:superCall( ComponentBase, '__createView__' )
	--==--
end

function Background:__undoCreateView__()
	-- print( "Background:__undoCreateView__" )
	--==--
	self:superCall( ComponentBase, '__undoCreateView__' )
end
--]]


--== initComplete

function Background:__initComplete__()
	-- print( "Background:__initComplete__" )
	self:superCall( ComponentBase, '__initComplete__' )
	--==--
	self.style = self._tmp_style
end

function Background:__undoInitComplete__()
	--print( "Background:__undoInitComplete__" )
	self:_removeBackground()
	self.style = nil
	--==--
	self:superCall( ComponentBase, '__undoInitComplete__' )
end

-- END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Static Methods


function Background.initialize( manager )
	-- print( "Background.initialize" )
	Widgets = manager
	ThemeMgr = Widgets.ThemeMgr
	Background.STYLE_CLASS = Widgets.Style.Background

	ViewFactory = Widgets.BackgroundFactory

	ThemeMgr:registerWidget( Background.THEME_ID, Background )
end



--====================================================================--
--== Public Methods


--======================================================--
-- Local Properties

-- .X
--
function Background.__getters:x()
	return self._x
end
function Background.__setters:x( value )
	-- print( "Background.__setters:x", value )
	assert( type(value)=='number' )
	--==--
	self._x = value
	self._x_dirty=true
	self:__invalidateProperties__()
end

-- .Y
--
function Background.__getters:y()
	return self._y
end
function Background.__setters:y( value )
	-- print( "Background.__setters:y", value )
	assert( type(value)=='number' )
	--==--
	self._y = value
	self._y_dirty=true
	self:__invalidateProperties__()
end


--======================================================--
--== View Style Properties

--== cornerRadius

function Background.__getters:cornerRadius()
	return self.curr_style.view.cornerRadius
end
function Background.__setters:cornerRadius( value )
	-- print( 'Background.__setters:cornerRadius', value )
	self.curr_style.view.cornerRadius = value
end

--== viewStrokeWidth

function Background.__getters:viewStrokeWidth()
	return self.curr_style.view.strokeWidth
end
function Background.__setters:viewStrokeWidth( value )
	-- print( "Background.__setters:viewStrokeWidth", value )
	self.curr_style.view.strokeWidth = value
end

--== setViewFillColor

function Background:setViewFillColor( ... )
	-- print( "Background:setViewFillColor" )
	self.curr_style.view.fillColor = {...}
end

--== setViewStrokeColor

function Background:setViewStrokeColor( ... )
	-- print( "Background:setViewStrokeColor" )
	self.curr_style.view.strokeColor = {...}
end


--======================================================--
--== Theme Mix Methods

function Background:afterAddStyle()
	-- print( "Background:afterAddStyle" )
	self._wgtViewStyle_dirty=true
	self:__invalidateProperties__()
end


function Background:beforeRemoveStyle()
	-- print( "Background:beforeRemoveStyle" )
	self._wgtViewStyle_dirty=true
	self:__invalidateProperties__()
end



--====================================================================--
--== Private Methods


function Background:_removeBackground()
	-- print( "Background:_removeBackground" )
	local o = self._wgtView
	if not o then return end
	o.style = nil
	o:removeSelf()
	self._wgtView = nil
end

function Background:_createBackgroundView()
	-- print( "Background:_createBackgroundView" )
	local style = self.curr_style
	local vtype = style.view.type
	local o = self._wgtView

	-- create background if missing or type mismatch
	if not o or vtype ~= o.TYPE then
		self:_removeBackground()
		o = ViewFactory.create( vtype )
		self:insert( o.view )
	end

	o:setActiveStyle( style.view, {copy=false} )
	self._wgtView = o

	--== Reset properties

	-- none
end


function Background:__commitProperties__()
	-- print( "Background:__commitProperties__" )

	--== Update Widget Components

	if self._wgtView_dirty or self._wgtViewStyle_dirty then
		self:_createBackgroundView()
		self._wgtView_dirty=false
		self._wgtViewStyle_dirty=false
	end

	--== Update Widget View

	local style = self.curr_style
	local view = self.view
	local bg = self._wgtView

	-- x/y

	if self._x_dirty then
		view.x = self._x
		self._x_dirty = false
	end
	if self._y_dirty then
		view.y = self._y
		self._y_dirty = false
	end

end



--====================================================================--
--== Event Handlers


function Background:stylePropertyChangeHandler( event )
	-- print( "Background:stylePropertyChangeHandler", event.type, event.property )
	local style = event.target
	local etype= event.type
	local property= event.property
	local value = event.value

	-- print( "Style Changed", etype, property, value )

	if etype==style.STYLE_RESET or etype==style.STYLE_CLEARED then
		self._debugOn_dirty=true
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




return Background
