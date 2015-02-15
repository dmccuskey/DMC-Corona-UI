--====================================================================--
-- dmc_widgets/theme_manager/background_style.lua
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
--== DMC Corona Widgets : Widget Background Style
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
--== DMC Widgets : newBackgroundStyle
--====================================================================--



--====================================================================--
--== Imports


local Objects = require 'dmc_objects'

local BaseStyle = require( widget_find( 'theme_manager.base_style' ) )



--====================================================================--
--== Setup, Constants


local newClass = Objects.newClass
local ObjectBase = Objects.ObjectBase



--====================================================================--
--== Background Style Class
--====================================================================--


local BackgroundStyle = newClass( BaseStyle, {name="Background Style"} )

--== Class Constants

BackgroundStyle.DEFAULT = {
	name='background-default-style',

	width=100,
	height=50,

	anchorX=0.5,
	anchorY=0.5,
	fillColor={1,1,1,1},
	isHitTestable=true,
	strokeColor={0,0,0,1},
	strokeWidth=0
}

--== Event Constants

-- from super
-- Class.EVENT
-- Class.STYLE_UPDATED


--======================================================--
--== Start: Setup DMC Objects

function BackgroundStyle:__init__( params )
	-- print( "BackgroundStyle:__init__", params )
	params = params or {}
	if params.inherit==nil then params.inherit=BackgroundStyle end
	self:superCall( '__init__', params )
	--==--

	--== Style Properties ==--

	-- self._inherit
	-- self._data

	-- self._name
	-- self._onProperty

	self._width = nil
	self._height = nil

	self._anchorX = nil
	self._anchorY = nil
	self._fillColor = nil
	self._isHitTestable = nil
	self._strokeColor = nil
	self._strokeWidth = nil
end

--== END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Static Methods


function BackgroundStyle.setDefaults()
	-- print( "BackgroundStyle.setDefaults" )
	local def = BackgroundStyle.DEFAULT

	BackgroundStyle._name=def.name

	BackgroundStyle._width=def.width
	BackgroundStyle._height=def.height

	BackgroundStyle._anchorX=def.anchorX
	BackgroundStyle._anchorY=def.anchorY
	BackgroundStyle._fillColor=def.fillColor
	BackgroundStyle._strokeColor=def.strokeColor
	BackgroundStyle._strokeWidth=def.strokeWidth
end


--== updateStyle

-- force is used when making exact copy of data
--
function BackgroundStyle:updateStyle( info, force )
	-- print( "BackgroundStyle:updateStyle", info )
	if force==nil then force=true end
	--==--
	if info.width~=nil or force then self.width=info.width end
	if info.height~=nil or force then self.height=info.height end

	if info.anchorX~=nil or force then self.anchorX=info.anchorX end
	if info.anchorY~=nil or force then self.anchorY=info.anchorY end
	if info.fillColor~=nil or force then self.fillColor=info.fillColor end
	if info.strokeColor~=nil or force then self.strokeColor=info.strokeColor end
	if info.strokeWidth~=nil or force then self.strokeWidth=info.strokeWidth end
end



--====================================================================--
--== Public Methods


-- none



--====================================================================--
--== Private Methods


function BackgroundStyle:_checkProperties()
	BaseStyle._checkProperties( self )
	assert( self.width, "Style: requires 'width'" )
	assert( self.height, "Style: requires 'height'" )

	assert( self.anchorX, "Style: requires 'anchorX'" )
	assert( self.anchorY, "Style: requires 'anchory'" )
	assert( self.fillColor, "Style: requires 'fillColor'" )
	assert( self.strokeColor, "Style: requires 'strokeColor'" )
	assert( self.strokeWidth, "Style: requires 'strokeWidth'" )
end




--====================================================================--
--== Event Handlers


-- none


--== Pre-Processing ==--

BackgroundStyle.setDefaults()



return BackgroundStyle
