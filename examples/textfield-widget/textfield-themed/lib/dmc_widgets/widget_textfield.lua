--====================================================================--
-- dmc_widgets/widget_textfield.lua
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
--== DMC Corona Widgets : Widget TextField Field
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
--== DMC Widgets : newTextField
--====================================================================--



--====================================================================--
--== Imports


local Objects = require 'dmc_objects'
local Utils = require 'dmc_utils'
local LifecycleMixModule = require 'dmc_lifecycle_mix'
local ThemeMixModule = require( dmc_widget_func.find( 'widget_theme_mix' ) )

-- set later
local Widgets = nil
local ThemeMgr = nil



--====================================================================--
--== Setup, Constants


-- setup some aliases to make code cleaner
local newClass = Objects.newClass
local ComponentBase = Objects.ComponentBase

local LifecycleMix = LifecycleMixModule.LifecycleMix
local ThemeMix = ThemeMixModule.ThemeMix

local LOCAL_DEBUG = false



--====================================================================--
--== TextField Widget Class
--====================================================================--


local TextField = newClass( {ThemeMix,ComponentBase,LifecycleMix}, {name="TextField"}  )

--== Class Constants

-- alignment
TextField.LEFT = 'left'
TextField.CENTER = 'center'
TextField.RIGHT = 'right'

-- background styles
TextField.BORDER_STYLE_NONE = 'border-style-none'
TextField.BORDER_STYLE_LINE = 'border-style-line'
TextField.BORDER_STYLE_ROUNDED = 'border-style-rounded'
TextField.BORDER_IMAGE = 'border-style-rounded'

-- keyboard
TextField.INPUT_DEFAULT = 'default'
TextField.INPUT_DECIMAL = 'decimal'
TextField.INPUT_EMAIL = 'email'
TextField.INPUT_NUMBER = 'number'
TextField.INPUT_PASSWORD = 'password'
TextField.INPUT_PHONE = 'phone'
TextField.INPUT_URL = 'url'

-- return key
TextField.RETURN_DEFAULT = 'default'
TextField.RETURN_DONE = 'done'
TextField.RETURN_EMERGENCY = 'emergencyCall'
TextField.RETURN_GO = 'go'
TextField.RETURN_JOIN = 'join'
TextField.RETURN_NEXT = 'next'
TextField.RETURN_NONE = 'none'
TextField.RETURN_ROUTE = 'route'
TextField.RETURN_SEARCH = 'search'
TextField.RETURN_SEND = 'send'

-- visual styles
TextField.STYLE_DEFAULT = 'default'
TextField.STYLE_DISABLED = 'disabled'
TextField.STYLE_INVALID = 'invalid'

TextField.TOP = 'top'
TextField.BOTTOM = 'bottom'

--== Theme Constants

TextField.THEME_ID = 'textfield'
TextField.STYLE_CLASS = nil -- added later

-- TODO: hook up later
-- Text.DEFAULT = 'default'

-- Text.THEME_STATES = {
-- 	Text.DEFAULT,
-- }

--== Event Constants

TextField.EVENT = 'userInput'

TextField.BEGAN = 'began'
TextField.ENDED = 'ended'
TextField.SUBMITTED = 'submitted'
TextField.EDITING = 'editing'


--======================================================--
--== Start: Setup DMC Objects

--== Init

