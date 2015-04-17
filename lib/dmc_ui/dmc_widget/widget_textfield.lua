--====================================================================--
-- dmc_ui/dmc_widget/widget_textfield.lua
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
--== DMC Corona UI : TextField Widget
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
--== DMC UI : newTextField
--====================================================================--



--====================================================================--
--== Imports


local Objects = require 'dmc_objects'
local Utils = require 'dmc_utils'

local uiConst = require( ui_find( 'ui_constants' ) )

local WidgetBase = require( ui_find( 'core.widget' ) )



--====================================================================--
--== Setup, Constants


local newClass = Objects.newClass

--== To be set in initialize()
local dUI = nil
local Widget = nil



--====================================================================--
--== TextField Widget Class
--====================================================================--


--- TextField Widget Module.
-- a widget used to collect text from user.
--
-- **Inherits from:** <br>
-- * @{Core.Widget}
--
-- **Style Object:** <br>
-- * @{Style.TextField}
--
-- @classmod Widget.TextField
-- @usage
-- local dUI = require 'dmc_ui'
-- local widget = dUI.TextField()

local TextField = newClass( WidgetBase, {name="TextField"} )

--- Constants
-- @section

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

--- defines default Keyboard input type.
-- set input type using styles (inline, style, or direct)
-- @usage
-- widget.style.inputType = widget.INPUT_DEFAULT

TextField.INPUT_DEFAULT = 'default'

--- defines decimal Keyboard input type.
-- set input type using styles (inline, style, or direct)
-- @usage
-- widget.style.inputType = widget.INPUT_DECIMAL

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

--== Style/Theme Constants

TextField.STYLE_CLASS = nil -- added later
TextField.STYLE_TYPE = uiConst.TEXTFIELD

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
-- Start: Setup DMC Objects

--== Init

function TextField:__init__( params )
	-- print( "TextField:__init__", params, self )
	params = params or {}
	if params.text==nil then params.text="" end
	if params.hintText==nil then params.hintText="" end

	self:superCall( '__init__', params )
	--==--

	--== Create Properties ==--

	-- properties stored in Class

	self._displayText = params.text
	self._displayText_dirty=true
	self._hintText = params.hintText
	self._hintText_dirty=true

	self._isWidgetEnabled = true

	self._isEditActive = { state=false, set_focus=nil }
	self._isEditActive_dirty = true

	self._clearOnBeginEdit = false
	self._adjustFontToFit = false
	self._clearButtonMode = 'never'

	self._keyboardFocus=false
	self._keyboardFocus_dirty=true
	self._keyboardFocus_timer=nil

	-- properties stored in Style

	self._align_dirty=true
	self._backgroundStyle_dirty=true
	self._inputType_dirty=true
	self._isHitActive_dirty=true
	self._isSecure_dirty=true
	self._marginX_dirty=true
	self._marginY_dirty=true
	self._returnKey_dirty=true

	-- "Virtual" properties

	self._widgetStyle_dirty=true
	self._wgtBgStyle_dirty=true

	self._wgtTextFont_dirty=true
	self._wgtTextFontSize_dirty=true
	self._wgtTextHeight_dirty=true
	self._wgtTextIsSecure_dirty=true
	self._wgtTextStyle_dirty=true
	self._wgtTextText_dirty=true

	self._inputFieldX_dirty=true
	self._inputFieldY_dirty=true
	self._inputFieldAlign_dirty=true
	self._inputFieldFont_dirty=true
	self._inputFieldFontSize_dirty=true
	self._inputFieldWidth_dirty=true
	self._inputFieldHeight_dirty=true
	self._inputFieldMarginX_dirty=true
	self._inputFieldIsSecure_dirty=true
	self._inputFieldStyle_dirty=true
	self._inputFieldText_dirty=true
	self._inputFieldTextColor_dirty=true

	--== Object References ==--

	self._rctHit = nil -- our rectangle hit area
	self._rctHit_f = nil

	self._wgtBg = nil -- background widget
	self._wgtBg_dirty=true

	self._wgtText = nil -- text widget (for both hint and value display)
	self._wgtText_f = nil -- widget handler
	self._wgtText_dirty=true

	self._inputField = nil -- textfield object
	self._inputField_f = nil -- textfield handler
	self._inputField_dirty=true
