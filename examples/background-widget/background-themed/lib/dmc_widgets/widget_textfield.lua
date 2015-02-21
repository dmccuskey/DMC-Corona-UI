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


local LifecycleMixModule = require 'dmc_lifecycle_mix'
local Objects = require 'dmc_objects'
local ThemeMixModule = require( dmc_widget_func.find( 'widget_theme_mix' ) )
local Utils = require 'dmc_utils'

-- set later
local Widgets = nil
local ThemeMgr = nil



--====================================================================--
--== Setup, Constants


local newClass = Objects.newClass
local ComponentBase = Objects.ComponentBase

local LifecycleMix = LifecycleMixModule.LifecycleMix
local ThemeMix = ThemeMixModule.ThemeMix



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
-- Start: Setup DMC Objects

--== Init

function TextField:__init__( params )
	-- print( "TextField:__init__", params, self )
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

	-- properties stored in class

	self._x = params.x
	self._x_dirty=true
	self._y = params.y
	self._y_dirty=true

	self._displayText = params.text
	self._displayText_dirty=true
	self._hintText = params.hintText
	self._hintText_dirty=true

	self._isWidgetEnabled = true

	self._isEditActive = { state=false, set_focus=nil }
	self._isEditActive_dirty = true

	self._isValid = true
	self._isValid_dirty = true

	self._clearOnBeginEdit = false
	self._adjustFontToFit = false
	self._clearButtonMode = 'never'

	self._keyboardFocus=false
	self._keyboardFocus_dirty=true
	self._keyboardFocus_timer=nil

	-- properties stored in style

	self._width_dirty=true
	self._height_dirty=true

	self._align_dirty=true
	self._anchorX_dirty=true
	self._anchorY_dirty=true
	self._backgroundStyle_dirty = true
	self._inputType_dirty=true
	self._isHitActive_dirty=true
	self._isHitTestable_dirty=true
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
	self._inputFieldHeight_dirty=true
	self._inputFieldStyle_dirty=true
	self._inputFieldText_dirty=true
	self._inputFieldTextColor_dirty=true

	--== Object References ==--

	self._tmp_style = params.style -- save

	self._delegate = nil -- delegate
	self._formatter = params.formatter -- data formatter

	self._rctHit = nil -- our rectangle hit area
	self._rctHit_f = nil

	self._wgtBg = nil -- background widget
	self._wgtBg_f = nil -- widget handler
	self._wgtBg_dirty=true

	self._wgtText = nil -- text widget (for both hint and value display)
	self._wgtText_f = nil -- widget handler
	self._wgtText_dirty=true

	self._inputField = nil -- textfield object
	self._inputField_f = nil -- textfield handler
	self._inputField_dirty=true
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
	local o = display.newRect( 0,0,0,0 )
	o.anchorX, o.anchorY = 0.5,0.5
	self:insert( o )
	self._rctHit = o
end

function TextField:__undoCreateView__()
	-- print( "TextField:__undoCreateView__" )
	self._rctHit:removeSelf()
	self._rctHit=nil
	--==--
	self:superCall( ComponentBase, '__undoCreateView__' )
end


--== initComplete

function TextField:__initComplete__()
	-- print( "TextField:__initComplete__" )
	self:superCall( ComponentBase, '__initComplete__' )
	--==--
	self._rctHit_f = self:createCallback( self._hitAreaTouch_handler )
	self._rctHit:addEventListener( 'touch', self._rctHit_f )

	self._inputField_f = self:createCallback( self._textFieldEvent_handler )
	self._textStyle_f = self:createCallback( self.textStyleChange_handler )
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

	self._wgtBg_f = nil
	self._textStyle_f = nil
	self._inputField_f = nil

	self._rctHit:removeEventListener( 'touch', self._rctHit_f )
	self._rctHit_f = nil
	--==--
	self:superCall( ComponentBase, '__undoInitComplete__' )
end

-- END: Setup DMC Objects
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


--======================================================--
-- Local Properties

-- .X
--
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

-- .Y
--
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

-- .hintText
--
function TextField.__getters:hintText()
	return self._hintText
end
function TextField.__setters:hintText( value )
	-- print( 'TextField.__setters:hintText', value )
	if value == self._hintText then return end
	self._hintText = value
	self._hintText_dirty=true
	self:__invalidateProperties__()
end

-- .isEditing
--
function TextField.__getters:isEditing()
	return self._isEditActive.state
end

-- setEditActive()
--
function TextField:setEditActive( value, params )
	-- print( 'TextField:setEditActive', value )
	params = params or {}
	if params.set_focus==nil then params.set_focus=true end
	assert( type(value)=='boolean' )
	--==--
	params.state=value
	self._isEditActive = params
	self._isEditActive_dirty=true
	self:__invalidateProperties__()
end

-- .isSecure
--
function TextField.__getters:isSecure()
	return self.curr_style.isSecure
