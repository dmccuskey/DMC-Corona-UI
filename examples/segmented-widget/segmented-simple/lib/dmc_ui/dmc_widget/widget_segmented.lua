--====================================================================--
-- dmc_ui/dmc_widget/widget_background/nice_slice_view.lua
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
--== DMC Corona Widgets : 9-Slice Background View
--====================================================================--


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.1.0"



--====================================================================--
--== DMC Widgets Setup
--====================================================================--


local dmc_ui_data = _G.__dmc_ui
local dmc_ui_func = dmc_ui_data.func
local ui_find = dmc_ui_func.find



--====================================================================--
--== DMC Widgets : new9SliceBackground
--====================================================================--



--====================================================================--
--== Imports


local Objects = require 'dmc_objects'

local uiConst = require( ui_find( 'ui_constants' ) )

local WidgetBase = require( ui_find( 'core.widget' ) )



--====================================================================--
--== Setup, Constants


local tinsert = table.insert

--== To be set in initialize()
local dUI = nil



--====================================================================--
--== Support Functions


local function loadSpriteSheet( info, image )
	local spriteInfo = require( info )
	return graphics.newImageSheet( image, spriteInfo:getSheet() )
end



--====================================================================--
--== 9-Slice Background View Class
--====================================================================--


--- Background 9-Slice View Module.
--
-- @classmod Widget.Background.9Slice
-- @usage
-- dUI = require 'dmc_ui'
-- widget = dUI.new9SliceBackground()

local SegmentedCtrl = newClass( WidgetBase, {name="9-Slice Background View"} )

--- Class Constants.
-- @section

--== Class Constants

--== Theme Constants

SegmentedCtrl.STYLE_CLASS = nil -- added later
SegmentedCtrl.STYLE_TYPE = uiConst.SEGMENTEDCTRL

-- TODO: hook up later
-- SegmentedCtrl.DEFAULT = 'default'

-- SegmentedCtrl.THEME_STATES = {
-- 	SegmentedCtrl.DEFAULT,
-- }


--======================================================--
-- Start: Setup DMC Objects

--== Init

function SegmentedCtrl:__init__( params )
	-- print( "SegmentedCtrl:__init__", params )
	params = params or {}

	self:superCall( '__init__', params )
	--==--

	--== Create Properties ==--

	-- properties stored in Class

	self._sheet = nil
	self._spriteSheet_dirty=true

	-- array of info records
	self._segmentInfo = {}
	self._segmentCount_dirty=true
	self._segmentSelect_dirty=true

	-- properties stored in Style

	self._offsetLeft_dirty=true
	self._offsetRight_dirty=true
	self._offsetTop_dirty=true
	self._offsetBottom_dirty=true
	self._sheetInfo_dirty=true
	self._sheetImage_dirty=true
	self._spriteFrames_dirty=true

	-- virtual

	self._sliceLayout_dirty=true
	self._sliceX_dirty=true
	self._sliceY_dirty=true

	--== Object References ==--

	-- display group for slices
	-- self._dgBg = nil
	self._dgSegment = nil
	-- self._dgViews = nil

	-- image slices
	-- self._aCapLeft
	-- self._iCapLeft
	-- self._aDivLeft
	-- self._aItemMiddle
	-- self._aDivRight

	self._leftA = nil
	self._rightA = nil
	self._leftI = nil
	self._rightI = nil
	self._divAI = nil
	self._divIA = nil

end

--[[
function SegmentedCtrl:__undoInit__()
	-- print( "SegmentedCtrl:__undoInit__" )
	--==--
		self:superCall( '__undoInit__' )
end
--]]

--== createView

function SegmentedCtrl:__createView__()
	-- print( "SegmentedCtrl:__createView__" )
	self:superCall( '__createView__' )
	--==--
	local dgMain, dg
	local dgMain = display.newGroup()
	self._dgSegment = dgMain
	self.view:insert( 2, dgMain ) -- insert between layers

	-- background
	dg = display.newGroup()
	dgMain:insert( dg )

	-- selected
	dg = display.newGroup()
	dgMain:insert( dg )

	-- items
	dg = display.newGroup()
	dgMain:insert( dg )

