--====================================================================--
-- dmc_widgets/widget_background/rounded_view.lua
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
--== DMC Corona Widgets : Rounded Background View
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
--== DMC Widgets : newRoundedBackground
--====================================================================--



--====================================================================--
--== Imports


local Objects = require 'dmc_objects'
local LifecycleMixModule = require 'dmc_lifecycle_mix'
local ThemeMixModule = require( dmc_widget_func.find( 'widget_theme_mix' ) )

-- these are set later
local StyleFactory = nil
local ThemeMgr = nil
local ViewFactory = nil
local Widgets = nil



--====================================================================--
--== Setup, Constants


local newClass = Objects.newClass
local ComponentBase = Objects.ComponentBase

local LifecycleMix = LifecycleMixModule.LifecycleMix
local ThemeMix = ThemeMixModule.ThemeMix



--====================================================================--
--== Rounded Background View Class
--====================================================================--


local RoundedView = newClass( {ThemeMix,ComponentBase,LifecycleMix}, {name="Rounded Background View"}  )

--== Class Constants

RoundedView.TYPE = 'rounded'

RoundedView.LEFT = 'left'
RoundedView.CENTER = 'center'
RoundedView.RIGHT = 'right'

--== Theme Constants

RoundedView.THEME_ID = 'rounded-background-view'
RoundedView.STYLE_CLASS = nil -- added later

-- TODO: hook up later
-- RoundedView.DEFAULT = 'default'

-- RoundedView.THEME_STATES = {
-- 	RoundedView.DEFAULT,
-- }

--== Event Constants

RoundedView.EVENT = 'rounded-background-view-event'


--======================================================--
-- Start: Setup DMC Objects

--== Init

function RoundedView:__init__( params )
	-- print( "RoundedView:__init__", params )
	params = params or {}
	if params.x==nil then params.x=0 end
	if params.y==nil then params.y=0 end

	self:superCall( LifecycleMix, '__init__', params )
	self:superCall( ComponentBase, '__init__', params )
	self:superCall( ThemeMix, '__init__', params )
	--==--

	--== Create Properties ==--

	-- properties in this class

	self._x = params.x
	self._x_dirty = true
	self._y = params.y
	self._y_dirty = true

	-- properties from style

	self._width_dirty=true
	self._height_dirty=true
	self._anchorX_dirty=true
	self._anchorY_dirty=true

	self._cornerRadius_dirty = true
	self._fillColor_dirty = true
	self._strokeColor_dirty=true
	self._strokeWidth_dirty=true

	--== Object References ==--

	self._tmp_style = params.style -- save

	self._rndBg = nil -- our rounded rect object

end

function RoundedView:__undoInit__()
	-- print( "RoundedView:__undoInit__" )
	--==--
	self:superCall( ThemeMix, '__undoInit__' )
	self:superCall( ComponentBase, '__undoInit__' )
	self:superCall( LifecycleMix, '__undoInit__' )
end

--== createView

function RoundedView:__createView__()
	-- print( "RoundedView:__createView__" )
	self:superCall( ComponentBase, '__createView__' )
	--==--
	local o = display.newRoundedRect( 0,0,0,0,1 )
	self:insert( o )
	self._rndBg = o
end

function RoundedView:__undoCreateView__()
	-- print( "RoundedView:__undoCreateView__" )
	self._rndBg:removeSelf()
	self._rndBg=nil
	--==--
	self:superCall( ComponentBase, '__undoCreateView__' )
end

--== initComplete

function RoundedView:__initComplete__()
	-- print( "RoundedView:__initComplete__" )
	self:superCall( ComponentBase, '__initComplete__' )
	--==--
	self.style = self._tmp_style
end

function RoundedView:__undoInitComplete__()
	--print( "RoundedView:__undoInitComplete__" )
	self.style = nil
	--==--
	self:superCall( ComponentBase, '__undoInitComplete__' )
end

-- END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Static Methods


function RoundedView.initialize( manager )
	-- print( "RoundedView.initialize" )
	Widgets = manager

	ThemeMgr = Widgets.ThemeMgr
	ViewFactory = Widgets.BackgroundFactory
	StyleFactory = Widgets.Style.BackgroundFactory

	RoundedView.STYLE_CLASS = StyleFactory.Rounded

	ThemeMgr:registerWidget( RoundedView.THEME_ID, RoundedView )
end



--====================================================================--
--== Public Methods


--== X

function RoundedView.__getters:x()
	return self._x
end
function RoundedView.__setters:x( value )
	-- print( 'RoundedView.__setters:x', value )
	assert( type(value)=='number' )
	--==--
	if self._x == value then return end
	self._x = value
	self._x_dirty=true
	self:__invalidateProperties__()
end

--== Y

function RoundedView.__getters:y()
	return self._y
end
function RoundedView.__setters:y( value )
	-- print( 'RoundedView.__setters:y', value )
	assert( type(value)=='number' )
	--==--
	if self._y == value then return end
	self._y = value
	self._y_dirty=true
	self:__invalidateProperties__()
end



--====================================================================--
--== Private Methods


function RoundedView:__commitProperties__()
	-- print( 'RoundedView:__commitProperties__' )
	local style = self.curr_style
	local view = self.view
	local bg = self._rndBg

	-- x/y

	if self._x_dirty then
		view.x = self._x
		self._x_dirty = false
	end
	if self._y_dirty then
		view.y = self._y
		self._y_dirty = false
	end

	if self._width_dirty then
		bg.path.width=style.width
		self._width_dirty=false
	end
	if self._height_dirty then
		bg.path.height=style.height
		self._height_dirty=false
	end

	-- anchorX/anchorY

	if self._anchorX_dirty then
		bg.anchorX = style.anchorX
		self._anchorX_dirty=false
	end
	if self._anchorY_dirty then
		bg.anchorY = style.anchorY
		self._anchorY_dirty=false
	end

	-- fills/colors

	if self._cornerRadius_dirty then
		bg.path.radius = style.cornerRadius
		self._cornerRadius_dirty=false
	end
	if self._fillColor_dirty then
		bg:setFillColor( unpack( style.fillColor ))
		self._fillColor_dirty=false
	end
	if self._strokeColor_dirty then
		bg:setStrokeColor( unpack( style.strokeColor ))
		self._strokeColor_dirty=false
	end
	if self._strokeWidth_dirty then
		bg.strokeWidth = style.strokeWidth
		self._strokeWidth_dirty=false
	end

end



--====================================================================--
--== Event Handlers


function RoundedView:stylePropertyChangeHandler( event )
	-- print( "RoundedView:stylePropertyChangeHandler", event )
	local style = event.target
	local etype= event.type
	local property= event.property
	local value = event.value

	-- print( "Style Changed", etype, property, value )

	if etype==style.STYLE_RESET or etype==style.STYLE_CLEARED then
		self._width_dirty=true
		self._height_dirty=true
		self._anchorX_dirty=true
		self._anchorY_dirty=true

		self._cornerRadius_dirty = true
		self._fillColor_dirty = true
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

		elseif property=='cornerRadius' then
			self._cornerRadius_dirty=true
		elseif property=='fillColor' then
			self._fillColor_dirty=true
		elseif property=='strokeColor' then
			self._strokeColor_dirty=true
		elseif property=='strokeWidth' then
			self._strokeWidth_dirty=true
		end

	end

	self:__invalidateProperties__()
	self:__dispatchInvalidateNotification__( property, value )
end




return RoundedView
