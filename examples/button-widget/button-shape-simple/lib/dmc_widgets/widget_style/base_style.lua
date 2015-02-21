--====================================================================--
-- dmc_widgets/base_style.lua
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
--== DMC Corona Widgets : Base Widget Style
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
--== DMC Widgets : newStyle Base
--====================================================================--



--====================================================================--
--== Imports


local Objects = require 'dmc_objects'
local Utils = require 'dmc_utils'



--====================================================================--
--== Setup, Constants


local newClass = Objects.newClass
local ObjectBase = Objects.ObjectBase

local sformat = string.format



--====================================================================--
--== Style Base Class
--====================================================================--


local Style = newClass( ObjectBase, {name="Style Base"}  )

--== Class Constants

Style.__base_style__ = nil  -- <instance of class>

-- table to check for properties style should have
Style._VALID_PROPERTIES = {}

-- table of properties to exclude from checking
-- these are properties which value can be 'nil'
--
Style._EXCLUDE_PROPERTY_CHECK = {} -- d

Style._STYLE_DEFAULTS = nil

--== Event Constants

Style.EVENT = 'style-event'

-- CLEARED
-- this is used when the local Style properties have been cleared
-- This is only propagated to Child Styles, they should clear also
-- affected Widgets should do a full refresh
Style.STYLE_CLEARED = 'style-cleared-event'

-- RESET
-- this is used to let a Widget know about drastic
-- changes to a Style, eg, inheritance has changed
-- This is propagated through inheritance chain as well as
-- to Child Styles and their inheritance chain
-- affected Widgets should do a full refresh
Style.STYLE_RESET = 'style-reset-event'

-- UPDATED
-- this is used when a property on a Style has changed
-- this change could be local or in inheritance chain
-- Child Styles propagate these AS LONG AS their local
-- value of the property is not set (ie, equal to nil )
-- affectd Widgets should update accordingly
Style.STYLE_UPDATED = 'style-updated-event'


--======================================================--
-- Start: Setup DMC Objects

function Style:__init__( params )
	-- print( "Style:__init__", params )
	params = params or {}
	params.data = params.data
	if params.inherit==nil then
		params.inherit=self.class.__base_style__
	end
	params.name = params.name
	params.widget = params.widget

	self:superCall( '__init__', params )
	--==--
	self._is_initialized = false

	-- Style inheritance tree
	self._inherit = params.inherit
	self._inherit_f = nil

	-- widget delegate
	self._parent = params.parent
	self._widget = params.widget
	self._onPropertyChange_f = params.onPropertyChange

	-- self._data = params.data
	self._tmp_data = params.data -- temporary save of data

	self._name = params.name
	self._debugOn = params.debugOn
	self._width = params.width
	self._height = params.height
	self._anchorX = params.anchorX
	self._anchorY = params.anchorY
end

function Style:__initComplete__()
	-- print( "Style:__initComplete__", self )
	self:superCall( '__initComplete__' )
	--==--
	local data = self:_prepareData( self._tmp_data )
	self._tmp_data = nil
	self:_parseData( data )
	self:_checkChildren()

	-- do this after style/children constructed --

	self.inherit = self._inherit -- use setter
	self.parent = self._parent -- use setter
	-- self.widget = self._widget -- use setter

	assert( self:verifyClassProperties(), "Style: missing properties"..tostring(self.class) )

	self._is_initialized = true
end

-- End: Setup DMC Objects
--======================================================--



--====================================================================--
--== Static Methods


function Style.initialize( manager )
	error( "OVERRIDE Style.addMissingDestProperties" )
end


-- create empty Style structure (default)
function Style.createStyleStructure( data )
	-- print( "Style.createStyleStructure", data )
	return {}
end


-- addMissingDestProperties()
-- copies properties from src structure to dest structure
-- if property isn't already in dest
-- Note: usually used by OTHER classes
--
function Style.addMissingDestProperties( dest, src, params )
	error( "OVERRIDE Style.addMissingDestProperties" )
end

-- addMissingDestProperties()
-- copies properties from src structure to dest structure
-- if property isn't already in dest
-- Note: usually used by OTHER classes
--
function Style.copyExistingSrcProperties( dest, src, params )
	error( "OVERRIDE Style.copyExistingSrcProperties" )
end


