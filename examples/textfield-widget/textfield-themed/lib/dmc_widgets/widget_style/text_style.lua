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

local Widgets = nil -- set later



--====================================================================--
--== Text Style Class
--====================================================================--


local TextStyle = newClass( BaseStyle, {name="Text Style"} )

--== Class Constants

TextStyle.__base_style__ = nil

TextStyle.EXCLUDE_PROPERTY_CHECK = {
	width=true,
	height=true
}

TextStyle._STYLE_DEFAULTS = {
	name='text-default-style',

	width=nil,
	height=nil,

	align='center',
	anchorX=0.5,
	anchorY=0.5,
	debugOn=false,
	fillColor={1,1,1,0},
	font=native.systemFont,
	fontSize=24,
	marginX=0,
	marginY=0,
	strokeColor={0,0,0,1},
	strokeWidth=0,
	textColor={0,0,0,1}
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


-- copyMissingProperties()
-- copies properties from src structure to dest structure
-- if property isn't already in dest
-- Note: usually used by OTHER classes
--
function TextStyle.copyMissingProperties( dest, src )
	-- print( "TextStyle.copyMissingProperties", dest, src )
	if dest.debugOn==nil then dest.debugOn=src.debugOn end

	if dest.width==nil then dest.width=src.width end
	if dest.height==nil then dest.height=src.height end

	if dest.align==nil then dest.align=src.align end
	if dest.anchorX==nil then dest.anchorX=src.anchorX end
	if dest.anchorY==nil then dest.anchorY=src.anchorY end
	if dest.fillColor==nil then dest.fillColor=src.fillColor end
	if dest.font==nil then dest.font=src.font end
	if dest.fontSize==nil then dest.fontSize=src.fontSize end
	if dest.marginX==nil then dest.marginX=src.marginX end
	if dest.marginY==nil then dest.marginY=src.marginY end
	if dest.strokeColor==nil then dest.strokeColor=src.strokeColor end
	if dest.strokeWidth==nil then dest.strokeWidth=src.strokeWidth end
	if dest.textColor==nil then dest.textColor=src.textColor end
end




--====================================================================--
--== Public Methods


--== updateStyle

-- force is used when making exact copy of data, incl 'nil's
--
function TextStyle:updateStyle( info, params )
	-- print( "TextStyle:updateStyle" )
	params = params or {}
	if params.force==nil then params.force=true end
	--==--
	local force=params.force

	if info.debugOn~=nil or force then self.debugOn=info.debugOn end

	if info.width~=nil or force then self.width=info.width end
	if info.height~=nil or force then self.height=info.height end

	if info.align~=nil or force then self.align=info.align end
	if info.anchorX~=nil or force then self.anchorX=info.anchorX end
	if info.anchorY~=nil or force then self.anchorY=info.anchorY end
	if info.fillColor~=nil or force then self.fillColor=info.fillColor end
	if info.font~=nil or force then self.font=info.font end
	if info.fontSize~=nil or force then self.fontSize=info.fontSize end
	if info.marginX~=nil or force then self.marginX=info.marginX end
	if info.marginY~=nil or force then self.marginY=info.marginY end
	if info.strokeColor~=nil or force then self.strokeColor=info.strokeColor end
	if info.strokeWidth~=nil or force then self.strokeWidth=info.strokeWidth end
	if info.textColor~=nil or force then self.textColor=info.textColor end
end



--====================================================================--
--== Private Methods


function TextStyle._setDefaults()
	-- print( "TextStyle._setDefaults" )
	local style = TextStyle:new{
		data=TextStyle._STYLE_DEFAULTS
	}
	TextStyle.__base_style__ = style
end


function TextStyle:_checkProperties()
	-- print( "TextStyle:_checkProperties" )
	local emsg = "Style: requires property '%s'"
	local is_valid = BaseStyle._checkProperties( self )

	--[[
	we don't check for width/height because nil is valid value
	sometimes we just use width/height of the text object
	-- if not self.width then print(sformat(emsg,'width')) ; is_valid=false end
	-- if not self.height then print(sformat(emsg,'height')) ; is_valid=false end
	--]]

	if not self.align then print(sformat(emsg,'align')) ; is_valid=false end
	if not self.anchorX then print(sformat(emsg,'anchorX')) ; is_valid=false end
	if not self.anchorY then print(sformat(emsg,'anchorY')) ; is_valid=false end
	if not self.fillColor then print(sformat(emsg,'fillColor')) ; is_valid=false end
	if not self.font then print(sformat(emsg,'font')) ; is_valid=false end
	if not self.fontSize then print(sformat(emsg,'fontSize')) ; is_valid=false end
	if not self.marginX then print(sformat(emsg,'marginX')) ; is_valid=false end
	if not self.marginY then print(sformat(emsg,'marginY')) ; is_valid=false end
	if not self.strokeColor then print(sformat(emsg,'strokeColor')) ; is_valid=false end
	if not self.strokeWidth then print(sformat(emsg,'strokeWidth')) ; is_valid=false end
	if not self.textColor then print(sformat(emsg,'textColor')) ; is_valid=false end

	return is_valid
end



--====================================================================--
--== Event Handlers


-- none



return TextStyle
