--====================================================================--
-- dmc_widgets/widget_button/button_state_style.lua
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
--== DMC Corona Widgets : Widget Button State Style
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
--== DMC Widgets : newButtonStyle
--====================================================================--



--====================================================================--
--== Imports


local Objects = require 'dmc_objects'
local Utils = require 'dmc_utils'

local BaseStyle = require( widget_find( 'widget_style.base_style' ) )



--====================================================================--
--== Setup, Constants


local newClass = Objects.newClass
local ObjectBase = Objects.ObjectBase

local sformat = string.format
local tinsert = table.insert

--== To be set in initialize()
local Widgets = nil



--====================================================================--
--== Button-State Style Class
--====================================================================--


local ButtonStateStyle = newClass( BaseStyle, {name="Button State Style"} )

--== Class Constants

ButtonStateStyle.TYPE = 'button-state'

ButtonStateStyle.__base_style__ = nil

-- child styles
ButtonStateStyle.LABEL_KEY = 'label'
ButtonStateStyle.LABEL_NAME = 'button-state-label'
ButtonStateStyle.BACKGROUND_KEY = 'background'
ButtonStateStyle.BACKGROUND_NAME = 'button-state-background'

ButtonStateStyle._VALID_PROPERTIES = {
	debugOn=true,
	width=true,
	height=true,
	anchorX=true,
	anchorY=true,

	align=true,
	hitMarginX=true,
	hitMarginY=true,
	isHitActive=true,
	marginX=true,
	marginY=true,
	offsetX=true,
	offsetY=true
}

ButtonStateStyle._EXCLUDE_PROPERTY_CHECK = nil

ButtonStateStyle._STYLE_DEFAULTS = {
	name='button-state-default-style',
	debugOn=false,
	width=100,
	height=40,
	anchorX=0.5,
	anchorY=0.5,

	align='center',
	hitMarginX=0,
	hitMarginY=0,
	isHitActive=true,
	marginX=0,
	marginY=5,
	offsetX=0,
	offsetY=0,

	label={
		textColor={1,0,0},
		font=native.systemFontBold,
		fontSize=10
	},
	background={
		type='rectangle',
		view={
			fillColor={1,1,0.5, 0.5},
			strokeWidth=6,
			strokeColor={1,0,0,0.5},
		}
	}

}

--== Event Constants

ButtonStateStyle.EVENT = 'button-state-style-event'

-- from super
-- Class.STYLE_UPDATED


--======================================================--
-- Start: Setup DMC Objects

function ButtonStateStyle:__init__( params )
	-- print( "ButtonStateStyle:__init__", params )
	params = params or {}
	self:superCall( '__init__', params )
	--==--

	--== Style Properties ==--

	-- self._data
	-- self._inherit
	-- self._widget
	-- self._parent
	-- self._onProperty

	-- self._name
	-- self._debugOn
	-- self._width
	-- self._height
	-- self._anchorX
	-- self._anchorY

	self._align = nil
	self._hitMarginX = nil
	self._hitMarginY = nil
	self._isHitActive = nil
	self._marginX = nil
	self._marginY = nil
	self._offsetX = nil
	self._offsetY = nil

	--== Object Refs ==--

	-- these are other style objects
	self._background = nil -- Background
	self._label = nil -- Text

end

-- END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Static Methods


function ButtonStateStyle.initialize( manager )
	-- print( "ButtonStateStyle.initialize", manager )
	Widgets = manager

	ButtonStateStyle._setDefaults( ButtonStateStyle )
end


-- create empty style structure
-- param data string, type of background view
--
function ButtonStateStyle.createStyleStructure( data )
	-- print( "ButtonStateStyle.createStyleStructure", data )
	return {
		label=Widgets.Style.Text.createStyleStructure(),
		background=Widgets.Style.Background.createStyleStructure( data )
	}
end


