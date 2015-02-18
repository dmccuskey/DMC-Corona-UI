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
local ThemeMixModule = require( widget_find( 'widget_theme_mix' ) )

-- these are set later
local Widgets = nil
local ThemeMgr = nil
local ViewFactory = nil



--====================================================================--
--== Setup, Constants


local newClass = Objects.newClass
local ComponentBase = Objects.ComponentBase

local LifecycleMix = LifecycleMixModule.LifecycleMix
local ThemeMix = ThemeMixModule.ThemeMix



--====================================================================--
--== Background Widget Class
--====================================================================--


-- ! put ThemeMix first !

local Background = newClass( {ThemeMix,ComponentBase,LifecycleMix}, {name="Background Widget"} )

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

Background.PRESSED = 'touch-press-event'
Background.RELEASED = 'touch-release-event'


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

	-- properties in this class
	self._x = params.x
	self._x_dirty = true
	self._y = params.y
	self._y_dirty = true

	-- properties for style
	self._width_dirty=true
	self._height_dirty=true

	self._anchorX_dirty=true
	self._anchorY_dirty=true
	self._debugOn_dirty=true
	self._hitMarginX_dirty=true
	self._hitMarginY_dirty=true
	self._isHitActive_dirty=true
	self._isHitTestable_dirty=true

	-- virtual
	self._hitX_dirty = true
	self._hitY_dirty = true

	--== Object References ==--

	self._tmp_style = params.style -- save
	-- self.curr_style -- from inherit

	self._rct_bgHit = nil -- our hit area
	self._rct_bgHit_f = nil

	self._wgt_bgView = nil -- background view
	self._wgt_bgView_dirty = true

end

function Background:__undoInit__()
	-- print( "Background:__undoInit__" )
	--==--
	self:superCall( ComponentBase, '__undoInit__' )
	self:superCall( ThemeMix, '__undoInit__' )
	self:superCall( LifecycleMix, '__undoInit__' )
end


--== createView
function Background:__createView__()
	-- print( "Background:__createView__" )
	self:superCall( ComponentBase, '__createView__' )
	--==--
	local o = display.newRect( 0,0,0,0 )
	o.anchorX, o.anchorY = 0.5,0.5
	self:insert( o )
	self._rct_bgHit = o
end

function Background:__undoCreateView__()
	-- print( "Background:__undoCreateView__" )
	self._rct_bgHit:removeSelf()
	self._rct_bgHit=nil
	--==--
	self:superCall( ComponentBase, '__undoCreateView__' )
end


--== initComplete

function Background:__initComplete__()
	-- print( "Background:__initComplete__" )
	self:superCall( ComponentBase, '__initComplete__' )
	--==--
	self._rct_bgHit_f = self:createCallback( self._hitAreaTouch_handler )
	self._rct_bgHit:addEventListener( 'touch', self._rct_bgHit_f )

	self.style = self._tmp_style
end

function Background:__undoInitComplete__()
	--print( "Background:__undoInitComplete__" )
	self:_removeBackground()

	self.style = nil

	self._rct_bgHit:removeEventListener( 'touch', self._rct_bgHit_f )
	self._rct_bgHit_f = nil
	--==--
	self:superCall( ComponentBase, '__undoInitComplete__' )
end

--== END: Setup DMC Objects
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

--== width (custom)

function Background.__getters:width()
	-- print( 'Background.__getters:width' )
	return self.curr_style.width
end
function Background.__setters:width( value )
	-- print( 'Background.__setters:width', value )
	local style=self.curr_style
	style.width = value
	style.view.width=value
end

--== height (custom)

function Background.__getters:height()
	-- print( 'Background.__getters:height' )
	return self.curr_style.height
end
function Background.__setters:height( value )
	-- print( 'Background.__setters:height', value )
	local style=self.curr_style
	style.height = value
	style.view.height=value
end


--== anchorX

function Background.__getters:anchorX()
	-- print( 'Background.__getters:anchorX' )
	return self.curr_style.anchorX
end
function Background.__setters:anchorX( value )
	-- print( 'Background.__setters:anchorX', value )
	local style=self.curr_style
	style.anchorX = value
	style.view.anchorX = value
end

--== anchorY

function Background.__getters:anchorY()
	-- print( 'Background.__getters:anchorY' )
	return self.curr_style.anchorY
end
function Background.__setters:anchorY( value )
	-- print( 'Background.__setters:anchorY', value )
	local style=self.curr_style
	style.anchorY = value
	style.view.anchorY = value
end



--== hitMarginX

function Background.__getters:hitMarginX()
	-- print( 'Background.__getters:hitMarginX' )
	return self.curr_style.hitMarginX
end
function Background.__setters:hitMarginX( value )
	-- print( 'Background.__setters:hitMarginX', value )
	self.curr_style.hitMarginX = value
end

--== hitMarginY

function Background.__getters:hitMarginY()
	-- print( 'Background.__getters:hitMarginY' )
	return self.curr_style.hitMarginY
end
function Background.__setters:hitMarginY( value )
	-- print( 'Background.__setters:hitMarginY', value )
	self.curr_style.hitMarginY = value
end

--== isHitActive

function Background.__getters:isHitActive()
	-- print( 'Background.__getters:isHitActive' )
	return self.curr_style.isHitActive
end
function Background.__setters:isHitActive( value )
	-- print( 'Background.__setters:isHitActive', value )
	self.curr_style.isHitActive = value
end



--== setHitMargin

