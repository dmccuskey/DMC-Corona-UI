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

-- these are set later
local Widgets = nil
local FontMgr = nil



--====================================================================--
--== Setup, Constants


-- setup some aliases to make code cleaner
local newClass = Objects.newClass
local ComponentBase = Objects.ComponentBase

local LifecycleMix = LifecycleMixModule.LifecycleMix

local tinsert = table.insert
local tremove = table.remove

local LOCAL_DEBUG = true

assert( LifecycleMix )


--====================================================================--
--== Text Widget Class
--====================================================================--


local Text = newClass( {ComponentBase,LifecycleMix}, {name="Text"}  )

--== Class Constants

Text.DEFAULT_TEXTCOLOR = {0,0,0,1}
Text.DEFAULT_FILLCOLOR = {0,0,0,0}

Text.RIGHT = 'right'
Text.CENTER = 'center'
Text.LEFT = 'left'

Text.TOP = 'top'
Text.BOTTOM = 'bottom'


--======================================================--
--== Start: Setup DMC Objects

--== Init

function Text:__init__( params )
	-- print( "Text:__init__", params )
	params = params or {}
	if params.x==nil then params.x=0 end
	if params.y==nil then params.y=0 end
	if params.align==nil then params.align=self.CENTER end
	if params.textColor==nil then params.textColor=self.DEFAULT_TEXTCOLOR end
	if params.fillColor==nil then params.fillColor=self.DEFAULT_FILLCOLOR end
	if params.marginX==nil then params.marginX=0 end
	if params.marginY==nil then params.marginY=0 end
	self:superCall( LifecycleMix, '__init__', params )
	self:superCall( ComponentBase, '__init__', params )
	--==--

	--== Sanity Check ==--

	if self.is_class then return end

	assert( params.text, "Text: requires param 'text'" )
	assert( params.font, "Text: requires param 'font'" )
	assert( params.fontSize, "Text: requires param 'fontSize'" )

	--== Create Properties ==--

	-- required params
	self._text = params.text
	self._text_dirty=true
	self._font = params.font
	self._font_dirty=true
	self._fontSize = params.fontSize
	self._fontSize_dirty=true

	-- optional params
	self._parent = params.parent

	self._x = params.x
	self._x_dirty = true
	self._y = params.y
	self._y_dirty=true

	self._width = params.width
	self._width_dirty=true
	self._height = params.height
	self._height_dirty=true

	self._align = params.align
	self._align_dirty=true

	-- other
	self._anchorX = 0.5
	self._anchorX_dirty=true
	self._anchorY = 0.5
	self._anchorY_dirty=true

	self._bg_width_dirty=true
	self._bg_height_dirty=true

	self._bg_marginX = params.marginX
	self._bg_marginY = params.marginY

	self._fillColor = params.fillColor
	self._fillColor_dirty = true

	self._textColor = params.textColor
	self._textColor_dirty = true

	--== Object References ==--

	self._newtext = nil -- our text object
	self._bg = nil -- our background object

end

function Text:__undoInit__()
	-- print( "Text:__undoInit__" )
	--==--
	self:superCall( ComponentBase, '__undoInit__' )
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
	self:__commitProperties__()
end

function Text:__undoInitComplete__()
	--print( "Text:__undoInitComplete__" )
	self:_removeNewText()
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
end



--====================================================================--
--== Public Methods


--== X

function Text.__setters:x( value )
	-- print( 'Text.__setters:x', value )
	assert( type(value)=='number' )
	--==--
	if value == self._x then return end
	self._x = value
	self._x_dirty=true
	self:__invalidateProperties__()
end


--== Y

function Text.__setters:y( value )
	-- print( 'Text.__setters:y', value )
	assert( type(value)=='number' )
	--==--
	if value == self._y then return end
	self._y = value
	self._y_dirty=true
	self:__invalidateProperties__()
end


--== marginX

function Text.__setters:marginX( value )
	-- print( 'Text.__setters:marginX', value )
	assert( type(value)=='number' )
	if value < 0 then value=0 end
	--==--
	if value == self._bg_marginX then return end
	self._bg_marginX = value
	self._bg_width_dirty=true
	self:__invalidateProperties__()
end


--== marginY

function Text.__setters:marginY( value )
	-- print( 'Text.__setters:marginY', value )
	assert( type(value)=='number' )
	if value < 0 then value=0 end
	--==--
	if value == self._bg_marginY then return end
	self._bg_marginY = value
	self._bg_height_dirty=true
	self:__invalidateProperties__()
end


--== align

function Text.__getters:align()
	return self._align
end
function Text.__setters:align( value )
	-- print( 'Text.__setters:align', value )
	assert( type(value)=='string' )
	if self._align == value then return end
	self._align = value
	self._align_dirty = true
	self:__invalidateProperties__()
end


--== anchorX

function Text.__getters:anchorX()
	return self._anchorX
end
function Text.__setters:anchorX( value )
	-- print( 'Text.__setters:anchorX', value )
	assert( type(value)=='number' )
	--==--
	if value==self._anchorX then return end
	self._anchorX = value
	self._anchorX_dirty=true
	self._text_alignX_dirty=true
	self:__invalidateProperties__()
end


--== anchorY

function Text.__getters:anchorY()
	return self._anchorY
end
function Text.__setters:anchorY( value )
	-- print( 'Text.__setters:anchorY', value )
	assert( type(value)=='number' )
	--==--
	if value==self._anchorY then return end
	self._anchorY = value
	self._anchorY_dirty=true
	self:__invalidateProperties__()
end


--== setAnchor

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


--== font

function Text.__getters:font()
	return self._font
end
function Text.__setters:font( value )
	-- print( 'Text.__setters:font', value )
	assert( value )
	--==--
	if value==self._font then return end
	self._font = value
	self._font_dirty=true
	self:__invalidateProperties__()
