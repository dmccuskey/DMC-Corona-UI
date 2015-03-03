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

local sfmt = string.format
local tinsert = table.insert



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
Style._EXCLUDE_PROPERTY_CHECK = {}

Style._CHILDREN = {}

Style._VALID_PROPERTIES = {
	debugOn=true,
	width=true,
	height=true,
	anchorX=true,
	anchorY=true,
}
Style._STYLE_DEFAULTS = {
	debugOn=false,
	-- width=nil,
	-- height=nil,
	anchorX=0.5,
	anchorY=0.5,
}

Style._TEST_DEFAULTS = {
	debugOn=false,
	-- width=nil,
	-- height=nil,
	anchorX=4,
	anchorY=4,
}

Style.RUN_MODE = 'run'
Style.TEST_MODE = 'test'
Style.MODE = Style.RUN_MODE

Style._DEFAULTS = Style._STYLE_DEFAULTS

--== Event Constants

Style.EVENT = 'style-event'

-- DESTROYED
-- this is used to let a Widget know when a Style
-- is about to be removed
-- This is NOT propagated through inheritance chain
-- affected Widgets should release the Style
Style.STYLE_DESTROYED = 'style-destroy-event'

-- RESET
-- this is used to let a Widget know about drastic
-- changes to a Style, eg, inheritance has changed
-- This is propagated through inheritance chain as well as
-- to Child Styles and their inheritance chain
-- affected Widgets should do a full refresh
Style.STYLE_RESET = 'style-reset-event'

-- PROPERTY_CHANGED
-- this is used when a property on a Style has changed
-- this change could be local or in inheritance chain
-- Child Styles propagate these AS LONG AS their local
-- value of the property is not set (ie, equal to nil )
-- affectd Widgets should update accordingly
Style.PROPERTY_CHANGED = 'style-property-changed-event'


--======================================================--
-- Start: Setup DMC Objects

function Style:__init__( params )
	-- print( "Style:__init__", params, self )
	params = params or {}
	params.data = params.data
	params.name = params.name
	params.widget = params.widget

	self:superCall( '__init__', params )
	--==--
	self._isInitialized = false
	self._isClearing = false
	self._isDestroying = false

	-- inheritance style
	self._inherit = params.inherit
	self._inherit_f = nil

	-- parent style
	self._parent = params.parent
	self._parent_f = nil

	-- widget delegate
	self._widget = params.widget

	self._onPropertyChange_f = params.onPropertyChange

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
	self._isDestroying = false

	local data = self:_prepareData( self._tmp_data )
	self._tmp_data = nil
	self:_parseData( data )

	-- do this after style/children constructed --

	self.inherit = self._inherit -- use setter
	self.parent = self._parent -- use setter
	self.widget = self._widget -- use setter

	assert( self:verifyProperties(), sfmt( "Missing properties for Style '%s'", tostring(self.class) ) )

	self._isInitialized = true
end

function Style:__undoInitComplete__()
	-- print( "Style:__undoInitComplete__", self )
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


Style._CHILDREN = {}

function Style:isChild( name )
	return (self._CHILDREN[ name ]~=nil)
end
function Style:getChildren( name )
	return self._CHILDREN
end
function Style:nilProperty( name )
	return (self._EXCLUDE_PROPERTY_CHECK[ name ]~=nil)
end


function Style.initialize( manager, params )
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
-- this is used layer in all properties
-- Note: usually used by OTHER classes

-- 'dest' should be basic structure of Style type
-- 'srcs' table of sources usually be anything, but usually parent of Style
--
function Style.addMissingDestProperties( dest, srcs )
	-- print( "Style.addMissingDestProperties", dest, srcs )
	assert( dest )
	srcs = srcs or {}
	local lsrc = Utils.extend( srcs, {} )
	if lsrc.parent==nil then lsrc.parent=dest end
	if lsrc.main==nil then lsrc.main=Style._DEFAULTS end
	lsrc.widget = Style._DEFAULTS
	--==--

	for _, key in ipairs( { 'main', 'parent', 'widget' } ) do
		local src = lsrc[key] or {}

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
function Style._addMissingChildProperties( dest, srcs )
	-- print( "OVERRIDE Style._addMissingChildProperties" )
	return dest
end


