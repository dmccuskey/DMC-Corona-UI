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


local dmc_widget_data = _G.__dmc_widget
local dmc_widget_func = dmc_widget_data.func
local widget_find = dmc_widget_func.find



--====================================================================--
--== DMC Widgets : newText
--====================================================================--



--====================================================================--
--== Imports


local Objects = require 'dmc_objects'
local LifecycleMixModule = require 'dmc_lifecycle_mix'
local ThemeMixModule = require( dmc_widget_func.find( 'widget_theme_mix' ) )
local Utils = require( dmc_widget_func.find( 'widget_utils' ) )

-- these are set later
local Widgets = nil
local ThemeMgr = nil
local FontMgr = nil



--====================================================================--
--== Setup, Constants


-- setup some aliases to make code cleaner
local newClass = Objects.newClass
local ComponentBase = Objects.ComponentBase

local LifecycleMix = LifecycleMixModule.LifecycleMix
local ThemeMix = ThemeMixModule.ThemeMix

local LOCAL_DEBUG = false



--====================================================================--
--== Text Widget Class
--====================================================================--


local Text = newClass( {ThemeMix,ComponentBase,LifecycleMix}, {name="Text"}  )

--== Class Constants

Text.LEFT = 'left'
Text.CENTER = 'center'
Text.RIGHT = 'right'

--== Theme Constants

Text.THEME_ID = 'text'
Text.STYLE_CLASS = nil -- added later

-- TODO: hook up later
-- Text.DEFAULT = 'default'

-- Text.THEME_STATES = {
-- 	Text.DEFAULT,
-- }

--== Event Constants

Text.EVENT = 'text-widget-event'


--======================================================--
--== Start: Setup DMC Objects

--== Init

function Text:__init__( params )
	-- print( "Text:__init__", params )
	params = params or {}
	if params.x==nil then params.x=0 end
	if params.y==nil then params.y=0 end
	if params.text==nil then params.text="" end

	self:superCall( LifecycleMix, '__init__', params )
	self:superCall( ComponentBase, '__init__', params )
	self:superCall( ThemeMix, '__init__', params )
	--==--

	--== Create Properties ==--

	-- properties in this class

	self._text = params.text
	self._text_dirty=true

	self._x = params.x
	self._x_dirty = true
	self._y = params.y
	self._y_dirty = true

	-- properties from style

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

	self._textColor_dirty=true
	-- virtual
	self._textX_dirty=true
	self._textY_dirty=true

	--== Object References ==--

	self._tmp_style = params.style -- save
	-- self.curr_style -- from inherit

	self._txt_text = nil -- our text object
	self._bg = nil -- our background object

end

function Text:__undoInit__()
	-- print( "Text:__undoInit__" )
	--==--
	self:superCall( ThemeMix, '__undoInit__' )
	self:superCall( ComponentBase, '__undoInit__' )
	self:superCall( LifecycleMix, '__undoInit__' )
end


--== createView

function Text:__createView__()
	-- print( "Text:__createView__" )
	self:superCall( ComponentBase, '__createView__' )
	--==--
	local o = display.newRect( 0,0,0,0 )
	o.x, o.y = 0, 0
	self:insert( o )
	self._bg = o
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
	self.style = self._tmp_style
end

function Text:__undoInitComplete__()
	--print( "Text:__undoInitComplete__" )
	self:_removeText()

	self.style = nil
	--==--
	self:superCall( ComponentBase, '__undoInitComplete__' )
end

--== END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Static Methods


function Text.initialize( manager )
	-- print( "Text.initialize" )
	Widgets = manager
	FontMgr = Widgets.FontMgr
	ThemeMgr = Widgets.ThemeMgr
	Text.STYLE_CLASS = Widgets.Style.Text

	ThemeMgr:registerWidget( Text.THEME_ID, Text )
end



--====================================================================--
--== Public Methods


--== X

function Text.__getters:x()
	return self._x
end
function Text.__setters:x( value )
	-- print( 'Text.__setters:x', value )
	assert( type(value)=='number' )
	--==--
	if self._x == value then return end
	self._x = value
	self._x_dirty=true
	self:__invalidateProperties__()
end

--== Y

function Text.__getters:y()
	return self._y
end
function Text.__setters:y( value )
	-- print( 'Text.__setters:y', value )
	assert( type(value)=='number' )
	--==--
	if self._y == value then return end
	self._y = value
	self._y_dirty=true
	self:__invalidateProperties__()
end