function ButtonStateStyle.addMissingDestProperties( dest, src, params )
	-- print( "ButtonStateStyle.addMissingDestProperties", dest, src )
	params = params or {}
	if params.force==nil then params.force=false end
	assert( dest )
	--==--
	local force=params.force
	local srcs = { ButtonStateStyle._STYLE_DEFAULTS }
	if src then tinsert( srcs, 1, src ) end

	for i=1,#srcs do
		local src = srcs[i]

		if dest.debugOn==nil or force then dest.debugOn=src.debugOn end

		if dest.width==nil or force then dest.width=src.width end
		if dest.height==nil or force then dest.height=src.height end

		if dest.align==nil or force then dest.align=src.align end
		if dest.anchorX==nil or force then dest.anchorX=src.anchorX end
		if dest.anchorY==nil or force then dest.anchorY=src.anchorY end
		if dest.isHitActive==nil or force then dest.isHitActive=src.isHitActive end
		if dest.hitMarginX==nil or force then dest.hitMarginX=src.hitMarginX end
		if dest.hitMarginY==nil or force then dest.hitMarginY=src.hitMarginY end
		if dest.marginX==nil or force then dest.marginX=src.marginX end
		if dest.marginY==nil or force then dest.marginY=src.marginY end
		if dest.offsetX==nil or force then dest.offsetX=src.offsetX end
		if dest.offsetY==nil or force then dest.offsetY=src.offsetY end

	end

	ButtonStateStyle._addMissingChildProperties( dest, src )

	return dest
end


function ButtonStateStyle.copyExistingSrcProperties( dest, src, params )
	-- print( "ButtonStateStyle.copyExistingSrcProperties", dest, src )
	params = params or {}
	if params.force==nil then params.force=false end
	assert( dest )
	--==--
	local force=params.force
	local srcs = { ButtonStateStyle._STYLE_DEFAULTS }
	if src then tinsert( srcs, 1, src ) end

	for i=1,#srcs do
		local src = srcs[i]

		if (src.debugOn~=nil and dest.debugOn==nil) or force then
			dest.debugOn=src.debugOn
		end
		if (src.width~=nil and dest.width==nil) or force then
			dest.width=src.width
		end
		if (src.height~=nil and dest.height==nil) or force then
			dest.height=src.height
		end

		if (src.align~=nil and dest.align==nil) or force then
			dest.align=src.align
		end
		if (src.anchorX~=nil and dest.anchorX==nil) or force then
			dest.anchorX=src.anchorX
		end
		if (src.anchorY~=nil and dest.anchorY==nil) or force then
			dest.anchorY=src.anchorY
		end
		if (src.isHitActive~=nil and dest.isHitActive==nil) or force then
			dest.isHitActive=src.isHitActive
		end
		if (src.hitMarginX~=nil and dest.hitMarginX==nil) or force then
			dest.hitMarginX=src.hitMarginX
		end
		if (src.hitMarginY~=nil and dest.hitMarginY==nil) or force then
			dest.hitMarginY=src.hitMarginY
		end
		if (src.marginX~=nil and dest.marginX==nil) or force then
			dest.marginX=src.marginX
		end
		if (src.marginY~=nil and dest.marginY==nil) or force then
			dest.marginY=src.marginY
		end
		if (src.offsetX~=nil and dest.offsetX==nil) or force then
			dest.offsetX=src.offsetX
		end
		if (src.offsetY~=nil and dest.offsetY==nil) or force then
			dest.offsetY=src.offsetY
		end

	end

	ButtonStateStyle._addMissingChildProperties( dest, src )

	return dest
end



--
-- copy properties to sub-styles
--
function ButtonStateStyle._addMissingChildProperties( dest, src )
	-- print("ButtonStateStyle._pushMissingProperties", dest, src )
	local eStr = "ERROR: Style missing property '%s'"
	local StyleClass, child

	child = dest.label
	assert( child, sformat( eStr, 'label' ) )
	StyleClass = Widgets.Style.Text
	StyleClass.addMissingDestProperties( child, src )

	child = dest.background
	assert( child, sformat( eStr, 'background' ) )
	StyleClass = Widgets.Style.Background
	StyleClass.addMissingDestProperties( child, src )

	return dest
end


