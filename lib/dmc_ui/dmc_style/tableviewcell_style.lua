--====================================================================--
-- dmc_ui/dmc_style/tableview_style.lua
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
--== DMC Corona UI : TableViewCell Style
--====================================================================--


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.1.0"



--====================================================================--
--== DMC UI Setup
--====================================================================--


local dmc_ui_data = _G.__dmc_ui
local dmc_ui_func = dmc_ui_data.func
local ui_find = dmc_ui_func.find



--====================================================================--
--== DMC UI : newTableViewCell
--====================================================================--



--====================================================================--
--== Imports


local Objects = require 'dmc_objects'
local Utils = require 'dmc_utils'
local uiConst = require( ui_find( 'ui_constants' ) )

local BaseStyle = require( ui_find( 'dmc_style.base_style' ) )



--====================================================================--
--== Setup, Constants


local newClass = Objects.newClass
local ObjectBase = Objects.ObjectBase

local sfmt = string.format
local tinsert = table.insert

--== To be set in initialize()
local Style = nil



--====================================================================--
--== TableViewCell Style Class
--====================================================================--


local TableViewCell = newClass( BaseStyle, {name="TableViewCell Style"} )

--== Class Constants

TableViewCell.TYPE = uiConst.TABLEVIEWCELL

TableViewCell.__base_style__ = nil

TableViewCell._VALID_PROPERTIES = {
	debugOn=true,
	width=true,
	height=true,
	anchorX=true,
	anchorY=true,

	align=true,
	fillColor=true,
	font=true,
	fontSize=true,
	marginX=true,
	marginY=true,
	textColor=true,

	strokeColor=true,
	strokeWidth=true,
}

TableViewCell._EXCLUDE_PROPERTY_CHECK = {}

TableViewCell._STYLE_DEFAULTS = {
	debugOn=true,
	width=200,
	height=30,
	anchorX=0.5,
	anchorY=0.5,

	align='center',
	fillColor={0,0,0,0},
	font=native.systemFont,
	fontSize=16,
	marginX=0,
	marginY=0,
	textColor={0,0,0,1},

	strokeColor={0,0,0,0},
	strokeWidth=0,
}

TableViewCell._TEST_DEFAULTS = {
	debugOn=true,
	width=117,
	height=nil,
	anchorX=101,
	anchorY=102,

	align='test-center',
	fillColor={101,102,103,104},
	font=native.systemFont,
	fontSize=101,
	marginX=102,
	marginY=103,
	textColor={111,112,113,114},

	strokeColor={121,122,123,124},
	strokeWidth=111,
}

TableViewCell.MODE = uiConst.RUN_MODE
TableViewCell._DEFAULTS = TableViewCell._STYLE_DEFAULTS

--== Event Constants

TableViewCell.EVENT = 'tableviewcell-style-event'


--======================================================--
-- Start: Setup DMC Objects

function TableViewCell:__init__( params )
	-- print( "TableViewCell:__init__", params )
	params = params or {}
	self:superCall( '__init__', params )
	--==--

	--== Style Properties ==--

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

	self._align = nil
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


function TableViewCell.initialize( manager, params )
	-- print( "TableViewCell.initialize", manager, params.mode )
	params = params or {}
	if params.mode==nil then params.mode=uiConst.RUN_MODE end
	--==--
	Style = manager

	if params.mode==uiConst.TEST_MODE then
		TableViewCell.MODE = params.mode
		TableViewCell._DEFAULTS = TableViewCell._TEST_DEFAULTS
	end
	local defaults = TableViewCell._DEFAULTS

	TableViewCell._setDefaults( TableViewCell, {defaults=defaults} )
end


function TableViewCell.addMissingDestProperties( dest, src )
	-- print( "TableViewCell.addMissingDestProperties", dest, src )
	assert( dest )
	--==--
	local srcs = { TableViewCell._DEFAULTS }
	if src then tinsert( srcs, 1, src ) end

	dest = BaseStyle.addMissingDestProperties( dest, src )

	for i=1,#srcs do
		local src = srcs[i]

		if dest.align==nil then dest.align=src.align end
		if dest.fillColor==nil then dest.fillColor=src.fillColor end
		if dest.font==nil then dest.font=src.font end
		if dest.fontSize==nil then dest.fontSize=src.fontSize end
		if dest.marginX==nil then dest.marginX=src.marginX end
		if dest.marginY==nil then dest.marginY=src.marginY end
		if dest.strokeColor==nil then dest.strokeColor=src.strokeColor end
		if dest.strokeWidth==nil then dest.strokeWidth=src.strokeWidth end
		if dest.textColor==nil then dest.textColor=src.textColor end

	end

	return dest
end


-- copyExistingSrcProperties()
--
function TableViewCell.copyExistingSrcProperties( dest, src, params )
	-- print( "TableViewCell.copyExistingSrcProperties", dest, src )
	assert( dest )
	if not src then return end
	params = params or {}
	if params.force==nil then params.force=false end
	--==--
	local force=params.force

	BaseStyle.copyExistingSrcProperties( dest, src, params )

	if (src.align~=nil and dest.align==nil) or force then
		dest.align=src.align
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


-- _verifyStyleProperties()
--
function TableViewCell._verifyStyleProperties( src )
	-- print( "TableViewCell._verifyStyleProperties", src )
	local emsg = "Style (TableViewCell) requires property '%s'"

	-- exclude width/height because nil is valid value
	local is_valid = BaseStyle._verifyStyleProperties( src, {width=true, height=true} )

	if not src.align then
		print(sfmt(emsg,'align')) ; is_valid=false
	end
	if not src.fillColor then
		print(sfmt(emsg,'fillColor')) ; is_valid=false
	end
	if not src.font then
		print(sfmt(emsg,'font')) ; is_valid=false
	end
	if not src.fontSize then
		print(sfmt(emsg,'fontSize')) ; is_valid=false
	end
	if not src.marginX then
		print(sfmt(emsg,'marginX')) ; is_valid=false
	end
	if not src.marginY then
		print(sfmt(emsg,'marginY')) ; is_valid=false
	end
	if not src.strokeColor then
		print(sfmt(emsg,'strokeColor')) ; is_valid=false
	end
	if not src.strokeWidth then
		print(sfmt(emsg,'strokeWidth')) ; is_valid=false
	end
	if not src.textColor then
		print(sfmt(emsg,'textColor')) ; is_valid=false
	end

	return is_valid
end



--====================================================================--
--== Public Methods


--== verifyProperties

function TableViewCell:verifyProperties()
	-- print( "TableViewCell:verifyProperties" )
	return TableViewCell._verifyStyleProperties( self )
end



--====================================================================--
--== Private Methods


-- none



--====================================================================--
--== Event Handlers


-- none



return TableViewCell
