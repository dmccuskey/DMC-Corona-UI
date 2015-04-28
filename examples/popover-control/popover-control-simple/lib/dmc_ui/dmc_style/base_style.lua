--====================================================================--
-- dmc_widget/base_style.lua
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
--== DMC Corona UI : Style Base Class
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
--== DMC UI : Style Base Class
--====================================================================--



--====================================================================--
--== Imports


local Kolor = require 'dmc_kolor'
local Objects = require 'dmc_objects'
local Utils = require 'dmc_utils'
local uiConst = require( ui_find( 'ui_constants' ) )



--====================================================================--
--== Setup, Constants


local newClass = Objects.newClass
local ObjectBase = Objects.ObjectBase

local sfmt = string.format
local tinsert = table.insert

--== To be set in initialize()
local Style = nil



--====================================================================--
--== Style Base Class
--====================================================================--


local BaseStyle = newClass( ObjectBase, {name="Style Base"}  )

--== Class Constants

--- the main style instance for the class.
-- is is the root style for the class, all styles
-- inherit from this one. set later in setup.
--
BaseStyle.__base_style__ = nil  -- <instance of class>

--- table (hash) of valid style properties.
-- used to check properties when updates come from Parent Style
-- It's highly possible for Parent to have properties not available in
-- a Child Style, so those should be skipped for propagation
--
BaseStyle._VALID_PROPERTIES = {}

-- table of properties to exclude from checking
-- these are properties which value can be 'nil'
--
BaseStyle._EXCLUDE_PROPERTY_CHECK = {}

--- table (hash) of children styles.
-- this allows data (structures) for children
-- to be processed separately.
-- key/value should be name of child set to true, eg
-- { text=true }
--
BaseStyle._CHILDREN = {}

BaseStyle._VALID_PROPERTIES = {
	debugOn=true,
	width=true,
	height=true,
	anchorX=true,
	anchorY=true,
}
BaseStyle._STYLE_DEFAULTS = {
	debugOn=false,
	-- width=nil,
	-- height=nil,
	anchorX=0.5,
	anchorY=0.5,
}

BaseStyle._TEST_DEFAULTS = {
	debugOn=false,
	-- width=nil,
	-- height=nil,
	anchorX=4,
	anchorY=4,
}

BaseStyle.MODE = uiConst.RUN_MODE

BaseStyle._DEFAULTS = BaseStyle._STYLE_DEFAULTS

BaseStyle.NO_INHERIT = {}

--== Event Constants

BaseStyle.EVENT = 'style-event'

-- DESTROYED
-- this is used to let a Widget know when a BaseStyle
-- is about to be removed
-- This is NOT propagated through inheritance chain
-- affected Widgets should release the Style
BaseStyle.STYLE_DESTROYED = 'style-destroy-event'

-- RESET
-- this is used to let a Widget know about drastic
-- changes to a Style, eg, inheritance has changed
-- This is propagated through inheritance chain as well as
-- to Child Styles and their inheritance chain
-- affected Widgets should do a full refresh
BaseStyle.STYLE_RESET = 'style-reset-event'

-- PROPERTY_CHANGED
-- this is used when a property on a Style has changed
-- this change could be local or in inheritance chain
-- Child Styles propagate these AS LONG AS their local
-- value of the property is not set (ie, equal to nil )
-- affectd Widgets should update accordingly
BaseStyle.PROPERTY_CHANGED = 'style-property-changed-event'


--======================================================--
-- Start: Setup DMC Objects