function ButtonStateStyle._verifyClassProperties( src )
	-- print( "ButtonStateStyle._verifyClassProperties", src )
	assert( src )
	--==--
	local emsg = "Style: requires property '%s'"

	local is_valid = BaseStyle._verifyClassProperties( src )

	-- TODO: add more tests

	if not src.width then
		print(sformat(emsg,'width')) ; is_valid=false
	end
	if not src.height then
		print(sformat(emsg,'height')) ; is_valid=false
	end

	if not src.align then
		print(sformat(emsg,'align')) ; is_valid=false
	end
	if not src.anchorX then
		print(sformat(emsg,'anchorX')) ; is_valid=false
	end
	if not src.anchorY then
		print(sformat(emsg,'anchorY')) ; is_valid=false
	end
	if not src.marginX then
		print(sformat(emsg,'marginX')) ; is_valid=false
	end
	if not src.marginY then
		print(sformat(emsg,'marginY')) ; is_valid=false
	end

	-- check sub-styles

	local StyleClass

	StyleClass = src._background.class
	-- if not StyleClass._checkProperties( src._background ) then is_valid=false end

	StyleClass = src._label.class
	-- if not StyleClass._checkProperties( src._label ) then is_valid=false end

	return is_valid
end



--====================================================================--
--== Public Methods


--======================================================--
-- Access to sub-styles

function ButtonStateStyle.__getters:background()
	-- print( 'ButtonStateStyle.__getters:background', self._background )
	return self._background
end
function ButtonStateStyle.__setters:background( data )
	-- print( 'ButtonStateStyle.__setters:background', data )
	assert( data==nil or type( data )=='table' )
	--==--
	local StyleClass = Widgets.Style.Background
	local inherit = self._inherit and self._inherit._background

	self._background = StyleClass:createStyleFrom{
		name=ButtonStateStyle.BACKGROUND_NAME,
		inherit=inherit,
		parent=self,
		data=data
	}
end


function ButtonStateStyle.__getters:label()
	-- print( "ButtonStateStyle.__getters:label", data )
	return self._label
end
function ButtonStateStyle.__setters:label( data )
	-- print( "ButtonStateStyle.__setters:label", data )
	assert( data==nil or type( data )=='table' )
	--==--
	local StyleClass = Widgets.Style.Text
	local inherit = self._inherit and self._inherit._label

	self._label = StyleClass:createStyleFrom{
		name=ButtonStateStyle.LABEL_NAME,
		inherit=inherit,
		parent=self,
		data=data
	}
end


--======================================================--
-- Access to style properties

--== align

function ButtonStateStyle.__getters:align()
	-- print( "ButtonStateStyle.__getters:align" )
	local value = self._align
	if value==nil and self._inherit then
		value = self._inherit.align
	end
	return value
end
function ButtonStateStyle.__setters:align( value )
	-- print( "ButtonStateStyle.__setters:align", value )
	assert( (value==nil and self._inherit) or type(value)=='string' )
	--==--
	if value == self._align then return end
	self._align = value
end

--== backgroundStyle

function ButtonStateStyle.__getters:backgroundStyle()
	-- print( "ButtonStateStyle.__getters:backgroundStyle" )
	local value = self._bgStyle
	if value==nil and self._inherit then
		value = self._inherit.backgroundStyle
	end
	return value
end
function ButtonStateStyle.__setters:backgroundStyle( value )
	-- print( "ButtonStateStyle.__setters:backgroundStyle", value )
	assert( (value==nil and self._inherit) or type(value)=='string' )
	--==--
	if value == self._bgStyle then return end
	self._bgStyle = value
end

--== hitMarginX

function ButtonStateStyle.__getters:hitMarginX()
	-- print( "ButtonStateStyle.__getters:hitMarginX" )
	local value = self._hitMarginX
	if value==nil and self._inherit then
		value = self._inherit.hitMarginX
	end
	return value
end
function ButtonStateStyle.__setters:hitMarginX( value )
	-- print( "ButtonStateStyle.__setters:hitMarginX", value )
	assert( (type(value)=='number' and value>=0) or (value==nil and self._inherit) )
	--==--
	if value == self._hitMarginX then return end
	self._hitMarginX = value
	self:_dispatchChangeEvent( 'hitMarginX', value )
end

--== hitMarginY

