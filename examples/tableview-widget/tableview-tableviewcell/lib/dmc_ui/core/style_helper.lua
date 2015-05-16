--====================================================================--
-- dmc_ui/core/style_help.lua
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
--== DMC Corona UI : Style Helpers
--====================================================================--


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.1.0"



--====================================================================--
--== Imports


local Kolor = require 'dmc_kolor'



--====================================================================--
--== Style Help Table
--====================================================================--


local StyleHelp = {
	['__getters']={},
	['__setters']={}
}



--== .align

--- [**style**] set/get Style value for Widget text alignment.
-- values are 'left', 'center', 'right'
--
-- @within Properties
-- @function .align
-- @usage style.align = 'center'
-- @usage print( style.align )

-- CLASS.__getters.align = StyleHelp.__getters.align
-- CLASS.__setters.align = StyleHelp.__setters.align

function StyleHelp.__getters:align()
	-- print( "StyleHelp.__getters:align", self )
	local value = self._align
	if value==nil and self._inherit then
		value = self._inherit.align
	end
	return value
end
function StyleHelp.__setters:align( value )
	-- print( "StyleHelp.__setters:align", value )
	assert( type(value)=='string' or (value==nil and (self._inherit or self._isClearing)) )
	--==--
	if value==self._align then return end
	self._align = value
	self:_dispatchChangeEvent( 'align', value )
end


--== .fillColor

--- [**style**] set/get Style value for Widget fill color.
--
-- @within Properties
-- @function .fillColor
-- @usage style.fillColor = '#ff0000'
-- @usage print( style.fillColor )

-- CLASS.__getters.fillColor = StyleHelp.__getters.fillColor
-- CLASS.__setters.fillColor = StyleHelp.__setters.fillColor

function StyleHelp.__getters:fillColor()
	-- print( "StyleHelp.__getters:fillColor", self, self._fillColor )
	local value = self._fillColor
	if value==nil and self._inherit then
		value = self._inherit.fillColor
	end
	return value
end
function StyleHelp.__setters:fillColor( value )
	-- print( "StyleHelp.__setters:fillColor", self._fillColor, value, self._isClearing )
	assert( value or (value==nil and (self._inherit or self._isClearing)) )
	--==--
	self._fillColor = Kolor.translateColor( value )
	self:_dispatchChangeEvent( 'fillColor', value )
end


--== .font

--- [**style**] set/get Style value for Widget font.
--
-- @within Properties
-- @function .font
-- @usage style.font = native.systemFontBold
-- @usage print( style.font )

-- CLASS.__getters.font = StyleHelp.__getters.font
-- CLASS.__setters.font = StyleHelp.__setters.font

function StyleHelp.__getters:font()
	local value = self._font
	if value==nil and self._inherit then
		value = self._inherit.font
	end
	return value
end
function StyleHelp.__setters:font( value )
	-- print( "StyleHelp.__setters:font", value )
	assert( value or (value==nil and (self._inherit or self._isClearing)) )
	--==--
	self._font = value
	self:_dispatchChangeEvent( 'font', value )
end


--== .fontSize

--- [**style**] set/get Style value for Widget font size.
--
-- @within Properties
-- @function .fontSize
-- @usage style.fontSize = 12
-- @usage print( style.fontSize )

-- CLASS.__getters.fontSize = StyleHelp.__getters.fontSize
-- CLASS.__setters.fontSize = StyleHelp.__setters.fontSize

function StyleHelp.__getters:fontSize()
	local value = self._fontSize
	if value==nil and self._inherit then
		value = self._inherit.fontSize
	end
	return value
end
function StyleHelp.__setters:fontSize( value )
	-- print( "StyleHelp.__setters:fontSize", value )
	assert( type(value)=='number' or (value==nil and (self._inherit or self._isClearing)) )
	--==--
	self._fontSize = value
	self:_dispatchChangeEvent( 'fontSize', value )
end


--== .marginX

--- [**style**] set/get Style value for Widget X-axis margin.
--
-- @within Properties
-- @function .marginX
-- @usage style.marginX = 10
-- @usage print( style.marginX )

