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
local Patch = require 'dmc_patch'
local Utils = require 'dmc_utils'

local uiConst = require( ui_find( 'ui_constants' ) )

local WidgetBase = require( ui_find( 'core.widget' ) )



--====================================================================--
--== Setup, Constants


Patch.addPatch( 'print-output' )

local assert = assert
local getStage = display.getCurrentStage
local newRect = display.newRect
local newImage = display.newImage
local sformat = string.format
local tinsert, tremove = table.insert, table.remove
local type = type

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

	-- don't use style width/height
	self._width=0
	self._height=0

	self._sheet = nil
	self._spriteSheet_dirty=true

	self._selectedIdx = 0
	self._selectedIdx_dirty=true

	-- array of info records
	self._segmentInfo = {}
	self._removeSegmentInfo = {}
	self._segmentCount_dirty=true

	-- properties stored in Style

	self._offsetLeft_dirty=true
	self._offsetRight_dirty=true
	self._offsetTop_dirty=true
	self._offsetBottom_dirty=true
	self._sheetInfo_dirty=true
	self._sheetImage_dirty=true
	self._spriteFrames_dirty=true

	-- virtual

	self._segmentHighlight_dirty=true
	self._spriteSheet_dirty=true

	--== Object References ==--

	-- self._dgBg = nil
	self._dgSegment = nil  -- display group for segments
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

	-- items overlay
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
--]]

function SegmentedCtrl:__undoInitComplete__()
	-- print( "SegmentedCtrl:__undoInitComplete__" )
	self:_removePreparedSegments( self._segmentInfo )
	self:_removePreparedSegments( self._removeSegmentInfo )
	--==--
	self:superCall( '__undoInitComplete__' )
end

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


--== .width

function SegmentedCtrl.__getters:width()
	return self._width
end
function SegmentedCtrl.__setters:width( value )
	-- print("SegmentedCtrl.__setters:width", value)
	self._width = value
	self:_widthChanged()
end

--== .height

function SegmentedCtrl.__getters:height()
	return self._height
end
function SegmentedCtrl.__setters:height( value )
	-- print( "SegmentedCtrl.__setters:height", value )
	self._height = value
	self:_heightChanged()
end

--== .selected

function SegmentedCtrl.__getters:selected()
	return self._selectedIdx
end
function SegmentedCtrl.__setters:selected( idx )
	-- print( "SegmentedCtrl.__setters:selected", idx )
	if idx<1 or idx>#self._segmentInfo then idx = 0 end
	local sInfo = self._segmentInfo[idx] or {}

	self._selectedIdx = idx
	self._selectedIdx_dirty=true
	self:__invalidateProperties__()
	self:dispatchEvent( self.SELECTED, {index=idx, data=sInfo.data}, {merge=true} )
end

--== :insertSegment

--- insert new segment into control.
--
-- @usage
-- widget:insertSegment( string/image )
-- widget:insertSegment( string/image, params )
-- widget:insertSegment( index, string/image )
-- widget:insertSegment( index, string/image, params )