function BaseStyle:__init__( params )
	-- print( "BaseStyle:__init__", params, self )
	params = params or {}
	params.data = params.data
	params.name = params.name
	params.widget = params.widget

	self:superCall( '__init__', params )
	--==--

  if self.is_class then return end

	self._isInitialized = false
	self._isClearing = false
	self._isDestroying = false

	-- inheritance style
	if params.inherit==nil then
		params.inherit = self:getBaseStyle( params.data )
	end

	self._inherit = params.inherit
	self._inherit_f = nil

	-- parent style
	self._parent = params.parent
	self._parent_f = nil

	-- widget delegate
	self._widget = params.widget

	self._onPropertyChange_f = params.onPropertyChange

	self._tmp_data = params.data -- temporary save of data
	self._tmp_dataSrc = params.dataSrc -- temporary save of data

	self._name = params.name
	self._debugOn = params.debugOn
	self._width = params.width
	self._height = params.height
	self._anchorX = params.anchorX
	self._anchorY = params.anchorY
end

function BaseStyle:__initComplete__()
	-- print( "BaseStyle:__initComplete__", self )
	self:superCall( '__initComplete__' )
	--==--
	self._isDestroying = false

	local data = self:_prepareData( self._tmp_data,
		self._tmp_dataSrc, {inherit=self._inherit} )
	self._tmp_data = nil
	self._tmp_dataSrc = nil
	self:_parseData( data )

	-- do this after style/children constructed --

	self.inherit = self._inherit -- use setter
	self.parent = self._parent -- use setter
	self.widget = self._widget -- use setter

	assert( self:verifyProperties(), sfmt( "Missing properties for Style '%s'", tostring(self.class) ) )

	self._isInitialized = true
end

function BaseStyle:__undoInitComplete__()
	-- print( "BaseStyle:__undoInitComplete__", self )
	--==--

	self._isDestroying = true

	self:_dispatchDestroyEvent()

	self.widget = nil
	self.parent = nil
	self.inherit = nil

	self:_destroyChildren()

	--==--
	self:superCall( '__undoInitComplete__' )
end


-- End: Setup DMC Objects
--======================================================--



--====================================================================--
--== Static Methods


function BaseStyle:isChild( name )
	return (self._CHILDREN[ name ]~=nil)
end
function BaseStyle:getChildren( name )
	return self._CHILDREN
end
function BaseStyle:nilProperty( name )
	return (self._EXCLUDE_PROPERTY_CHECK[ name ]~=nil)
end


function BaseStyle.initialize( manager, params )
	-- print( "BaseStyle.initialize", manager )
	Style = manager
end


-- createStyleStructure()
-- creates basic structure for current Style
-- 'src', table/obj with structure of current Style
--
function BaseStyle.createStyleStructure( src )
	-- print( "BaseStyle.createStyleStructure", src )
	src = src or {}
	--==--
	return {}
end




-- addMissingDestProperties()
-- copies properties from src structure to dest structure
-- if property isn't already in dest
-- this is used layer in all properties
-- Note: usually used by OTHER classes but ONLY
-- to create root Style instances

-- 'dest' should be basic structure of Style type
-- 'srcs' table of sources usually be anything, but usually parent of Style
--
function BaseStyle.addMissingDestProperties( dest, src )
	-- print( "BaseStyle.addMissingDestProperties", dest, src )
	assert( dest )
	--==--
	local srcs = { BaseStyle._DEFAULTS }
	if src then tinsert( srcs, 1, src ) end

	for i=1,#srcs do
		local src = srcs[i]

		if dest.debugOn==nil then dest.debugOn=src.debugOn end
		if dest.width==nil then dest.width=src.width end
		if dest.height==nil then dest.height=src.height end
		if dest.anchorX==nil then dest.anchorX=src.anchorX end
		if dest.anchorY==nil then dest.anchorY=src.anchorY end

	end

	return dest
end


-- _addMissingChildProperties()
-- take destination and source. pass along destination
-- to sub-style classes and let them fill in information
-- as needed.
-- this is used to make a structure with ALL properties
-- 'src' allows us to send in some default properties
-- src should be a table of items, things to copy and class master
function BaseStyle._addMissingChildProperties( dest, srcs )
	-- print( "OVERRIDE BaseStyle._addMissingChildProperties" )
	return dest
end