function TextField:__init__( params )
	-- print( "TextField:__init__", params )
	params = params or {}
	if params.x==nil then params.x=0 end
	if params.y==nil then params.y=0 end
	if params.text==nil then params.text="" end
	if params.hintText==nil then params.hintText="" end

	self:superCall( LifecycleMix, '__init__', params )
	self:superCall( ComponentBase, '__init__', params )
	self:superCall( ThemeMix, '__init__', params )
	--==--

	--== Create Properties ==--

	-- properties in this class

	self._text = params.text
	self._text_dirty=true

	self._hint_text = params.hintText
	self._displayText_dirty=true

	self._x = params.x
	self._x_dirty=true
	self._y = params.y
	self._y_dirty=true

	-- properties for style

	self._width_dirty=true
	self._height_dirty=true

	self._align_dirty=true
	-- virtual
	self._inputAlign_dirty=true

	self._bgAnchorX_dirty=true
	self._bgAnchorY_dirty=true

	self._hasBackground = false -- << hard coded
	self._hasBackground_dirty = true
	self._inputType_dirty = true
	self._marginX_dirty=true
	self._marginY_dirty=true
	self._returnKey_dirty=true

	self._clear_onBeginEdit = false
	self._adjust_fontToFit = false
	self._clearButton_mode = 'never'

	--== Text-level
	-- align
	self._textColor_dirty = true
	self._font_dirty=true
	self._fontSize_dirty=true

	--== Hint-level
	-- align?
	self._textDisplayFont_dirty = true
	self._textDisplayFontSize_dirty = true
	self._textDisplayColor_dirty = true

	--== Background-level
	self._bgStyle_dirty=true

	--== Internal

	self._keyboardFocus=false
	self._keyboardFocus_dirty=true
	self._keyboardFocus_timer=nil

	self._is_enabled = true

	self._is_editing = { state=false, set_focus=nil }
	self._editActive_dirty = true

	self._is_valid = true
	self._value = nil

	--== Object References ==--

	self._delegate = nil -- delegate
	self._formatter = nil -- data formatter

	self._tmp_style = params.style -- save

	self._bg = nil -- background object
	self._bg_dirty = true
	self._textDisplay = nil -- text object (for both hint and value display)
	self._textDisplay_dirty = true
	self._textfield = nil -- textfield object
	self._textfield_f = nil -- textfield handler

end

function TextField:__undoInit__()
	-- print( "TextField:__undoInit__" )
	--==--
	self:superCall( ThemeMix, '__undoInit__' )
	self:superCall( ComponentBase, '__undoInit__' )
	self:superCall( LifecycleMix, '__undoInit__' )
end


--== createView

function TextField:__createView__()
	-- print( "TextField:__createView__" )
	self:superCall( ComponentBase, '__createView__' )
	--==--
end

function TextField:__undoCreateView__()
	-- print( "TextField:__undoCreateView__" )
	self:_removeNewTextField()
	--==--
	self:superCall( ComponentBase, '__undoCreateView__' )
end


--== initComplete

function TextField:__initComplete__()
	-- print( "TextField:__initComplete__" )
	self:superCall( ComponentBase, '__initComplete__' )
	--==--
	self._textfield_f = self:createCallback( self._textFieldEvent_handler )

	--[[
	self._textDisplay.onUpdate = self:createCallback( self._textOnUpdateEvent_handler )
	--]]

	self._bg_f = self:createCallback( self._backgroundTouch_handler )

	print("\n\n another setup here\n")
	self.style = self._tmp_style
	self:_stopEdit(false)

	self._is_rendered = true
end

function TextField:__undoInitComplete__()
	--print( "TextField:__undoInitComplete__" )
	self._is_rendered = false

	self:_removeTextField()

	self._bg_f = nil

	self._textDisplay.onUpdate = nil

	self:_stopKeyboardFocus()

	self._textfield_f = nil

	self.style = nil

	--==--
	self:superCall( ComponentBase, '__undoInitComplete__' )
end

--== END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Static Methods


function TextField.initialize( manager )
	-- print( "TextField.initialize" )
	Widgets = manager
	ThemeMgr = Widgets.ThemeMgr
	ThemeMgr = Widgets.ThemeMgr
	TextField.STYLE_CLASS = Widgets.Style.TextField

	ThemeMgr:registerWidget( TextField.THEME_ID, TextField )
end



--====================================================================--
--== Public Methods




--== X

function TextField.__getters:x()
	return self._x
