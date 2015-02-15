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
local ThemeMixModule = require( dmc_widget_func.find( 'widget_theme_mix' ) )

-- these are set later
local Widgets = nil
local ThemeMgr = nil



--====================================================================--
--== Setup, Constants


local newClass = Objects.newClass
local ComponentBase = Objects.ComponentBase

local LifecycleMix = LifecycleMixModule.LifecycleMix
local ThemeMix = ThemeMixModule.ThemeMix

local LOCAL_DEBUG = true



--====================================================================--
--== Background Widget Class
--====================================================================--


-- put ThemeMix first

local Background = newClass( {ThemeMix,ComponentBase,LifecycleMix}, {name="Background"} )

--== Class Constants

Background.DEFAULT_TEXTCOLOR = {0,0,0,1}
Background.DEFAULT_FILLCOLOR = {0,0,0,0}

Background.RIGHT = 'right'
Background.CENTER = 'center'
Background.LEFT = 'left'

Background.TOP = 'top'
Background.BOTTOM = 'bottom'

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

Background.RELEASE = 'touch-release-event'


--======================================================--
--== Start: Setup DMC Objects

--== Init

function Background:__init__( params )
	-- print( "Background:__init__", params )
	params = params or {}
	if params.x==nil then params.x=0 end
	if params.y==nil then params.y=0 end
	self:superCall( LifecycleMix, '__init__', params )
	self:superCall( ComponentBase, '__init__', params )
	self:superCall( ThemeMix, '__init__', params )
	--==--

	--== Sanity Check ==--

	if self.is_class then return end

	--== Create Properties ==--

	-- propeties in this class
	self._x = params.x
	self._x_dirty = true
	self._y = params.y
	self._y_dirty = true

	-- properties for style
	self._width_dirty=true
	self._height_dirty=true

	self._anchorX_dirty=true
	self._anchorY_dirty=true

	self._fillColor_dirty=true
	self._strokeColor_dirty=true
	self._strokeWidth_dirty=true

	self._isHitTestable_dirty = true


	--== Object References ==--

	self._tmp_style = params.style -- save
	-- self.curr_style -- from inherit

	self._bg = nil -- our background object – rect or image
	self._bg_f = nil
	self._bg_dirty = true

end

function Background:__undoInit__()
	-- print( "Background:__undoInit__" )
	--==--
	self:superCall( ComponentBase, '__undoInit__' )
	self:superCall( ThemeMix, '__undoInit__' )
	self:superCall( LifecycleMix, '__undoInit__' )
end


