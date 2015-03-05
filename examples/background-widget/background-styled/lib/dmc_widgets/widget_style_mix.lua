--====================================================================--
-- dmc_widgets/widget_style_mix.lua
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
--== DMC Corona Widgets : Widget Theme Mixin
--====================================================================--


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.1.0"



--====================================================================--
--== Imports


local Utils = require 'dmc_utils'

-- local Widgets = require 'dmc_utils'



--====================================================================--
--== Setup, Constants


local LOCAL_DEBUG = false
local sformat = string.format



--====================================================================--
--== Support Functions


function _patch( obj )

	obj = obj or {}

	-- add properties
	Theme.__init__( obj )

	-- add methods
	obj.resetStyle = Theme.resetStyle
	obj.setTheme = Theme.setTheme
	obj.setDebug = Theme.setDebug

	return obj
end



--====================================================================--
--== Theme Mixin
--====================================================================--


local Theme = {}

Theme.NAME = "Theme Mixin"

Theme.__getters = {}
Theme.__setters = {}

--======================================================--
-- START: Mixin Setup for DMC Objects

function Theme.__init__( self, params )
	-- print( 'Theme.__init__x', params )
	params = params or {}
	--==--

	--== Sanity Check ==--

	if self.is_class then return end

	--== Setup

	if LOCAL_DEBUG then
		print( "\n\n\n DOING THEME INIT: widget", self)
	end
	self:resetStyle( params )
	if LOCAL_DEBUG then
		print( "\n\n\n DONE WITH THEME INIT")
	end
end


function Theme.__undoInit__( self )
	-- print( "Theme.__undoInit__" )
	self:resetStyle()
end

function Theme.__initComplete__( self )
	-- print( 'Theme.__initComplete__' )
	self:_createDefaultStyle()
	self:setActiveStyle( nil )
end

function Theme.__undoInitComplete__( self )
	-- print( 'Theme.__undoInitComplete__' )
	self:_destroyDefaultStyle()
end

-- END: Mixin Setup for DMC Objects
--======================================================--



--====================================================================--
--== Public Methods


function Theme.resetStyle( self, params )
	params = params or {}
	if params.debug_on==nil then params.debug_on=false end
	--==--
	if self.__debug_on then
		print( outStr( "ResetTheme: resetting theme" ) )
	end
	self.__collection_name = nil -- 'navbar-home'
	self.__curr_style_collection = nil -- <style collection obj>
	self.__curr_style = nil -- <style obj>
	self.__default_style = nil
	self.__curr_style_f = nil
	self.__styles = {}
	self.__debug_on = params.debug_on
end


function Theme.stylePropertyChangeHandler( self, event )
	-- print( "Theme.stylePropertyChangeHandler", event )
	error("class must have event method: stylePropertyChangeHandler")
end

-- TODO
function Theme.resetStyles( self )
	self.__styles = {}
end

-- TODO
function Theme.addTheme( self )
end

-- TODO
function Theme.removeTheme( self )
end



function Theme.setDebug( self, value )
	self.__debug_on = value
end


--== Style Getters/Setters ==--

function Theme.__getters:style()
	-- print( "Theme.__getters:style" )
	return self.curr_style
end
function Theme.__setters:style( value )
	-- print( "Theme.__setters:style", value )
	self:setActiveStyle( value )
end


function Theme.afterAddStyle( self )
	-- print( "OVERRIDE Theme.afterAddStyle", self )
end
function Theme.beforeRemoveStyle( self )
	-- print( "OVERRIDE Theme.beforeRemoveStyle", self )
end


function Theme.setActiveStyle( self, data, params )
	-- print( "\n\n\n>>>>>>>Theme.setActiveStyle", self, data, self.STYLE_CLASS )
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
		assert( data.isa and data:isa(StyleClass), sformat( "Style not Class '%s'", tostring(StyleClass) ))
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

function Theme:clearStyle()
	return self.curr_style:clearProperties()
end




--[[
override these getters/setters/methods if necesary
--]]

--== debugOn

function Theme.__getters:debugOn()
	return self.curr_style.debugOn
end
function Theme.__setters:debugOn( value )
	-- print( 'Theme.__setters:debugOn', value )
	self.curr_style.debugOn = value
end


--== width

function Theme.__getters:width()
	return self.curr_style.width