end
function TextField.__setters:x( value )
	-- print( 'TextField.__setters:x', value )
	assert( type(value)=='number' )
	--==--
	self._x = value
	self._x_dirty=true
	self:__invalidateProperties__()
end

--== Y

function TextField.__getters:y()
	return self._y
end
function TextField.__setters:y( value )
	-- print( 'TextField.__setters:y', value )
	assert( type(value)=='number' )
	--==--
	self._y = value
	self._y_dirty=true
	self:__invalidateProperties__()
end


--== width (custom)

function TextField.__getters:width()
	-- print( 'TextField.__getters:width' )
	return self.curr_style.width
end
function TextField.__setters:width( value )
	print( 'TextField.__setters:width', value )
	local style=self.curr_style
	style.width = value
	style.background.width=value
	style.hint.width = value
	style.text.width = value
	self._width_dirty=true
	self:__invalidateProperties__()
end

--== height (custom)

function TextField.__getters:height()
	-- print( 'TextField.__getters:height' )
	return self.curr_style.height
end
function TextField.__setters:height( value )
	print( 'TextField.__setters:height', value )
	local style=self.curr_style
	style.height = value
	style.background.height=value
	style.hint.height = value
	style.text.height = value
	self._height_dirty=true
	self:__invalidateProperties__()
end


--== align

function TextField.__getters:align()
	-- print( 'TextField.__getters:align' )
	return self.curr_style.align
end
function TextField.__setters:align( value )
	-- print( 'TextField.__setters:align', value )
	local style=self.curr_style
	style.align = value
	style.hint.align = value
	style.text.align = value
end

--== anchorX

function TextField.__getters:anchorX()
	-- print( 'TextField.__getters:anchorX' )
	return self.curr_style.anchorX
end
function TextField.__setters:anchorX( value )
	-- print( 'TextField.__setters:anchorX', value )
	local style=self.curr_style
	style.anchorX = value
	style.background.anchorX = value
	style.hint.anchorX = value
	style.text.anchorX = value
end

--== anchorY

function TextField.__getters:anchorY()
	-- print( 'TextField.__getters:anchorY' )
	return self.curr_style.anchorY
end
function TextField.__setters:anchorY( value )
	-- print( 'TextField.__setters:anchorY', value )
	local style=self.curr_style
	style.anchorY = value
	style.background.anchorY = value
	style.hint.anchorY = value
	style.text.anchorY = value
end





--== TextField

function TextField.__getters:text()
	return self._text
end
function TextField.__setters:text( value )
	print( 'TextField.__setters:text', value )
	assert( type(value)=='string' )
	--==--
	self._text = value
	self._text_dirty=true
	self._displayStyle_dirty=true
	self:__invalidateProperties__()
end


--== TextField

function TextField.__getters:isEditing()
	return self._is_editing.state
end

function TextField:setEditActive( value, params )
	print( 'TextField:setEditActive', value )
	params = params or {}
	if params.set_focus==nil then params.set_focus=true end
	assert( type(value)=='boolean' )
	--==--
	params.state=value
	self._is_editing = params
	self._editActive_dirty = true
	self:__invalidateProperties__()
end



--== formatter

function TextField.__setters:formatter( value )
	-- print( 'TextField.__setters:formatter', value )
	assert( value )
	--==--
	self._formatter = value
end




--== isValid

function TextField.__setters:isValid( value )
	-- print( 'TextField.__setters:isValid', value )
	assert( type(value)=='boolean' )
	--==--
	if value == self._is_valid then return end
	self._is_valid = value
	self._valid_dirty=true
	self:__invalidateProperties__()
end

--== marginX

function TextField.__getters:marginX( value )
	return self.curr_style.marginX
end
function TextField.__setters:marginX( value )
	-- print( 'TextField.__setters:marginX', value )
	local style=self.curr_style
	style.marginX = value
	style.hint.marginX = value
	style.text.marginX = value
