--====================================================================--
-- widget_button/view_image.lua
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
--== DMC Widgets : Button Image View
--====================================================================--



--====================================================================--
--== Imports

local Objects = require 'dmc_objects'
-- local Utils = require 'dmc_utils'

local BaseView = require( dmc_widget_func.find( 'widget_button.view_base' ) )


--====================================================================--
--== Setup, Constants

-- setup some aliases to make code cleaner
local inheritsFrom = Objects.inheritsFrom


--====================================================================--
--== Support Functions

-- build parameters for this image
-- get defaults and layer in specific values
--
local function createImageParams( v_name, params )
	-- print( "createImageParams", v_name, params )
	local v_p = params[ v_name ] -- specific view parameters
	local p = {
		width=params.width,
		height=params.height,
		file=params.file,
	}

	-- layer in view specific values
	if v_p then
		p.width = v_p.width == nil and p.width or v_p.width
		p.height = v_p.height == nil and p.height or v_p.height
		p.file = v_p.file == nil and p.file or v_p.file
	end

	return p
end


-- create the actual corona display object
--
local function createImage( v_params )
	-- print( "createImage", v_params )
	if v_params.base_dir then
		return display.newImageRect( v_params.file, v_params.baseDir, v_params.width, 	v_params.height )
	else
		return display.newImageRect( v_params.file, v_params.width, v_params.height )
	end
end



--====================================================================--
--== Button Image View Class
--====================================================================--


local ImageView = inheritsFrom( BaseView )
ImageView.NAME = "Image View"


--======================================================--
-- Start: Setup DMC Objects

function ImageView:_init( params )
	-- print( "ImageView:_init" )
	params = params or {}
	self:superCall( '_init', params )
	--==--

	--== Sanity Check ==--

	if self.is_intermediate then return end
	assert( type(params.file)=='string', "expected string-type 'file' parameter" )

	--== Create Properties ==--

	self._view_params = createImageParams( self._view_name, params )

	--== Display Groups ==--
	--== Object References ==--
end

-- _createView()
--
function ImageView:_createView()
	-- print( "ImageView:_createView" )
	self:superCall( '_createView' )
	--==--

	local v_params = self._view_params
	local o, tmp   -- object, temp

	--== create background

	o = createImage( v_params )
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

	self.view:insert( 1, o ) -- insert over background
	self._view = o

end


function ImageView:_undoCreateView()
	-- print( "ImageView:_undoCreateView" )
	local o

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

--none


--====================================================================--
--== Event Handlers

-- none




return ImageView