end
function Theme.__setters:width( value )
	-- print( 'Theme.__setters:width', value )
	self.curr_style.width = value
end

--== height

function Theme.__getters:height()
	-- print( 'Theme.__getters:height' )
	return self.curr_style.height
end
function Theme.__setters:height( value )
	-- print( 'Theme.__setters:height', value )
	self.curr_style.height = value
end

--== align

function Theme.__getters:align()
	return self.curr_style.align
end
function Theme.__setters:align( value )
	-- print( 'Theme.__setters:align', value )
	self.curr_style.align = value
end

--== anchorX

function Theme.__getters:anchorX()
	return self.curr_style.anchorX
end
function Theme.__setters:anchorX( value )
	-- print( 'Theme.__setters:anchorX', value, self )
	self.curr_style.anchorX = value
end

--== anchorY

function Theme.__getters:anchorY()
	return self.curr_style.anchorY
end
function Theme.__setters:anchorY( value )
	-- print( 'Theme.__setters:anchorY', value )
	self.curr_style.anchorY = value
end

--== font

function Theme.__getters:font()
	return self.curr_style.font
end
function Theme.__setters:font( value )
	-- print( 'Theme.__setters:font', value )
	self.curr_style.font = value
end

--== fontSize

function Theme.__getters:fontSize()
	return self.curr_style.fontSize
end
function Theme.__setters:fontSize( value )
	-- print( 'Theme.__setters:fontSize', value )
	self.curr_style.fontSize = value
end

--== marginX

function Theme.__getters:marginX()
	return self.curr_style.marginX
end
function Theme.__setters:marginX( value )
	-- print( 'Theme.__setters:marginX', value )
	self.curr_style.marginX = value
end

--== marginY

function Theme.__getters:marginY()
	return self.curr_style.marginY
end
function Theme.__setters:marginY( value )
	-- print( 'Theme.__setters:marginY', value )
	self.curr_style.marginY = value
end

--== strokeWidth

function Theme.__getters:strokeWidth()
	return self.curr_style.strokeWidth
end
function Theme.__setters:strokeWidth( value )
	-- print( 'Theme.__setters:strokeWidth', value )
	self.curr_style.strokeWidth = value
end



--== Style Methods ==--

--== setAnchor

function Theme:setAnchor( ... )
	-- print( 'Theme:setAnchor' )
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

function Theme:setFillColor( ... )
	-- print( 'Theme:setFillColor' )
	self.curr_style.fillColor = {...}
end

--== setStrokeColor

function Theme:setStrokeColor( ... )
	-- print( 'Theme:setStrokeColor' )
	self.curr_style.strokeColor = {...}
end

--== setTextColor

function Theme:setTextColor( ... )
	-- print( 'Theme:setTextColor' )
	self.curr_style.textColor = {...}
end



--====================================================================--
--== Private Methods


function Theme._createStyle( self, StyleClass, data )
	-- print( "Theme._createStyle", self, StyleClass, data )
	-- create copied style
	local name = string.format( "copied-style-%s", tostring( self ) )
	local style = StyleClass:createStyleFrom{
		data=data,
		name=name
	}
	-- tag style, to remove later
	style.__active_create=true
	return style
end

function Theme._destroyStyle( self, style )
	if style.__active_create==true then
		-- remove it if we created it
		style:removeSelf()
	end
	return nil
end


-- _createDefaultStyle()
-- create the default Style instance for this Widget
--
function Theme._createDefaultStyle( self )
	-- print( "Theme._createDefaultStyle", self.STYLE_CLASS )
	local StyleClass = self.STYLE_CLASS
	assert( StyleClass, "[ERROR] Widget is missing property 'STYLE_CLASS'" )
	local BaseStyle = StyleClass:getBaseStyle()
	assert( BaseStyle, "[ERROR] Widget is missing property 'BaseStyle'" )
	local o = BaseStyle:copyStyle()
	assert( o, "[ERROR] Creating default style class" )
	self.__default_style = o
end

function Theme._destroyDefaultStyle( self )
	local o = self.__default_style
	if not o then return end
	o:removeSelf()
	self.__default_style = nil
	return nil
end



--====================================================================--
--== Theme Facade
--====================================================================--


return {
	StyleMix=Theme,
	patch=_patch,
}