end

--== marginY

function TextField.__getters:marginY( value )
	return self.curr_style.marginY
end
function TextField.__setters:marginY( value )
	-- print( 'TextField.__setters:marginY', value )
	local style=self.curr_style
	style.marginY = value
	style.hint.marginY = value
	style.text.marginY = value
end


--== text

function TextField.__getters:text()
	return self._text
end
function TextField.__setters:text( value )
	-- print( 'TextField.__setters:text', value )
	if value == self._text then return end
	self._text = value
	self._text_dirty=true
	self._displayText_dirty=true
	self:__invalidateProperties__()
end

function TextField.__getters:hintText()
	return self._hint_text
end
function TextField.__setters:hintText( value )
	-- print( 'TextField.__setters:hintText', value )
	if value == self._hint_text then return end
	self._hint_text = value
	self._displayText_dirty=true
	self:__invalidateProperties__()
end



--== setKeyboardFocus

function TextField:setKeyboardFocus()
	-- print( 'TextField:setKeyboardFocus' )
	self._keyboardFocus = true
	self._keyboardFocus_dirty = true
	self:__invalidateProperties__()
end

function TextField:unsetKeyboardFocus()
	-- print( 'TextField:unsetKeyboardFocus' )
	self._keyboardFocus = false
	self._keyboardFocus_dirty = true
	self:__invalidateProperties__()
end


--== setReturnKey

function TextField:setReturnKey( value )
	-- print( 'TextField:setReturnKey', value )
	assert( type(value)=='string' )
	--==--
	if value==self._returnKey then return end
	--==--
	self._returnKey = value
	self._returnKey_dirty = true
	self:__invalidateProperties__()
end


--== Background Style Methods ==--

--== backgroundStrokeWidth

function TextField.__getters:backgroundStrokeWidth()
	return self.curr_style.background.strokeWidth
end
function TextField.__setters:backgroundStrokeWidth( value )
	-- print( 'TextField.__setters:backgroundStrokeWidth', value )
	self.curr_style.background.strokeWidth = value
end

--== setBackgroundFillColor

function TextField:setBackgroundFillColor( ... )
	-- print( 'TextField:setBackgroundFillColor' )
	self.curr_style.background.fillColor = {...}
end

--== setBackgroundStrokeColor

function TextField:setBackgroundStrokeColor( ... )
	-- print( 'TextField:setBackgroundStrokeColor' )
	self.curr_style.background.strokeColor = {...}
end



--== Hint Style Methods ==--

function TextField.__setters:hintFont( value )
	-- print( 'TextField.__setters:hintFont', value )
	self.curr_style.hint.font = value
end

function TextField.__setters:hintFontSize( value )
	-- print( 'TextField.__setters:hintFontSize', value )
	self.curr_style.hint.fontSize = value
end

function TextField:setHintColor( ... )
	-- print( 'TextField:setHintColor' )
	self.curr_style.hint.textColor = {...}
end


--== Text Style Methods ==--

function TextField.__setters:textFont( value )
	-- print( 'TextField.__setters:textFont', value )
	self.curr_style.text.font = value
end

function TextField.__setters:textFontSize( value )
	-- print( 'TextField.__setters:textFontSize', value )
	self.curr_style.text.fontSize = value
end

function TextField:setTextColor( ... )
	-- print( 'TextField:setTextColor' )
	self.curr_style.text.textColor = {...}
end




--======================================================--
--== Delegate

function TextField:shouldBeginEditing()
	return self._is_enabled
end

-- on tap
function TextField:_delegateShouldBeginEditing()
	local delegate = self._delegate or self
	if not delegate or not delegate.shouldBeginEditing then
		delegate = self
	end
	return delegate:shouldBeginEditing()
end


function TextField:shouldEndEditing( event )
	return self._is_valid
end