-- copyExistingSrcProperties()
-- copies properties from src structure to dest structure
-- only if src has property and dest does not
-- purpose is to allow property overrides and inheritance
-- copied down from parent style
-- force makes exact copy of source
--
function BaseStyle.copyExistingSrcProperties( dest, src, params )
	-- print( "BaseStyle.copyExistingSrcProperties", dest, src, params )
	assert( dest )
	if not src then return end
	params = params or {}
	if params.force==nil then params.force=false end
	--==--
	local force=params.force

	if (src.debugOn~=nil and dest.debugOn==nil) or force then
		dest.debugOn=src.debugOn
	end
	if (src.width~=nil and dest.width==nil) or force then
		dest.width=src.width
	end
	if (src.height~=nil and dest.height==nil) or force then
		dest.height=src.height
	end
	if (src.anchorX~=nil and dest.anchorX==nil) or force then
		dest.anchorX=src.anchorX
	end
	if (src.anchorY~=nil and dest.anchorY==nil) or force then
		dest.anchorY=src.anchorY
	end

	return dest
end


function BaseStyle._verifyStyleProperties( src, exclude )
	-- print( "BaseStyle:_verifyStyleProperties", src, self )
	assert( src, "BaseStyle:verifyStyleProperties requires source")
	exclude = exclude or {}
	--==--
	local emsg = "Style (Base) requires property '%s'"
	local is_valid = true

	if type(src.debugOn)~='boolean' then
		print( sfmt(emsg,'debugOn') ) ; is_valid=false
	end
	if not src.width and not exclude.width then
		print( sfmt(emsg,'width') ) ; is_valid=false
	end
	if not src.height and not exclude.height then
		print( sfmt(emsg,'height') ) ; is_valid=false
	end
	if not src.anchorX then
		print( sfmt(emsg,'anchorX') ) ; is_valid=false
	end
	if not src.anchorY then
		print( sfmt(emsg,'anchorY') ) ; is_valid=false
	end

	return is_valid
end


-- _setDefaults()
-- generic method to set defaults
function BaseStyle._setDefaults( StyleClass, params )
	-- print( "BaseStyle._setDefaults", StyleClass )
	params = params or {}
	if params.defaults==nil then params.defaults=StyleClass._DEFAULTS end
	--==--
	local def = params.defaults

	def = StyleClass.addMissingDestProperties( def )

	local style = StyleClass:new{
		data=def,
		inherit=BaseStyle.NO_INHERIT
	}

	StyleClass.__base_style__ = style
end



--====================================================================--
--== Public Methods


function BaseStyle:getBaseStyle()
	-- print( "BaseStyle:getBaseStyle", self )
	return self.class.__base_style__
end


function BaseStyle:getDefaultStyleValues()
	-- TODO: make a copy
	return self._DEFAULTS
end


-- cloneStyle()
-- make a copy of the current style setting
-- same information and inheritance
--
function BaseStyle:cloneStyle()
	local o = self.class:new{
		inherit=self._inherit
	}
	o:copyProperties( self, {force=true} ) -- clone data, force
	return o
end


-- copyProperties()
-- copy properties from a source
-- if no source, then copy from Base Style
--
function BaseStyle:copyProperties( src, params )
	-- print( "BaseStyle:copyProperties", self, src )
	params = params or {}
	if params.force==nil then params.force=false end
	--==--
	local StyleClass = self.class
	if not src then src=StyleClass:getBaseStyle() end
	StyleClass.copyExistingSrcProperties( self, src, params )
end


-- copyStyle()
-- create a new style, setting inheritance to current style
--
function BaseStyle:copyStyle( params )
	-- print( "BaseStyle:copyStyle", self )
	params = params or {}
	if params.data==nil then params.data = {} end
	params.inherit = self
	params.dataSrc = self
	--==--
	return self.class:new( params )
end
BaseStyle.inheritStyle=BaseStyle.copyStyle


-- resetProperties()
-- send out Reset event
-- tells listening Widget to redraw itself
--
function BaseStyle:resetProperties()
	self:_dispatchResetEvent()
end