-- copyExistingSrcProperties()
-- copies properties from src structure to dest structure
-- only if src has property and dest does not
-- purpose is to allow property overrides and inheritance
-- copied down from parent style
-- force makes exact copy of source
--[[
source = {
	fillColor={}
	strokeWidth=4,

	view = {

	}
}
src=source, dest=source.view <send view>
source = {
	fillColor={}
	strokeWidth=4,

	view = {
		fillColor={},
		strokeWidth=4
	}
}
--]]
function Style.copyExistingSrcProperties( dest, src, params )
	-- print( "Style.copyExistingSrcProperties", dest, src, params )
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


function Style._verifyStyleProperties( src, exclude )
	-- print( "Style:_verifyStyleProperties", src, self )
	exclude = exclude or {}
	--==--
	local emsg = "Style requires property '%s'"
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
function Style._setDefaults( StyleClass, params )
	-- print( "Style._setDefaults" )
	params = params or {}
	if params.defaults==nil then params.defaults=StyleClass._DEFAULTS end
	--==--
	local def = params.defaults

	def = StyleClass.addMissingDestProperties( def, {main=def} )

	local style = StyleClass:new{
		data=def
	}
	StyleClass.__base_style__ = style
end



--====================================================================--
--== Public Methods


function Style:getBaseStyle()
	-- print( "Style:getBaseStyle", self )
	return self.class.__base_style__
end


function Style:getDefaultStyleValues()
	-- TODO: make a copy
	return self._DEFAULTS
end


-- cloneStyle()
-- make a copy of the current style setting
-- same information and inheritance
--
function Style:cloneStyle()
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
function Style:copyProperties( src, params )
	-- print( "Style:copyProperties", self, src )
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
function Style:copyStyle( params )
	-- print( "Style:copyStyle", self )
	params = params or {}
	params.inherit = self
	--==--
	return self.class:new( params )
end
Style.inheritStyle=Style.copyStyle


-- resetProperties()
-- send out Reset event
-- tells listening Widget to redraw itself
--
function Style:resetProperties()
	self:_dispatchResetEvent()
end


-- _clearProperties()
-- TODO, make sure type matches
--
function Style:_clearProperties( src, params )
	-- print( "Style:_clearProperties", self, src, params )
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
function Style:_clearChildrenProperties( src, params )
	-- print( "Style:_clearChildrenProperties", src, params )
end

-- clearProperties()
-- clear any local modifications on Style
-- can pass in src to "clear props to source"
--
function Style:clearProperties( src, params )
	-- print( "Style:clearProperties", src, params, self )
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

--== inherit

function Style.__getters:inherit()
	return self._inherit
end

function Style:_doChildrenInherit( value )
end


function Style:_unlinkInherit( o, f )
	if o and f then
		o:removeEventListener( o.EVENT, f )
	end
	o, f = nil, nil
	return o, f
end

function Style:_linkInherit( o )
	local f
	if o then
		f = self:createCallback( self._inheritedStyleEvent_handler )
		o:addEventListener( o.EVENT, f )
	end
	return o, f
end

function Style:_doChildrenInherit( value, params )
	-- print( "Style:_doChildrenInherit", value, params )
	-- skip this if we're being created
	-- because children have already been init'd
	if not self._isInitialized then return end
end

function Style:_doClearPropertiesInherit( reset, params )
	-- print( "Style:_doClearPropertiesInherit", self, reset, params )
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

-- value should be a instance of Style Class or nil
--
function Style.__setters:inherit( value )
	-- print( "Style.__setters:inherit from ", value, self, self._isInitialized )
	assert( value==nil or value:isa( Style ) )
	--==--
	local StyleClass = self.class
	local StyleBase = StyleClass:getBaseStyle()
	-- current / new inherit
	local cInherit, cInherit_f = self._inherit, self._inherit_f
	local nInherit = value
	local reset = nil

	--== Remove old inherit link

	self._inherit, self._inherit_f = self:_unlinkInherit( cInherit, cInherit_f )

	if self._isDestroying then return end

	--== Add new inherit link

	self._inherit, self._inherit_f = self:_linkInherit( nInherit )

	--== Choose Reset method

	if nInherit then
		-- we have inherit, so clear all properties
		reset = nil
	elseif self._isInitialized then
		-- no inherit, so reset with previous inherit
		-- note, could be nil
		reset = cInherit
	else
		-- reset with class base
		reset = StyleBase
	end

	--== Process children

	self:_doChildrenInherit( value, {curr=cInherit, next=nInherit} )

	--== Clear properties

	-- Choose Reset method
	if nInherit then
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
	-- print( "Style.__getters:name", self._inherit )
	local value = self._name
	if value==nil and self._inherit then
		value = self._inherit.name
	end
	return value