end

--[[
function TextField:__undoInit__()
	-- print( "TextField:__undoInit__" )
	--==--
	self:superCall( '__undoInit__' )
end
--]]


--== createView

function TextField:__createView__()
	-- print( "TextField:__createView__" )
	self:superCall( '__createView__' )
	--==--
	local o = display.newRect( 0,0,0,0 )
	o.anchorX, o.anchorY = 0.5,0.5
	o.isHitTestable=true
	self:insert( o )
	self._rctHit = o
end

function TextField:__undoCreateView__()
	-- print( "TextField:__undoCreateView__" )
	self._rctHit:removeSelf()
	self._rctHit=nil
	--==--
	self:superCall( '__undoCreateView__' )
end


--== initComplete

function TextField:__initComplete__()
	-- print( "TextField:__initComplete__" )
	self:superCall( '__initComplete__' )
	--==--
	self._rctHit_f = self:createCallback( self._hitAreaTouch_handler )
	self._rctHit:addEventListener( 'touch', self._rctHit_f )

	self._inputField_f = self:createCallback( self._textFieldEvent_handler )
	self._textStyle_f = self:createCallback( self.textStyleChange_handler )
	self._wgtText_f = self:createCallback( self._wgtTextWidgetUpdate_handler )

	self:_stopEdit(false)
end

function TextField:__undoInitComplete__()
	--print( "TextField:__undoInitComplete__" )
	self:_removeTextField()
	self:_removeText()
	self:_removeBackground()

	self:_stopKeyboardFocus()

	self._textStyle_f = nil
	self._inputField_f = nil

	self._rctHit:removeEventListener( 'touch', self._rctHit_f )
	self._rctHit_f = nil
	--==--
	self:superCall( '__undoInitComplete__' )
end

-- END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Static Methods


function TextField.initialize( manager )
	-- print( "TextField.initialize" )
	dUI = manager
	Widget = dUI.Widget

	local Style = dUI.Style
	TextField.STYLE_CLASS = Style.TextField

	Style.registerWidget( TextField )
end



--====================================================================--
--== Public Methods


--======================================================--
-- Local Properties


--[[
Inherited Methods
--]]

--- set/get align.
-- values are 'left', 'center', 'right'
--
-- @within Properties
-- @function .align
-- @usage widget.align = 'center'
-- @usage print( widget.align )

--== .hintText

--- set/get hintText.
-- set the text when the "hint" is visible.
--
-- @within Properties
-- @function .hintText
-- @usage widget.hintText = "Enter an email"
-- @usage print( widget.hintText )

function TextField.__getters:hintText()
	return self._hintText
end
function TextField.__setters:hintText( value )
	-- print( "TextField.__setters:hintText", value )
	if value == self._hintText then return end
	self._hintText = value
	self._hintText_dirty=true
	self:__invalidateProperties__()
end


--== .isEditing

--- get editing state for TextField.
-- returns true if the TextField is currently displaying the input field.
--
-- @within Properties
-- @function .isEditing
-- @treturn bool
-- @usage print( widget.isEditing )

function TextField.__getters:isEditing()
	return self._isEditActive.state
end


--== .isHitActive

--- set state of touch-activity.
-- set true if the TextField editing is enabled.
--
-- @within Properties
-- @function .isHitActive
-- @usage widget.isHitActive = true

function TextField.__setters:isHitActive( value, params )
	-- print( "TextField.__setters:isHitActive", value )
	self.curr_style.isHitActive = value
end


--== .isSecure