-- _clearProperties()
-- TODO, make sure type matches
--
function BaseStyle:_clearProperties( src, params )
	-- print( "BaseStyle:_clearProperties", self, src, params )
	params = params or {}
	if params.clearChildren==nil then params.clearChildren=true end
	--==--
	self._isClearing = true
	self:copyProperties( src, params )
	if params.clearChildren then
		self:_clearChildrenProperties( src, params )
	end
	self._isClearing = false
end


-- separate method to custom clear children
--
function BaseStyle:_clearChildrenProperties( src, params )
	-- print( "BaseStyle:_clearChildrenProperties", src, params )
end

-- clearProperties()
-- clear any local modifications on Style
-- can pass in src to "clear props to source"
--
function BaseStyle:clearProperties( src, params )
	-- print( "BaseStyle:clearProperties", src, params, self )
	params = params or {}
	if params.clearChildren==nil then params.clearChildren=true end
	if params.force==nil then params.force=true end
	--==--
	local StyleClass = self.class
	local inherit = self._inherit

	if src then
		-- have source, 'gentle' copy
		params.force=false
	elseif inherit then
		-- have inherit, then use empty to clear all properties
		src = {}
		params.force=true
	else
		-- no source
		src = StyleClass:getBaseStyle()
		params.force=true
	end

	self:_clearProperties( src, params )
	self:_dispatchResetEvent()
end


-- createStyleFrom()
-- important method to create a new style object
-- given different parameters
--
-- @param params, table of options
-- data, -- either nil, Lua structure, or Style object
-- copy, whether to use style Object as is, or make a copy
-- other params, given to Style Constructor
-- (eg, name, inherit, parent, widget, etc)
--
function BaseStyle:createStyleFrom( params )
	-- print( "BaseStyle:createStyleFrom", params, params.copy )
	params = params or {}
	if params.copy==nil then params.copy=true end
	--==--
	local data = params.data
	local copy = params.copy ; params.copy=nil

	local StyleClass = self.class
	local style

	if data==nil then
		-- no data, so create with given params
		style = StyleClass:new( params )

	elseif type(data.isa)=='function' then
		-- data is a Style object, use directly or make copy
		if not copy then
			style = data
		else
			style = data:copyStyle( params )
		end

	else
		-- data is Lua structure
		style = StyleClass:new( params )
	end

	return style
end


--======================================================--
-- Misc

--== Inherit Support

function BaseStyle:_unlinkInherit( o, f )
	if o and f then
		o:removeEventListener( o.EVENT, f )
	end
	o, f = nil, nil
	return o, f
end

function BaseStyle:_linkInherit( o )
	local f
	if o and o~=BaseStyle.NO_INHERIT then
		f = self:createCallback( self._inheritedStyleEvent_handler )
		o:addEventListener( o.EVENT, f )
	end
	return o, f
end

function BaseStyle:_doChildrenInherit( value, params )
	-- print( "BaseStyle:_doChildrenInherit", value, params )
	-- skip this if we're being created
	-- because children have already been init'd
	if not self._isInitialized then return end
end

function BaseStyle:_doClearPropertiesInherit( reset, params )
	-- print( "BaseStyle:_doClearPropertiesInherit", self, reset, params )
	-- params, clearChildren, force
	params = params or {}
	if params.clearChildren==nil then params.clearChildren=true end
	--==--
	if not self._isInitialized then
		-- skip this if we're being created
		-- because children have already been init'd
		params.clearChildren=false
	end
	self:clearProperties( reset, params )
end


--== inherit

function BaseStyle.__getters:inherit()
	return self._inherit
end