end

function SegmentedCtrl:__undoCreateView__()
	-- print( "SegmentedCtrl:__undoCreateView__" )
	self._dgSegment:removeSelf()
	self._dgSegment=nil
	--==--
	self:superCall( '__undoCreateView__' )
end

--== initComplete

--[[
function SegmentedCtrl:__initComplete__()
	-- print( "SegmentedCtrl:__initComplete__" )
	self:superCall( '__initComplete__' )
	--==--
end

function SegmentedCtrl:__undoInitComplete__()
	--print( "SegmentedCtrl:__undoInitComplete__" )
	--==--
	self:superCall( '__undoInitComplete__' )
end
--]]

-- END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Static Methods


function SegmentedCtrl.initialize( manager )
	print( "SegmentedCtrl.initialize" )
	dUI = manager

	local Style = dUI.Style
	SegmentedCtrl.STYLE_CLASS = Style.SegmentedControl

	Style.registerWidget( SegmentedCtrl )
end



--====================================================================--
--== Public Methods


--[[
w.selectedSegment
w:insertSegment( idx, image/text, params )
w:insertSegment( image/text, params ) -- next
w:setImage( idx, image, params )
w:setText( idx, text, params )

w:isEnabled( idx )
w:setEnabled( idx, true )
w:setWidth( idx, 80 )
w:getWidth( idx )

w:removeAllSegments()
w:removeSegment( idx )
--]]


