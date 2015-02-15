--====================================================================--
-- dmc_widgets/widget_theme_mix.lua
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
--== Support Functions


function _patch( obj )

	obj = obj or {}

	-- add properties
	Theme.__init__( obj )

	-- add methods
	obj.resetTheme = Theme.resetTheme
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
	Theme.resetTheme( self, params )

end

function Theme.__undoInit__( self )
	-- print( "Theme.__undoInit__" )
	Theme.resetTheme( self )
end

-- END: Mixin Setup for DMC Objects
--======================================================--



--====================================================================--
--== Public Methods


function Theme.resetTheme( self, params )
	params = params or {}
	if params.debug_on==nil then params.debug_on=false end
	--==--
	if self.__debug_on then
		print( outStr( "resetTheme: resetting popover" ) )
	end
	self.__collection_name = nil -- 'navbar-home'
	self.__curr_style_collection = nil -- <style collection obj>
	self.__curr_style = nil -- <style obj>
	self.__curr_style_f = nil
	self.__styles = {}
	self.__debug_on = params.debug_on

	self:setActiveStyle( nil )
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
	-- print( 'Theme.__getters:style' )
	return self.curr_style
end
function Theme.__setters:style( value )
	-- print( 'Theme.__setters:style', value )
	self:setActiveStyle( value )
end


function Theme.setActiveStyle( self, data, params )
	print( "Theme.setActiveStyle", style )
	params = params or {}
	if params.widget==nil then params.widget=self end
	if params.copy==nil then params.copy=true end
	-- name
	assert( data==nil or type(data)=='table' )
	--==--
	local StyleClass = self.STYLE_CLASS
	assert( StyleClass, "[ERROR] Widget is missing property 'STYLE_CLASS'" )

	local style = self.__curr_style
	local o = self.__curr_style

	if style then
		style.widget = nil
		style:removeSelf()
		self.__curr_style = nil
		self.curr_style = nil
	end

	print( "\n\n>>> IN SET ACTIVE STYLE", self )

	-- create copied style
	if not params.copy and data then
		assert( data.isa and data:isa(StyleClass) )
		style = data
	else
		style = StyleClass:createStyleFrom{
			data=data,
			widget=params.widget,
			name="my name here"
		}
	end

	-- set before call to resetProperties()
	self.__curr_style = style
	self.curr_style = style

	if style then
		style.widget = params.widget
		style:resetProperties()
	end
end





--[[
override these getters/setters/methods if necesary
--]]

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
	-- print( 'Theme.__setters:anchorX', value )
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






--====================================================================--
--== Theme Facade
--====================================================================--


return {
	ThemeMix=Theme,
	patch=_patch,
}



