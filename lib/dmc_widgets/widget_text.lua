--====================================================================--
-- dmc_widgets/widget_text.lua
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
--== DMC Corona Widgets : Widget Text
--====================================================================--


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.1.0"



--====================================================================--
--== DMC Widgets Setup
--====================================================================--


local dmc_widget_data, dmc_widget_func
dmc_widget_data = _G.__dmc_widget
dmc_widget_func = dmc_widget_data.func



--====================================================================--
--== DMC Widgets : newText
--====================================================================--



--====================================================================--
--== Imports


local Objects = require 'dmc_objects'
local LifecycleMixModule = require 'dmc_lifecycle_mix'
local Utils = require( dmc_widget_func.find( 'widget_utils' ) )
local ThemeMixModule = require( dmc_widget_func.find( 'widget_theme_mix' ) )

-- these are set later
local Widgets = nil
local FontMgr = nil
local ThemeMgr = nil



--====================================================================--
--== Setup, Constants


-- setup some aliases to make code cleaner
local newClass = Objects.newClass
local ComponentBase = Objects.ComponentBase

local LifecycleMix = LifecycleMixModule.LifecycleMix
local ThemeMix = ThemeMixModule.ThemeMix

local LOCAL_DEBUG = true



--====================================================================--
--== Text Widget Class
--====================================================================--


local Text = newClass( {ComponentBase,ThemeMix,LifecycleMix}, {name="Text"}  )

--== Class Constants

Text.LEFT = 'left'
Text.CENTER = 'center'
Text.RIGHT = 'right'

--== Theme Constants

Text.THEME_ID = 'text'

Text.DEFAULT = 'default'

Text.THEME_STATES = {
	Text.DEFAULT,
}

--== Event Constants

Text.EVENT = 'background-widget-event'


--======================================================--
--== Start: Setup DMC Objects

--== Init

function Text:__init__( params )
	-- print( "Text:__init__", params )
	params = params or {}
	if params.text==nil then params.text="" end
	self:superCall( LifecycleMix, '__init__', params )
	self:superCall( ThemeMix, '__init__', params )
	self:superCall( ComponentBase, '__init__', params )
	--==--

	--== Sanity Check ==--

	if self.is_class then return end

	local style = params.style
	if not style then
		style = Widgets.Style.Text.copyStyle()
	end
	style:updateStyle( params )

	--== Create Properties ==--

	self._text = params.text

	self._x_dirty = true
	self._y_dirty = true
	self._width_dirty=true
	self._height_dirty=true
	-- virtual
	self._bgWidth_dirty=true
	self._bgHeight_dirty=true

	self._align_dirty=true
	self._anchorX_dirty=true
	self._anchorY_dirty=true
	self._fillColor_dirty = true
	self._font_dirty=true
	self._fontSize_dirty=true
	self._marginX_dirty=true
	self._marginY_dirty=true
	self._strokeColor_dirty=true
	self._strokeWidth_dirty=true

	self._text_dirty=true
	self._textColor_dirty=true
	-- virtual
	self._textX_dirty=true
	self._textY_dirty=true

	--== Object References ==--

	self._style = style -- save
	-- self.curr_style -- from inherit

	self._txt_text = nil -- our text object
	self._bg = nil -- our background object

end

function Text:__undoInit__()
	-- print( "Text:__undoInit__" )
	--==--
	self:superCall( ComponentBase, '__undoInit__' )
	self:superCall( ThemeMix, '__undoInit__' )
	self:superCall( LifecycleMix, '__undoInit__' )
end


--== createView

function Text:__createView__()
	-- print( "Text:__createView__" )
	self:superCall( ComponentBase, '__createView__' )
	--==--
	self._bg = display.newRect( 0,0,0,0 )
	self:insert( self._bg )
end

function Text:__undoCreateView__()
	-- print( "Text:__undoCreateView__" )
	self._bg:removeSelf()
	self._bg=nil
	--==--
	self:superCall( ComponentBase, '__undoCreateView__' )
end


--== initComplete

function Text:__initComplete__()
	-- print( "Text:__initComplete__" )
	self:superCall( ComponentBase, '__initComplete__' )
	--==--

	local f  = self:createCallback( self._styleEvent_handler )
	self:setStyleCallback( f )

	-- calls __commitProperties__()
	self:setActiveStyle( self._style )
end

function Text:__undoInitComplete__()
	--print( "Text:__undoInitComplete__" )
	self:_removeText()

	self:setActiveStyle( nil )

	self:setStyleCallback( nil )
	--==--
	self:superCall( ComponentBase, '__undoInitComplete__' )
end

--== END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Static Methods


function Text.__setWidgetManager( manager )
	-- print( "Text.__setWidgetManager" )
	Widgets = manager
	FontMgr = Widgets.FontMgr
	ThemeMgr = Widgets.ThemeMgr

	ThemeMgr:registerWidget( Text.THEME_ID, Text )
end



--====================================================================--
--== Public Methods


--== style

function Text.__getters:style()
	-- print( 'Text.__getters:style' )
	return self.curr_style
