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


local Background = newClass( {ComponentBase,ThemeMix,LifecycleMix}, {name="Background"} )

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

Background.DEFAULT = 'default'

Background.THEME_STATES = {
	Background.DEFAULT,
}

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
	self:superCall( ThemeMix, '__init__', params )
	self:superCall( ComponentBase, '__init__', params )
	--==--

	--== Sanity Check ==--

	if self.is_class then return end

	local style = params.style
	if not style then
		style = Widgets.Style.Background.createDefaultStyle()
	end
	style:updateStyle( params )

	assert( style.width, "Background: requires param 'width'" )
	assert( style.height, "Background: requires param 'height'" )
	assert( style.x, "Background: requires param 'x'" )
	assert( style.y, "Background: requires param 'y'" )

	--== Create Properties ==--

	-- required params
	self._x_dirty = true
	self._y_dirty = true

	-- other
	self._anchorX_dirty=true
	self._anchorY_dirty=true

	self._fillColor_dirty = true

	self._height_dirty=true
	self._width_dirty=true

	self._fillColor_dirty=true
	self._strokeColor_dirty=true
	self._strokeWidth_dirty=true

	self._isHitTestable_dirty = true

	self._bg_dirty = true

	--== Object References ==--

	self._style = style
	self.curr_style = nil
	self.curr_style_f = nil

	self._bg = nil -- our background object – rect or image
	self._bg_f = nil

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

	local f  = self:createCallback( self._styleEvent_handler )
	self:setStyleCallback( f )
	self:setActiveStyle( self._style )

	self:__commitProperties__()
end

function Background:__undoInitComplete__()
	--print( "Background:__undoInitComplete__" )
	self:_removeBackground()

	self:setActiveStyle( nil )
	self:setStyleCallback( nil )

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

	ThemeMgr:registerWidget( Background.THEME_ID, Background )
end



--====================================================================--
--== Public Methods


--== X

function Background.__setters:x( value )
	-- print( 'Background.__setters:x', value )
	self.curr_style.x = value
end

--== Y

function Background.__setters:y( value )
	-- print( 'Background.__setters:y', value )
	self.curr_style.y = value
end

--== anchorX

function Background.__getters:anchorX()
	return self.curr_style.anchorX
end
function Background.__setters:anchorX( value )
	-- print( 'Background.__setters:anchorX', value )
	self.curr_style.anchorX = value
end

--== anchorY

function Background.__getters:anchorY()
	return self.curr_style.anchorY
end
function Background.__setters:anchorY( value )
	-- print( 'Background.__setters:anchorY', value )
	assert( type(value)=='number' )
	--==--
	self.curr_style.anchorY = value
end

--== strokeColor

function Background.__getters:strokeColor()
	return self.curr_style.strokeColor
end
function Background.__setters:strokeColor( value )
	-- print( 'Background.__setters:strokeColor', value )
	self.curr_style.strokeColor = value
end

--== strokeWidth

function Background.__getters:strokeWidth()
	return self.curr_style.strokeWidth
end
function Background.__setters:strokeWidth( value )
	-- print( 'Background.__setters:strokeWidth', value )
	self.curr_style.strokeWidth = value
end

--== setAnchor

function Background:setAnchor( ... )
	-- print( 'Background:setAnchor' )
	local args = {...}

	if type( args[1] ) == 'table' then
		self.anchorX, self.anchorY = unpack( args[1] )
	end
	if type( args[1] ) == 'number' then
		self.anchorX = args[1]
	end
	if type( args[2] ) == 'number' then
		self.anchorY = args[2]
	end
end

--== width

function Background.__getters:width()
	return self.curr_style.width
end
function Background.__setters:width( value )
	-- print( 'Background.__setters:width', value )
	self.curr_style.width = value
end

--== height

function Background.__getters:height()
	return self.curr_style.height
end
function Background.__setters:height( value )
	-- print( 'Background.__setters:height', value )
	self.curr_style.height = value
end

--== setFillColor

function Background:setFillColor( ... )
	-- print( 'Background:setFillColor' )
	--==--
	self.curr_style.fillColor = {...}
end



--====================================================================--
--== Private Methods


function Background:_updateBackgroundProperties()
	-- CAN OVERRIDE FOR CUSTOM HANDLING
end


function Background:_removeBackground()
	-- print( 'Background:_removeBackground' )
	local o = self._newtext
	if o then
		o:removeEventListener( 'touch', self._bg_f )
		o:removeSelf()
		self._newtext = nil
	end
end

function Background:_createNewBackground()
	-- print( 'Background:_createNewBackground' )
	local o -- object
	local style = self.curr_style

	self:_removeBackground()
	self:_updateBackgroundProperties()

	local x, y = style.x, style.y
	local w, h = style.width, style.height

	self._bg = display.newRect( 0,0,w,h )
	self:insert( self._bg )
	self._bg:addEventListener( 'touch', self._bg_f )

	self._bg_dirty = false

	self._x_dirty=true
	self._y_dirty=true
	self._height_dirty=false
	self._width_dirty=false

	--== reset our object

	self._isHitTestable_dirty=true
	self._anchorX_dirty=true
	self._anchorY_dirty=true
	self._fillColor_dirty=true
end


function Background:__commitProperties__()
	-- print( 'Background:__commitProperties__' )

	-- create new text if necessary
	if self._bg_dirty then
		self:_createNewBackground()
	end

	local view = self.view
	local bg = self._bg
	local style = self.curr_style

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
		view.x = style.x
		self._x_dirty = false
	end
	if self._y_dirty then
		view.y = style.y
		self._y_dirty = false
	end

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

	if self._strokeWidth_dirty then
		bg.strokeWidth = style.strokeWidth
		self._strokeWidth_dirty=false
	end
	if self._strokeColor_dirty then
		bg:setStrokeColor( unpack( style.strokeColor ))
		self._strokeColor_dirty=false
	end


end



--====================================================================--
--== Event Handlers


function Background:_styleEvent_handler( event )
	-- print( "Background:_styleEvent_handler", event )
	local etype= event.type
	local property= event.property
	local value = event.value

	-- print( "Style Changed", etype, property, value )

	if property=='x' then
		self._x_dirty=true
	elseif property=='y' then
		self._y_dirty=true
	elseif property=='anchorX' then
		self._anchorX_dirty=true
	elseif property=='anchorY' then
		self._anchorY_dirty=true
	elseif property=='fillColor' then
		self._fillColor_dirty=true
	elseif property=='height' then
		self._height_dirty=true
	elseif property=='isHitTestable' then
		self._isHitTestable_dirty=true
	elseif property=='strokeWidth' then
		self._strokeWidth_dirty=true
	elseif property=='strokeColor' then
		self._strokeColor_dirty=true
	elseif property=='width' then
		self._width_dirty=true
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