--== createView
--[[
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

	self._bg_f = self:createCallback( self._backgroundTouch_handler )

	self.style = self._tmp_style
end

function Background:__undoInitComplete__()
	--print( "Background:__undoInitComplete__" )
	self:_removeBackground()

	self.style = nil

	self._bg_f = nil
	--==--
	self:superCall( ComponentBase, '__undoInitComplete__' )
end

--== END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Static Methods


function Background.__setWidgetManager( manager )
	-- print( "Background.__setWidgetManager" )
	Widgets = manager
	ThemeMgr = Widgets.ThemeMgr
	Background.STYLE_CLASS = Widgets.Style.Background

	ThemeMgr:registerWidget( Background.THEME_ID, Background )
end



--====================================================================--
--== Public Methods


--== X

function Background.__getters:x()
	return self._x
end
function Background.__setters:x( value )
	-- print( 'Background.__setters:x', value )
	assert( type(value)=='number' )
	--==--
	self._x = value
	self._x_dirty=true
	self:__invalidateProperties__()
end

--== Y

function Background.__getters:y()
	return self._y
end
function Background.__setters:y( value )
	-- print( 'Background.__setters:y', value )
	assert( type(value)=='number' )
	--==--
	self._y = value
	self._y_dirty=true
	self:__invalidateProperties__()
end



--====================================================================--
--== Private Methods


function Background:_removeBackground()
	-- print( 'Background:_removeBackground' )
	local o = self._bg
	if o then
		o:removeEventListener( 'touch', self._bg_f )
		o:removeSelf()
		self._bg = nil
	end
end

function Background:_createBackground()
	-- print( 'Background:_createBackground' )
	local style = self.curr_style
	local o -- object

	self:_removeBackground()

	local w, h = style.width, style.height

	self._bg = display.newRect( 0,0,w,h )
	self:insert( self._bg )
	self._bg:addEventListener( 'touch', self._bg_f )

	-- conditions for coming in here
	self._bg_dirty = false

	self._height_dirty=false
	self._width_dirty=false

	--== reset our object

	self._x_dirty=true
	self._y_dirty=true

	self._isHitTestable_dirty=true
	self._anchorX_dirty=true
	self._anchorY_dirty=true
	self._fillColor_dirty=true
end


function Background:__commitProperties__()
	-- print( 'Background:__commitProperties__' )
	local style = self.curr_style

	-- create new background if necessary
	if self._bg_dirty then
		self:_createBackground()
	end

	local view = self.view
	local bg = self._bg

	-- width/height

	if self._bg_width_dirty then
		bg.width = self.width
		self._bg_width_dirty=false

		self._text_alignX_dirty=true
	end
	if self._bg_height_dirty then
		bg.height = self.height
		self._bg_height_dirty=false

		self._text_alignY_dirty=true
	end

	-- anchorX/anchorY

	if self._anchorX_dirty then
		bg.anchorX = style.anchorX
		self._anchorX_dirty=false

		self._x_dirty=true
	end
	if self._anchorY_dirty then
		bg.anchorY = style.anchorY
		self._anchorY_dirty=false

		self._y_dirty=true
	end

	-- x/y

	if self._x_dirty then
		view.x = self._x
		self._x_dirty = false
	end
	if self._y_dirty then
		view.y = self._y
		self._y_dirty = false
	end


	--== non-position sensitive

	-- hit testable

	if self._isHitTestable_dirty then
		bg.isHitTestable = style.isHitTestable
		self._isHitTestable_dirty=false
	end

	-- fillColor

	if self._fillColor_dirty then
		bg:setFillColor( unpack( style.fillColor ))
		self._fillColor_dirty=false
	end

	-- strokeColor

	if self._strokeColor_dirty then
		bg:setStrokeColor( unpack( style.strokeColor ))
		self._strokeColor_dirty=false
	end

	-- strokeWidth

	if self._strokeWidth_dirty then
		bg.strokeWidth = style.strokeWidth
		self._strokeWidth_dirty=false
	end

end



--====================================================================--
--== Event Handlers


function Background:stylePropertyChangeHandler( event )
	-- print( "Background:stylePropertyChangeHandler", event )
	local etype= event.type
	local property= event.property
	local value = event.value

	-- print( "Style Changed", etype, property, value )

	if etype=='reset-all' then
		self._width_dirty=true
		self._height_dirty=true

		self._anchorX_dirty=true
		self._anchorY_dirty=true
		self._fillColor_dirty = true
		self._isHitTestable_dirty=true
		self._strokeColor_dirty=true
		self._strokeWidth_dirty=true

		property = etype

	else
		if property=='width' then
			self._width_dirty=true
		elseif property=='height' then
			self._height_dirty=true

		elseif property=='anchorX' then
			self._anchorX_dirty=true
		elseif property=='anchorY' then
			self._anchorY_dirty=true
		elseif property=='fillColor' then
			self._fillColor_dirty=true
		elseif property=='isHitTestable' then
			self._isHitTestable_dirty=true
		elseif property=='strokeWidth' then
			self._strokeWidth_dirty=true
		elseif property=='strokeColor' then
			self._strokeColor_dirty=true
		end

	end

	self:__invalidateProperties__()
	self:__dispatchInvalidateNotification__( property, value )
end


function Background:_backgroundTouch_handler( event )
	-- print( 'Background:_backgroundTouch_handler', event.phase )
	local phase = event.phase
	local background = event.target

	if phase=='began' then
		display.getCurrentStage():setFocus( background )
		self._has_focus = true
	end

	if not self._has_focus then return false end

	if phase=='ended' or phase=='canceled' then
		local bgCb = background.contentBounds
		local isWithinBounds = ( bgCb.xMin <= event.x and bgCb.xMax >= event.x and bgCb.yMin <= event.y and bgCb.yMax >= event.y )
		if isWithinBounds then
			self:dispatchEvent( self.RELEASE )
		end

		display.getCurrentStage():setFocus( nil )
		self._has_focus = false
	end

	return true
end




return Background