-- after end/submit
function TextField:_delegateShouldEndEditing()
	local delegate = self._delegate or self
	if not delegate or not delegate.shouldEndEditing then
		delegate = self
	end
	return delegate:shouldEndEditing()
end


function TextField:shouldClearTextField()
	return true
end

-- on button press
function TextField:_delegateShouldClearTextField()
	local delegate = self._delegate
	if not delegate or not delegate.shouldClearTextField then
		delegate = self
	end
	return delegate:shouldClearTextField()
end


--======================================================--
--== Formatter

function TextField:areCharactersValid( chars, text )
	return true
end

function TextField:_formatterAreCharactersValid( chars, text )
	local formatter = self._formatter or self
	if not formatter or not formatter.areCharactersValid then
		delegate = self
	end
	return formatter:areCharactersValid( chars, text )
end


function TextField:isTextValid( text )
	return true
end

function TextField:_formatterIsTextValid( text )
	-- print( "_formatterIsTextValid", text)
	local formatter = self._formatter or self
	if not formatter or not formatter.isTextValid then
		delegate = self
	end
	return formatter:isTextValid( text )
end



--====================================================================--
--== Private Methods


function TextField:_removeBackground()
	-- print( "TextField:_removeBackground" )
	local o = self._bg
	if not o then return end
	o:removeEventListener( o.EVENT, self._bg_f )
	o:removeSelf()
	self._bg = nil
end

function TextField:_createBackground()
	-- print( "TextField:_createBackground" )

	self:_removeBackground()

	local o = Widgets.newBackground{}
	o:addEventListener( o.EVENT, self._bg_f )
	self:insert( o.view )
	self._bg = o

	-- conditions for coming in here
	self._bg_dirty = false

	--== reset our text field object

	self._bgStyle_dirty = true
	-- self._bgX_dirty = true
	-- self._bgY_dirty = true

end


function TextField:_removeText()
	-- print( "TextField:_removeText" )
	local o = self._textDisplay
	if not o then return end
	o:removeSelf()
	self._textDisplay = nil
end

function TextField:_createText()
	-- print( "TextField:_createText" )

	self:_removeText()

	local o = Widgets.newText()
	self:insert( o.view )
	self._textDisplay = o

	-- conditions for coming in here
	self._textDisplay_dirty=false

	--== reset our text field object

	self._displayStyle_dirty=true
	self._textDisplayIsVisible_dirty=true

	self._editActive_dirty = true


	-- self._x_dirty=true
	-- self._y_dirty=true

	-- self._text_dirty=true
	-- self._textColor_dirty=true
	-- self._inputAlign_dirty=true
	-- self._textX_dirty=true
	-- self._textY_dirty=true

	-- self._hasBackground_dirty=true
	-- self._keyboardFocus_dirty=true
end



function TextField:_removeTextField()
	-- print( "TextField:_removeTextField" )
	local o = self._textfield
	if not o then return end
	o:removeEventListener( 'userInput', self._textfield_f )
	o:removeSelf()
	self._textfield = nil
end

function TextField:_createTextField()
	-- print( "TextField:_createTextField" )
	local style = self.curr_style
	local o -- object

	self:_removeTextField()

	local w, h = style.width, style.height
	w = w - style.marginX*2
	h = h - style.marginY*2

	o = native.newTextField(0,0,w,h)
	self:insert( o )
	o:addEventListener( 'userInput', self._textfield_f )
	self._textfield = o

	-- conditions for coming in here
	self._width_dirty=false
	self._height_dirty=false

	--== reset our text field object

	self._x_dirty=true
	self._y_dirty=true

	self._editActive_dirty = true

	self._bgWidth_dirty=true

	self._text_dirty=true
	self._textColor_dirty=true
	self._inputAlign_dirty=true
	self._textX_dirty=true
	self._textY_dirty=true

	self._font_dirty=true
	self._fontSize_dirty=true
	self._hasBackground_dirty=true
	self._keyboardFocus_dirty=true