-- value should be a instance of Style Class or nil
--
function BaseStyle.__setters:inherit( value )
	-- print( "BaseStyle.__setters:inherit from ", value, self, self._isInitialized )
	assert( value==nil or type(value)=='string' or value==BaseStyle.NO_INHERIT or value:isa( BaseStyle ) )
	--==--
	if type(value)=='string' then
		-- get named style from Style Mgr
		-- will be Style instance or 'nil'
		value = Style.Manager.getStyle( self, value )
	end

	local StyleClass = self.class
	local StyleBase = StyleClass:getBaseStyle()
	-- current / new inherit
	local cInherit, cInherit_f = self._inherit, self._inherit_f
	local nInherit = value or StyleBase
	local reset = nil

	--== Remove old inherit link

	self._inherit, self._inherit_f = self:_unlinkInherit( cInherit, cInherit_f )

	if self._isDestroying then return end

	--== Add new inherit link

	self._inherit, self._inherit_f = self:_linkInherit( nInherit )

	--== Process children

	if not self._isInitialized then return end

	self:_doChildrenInherit( value, {curr=cInherit, next=nInherit} )

	--== Clear properties

	-- Choose Reset method
	if nInherit~=BaseStyle.NO_INHERIT then
		-- we have inherit, so clear all properties
		reset = nil
	elseif self._isInitialized then
		-- no inherit, so reset with previous inherit
		reset = cInherit -- could be nil
	else
		reset = StyleBase -- reset with class base
	end

	self:_doClearPropertiesInherit( reset )
end

--== parent

function BaseStyle.__getters:parent()
	return self._parent
end

-- value should be a instance of Style Class or nil
--
function BaseStyle.__setters:parent( value )
	-- print( "BaseStyle.__setters:parent", self, value )
	assert( value==nil or value:isa( BaseStyle ) )
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

function BaseStyle.__getters:widget()
	-- print( "BaseStyle.__getters:widget" )
	return self._widget
end
function BaseStyle.__setters:widget( value )
	-- print( "BaseStyle.__setters:widget", value )
	-- TODO: update to check class, not table
	assert( value==nil or type(value)=='table' )
	self._widget = value
end


-- onPropertyChange
--
function BaseStyle.__setters:onPropertyChange( func )
	-- print( "BaseStyle.__setters:onPropertyChange", func )
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

function BaseStyle.__getters:name()
	-- print( "BaseStyle.__getters:name", self._inherit )
	return self._name
end
function BaseStyle.__setters:name( value )
	-- print( "BaseStyle.__setters:name", value )
	local cName, nName = self._name, value
	if value == self._name then return end

	self._name = value

	if cName then
		Style.Manager.removeStyle( self.TYPE, cName )
	end
	if nName then
		Style.Manager.addStyle( self )
	end

end

--== debugOn

function BaseStyle.__getters:debugOn()
	local value = self._debugOn
	if value==nil and self._inherit then
		value = self._inherit.debugOn
	end
	return value
end
function BaseStyle.__setters:debugOn( value )
	-- print( "BaseStyle.__setters:debugOn", value, self, self._isInitialized, self._isClearing )
	assert( type(value)=='boolean' or (value==nil and (self._inherit or self._isClearing)) )
	--==--
	if value == self._debugOn then return end
	self._debugOn = value
	self:_dispatchChangeEvent( 'debugOn', value )
end

--== X

function BaseStyle.__getters:x()
	local value = self._x
	if value==nil and self._inherit then
		value = self._inherit.x
	end
	return value
end
function BaseStyle.__setters:x( value )
	-- print( "BaseStyle.__setters:x", value )
	assert( type(value)=='number' or (value==nil and (self._inherit or self._isClearing)) )
	--==--
	if value == self._x then return end
	self._x = value
	self:_dispatchChangeEvent( 'x', value )
end

--== Y

function BaseStyle.__getters:y()
	local value = self._y
	if value==nil and self._inherit then
		value = self._inherit.y
	end
	return value
end
function BaseStyle.__setters:y( value )
	-- print( "BaseStyle.__setters:y", value )
	assert( type(value)=='number' or (value==nil and (self._inherit or self._isClearing)) )
	--==--
	if value == self._y then return end
	self._y = value
	self:_dispatchChangeEvent( 'y', value )
end

--== width

function BaseStyle.__getters:width()
	-- print( "BaseStyle.__getters:width", self.name, self._width  )
	local value = self._width
	if value==nil and self._inherit then
		value = self._inherit.width
	end
	return value