function Style._verifyClassProperties( src, excl  )
	-- print( "Style:_verifyClassProperties" )
	excl = excl or {}
	assert( src, "Style:_verifyClassProperties missing source" )
	--==--
	local emsg = "Style: requires property '%s'"
	local is_valid = true

	if type(src.name)~='string' then
		print(sformat(emsg,'name')) ; is_valid=false
	end
	if type(src.debugOn)~='boolean' then
		print(sformat(emsg,'debugOn')) ; is_valid=false
	end
	if not src.width and not excl.width then
		print(sformat(emsg,'width')) ; is_valid=false
	end
	if not src.height and not excl.height then
		print(sformat(emsg,'height')) ; is_valid=false
	end
	if not src.anchorX then
		print(sformat(emsg,'anchorX')) ; is_valid=false
	end
	if not src.anchorY then
		print(sformat(emsg,'anchorY')) ; is_valid=false
	end

	return is_valid
end


-- _setDefaults()
-- generic method to set defaults
function Style._setDefaults( StyleClass )
	-- print( "Style._setDefaults" )
	local defaults = StyleClass._STYLE_DEFAULTS
	local style = StyleClass:new{
		data=defaults
	}
	StyleClass.__base_style__ = style
end



--====================================================================--
--== Public Methods


-- cloneStyle()
-- make a copy of the current style setting
-- same information and inheritance
--
function Style:cloneStyle()
	local o = self.class:new{
		inherit=self._inherit
	}
	o:updateStyle( self, {force=true} ) -- clone data, force
	return o
end


-- copyStyle()
-- create a new style, setting inheritance to current style
--
function Style:copyStyle( params )
	-- print( "Style:copyStyle", self )
	params = params or {}
	params.inherit = self
	--==--
	return self.class:new( params )
end
Style.inheritStyle=Style.copyStyle


-- resetProperties()
-- sends out Reset event, tells listening Widget
-- to redraw itself
--
function Style:resetProperties()
	self:_dispatchResetEvent()
end


function Style:_clearProperties()
	-- print("Style:_clearProperties")
	self.debugOn=nil
	self.width=nil
	self.height=nil
	self.anchorX=nil
	self.anchorY=nil
end

-- this would clear any local modifications on style class
--
function Style:clearProperties()
	-- print("Style:clearProperties")
	self:_clearProperties()
	self:_dispatchClearEvent()
end

function Style:getDefaultStyles()
	-- TODO: make a copy
	return self._STYLE_DEFAULTS
end


-- params:
-- data
-- widget
-- name
function Style:createStyleFrom( params )
	-- print( "Style:createStyleFrom", params, params.copy )
	params = params or {}
	if params.copy==nil then params.copy=true end
	--==--
	local data = params.data
	local copy = params.copy ; params.copy=nil

	local StyleClass = self.class
	local style
	if data==nil then
		style = StyleClass:new( params )
	elseif type(data.isa)=='function' then

		if not copy then
			style = data
		else
			style = data:copyStyle( params )
		end
	else
		-- Lua structure
		style = StyleClass:new( params )
	end

	assert( style, "failed to create style" )

	return style
end


--======================================================--
-- Misc

--== inherit

function Style.__getters:inherit()
	return self._inherit
end

-- value should be a instance of Style Class or nil
--
function Style.__setters:inherit( value )
	-- print( "Style.__setters:inherit", self, value )
	assert( value==nil or value:isa( Style ) )
	--==--
	local o = self._inherit
	local f = self._inherit_f
	if o and f then
		o:removeEventListener( o.EVENT, f )
		self._inherit = nil
		self._inherit_f = nil
	end

	o = value

	if o then
		f = self:createCallback( self._inheritedStyleEvent_handler )
		o:addEventListener( o.EVENT, f )
		self._inherit = o
		self._inherit_f = f
	end
end

--== parent

function Style.__getters:parent()
	return self._parent
end

-- value should be a instance of Style Class or nil
--
function Style.__setters:parent( value )
	-- print( "Style.__setters:parent", self, value )
	assert( value==nil or value:isa( Style ) )
	--==--
	local o = self._parent
	local f = self._parent_f
	if o and f then
		o:removeEventListener( o.EVENT, f )
		self._parent = nil
		self._parent_f = nil
	end

	o = value

	if o then
		f = self:createCallback( self._parentStyleEvent_handler )
		o:addEventListener( o.EVENT, f )
		self._parent = o
		self._parent_f = f
	end
end

--== widget

function Style.__getters:widget()
	-- print( "Style.__getters:widget" )
	return self._widget