--- set/get password display.
-- set to true to change TextField to mask the text entered.
--
-- @within Properties
-- @function .isSecure
-- @usage widget.isSecure = true
-- @usage print( widget.isSecure )

function TextField.__getters:isSecure()
	return self.curr_style.isSecure
end
function TextField.__setters:isSecure( value )
	-- print( "TextField.__setters:isSecure", value )
	self.curr_style.isSecure = value
end


--== .marginX

--- set/get marginX.
-- set the margin inset of the widget. this value is *subtracted* from the widget width.
--
-- @within Properties
-- @function .marginX
-- @usage widget.marginX = 18
-- @usage print( widget.marginX )

--== .marginY

--- set/get marginY.
-- set the margin inset of the widget. this value is *subtracted* from the widget width.
--
-- @within Properties
-- @function .marginY
-- @usage widget.marginY = 18
-- @usage print( widget.marginY )


--== :setEditActive()

--- activate editing mode for TextField.
--
-- @within Properties
-- @function :setEditActive
-- @tparam bool value true if
-- @tab[opt] params table of optional parameters
-- @usage widget:setEditActive( true, { set_focus=true })

function TextField:setEditActive( value, params )
	-- print( "TextField:setEditActive", value )
	params = params or {}
	if params.set_focus==nil then params.set_focus=true end
	assert( type(value)=='boolean' )
	--==--
	params.state=value
	self._isEditActive = params
	self._isEditActive_dirty=true
	self:__invalidateProperties__()
end


--== :setKeyboardFocus()

--- set keyboard cursor-focus on this TextField.
-- this will show the keyboard.
--
-- @within Properties
-- @function :setKeyboardFocus
-- @usage widget:setKeyboardFocus()

function TextField:setKeyboardFocus()
	-- print( "TextField:setKeyboardFocus" )
	self._keyboardFocus = true
	self._keyboardFocus_dirty = true
	self:__invalidateProperties__()
end

--== :unsetKeyboardFocus()

--- remove keyboard cursor-focus on this TextField.
-- this will hide the keyboard.
--
-- @within Properties
-- @function :unsetKeyboardFocus

function TextField:unsetKeyboardFocus()
	-- print( "TextField:unsetKeyboardFocus" )
	self._keyboardFocus = false
	self._keyboardFocus_dirty = true
	self:__invalidateProperties__()
end

--== setReturnKey()

-- set value for Return Key.
-- @TODO
-- @within Properties
-- @function :setReturnKey

function TextField:setReturnKey( value )
	-- print( "TextField:setReturnKey", value )
	assert( type(value)=='string' )
	--==--
	if value==self._returnKey then return end
	--==--
	self._returnKey = value
	self._returnKey_dirty = true
	self:__invalidateProperties__()
end


--== .text

--- set/get input text for TextWidget.
--
-- @within Properties
-- @function .text
-- @usage widget.text = "input field text"
-- @usage print( widget.text )

function TextField.__getters:text()
	return self._displayText
end
function TextField.__setters:text( value )
	-- print( "TextField.__setters:text", value )
	assert( type(value)=='string' )
	--==--
	if value == self._displayText then return end
	self._displayText = value
	self._displayText_dirty=true
	self:__invalidateProperties__()
end



--======================================================--
-- Background Style Properties

-- .backgroundStrokeWidth
--
function TextField.__getters:backgroundStrokeWidth()
	return self.curr_style.backgroundStrokeWidth
end
function TextField.__setters:backgroundStrokeWidth( value )
	-- print( "TextField.__setters:backgroundStrokeWidth", value )
	self.curr_style.backgroundStrokeWidth = value
end

-- setBackgroundFillColor()
--
function TextField:setBackgroundFillColor( ... )
	-- print( "TextField:setBackgroundFillColor" )
	self.curr_style.backgroundFillColor = {...}
end

-- setBackgroundStrokeColor()
--
function TextField:setBackgroundStrokeColor( ... )
	-- print( "TextField:setBackgroundStrokeColor" )
	self.curr_style.backgroundStrokeColor = {...}