--[[
we use custom getters for width/height
without width/height, we just use dimensions
from text object after creation
--]]

--== width (custom)


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

--== height (custom)

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

-- get just the text height
function Text:getTextHeight()
	-- print( "Text:getTextHeight" )
	local val = 0
	if self._txt_text then
		val = self._txt_text.height
	end
	return val
end


--== Text

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


--====================================================================--
--== Private Methods


function Text:_removeText()
	-- print( 'Text:_removeText' )
	local o = self._txt_text
	if not o then return end
	o:removeSelf()
	self._txt_text = nil
end

function Text:_createText()
	-- print( 'Text:_createText' )
	local style = self.curr_style
	local o -- object

	self:_removeText()

	local w, h = style.width, style.height
	if w ~= nil then
		w = w - style.marginX*2
	end

	o = display.newText{
		x=0, y=0,

		width=w,
		-- don't use height, turns into multi-line
		height=nil,

		text=self._text,
		align=style.align,
		font=style.font,
		fontSize=style.fontSize,
	}

	self:insert( o )
	self._txt_text = o

	-- conditions for coming in here
	self._align_dirty=false
	self._font_dirty=false
	self._fontSize_dirty=false

	--== reset our text object

	self._x_dirty=true
	self._y_dirty=true
	self._width_dirty=true
	self._height_dirty=true

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
	local display = self._txt_text

	--== position sensitive

	-- set text string

	if self._text_dirty then
		display.text = self._text
		self._text_dirty=false

		self._width_dirty=true
		self._height_dirty=true
	end

	if self._align_dirty then
		display.align=style.align
		self._align_dirty = false
	end

	if self._width_dirty then
		display.width=self.width
		self._width_dirty=false

		self._anchorX_dirty=true
		self._bgWidth_dirty=true
	end
	if self._height_dirty then
		-- reminder, we don't set text height
		self._height_dirty=false

		self._anchorY_dirty=true
		self._bgHeight_dirty=true
	end

	if self._marginX_dirty then
		-- reminder, we don't set text height
		self._marginX_dirty=false

		self._bgWidth_dirty=true
		self._textX_dirty=true
	end
	if self._marginY_dirty then
		-- reminder, we don't set text height
		self._marginY_dirty=false

		self._bgHeight_dirty=true
		self._textY_dirty=true
	end


	-- bg width/height

	if self._bgWidth_dirty then
		bg.width = self.width+style.marginX*2 -- use getter, it's smart
		self._bgWidth_dirty=false
	end
	if self._bgHeight_dirty then
		bg.height = self.height+style.marginY*2 -- use getter, it's smart
		self._bgHeight_dirty=false
	end

	-- anchorX/anchorY

	if self._anchorX_dirty then
		bg.anchorX = style.anchorX
		self._anchorX_dirty=false

		self._x_dirty=true
		self._textX_dirty=true
	end
	if self._anchorY_dirty then
		bg.anchorY = style.anchorY
		self._anchorY_dirty=false

		self._y_dirty=true
		self._textY_dirty=true
	end

	-- x/y

	if self._x_dirty then
		view.x = self._x
		self._x_dirty = false

		self._textX_dirty=true
	end
	if self._y_dirty then
		view.y = self._y
		self._y_dirty = false

		self._textY_dirty=true
	end

	-- text align x/y

	if self._textX_dirty then
		local align = style.align
		local width = self.width -- use getter, it's smart
		local offset
		if align == self.LEFT then
			display.anchorX = 0
			offset = -width*(style.anchorX)+style.marginX
			display.x=offset
		elseif align == self.RIGHT then
			display.anchorX = 1
			offset = width*(1-style.anchorX)-style.marginX
			display.x=offset
		else
			display.anchorX = 0.5
			offset = width*(0.5-style.anchorX)
			display.x=offset
		end
		self._textX_dirty = false
	end

	if self._textY_dirty then
		local height = self.height -- use getter, it's smart
		local offset
		display.anchorY = 0.5
		offset = height/2-height*(style.anchorY)
		display.y=offset
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
		display:setTextColor( unpack( style.textColor ) )
		self._textColor_dirty=false
	end

end




--====================================================================--
--== Event Handlers


function Text:stylePropertyChangeHandler( event )
	-- print( "Text:stylePropertyChangeHandler", event )
	local style = event.target
	local etype= event.type
	local property= event.property
	local value = event.value

	-- print( "Style Changed", etype, property, value )

	if etype == style.STYLE_RESET then
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

		property = etype

	else
		if property=='width' then
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