-- CLASS.__getters.marginX = StyleHelp.__getters.marginX
-- CLASS.__setters.marginX = StyleHelp.__setters.marginX

function StyleHelp.__getters:marginX()
	local value = self._marginX
	if value==nil and self._inherit then
		value = self._inherit.marginX
	end
	return value
end
function StyleHelp.__setters:marginX( value )
	-- print( "StyleHelp.__setters:marginX", value )
	assert( type(value)=='number' or (value==nil and (self._inherit or self._isClearing)) )
	--==--
	self._marginX = value
	self:_dispatchChangeEvent( 'marginX', value )
end


--== .marginY

--- [**style**] set/get Style value for Widget Y-axis margin.
--
-- @within Properties
-- @function .marginY
-- @usage style.marginY = 10
-- @usage print( style.marginY )

-- CLASS.__getters.marginY = StyleHelp.__getters.marginY
-- CLASS.__setters.marginY = StyleHelp.__setters.marginY

function StyleHelp.__getters:marginY()
	local value = self._marginY
	if value==nil and self._inherit then
		value = self._inherit.marginY
	end
	return value
end
function StyleHelp.__setters:marginY( value )
	-- print( "StyleHelp.__setters:marginY", value )
	assert( type(value)=='number' or (value==nil and (self._inherit or self._isClearing)) )
	--==--
	self._marginY = value
	self:_dispatchChangeEvent( 'marginY', value )
end


--== .strokeColor

--- [**style**] set/get Style value for Widget border color.
--
-- @within Properties
-- @function .strokeColor
-- @usage style.strokeColor = {1,1,1,1}
-- @usage print( style.strokeColor )

-- CLASS.__getters.strokeColor = StyleHelp.__getters.strokeColor
-- CLASS.__setters.strokeColor = StyleHelp.__setters.strokeColor

function StyleHelp.__getters:strokeColor()
	local value = self._strokeColor
	if value==nil and self._inherit then
		value = self._inherit.strokeColor
	end
	return value
end
function StyleHelp.__setters:strokeColor( value )
	-- print( "StyleHelp.__setters:strokeColor", value )
	assert( value or (value==nil and (self._inherit or self._isClearing)) )
	--==--
	self._strokeColor = Kolor.translateColor( value )
	self:_dispatchChangeEvent( 'strokeColor', value )
end


--== strokeWidth

--- [**style**] set/get Style value for Widget border thickness.
--
-- @within Properties
-- @function .strokeWidth
-- @usage style.strokeWidth = 2
-- @usage print( style.strokeWidth )

-- CLASS.__getters.strokeWidth = StyleHelp.__getters.strokeWidth
-- CLASS.__setters.strokeWidth = StyleHelp.__setters.strokeWidth

function StyleHelp.__getters:strokeWidth( value )
	local value = self._strokeWidth
	if value==nil and self._inherit then
		value = self._inherit.strokeWidth
	end
	return value
end
function StyleHelp.__setters:strokeWidth( value )
	-- print( "StyleHelp.__setters:strokeWidth", self._strokeWidth, value, self._isClearing )
	assert( value or (value==nil and (self._inherit or self._isClearing)) )
	--==--
	if value == self._strokeWidth then return end
	self._strokeWidth = value
	self:_dispatchChangeEvent( 'strokeWidth', value )

end


--== textColor

--- [**style**] set/get Style value for Widget text color.
--
-- @within Properties
-- @function .textColor
-- @usage style.textColor = {0,0,1,0.5}
-- @usage print( style.textColor )

-- CLASS.__getters.textColor = StyleHelp.__getters.textColor
-- CLASS.__setters.textColor = StyleHelp.__setters.textColor

function StyleHelp.__getters:textColor()
	local value = self._textColor
	if value==nil and self._inherit then
		value = self._inherit.textColor
	end
	return value
end
function StyleHelp.__setters:textColor( value )
	-- print( "StyleHelp.__setters:textColor", value )
	assert( value or (value==nil and (self._inherit or self._isClearing)) )
	--==--
	self._textColor = Kolor.translateColor( value )
	self:_dispatchChangeEvent( 'textColor', value )
end


return StyleHelp