end
function Text.__setters:style( value )
	-- print( 'Text.__setters:style', value )
	self:setActiveStyle( value )
end

--== X

function Text.__setters:x( value )
	-- print( 'Text.__setters:x', value )
	self.curr_style.x = value
end

--== Y

function Text.__setters:y( value )
	-- print( 'Text.__setters:y', value )
	self.curr_style.y = value
end

--== width

function Text.__getters:width()
	-- print( 'Text.__getters:width' )
	local w, t = self.curr_style.width, self._txt_text
	if w==nil and t then w=t.width end
	return w
end
function Text.__setters:width( value )
	-- print( 'Text.__setters:width', value )
	self.curr_style.width = value
end

--== height

function Text.__getters:height()
	-- print( 'Text.__getters:height' )
	local h, t = self.curr_style.height, self._txt_text
	if h==nil and t then h=t.height end
	return h
end
function Text.__setters:height( value )
	-- print( 'Text.__setters:height', value )
	self.curr_style.height = value
end


--== align

function Text.__getters:align()
	return self.curr_style.align
end
function Text.__setters:align( value )
	-- print( 'Text.__setters:align', value )
	self.curr_style.align = value
end

--== anchorX

function Text.__getters:anchorX()
	return self.curr_style.anchorX
end
function Text.__setters:anchorX( value )
	-- print( 'Text.__setters:anchorX', value )
	self.curr_style.anchorX = value
end

--== anchorY

function Text.__getters:anchorY()
	return self.curr_style.anchorY
end
function Text.__setters:anchorY( value )
	-- print( 'Text.__setters:anchorY', value )
	self.curr_style.anchorY = value
end

--== font

function Text.__getters:font()
	return self.curr_style.font
end
function Text.__setters:font( value )
	-- print( 'Text.__setters:font', value )
	self.curr_style.font = value
end

--== fontSize

function Text.__getters:fontSize()
	return self.curr_style.fontSize
end
function Text.__setters:fontSize( value )
	-- print( 'Text.__setters:fontSize', value )
	self.curr_style.fontSize = value
end

--== marginX

function Text.__getters:marginX()
	return self.curr_style.marginX
end
function Text.__setters:marginX( value )
	-- print( 'Text.__setters:marginX', value )
	self.curr_style.marginX = value
end

--== marginY

function Text.__getters:marginY()
	return self.curr_style.marginY
end
function Text.__setters:marginY( value )
	-- print( 'Text.__setters:marginY', value )
	self.curr_style.marginY = value
end

--== strokeWidth

function Text.__getters:strokeWidth()
	return self.curr_style.strokeWidth
end
function Text.__setters:strokeWidth( value )
	-- print( 'Text.__setters:strokeWidth', value )
	self.curr_style.strokeWidth = value
end

--== text

function Text.__getters:text()
	return self._text
end
function Text.__setters:text( value )
	-- print( 'Text.__setters:text', value )
	assert( type(value)=='string' )
	--==--
	if self._text == value then return end
	self._text = value
	self._text_dirty=true
	self:__invalidateProperties__()
end

--== Text

function Text:setAnchor( ... )
	-- print( 'Text:setAnchor' )
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

--== setFillColor

function Text:setFillColor( ... )
	-- print( 'Text:setFillColor' )
	self.curr_style.fillColor = {...}
end

--== setStrokeColor

function Text:setStrokeColor( ... )
	-- print( 'Text:setStrokeColor' )
	self.curr_style.strokeColor = {...}
end

--== setTextColor

function Text:setTextColor( ... )
	-- print( 'Text:setTextColor' )
	self.curr_style.textColor = {...}
end



--====================================================================--
--== Private Methods


function Text:_updateTextProperties()
	-- CAN OVERRIDE FOR CUSTOM HANDLING
end

function Text:_removeText()
	-- print( 'Text:_removeText' )
	local o = self._txt_text
	if o then
		o:removeSelf()
		self._txt_text = nil
	end
end

function Text:_createText()
	-- print( 'Text:_createText' )
	local style = self.curr_style
	local o -- object

	self:_removeText()
	self:_updateTextProperties()

	local w, h = style.width, style.height
	if w ~= nil then
		w = w - style.marginX*2
	end

	o = display.newText{
		x=0,
		y=0,
		width=w,
		height=nil, -- don't use height

		align=style.align,
		fontSize=style.fontSize,
		text=self._text,
	}

	self:insert( o )
	self._txt_text = o

	-- conditions for coming in here
	self._align_dirty=false
	self._font_dirty=false
	self._fontSize_dirty=false
	self._fontSize_dirty=false

	--== reset our text object

	self._x_dirty=true
	self._y_dirty=true
	self._width_dirty=true
	self._height_dirty=true

	self._bgWidth_dirty=true
	self._bgHeight_dirty=true

	self._anchorX_dirty=true
	self._anchorY_dirty=true
	self._text_dirty=true
	self._textColor_dirty=true
end


