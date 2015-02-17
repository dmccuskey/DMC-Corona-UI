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


-- ! put ThemeMix first !

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

	-- virtual (text changes)
	self._wgtTextText_dirty=true
	self._wgtTextStyle_dirty=true

	self._inputText_dirty=true

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
	self._wgtTextFont_dirty = true
	self._wgtTextFontSize_dirty = true
	self._wgtTextColor_dirty = true

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
	self._formatter = params.formatter -- data formatter

	self._tmp_style = params.style -- save

	self._bg = nil -- background object
	self._bg_dirty = true

	self._wgtText = nil -- text object (for both hint and value display)
	self._wgtText_f = nil -- text object (for both hint and value display)
	self._wgtText_dirty = true
	self._textInput = nil -- textfield object
	self._textInput_f = nil -- textfield handler

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

	-- basic updater
	self._textInput_f = self:createCallback( self._textFieldEvent_handler )
	self._textStyle_f = self:createCallback( self.textStyleChange_handler )
	self._bg_f = self:createCallback( self._backgroundTouch_handler )
	self._wgtText_f = self:createCallback( self._wgtTextWidgetUpdate_handler )

	self.formatter = self._formatter -- use setter


	self.style = self._tmp_style
	self:_stopEdit(false)
end

function TextField:__undoInitComplete__()
	--print( "TextField:__undoInitComplete__" )
	self:_removeTextField()

	self:_stopKeyboardFocus()
	self.style = nil

	self._bg_f = nil
	self._textStyle_f = nil
	self._textInput_f = nil

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
	-- print( 'TextField.__setters:width', value )
	local style=self.curr_style
	style.width = value
	style.background.width=value
	style.hint.width = value
	style.display.width = value
	self._width_dirty=true
	self:__invalidateProperties__()
end

--== height (custom)

function TextField.__getters:height()
	-- print( 'TextField.__getters:height' )
	return self.curr_style.height
end
function TextField.__setters:height( value )
	-- print( 'TextField.__setters:height', value )
	local style=self.curr_style
	style.height = value
	style.background.height=value
	style.hint.height = value
	style.display.height = value
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
	style.display.align = value
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
	style.display.anchorX = value
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
	style.display.anchorY = value
end




--== isEditing

function TextField.__getters:isEditing()
	return self._is_editing.state
end

--== setEditActive()

function TextField:setEditActive( value, params )
	-- print( 'TextField:setEditActive', value )
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
	assert( value==nil or type(value)=='table' )
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
	style.display.marginX = value
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
	style.display.marginY = value
end

--== text

function TextField.__getters:text()
	return self._text
end
function TextField.__setters:text( value )
	-- print( 'TextField.__setters:text', value )
	assert( type(value)=='string' )
	--==--
	if value == self._text then return end
	self._text = value
	self._text_dirty=true
	self._wgtTextText_dirty=true
	self._wgtTextStyle_dirty=true
	self:__invalidateProperties__()
end

function TextField.__getters:hintText()
	return self._hint_text
end
function TextField.__setters:hintText( value )
	-- print( 'TextField.__setters:hintText', value )
	if value == self._hint_text then return end
	self._hint_text = value
	self._wgtTextText_dirty=true
	self._wgtTextStyle_dirty=true
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


--== Display Style Methods ==--

function TextField.__setters:displayFont( value )
	-- print( 'TextField.__setters:displayFont', value )
	self.curr_style.display.font = value
end

function TextField.__setters:displayFontSize( value )
	-- print( 'TextField.__setters:displayFontSize', value )
	self.curr_style.display.fontSize = value
end

function TextField:setDisplayColor( ... )
	-- print( 'TextField:setDisplayColor' )
	self.curr_style.display.textColor = {...}
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
	local o = self._wgtText
	if not o then return end
	o.onUpdate=nil
	o:removeSelf()
	self._wgtText = nil
end

function TextField:_createText()
	-- print( "TextField:_createText" )

	self:_removeText()

	local o = Widgets.newText()
	o.onUpdate = self._wgtText_f
	self:insert( o.view )
	self._wgtText = o

	-- conditions for coming in here
	self._wgtText_dirty=false

	--== reset our text field object

	self._wgtTextStyle_dirty=true

	self._editActive_dirty = true
end



function TextField:_removeTextField()
	-- print( "TextField:_removeTextField" )
	local o = self._textInput
	if not o then return end

	o:removeEventListener( 'userInput', self._textInput_f )
	o:removeSelf()
	self._textInput = nil
end