end
function BaseStyle.__setters:width( value, force )
	-- print( "BaseStyle.__setters:width", self, self._width, value, force )
	assert( type(value)=='number' or (value==nil and ( self._inherit or self:nilProperty('width') or self._isClearing) ) )
	--==--
	if value==self._width and not force then return end
	self._width = value
	self:_dispatchChangeEvent( 'width', value )
end

--== height

function BaseStyle.__getters:height()
	local value = self._height
	if value==nil and self._inherit then
		value = self._inherit.height
	end
	return value
end
function BaseStyle.__setters:height( value )
	-- print( "BaseStyle.__setters:height", self, value )
	assert( type(value)=='number' or (value==nil and ( self._inherit or self:nilProperty('height')  or self._isClearing ) ) )
	--==--
	if value == self._height then return end
	self._height = value
	self:_dispatchChangeEvent( 'height', value )
end


--== align

function BaseStyle.__getters:align()
	local value = self._align
	if value==nil and self._inherit then
		value = self._inherit.align
	end
	return value
end
function BaseStyle.__setters:align( value )
	-- print( "BaseStyle.__setters:align", value )
	assert( type(value)=='string' or (value==nil and (self._inherit or self._isClearing)) )
	--==--
	if value==self._align then return end
	self._align = value
	self:_dispatchChangeEvent( 'align', value )
end

--== anchorX

function BaseStyle.__getters:anchorX()
	local value = self._anchorX
	if value==nil and self._inherit then
		value = self._inherit.anchorX
	end
	return value
end
function BaseStyle.__setters:anchorX( value )
	-- print( "BaseStyle.__setters:anchorX", value, self )
	assert( type(value)=='number' or (value==nil and (self._inherit or self._isClearing)) )
	--==--
	if value==self._anchorX then return end
	self._anchorX = value
	self:_dispatchChangeEvent( 'anchorX', value )
end

--== anchorY

function BaseStyle.__getters:anchorY()
	local value = self._anchorY
	if value==nil and self._inherit then
		value = self._inherit.anchorY
	end
	return value
end
function BaseStyle.__setters:anchorY( value )
	-- print( "BaseStyle.__setters:anchorY", value )
	assert( type(value)=='number' or (value==nil and (self._inherit or self._isClearing)) )
	--==--
	if value==self._anchorY then return end
	self._anchorY = value
	self:_dispatchChangeEvent( 'anchorY', value )
end

--== fillColor

function BaseStyle.__getters:fillColor()
	-- print( "BaseStyle.__getters:fillColor", self, self._fillColor )
	local value = self._fillColor
	if value==nil and self._inherit then
		value = self._inherit.fillColor
	end
	return value
end
function BaseStyle.__setters:fillColor( value )
	-- print( "BaseStyle.__setters:fillColor", self._fillColor, value, self._isClearing )
	assert( value or (value==nil and (self._inherit or self._isClearing)) )
	--==--
	self._fillColor = Kolor.translateColor( value )
	self:_dispatchChangeEvent( 'fillColor', value )
end

--== font

function BaseStyle.__getters:font()
	local value = self._font
	if value==nil and self._inherit then
		value = self._inherit.font
	end
	return value
end
function BaseStyle.__setters:font( value )
	-- print( "BaseStyle.__setters:font", value )
	assert( value or (value==nil and (self._inherit or self._isClearing)) )
	--==--
	self._font = value
	self:_dispatchChangeEvent( 'font', value )
end

--== fontSize

function BaseStyle.__getters:fontSize()
	local value = self._fontSize
	if value==nil and self._inherit then
		value = self._inherit.fontSize
	end
	return value
end
function BaseStyle.__setters:fontSize( value )
	-- print( "BaseStyle.__setters:fontSize", value )
	assert( type(value)=='number' or (value==nil and (self._inherit or self._isClearing)) )
	--==--
	self._fontSize = value
	self:_dispatchChangeEvent( 'fontSize', value )