function Text:__commitProperties__()
	-- print( 'Text:__commitProperties__' )
	local style = self.curr_style
	-- local metric = FontMgr:getFontMetric( style.font, style.fontSize )
	metric={offsetX=0,offsetY=0}

	-- create new text if necessary
	if self._align_dirty or self._font_dirty or self._fontSize_dirty then
		self:_createText()
	end

	local view = self.view
	local bg = self._bg
	local text = self._txt_text

	--== position sensitive

	if self._align_dirty then
		text.align=style._align
		self._align_dirty = false
	end

	-- set text string

	if self._text_dirty then
		text.text = self._text
		self._text_dirty=false

		self._bgWidth_dirty=true
		self._bgHeight_dirty=true
		self._anchorX_dirty=true
		self._anchorY_dirty=true
	end

	-- bg width/height

	if self._bgWidth_dirty then
		bg.width = self.width
		self._bgWidth_dirty=false

		self._text_alignX_dirty=true
	end
	if self._bgHeight_dirty then
		bg.height = self.height
		self._bgHeight_dirty=false

		self._text_alignY_dirty=true
	end

	-- anchorX/anchorY

	if self._anchorX_dirty then
		-- view.anchorX = style.anchorX
		bg.anchorX = style.anchorX
		self._anchorX_dirty=false

		self._x_dirty=true
	end
	if self._anchorY_dirty then
		-- view.anchorY = style.anchorY
		bg.anchorY = style.anchorY
		self._anchorY_dirty=false

		self._y_dirty=true
	end

	-- x/y

	if self._x_dirty then
		view.x = style.x
		bg.x = 0
		local offset = bg.width*(0.5-bg.anchorX)
		text.x = bg.x+offset
		self._x_dirty = false

		self._textX_dirty=true
	end
	if self._y_dirty then
		view.y = style.y
		bg.y = 0
		local offset = bg.height*(0.5-bg.anchorY)
		text.y = bg.y -- +offset
		self._y_dirty = false

		self._textY_dirty=true
	end

	-- text align x/y

	if self._textX_dirty then
		local align = self._align
		local bgMarginX = style.marginX
		local offset
		if align == self.LEFT then
			text.anchorX = 0
			offset = -bg.width*(bg.anchorX)+bgMarginX
			text.x=bg.x+offset
		elseif align == self.RIGHT then
			text.anchorX = 1
			offset = bg.width*(1-bg.anchorX)-bgMarginX
			text.x=bg.x+offset
		else
			text.anchorX = 0.5
			offset = bg.width*(0.5-bg.anchorX)
			text.x=bg.x+offset
		end
		self._textX_dirty = false
	end

	if self._textY_dirty then
		local offset
		text.anchorY = 0.5
		offset = bg.height/2-bg.height*(bg.anchorY) -- 0
		text.y=bg.y+offset
		self._textY_dirty=false
	end


	--== non-position sensitive

	-- textColor/fillColor

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
	if self._textColor_dirty then
		text:setTextColor( unpack( style.textColor ) )
		self._textColor_dirty=false
	end

end


function Text:_resetAllProperties()
	-- print( "Text:_resetAllProperties" )
	self._x_dirty = true
	self._y_dirty = true
	self._width_dirty=true
	self._height_dirty=true

	self._align_dirty=true
	self._anchorX_dirty=true
	self._anchorY_dirty=true
	self._fillColor_dirty = true
	self._font_dirty=true
	self._fontSize_dirty=true
	self._marginX_dirty=true
	self._marginY_dirty=true
	self._strokeColor_dirty=true
	self._strokeWidth_dirty=true

	self._text_dirty=true
	self._textColor_dirty=true
end



--====================================================================--
--== Event Handlers


function Text:_styleEvent_handler( event )
	-- print( "Text:_styleEvent_handler", event )
	local etype= event.type
	local property= event.property
	local value = event.value

	-- print( "Style Changed", etype, property, value )

	if etype=='reset-all' then
		self:_resetAllProperties()

	else

		if property=='x' then
			self._x_dirty=true
		elseif property=='y' then
			self._y_dirty=true
		elseif property=='width' then
			self._width_dirty=true
		elseif property=='height' then
			self._height_dirty=true

		elseif property=='align' then
			self._align_dirty=true
		elseif property=='anchorX' then
			self._anchorX_dirty=true
		elseif property=='anchorY' then
			self._anchorY_dirty=true
		elseif property=='fillColor' then
			self._fillColor_dirty=true
		elseif property=='font' then
			self._font_dirty=true
		elseif property=='fontSize' then
			self._fontSize_dirty=true
		elseif property=='marginX' then
			self._marginX_dirty=true
		elseif property=='marginY' then
			self._marginY_dirty=true
		elseif property=='strokeColor' then
			self._strokeColor_dirty=true
		elseif property=='strokeWidth' then
			self._strokeWidth_dirty=true
		elseif property=='text' then
			self._text_dirty=true
		elseif property=='textColor' then
			self._textColor_dirty=true
		end
	end

	self:__invalidateProperties__()
	self:__dispatchInvalidateNotification__( property, value )
end




return Text