end
function Style.__setters:name( value )
	-- print( "Style.__setters:name", value )
	assert( type(value)=='string' or (value==nil and (self._inherit or self._isClearing))  )
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
	-- print( "Style.__setters:debugOn", value, self, self._isInitialized, self._isClearing )
	assert( type(value)=='boolean' or (value==nil and (self._inherit or self._isClearing)) )
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
	assert( type(value)=='number' or (value==nil and (self._inherit or self._isClearing)) )
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
	assert( type(value)=='number' or (value==nil and (self._inherit or self._isClearing)) )
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
	-- print( "Style.__setters:width", self, self._width, value, force )
	assert( type(value)=='number' or (value==nil and ( self._inherit or self:nilProperty('width') or self._isClearing) ) )
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
	assert( type(value)=='number' or (value==nil and ( self._inherit or self:nilProperty('height')  or self._isClearing ) ) )
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
	-- print( "Style.__setters:align", value )
	assert( type(value)=='string' or (value==nil and (self._inherit or self._isClearing)) )
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
	-- print( "Style.__setters:anchorX", value, self )
	assert( type(value)=='number' or (value==nil and (self._inherit or self._isClearing)) )
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
	-- print( "Style.__setters:anchorY", value )
	assert( type(value)=='number' or (value==nil and (self._inherit or self._isClearing)) )
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
	-- print( "Style.__setters:fillColor", self._fillColor, value, self._isClearing )
	assert( type(value)=='table' or (value==nil and (self._inherit or self._isClearing) ))
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
	assert( value or (value==nil and (self._inherit or self._isClearing)) )
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
	assert( type(value)=='number' or (value==nil and (self._inherit or self._isClearing)) )
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
	assert( type(value)=='number' or (value==nil and (self._inherit or self._isClearing)) )
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
	assert( type(value)=='number' or (value==nil and (self._inherit or self._isClearing)) )
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
	assert( value or (value==nil and (self._inherit or self._isClearing) ))
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
	-- print( "Style.__setters:strokeWidth", self._strokeWidth, value, self._isClearing )
	assert( value or (value==nil and (self._inherit or self._isClearing) ))
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
	assert( value or (value==nil and (self._inherit or self._isClearing)) )
	--==--
	if value == self._textColor then return end
	self._textColor = value
	self:_dispatchChangeEvent( 'textColor', value )
end


-- verifyProperties()
-- ability to check properties to make sure everything went well
-- this is used with a Style instance
--
function Style:verifyProperties()
	-- print( "Style:verifyProperties" )
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
function Style:_prepareData( data )
	-- print( "Style:_prepareData", self )
	-- data could be nil, Lua structure, or class instance
	if type(data)=='table' and data.isa then
		-- if we have an Instance, dump it
		data=nil
	end
	return data
end

-- _parseData()
-- parse through the Lua data given, creating properties
-- an substyles as we loop through
--
function Style:_parseData( data )
	-- print( "Style:_parseData", self, data )
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
function Style:_getRawProperty( name )
	assert( type(name)=='string' )
	local key = '_'..name
	return self[key]
end


function Style:_destroyChildren()
	-- print( "Style:_destroyChildren", self )
end


--======================================================--
-- Event Dispatch


-- _dispatchChangeEvent()
-- send out property-changed event to listeners
-- and to any inherits
--
function Style:_dispatchChangeEvent( prop, value, data )
	-- print( "Style:_dispatchChangeEvent", prop, value, self )
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
function Style:_dispatchDestroyEvent( prop, value )
	-- print( "Style:_dispatchDestroyEvent", prop, value, self )

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
function Style:_dispatchResetEvent()
	-- print( "Style:_dispatchResetEvent", self )
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
function Style:_inheritedStyleEvent_handler( event )
	-- print( "Style:_inheritedStyleEvent_handler", event, event.type, self )
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

function Style:_parentStyleEvent_handler( event )
	-- print( "Style:_parentStyleEvent_handler", event.type, self )
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




return Style
