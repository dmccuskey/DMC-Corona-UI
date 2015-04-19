--====================================================================--
-- dmc_ui/dmc_widget/widget_text.lua
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
--== DMC Corona UI : Text Widget
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
--== DMC UI : newText
--====================================================================--



--====================================================================--
--== Imports


local Objects = require 'dmc_objects'

local uiConst = require( ui_find( 'ui_constants' ) )

local WidgetBase = require( ui_find( 'core.widget' ) )



--====================================================================--
--== Setup, Constants


local newClass = Objects.newClass

local ssub = string.sub

--== To be set in initialize()
local dUI = nil
local FontMgr = nil



--====================================================================--
--== Support Functions


local function testTextLength( text, params )
	-- print( "Text:testTextLength", text, params.width )
	local w = params.width
	local _ssub = ssub
	local o = display.newText{
		text=text,
		font=params.font,
		fontSize=params.fontSize
	}
	local tw = o.width
	o:removeSelf()
	if tw < w then return text end

	local cnt = 0
	local prev = '...'
	while true do
		local t = ssub( text, 0, cnt )..'...'
		local o = display.newText{
			text=t,
			font=params.font,
			fontSize=params.fontSize
		}
		local tw = o.width
		o:removeSelf()
		if tw <= w then
			cnt = cnt + 1 ;	prev = t
		else
			break
		end
	end
	return prev
end



--====================================================================--
--== Text Widget Class
--====================================================================--


--- Text Widget Module.
-- at the core, the DMC Text Widget wraps a Corona Text widget to provide its functionality. this gives us more consistent behavior! (w00t!)
--
-- @classmod Widget.Text
-- @usage
-- local dUI = require 'dmc_ui'
-- local widget = dUI.newText()

local Text = newClass( WidgetBase, { name="Text Widget" } )

--- Class Constants.
-- @section

--== Class Constants

Text.LEFT = 'left'
Text.CENTER = 'center'
Text.RIGHT = 'right'

--== Style/Theme Constants

Text.STYLE_CLASS = nil -- added later
Text.STYLE_TYPE = uiConst.TEXT

-- TODO: hook up later
-- Text.DEFAULT = 'default'

-- Text.THEME_STATES = {
-- 	Text.DEFAULT,
-- }

--== Event Constants

Text.EVENT = 'text-widget-event'


--======================================================--
-- Start: Setup DMC Objects

--== Init

function Text:__init__( params )
	-- print( "Text:__init__", params )
	params = params or {}
	if params.text==nil then params.text="" end

	self:superCall( '__init__', params )
	--==--

	--== Create Properties ==--

	-- properties in this class

	self._text = params.text
	self._text_dirty=true

	-- properties from style

	-- virtual
	self._displayWidth_dirty=true
	self._displayHeight_dirty=true
	self._rectBgWidth_dirty=true
	self._rectBgHeight_dirty=true

	self._align_dirty=true
	self._fillColor_dirty = true
	self._font_dirty=true
	self._fontSize_dirty=true
	self._marginX_dirty=true
	self._marginY_dirty=true
	self._strokeColor_dirty=true
	self._strokeWidth_dirty=true

	self._textColor_dirty=true
	self._textObject_dirty=true

	-- virtual
	self._textX_dirty=true
	self._textY_dirty=true

	--== Object References ==--

	self._txtText = nil -- our text object
	self._rectBg = nil -- our background object

end

--[[
function Text:__undoInit__()
	-- print( "Text:__undoInit__" )
	--==--
		self:superCall( '__undoInit__' )
end
--]]

--== createView

function Text:__createView__()
	-- print( "Text:__createView__" )
	self:superCall( '__createView__' )
	--==--
	local o = display.newRect( 0,0,0,0 )
	o.anchorX, o.anchorY = 0.5, 0.5
	self:insert( o )
	self._rectBg = o
end

function Text:__undoCreateView__()
	-- print( "Text:__undoCreateView__" )
	self._rectBg:removeSelf()
	self._rectBg=nil
	--==--
	self:superCall( '__undoCreateView__' )
end

--== initComplete

--[[
function Text:__initComplete__()
	-- print( "Text:__initComplete__" )
	self:superCall( '__initComplete__' )
	--==--
end
--]]

function Text:__undoInitComplete__()
	--print( "Text:__undoInitComplete__" )
	self:_removeText()
	--==--
	self:superCall( '__undoInitComplete__' )
end

-- END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Static Methods


function Text.initialize( manager )
	-- print( "Text.initialize" )
	dUI = manager
	local Widget = nil

	FontMgr = dUI.FontMgr

	local Style = dUI.Style
	Text.STYLE_CLASS = Style.Text

	Style.registerWidget( Text )
end



