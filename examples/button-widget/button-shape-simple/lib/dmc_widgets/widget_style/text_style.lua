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
--== DMC Widgets : newTextStyle
--====================================================================--



--====================================================================--
--== Imports


local Objects = require 'dmc_objects'

local BaseStyle = require( widget_find( 'widget_style.base_style' ) )



--====================================================================--
--== Setup, Constants


local newClass = Objects.newClass
local ObjectBase = Objects.ObjectBase

--== To be set in initialize()
local Widgets = nil



--====================================================================--
--== Text Style Class
--====================================================================--


local TextStyle = newClass( BaseStyle, {name="Text Style"} )

--== Class Constants

TextStyle.TYPE = 'text'

TextStyle.__base_style__ = nil

TextStyle.EXCLUDE_PROPERTY_CHECK = {
	-- width/height, they can be nil
	width=true,
	height=true
}

TextStyle._STYLE_DEFAULTS = {
	name='text-default-style',
	debugOn=false,

	width=nil,
	height=nil,

	align='center',
	anchorX=0.5,
	anchorY=0.5,
	fillColor={1,1,1,0},
	font=native.systemFont,
	fontSize=24,
	marginX=0,
	marginY=0,
	offsetX=0,
	offsetY=0,
	textColor={0,0,0,1},

	strokeColor={0,0,0,1},
	strokeWidth=0,
}

--== Event Constants

TextStyle.EVENT = 'text-style-event'

-- from super
-- Class.STYLE_UPDATED


--======================================================--
-- Start: Setup DMC Objects

function TextStyle:__init__( params )
	-- print( "TextStyle:__init__", params )
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

	self._width = nil
	self._height = nil

	self._align = nil
	self._anchorX = nil
	self._anchorY = nil
	self._fillColor = nil
	self._font = nil
	self._fontSize = nil
	self._marginX = nil
	self._marginY = nil
	self._strokeColor = nil
	self._strokeWidth = nil
	self._textColor = nil
end

-- END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Static Methods


function TextStyle.initialize( manager )
	-- print( "TextStyle.initialize", manager )
	Widgets = manager

	TextStyle._setDefaults()
end


function TextStyle.addMissingDestProperties( dest, src, params )
	-- print( "TextStyle.addMissingDestProperties", dest, src )
	if not dest or not src then return end
	params = params or {}
	if params.force==nil then params.force=false end
	--==--
	local force=params.force

	if dest.debugOn==nil or force then dest.debugOn=src.debugOn end

	if dest.width==nil or force then dest.width=src.width end
	if dest.height==nil or force then dest.height=src.height end

	if dest.align==nil or force then dest.align=src.align end
	if dest.anchorX==nil or force then dest.anchorX=src.anchorX end
	if dest.anchorY==nil or force then dest.anchorY=src.anchorY end
	if dest.fillColor==nil or force then dest.fillColor=src.fillColor end
	if dest.font==nil or force then dest.font=src.font end
	if dest.fontSize==nil or force then dest.fontSize=src.fontSize end
	if dest.marginX==nil or force then dest.marginX=src.marginX end
	if dest.marginY==nil or force then dest.marginY=src.marginY end
	if dest.strokeColor==nil or force then dest.strokeColor=src.strokeColor end
	if dest.strokeWidth==nil or force then dest.strokeWidth=src.strokeWidth end
	if dest.textColor==nil or force then dest.textColor=src.textColor end

	return dest
end


-- copyExistingSrcProperties()
--
function TextStyle.copyExistingSrcProperties( dest, src, params )
	-- print( "TextStyle.copyExistingSrcProperties", dest, src )
	if not dest or not src then return end
	params = params or {}
	if params.force==nil then params.force=false end
	--==--
	local force=params.force

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
	if (src.fillColor~=nil and dest.fillColor==nil) or force then
		dest.fillColor=src.fillColor
	end
	if (src.font~=nil and dest.font==nil) or force then
		dest.font=src.font
	end
	if (src.fontSize~=nil and dest.fontSize==nil) or force then
		dest.fontSize=src.fontSize
	end
	if (src.marginX~=nil and dest.marginX==nil) or force then
		dest.marginX=src.marginX
	end
	if (src.marginY~=nil and dest.marginY==nil) or force then
		dest.marginY=src.marginY
	end
	if (src.strokeColor~=nil and dest.strokeColor==nil) or force then
		dest.strokeColor=src.strokeColor
	end
	if (src.strokeWidth~=nil and dest.strokeWidth==nil) or force then
		dest.strokeWidth=src.strokeWidth
	end
	if (src.textColor~=nil and dest.textColor==nil) or force then
		dest.textColor=src.textColor
	end

	return dest
end


-- create empty Style structure
function TextStyle.createStateStructure( data )
	-- print( "TextStyle.createStateStructure", data )
	return {}
end


-- _verifyClassProperties()
--
function TextStyle._verifyClassProperties( src )
	-- print( "TextStyle._verifyClassProperties", src )
	assert( src )
	--==--
	local emsg = "Style: requires property '%s'"

	local is_valid = BaseStyle._verifyClassProperties( src )

	--[[
	we don't check for width/height because nil is valid value
	sometimes we just use width/height of the text object
	-- if not self.width then print(sformat(emsg,'width')) ; is_valid=false end
	-- if not self.height then print(sformat(emsg,'height')) ; is_valid=false end
	--]]

	if not src.align then
		print(sformat(emsg,'align')) ; is_valid=false
	end
	if not src.anchorX then
		print(sformat(emsg,'anchorX')) ; is_valid=false
	end
	if not src.anchorY then
		print(sformat(emsg,'anchorY')) ; is_valid=false
	end
	if not src.fillColor then
		print(sformat(emsg,'fillColor')) ; is_valid=false
	end
	if not src.font then
		print(sformat(emsg,'font')) ; is_valid=false
	end
	if not src.fontSize then
		print(sformat(emsg,'fontSize')) ; is_valid=false
	end
	if not src.marginX then
		print(sformat(emsg,'marginX')) ; is_valid=false
	end
	if not src.marginY then
		print(sformat(emsg,'marginY')) ; is_valid=false
	end
	if not src.strokeColor then
		print(sformat(emsg,'strokeColor')) ; is_valid=false
	end
	if not src.strokeWidth then
		print(sformat(emsg,'strokeWidth')) ; is_valid=false
	end
	if not src.textColor then
		print(sformat(emsg,'textColor')) ; is_valid=false
	end

	return is_valid
end


function TextStyle._setDefaults()
	-- print( "TextStyle._setDefaults" )
	local style = TextStyle:new{
		data=TextStyle._STYLE_DEFAULTS
	}
	TextStyle.__base_style__ = style
end



--====================================================================--
--== Public Methods


--== updateStyle

-- force is used when making exact copy of data, incl 'nil's
--
function TextStyle:updateStyle( src, params )
	-- print( "TextStyle:updateStyle" )
	TextStyle.copyExistingSrcProperties( self, src, params )
end


function TextStyle:verifyClassProperties()
	-- print( "TextStyle:verifyClassProperties" )
	return TextStyle._verifyClassProperties( self )
end



--====================================================================--
--== Private Methods


-- none



--====================================================================--
--== Event Handlers


-- none



return TextStyle