end


function TextField:__commitProperties__()
	-- print( 'TextField:__commitProperties__' )
	local style = self.curr_style

	if self._bg_dirty then
		self:_createBackground()
	end

	if self._textDisplay_dirty then
		self:_createText()
	end

	if self._width_dirty or self._height_dirty then
		self:_createTextField()
	end

	local view = self.view
	local bg = self._bg
	local display = self._textDisplay
	local input = self._textfield

	--== position sensitive

	--== View

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

	if self._align_dirty then
		self._align_dirty = false

		self._displayAlign_dirty=true
		self._inputAlign_dirty=true
	end

	if self._anchorX_dirty then
		-- view.y = self._y
		self._anchorX_dirty = false

		self._bgAnchorX_dirty=true
		self._textX_dirty=true
	end
	if self._anchorY_dirty then
		-- view.y = self._y
		self._anchorY_dirty = false

		self._bgAnchorY_dirty=true
		self._textY_dirty=true
	end

	self._editActive_dirty = true

	if self._editActive_dirty then
		local is_editing = self._is_editing
		local edit, set_focus = is_editing.state, is_editing.set_focus
		display.isVisible=not edit
		input.isVisible=edit
		if set_focus then
			local focus = input
			if not edit then focus=nil end
			native.setKeyboardFocus( focus )
		end
		self._editActive_dirty=false
	end

	--== Background

	if self._bgX_dirty then
		error("HERE IN _bgX_dirty")
		bg.x = self._x
		self._bgX_dirty=false
	end
	if self._bgStyle_dirty then
		print( "\n\n BACK STYLE SET", style.background, bg )
		bg:setActiveStyle( style.background, {copy=false} )
		print( ">>1", style.background.widget, bg )
		-- error("here")
		self._bgStyle_dirty=false
	end


	-- if self._bgfillColor_dirty then
	-- 	local color = style.background.fillColor
	-- 	bg:setFillColor( unpack( style.background.fillColor ))
	-- 	self._bgfillColor_dirty=false
	-- end
	-- if self._bgStrokeWidth_dirty then
	-- 	bg.strokeWidth = style.background.strokeWidth
	-- 	self._bgStrokeWidth_dirty=false
	-- end

	-- if self._bgAnchorX_dirty then
	-- 	bg.anchorX = style.background.anchorX
	-- 	self._bgAnchorX_dirty=false

	-- 	self._hintX_dirty=true
	-- end
	-- if self._bgAnchorY_dirty then
	-- 	bg.anchorY = style.background.anchorY
	-- 	self._bgAnchorY_dirty=false

	-- 	self._textDisplayY_dirty=true
	-- end
	-- -- if self._bgWidth_dirty then
	-- 	bg.width = style.width
	-- 	self._bgWidth_dirty=false

	-- 	self._textX_dirty=true
	-- 	self._hintAlignX_dirty=true
	-- end
	-- if self._bg_height_dirty then
	-- 	bg.height = style.height
	-- 	self._bg_height_dirty=false

	-- 	self._textY_dirty=true
	-- end

	--== text field

	if self._inputAlign_dirty then
		input.align=self._align
		self._inputAlign_dirty = false
	end
	if self._hasBackground_dirty then
		-- hard-code, no background
		input.hasBackground=false
		self._hasBackground_dirty = false
	end

	-- if self._textX_dirty then
	-- 	local align = style.align
	-- 	local marginX = style.marginX
	-- 	local offset
	-- 	if align==self.LEFT then
	-- 		text.anchorX = 0
	-- 		offset = -bg.width*(bg.anchorX)+marginX
	-- 		text.x=bg.x+offset
	-- 	elseif align==self.RIGHT then
	-- 		text.anchorX = 1
	-- 		offset = bg.width*(1-bg.anchorX)-marginX
	-- 		text.x=bg.x+offset
	-- 	else
	-- 		text.anchorX = 0.5
	-- 		offset = bg.width*(0.5-bg.anchorX)
	-- 		text.x=bg.x+offset
	-- 	end
	-- 	self._textX_dirty = false
	-- end
	-- if self._textY_dirty then
	-- 	local offset=bg.height/2+(-bg.height*bg.anchorY)
	-- 	text.y=bg.y+offset
	-- 	self._textY_dirty=false
	-- end

	-- if self._text_dirty then
	-- 	text.text = self._text
	-- 	self._text_dirty=false

	-- 	self._bgAnchorX_dirty=true
	-- 	self._bgAnchorY_dirty=true
	-- end
	-- if self._font_dirty or self._fontSize_dirty then
	-- 	text.font=native.newFont( style.text.font, style.text.fontSize )
	-- 	self._font_dirty=false
	-- 	self._fontSize_dirty=false
	-- end
	-- if self._textColor_dirty then
	-- 	text:setTextColor( unpack( style.text.textColor ) )
	-- 	self._textColor_dirty=false
	-- end

	if self._keyboardFocus_dirty then
		local focus = nil
		if self._keyboardFocus==true then
			focus = input
		end
		self:_startKeyboardFocus( focus )
		self._keyboardFocus_dirty=false
	end

	-- if self._inputAlign_dirty then
	-- 	text.align=style.align
	-- 	self._inputAlign_dirty = false
	-- end

	--== Hint

	-- if self._hintX_dirty then
	-- 	local align = style.align
	-- 	local marginX = style.marginX
	-- 	local offset
	-- 	if align==self.LEFT then
	-- 		hint.anchorX = 0
	-- 		offset = -bg.width*(bg.anchorX)+marginX
	-- 		hint.x=bg.x+offset
	-- 	elseif align==self.RIGHT then
	-- 		hint.anchorX = 1
	-- 		offset = bg.width*(1-bg.anchorX)-marginX
	-- 		hint.x=bg.x+offset
	-- 	else
	-- 		text.anchorX = 0.5
	-- 		offset = bg.width*(0.5-bg.anchorX)
	-- 		hint.x=bg.x+offset
	-- 	end
	-- 	self._hintX_dirty = false
	-- end
	-- if self._textDisplayY_dirty then
	-- 	local offset
	-- 	hint.anchorY = 0.5
	-- 	offset = bg.height/2-bg.height*(bg.anchorY) -- 0
	-- 	hint.y=bg.y+offset
	-- 	self._textDisplayY_dirty = false
	-- end

	if self._displayText_dirty then
		if self._text=="" then
			display.text=self._hint_text
		else
			display.text=self._text
		end
		self._displayText_dirty=false
	end

	if self._displayStyle_dirty then
		if self._text=="" then
			display:setActiveStyle( style.hint, {copy=false} )
		else
			display:setActiveStyle( style.text, {copy=false} )
		end
		self._displayStyle_dirty=false
	end



	-- if self._textDisplayFont_dirty then
	-- 	if self._text=="" then
	-- 		hint.font=style.hint.font
	-- 	else
	-- 		hint.font=style.text.font
	-- 	end
	-- 	self._textDisplayFont_dirty=false
	-- end
	-- if self._textDisplayFontSize_dirty then
	-- 	if self._text=="" then
	-- 		hint.fontSize=style.hint.fontSize
	-- 	else
	-- 		hint.fontSize=style.text.fontSize
	-- 	end
	-- 	self._textDisplayFontSize_dirty=false
	-- end
	-- if self._textDisplayColor_dirty then
	-- 	-- error("here in color")
	-- 	Utils.print( style.hint.textColor )
	-- 	Utils.print( style.text.textColor )
	-- 	if self._text=="" then
	-- 		hint:setTextColor( unpack( style.hint.textColor ) )
	-- 	else
	-- 		hint:setTextColor( unpack( style.text.textColor ) )
	-- 	end
	-- 	self._textDisplayColor_dirty=false
	-- end