end
function Style.__setters:widget( value )
	-- print( "Style.__setters:widget", value )
	-- TODO: update to check class, not table
	assert( value==nil or type(value)=='table' )
	self._widget = value
end


-- onPropertyChange
--
function Style.__setters:onPropertyChange( func )
	-- print( "Style.__setters:onPropertyChange", func )
	assert( type(func)=='function' )
	--==--
	self._onPropertyChange_f = func
end


--======================================================--
-- Access to style properties

--[[
override these getters/setters/methods if necesary
--]]

--== name

function Style.__getters:name()
	-- print( 'Style.__getters:name', self._inherit )
	local value = self._name
	if value==nil and self._inherit then
		value = self._inherit.name
	end
	return value
end
function Style.__setters:name( value )
	-- print( 'Style.__setters:name', value )
	assert( (value==nil and self._inherit) or type(value)=='string' )
	--==--
	if value == self._name then return end
	self._name = value
end

--== debugOn

function Style.__getters:debugOn()
	local value = self._debugOn
	if value==nil and self._inherit then
		value = self._inherit.debugOn
	end
	return value
end
function Style.__setters:debugOn( value )
	-- print( "Style.__setters:debugOn", value )
	assert( type(value)=='boolean' or (value==nil and self._inherit) )
	--==--
	if value == self._debugOn then return end
	self._debugOn = value
	self:_dispatchChangeEvent( 'debugOn', value )
end

--== X

function Style.__getters:x()
	local value = self._x
	if value==nil and self._inherit then
		value = self._inherit.x
	end
	return value
end
function Style.__setters:x( value )
	-- print( "Style.__setters:x", value )
	assert( type(value)=='number' or (value==nil and self._inherit) )
	--==--
	if value == self._x then return end
	self._x = value
	self:_dispatchChangeEvent( 'x', value )
end

--== Y

function Style.__getters:y()
	local value = self._y
	if value==nil and self._inherit then
		value = self._inherit.y
	end
	return value
end
function Style.__setters:y( value )
	-- print( "Style.__setters:y", value )
	assert( type(value)=='number' or (value==nil and self._inherit) )
	--==--
	if value == self._y then return end
	self._y = value
	self:_dispatchChangeEvent( 'y', value )
end

--== width

function Style.__getters:width()
	-- print( "Style.__getters:width", self.name, self._width  )
	local value = self._width
	if value==nil and self._inherit then
		value = self._inherit.width
	end
	return value
end
function Style.__setters:width( value, force )
	-- print( "Style.__setters:width", self.name, value, force )
	assert( type(value)=='number' or (value==nil and self._inherit) )
	--==--
	if value==self._width and not force then return end
	self._width = value
	self:_dispatchChangeEvent( 'width', value )
end

--== height

function Style.__getters:height()
	local value = self._height
	if value==nil and self._inherit then
		value = self._inherit.height
	end
	return value
end
function Style.__setters:height( value )
	-- print( "Style.__setters:height", self, value )
	assert( type(value)=='number' or (value==nil and self._inherit) )
	--==--
	if value == self._height then return end
	self._height = value
	self:_dispatchChangeEvent( 'height', value )
end


--== align

function Style.__getters:align()
	local value = self._align
	if value==nil and self._inherit then
		value = self._inherit.align
	end
	return value
end
function Style.__setters:align( value )
	-- print( 'Style.__setters:align', value )
	assert( type(value)=='string' or (value==nil and self._inherit) )
	--==--
	if value==self._align then return end
	self._align = value
	self:_dispatchChangeEvent( 'align', value )
end

--== anchorX

function Style.__getters:anchorX()
	local value = self._anchorX
	if value==nil and self._inherit then
		value = self._inherit.anchorX
	end
	return value
end
function Style.__setters:anchorX( value )
	-- print( 'Style.__setters:anchorX', value, self )
	assert( type(value)=='number' or (value==nil and self._inherit) )
	--==--
	if value==self._anchorX then return end
	self._anchorX = value
	self:_dispatchChangeEvent( 'anchorX', value )
end

--== anchorY

function Style.__getters:anchorY()
	local value = self._anchorY
	if value==nil and self._inherit then
		value = self._inherit.anchorY
	end
	return value