function SegmentedCtrl:insertSegment( ... )
	-- print( "SegmentedCtrl:insertSegment" )
	local args = {...}
	assert( #args>=1 and #args<=3, "SegmentedCtrl:insertSegment incorrect number of args" )
	--==--
	local idx, obj, params

	--== check params

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
	assert( type(obj)=='string' or type(obj)=='table', "SegmentedCtrl:insertSegment object should be 'string' or 'image'" )

	--== Start Processing

	params = params or {}

	local segments = self._segmentInfo
	if idx==nil then idx = #segments + 1 end

	local sInfo = self:_createSegmentRecord( params )
	tinsert( segments, idx, sInfo )
	self._segmentCount_dirty=true

	self:_createSegment( sInfo, obj, params )

	-- adjust current selection if necessary
	local selectedIdx = self._selectedIdx
	if idx<=selectedIdx then
		-- advance selected index if inserting
		-- item before current selection
		self._selectedIdx = selectedIdx+1
		self._selectedIdx_dirty=true
	end

	self:__invalidateProperties__()
end

--== :removeSegment

function SegmentedCtrl:removeSegment( idx )
	-- print( "SegmentedCtrl:removeSegment", idx )
	assert( type(idx)=='number', "SegmentedCtrl:removeSegment expected parameter of type 'number'" )
	--==--
	self:_removeSegmentPrep( idx )
	self._segmentCount_dirty=true
	self:__invalidateProperties__()
end

--== :removeAllSegments

function SegmentedCtrl:removeAllSegments()
	-- print( "SegmentedCtrl:removeAllSegments" )
	local curSegs = self._segmentInfo
	local remSegs = self._removeSegmentInfo
	local remSegPrep = self._removeSegmentPrep
	for i=#curSegs, 1, -1 do
		remSegPrep( self, i, curSegs, remSegs )
	end
	self._segmentCount_dirty=true
	self:__invalidateProperties__()
end

--== :isEnabled

function SegmentedCtrl:isEnabled( idx )
	-- print( "SegmentedCtrl:isEnabled", idx )
	assert( type(idx)=='number', "SegmentedCtrl:isEnabled expected parameter of type 'number'" )
	--==--
	local sInfo = self._segmentInfo[idx]
	if not sInfo then
		pwarn( sformat( "SegmentedCtrl:isEnabled no segment at index '%s'", idx ))
		return nil
	end
	return sInfo.isEnabled
end

--== :setEnabled

function SegmentedCtrl:setEnabled( idx, value )
	-- print( "SegmentedCtrl:setEnabled", idx, value )
	assert( type(idx)=='number', "SegmentedCtrl:isEnabled incorrect type for parameter 'index'" )
	assert( type(value)=='boolean', "SegmentedCtrl:isEnabled incorrect type for parameter 'value'" )
	--==--
	local sInfo = self._segmentInfo[idx]
	if not sInfo then
		pwarn( sformat( "SegmentedCtrl:setEnabled no segment at index '%s'", idx ))
		return nil
	end
	sInfo.isEnabled=value

	self._segmentHighlight_dirty=true
	self:__invalidateProperties__()
end

--== :setImage

--- replace existing segment content with an Image.
--
-- @int idx index of current segment to replace
-- @string image the image with which to update content
--
-- @usage
-- widget:setImage( image )
-- widget:setImage( index, image )
-- widget:setImage( image, params )
-- widget:setImage( index, image, params )

function SegmentedCtrl:setImage( idx, image, params )
	-- print( "SegmentedCtrl:setImage", idx, image )
	params = params or {}
	--==--
	local selectedIdx = self._selectedIdx
	local sInfo = self._segmentInfo[ idx ]
	sInfo.width = params.width or sInfo.width
	sInfo.data = params.data

	self:removeSegment( idx )
	self:insertSegment( idx, image, sInfo )

	self._selectedIdx = selectedIdx
	self._selectedIdx_dirty=true
	self:__invalidateProperties__()
end

--== :setText

--- replace existing segment content with Text.
--
-- @int idx index of current segment to replace
-- @string str the text with which to update content
-- @tparams[opt] table params
--
-- @usage
-- widget:setImage( string )
-- widget:setImage( index, string )
-- widget:setImage( string, params )
-- widget:setImage( index, string, params )

function SegmentedCtrl:setText( idx, str, params )
	-- print( "SegmentedCtrl:setText", idx, str )
	params = params or {}
	--==--
	local selectedIdx = self._selectedIdx
	local sInfo = self._segmentInfo[ idx ]
	sInfo.width = params.width or sInfo.width
	sInfo.data = params.data

	self:removeSegment( idx )
	self:insertSegment( idx, str, sInfo )

	self._selectedIdx = selectedIdx
	self._selectedIdx_dirty=true
	self:__invalidateProperties__()
end

--== :getWidth

function SegmentedCtrl:getWidth( idx )
	-- print( "SegmentedCtrl:getWidth", idx )
	local sInfo = self._segmentInfo[idx]
	if not sInfo then
		pwarn( sformat( "SegmentedCtrl:getWidth no segment at index '%s'", idx ))
		return nil
	end
	return sInfo.width
end

--== :setWidth

function SegmentedCtrl:setWidth( idx, value )
	-- print( "SegmentedCtrl:setWidth", idx, value )
	local sInfo = self._segmentInfo[idx]
	if not sInfo then
		pwarn( sformat( "SegmentedCtrl:setWidth no segment at index '%s'", idx ))
		return
	end
	sInfo.width = value
	self._segmentLayout_dirty=true
	self:__invalidateProperties__()

end



--====================================================================--
--== Private Methods


function SegmentedCtrl:_createSegmentRecord( params )
	params = params or {}
	if params.isEnabled==nil then params.isEnabled = true end
	if params.width==nil then params.width = 50 end
	if params.offsetX==nil then params.offsetX = 0 end
	if params.offsetY==nil then params.offsetY = 0 end
	--==--
	return {
		idx=0, -- current index
		isEnabled=params.isEnabled,
		width=params.width,
		offsetX=params.offsetX,
		offsetY=params.offsetY,
		data=params.data,
		type='text',
		item=nil, -- visual item
		bg=nil, -- inactive visual bg
		div=nil, -- inactive right divider
		cb=nil, -- touch callback
		hit=nil, -- touch hit area
	}
end


-- prepare to remove this segment, for async-removal
-- caller should set/call:
-- self._segmentCount_dirty, invalidate_properties
--
function SegmentedCtrl:_removeSegmentPrep( idx, curSegs, remSegs )
	-- print( "SegmentedCtrl:_removeSegmentPrep", idx )
	if curSegs==nil then curSegs=self._segmentInfo end
	if remSegs==nil then remSegs=self._removeSegmentInfo end
	assert( idx>=1 and idx<=#curSegs )
	--==--

	tinsert( remSegs, tremove( curSegs, idx ) )

	-- adjust current selection as necessary
	local selectedIdx = self._selectedIdx
	if selectedIdx==idx then
		self._selectedIdx=0
		self._selectedIdx_dirty=true
	elseif idx<selectedIdx then
		self._selectedIdx = selectedIdx-1
		self._selectedIdx_dirty=true
	end

end


-- this is sync-removal, async has already been setup.
-- so this is the time
--
function SegmentedCtrl:_removeSegment( sInfo )
	-- print( "SegmentedCtrl:_removeSegment", sInfo )

	self:_removeSegmentSlices( sInfo )

	-- remove hit area
	o = sInfo.hit
	if o~=nil then
		o:removeEventListener( 'touch', sInfo.cb )
		sInfo.cb=nil
		o:removeSelf()
		sInfo.hit=nil
	end

	-- remove object
	o = sInfo.item
	if o~=nil then
		o:removeSelf()
		sInfo.item=nil
	end

end

-- sync-create segment
-- have to do slices later, async-create
--
function SegmentedCtrl:_createSegment( sInfo, obj, params )
	-- print( "SegmentedCtrl:_createSegment", sInfo, obj, params )
	local dgBg = self._dgSegment[1] -- background
	local dgOver = self._dgSegment[3] -- overlay

	-- prepare object
	local item
	if type(obj)=='string' then
		sInfo.type='text'
		item = dUI.newText{text=obj}
		sInfo.item=item
		dgOver:insert( item.view )
		-- force update highlight, set text style
		self._segmentHighlight_dirty=true
	else
		sInfo.type='image'
		sInfo.item=obj
		item=obj
		dgOver:insert( obj )
	end
	item.isVisible=false

	-- create hit area
	if sInfo.hit==nil then
		local o = newRect( 0,0,10,10 )
		o.anchorX, o.anchorY = 0,0
		o:setFillColor( 0.5 )
		o.isHitTestable=true
		o.isVisible=false
		dgBg:insert( o )
		sInfo.hit = o
		sInfo.cb = self:_createSegmentTouchCallback( sInfo )
		o:addEventListener( 'touch', sInfo.cb )
		o.isVisible=false
	end

	--== slices will be created later

end


-- after addition/removal, re-adjust positioning of segments
--
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

		sInfo.idx=i

		w = sInfo.width
		-- adjust hit
		o = sInfo.hit
		-- o.isVisible=true
		o.width, o.height = w, h
		o.x, o.y = x, y+offT
		-- adjust item
		o = sInfo.item
		o.isVisible=true
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


-- hide/show the active slice elements.
-- can be called independently of selected index
--
-- @int[opt=selectedIdx] idx index to show
--
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
		local item

		if sInfo.type=='text' then item=sInfo.item end

		if idx~=i then
			if item then
				if sInfo.isEnabled then
					item:setActiveStyle( style.inactive )
				else
					item:setActiveStyle( style.disabled )
				end
				item.width=sInfo.width
			end

		elseif idx==i then

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

			if item then
				if sInfo.isEnabled then
					item:setActiveStyle( style.active )
				else
					item:setActiveStyle( style.disabled )
				end
				item.width=sInfo.width
			end
			mA.x, mA.y = sInfo.bg.x, y
			mA.width = sInfo.width
			mA.isVisible=true

		end

	end

end



-- create custom touch-callback for each segment
--
function SegmentedCtrl:_createSegmentTouchCallback( sInfo )

	return function( event )

		if not sInfo.isEnabled then return true end

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
				if self._selectedIdx~=segIdx then
					self.selected=segIdx
				end
			else
				self:_highlightSegment()
			end
			getStage():setFocus( nil )
			target._isFocus=false
		end

		return true
	end

end



function SegmentedCtrl:_removePreparedSegments( segments )
	-- print( "SegmentedCtrl:_removePreparedSegments" )
	if segments==nil then segments=self._segmentInfo end
	local removeSegment = self._removeSegment
	for i=1,#segments do
		local sInfo = segments[i]
		removeSegment( self, sInfo )
	end
end


function SegmentedCtrl:_removeSegmentSlices( sInfo )
	-- print( "SegmentedCtrl:_removeSegmentSlices" )
	local o

	o = sInfo.div
	if o~=nil then
		o:removeSelf()
		sInfo.div=nil
	end

	o = sInfo.bg
	if o~=nil then
		o:removeSelf()
		sInfo.bg=nil
	end

end

function SegmentedCtrl:_createSegmentSlices( sheet, frames, dg, sInfo )
	-- print( "SegmentedCtrl:_createSegmentSlices" )
	local dg = self._dgSegment[1] -- background

	-- inactive background

	if sInfo.bg==nil then
		local o = newImage( sheet, frames.middleInactive )
		o.anchorX, o.anchorY = 0,0
		dg:insert( o )
		sInfo.bg = o
	end

	-- inactive divider

	if sInfo.div==nil then
		local o = newImage( sheet, frames.dividerII )
		o.anchorX, o.anchorY = 0,0
		dg:insert( o )
		sInfo.div = o
	end

end


-- complete creation of segments, this is async-part
--
function SegmentedCtrl:_createAllSegmentSlices( sheet, frames )
	-- print( "SegmentedCtrl:_createAllSegmentSlices", sheet, frames )
	local segments = self._segmentInfo
	local dg = self._dgSegment[1] -- background
	local createSlices = self._createSegmentSlices
	for i=1,#segments do
		local sInfo = segments[i]
		if not sInfo.bg or not sInfo.div then
			createSlices( self, sheet, frames, dg, sInfo )
		end
	end
end



function SegmentedCtrl:_removeUISlices()
	-- print( "SegmentedCtrl:_removeUISlices" )
	local o

	o = self._leftA
	if o then
		o:removeSelf()
		self._leftA = nil
	end

	o = self._middleA
	if o then
		o:removeSelf()
		self._middleA = nil
	end

	o = self._rightA
	if o then
		o:removeSelf()
		self._rightA = nil
	end

	o = self._divIA
	if o then
		o:removeSelf()
		self._divIA = nil
	end

	o = self._divAI
	if o then
		o:removeSelf()
		self._divAI = nil
	end

	o = self._leftI
	if o then
		o:removeSelf()
		self._leftI = nil
	end

	o = self._rightI
	if o then
		o:removeSelf()
		self._rightI = nil
	end

end

-- create basic, reusable background image slices
--
function SegmentedCtrl:_createUISlices( sheet, frames )
	-- print( "SegmentedCtrl:_createUISlices", sheet, frames )
	local dgBg = self._dgSegment[1]
	local dgSelect = self._dgSegment[2]

	self:_removeUISlices()

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
		self.height=self._leftA.height-(offsets.T+offsets.B)
		self._spriteSheet_dirty=false
	end

	if self._segmentCount_dirty then
		self:_removePreparedSegments( self._removeSegmentInfo )
		self:_createAllSegmentSlices( self._sheet, style.spriteFrames )
		self._segmentCount_dirty=false

		self._segmentLayout_dirty=true
		self._width_dirty=true
	end


	if self._segmentLayout_dirty then
		-- measure width, adjusted for offsets
		local w = self:_adjustUILayout( self._height, offsets )
		self.width = w
		self._segmentLayout_dirty=false

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
		self._dgSegment.x = -self._width*style.anchorX+offsets.L
		self._anchorX_dirty=false
	end
	if self._anchorY_dirty then
		self._dgSegment.y = -self._height*style.anchorY
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
		-- self._width_dirty=true
		-- self._height_dirty=true
		self._anchorX_dirty=true
		self._anchorY_dirty=true

		self._offsetBottom_dirty=true
		self._offsetLeft_dirty=true
		self._offsetRight_dirty=true
		self._offsetTop_dirty=true
		self._spriteFrames_dirty=true
		self._sheetImage_dirty=true
		self._sheetInfo_dirty=true

		self._selectedIdx_dirty=true
		self._segmentHighlight_dirty=true
		self._spriteSheet_dirty=true

		property = etype

	else
		if property=='debugActive' then
			self._debugOn_dirty=true
		elseif property=='width' then
			-- self._width_dirty=true
		elseif property=='height' then
			-- self._height_dirty=true
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
