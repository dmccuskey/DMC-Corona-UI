--====================================================================--
-- dmc_widgets/widget_background/rounded_style.lua
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
--== DMC Corona Widgets : Rounded Background Style
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
--== DMC Widgets : newRoundedBackgroundStyle
--====================================================================--



--====================================================================--
--== Imports


local Objects = require 'dmc_objects'
local Utils = require 'dmc_utils'

local ViewStyle = require( widget_find( 'widget_background.base_view_style' ) )



--====================================================================--
--== Setup, Constants


local newClass = Objects.newClass

local sformat = string.format
local tinsert = table.insert

--== To be set in initialize()
local Widgets = nil



--====================================================================--
--== Rounded Background Style Class
--====================================================================--


local RoundedStyle = newClass( ViewStyle, {name="Rounded Background Style"} )

--== Class Constants

RoundedStyle.TYPE = 'rounded'

RoundedStyle.__base_style__ = nil

RoundedStyle._VALID_PROPERTIES = {
	debugOn=true,
	width=true,
	height=true,
	anchorX=true,
	anchorY=true,

	cornerRadius=true,
	fillColor=true,
	strokeColor=true,
	strokeWidth=true,
}

RoundedStyle._EXCLUDE_PROPERTY_CHECK = nil

RoundedStyle._STYLE_DEFAULTS = {
	name='rounded-background-default-style',
	debugOn=false,
	width=75,
	height=30,
	anchorX=0.5,
	anchorY=0.5,

	cornerRadius=6,
	fillColor={1,1,1,1},
	strokeColor={0,0,0,1},
	strokeWidth=0
}

--== Event Constants

RoundedStyle.EVENT = 'rounded-background-style-event'

-- from super
-- Class.STYLE_UPDATED


--======================================================--
-- Start: Setup DMC Objects

function RoundedStyle:__init__( params )
	-- print( "RoundedStyle:__init__", params )
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

	self._type = nil

	self._cornerRadius = nil
	self._fillColor = nil
	self._strokeColor = nil
	self._strokeWidth = nil
end

-- END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Static Methods


function RoundedStyle.initialize( manager )
	-- print( "RoundedStyle.initialize", manager )
	Widgets = manager

	RoundedStyle._setDefaults( RoundedStyle )
end



function RoundedStyle.addMissingDestProperties( dest, src, params )
	-- print( "RoundedStyle.addMissingDestProperties", dest, src )
	params = params or {}
	if params.force==nil then params.force=false end
	assert( dest )
	--==--
	local force=params.force
	local srcs = { RoundedStyle._STYLE_DEFAULTS }
	if src then tinsert( srcs, 1, src ) end

	for i=1,#srcs do
		local src = srcs[i]

		if dest.debugOn==nil then dest.debugOn=src.debugOn end
		if dest.width==nil then dest.width=src.width end
		if dest.height==nil then dest.height=src.height end
		if dest.anchorX==nil then dest.anchorX=src.anchorX end
		if dest.anchorY==nil then dest.anchorY=src.anchorY end

		if dest.cornerRadius==nil then dest.cornerRadius=src.cornerRadius end
		if dest.fillColor==nil then dest.fillColor=src.fillColor end
		if dest.strokeColor==nil then dest.strokeColor=src.strokeColor end
		if dest.strokeWidth==nil then dest.strokeWidth=src.strokeWidth end

	end

	return dest
end


function RoundedStyle.copyExistingSrcProperties( dest, src, params )
	-- print( "RoundedStyle.copyExistingSrcProperties", dest, src )
	assert( dest )
	if not src then return end
	params = params or {}
	if params.force==nil then params.force=false end
	--==--
	local force=params.force

	ViewStyle.copyExistingSrcProperties( dest, src, params )

	if (src.cornerRadius~=nil and dest.cornerRadius==nil) or force
		then dest.cornerRadius=src.cornerRadius
	end
	if (src.fillColor~=nil and dest.fillColor==nil) or force
		then dest.fillColor=src.fillColor
	end
	if (src.strokeColor~=nil and dest.strokeColor==nil) or force
		then dest.strokeColor=src.strokeColor
	end
	if (src.strokeWidth~=nil and dest.strokeWidth==nil) or force
		then dest.strokeWidth=src.strokeWidth
	end

	return dest
end


function RoundedStyle._verifyStyleProperties( src )
	-- print( "RoundedStyle._verifyStyleProperties" )
	local emsg = "Style: requires property '%s'"

	local is_valid = ViewStyle._verifyStyleProperties( src )

	if not src.cornerRadius then
		print(sformat(emsg,'cornerRadius')) ; is_valid=false
	end
	if not src.fillColor then
		print(sformat(emsg,'fillColor')) ; is_valid=false
	end
	if not src.strokeColor then
		print(sformat(emsg,'strokeColor')) ; is_valid=false
	end
	if not src.strokeWidth then
		print(sformat(emsg,'strokeWidth')) ; is_valid=false
	end

	return is_valid
end



--====================================================================--
--== Public Methods


--======================================================--
-- Access to style properties

--== cornerRadius

function RoundedStyle.__getters:cornerRadius()
	-- print( "RoundedStyle.__getters:cornerRadius", self )
	local value = self._cornerRadius
	if value==nil and self._inherit then
		value = self._inherit.cornerRadius
	end
	return value
end
function RoundedStyle.__setters:cornerRadius( value )
	-- print( "RoundedStyle.__setters:cornerRadius", value )
	assert( (type(value)=='number' and value>=0) or (value==nil and self._inherit) )
	--==--
	if value == self._cornerRadius then return end
	self._cornerRadius = value
	self:_dispatchChangeEvent( 'cornerRadius', value )
end


--======================================================--
-- Misc

--== updateStyle

-- force is used when making exact copy of data
--
function RoundedStyle:updateStyle( src, params )
	-- print( "RoundedStyle:updateStyle", src )
	RoundedStyle.copyExistingSrcProperties( self, src, params )
end


function RoundedStyle:verifyProperties()
	-- print( "RoundedStyle.verifyProperties" )
	local emsg = "Style: requires property '%s'"

	--== Check Inheritance

	-- if inheritance is not of similar type then
	-- then make sure we have default data

	local inherit_type = self._inherit and self._inherit.type or nil

	if self.type ~= inherit_type and inherit_type~=nil then
		print( sformat("[NOTICE] Style inheritance mismatch '%s'<>'%s'", tostring(self.type), tostring(inherit_type) ))
		RoundedStyle.addMissingDestProperties( self, RoundedStyle._STYLE_DEFAULTS )
	end

	return RoundedStyle._verifyStyleProperties( self )
end



--====================================================================--
--== Private Methods


-- this would clear any local modifications on style class
-- called by clearProperties()
--
function RoundedStyle:_clearProperties()
	-- print( "RoundedStyle:_clearProperties" )
	self:superCall( '_clearProperties' )
	self.cornerRadius=nil
	self.fillColor=nil
	self.strokeColor=nil
	self.strokeWidth=nil
end



--====================================================================--
--== Event Handlers


-- none




return RoundedStyle