function ButtonStateStyle.__getters:hitMarginY()
	-- print( "ButtonStateStyle.__getters:hitMarginY" )
	local value = self._hitMarginY
	if value==nil and self._inherit then
		value = self._inherit.hitMarginY
	end
	return value
end
function ButtonStateStyle.__setters:hitMarginY( value )
	-- print( "ButtonStateStyle.__setters:hitMarginY", value, self )
	assert( (type(value)=='number' and value>=0) or (value==nil and self._inherit) )
	--==--
	if value==self._hitMarginY then return end
	self._hitMarginY = value
	self:_dispatchChangeEvent( 'hitMarginY', value )
end

--== marginX

function ButtonStateStyle.__getters:marginX()
	-- print( "ButtonStateStyle.__getters:marginX" )
	local value = self._marginX
	if value==nil and self._inherit then
		value = self._inherit.marginX
	end
	return value
end
function ButtonStateStyle.__setters:marginX( value )
	-- print( "ButtonStateStyle.__setters:marginX", value )
	assert( (type(value)=='number' and value>=0) or (value==nil and self._inherit) )
	--==--
	if value == self._marginX then return end
	self._marginX = value
	self:_dispatchChangeEvent( 'marginX', value )
end

--== marginY

function ButtonStateStyle.__getters:marginY()
	-- print( "ButtonStateStyle.__getters:marginY" )
	local value = self._marginY
	if value==nil and self._inherit then
		value = self._inherit.marginY
	end
	return value
end
function ButtonStateStyle.__setters:marginY( value )
	-- print( "ButtonStateStyle.__setters:marginY", value )
	assert( (type(value)=='number' and value>=0) or (value==nil and self._inherit) )
	--==--
	if value == self._marginY then return end
	self._marginY = value
	self:_dispatchChangeEvent( 'marginY', value )
end



--======================================================--
-- Proxy Methods





--======================================================--
-- Misc

--== inherit

function ButtonStateStyle.__setters:inherit( value )
	-- print( "ButtonStateStyle.__setters:inherit", value )
	BaseStyle.__setters.inherit( self, value )
	--==--
	self._background.inherit = value and value.background or nil
	self._label.inherit = value and value.label or nil
end


--== updateStyle

-- force is used when making exact copy of data
--
function ButtonStateStyle:updateStyle( src, params )
	-- print( "ButtonStateStyle:updateStyle" )
	ButtonStateStyle.copyExistingSrcProperties( self, src, params )
end


function ButtonStateStyle:verifyClassProperties()
	-- print( "ButtonStateStyle:verifyClassProperties", self )
	return ButtonStateStyle._verifyClassProperties( self )
end



--====================================================================--
--== Private Methods


-- this would clear any local modifications on style class
-- called by clearProperties()
--
function ButtonStateStyle:_clearProperties()
	-- print( "ButtonStateStyle:_clearProperties" )
	self:superCall( '_clearProperties' )
	self.align=nil
	self.hitMarginX=nil
	self.hitMarginY=nil
	self.isHitActive=nil
	self.marginX=nil
	self.marginY=nil
	self.offsetX=nil
	self.offsetY=nil
end


function ButtonStateStyle:_prepareData( data )
	-- print("ButtonStateStyle:_prepareData", data )
	if not data then return end
	--==--
	local createStruct = ButtonStateStyle.createStyleStructure

	if data.isa and data:isa( ButtonStateStyle ) then
		--== Instance
		local o = data
		data = createStruct( o.background.view.type )

	else
		--== Lua structure
		local StyleClass
		local src, dest = data, nil

		dest = src.label
		StyleClass = Widgets.Style.Text
		StyleClass.copyExistingSrcProperties( dest, src )

		dest = src.background
		StyleClass = Widgets.Style.Background
		StyleClass.copyExistingSrcProperties( dest, src )

	end

	return data
end


function ButtonStateStyle:_checkChildren()
	-- print( "ButtonStateStyle:_checkChildren" )

	-- using setters !!!
	if self._background==nil then self.background=nil end
	if self._label==nil then self.label=nil end
end



--====================================================================--
--== Event Handlers


-- none




return ButtonStateStyle