function TextField:_createTextField()
	-- print( "TextField:_createTextField" )
	local style = self.curr_style
	local text = self._wgtText
	local o -- object

	self:_removeTextField()

	local height = text:getTextHeight()
	if not height or height <=0 then
		height = style.height
	end
	local w, h = style.width, height
	w = w - style.marginX*2

	o = native.newTextField(0,0,w,h)
	self:insert( o )
	o:addEventListener( 'userInput', self._textInput_f )
	self._textInput = o

	-- conditions for coming in here
	self._width_dirty=false
	self._height_dirty=false

	--== reset our text field object

	self._inputText_dirty=true
	self._inputStyle_dirty=true

	self._editActive_dirty=true

	-- check
	self._inputX_dirty=true
	self._inputY_dirty=true

	self._inputAlign_dirty=true
	self._inputTextColor_dirty=true

	self._inputFont_dirty=true
	self._inputFontSize_dirty=true
	self._hasBackground_dirty=true
	self._keyboardFocus_dirty=true
end


function TextField:__commitProperties__()
	-- print( 'TextField:__commitProperties__' )
	local style = self.curr_style

	if self._bg_dirty then
		self:_createBackground()
	end

	if self._wgtText_dirty then
		self:_createText()
	end

	if self._width_dirty or self._height_dirty then
		self:_createTextField()
	end

	local view = self.view
	local bg = self._bg
	local text = self._wgtText
	local input = self._textInput

	--== position sensitive

	--== View

	if self._x_dirty then
		view.x = self._x
		self._x_dirty = false

		self._inputX_dirty=true
	end
	if self._y_dirty then
		view.y = self._y
		self._y_dirty = false

		self._inputY_dirty=true
	end

	if self._text_dirty then
		self._text_dirty = false

		self._wgtTextText_dirty=true
		self._wgtTextStyle_dirty=true
		self._inputText_dirty=true
	end

	if self._align_dirty then
		self._align_dirty = false

		self._wgtTextAlign_dirty=true
		self._inputAlign_dirty=true
	end

	if self._anchorX_dirty then
		-- view.y = self._y
		self._anchorX_dirty = false

		self._bgAnchorX_dirty=true
		self._inputX_dirty=true
	end
	if self._anchorY_dirty then
		-- view.y = self._y
		self._anchorY_dirty = false

		self._bgAnchorY_dirty=true
		self._inputY_dirty=true
	end

	if self._editActive_dirty then
		local is_editing = self._is_editing
		local edit, set_focus = is_editing.state, is_editing.set_focus
		text.isVisible=not edit
		input.isVisible=edit
		if set_focus then
			local focus = input
			if not edit then focus=nil end
			native.setKeyboardFocus( focus )
		end
		self._editActive_dirty=false
	end

	--== Background

	if self._bgStyle_dirty then
		bg:setActiveStyle( style.background, {copy=false} )
		self._bgStyle_dirty=false
	end

	--== Display

	--== Input

	if self._inputAnchorX_dirty then
		self._inputAnchorX_dirty=false

		self._inputX_dirty=true
	end
	if self._inputAnchorY_dirty then
		self._inputAnchorY_dirty=false

		self._inputY_dirty=true
	end

	if self._inputX_dirty  then
		-- error("here")
		local align = style.align
		local marginX = style.marginX
		local offset
		if align==self.LEFT then
			input.anchorX = 0
			offset = -style.width*(style.anchorX)+marginX
			input.x=offset
		elseif align==self.RIGHT then
			input.anchorX = 1
			offset = style.width*(1-style.anchorX)-marginX
			input.x=offset
		else
			input.anchorX = 0.5
			offset = style.width*(0.5-style.anchorX)
			input.x=offset
		end
		self._inputX_dirty = false
	end
	if self._inputY_dirty then
		local height = style.height
		input.y=height/2+(-height*style.anchorY)
		self._inputY_dirty=false
	end

	--== Non-positional


	if self._wgtTextText_dirty then
		if self._text=="" then
			text.text=self._hint_text
		else
			text.text=self._text
		end
		self._wgtTextText_dirty=false
	end

	if self._wgtTextStyle_dirty then
		if self._text=="" then
			text:setActiveStyle( style.hint, {copy=false} )
		else
			text:setActiveStyle( style.display, {copy=false} )
		end
		self._wgtTextStyle_dirty=false
	end



	if self._inputStyle_dirty then
		style.display.onPropertyChange = self._textStyle_f
		style.display:resetProperties()
		self._inputStyle_dirty=false
	end

	if self._inputFont_dirty or self._inputFontSize_dirty then
		input.font=native.newFont( style.display.font, style.display.fontSize )
		self._inputFont_dirty=false
		self._inputFontSize_dirty=false
	end

	if self._inputTextColor_dirty then
		input:setTextColor( unpack( style.display.textColor ) )
		self._inputTextColor_dirty=false
	end

	if self._inputAlign_dirty then
		input.align=style.align
		self._inputAlign_dirty = false
	end
	if self._hasBackground_dirty then
		-- hard-code, no background
		-- TEST – false/(true)
		input.hasBackground=false
		self._hasBackground_dirty = false
	end

	if self._keyboardFocus_dirty then
		local focus = nil
		if self._keyboardFocus==true then
			focus = input
		end
		self:_startKeyboardFocus( focus )
		self._keyboardFocus_dirty=false
	end

	if self._inputText_dirty then
		input.text=self._text
		self._inputText_dirty=false
	end

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