end

--== fontSize

function Text.__getters:fontSize()
	return self._fontSize
end
function Text.__setters:fontSize( value )
	-- print( 'Text.__setters:fontSize', value )
	assert( type(value)=='number' )
	--==--
	if value==self._fontSize then return end
	self._fontSize = value
	self._fontSize_dirty=true
	self:__invalidateProperties__()
end


--== width

function Text.__getters:width()
	local t, w = self._newtext, self._width
	if w==nil and t then w=t.width end
	return w
end
function Text.__setters:width( value )
	-- print( 'Text.__setters:width', value )
	assert( value==nil or type(value)=='number' )
	--==--
	if value==self._width then return end
	self._width = value
	self._width_dirty=true
	self._bg_width_dirty=true
	self._text_alignX_dirty=true
	self:__invalidateProperties__()
end


--== height

function Text.__getters:height()
	local t, h = self._newtext, self._height
	if h==nil and t then h=t.height end
	return h
end
function Text.__setters:height( value )
	-- print( 'Text.__setters:height', value )
	assert( value==nil or type(value)=='number' )
	--==--
	if value==self._height then return end
	self._height = value
	self._height_dirty=true
	self._bg_height_dirty=true
	self:__invalidateProperties__()
end


--== text

function Text.__getters:text()
	return self._text
end
function Text.__setters:text( value )
	-- print( 'Text.__setters:text', value )
	if value == self._text then return end
	self._text = value
	self._text_dirty=true
	self:__invalidateProperties__()
end

function Text.__getters:textHeight()
	return self._newtext.height
end


--== setTextColor

function Text:setTextColor( ... )
	-- print( 'Text:setTextColor' )
	--==--
	self._textColor = {...}
	self._textColor_dirty = true
	self:__invalidateProperties__()
end


--== setFillColor

function Text:setFillColor( ... )
	-- print( 'Text:setFillColor' )
	--==--
	self._fillColor = {...}
	self._fillColor_dirty = true
	self:__invalidateProperties__()
end



--====================================================================--
--== Private Methods


function Text:_updateTextProperties()
	-- CAN OVERRIDE FOR CUSTOM TEXT HANDLING
end


function Text:_removeNewText()
	-- print( 'Text:_removeNewText' )
	local o = self._newtext
	if o then
		o:removeSelf()
		self._newtext = nil
	end
end

function Text:_createNewText()
	-- print( 'Text:_createNewText' )
	local o -- object

	self:_removeNewText()
	self:_updateTextProperties()

	local w = self._width
	if w~=nil then
		w=w-self._bg_marginX*2
	end

	o = display.newText{
		parent=self._parent,

		text=self._text,
		fontSize=self._fontSize,

		x=0,
		y=0,
		width=w,
		height=nil,

		align=self._align
	}

	self:insert( o )
	self._newtext = o

	-- can't reset these
	self._font_dirty=false
	self._fontSize_dirty=false

	self._width_dirty=false
	self._height_dirty=false
	self._align_dirty=false

	--== reset our text object

	self._text_dirty=false

	self._textColor_dirty=true
	self._anchorX_dirty=true
	self._anchorY_dirty=true

end


function Text:__commitProperties__()
	-- print( 'Text:__commitProperties__' )

	-- create new text if necessary
	if self._font_dirty or self._align_dirty or self._fontSize_dirty then
		self:_createNewText()
	end

	local view = self.view
	local bg = self._bg
	local text = self._newtext
	local metric = FontMgr:getFontMetric( self._font, self._fontSize )

	-- set text string

	if self._text_dirty then
		text.text = self._text
		self._text_dirty=false
		self._anchorX_dirty=true
		self._anchorY_dirty=true
	end

	-- textColor/fillColor

	if self._textColor_dirty then
		text:setTextColor( unpack( self._textColor ) )
		self._textColor_dirty=false
	end
	if self._fillColor_dirty then
		bg:setFillColor( unpack( self._fillColor ))
		self._fillColor_dirty=false
	end

	-- anchorX/anchorY

	if self._anchorX_dirty then
		view.anchorX = self._anchorX
		bg.anchorX = self._anchorX
		self._anchorX_dirty=false
		self._x_dirty=true
	end
	if self._anchorY_dirty then
		view.anchorY = self._anchorY
		bg.anchorY = self._anchorY
		self._anchorY_dirty=false
		self._y_dirty=true
	end

	-- x/y

	if self._x_dirty then
		view.x = self._x
		bg.x = metric.offsetX
		local offset = bg.width*(0.5-bg.anchorX)
		text.x = bg.x+offset
		self._x_dirty = false
		self._text_alignX_dirty=true
	end
	if self._y_dirty then
		view.y = self._y
		bg.y = metric.offsetY
		local offset = bg.height*(0.5-bg.anchorY)
		text.y = bg.y+offset
		self._y_dirty = false
		self._text_alignY_dirty=true
	end

	-- bg width/height

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

	if self._text_alignX_dirty then
		local offset
		if self._align == self.LEFT then
			text.anchorX = 0
			offset = -bg.width*(bg.anchorX)+self._bg_marginX
			text.x=bg.x+offset
		elseif self._align == self.RIGHT then
			text.anchorX = 1
			offset = bg.width*(1-bg.anchorX)-self._bg_marginX
			text.x=bg.x+offset
		else
			text.anchorX = 0.5
			offset = bg.width*(0.5-bg.anchorX)
			text.x=bg.x+offset
		end
		self._text_alignX_dirty = false
	end

	if self._text_alignX_dirty then
		self._text_alignY_dirty=false
	end

end



--====================================================================--
--== Event Handlers


-- none



return Text
