--====================================================================--
-- widget_BaseView.lua
--
-- Documentation: http://docs.davidmccuskey.com/display/docs/newBaseView.lua
--====================================================================--

--[[

Copyright (C) 2013-2014 David McCuskey. All Rights Reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in the
Software without restriction, including without limitation the rights to use, copy,
modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
and to permit persons to whom the Software is furnished to do so, subject to the
following conditions:

The above copyright notice and this permission notice shall be included in all copies
or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.

--]]


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "1.0.0"



--====================================================================--
--== DMC Widgets Setup
--====================================================================--

-- local dmc_widget_data, dmc_widget_func
-- dmc_widget_data = _G.__dmc_widget
-- dmc_widget_func = dmc_widget_data.func



--====================================================================--
--== DMC Widgets : Button View Base
--====================================================================--


--====================================================================--
--== Imports

local Objects = require 'dmc_objects'


--====================================================================--
--== Setup, Constants

-- setup some aliases to make code cleaner
local inheritsFrom = Objects.inheritsFrom
local CoronaBase = Objects.CoronaBase



--====================================================================--
--== BaseView Widget Class
--====================================================================--


local BaseView = inheritsFrom( CoronaBase )
BaseView.NAME = "Button View Base"


--======================================================--
-- Start: Setup DMC Objects

function BaseView:_init( params )
	-- print( "BaseView:_init" )
	params = params or {}
	self:superCall( '_init', params )
	--==--

	--== Sanity Check ==--

	if self.is_intermediate then return end
	assert( type(params.name)=='string', "expected string-type 'name' parameter" )

	--== Create Properties ==--

	self._view_name = params.name -- 'down', 'up', etc
	self._label_params = self:_createLabelParams( self._view_name, params )
	self._view_params = nil -- set in subclass

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
function BaseView:_createView()

	-- print( "BaseView:_createView" )
	self:superCall( '_createView' )
	--==--

	local l_params = self._label_params
	local o, tmp

	--== create label

	o = self:_createLabel( l_params )
	o.anchorX, o.anchorY = 0.5, 0.5
	o.x, o.y = l_params.x_offset, l_params.y_offset
	tmp = l_params.color
	if tmp and tmp.gradient then
		o:setFillColor( tmp )
	elseif tmp then
		o:setFillColor( unpack( tmp ) )
	end

	self.view:insert( o )
	self._label = o

end

function BaseView:_undoCreateView()
	-- print( "BaseView:_undoCreateView" )

	local o

	o = self._label
	o:removeSelf()
	self._label = nil

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

-- build parameters for the label
-- get defaults and layer in specific values
--
function BaseView:_createLabelParams( v_name, params )
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
	if p.font_size == nil then p.font_size = 13 end
	if p.align == nil then p.align = 'center' end
	if p.x_offset == nil then p.x_offset = 0 end
	if p.y_offset == nil then p.y_offset = 0 end
	if p.width == nil then p.width = params.width end
	if p.margin == nil then p.margin = 0 end
	p.width = p.width-p.margin

	return p
end

function BaseView:_createLabel( l_params )
	-- print( "BaseView:_createLabel" )
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
--== Event Handlers

-- none



return BaseView