end
function Style.__setters:anchorY( value )
	-- print( 'Style.__setters:anchorY', value )
	assert( value==nil or type(value)=='number' )
	if value==nil and self._inherit==nil  then print( "WARN") ; return end
	--==--
	if value==self._anchorY then return end
	self._anchorY = value
	self:_dispatchChangeEvent( 'anchorY', value )
end

--== fillColor

function Style.__getters:fillColor()
	-- print( "Style.__getters:fillColor", self, self._fillColor )
	local value = self._fillColor
	if value==nil and self._inherit then
		value = self._inherit.fillColor
	end
	return value
end
function Style.__setters:fillColor( value )
	-- print( "Style.__setters:fillColor", value )
	assert( value or (value==nil and self._inherit) )
	--==--
	self._fillColor = value
	self:_dispatchChangeEvent( 'fillColor', value )
end

--== font

function Style.__getters:font()
	local value = self._font
	if value==nil and self._inherit then
		value = self._inherit.font
	end
	return value
end
function Style.__setters:font( value )
	-- print( "Style.__setters:font", value )
	assert( value or (value==nil and self._inherit) )
	--==--
	self._font = value
	self:_dispatchChangeEvent( 'font', value )
end

--== fontSize

function Style.__getters:fontSize()
	local value = self._fontSize
	if value==nil and self._inherit then
		value = self._inherit.fontSize
	end
	return value
end
function Style.__setters:fontSize( value )
	-- print( "Style.__setters:fontSize", value )
	assert( type(value)=='number' or (value==nil and self._inherit) )
	--==--
	self._fontSize = value
	self:_dispatchChangeEvent( 'fontSize', value )
end

--== marginX

function Style.__getters:marginX()
	local value = self._marginX
	if value==nil and self._inherit then
		value = self._inherit.marginX
	end
	return value
end
function Style.__setters:marginX( value )
	-- print( "Style.__setters:marginX", value )
	assert( type(value)=='number' or (value==nil and self._inherit) )
	--==--
	self._marginX = value
	self:_dispatchChangeEvent( 'marginX', value )
end

--== marginY

function Style.__getters:marginY()
	local value = self._marginY
	if value==nil and self._inherit then
		value = self._inherit.marginY
	end
	return value
end
function Style.__setters:marginY( value )
	-- print( "Style.__setters:marginY", value )
	assert( type(value)=='number' or (value==nil and self._inherit) )
	--==--
	self._marginY = value
	self:_dispatchChangeEvent( 'marginY', value )
end

--== strokeColor

function Style.__getters:strokeColor()
	local value = self._strokeColor
	if value==nil and self._inherit then
		value = self._inherit.strokeColor
	end
	return value
end
function Style.__setters:strokeColor( value )
	-- print( "Style.__setters:strokeColor", value )
	assert( value or (value==nil and self._inherit) )
	--==--
	self._strokeColor = value
	self:_dispatchChangeEvent( 'strokeColor', value )
end

--== strokeWidth

function Style.__getters:strokeWidth( value )
	local value = self._strokeWidth
	if value==nil and self._inherit then
		value = self._inherit.strokeWidth
	end
	return value
end
function Style.__setters:strokeWidth( value )
	-- print( "Style.__setters:strokeWidth", value )
	assert( type(value)=='number' or (value==nil and self._inherit) )
	--==--
	if value == self._strokeWidth then return end
	self._strokeWidth = value
	self:_dispatchChangeEvent( 'strokeWidth', value )

end

--== textColor

function Style.__getters:textColor()
	local value = self._textColor
	if value==nil and self._inherit then
		value = self._inherit.textColor
	end
	return value
end
function Style.__setters:textColor( value )
	-- print( "Style.__setters:textColor", value )
	assert( value or (value==nil and self._inherit) )
	--==--
	if value == self._textColor then return end
	self._textColor = value
	self:_dispatchChangeEvent( 'textColor', value )
end


-- verifyClassProperties()
-- ability to check properties to make sure everything went well
--
function Style:verifyClassProperties()
	-- print( "Style:verifyClassProperties" )
	return Style._verifyClassProperties( self )
end


--====================================================================--
--== Private Methods


--======================================================--
-- Style Class setup

-- _prepareData()
-- if necessary, modify data before we process it
-- usually this is to copy styles from parent to child
--
function Style:_prepareData( data )
	-- print( "OVERRIDE Style:_prepareData", self )
	-- data could be nil, Lua structure, or class instance
	if type(data)=='table' and data.isa then
		-- if we have an Instance, dump it
		data=nil
	end
	return data