end
function TextField.__setters:isSecure( value )
	-- print( 'TextField.__setters:isSecure', value )
	self.curr_style.isSecure = value
end

-- .isValid
--
function TextField.__setters:isValid( value )
	-- print( 'TextField.__setters:isValid', value )
	assert( type(value)=='boolean' )
	--==--
	if value == self._isValid then return end
	self._isValid = value
	self._isValid_dirty=true
	self:__invalidateProperties__()
end

-- .text
--
function TextField.__getters:text()
	return self._displayText
end
function TextField.__setters:text( value )
	-- print( 'TextField.__setters:text', value )
	assert( type(value)=='string' )
	--==--
	if value == self._displayText then return end
	self._displayText = value
	self._displayText_dirty=true
	self:__invalidateProperties__()
end

-- setKeyboardFocus()
--
function TextField:setKeyboardFocus()
	-- print( 'TextField:setKeyboardFocus' )
	self._keyboardFocus = true
	self._keyboardFocus_dirty = true
	self:__invalidateProperties__()
end

-- unsetKeyboardFocus()
--
function TextField:unsetKeyboardFocus()
	-- print( 'TextField:unsetKeyboardFocus' )
	self._keyboardFocus = false
	self._keyboardFocus_dirty = true
	self:__invalidateProperties__()
end

-- setReturnKey()
--
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


--======================================================--
-- Background Style Properties

-- .backgroundStrokeWidth
--
function TextField.__getters:backgroundStrokeWidth()
	return self.curr_style.background.strokeWidth
end
function TextField.__setters:backgroundStrokeWidth( value )
	-- print( 'TextField.__setters:backgroundStrokeWidth', value )
	self.curr_style.background.strokeWidth = value
end

-- setBackgroundFillColor()
--
function TextField:setBackgroundFillColor( ... )
	-- print( 'TextField:setBackgroundFillColor' )
	self.curr_style.background.fillColor = {...}
end

-- setBackgroundStrokeColor()
--
function TextField:setBackgroundStrokeColor( ... )
	-- print( 'TextField:setBackgroundStrokeColor' )
	self.curr_style.background.strokeColor = {...}
end


--======================================================--
-- Hint Style Properties

-- .hintFont
--
function TextField.__setters:hintFont( value )
	-- print( 'TextField.__setters:hintFont', value )
	self.curr_style.hint.font = value
end

-- .hintFontSize
--
function TextField.__setters:hintFontSize( value )
	-- print( 'TextField.__setters:hintFontSize', value )
	self.curr_style.hint.fontSize = value
end

-- setHintColor()
--
function TextField:setHintColor( ... )
	-- print( 'TextField:setHintColor' )
	self.curr_style.hint.textColor = {...}
end


--======================================================--
-- Display Style Properties

-- .displayFont
--
function TextField.__setters:displayFont( value )
	-- print( 'TextField.__setters:displayFont', value )
	self.curr_style.display.font = value
end

-- .displayFontSize
--
function TextField.__setters:displayFontSize( value )
	-- print( 'TextField.__setters:displayFontSize', value )
	self.curr_style.display.fontSize = value
end

-- setDisplayColor()
--
function TextField:setDisplayColor( ... )
	-- print( 'TextField:setDisplayColor' )
	self.curr_style.display.textColor = {...}
end


--======================================================--
-- Delegate

-- shouldBeginEditing()
--
function TextField:shouldBeginEditing()
	return self._isWidgetEnabled
end

-- on tap
function TextField:_delegateShouldBeginEditing()
	local delegate = self._delegate or self
	if not delegate or not delegate.shouldBeginEditing then
		delegate = self
	end
	return delegate:shouldBeginEditing()
end


-- shouldEndEditing()
--
function TextField:shouldEndEditing( event )
	return self._isValid
end

-- after end/submit
function TextField:_delegateShouldEndEditing()
	local delegate = self._delegate or self
	if not delegate or not delegate.shouldEndEditing then
		delegate = self
	end
	return delegate:shouldEndEditing()
end


-- shouldClearTextField()
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
	return delegate:shouldClearTextField()
end


--======================================================--
-- Formatter

-- .formatter
--
function TextField.__setters:formatter( value )
	-- print( 'TextField.__setters:formatter', value )
	assert( value==nil or type(value)=='table' )
	--==--
	self._formatter = value
end

-- areCharactersValid()
--
function TextField:areCharactersValid( chars, text )
	return true
end

-- _formatterAreCharactersValid()
--
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


--======================================================--
-- Theme Methods

-- clearStyle()
--
function TextField:clearStyle()
	local style=self.curr_style
	style:clearProperties()
	style.background:clearProperties()
	style.hint:clearProperties()
	style.display:clearProperties()
end

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

	local o = Widgets.newBackground()
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

	local o = Widgets.newText()
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
	self._inputFieldStyle_dirty=true
	self._inputFieldText_dirty=true
	self._inputFieldTextColor_dirty=true