end

--== marginX

function BaseStyle.__getters:marginX()
	local value = self._marginX
	if value==nil and self._inherit then
		value = self._inherit.marginX
	end
	return value
end
function BaseStyle.__setters:marginX( value )
	-- print( "BaseStyle.__setters:marginX", value )
	assert( type(value)=='number' or (value==nil and (self._inherit or self._isClearing)) )
	--==--
	self._marginX = value
	self:_dispatchChangeEvent( 'marginX', value )
end

--== marginY

function BaseStyle.__getters:marginY()
	local value = self._marginY
	if value==nil and self._inherit then
		value = self._inherit.marginY
	end
	return value
end
function BaseStyle.__setters:marginY( value )
	-- print( "BaseStyle.__setters:marginY", value )
	assert( type(value)=='number' or (value==nil and (self._inherit or self._isClearing)) )
	--==--
	self._marginY = value
	self:_dispatchChangeEvent( 'marginY', value )
end

--== strokeColor

function BaseStyle.__getters:strokeColor()
	local value = self._strokeColor
	if value==nil and self._inherit then
		value = self._inherit.strokeColor
	end
	return value
end
function BaseStyle.__setters:strokeColor( value )
	-- print( "BaseStyle.__setters:strokeColor", value )
	assert( value or (value==nil and (self._inherit or self._isClearing)) )
	--==--
	self._strokeColor = Kolor.translateColor( value )
	self:_dispatchChangeEvent( 'strokeColor', value )
end

--== strokeWidth

function BaseStyle.__getters:strokeWidth( value )
	local value = self._strokeWidth
	if value==nil and self._inherit then
		value = self._inherit.strokeWidth
	end
	return value
end
function BaseStyle.__setters:strokeWidth( value )
	-- print( "BaseStyle.__setters:strokeWidth", self._strokeWidth, value, self._isClearing )
	assert( value or (value==nil and (self._inherit or self._isClearing)) )
	--==--
	if value == self._strokeWidth then return end
	self._strokeWidth = value
	self:_dispatchChangeEvent( 'strokeWidth', value )

end

--== textColor

function BaseStyle.__getters:textColor()
	local value = self._textColor
	if value==nil and self._inherit then
		value = self._inherit.textColor
	end
	return value
end
function BaseStyle.__setters:textColor( value )
	-- print( "BaseStyle.__setters:textColor", value )
	assert( value or (value==nil and (self._inherit or self._isClearing)) )
	--==--
	self._textColor = Kolor.translateColor( value )
	self:_dispatchChangeEvent( 'textColor', value )
end


-- verifyProperties()
-- ability to check properties to make sure everything went well
-- this is used with a Style instance
--
function BaseStyle:verifyProperties()
	-- print( "BaseStyle:verifyProperties" )
	local StyleClass = self.class
	return StyleClass._verifyStyleProperties( self )
end



--====================================================================--
--== Private Methods


--======================================================--
-- Style Class setup


-- _prepareData()
-- if necessary, modify data before we process it
-- usually this is to copy styles from parent to child
-- the goal is to have enough of a structure to be able
-- to process with _parseData()
--
function BaseStyle:_prepareData( data, dataSrc, params )
	-- print( "BaseStyle:_prepareData", data, dataSrc, self )
	params = params or {}
	--==--
	local StyleClass = self.class

	if not data then
		data = StyleClass.createStyleStructure( dataSrc )
	end

	return data
end


