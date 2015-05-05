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
local Utils = require 'dmc_utils'

local uiConst = require( ui_find( 'ui_constants' ) )

local WidgetBase = require( ui_find( 'core.widget' ) )



--====================================================================--
--== Setup, Constants


local getStage = display.getCurrentStage
local newRect = display.newRect
local newImage = display.newImage
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

	self._selectedIdx = 0
	self._selectedIdx_dirty=true

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

	self._sliceX_dirty=true
	self._sliceY_dirty=true

	--== Object References ==--

	-- display group for slices
	-- self._dgBg = nil
	self._dgSegment = nil
	-- self._dgViews = nil

	-- basic UI slices
	self._leftA = nil
	self._rightA = nil
	self._leftI = nil
	self._rightI = nil

	self._middleA = nil
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
	-- print( "SegmentedCtrl.initialize" )
	dUI = manager

	local Style = dUI.Style
	SegmentedCtrl.STYLE_CLASS = Style.SegmentedControl

	Style.registerWidget( SegmentedCtrl )
end



--====================================================================--
--== Public Methods


--[[
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


function SegmentedCtrl.__getters:selected()
	return self._selectedIdx
end
function SegmentedCtrl.__setters:selected( idx )
	if idx<1 or idx>#self._segmentInfo then idx = 0 end
	self._selectedIdx = idx
	self._selectedIdx_dirty=true
	self:__invalidateProperties__()
	self:dispatchEvent( self.SELECTED, {index=idx}, {merge=true} )
end

function SegmentedCtrl:insertSegment( ... )
	-- print( "SegmentedCtrl:insertSegment" )
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
	-- print( "SegmentedCtrl:_insertSegment", idx, obj, params )
	params = params or {}
	--==--
	local dg = self._dgSegment[3] -- overlay
	local segments = self._segmentInfo
	if idx==nil then idx = #segments + 1 end

	-- create new data record for segment
	local sInfo = {
		idx=0, -- current index
		width=50,
		offsetX=0,
		offsetY=0,
		type='text',
		item=item,
		callback=nil, -- touch callback
		bg=nil, -- this is visual bg
		hit=nil, -- this is hit area
		div=nil, -- inactive right divider
	}

	-- initial setup for text/image item
	if type(obj)~='string' then
		sInfo.type='image'
		sInfo.item=obj
		dg:insert( item )
	else
		item = dUI.newText{text=obj}
		-- item.debugOn=true
		item.textColor={1,1,0,1}
		sInfo.type='text'
		sInfo.item=item
		dg:insert( item.view )
	end
	item.anchorX, item.anchorY = 0.5, 0.5
	tinsert( segments, idx, sInfo )

	if idx>=self._selectedIdx then
		-- advance selected index if inserting
		-- item before current selection
		self._selectedIdx = self._selectedIdx+1
		self._selectedIdx_dirty=true
	end

	self._segmentCount_dirty=true
	self:__invalidateProperties__()
end


function SegmentedCtrl:_adjustUILayout( height, offset )
	-- print( "SegmentedCtrl:_adjustUILayout", height )
	local offL, offR = offset.L, offset.R
	local offT, offB = offset.T, offset.B
	local segments = self._segmentInfo
	local h = height
	local hc = h*0.5
	local o

	local x, y = 0-offL,0-offT

	-- left cap
	o = self._leftA
	o.x, o.y = x, y
	o = self._leftI
	o.x, o.y = x, y
	x=x+o.width

	-- segments
	for i=1,#segments do
		local sInfo = segments[i]
		local o
		w = sInfo.width
		-- adjust hit
		o = sInfo.hit
		o.width, o.height = w, h
		o.x, o.y = x, y+offT
		-- adjust item
		o = sInfo.item
		o.x, o.y = x+w*0.5, hc
		-- adjust bg
		o = sInfo.bg
		o.x, o.y = x, y
		o.width = w
		o.isVisible=true -- TEST (True)/false
		x=x+w
		-- adjust divider
		o = sInfo.div
		if i~=#segments then
			o.x, o.y = x, y
			x=x+o.width
			o.isVisible=true
		else
			o.x,o.y=0,0
			o.isVisible=false
		end
	end

	-- right cap
	o = self._rightA
	o.x, o.y = x, y
	o = self._rightI
	o.x, o.y = x, y

	x=x+o.width-offR+offL
	return x -- return x for set width

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


-- hide/show the active slice elements.
-- can be called independently of selected index
--
-- @int[opt=selectedIdx] idx index to show

function SegmentedCtrl:_highlightSegment( idx )
	-- print( "SegmentedCtrl:_highlightSegment", idx )
	idx = idx or self._selectedIdx
	--==--
	local segments = self._segmentInfo
	local style = self.curr_style

	-- hide current selected slices
	local lA, mA, rA = self._leftA, self._middleA, self._rightA
	local dIA, dAI = self._divIA, self._divAI
	lA.isVisible=false
	rA.isVisible=false
	mA.isVisible=false
	dIA.isVisible=false
	dAI.isVisible=false

	-- show next selected slices
	local y = 0-style.offsetTop
	for i=1,#segments do
		local sInfo = segments[i]
		local prevSeg = segments[i-1]

		if idx==i then

			if i==1 then
				lA.isVisible=true
				if #segments==1 then
					rA.isVisible=true
				else
					dAI.x, dAI.y = sInfo.div.x, y
					dAI.isVisible=true
				end

			elseif i==#segments then
				rA.isVisible=true
				dIA.x, dIA.y = prevSeg.div.x, y
				dIA.isVisible=true

			else
				dIA.x, dIA.y= prevSeg.div.x, y
				dIA.isVisible=true
				dAI.x, dAI.y = sInfo.div.x, y
				dAI.isVisible=true

			end

			mA.x, mA.y = sInfo.bg.x, y
			mA.width = sInfo.width
			mA.isVisible=true

		end

	end

end



function SegmentedCtrl:_destroySegmentSlices( obj )

end


function SegmentedCtrl:_createSegmentTouchCallback( sInfo )

	return function( event )
		local target = event.target
		local phase = event.phase
		local segIdx = sInfo.idx

		if phase=='began' then
			self:_highlightSegment( segIdx )
			target._isFocus=true
			getStage():setFocus( target )
			return true
		end

		if not target._isFocus then return end

		local x, y = event.x, event.y
		local bounds = target.contentBounds
		local isWithinBounds =
			( bounds.xMin <= x and bounds.xMax >= x and
			bounds.yMin <= y and bounds.yMax >= y )

		if phase=='moved' then
			if isWithinBounds then
				self:_highlightSegment( segIdx )
			else
				self:_highlightSegment()
			end

		elseif phase=='ended' or phase=='cancelled' then
			if isWithinBounds then
				self.selected=segIdx
			else
				self:_highlightSegment()
			end
			getStage():setFocus( nil )
			target._isFocus=false
		end

		return true
	end

end

function SegmentedCtrl:_createSegmentSlices( sheet, frames )
	-- print( "SegmentedCtrl:_createSegmentSlices", sheet, frames )
	local segments = self._segmentInfo
	local dg = self._dgSegment[1] -- background
	local height = self.height

	-- create segment pieces
	for i=1,#segments do
		local sInfo = segments[i]

		sInfo.idx = i -- update index

		if sInfo.hit==nil then
			local o = newRect( 0,0,10, height )
			o.anchorX, o.anchorY = 0,0
			o.cb = self:_createSegmentTouchCallback( sInfo )
			o:setFillColor( 0.2, 0.2, 0.2 )
			dg:insert( o )
			sInfo.hit = o
			o:addEventListener( 'touch', o.cb )
		end

		if sInfo.bg==nil then
			local o = newImage( sheet, frames.middleInactive )
			o.anchorX, o.anchorY = 0,0
			dg:insert( o )
			sInfo.bg = o
		end

		if sInfo.div==nil then
			local o = newImage( sheet, frames.dividerII )
			o.anchorX, o.anchorY = 0,0
			dg:insert( o )
			sInfo.div = o
		end

	end

end

function SegmentedCtrl:_createUISlices( sheet, frames )
	-- print( "SegmentedCtrl:_createUISlices", sheet, frames )
	local dgBg = self._dgSegment[1]
	local dgSelect = self._dgSegment[2]

	-- self:_removeUISlices()

	--== Active

	o = display.newImage( sheet, frames.leftActive )
	o.anchorX, o.anchorY = 0,0
	o.isVisible=false
	dgSelect:insert( o )
	self._leftA = o

	o = display.newImage( sheet, frames.middleActive )
	o.anchorX, o.anchorY = 0,0
	o.isVisible=false
	dgSelect:insert( o )
	self._middleA = o

	o = display.newImage( sheet, frames.rightActive )
	o.anchorX, o.anchorY = 0,0
	o.isVisible=false
	dgSelect:insert( o )
	self._rightA = o

	-- dividers

	o = display.newImage( sheet, frames.dividerIA )
	o.anchorX, o.anchorY = 0,0
	o.isVisible=false
	dgSelect:insert( o )
	self._divIA = o

	o = display.newImage( sheet, frames.dividerAI )
	o.anchorX, o.anchorY = 0,0
	o.isVisible=false
	dgSelect:insert( o )
	self._divAI = o

	--== Inactive

	o = display.newImage( sheet, frames.leftInactive )
	o.anchorX, o.anchorY = 0,0
	dgBg:insert( o )
	self._leftI = o

	o = display.newImage( sheet, frames.rightInactive )
	o.anchorX, o.anchorY = 0,0
	dgBg:insert( o )
	self._rightI = o

end

function SegmentedCtrl:__commitProperties__()
	-- print( 'SegmentedCtrl:__commitProperties__' )
	local style = self.curr_style
	local view = self.view
	local offsets = {
		L=style.offsetLeft,
		R=style.offsetRight,
		T=style.offsetTop,
		B=style.offsetBottom,
	}

	if self._sheetInfo_dirty or self._sheetImage_dirty then
		self._sheet = loadSpriteSheet( style.sheetInfo, style.sheetImage )
		self._sheetInfo_dirty=false
		self._sheetImage_dirty=false

		self._spriteSheet_dirty=true
	end

	if self._spriteSheet_dirty then
		self:_createUISlices( self._sheet, style.spriteFrames )

		-- measure height, adjust for offsets
		style.height=self._leftA.height-(offsets.T+offsets.B)

		print(self._leftA.height, style.height)

		-- self:_createUISlices( self._sheet, style.spriteFrames )
		self._spriteSheet_dirty=false
	end

	if self._segmentCount_dirty then
		self:_createSegmentSlices( self._sheet, style.spriteFrames )
		local w = self:_adjustUILayout( style.height, offsets )
		style.width = w
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
	end

	if self._height_dirty then
		self._height_dirty=false

		self._anchorY_dirty=true
	end

	-- anchorX/anchorY

	if self._anchorX_dirty then
		self._dgSegment.x = -style.width*style.anchorX+offsets.L
		self._anchorX_dirty=false
	end
	if self._anchorY_dirty then
		self._dgSegment.y = -style.height*style.anchorY
		self._anchorY_dirty=false
	end

	-- selected index

	if self._selectedIdx_dirty then
		self._selectedIdx_dirty=false

		self._segmentHighlight_dirty=true
	end

	if self._segmentHighlight_dirty then
		self:_highlightSegment()
		self._segmentHighlight_dirty=false
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
