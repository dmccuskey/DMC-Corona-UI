--====================================================================--
-- dmc_ui/dmc_widget/widget_background.lua
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
--== DMC Corona UI : Background Widget
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
--== DMC UI : newBackground
--====================================================================--



--====================================================================--
--== Imports


local Objects = require 'dmc_objects'

local uiConst = require( ui_find( 'ui_constants' ) )

local WidgetBase = require( ui_find( 'core.widget' ) )



--====================================================================--
--== Setup, Constants


local newClass = Objects.newClass

--== To be set in initialize()
local dUI = nil
local ViewFactory = nil



--====================================================================--
--== Background Widget Class
--====================================================================--


--- Background Widget Module.
-- a background widget is a graphical element, normally used as a background. the background graphics can be from a Shape, Image, 9-Slice.
--
-- @classmod Widget.Background
-- @usage
-- local dUI = require 'dmc_ui'
-- local widget = dUI.newBackground()

local Background = newClass( WidgetBase, { name="Background Widget" } )

--- Class Constants
--
-- @section class-constants

--== Style/Theme Constants

Background.STYLE_CLASS = nil -- added later
Background.STYLE_TYPE = uiConst.BACKGROUND

Background._DEFAULT_VIEWTYPE = uiConst.DEFAULT_BACKGROUND_TYPE

-- TODO: hook up later
-- Background.DEFAULT = 'default'

-- Background.THEME_STATES = {
-- 	Background.DEFAULT,
-- }



--======================================================--
-- Start: Setup DMC Objects

--== Init

function Background:__init__( params )
	-- print( "Background:__init__", params )
	params = params or {}
	if params.x==nil then params.x=0 end
	if params.y==nil then params.y=0 end
	if params.viewType==nil then params.viewType=uiConst._DEFAULT_VIEWTYPE end

	self:superCall( '__init__', params )
	--==--

	--== Create Properties ==--

	-- properties stored in Class

	self._viewType = params.viewType -- default style type
	params.style = self:_createDefaultStyleParams( params.viewType, params.style )

	-- "Virtual" properties

	self._wgtViewStyle_dirty=true

	--== Object References ==--

	self._wgtView = nil -- background view
	self._wgtView_dirty=true

end

--[[
function Background:__undoInit__()
	-- print( "Background:__undoInit__" )
	--==--
	self:superCall( '__undoInit__' )
end
--]]


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

--[[
function Background:__initComplete__()
	-- print( "Background:__initComplete__" )
	self:superCall( '__initComplete__' )
	--==--
end
--]]

function Background:__undoInitComplete__()
	--print( "Background:__undoInitComplete__" )
	self:_removeBackground()
	--==--
	self:superCall( '__undoInitComplete__' )
end

-- END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Static Methods


function Background.initialize( manager )
	-- print( "Background.initialize" )
	dUI = manager

	ViewFactory = dUI.Widget.BackgroundFactory

	local Style = dUI.Style
	Background.STYLE_CLASS = Style.Background -- <<<<

	Style.registerWidget( Background )
end



--====================================================================--
--== Public Methods

--[[
Inherited
--]]

--- set/get x position.
--
-- @within Properties
-- @function .x
-- @usage widget.x = 5
-- @usage print( widget.x )

--- set/get y position.
--
-- @within Properties
-- @function .y
-- @usage widget.y = 5
-- @usage print( widget.y )

--- set/get width.
--
-- @within Properties
-- @function .width
-- @usage widget.width = 5
-- @usage print( widget.width )

--- set/get height.
--
-- @within Properties
-- @function .height
-- @usage widget.height = 5
-- @usage print( widget.height )

--- set/get anchorX.
--
-- @within Properties
-- @function .anchorX
-- @usage widget.anchorX = 5
-- @usage print( widget.anchorX )

--- set/get anchorY.
--
-- @within Properties
-- @function .anchorY
-- @usage widget.anchorY = 5
-- @usage print( widget.anchorY )

--- set/get widget style.
-- style can be a style name or a Style Object.
-- Style Object must be appropriate style for Widget, eg style for Background widget comes from dUI.newBackgroundStyle().
-- @within Properties
-- @function .style
-- @usage widget.style = 'widget-home-page'
-- @usage
-- local wStyle = dUI.newBackgroundStyle()
-- widget.style = wStyle


--- clear any local properties on style.
-- convenience method, calls clearProperties() on active style.
--
-- @within Methods
-- @function clearStyle
-- @usage widget:clearStyle()



--======================================================--
-- Local Properties


function Background.__getters:viewStyle()
	return self.curr_style.view
end


--======================================================--
-- Theme Mix Methods

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

function Background:_createDefaultStyleParams( vType, vStyle )
	-- print( "Background:_createDefaultStyleParams", vType )
	if vStyle==nil then
		vStyle = { name=nil }
	end
	vStyle.type = vType
	return vStyle
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
	local vtype = style.type
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

	-- local style = self.curr_style
	local view = self.view
	-- local bg = self._wgtView

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

	if etype==style.STYLE_RESET then
		self._debugOn_dirty=true
		self._width_dirty=true
		self._height_dirty=true
		self._anchorX_dirty=true
		self._anchorY_dirty=true

		self._wgtView_dirty=true
		self._wgtViewStyle_dirty=true

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
		elseif property=='type' then
			self._wgtView_dirty=true
		end

	end

	self:__invalidateProperties__()
	self:__dispatchInvalidateNotification__( property, value )
end




return Background