--====================================================================--
--== Public Methods


--[[
Inherited Methods
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
-- local wStyle = dUI.newTextStyle()
-- widget.style = wStyle


--- clear any local properties on style.
-- convenience method, calls clearProperties() on active style.
--
-- @within Methods
-- @function :clearStyle
-- @usage widget:clearStyle()


--- set/get align.
-- values are 'left', 'center', 'right'
--
-- @within Properties
-- @function .align
-- @usage widget.align = 'center'
-- @usage print( widget.align )

--- set/get font.
-- can either be Corona font (eg, native.systemFont) or one installed in system (eg, 'Helvetica-Grande')
--
-- @within Properties
-- @function .font
-- @usage widget.font = native.systemFont
-- @usage print( widget.font )

--- set/get fontSize.
-- set the font size of the text.
--
-- @within Properties
-- @function .fontSize
-- @usage widget.fontSize = 18
-- @usage print( widget.fontSize )

--- set/get marginX.
-- set the margin inset of the widget. this value is *subtracted* from the widget width.
--
-- @within Properties
-- @function .marginX
-- @usage widget.marginX = 18
-- @usage print( widget.marginX )


--- set/get strokeWidth.
-- set stroke width for the simple background.
--
-- @within Properties
-- @function .strokeWidth
-- @usage widget.strokeWidth = 18
-- @usage print( widget.strokeWidth )


--- set the fill color of the simple background.
--
-- @within Methods
-- @function :setFillColor
-- @usage
-- widget:setFillColor( grey )
-- widget:setFillColor( grey, a )
-- widget:setFillColor( r, g, b, a )
-- widget:setFillColor( gradient )

--- set stroke color of the simple background.
--
-- @within Methods
-- @function :setStrokeColor
-- @usage
-- widget:setStrokeColor( grey )
-- widget:setStrokeColor( grey, a )
-- widget:setStrokeColor( r, g, b, a )
-- widget:setStrokeColor( gradient )

--- set color of text.
--
-- @within Methods
-- @function :setTextColor
-- @usage
-- widget:setTextColor( grey )
-- widget:setTextColor( grey, a )
-- widget:setTextColor( r, g, b, a )
-- widget:setTextColor( gradient )




--[[
we use custom getters for width/height
without width/height, we just use dimensions
from text object after creation
--]]

--== .width (custom)

--- set/get width.
-- Note: this property changes both the width of the DMC Text Widget and the encapsulated Corona Text widget. If the style is unset, then the width value is the width of the encapsulated Corona Text widget. If the style value is set, then then the width for both changes to that value.
--
-- @within Properties
-- @function .width
-- @usage widget.width = 5
-- @usage print( widget.width )

function Text.__getters:width()
	-- print( 'Text.__getters:width' )
	local style = self.curr_style
	-- local mX = style.marginX*2
	local w, t = style.width, self._txtText
	if w==nil and t then w=t.width end
	-- return w+mX
	return w
end
function Text.__setters:width( value )
	-- print( 'Text.__setters:width', value )
	self.curr_style.width = value
end

--== .height (custom)

--- set/get height.
-- Note: this property *doesn't* change the height of the actual *Corona Text widget*, that remains constant. If the style is unset, then the height value is the height of the encapsulated Corona Text widget. If the style value is set, then then the height is that value, even if the height of the Corona Text widget is different. (If the height of the Corona Text widget is set then it becomes a multi-line text widget.)
--
-- @within Properties
-- @function .height
-- @usage widget.height = 5
-- @usage print( widget.height )

function Text.__getters:height()
	-- print( 'Text.__getters:height' )
	local h, t = self.curr_style.height, self._txtText
	if h==nil and t then h=t.height end
	return h
end
function Text.__setters:height( value )
	-- print( 'Text.__setters:height', value )
	self.curr_style.height = value
end

--== .text

--- set/get widget text.
--
-- @within Properties
-- @function .text
-- @usage widget.text = 5
-- @usage print( widget.text )

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



--- get height of Corona Text object.
-- return the height of the encapsulated Corona text object, not height of the DMC Text Widget. returns 0 if Corona Text has yet to be created.
--
-- @within Methods
-- @function :getTextHeight
-- @treturn number height of Corona Text object
-- @usage print( widget:getTextHeight() )

function Text:getTextHeight()
	-- print( "Text:getTextHeight", self._txtText )
	local val = 0
	local o = self._txtText
	if o then val = o.height end
	return val
end



--====================================================================--
--== Private Methods


function Text:_removeText()
	-- print( "Text:_removeText" )
	local o = self._txtText
	if not o then return end
	o:removeSelf()
	self._txtText = nil
end

function Text:_createText()
	-- print( "Text:_createText" )
	local style = self.curr_style
	local o -- object

	self:_removeText()

	local w, h = style.width, style.height
	local text = self._text
	if w ~= nil then
		w = w - style.marginX*2
		text = testTextLength( text, {
			width=w, font=style.font, fontSize=style.fontSize
		})
	end
	o = display.newText{
		x=0, y=0,

		width=w,
		-- don't use height, turns into multi-line
		height=nil,

		text=text,
		align=style.align,
		font=style.font,
		fontSize=style.fontSize,
	}

	self:insert( o )
	self._txtText = o

	--== Reset properties

	self._x_dirty=true
	self._y_dirty=true
	self._width_dirty=true
	self._height_dirty=true

	self._text_dirty=false
	self._textColor_dirty=true
end


function Text:__commitProperties__()
	-- print( 'Text:__commitProperties__' )
	local style = self.curr_style
	-- local metric = FontMgr:getFontMetric( style.font, style.fontSize )
	-- metric={offsetX=0,offsetY=0}

	if self._width_dirty then
		self._width_dirty=false

		self._anchorX_dirty=true
		self._displayWidth_dirty=true
		self._rectBgWidth_dirty=true
		self._textObject_dirty=true
	end
	if self._height_dirty then
		self._height_dirty=false

		self._anchorY_dirty=true
		self._displayHeight_dirty=true
		self._rectBgHeight_dirty=true
	end

	-- create new text if necessary
	if self._align_dirty or self._font_dirty or self._fontSize_dirty or self._textObject_dirty then
		self:_createText()
		self._align_dirty=false
		self._font_dirty=false
		self._fontSize_dirty=false
		self._textObject_dirty=false
	end

	local view = self.view
	local bg = self._rectBg
	local txt = self._txtText

	--== position sensitive

	-- set text string

	if self._text_dirty then
		self._text_dirty=false
	end

	if self._marginX_dirty then
		self._marginX_dirty=false

		self._displayWidth_dirty=true
		self._rectBgWidth_dirty=true
		self._textX_dirty=true
	end
	if self._marginY_dirty then
		--== Reminder, we don't set text height ==--
		self._marginY_dirty=false

		self._displayHeight_dirty=true
		self._rectBgHeight_dirty=true
		self._textY_dirty=true
	end

	-- bg width/height

	if self._rectBgWidth_dirty then
		bg.width = self.width -- use getter
		self._rectBgWidth_dirty=false
	end
	if self._rectBgHeight_dirty then
		bg.height = self.height -- use getter
		self._rectBgHeight_dirty=false
	end

	if self._displayWidth_dirty then
		self._displayWidth_dirty=false
	end
	if self._displayHeight_dirty then
		--== !! DO NOT SET HEIGHT OF TEXT !! ==--
		--[[
		-- -- txt.height = self.height
		--]]
		self._displayHeight_dirty=false
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
		local w = style.width
		local width = self.width -- use getter, it's smart
		local offset
		if align == self.LEFT then
			txt.anchorX = 0
			offset = -width*(style.anchorX)
			if w~=nil then
				offset = offset+style.marginX
			end
			txt.x=offset
		elseif align == self.RIGHT then
			txt.anchorX = 1
			offset = width*(1-style.anchorX)
			if w~=nil then
				offset = offset-style.marginX
			end
			txt.x=offset
		else
			txt.anchorX = 0.5
			offset = width*(0.5-style.anchorX)
			txt.x=offset
		end
		self._textX_dirty = false
	end

	if self._textY_dirty then
		local height = self.height -- use getter
		local offset
		txt.anchorY = 0.5
		offset = height/2-height*(style.anchorY)
		txt.y=offset
		self._textY_dirty=false
	end


	--== non-position sensitive

	-- textColor/fillColor

	if self._fillColor_dirty or self._debugOn_dirty then
		if style.debugOn==true then
			bg:setFillColor( 1,0,0,0.2 )
		else
			bg:setFillColor( unpack( style.fillColor ))
		end
		self._fillColor_dirty=false
		self._debugOn_dirty=false
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
		txt:setTextColor( unpack( style.textColor ) )
		self._textColor_dirty=false
	end

end



--====================================================================--
--== Event Handlers


function Text:stylePropertyChangeHandler( event )
	-- print( "Text:stylePropertyChangeHandler", event.type, event.property )
	local style = event.target
	local etype= event.type
	local property= event.property
	local value = event.value

	-- print( "Style Changed", etype, property, value )

	if etype==style.STYLE_RESET then
		self._debugOn_dirty = true
		self._width_dirty=true
		self._height_dirty=true
		self._anchorX_dirty=true
		self._anchorY_dirty=true

		self._align_dirty=true
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

		elseif property=='align' then
			self._align_dirty=true
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
