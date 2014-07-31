--====================================================================--
-- widget_button/view_shape.lua
--
-- Documentation: http://docs.davidmccuskey.com/display/docs/newButton.lua
--====================================================================--

--[[

The MIT License (MIT)

Copyright (c) 2014 David McCuskey

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


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.1.0"



--====================================================================--
--== DMC Widgets Setup
--====================================================================--

local dmc_widget_data, dmc_widget_func
dmc_widget_data = _G.__dmc_widget
dmc_widget_func = dmc_widget_data.func



--====================================================================--
--== DMC Widgets : Button Shape View
--====================================================================--



--====================================================================--
--== Imports

local Objects = require 'dmc_objects'
local Utils = require 'dmc_utils'


--====================================================================--
--== Setup, Constants

-- setup some aliases to make code cleaner
local inheritsFrom = Objects.inheritsFrom
local CoronaBase = Objects.CoronaBase

--== these are the Corona shapes which can be a button view
local TYPE_RECT = 'rect'
local TYPE_ROUNDED_RECT = 'roundedRect'
local TYPE_CIRCLE = 'circle'
local TYPE_POLYGON = 'polygon'

local VALID_SHAPES = {
	TYPE_RECT,
	TYPE_ROUNDED_RECT,
	TYPE_CIRCLE,
	TYPE_POLYGON,
}


local LOCAL_DEBUG = false


--====================================================================--
--== Support Functions

-- ensure we have a shape-type we know about
--
-- @param name string name of shape type, one of types above
--
local function validateShapeType( name )
	if not Utils.propertyIn( VALID_SHAPES, name ) then
		error( "newButton: unknown shape type: " .. tostring( name ) )
	end
	return name
end


-- build parameters for this shape
-- get defaults and layer in specific values
--
local function createShapeParams( v_type, v_name, params )
	-- print( "createShapeParams", v_type, v_name, params )
	local p
	local v_p = params[ v_name ] -- specific view parameters

	if v_type == TYPE_RECT then
		p = {
			width=params.width,
			height=params.height,
			fill_color=params.fill_color,
			stroke_width=params.stroke_width,
			stroke_color=params.stroke_color
		}

	elseif v_type == TYPE_ROUNDED_RECT then
		p = {
			width=params.width,
			height=params.height,
			fill_color=params.fill_color,
			stroke_width=params.stroke_width,
			stroke_color=params.stroke_color,
			corner_radius=params.corner_radius
		}

	elseif v_type == TYPE_CIRCLE then
		p = {
			width=params.width,
			height=params.height,
			fill_color=params.fill_color,
			stroke_width=params.stroke_width,
			stroke_color=params.stroke_color
		}

	elseif v_type == TYPE_POLYGON then
		p = {
			width=params.width,
			height=params.height,
			fill_color=params.fill_color,
			stroke_width=params.stroke_width,
			stroke_color=params.stroke_color
		}

	else -- default view
		error( "newButton: unknown shape type: " .. tostring( v_type ) )

	end

	-- layer in view specific values
	if v_p then
		p.width = v_p.width == nil and p.width or v_p.width
		p.height = v_p.height == nil and p.height or v_p.height
		p.fill_color = v_p.fill_color == nil and p.fill_color or v_p.fill_color
		p.stroke_color = v_p.stroke_color == nil and p.stroke_color or v_p.stroke_color
		p.stroke_width = v_p.stroke_width == nil and p.stroke_width or v_p.stroke_width
		p.corner_radius = v_p.corner_radius == nil and p.corner_radius or v_p.corner_radius
	end

	return p
end


-- create the actual corona display object
--
local function createShape( v_type, v_params )
	-- print( "createShape", v_type, v_params )

	if v_type == TYPE_RECT then
		return display.newRect{
			0, 0, v_params.width, v_params.height
		}

	elseif v_type == TYPE_ROUNDED_RECT then
		return display.newRoundedRect( 0, 0, v_params.width, v_params.height, v_params.corner_radius )

	elseif v_type == TYPE_CIRCLE then
		-- TODO
		return display.newCircle{
			0, 0, v_params.width, v_params.height
		}

	elseif v_type == TYPE_POLYGON then
		-- TODO
		return display.newPolygon{
			0, 0, v_params.width, v_params.height
		}

	else -- default view
		error( "newButton: unknown shape type: " .. tostring( name ) )

	end
end


-- build parameters for the label
-- get defaults and layer in specific values
--
local function createLabelParams( v_name, params )
	-- print( "createLabelParams", v_name )
	local v_p = params[ v_name ] -- specific view parameters
	local l_p = params.label
	local p

	if type(l_p)=='string' then
		p = {
			text=l_p
		}

	else
		p = {
			text=l_p.text,
			align=l_p.align,
			margin=l_p.margin,
			x_offset=l_p.x_offset,
			y_offset=l_p.y_offset,
			color=l_p.color,
			font=l_p.font,
			font_size=l_p.font_size,
		}
	end

	-- layer in view specific values
	if v_p and v_p.label then
		l_p = v_p.label
		p.text = l_p.text == nil and p.text or l_p.text
		p.align = l_p.align == nil and p.align or l_p.align
		p.margin = l_p.margin == nil and p.margin or l_p.margin
		p.x_offset = l_p.x_offset == nil and p.x_offset or l_p.x_offset
		p.y_offset = l_p.y_offset == nil and p.y_offset or l_p.y_offset
		p.color = l_p.color == nil and p.color or l_p.color
		p.font = l_p.font == nil and p.font or l_p.font
		p.font_size = l_p.font_size == nil and p.font_size or l_p.font_size
	end

	-- set defaults
	if p.align == nil then p.align = 'center' end
	if p.x_offset == nil then p.x_offset = 0 end
	if p.y_offset == nil then p.y_offset = 0 end
	if p.width == nil then p.width = params.width end
	if p.margin == nil then p.margin = 0 end
	p.width = p.width-p.margin

	return p
end


-- create the actual corona display object
--
local function createLabel( l_params )
	-- print( "createLabel", l_params )
	return display.newText{
		text=l_params.text,
		width=l_params.width,
		height=l_params.height,
		font=l_params.font,
		fontSize=l_params.font_size,
		align=l_params.align
	}
end



--====================================================================--
--== Button Shape View Class
--====================================================================--


local ShapeView = inheritsFrom( CoronaBase )
ShapeView.NAME = "Shape View"


--======================================================--
-- Start: Setup DMC Objects

function ShapeView:_init( params )
	-- print( "ShapeView:_init" )
	params = params or {}
	self:superCall( '_init', params )
	--==--

	--== Sanity Check ==--

	if self.is_intermediate then return end
	assert( type(params.shape)=='string', "expected string-type 'shape' parameter" )
	assert( type(params.name)=='string', "expected string-type 'name' parameter" )

	--== Create Properties ==--

	self._view_name = params.name -- 'down', 'up', etc
	self._view_type = validateShapeType( params.shape )
	self._view_params = createShapeParams( self._view_type, self._view_name, params )
	self._label_params = createLabelParams( self._view_name, params )

	self._width = params.width
	self._height = params.height

	--== Display Groups ==--

	--== Object References ==--

	-- visual
	self._view = nil
	self._label = nil

end


-- _createView()
--
function ShapeView:_createView()
	-- print( "ShapeView:_createView" )
	self:superCall( '_createView' )
	--==--

	local v_params = self._view_params
	local l_params = self._label_params
	local o, tmp   -- object, temp

	--== create background

	o = createShape( self._view_type, v_params )
	o.x, o.y = 0, 0
	o.anchorX, o.anchorY = 0.5, 0.5
	tmp = v_params.fill_color
	if tmp and tmp.gradient then
		o:setFillColor( tmp )
	elseif tmp then
		o:setFillColor( unpack( tmp ) )
	end
	o.strokeWidth = v_params.stroke_width
	tmp = v_params.stroke_color
	if tmp and tmp.gradient then
		o:setStrokeColor( tmp )
	elseif tmp then
		o:setStrokeColor( unpack( tmp ) )
	end

	self.view:insert( o )
	self._view = o

	--== create label

	o = createLabel( l_params )
	o.x, o.y = l_params.x_offset, l_params.y_offset
	o.anchorX, o.anchorY = 0.5, 0.5
	tmp = l_params.color
	if tmp and tmp.gradient then
		o:setFillColor( tmp )
	elseif tmp then
		o:setFillColor( unpack( tmp ) )
	end

	self.view:insert( o )
	self._label = o

end

function ShapeView:_undoCreateView()
	-- print( "ShapeView:_undoCreateView" )
	local o

	o = self._label
	o:removeSelf()
	self._label = nil

	o = self._view
	o:removeSelf()
	self._view = nil

	--==--
	self:superCall( '_undoCreateView' )
end

-- END: Setup DMC Objects
--======================================================--


--====================================================================--
--== Public Methods

-- none


--====================================================================--
--== Private Methods

-- none


--====================================================================--
--== Event Handlers

-- none




return ShapeView