function SegmentedCtrl:insertSegment( ... )
	print( "SegmentedCtrl:insertSegment" )
	local args = {...}
	assert( #args>=1 and #args<=3, "incorrect number of args" )
	--==--
	local idx, obj, params
	if #args==1 then
		obj = args[1]
	elseif #args==2 then
		if type(args[1])=='number' then
			idx = args[1]
			obj = args[2]
		else
			obj = args[1]
			params = args[2]
		end
	else
		idx = args[1]
		obj = args[2]
		params = args[3]
	end
	assert( type(obj)=='string' or type(obj)=='table', "SegmentedCtrl:insertSegment incorrect params" )
	self:_insertSegment( idx, obj, params )

end


--====================================================================--
--== Private Methods


function SegmentedCtrl:_insertSegment( idx, obj, params )
	print( "SegmentedCtrl:_insertSegment", idx, obj, params )
	params = params or {}
	--==--
	local segInfo = self._segmentInfo
	local dg = self._dgSegment[3]

	if idx==nil then idx = #segInfo + 1 end
	item=obj
	if type(obj)~='string' then
		dg:insert( item )
	else
		print("Creating text obje")
		item = dUI.newText{text=obj}
		item.debugOn=true
		item.textColor={1,1,0,1}
		dg:insert( item.view )
	end
	item.anchorX, item.anchorY = 0.5, 0.5
	local rec = {
		width=50,
		offX=0,
		offY=0,
		type='text',
		item=item,
		bg=nil,
		div=nil
	}
	tinsert( segInfo, idx, rec )

	self._segmentCount_dirty=true
	self:__invalidateProperties__()
end


function SegmentedCtrl:_adjustUILayout( width, height, off )
	print( "SegmentedCtrl:_adjustUILayout", width, height )
	local segments = self._segmentInfo
	local x = 0
	local o
	local h = self.height
	local hc = h*0.5

	-- left cap
	o = self._leftI
	o.x=x
	x=x+o.width

	-- segments
	for i=1,#segments do
		local sInfo = segments[i]
		w = sInfo.width
		-- adjust item
		o = sInfo.item
		o.x, o.y = x+w*0.5, hc
		-- adjust bg
		sInfo.bg.x=x
		x=x+w
		-- adjust divider
		o = sInfo.div
		if i~=#segments then
			o.x=x
			x=x+o.width
			o.isVisible=true
		else
			o.x=0
			o.isVisible=false
		end
	end

	-- right cap
	o = self._rightI
	o.x=x
	x=x+o.width

	print("WW", x )
	self.width = x

end

function SegmentedCtrl:_removeUISlices()
	-- print( "SegmentedCtrl:_removeUISlices" )
	local o

	o = self._tl
	if o then
		o:removeSelf()
		self._tl = nil
	end

	o = self._tm
	if o then
		o:removeSelf()
		self._tm = nil
	end

	o = self._tr
	if o then
		o:removeSelf()
		self._tr = nil
	end

	o = self._ml
	if o then
		o:removeSelf()
		self._ml = nil
	end

	o = self._mm
	if o then
		o:removeSelf()
		self._mm = nil
	end

	o = self._mr
	if o then
		o:removeSelf()
		self._mr = nil
	end

	o = self._bl
	if o then
		o:removeSelf()
		self._bl = nil
	end

	o = self._bm
	if o then
		o:removeSelf()
		self._bm = nil
	end

	o = self._br
	if o then
		o:removeSelf()
		self._br = nil
	end

end


function SegmentedCtrl:_destroySegmentSlices( obj )

end


function SegmentedCtrl:_createSegmentSlices( sheet, frames )
	print( "SegmentedCtrl:_createSegmentSlices", sheet, frames )
	local segments = self._segmentInfo
	local dg = self._dgSegment[1] -- background

	for i=1,#segments do
		local sInfo = segments[i]

		if sInfo.bg==nil then
			local o = display.newImage( sheet, frames.middleInactive )
			o.anchorX, o.anchorY = 0,0
			o.width=sInfo.width
			dg:insert( o )
			sInfo.bg = o
		end

		if sInfo.div==nil then
			local o = display.newImage( sheet, frames.dividerII )
			o.anchorX, o.anchorY = 0,0
			dg:insert( o )
			sInfo.div = o
		end

	end

end

function SegmentedCtrl:_createUISlices( sheet, frames )
	print( "SegmentedCtrl:_createUISlices", sheet, frames )
	local dgBg = self._dgSegment[1]
	local dgSelect = self._dgSegment[2]

	-- self:_removeUISlices()

	o = display.newImage( sheet, frames.leftActive )
	o.anchorX, o.anchorY = 0,0
	dgSelect:insert( o )
	self._leftA = o
	o.isVisible=false

	-- o = display.newImage( sheet, frames.middleActive )
	-- o.anchorX, o.anchorY = 0,0
	-- dg:insert( o )
	-- self._mm = o

	o = display.newImage( sheet, frames.rightActive )
	o.anchorX, o.anchorY = 0,0
	dgSelect:insert( o )
	self._rightA = o
	o.isVisible=false

	o = display.newImage( sheet, frames.leftInactive )
	o.anchorX, o.anchorY = 0,0
	dgBg:insert( o )
	self._leftI = o

	-- o = display.newImage( sheet, frames.middleInactive )
	-- o.anchorX, o.anchorY = 0,0
	-- dgBg:insert( o )
	-- self._tm = o

	o = display.newImage( sheet, frames.rightInactive )
	o.anchorX, o.anchorY = 0,0
	dgBg:insert( o )
	self._rightI = o

	self.height=self._leftA.height

end

function SegmentedCtrl:__commitProperties__()
	-- print( 'SegmentedCtrl:__commitProperties__' )
	local style = self.curr_style
	local view = self.view

	if self._sheetInfo_dirty or self._sheetImage_dirty then
		self._sheet = loadSpriteSheet( style.sheetInfo, style.sheetImage )
		self._sheetInfo_dirty=false
		self._sheetImage_dirty=false

		self._spriteSheet_dirty=true
	end

	if self._spriteSheet_dirty then
		local frames = {
			leftInactive=1,
			middleInactive=2,
			rightInactive=3,
			leftActive=4,
			middleActive=5,
			rightActive=6
		}
		self:_createUISlices( self._sheet, frames )
		-- self:_createUISlices( self._sheet, style.spriteFrames )
		self._spriteSheet_dirty=false
	end

	if self._segmentCount_dirty then
		local offsets = {
			L=style.offsetLeft,
			R=style.offsetRight,
			T=style.offsetTop,
			B=style.offsetBottom,
		}
		local frames = {
			leftInactive=1,
			middleInactive=2,
			rightInactive=3,
			leftActive=4,
			middleActive=5,
			rightActive=6,
			dividerII=7
		}
		self:_createSegmentSlices( self._sheet, frames )
		self:_adjustUILayout( style.width, style.height )
		self._segmentCount_dirty=false

		self._width_dirty=true
	end

	-- x/y

	if self._x_dirty then
		view.x = self._x
		self._x_dirty = false
	end
	if self._y_dirty then
		view.y = self._y
		self._y_dirty = false
	end

	if self._width_dirty then
		self._width_dirty=false

		self._anchorX_dirty=true
		-- self._sliceLayout_dirty=true
		-- self._sliceX_dirty=true
	end

	if self._height_dirty then
		self._height_dirty=false

		-- self._sliceLayout_dirty=true
		-- self._sliceY_dirty=true
	end

	if self._sliceLayout_dirty then
		local offsets = {
			L=style.offsetLeft,
			R=style.offsetRight,
			T=style.offsetTop,
			B=style.offsetBottom,
		}
		-- self:_adjustUILayout( style.width, style.height, offsets )
		self._sliceLayout_dirty=false
	end

	-- anchorX/anchorY

	if self._anchorX_dirty then
		self._dgSegment.x = -style.width*style.anchorX
		self._anchorX_dirty=false
	end
	if self._anchorY_dirty then
		self._dgSegment.y = -style.height*style.anchorY
		self._anchorY_dirty=false

		self._sliceY_dirty=true
	end

	if self._sliceX_dirty then
		-- local dg = self._dgSegment
		-- local anchorX = style.anchorX
		-- local width = style.width
		-- local offsetLeft, offsetRight = style.offsetLeft, style.offsetRight
		-- local anchor = width*anchorX
		-- dg.x = self._x - anchor
		-- self._sliceX_dirty=false
	end

	if self._sliceY_dirty then
		-- local dg = self._dgSegment
		-- local anchorY = style.anchorY
		-- local height = style.height
		-- local offsetTop, offsetBottom = style.offsetTop, style.offsetBottom
		-- local realH = height - (offsetTop + offsetBottom)
		-- local anchor = height*anchorY
		-- dg.y = self._y - anchor
		-- self._sliceY_dirty=false
	end

end



--====================================================================--
--== Event Handlers


function SegmentedCtrl:stylePropertyChangeHandler( event )
	-- print( "SegmentedCtrl:stylePropertyChangeHandler", event )
	local style = event.target
	local etype= event.type
	local property= event.property
	local value = event.value

	-- print( "Style Changed", etype, property, value )

	if etype==style.STYLE_RESET then
		self._debugOn_dirty = true
		self._width_dirty=true
		self._height_dirty=true
		self._anchorX_dirty=true
		self._anchorY_dirty=true

		self._offsetLeft_dirty=true
		self._offsetRight_dirty=true
		self._offsetTop_dirty=true
		self._offsetBottom_dirty=true
		self._sheetInfo_dirty=true
		self._sheetImage_dirty=true
		self._spriteFrames_dirty=true

		self._sliceLayout_dirty=true
		self._sliceX_dirty=true
		self._sliceY_dirty=true
		self._spriteSheet_dirty=true

		property = etype

	else
		if property=='debugActive' then
			self._debugOn_dirty=true
		elseif property=='width' then
			self._width_dirty=true
		elseif property=='height' then
			self._height_dirty=true
		elseif property=='anchorX' then
			self._anchorX_dirty=true
		elseif property=='anchorY' then
			self._anchorY_dirty=true

		elseif property=='spriteFrames' then
			self._spriteFrames_dirty=true
		elseif property=='offsetLeft' then
			self._offsetLeft_dirty=true
		elseif property=='offsetRight' then
			self._offsetRight_dirty=true
		elseif property=='offsetTop' then
			self._offsetTop_dirty=true
		elseif property=='offsetBottom' then
			self._offsetBottom_dirty=true
		elseif property=='sheetInfo' then
			self._sheetInfo_dirty=true
		elseif property=='sheetImage' then
			self._sheetImage_dirty=true
		end

	end

	self:__invalidateProperties__()
	self:__dispatchInvalidateNotification__( property, value )
end




return SegmentedCtrl