end


--======================================================--
-- Hint Style Properties

-- .hintFont  TODO: move to style
--
function TextField.__setters:hintFont( value )
	-- print( "TextField.__setters:hintFont", value )
	self.curr_style.hint.font = value
end

-- .hintFontSize
--
function TextField.__setters:hintFontSize( value )
	-- print( "TextField.__setters:hintFontSize", value )
	self.curr_style.hint.fontSize = value
end

-- setHintTextColor()
--
function TextField:setHintTextColor( ... )
	-- print( "TextField:setHintTextColor" )
	self.curr_style.hintTextColor = {...}
end


--======================================================--
-- Display Style Properties

-- .displayFont -- TODO move to stlye
--
function TextField.__setters:displayFont( value )
	-- print( "TextField.__setters:displayFont", value )
	self.curr_style.displayFont = value
end

-- .displayFontSize
--
function TextField.__setters:displayFontSize( value )
	-- print( "TextField.__setters:displayFontSize", value )
	self.curr_style.displayFontSize = value
end

-- setDisplayTextColor()
--
function TextField:setDisplayTextColor( ... )
	-- print( "TextField:setDisplayTextColor" )
	self.curr_style.displayTextColor = {...}
end


--======================================================--
-- Delegate


--== :shouldChangeCharacters()

-- this is so TextField can answer Delegate questions
-- without assigned delegate
--
function TextField:shouldChangeCharacters( event )
	return true
end

-- on tap
function TextField:_delegateShouldChangeCharacters( event )
	-- print("TextField:_delegateShouldChangeCharacters")
	local delegate = self._delegate
	if not delegate or not delegate.shouldChangeCharacters then
		delegate = self
	end
	local evt = {
		target = self,
		startPosition=event.startPosition,
		newCharacters=event.newCharacters,
		numDeleted=event.numDeleted,
		text=event.text,
	}
	return delegate:shouldChangeCharacters( evt )
end


--== :shouldBeginEditing()

-- this is so TextField can answer Delegate questions
-- without assigned delegate
--
function TextField:shouldBeginEditing()
	return self._isWidgetEnabled
end

-- on tap
function TextField:_delegateShouldBeginEditing()
	local delegate = self._delegate
	if not delegate or not delegate.shouldBeginEditing then
		delegate = self
	end
	return delegate:shouldBeginEditing( self )
end


--== :shouldEndEditing()

-- this is so TextField can answer Delegate questions
-- without assigned delegate
--
function TextField:shouldEndEditing( event )
	return true
end

-- after end/submit
function TextField:_delegateShouldEndEditing()
	local delegate = self._delegate
	if not delegate or not delegate.shouldEndEditing then
		delegate = self
	end
	return delegate:shouldEndEditing( self )
end


--== :shouldClearTextField()

-- this is so TextField can answer Delegate questions
-- without assigned delegate
--
function TextField:shouldClearTextField()
	return true
end

-- on button press
function TextField:_delegateShouldClearTextField()
	local delegate = self._delegate
	if not delegate or not delegate.shouldClearTextField then
		delegate = self
	end
	return delegate:shouldClearTextField( self )
end



--======================================================--
-- Theme Methods

-- afterAddStyle()
--
function TextField:afterAddStyle()
	-- print( "TextField:afterAddStyle", self )
	self._widgetStyle_dirty=true
	self:__invalidateProperties__()
end

-- beforeRemoveStyle()
--
function TextField:beforeRemoveStyle()
	-- print( "TextField:beforeRemoveStyle", self )
	self._widgetStyle_dirty=true
	self:__invalidateProperties__()
end



--====================================================================--
--== Private Methods