end


function TextField:_startKeyboardFocus( focus )
	self:_stopKeyboardFocus()
	local f = function()
		native.setKeyboardFocus( focus )
		self._keyboardFocus_timer=nil
	end
	self._keyboardFocus_timer = timer.performWithDelay( 1, f )
end

function TextField:_stopKeyboardFocus()
	if not self._keyboardFocus_timer then return end
	timer.cancel( self._keyboardFocus_timer)
	self._keyboardFocus_timer = nil
end


function TextField:_startEdit( set_focus )
	-- print( 'TextField:_startEdit' )
	self:setEditActive( true, {set_focus=set_focus} )
end

function TextField:_stopEdit( set_focus )
	-- print( 'TextField:_stopEdit' )
	self:setEditActive( false, {set_focus=set_focus} )
end


function TextField:_doStateBegan( event )
	-- print( 'TextField:_doStateBegan', event )
	self:_startEdit( false )

	self._tmp_text = self._text -- start last ok state

	event.target=self
	event.text=self._text -- fix broken simulator
	self:dispatchEvent( event )
end

function TextField:_doStateEditing( event )
	-- print( 'TextField:_doStateEditing', event )

	self._tmp_text = event.text -- save for last ok state

	event.target=self
	self:dispatchEvent( event )
end

function TextField:_doStateEnded( event )
	-- print( 'TextField:_doStateEnded', event )
	self:_stopEdit( false )

	self._tmp_text = nil

	event.target=self
	event.text=self._text
	self:dispatchEvent( event )