-- _backgroundTouch_handler()
-- capture background touches, to start editing
--
function TextField:_backgroundTouch_handler( event )
	-- print( 'TextField:_backgroundTouch_handler', event.type )
	local etype = event.type
	local background = event.target

	if self._is_editing.state==true then return end

	if etype == background.RELEASED then
		self:_startEdit()
	end
end


-- _textFieldEvent_handler()
-- capture events from our Text Field input
--
function TextField:_textFieldEvent_handler( event )
	-- print( "TextField:_textFieldEvent_handler", event.phase )
	local phase = event.phase
	local textfield = event.target

	-- Utils.print( event )

	if phase==self.BEGAN then
		-- print( "text", event.text )
		self:_doStateBegan( event )

	elseif phase==self.ENDED or phase==self.SUBMITTED then
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


--[[
right now we only need this one time through
later, when backgrounds get more complex (ie, they redraw)
then we'll need a new strategy
--]]
-- _wgtTextWidgetUpdate_handler()
--
function TextField:_wgtTextWidgetUpdate_handler( event )
	-- print( "TextField:_wgtTextWidgetUpdate_handler", event )
	local widget = event.target
	local etype = event.type

	-- Utils.print( event )

	if etype==widget.LIFECYCLE_UPDATED then
		widget.onUpdate=nil

		self._height_dirty=true
		self:__invalidateProperties__()
		self:__dispatchInvalidateNotification__( property, value )
	end
end


--[[
we set this one up because the style 'text' isn't handed
to another widget to handle, we are doing it ourselves
in this widget
--]]

-- textStyleChange_handler()
--
function TextField:textStyleChange_handler( event )
	-- print( "TextField:textStyleChange_handler", event )

	local target = event.target
	local etype= event.type
	local property= event.property
	local value = event.value

	-- print( "Style Changed", etype, property, value )

	if etype == target.STYLE_RESET then

		self._inputX_dirty=true
		self._inputY_dirty=true

		self._inputWidth_dirty=true
		self._inputHeight_dirty=true

		self._inputAlign_dirty=true
		self._inputAnchorX_dirty=true
		self._inputAnchorY_dirty=true
		self._inputFont_dirty=true --ok
		self._inputFontSize_dirty=true --ok
		self._inputMarginX_dirty=true
		self._inputMmarginY_dirty=true

		self._inputText_dirty=true --ok
		self._inputTextColor_dirty=true --ok

		property = etype

	else
		if property=='width' then
			self._inputWidth_dirty=true
		elseif property=='height' then
			self._inputHeight_dirty=true

		elseif property=='align' then
			self._inputAlign_dirty=true
		elseif property=='anchorX' then
			self._inputAnchorX_dirty=true
		elseif property=='anchorY' then
			self._inputAnchorY_dirty=true
		elseif property=='font' then
			self._inputFont_dirty=true
		elseif property=='fontSize' then
			self._inputFontSize_dirty=true
		elseif property=='marginX' then
			self._inputMarginX_dirty=true
		elseif property=='marginY' then
			self._inputMmarginY_dirty=true
		elseif property=='text' then
			self._inputText_dirty=true
		elseif property=='textColor' then
			self._inputTextColor_dirty=true
		end

	end

	self:__invalidateProperties__()
	self:__dispatchInvalidateNotification__( property, value )
end


-- stylePropertyChangeHandler()
-- this is the standard property event handler
-- needed by any DMC Widget
-- it listens for changes in the Widget Style Object
-- and reponds with the appropriate message
--
function TextField:stylePropertyChangeHandler( event )
	-- print( "TextField:stylePropertyChangeHandler", event )
	local target = event.target
	local etype= event.type
	local property= event.property
	local value = event.value

	-- Utils.print( event )

	-- print( "Style Changed", etype, property, value )

	if etype == target.STYLE_RESET then


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
