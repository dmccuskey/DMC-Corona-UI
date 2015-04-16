--====================================================================--
-- dmc_widget/widget_style_mix.lua
--
-- Documentation: http://docs.davidmccuskey.com/
--====================================================================--

--[[

The MIT License (MIT)

Copyright (C) 2015 David McCuskey. All Rights Reserved.

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
--== DMC Corona Widgets : Widget StyleMix Mixin
--====================================================================--


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.1.0"



--====================================================================--
--== Imports


local Utils = require 'dmc_utils'




--====================================================================--
--== Setup, Constants


local sfmt = string.format

--== To be set in initialize()
local Style = nil
local StyleMgr = nil

local LOCAL_DEBUG = false



--====================================================================--
--== Support Functions


local function _patch( obj )

	obj = obj or {}

	-- add properties
	StyleMix.__init__( obj )

	-- add methods
	obj.resetStyle = StyleMix.resetStyle
	obj.setStyleMix = StyleMix.setStyleMix
	obj.setDebug = StyleMix.setDebug

	return obj
end


local function initialize( manager )
	-- print( "initialize Style Manager" )
	Style = manager
	StyleMgr = Style.Manager
end



--====================================================================--
--== StyleMix Mixin
--====================================================================--


local StyleMix = {}

StyleMix.NAME = "StyleMix Mixin"

StyleMix.__getters = {}
StyleMix.__setters = {}

--======================================================--
-- START: Mixin Setup for DMC Objects

function StyleMix.__init__( self, params )
	-- print( 'StyleMix.__init__x', params )
	params = params or {}
	--==--

	--== Sanity Check ==--

	if self.is_class then return end

	--== Setup

	if LOCAL_DEBUG then
		print( "\n\n\n DOING THEME INIT: widget", self)
	end
	self:resetStyle( params )

	self.__default_style = params.defaultStyle

	if LOCAL_DEBUG then
		print( "\n\n\n DONE WITH THEME INIT")
	end
end


function StyleMix.__undoInit__( self )
	-- print( "StyleMix.__undoInit__" )
	self:resetStyle()
end

function StyleMix.__initComplete__( self )
	-- print( 'StyleMix.__initComplete__' )
	if not self.__default_style then
		self.__default_style = self:_createDefaultStyle()
	end
	self:setActiveStyle( nil )
end

function StyleMix.__undoInitComplete__( self )
	-- print( 'StyleMix.__undoInitComplete__' )
	local o = self.__default_style
	self.__default_style = self:_destroyDefaultStyle( o )
end

-- END: Mixin Setup for DMC Objects
--======================================================--



--====================================================================--
--== Public Methods


function StyleMix.resetStyle( self, params )
	params = params or {}
	if params.debug_on==nil then params.debug_on=false end
	--==--
	if self.__debug_on then
		print( outStr( "ResetStyleMix: resetting theme" ) )
	end
	self.__collection_name = nil -- 'navbar-home'
	self.__curr_style_collection = nil -- <style collection obj>
	self.__curr_style = nil -- <style obj>
	self.__default_style = nil
	self.__curr_style_f = nil
	self.__styles = {}
	self.__debug_on = params.debug_on
end


function StyleMix.stylePropertyChangeHandler( self, event )
	-- print( "StyleMix.stylePropertyChangeHandler", event )
	error("class must have event method: stylePropertyChangeHandler")
end

-- TODO
function StyleMix.resetStyles( self )
	self.__styles = {}
end

-- TODO
function StyleMix.addStyleMix( self )
end

-- TODO
function StyleMix.removeStyleMix( self )
end



function StyleMix.setDebug( self, value )
	self.__debug_on = value
end


--== Style Getters/Setters ==--

--- set/get widget style.
-- style can be a style name or a Style Object.
-- Style Object must be appropriate style for Widget, eg style for Background widget comes from dUI.newBackgroundStyle().
-- @within Inherited
-- @function .style
-- @usage widget.style = 'widget-home-page'
-- @usage
-- local wStyle = dUI.newBackgroundStyle()
-- widget.style = wStyle
--
function StyleMix.__getters:style()
	-- print( "StyleMix.__getters:style" )
	return self.curr_style
end
function StyleMix.__setters:style( value )
	-- print( "StyleMix.__setters:style", value, self )
	if type(value)=='string' then
		-- get named style from Style Mgr
		-- will be Style instance or 'nil'
		value = StyleMgr.getStyle( self.STYLE_TYPE, value )
	end
	self:setActiveStyle( value )
end


function StyleMix.afterAddStyle( self )
	-- print( "OVERRIDE StyleMix.afterAddStyle", self )
end
function StyleMix.beforeRemoveStyle( self )
	-- print( "OVERRIDE StyleMix.beforeRemoveStyle", self )
end


function StyleMix.setActiveStyle( self, data, params )
	-- print( "\n\n\n>>>>>>>StyleMix.setActiveStyle", self, data, self.STYLE_CLASS )
	params = params or {}
	if params.widget==nil then params.widget=self end
	if params.copy==nil then params.copy=true end
	-- name
	assert( data==nil or type(data)=='table' )
	--==--
	local StyleClass = self.STYLE_CLASS

	local style = self.__curr_style
	local o = self.__curr_style

	if style then
		self:beforeRemoveStyle()
		style.widget = nil

		self:_destroyStyle( style )
		self.__curr_style = nil
		self.curr_style = nil
	end

	if data==nil then
		-- use our default style
		style=self.__default_style
	elseif type(data.isa)=='function' then
		assert( data.isa and data:isa(StyleClass), sfmt( "Style not Class '%s'", tostring(StyleClass) ))
		if not params.copy then
			style = data
		else
			style = data:copyStyle()
		end
	else
		-- Utils.print( data )
		-- data could be a Style instance or Lua data
		style = self:_createStyle( StyleClass, data )
	end

	-- set before call to resetProperties()
	self.__curr_style = style
	self.curr_style = style

	if style then
		style.widget = params.widget
		self:afterAddStyle()
		style:resetProperties()
	end
end

--- clear any local properties on style.
-- causes full style-inheritance to activate.
--
-- @within Inherited
-- @function clearStyle
-- @usage widget:clearStyle()
--
function StyleMix:clearStyle()
	return self.curr_style:clearProperties()
end




--[[
override these getters/setters/methods if necesary
--]]

--== debugOn

function StyleMix.__getters:debugOn()
	return self.curr_style.debugOn
end
function StyleMix.__setters:debugOn( value )
	-- print( 'StyleMix.__setters:debugOn', value )
	self.curr_style.debugOn = value
end


--== width

function StyleMix.__getters:width()
	return self.curr_style.width
end
function StyleMix.__setters:width( value )
	print( 'StyleMix.__setters:width', value )
	self.curr_style.width = value
end

--== height

function StyleMix.__getters:height()
	-- print( 'StyleMix.__getters:height' )
	return self.curr_style.height
end
function StyleMix.__setters:height( value )
	-- print( 'StyleMix.__setters:height', value )
	self.curr_style.height = value
end

--== align

function StyleMix.__getters:align()
	return self.curr_style.align
end
function StyleMix.__setters:align( value )
	-- print( 'StyleMix.__setters:align', value )
	self.curr_style.align = value
end

--== anchorX

--- set/get anchorX.
--
-- @within Inherited
-- @function .anchorX
-- @usage widget.anchorX = 5
-- @usage print( widget.anchorX )
--
function StyleMix.__getters:anchorX()
	return self.curr_style.anchorX
end
function StyleMix.__setters:anchorX( value )
	-- print( 'StyleMix.__setters:anchorX', value, self )
	self.curr_style.anchorX = value
end

--== anchorY

--- set/get anchorY.
--
-- @within Inherited
-- @function .anchorY
-- @usage widget.anchorY = 5
-- @usage print( widget.anchorY )
--
function StyleMix.__getters:anchorY()
	return self.curr_style.anchorY
end
function StyleMix.__setters:anchorY( value )
	-- print( 'StyleMix.__setters:anchorY', value )
	self.curr_style.anchorY = value
end

--== font

function StyleMix.__getters:font()
	return self.curr_style.font
end
function StyleMix.__setters:font( value )
	-- print( 'StyleMix.__setters:font', value )
	self.curr_style.font = value
end

--== fontSize

function StyleMix.__getters:fontSize()
	return self.curr_style.fontSize
end
function StyleMix.__setters:fontSize( value )
	-- print( 'StyleMix.__setters:fontSize', value )
	self.curr_style.fontSize = value
end

--== marginX

function StyleMix.__getters:marginX()
	return self.curr_style.marginX
end
function StyleMix.__setters:marginX( value )
	-- print( 'StyleMix.__setters:marginX', value )
	self.curr_style.marginX = value
end

--== marginY

function StyleMix.__getters:marginY()
	return self.curr_style.marginY
end
function StyleMix.__setters:marginY( value )
	-- print( 'StyleMix.__setters:marginY', value )
	self.curr_style.marginY = value
end

--== strokeWidth

function StyleMix.__getters:strokeWidth()
	return self.curr_style.strokeWidth
end
function StyleMix.__setters:strokeWidth( value )
	-- print( 'StyleMix.__setters:strokeWidth', value )
	self.curr_style.strokeWidth = value
end



--== Style Methods ==--

--== setAnchor

function StyleMix:setAnchor( ... )
	-- print( 'StyleMix:setAnchor' )
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

--== setFillColor

function StyleMix:setFillColor( ... )
	-- print( 'StyleMix:setFillColor' )
	self.curr_style.fillColor = {...}
end

--== setStrokeColor

function StyleMix:setStrokeColor( ... )
	-- print( 'StyleMix:setStrokeColor' )
	self.curr_style.strokeColor = {...}
end

--== setTextColor

function StyleMix:setTextColor( ... )
	-- print( 'StyleMix:setTextColor' )
	self.curr_style.textColor = {...}
end


function StyleMix.__getters:defaultStyle()
	return self.__default_style
end



--====================================================================--
--== Private Methods


function StyleMix._createStyle( self, StyleClass, data )
	print( "StyleMix._createStyle", self, StyleClass, data )
	-- create copied style
	local name = string.format( "copied-style-%s", tostring( self ) )
	Utils.print( data )
	local style = StyleClass:createStyleFrom{
		data=data,
		name=name
	}
	-- tag style, to remove later
	style.__active_create=true
	return style
end

function StyleMix._destroyStyle( self, style )
	-- print( "StyleMix._destroyStyle", self, style )
	if style.__active_create==true then
		-- remove it if we created it
		style:removeSelf()
	end
	return nil
end


-- _createDefaultStyle()
-- create the default Style instance for this Widget
--
function StyleMix._createDefaultStyle( self, params )
	print( "StyleMix._createDefaultStyle", self.STYLE_CLASS )
	params = params or {}
	if params.copy==nil then params.copy=true end
	--==--
	local StyleClass = self.STYLE_CLASS
	assert( StyleClass, "[ERROR] Widget is missing property 'STYLE_CLASS'" )
	local BaseStyle = StyleClass:getBaseStyle()
	assert( BaseStyle, "[ERROR] Widget is missing property 'BaseStyle'" )
	local o = BaseStyle:copyStyle()
	assert( o, "[ERROR] Creating default style class" )
	o.__mix_created = true
	return o
end

function StyleMix._destroyDefaultStyle( self, style )
	-- print( "StyleMix._destroyDefaultStyle", style )
	if not style or not style.__mix_created then return nil end
	style:removeSelf()
	return nil
end



--====================================================================--
--== StyleMix Facade
--====================================================================--


return {
	StyleMix=StyleMix,
	patch=_patch,
	initialize=initialize
}