end

-- _checkChildren()
-- check children after class initialization
-- eg, if a style doesn't have any child properties (eg, background)
-- to actually create the substyle
--
function Style:_checkChildren()
	-- print("OVERRIDE Style:_checkChildren")
end


-- _parseData()
-- parse through the Lua data given, creating properties
-- an substyles as we loop through
--
function Style:_parseData( data )
	-- print( "Style:_parseData", self, data )
	if data==nil then return end

	-- Utils.print( data )
	-- prep tables of things to exclude, etc
	local DEF = self._STYLE_DEFAULTS
	local EXCL = self._EXCLUDE_PROPERTY_CHECK

	for k,v in pairs( data ) do
		-- print(k,v)
		if DEF[k]==nil and not EXCL[k] then
			error( sformat( "Style: invalid property style found '%s'", tostring(k) ) )
		end
		self[k]=v
	end
end


-- _getRawProperty()
-- property access with name, and not using getters
--
function Style:_getRawProperty( name )
	assert( type(name)=='string' )
	local key = '_'..name
	return self[key]
end


--======================================================--
-- Event Dispatch


-- _dispatchChangeEvent()
-- send out property-changed event to listeners
-- and to any inherits
--
function Style:_dispatchChangeEvent( prop, value )
	-- print( 'Style:_dispatchChangeEvent', prop, value, self )
	local widget = self._widget
	local callback = self._onPropertyChange_f

	if not self._is_initialized then return end

	local e = self:createEvent( self.STYLE_UPDATED, {property=prop,value=value}, {merge=true} )

	-- dispatch event to different listeners
	if widget and widget.stylePropertyChangeHandler then
		widget:stylePropertyChangeHandler( e )
	end
	--
	if callback then callback( e ) end

	-- styles which inherit from this one
	self:dispatchRawEvent( e )
end


-- _dispatchClearEvent()
-- send out event to clear properties
-- and to any inherits
--
function Style:_dispatchClearEvent()
	-- print( 'Style:_dispatchClearEvent', self )
	local widget = self._widget
	local callback = self._onPropertyChange_f

	if not self._is_initialized then return end

	local e = self:createEvent( self.STYLE_CLEARED )

	-- dispatch event to different listeners
	if widget and widget.stylePropertyChangeHandler then
		widget:stylePropertyChangeHandler( e )
	end
	--
	if callback then callback( e ) end

	-- styles which inherit from this one
	self:dispatchRawEvent( e )
end


-- _dispatchResetEvent()
-- send out Reset event to listeners
--
function Style:_dispatchResetEvent()
	-- print( 'Style:_dispatchResetEvent', self )
	--==--
	local widget = self._widget
	local callback = self._onPropertyChange_f

	if not widget and not callback then return end

	local e = {
		name=self.EVENT,
		target=self,
		type=self.STYLE_RESET
	}
	if widget and widget.stylePropertyChangeHandler then
		widget:stylePropertyChangeHandler( e )
	end
	if callback then callback( e ) end
end




--====================================================================--
--== Event Handlers


-- _parentStyleEvent_handler()
-- handle parent property changes

function Style:_parentStyleEvent_handler( event )
	-- print( "Style:_parentStyleEvent_handler", event.type, self )
	local style = event.target
	local etype = event.type

	if etype==style.STYLE_CLEARED then
		self:clearProperties()

	elseif etype==style.STYLE_RESET then
		self._dispatchResetEvent()

	elseif etype==style.STYLE_UPDATED then
		local property, value = event.property, event.value
		-- we accept changes to parent as our own
		-- however, check to see if property is valid
		-- parent could have other properties
		if self._VALID_PROPERTIES[property] then
			self.__setters[property]( self, value, true )
		end
	end

end


-- _inheritedStyleEvent_handler()
-- handle inherited style-events
--
function Style:_inheritedStyleEvent_handler( event )
	-- print( "Style:_inheritedStyleEvent_handler", event, self )
	local style = event.target
	local etype = event.type

	if etype==style.STYLE_CLEARED then
		-- pass

	elseif etype==style.STYLE_RESET then
		self._dispatchResetEvent()

	elseif etype==style.STYLE_UPDATED then
		-- only re-dispatch property changes if our property is empty
		if self:_getRawProperty( event.property ) == nil then
			self:_dispatchChangeEvent( event.property, event.value )
		end
	end

end



return Style