function Background:setHitMargin( ... )
	-- print( 'Background:setHitMargin' )
	local args = {...}

	if type( args[1] ) == 'table' then
		self.hitMarginX, self.hitMarginY = unpack( args[1] )
	end
	if type( args[1] ) == 'number' then
		self.hitMarginX = args[1]
	end
	if type( args[2] ) == 'number' then
		self.hitMarginY = args[2]
	end
end


--== View Style Methods ==--


--== viewStrokeWidth

function Background.__getters:viewStrokeWidth()
	return self.curr_style.view.strokeWidth
end
function Background.__setters:viewStrokeWidth( value )
	-- print( 'Background.__setters:viewStrokeWidth', value )
	self.curr_style.view.strokeWidth = value
end

--== setViewFillColor

function Background:setViewFillColor( ... )
	-- print( 'Background:setViewFillColor' )
	self.curr_style.view.fillColor = {...}
end

--== setViewStrokeColor

function Background:setViewStrokeColor( ... )
	-- print( 'Background:setViewStrokeColor' )
	self.curr_style.view.strokeColor = {...}
end




--====================================================================--
--== Private Methods


function Background:_removeBackground()
	-- print( 'Background:_removeBackground' )
	local o = self._wgt_bgView
	if not o then return end
	o:removeSelf()
	self._wgt_bgView = nil
end

-- TODO: future will have different types of backgrounds
--
function Background:_createBackgroundView()
	-- print( 'Background:_createBackgroundView' )
	local style = self.curr_style

	self:_removeBackground()

	local o = ViewFactory.create( style.view.type )
	self:insert( o.view )
	self._wgt_bgView = o

	-- conditions for coming in here
	self._wgt_bgView_dirty = false

	--== reset our object

	self._bgStyle_dirty = true
end


function Background:__commitProperties__()
	-- print( 'Background:__commitProperties__' )
	local style = self.curr_style

	-- create new background if necessary
	if self._wgt_bgView_dirty then
		self:_createBackgroundView()
	end

	local view = self.view
	local hit = self._rct_bgHit
	local bg = self._wgt_bgView

	--== View

	-- x/y

	if self._x_dirty then
		view.x = self._x
		self._x_dirty = false

		self._hitX_dirty=true
	end
	if self._y_dirty then
		view.y = self._y
		self._y_dirty = false

		self._hitY_dirty=true
	end

	-- width/height

	if self._width_dirty then
		hit.width = style.width+style.hitMarginX*2
		self._width_dirty=false
	end
	if self._height_dirty then
		hit.height = style.height+style.hitMarginY*2
		self._height_dirty=false
	end

	--== View Widget

	if self._bgStyle_dirty then
		bg:setActiveStyle( style.view, {copy=false} )
		self._bgStyle_dirty=false
	end

	-- Hit Area

	if self._hitX_dirty then
		local width = style.width
		hit.x = width/2+(-width*style.anchorX)
		self._hitX_dirty=false
	end
	if self._hitY_dirty then
		local height = style.height
		hit.y = height/2+(-height*style.anchorY)
		self._hitY_dirty=false
	end


	--== non-position sensitive

	-- debug on

	if self._debugOn_dirty then
		if style.debugOn then
			hit:setFillColor( 1,0,0,0.5 )
		else
			hit:setFillColor( 0,0,0,0 )
		end
	end

	-- hit testable

	if self._isHitTestable_dirty then
		hit.isHitTestable = style.isHitTestable
		self._isHitTestable_dirty=false
	end

end



--====================================================================--
--== Event Handlers


function Background:stylePropertyChangeHandler( event )
	-- print( "\n\nBackground:stylePropertyChangeHandler", event )
	local style = event.target
	local etype= event.type
	local property= event.property
	local value = event.value

	-- print( "Style Changed", etype, property, value )

	if etype == style.STYLE_RESET then
		self._width_dirty=true
		self._height_dirty=true

		self._anchorX_dirty=true
		self._anchorY_dirty=true
		self._debugOn_dirty = true
		self._hitMarginX_dirty = true
		self._hitMarginX_dirty = true
		self._isHitActive_dirty=true
		self._isHitTestable_dirty=true

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
		elseif property=='debugActive' then
			self._debugOn_dirty=true
		elseif property=='hitMarginX' then
			self._hitMarginX_dirty=true
		elseif property=='hitMarginY' then
			self._hitMarginY_dirty=true
		elseif property=='isHitActive' then
			self._isHitActive_dirty=true
		elseif property=='isHitTestable' then
			self._isHitTestable_dirty=true
		end

	end

	self:__invalidateProperties__()
	self:__dispatchInvalidateNotification__( property, value )
end


function Background:_hitAreaTouch_handler( e )
	-- print( 'Background:_hitAreaTouch_handler', e.phase )
	local phase = e.phase
	local background = e.target

	if not self.curr_style.isHitActive then return false end

	if phase=='began' then
		display.getCurrentStage():setFocus( background )
		self._has_focus = true
		self:dispatchEvent( self.PRESSED, {isWithinBounds=true}, {merge=true} )
	end

	if not self._has_focus then return false end

	local bgCb = background.contentBounds
	local isWithinBounds =
		( bgCb.xMin <= e.x and bgCb.xMax >= e.x
			and bgCb.yMin <= e.y and bgCb.yMax >= e.y )

	if phase=='moved' then
		self:dispatchEvent( self.MOVED, {isWithinBounds=isWithinBounds}, {merge=true} )

	elseif phase=='ended' or phase=='canceled' then
		display.getCurrentStage():setFocus( nil )
		self._has_focus = false
		self:dispatchEvent( self.RELEASED, {isWithinBounds=isWithinBounds}, {merge=true}  )
	end

	return true
end




return Background