function TextField:_makeTextSecure( text )
	if self.curr_style.isSecure then
		text = string.rep( '•', #text )
	end
	return text
end


--== Create/Destroy Background Widget

function TextField:_removeBackground()
	-- print( "TextField:_removeBackground" )
	local o = self._wgtBg
	if not o then return end
	o:removeSelf()
	self._wgtBg = nil
end

function TextField:_createBackground()
	-- print( "TextField:_createBackground" )

	self:_removeBackground()

	local o = Widget.newBackground{
		defaultStyle = self.defaultStyle.background
	}
	self:insert( o.view )
	self._wgtBg = o

	--== Reset properties

	self._wgtBgStyle_dirty=true
end


--== Create/Destroy Text Widget

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

	local o = Widget.newText{
		defaultStyle = self.defaultStyle.label
	}
	o.onUpdate = self._wgtText_f
	self:insert( o.view )
	self._wgtText = o

	--== Reset properties

	self._wgtTextStyle_dirty=true
	self._isEditActive_dirty=true
end



function TextField:_removeTextField()
	-- print( "TextField:_removeTextField" )
	local o = self._inputField
	if not o then return end
	o:removeEventListener( 'userInput', self._inputField_f )
	o:removeSelf()
	self._inputField = nil
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
	o:addEventListener( 'userInput', self._inputField_f )
	self._inputField = o

	--== Reset properties

	self._hasBackground_dirty=true
	self._isEditActive_dirty=true
	self._keyboardFocus_dirty=true

	self._inputFieldX_dirty=true
	self._inputFieldY_dirty=true
	self._inputFieldAlign_dirty=true
	self._inputFieldFont_dirty=true
	self._inputFieldFontSize_dirty=true
	self._inputFieldIsSecure_dirty=true
	self._inputFieldStyle_dirty=true
	self._inputFieldText_dirty=true
	self._inputFieldTextColor_dirty=true

end


function TextField:__commitProperties__()
	-- print( "TextField:__commitProperties__" )

	--== Update Widget Components ==--

	if self._wgtBg_dirty then
		self:_createBackground()
		self._wgtBg_dirty = false
	end

	if self._wgtText_dirty then
		self:_createText()
		self._wgtText_dirty=false

		self._inputFieldHeight_dirty=true
	end

	if self._inputField_dirty or self._inputFieldHeight_dirty then
		self:_createTextField()
		self._inputField_dirty=false
		self._inputFieldHeight_dirty=false
	end


	--== Update Widget View ==--

	local style = self.curr_style
	local view = self.view
	local hit = self._rctHit
	local bg = self._wgtBg
	local text = self._wgtText
	local input = self._inputField

	-- x/y

	if self._x_dirty then
		view.x = self._x
		self._x_dirty=false
	end
	if self._y_dirty then
		view.y = self._y
		self._y_dirty=false
	end

	-- width/height

	if self._width_dirty then
		local width = style.width
		hit.width = width
		self._width_dirty=false

		self._inputFieldX_dirty=true
		self._inputFieldWidth_dirty=true
	end
	if self._height_dirty then
		local height = style.height
		hit.height = height
		self._height_dirty=false

		self._inputFieldY_dirty=true
	end

	-- align

	if self._align_dirty then
		self._align_dirty = false

		self._inputFieldX_dirty=true
	end

	-- anchorX/anchorY

	if self._anchorX_dirty then
		hit.anchorX = style.anchorX
		self._anchorX_dirty = false

		self._inputFieldX_dirty=true
	end
	if self._anchorY_dirty then
		hit.anchorY = style.anchorY
		self._anchorY_dirty = false

		self._inputFieldY_dirty=true
	end

	-- marginX/marginY

	if self._marginX_dirty then
		self._marginX_dirty = false

		self._inputFieldX_dirty=true
		self._inputFieldMarginX_dirty=true
	end
	if self._marginY_dirty then
		self._marginY_dirty = false
	end

	-- inputType

	if self._inputType_dirty then
		if style.inputType==TextField.INPUT_PASSWORD then
			input.inputType = TextField.INPUT_DEFAULT
			style.isSecure=true
		else
			input.inputType = style.inputType
		end

		self._isSecure_dirty=true
		self._inputType_dirty=false
	end

	-- isSecure

	if self._isSecure_dirty then
		self._isSecure_dirty=false

		self._wgtTextIsSecure_dirty=true
		self._inputFieldIsSecure_dirty=true
	end

	--== Virtual

	if self._widgetStyle_dirty then
		self._widgetStyle_dirty=false

		self._wgtBgStyle_dirty=true
		self._wgtTextStyle_dirty=true
		self._inputFieldStyle_dirty=true
	end

	if self._displayText_dirty then
		self._displayText_dirty=false

		self._wgtTextText_dirty=true
		self._wgtTextStyle_dirty=true
		self._inputFieldText_dirty=true
	end

	if self._hintText_dirty then
		self._hintText_dirty=false

		self._wgtTextText_dirty=true
		self._wgtTextStyle_dirty=true
	end

	if self._inputFieldIsSecure_dirty then
		-- this next line makes simulator edit field
		input.isSecure = style.isSecure
		-- so we force to inactive
		self:setEditActive( false )
		self._inputFieldIsSecure_dirty=false
	end


	if self._isEditActive_dirty then
		local is_editing = self._isEditActive
		local edit, set_focus = is_editing.state, is_editing.set_focus
		text.isVisible=not edit
		input.isVisible=edit
		if set_focus then
			local focus = input
			if not edit then focus=nil end
			native.setKeyboardFocus( focus )
		end
		self._isEditActive_dirty=false
	end


	--== Set Styles

	if self._wgtBgStyle_dirty then
		bg:setActiveStyle( style.background, {copy=false} )
		self._wgtBgStyle_dirty=false
	end

	if self._wgtTextText_dirty or self._wgtTextStyle_dirty or self._wgtTextIsSecure_dirty then

		if self._displayText=="" then
			text.text=self._hintText
			text:setActiveStyle( style.hint, {copy=false} )
		else
			text.text=self:_makeTextSecure( self._displayText )
			text:setActiveStyle( style.display, {copy=false} )
		end

		self._wgtTextText_dirty=false
		self._wgtTextStyle_dirty=false
		self._wgtTextIsSecure_dirty=false
	end

	--== Hit

	if self._wgtTextHeight_dirty then
		self._wgtTextHeight_dirty=false

		self._inputFieldHeight_dirty=true
	end

	--== Input Widget

	-- style

	if self._inputFieldStyle_dirty then
		style.display.onPropertyChange = self._textStyle_f
		style.display:resetProperties()
		self._inputFieldStyle_dirty=false
	end

	if self._inputFieldWidth_dirty or self._inputFieldMarginX_dirty then
		local width = style.width
		local marginX = style.marginX
		input.width = width - marginX*2
		self._inputFieldWidth_dirty=false
		self._inputFieldMarginX_dirty=false
	end

	if self._inputFieldHeight_dirty then
		input.height = text:getTextHeight()
		self._inputFieldHeight_dirty=false
	end

	-- X/Y

	if self._inputFieldX_dirty then
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
		self._inputFieldX_dirty = false
	end
	if self._inputFieldY_dirty then
		local height = style.height
		input.y=height/2+(-height*style.anchorY)
		self._inputFieldY_dirty=false
	end

	-- align

	if self._inputFieldAlign_dirty then
		input.align=style.align
		self._inputFieldAlign_dirty = false
	end

	-- font

	if self._inputFieldFont_dirty or self._inputFieldFontSize_dirty then
		input.font=native.newFont( style.display.font, style.display.fontSize )
		self._inputFieldFont_dirty=false
		self._inputFieldFontSize_dirty=false
	end

	-- hasBackground

	if self._hasBackground_dirty then
		-- hard-code, no background
		-- TEST – false/(true)
		input.hasBackground=true
		self._hasBackground_dirty = false
	end

	-- keyboardFocus

	if self._keyboardFocus_dirty then
		local focus = nil
		if self._keyboardFocus==true then
			focus = input
		end
		self:_startKeyboardFocus( focus )
		self._keyboardFocus_dirty=false
	end

	-- text

	if self._inputFieldText_dirty then
		-- input.text=self:_makeTextSecure( self._displayText )
		input.text=self._displayText
		self._inputFieldText_dirty=false
	end

	-- textColor

	if self._inputFieldTextColor_dirty then
		input:setTextColor( unpack( style.display.textColor ) )
		self._inputFieldTextColor_dirty=false
	end

	-- debug on

	if self._debugOn_dirty then
		if style.debugOn==true then
			hit:setFillColor( 1,1,0,0.3 )
		else
			hit:setFillColor( 0,0,0,0 )
		end
		self._debugOn_dirty=false
	end

end


-- sets keyboard focus, after a small timer delay
--
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
	timer.cancel( self._keyboardFocus_timer )
	self._keyboardFocus_timer = nil
end


function TextField:_startEdit( set_focus )
	-- print( "TextField:_startEdit" )
	self:setEditActive( true, {set_focus=set_focus} )
end

function TextField:_stopEdit( set_focus )
	-- print( "TextField:_stopEdit" )
	self:setEditActive( false, {set_focus=set_focus} )
end


function TextField:_dispatchStateBegan( event )
	-- print( "TextField:_dispatchStateBegan", event )
	self:_startEdit( false )

	self._tmp_text = self._displayText -- start last ok state

	event.target=self
	event.text=self._displayText -- fix broken simulator
	self:dispatchEvent( event )
end

function TextField:_dispatchStateEditing( event )
	-- print( "TextField:_dispatchStateEditing", event )

	self._tmp_text = event.text -- save for last ok state

	event.target=self
	self:dispatchEvent( event )
end

function TextField:_dispatchStateEnded( event )
	-- print( "TextField:_dispatchStateEnded", event )
	self:_stopEdit( false )

	self._tmp_text = nil

	event.target=self
	event.text=self._displayText
	self:dispatchEvent( event )
end



--====================================================================--
--== Event Handlers


function TextField:_hitAreaTouch_handler( e )
	-- print( "TextField:_hitAreaTouch_handler", e.phase )
	local phase = e.phase
	local background = e.target

	if not self.curr_style.isHitActive then return true end

	if phase=='began' then
		display.getCurrentStage():setFocus( background )
		self._has_focus = true
		self:dispatchEvent( self.PRESSED, {isWithinBounds=true}, {merge=true} )
		return true
	end

	if not self._has_focus then return false end


	local bgCb = background.contentBounds
	local isWithinBounds =
		( bgCb.xMin <= e.x and bgCb.xMax >= e.x
			and bgCb.yMin <= e.y and bgCb.yMax >= e.y )

	if phase=='ended' or phase=='canceled' then
		display.getCurrentStage():setFocus( nil )
		self._has_focus = false

		if isWithinBounds and self:_delegateShouldBeginEditing() then
			self:_startEdit()
		end
	end

	return true
end


-- _textFieldEvent_handler()
-- capture events from our Text Field object
--
function TextField:_textFieldEvent_handler( event )
	-- print( "TextField:_textFieldEvent_handler", event.phase )
	local phase = event.phase
	local textfield = event.target -- Corona TextField

	-- Utils.print( event )

	if phase==TextField.BEGAN then
		-- print( "text", event.text )
		self:_dispatchStateBegan( event )

	elseif phase==TextField.EDITING then
		--[[
		print( "start", event.startPosition )
		print( "delete", event.numDeleted )
		print( "new", event.newCharacters )
		print( "text", event.text )
		--]]
		if self:_delegateShouldChangeCharacters( event ) then
			self:_dispatchStateEditing( event )
		else
			textfield.text = self._tmp_text
		end

	elseif phase==TextField.ENDED or phase==TextField.SUBMITTED then
		if self:_delegateShouldEndEditing( event ) then
			self.text = textfield.text -- << Use Setter
			self:_dispatchStateEnded( event )
		else
			self:setKeyboardFocus()
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
	-- print( "TextField:_wgtTextWidgetUpdate_handler", event.type )
	local widget = event.target
	local etype = event.type

	-- Utils.print( event )

	if etype==widget.LIFECYCLE_UPDATED then
		widget.onUpdate=nil

		self._wgtTextHeight_dirty=true
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
	-- print( "TextField:textStyleChange_handler", event.property )
	local style = event.target
	local etype = event.type
	local property = event.property
	local value = event.value

	-- print( "Style Changed", etype, property, value )

	if etype==style.STYLE_RESET then
		self._debugOn_dirty = true

		self._inputFieldX_dirty=true
		self._inputFieldY_dirty=true

		-- self._inputFieldWidth_dirty=true
		-- self._inputFieldHeight_dirty=true

		self._inputFieldAlign_dirty=true
		-- self._inputFieldAnchorX_dirty=true
		-- self._inputFieldAnchorY_dirty=true
		self._inputFieldFont_dirty=true
		self._inputFieldFontSize_dirty=true
		-- self._inputFieldMarginX_dirty=true
		-- self._inputFieldMarginY_dirty=true
		self._inputFieldText_dirty=true --ok
		self._inputFieldTextColor_dirty=true --ok


		property = etype

	else
		if property=='debugActive' then
			self._debugOn_dirty=true

		elseif property=='width' then
			-- self._inputFieldWidth_dirty=true
		elseif property=='height' then
			-- self._inputFieldHeight_dirty=true

		elseif property=='align' then
			self._inputFieldAlign_dirty=true
		elseif property=='anchorX' then
			-- self._inputFieldAnchorX_dirty=true
		elseif property=='anchorY' then
			-- self._inputFieldAnchorY_dirty=true
		elseif property=='font' then
			self._inputFieldFont_dirty=true
		elseif property=='fontSize' then
			self._inputFieldFontSize_dirty=true
		elseif property=='marginX' then
			-- self._inputFieldMarginX_dirty=true
		elseif property=='marginY' then
			-- self._inputFieldMarginY_dirty=true
		elseif property=='text' then
			self._inputFieldText_dirty=true
		elseif property=='textColor' then
			self._inputFieldTextColor_dirty=true
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
	-- print( "TextField:stylePropertyChangeHandler", event.property, event.value )
	local style = event.target
	local etype= event.type
	local property= event.property
	local value = event.value

	-- Utils.print( event )

	-- print( "TF Style Changed", etype, property, value )

	if etype==style.STYLE_RESET then
		self._debugOn_dirty = true
		self._width_dirty=true
		self._height_dirty=true
		self._anchorX_dirty=true
		self._anchorY_dirty=true

		self._align_dirty=true
		self._backgroundStyle_dirty=true
		self._inputType_dirty=true
		self._isHitActive_dirty=true
		self._isSecure_dirty=true
		self._marginX_dirty=true
		self._marginY_dirty=true
		self._returnKey_dirty=true

		self._wgtText_dirty=true
		-- self._wgtTextTextColor_dirty=true

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
		elseif property=='backgroundStyle' then
			self._backgroundStyle_dirty=true
		elseif property=='inputType' then
			self._inputType_dirty=true
		elseif property=='isHitActive' then
			self._isHitActive_dirty=true
		elseif property=='isSecure' then
			self._isSecure_dirty=true
		elseif property=='marginX' then
			self._marginX_dirty=true
		elseif property=='marginY' then
			self._marginY_dirty=true
		elseif property=='returnKey' then
			self._returnKey_dirty=true
		end

	end

	self:__invalidateProperties__()
	self:__dispatchInvalidateNotification__( property, value )
end




return TextField