end



--====================================================================--
--== Event Handlers


function TextField:_backgroundTouch_handler( event )
	print( 'TextField:_backgroundTouch_handler', event.type )
	local etype = event.type
	local background = event.target

	if self._is_editing.state==true then return end

	if etype == background.RELEASE then
		self:_startEdit()
	end
end


--[[
-- from our 'hint' text object
function TextField:_textOnUpdateEvent_handler( event )
	-- print( 'TextField:_textOnUpdateEvent_handler' )
	local text = event.target
	-- print( 'text height', text.textHeight )
end
--]]



function TextField:_textFieldEvent_handler( event )
	print( '\n\nTextField:_textFieldEvent_handler', event.phase )
	local phase = event.phase
	local textfield = event.target

	-- Utils.print( event )

	if phase==self.BEGAN then
		-- print( "text", event.text )
		self:_doStateBegan( event )

	elseif phase==self.ENDED or phase==self.SUBMITTED then
		-- print( "end text", textfield.text )
		local text = textfield.text

		self.isValid = self:_formatterIsTextValid( text )
		if self:_delegateShouldEndEditing( event ) then
			-- this delegate call needs checking
			self.text = textfield.text -- << Use Setter
			self:_doStateEnded( event )
		else
			self:setKeyboardFocus()
		end

	elseif phase==self.EDITING then

		--[[
		print( "start", event.startPosition )
		print( "delete", event.numDeleted )
		print( "new", event.newCharacters )
		print( "text", event.text )
		--]]
		local del = (event.numDeleted>0)
		if del or self:_formatterAreCharactersValid( event.newCharacters, event.text ) then
			self.isValid = self:_formatterIsTextValid( event.text )
			self:_doStateEditing( event )
		else
			textfield.text = self._tmp_text
		end

	end
end


function TextField:stylePropertyChangeHandler( event )
	-- print( "TextField:stylePropertyChangeHandler", event )
	local target = event.target
	local etype= event.type
	local property= event.property
	local value = event.value

	-- Utils.print( event )

	if etype == target.STYLE_RESET then

		-- print( "Style Changed", etype, property, value )

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

		property = etype

	else
			-- if property=='x' then
			-- 	self._x_dirty=true
			-- elseif property=='y' then
			-- 	self._y_dirty=true
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




return TextField