-- _parseData()
-- parse through the Lua data given, creating properties
-- an substyles as we loop through
--
function BaseStyle:_parseData( data )
	-- print( "BaseStyle:_parseData", self, data )
	if data==nil then data={} end
	--==--

	-- prep tables of things to exclude, etc
	local DEF = self._DEFAULTS
	local EXCL = self._EXCLUDE_PROPERTY_CHECK

	--== process properties, skip children

	for prop, value in pairs( data ) do
		-- print( prop, value )
		if DEF[ prop ]==nil and not EXCL[ prop ] then
			print( sfmt("[WARNING] Skipping invalid style property '%s'", tostring(prop) ))
			print( sfmt("[WARNING] located in style definition for '%s'", tostring(self.NAME) ))
		end
		if not self:isChild( prop ) then
			self[ prop ]=value
		end
	end

	--== process children

	for prop, _ in pairs( self:getChildren() ) do
		-- print( "processing child", prop, _ )
		self[ prop ] = data[ prop ]
	end

end


-- _getRawProperty()
-- property access with name, and not using getters
--
function BaseStyle:_getRawProperty( name )
	assert( type(name)=='string' )
	local key = '_'..name
	return self[key]
end


function BaseStyle:_destroyChildren()
	-- print( "BaseStyle:_destroyChildren", self )
end


--======================================================--
-- Event Dispatch


-- _dispatchChangeEvent()
-- send out property-changed event to listeners
-- and to any inherits
--
function BaseStyle:_dispatchChangeEvent( prop, value, data )
	-- print( "BaseStyle:_dispatchChangeEvent", prop, value, self )
	local widget = self._widget
	local callback = self._onPropertyChange_f

	if not self._isInitialized or self._isClearing then return end

	local e = self:createEvent( self.PROPERTY_CHANGED, {property=prop,value=value,data=data}, {merge=true} )

	-- dispatch event to different listeners
	if widget and widget.stylePropertyChangeHandler then
		widget:stylePropertyChangeHandler( e )
	end
	--
	if callback then callback( e ) end

	-- styles which inherit from this one
	self:dispatchRawEvent( e )
end


-- _dispatchDestroyEvent()
-- send out destroy event to listeners
--
function BaseStyle:_dispatchDestroyEvent( prop, value )
	-- print( "BaseStyle:_dispatchDestroyEvent", prop, value, self )

	local e = self:createEvent( self.STYLE_DESTROYED )

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
function BaseStyle:_dispatchResetEvent()
	-- print( "BaseStyle:_dispatchResetEvent", self )
	--==--
	local widget = self._widget
	local callback = self._onPropertyChange_f

	if not self._isInitialized or self._isClearing then return end

	local e = {
		name=self.EVENT,
		target=self,
		type=self.STYLE_RESET
	}
	if widget and widget.stylePropertyChangeHandler then
		widget:stylePropertyChangeHandler( e )
	end
	if callback then callback( e ) end
	-- styles which inherit from this one

	self:dispatchRawEvent( e )
end



--====================================================================--
--== Event Handlers


-- _inheritedStyleEvent_handler()
-- handle inherited style-events
--
function BaseStyle:_inheritedStyleEvent_handler( event )
	-- print( "BaseStyle:_inheritedStyleEvent_handler", event, event.type, self )
	local style = event.target
	local etype = event.type

	if etype==style.STYLE_RESET then
		self:_dispatchResetEvent()

	elseif etype==style.PROPERTY_CHANGED then
		-- only re-dispatch property changes if our property is empty
		if self:_getRawProperty( event.property ) == nil then
			self:_dispatchChangeEvent( event.property, event.value )
		end
	end

end


-- _parentStyleEvent_handler()
-- handle parent property changes

function BaseStyle:_parentStyleEvent_handler( event )
	-- print( "BaseStyle:_parentStyleEvent_handler", event.type, self )
	local style = event.target
	local etype = event.type

	if etype==style.STYLE_RESET then
		self:_dispatchResetEvent()

	elseif etype==style.PROPERTY_CHANGED then
		local property, value = event.property, event.value
		-- we accept changes to parent as our own
		-- however, check to see if property is valid
		-- parent could have other properties
		if self._VALID_PROPERTIES[property] then
			local func = self.__setters[property]
			if func then
				func( self, value, true )
			else
				print( sfmt( "[WARNING] Unknown property '%s' on '%s'", tostring(property), tostring(self) ))
			end
		end
	end

end




return BaseStyle