end


function TextField:__commitProperties__()
	-- print( 'TextField:__commitProperties__' )

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


	--== View

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
		input.width = width
		style.background.width = width
		style.hint.width = width
		style.display.width = width
		self._width_dirty=false

		self._inputFieldX_dirty=true
	end
	if self._height_dirty then
		local height = style.height
		hit.height = height
		style.background.height = height
		style.hint.height = height
		style.display.height = height
		self._height_dirty=false

		self._inputFieldY_dirty=true
	end

	-- align

	if self._align_dirty then
		style.hint.align = style.align
		style.display.align = style.align
		self._align_dirty = false

		self._inputFieldX_dirty=true
	end

	-- anchorX/anchorY

	if self._anchorX_dirty then
		hit.anchorX = style.anchorX
		style.background.anchorX = style.anchorX
		style.hint.anchorX = style.anchorX
		style.display.anchorX = style.anchorX
		self._anchorX_dirty = false

		self._inputFieldX_dirty=true
	end
	if self._anchorY_dirty then
		hit.anchorY = style.anchorY
		style.background.anchorY = style.anchorY
		style.hint.anchorY = style.anchorY
		style.display.anchorY = style.anchorY
		self._anchorY_dirty = false

		self._inputFieldY_dirty=true
	end

	-- marginX/marginY

	if self._marginX_dirty then
		style.hint.marginX = style.marginX
		style.display.marginX = style.marginX
		self._marginX_dirty = false

		self._inputFieldX_dirty=true
	end
	if self._marginY_dirty then
		style.hint.marginY = style.marginY
		style.display.marginY = style.marginY
		self._marginY_dirty = false
	end

	-- inputType

	if self._inputType_dirty then
		if style.inputType==TextField.INPUT_PASSWORD then
			input.inputType = TextField.INPUT_DEFAULT
			style.isSecure = true
		else
			input.inputType = style.inputType
		end
		self._inputType_dirty=false
	end

	-- isSecure

	if self._isSecure_dirty then
		-- this next line makes simulator edit field
		input.isSecure = style.isSecure
		-- so we force to inactive
		self:setEditActive( false )
		self._isSecure_dirty=false

		self._wgtTextIsSecure_dirty=true
	end

	--== Virtual

	if self._widgetStyle_dirty then
		self._widgetStyle_dirty=false

		self._wgtBgStyle_dirty=true
		self._wgtTextStyle_dirty=true
		self._inputFieldStyle_dirty=false
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

	if self._isHitTestable then
		hit.isHitTestable=style.isHitTestable
		self._isHitTestable=false
	end

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

	if self._inputFieldHeight_dirty then
		input.height = text:getTextHeight()
		self._inputFieldHeight_dirty=true
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
		input.hasBackground=false
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
		if style.debugOn then
			hit:setFillColor( 1,0,0,0.5 )
		else
			hit:setFillColor( 0,0,0,0 )
		end
		self._debugOn_dirty=false
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

	self._tmp_text = self._displayText -- start last ok state

	event.target=self
	event.text=self._displayText -- fix broken simulator
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
	end

	if not self._has_focus then return false end

	local bgCb = background.contentBounds
	local isWithinBounds =
		( bgCb.xMin <= e.x and bgCb.xMax >= e.x
			and bgCb.yMin <= e.y and bgCb.yMax >= e.y )

	if phase=='ended' or phase=='canceled' then
		display.getCurrentStage():setFocus( nil )
		self._has_focus = false

		if isWithinBounds then
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
	-- print( "TextField:textStyleChange_handler", event )

	local target = event.target
	local etype= event.type
	local property= event.property
	local value = event.value

	-- print( "Style Changed", etype, property, value )

	if etype == target.STYLE_RESET then
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
	-- print( "TextField:stylePropertyChangeHandler", event )
	local target = event.target
	local etype= event.type
	local property= event.property
	local value = event.value

	-- Utils.print( event )

	-- print( "Style Changed", etype, property, value )

	if etype == target.STYLE_RESET then
		self._debugOn_dirty = true

		self._width_dirty=true
		self._height_dirty=true

		self._align_dirty=true
		self._anchorX_dirty=true
		self._anchorY_dirty=true
		self._backgroundStyle_dirty = true
		self._inputType_dirty=true
		self._isHitActive_dirty=true
		self._isHitTestable_dirty=true
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

		elseif property=='align' then
			self._align_dirty=true
		elseif property=='anchorX' then
			self._anchorX_dirty=true
		elseif property=='anchorY' then
			self._anchorY_dirty=true
		elseif property=='backgroundStyle' then
			self._backgroundStyle_dirty=true
		elseif property=='inputType' then
			self._inputType_dirty=true
		elseif property=='isHitActive' then
			self._isHitActive_dirty=true
		elseif property=='isHitTestable' then
			self._isHitTestable_dirty=true
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
