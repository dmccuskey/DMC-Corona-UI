--====================================================================--
-- dmc_widget/widget_text.lua
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
--== DMC Corona UI : TableViewCell Widget
--====================================================================--


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.1.0"



--====================================================================--
--== DMC UI Setup
--====================================================================--


local dmc_ui_data = _G.__dmc_ui
local dmc_ui_func = dmc_ui_data.func
local ui_find = dmc_ui_func.find
local ui_file = dmc_ui_func.file



--====================================================================--
--== DMC UI : newTableViewCell
--====================================================================--



--====================================================================--
--== Imports


local Objects = require 'dmc_objects'
local Utils = require 'dmc_utils'

local uiConst = require( ui_find( 'ui_constants' ) )

local View = require( ui_find( 'core.view' ) )



--====================================================================--
--== Setup, Constants


local newClass = Objects.newClass


-- these are set later
local dUI = nil
local Widget = nil
local FontMgr = nil



--====================================================================--
--== TableViewCell Widget Class
--====================================================================--


local TableViewCell = newClass( View, { name="TableViewCell" } )

--== Class Constants

TableViewCell.LEFT = 'left'
TableViewCell.CENTER = 'center'
TableViewCell.RIGHT = 'right'

-- tableviewcell layouts
TableViewCell.DEFAULT = 'default-layout'
TableViewCell.SUBTITLE = 'subtitle-layout'

-- tableviewcell accessories
TableViewCell.NONE = 'no-accessory'
TableViewCell.CHECKMARK = 'checkmark-accessory'
TableViewCell.DETAIL_BUTTON = 'detail-button-accessory'
TableViewCell.DISCLOSURE_INDICATOR = 'disclosure-indicator-accessory'

TableViewCell.ACCESSORY = {
	[ TableViewCell.CHECKMARK ] = {
		w=114, h=128,
		file=ui_file('dmc_widget/assets/tableviewcell/accessory-checkmark.png' ),
	},
	[ TableViewCell.DETAIL_BUTTON ] = {
		w=108, h=128,
		file=ui_file('dmc_widget/assets/tableviewcell/accessory-detail-button.png' ),
	},
	[ TableViewCell.DISCLOSURE_INDICATOR ] = {
		w=70, h=128,
		file=ui_file('dmc_widget/assets/tableviewcell/accessory-disclose-indicator.png' )
	}
}

--== Style/Theme Constants

TableViewCell.STYLE_CLASS = nil -- added later
TableViewCell.STYLE_TYPE = uiConst.TABLEVIEWCELL

-- TODO: hook up later
-- TableViewCell.DEFAULT = 'default'

-- TableViewCell.THEME_STATES = {
-- 	TableViewCell.DEFAULT,
-- }

--== Event Constants

TableViewCell.EVENT = 'tableviewcell-widget-event'


--[[

marginX = separatorInsert
indentLevel
indentWidth
--]]

--======================================================--
-- Start: Setup DMC Objects

--== Init

function TableViewCell:__init__( params )
	-- print( "TableViewCell:__init__", params )
	params = params or {}
	if params.x==nil then params.x=0 end
	if params.y==nil then params.y=0 end
	if params.text==nil then params.text="" end

	self:superCall( '__init__', params )
	--==--

	--== Create Properties ==--

	-- properties in this class

	self._x = params.x
	self._x_dirty = true
	self._y = params.y
	self._y_dirty = true

	self._highlight = false --

	self._textLabel = params.text
	self._textLabel_dirty=true
	self._textDetail = params.text
	self._textDetail_dirty=true

	-- properties from style

	self._accessory = nil
	self._accessoryObject = nil
	self._accessory_dirty=true

	self._width_dirty=true
	self._height_dirty=true
	-- virtual
	self._rectBgWidth_dirty=true
	self._rectBgHeight_dirty=true
	self._displayWidth_dirty=true
	self._displayHeight_dirty=true

	self._align_dirty=true
	self._anchorX_dirty=true
	self._anchorY_dirty=true
	self._fillColor_dirty = true
	self._font_dirty=true
	self._fontSize_dirty=true
	self._marginX_dirty=true
	self._marginY_dirty=true
	self._strokeColor_dirty=true
	self._strokeWidth_dirty=true

	self._textColor_dirty=true
	-- virtual
	self._textLabelX_dirty=true
	self._textLabelWidth_dirty=true
	self._textLabelY_dirty=true

	self._cellLayout = TableViewCell.SUBTITLE
	self._cellLayout_dirty = true

	self._textDetailY_dirty=true

	--== Object References ==--

	self._tmp_style = params.style -- save

	self._wgtTextLabel = nil -- text widget (for both hint and value display)
	self._wgtTextLabel_f = nil -- widget handler
	self._wgtTextLabel_dirty=true

	self._wgtTextDetail = nil -- text widget (for both hint and value display)
	self._wgtTextDetail_f = nil -- widget handler
	self._wgtTextDetail_dirty=true

	self._rectBg = nil -- our background object

end

--[[
function TableViewCell:__undoInit__()
	-- print( "TableViewCell:__undoInit__" )
	--==--
	self:superCall( '__undoInit__' )
end
--]]


--== createView

function TableViewCell:__createView__()
	-- print( "TableViewCell:__createView__" )
	self:superCall( '__createView__' )
	--==--
	local o = display.newRect( 0,0,0,0 )
	o.anchorX, o.anchorY = 0.5, 0.5
	self:insert( o )
	self._rectBg = o
end

function TableViewCell:__undoCreateView__()
	-- print( "TableViewCell:__undoCreateView__" )
	self._rectBg:removeSelf()
	self._rectBg=nil
	--==--
	self:superCall( '__undoCreateView__' )
end


--== initComplete

function TableViewCell:__initComplete__()
	-- print( "TableViewCell:__initComplete__" )
	self:superCall( '__initComplete__' )
	--==--
	self:_createTextLabel()
	self:_createTextDetail()
	self:setAnchor( self.TopLeftReferencePoint )
end

function TableViewCell:__undoInitComplete__()
	--print( "TableViewCell:__undoInitComplete__" )
	self:_removeTextLabel()

	--==--
	self:superCall( '__undoInitComplete__' )
end

-- END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Static Methods


function TableViewCell.initialize( manager )
	-- print( "TableViewCell.initialize" )
	dUI = manager
	Widget = dUI.Widget

	FontMgr = dUI.FontMgr

	local Style = dUI.Style
	TableViewCell.STYLE_CLASS = Style.TableViewCell

	Style.registerWidget( TableViewCell )
end





--====================================================================--
--== Public Methods


--== X

function TableViewCell.__getters:x()
	return self._x
end
function TableViewCell.__setters:x( value )
	-- print( 'TableViewCell.__setters:x', value )
	assert( type(value)=='number' )
	--==--
	if self._x == value then return end
	self._x = value
	self._x_dirty=true
	self:__invalidateProperties__()
end

--== Y

function TableViewCell.__getters:y()
	return self._y
end
function TableViewCell.__setters:y( value )
	-- print( 'TableViewCell.__setters:y', value )
	assert( type(value)=='number' )
	--==--
	if self._y == value then return end
	self._y = value
	self._y_dirty=true
	self:__invalidateProperties__()
end


--[[
we use custom getters for width/height
without width/height, we just use dimensions
from text object after creation
--]]

--== width (custom)


function TableViewCell.__getters:width()
	-- print( 'TableViewCell.__getters:width' )
	local w, t = self.curr_style.width, self._txt_text
	if w==nil and t then w=t.width end
	return w
end
function TableViewCell.__setters:width( value )
	-- print( 'TableViewCell.__setters:width', value )
	self.curr_style.width = value
end

--== height (custom)

function TableViewCell.__getters:height()
	-- print( 'TableViewCell.__getters:height' )
	local h, t = self.curr_style.height, self._txt_text
	if h==nil and t then h=t.height end
	return h
end
function TableViewCell.__setters:height( value )
	-- print( 'TableViewCell.__setters:height', value )
	self.curr_style.height = value
end

-- get just the text height
function TableViewCell:getTextHeight()
	-- print( "TableViewCell:getTextHeight", self._txt_text )
	local val = 0
	if self._txt_text then
		val = self._txt_text.height
	end
	return val
end


function TableViewCell.__getters:highlight()
	return self._highlight
end
function TableViewCell.__setters:highlight( value )
	-- print( "TableViewCell.__setters:highlight", value )
	assert( type(value)=='boolean' )
	--==--
	if self._highlight == value then return end
	self._highlight = value
	self._highlight_dirty=true
	self:__invalidateProperties__()
end


function TableViewCell.__getters:cellLayout()
	return self._cellLayout
end
function TableViewCell.__setters:cellLayout( value )
	-- print( "TableViewCell.__setters:cellLayout", value )
	assert( type(value)=='string' )
	--==--
	if self._cellLayout == value then return end
	self._cellLayout = value
	self._cellLayout_dirty=true
	self:__invalidateProperties__()
end



function TableViewCell.__getters:imageView()
	return self._imageView
end
function TableViewCell.__setters:imageView( value )
	self._imageView = value
	self._imageView_dirty=true
	self:__invalidateProperties__()
end

function TableViewCell.__getters:accessory()
	return self._accessory
end
function TableViewCell.__setters:accessory( value )
	assert( value )
	self._accessory = value
	self._accessory_dirty=true
	self:__invalidateProperties__()
end



function TableViewCell.__getters:textLabel()
	return self._wgtTextLabel
end

function TableViewCell.__getters:textDetail()
	return self._wgtTextDetail
end


--- set margin of table view cell.
-- this sets left and right side
-- @integer value
-- @usage cell.marginX=10
--
function TableViewCell.__setters:marginX( value )
	-- print( 'TableViewCell.__setters:marginX', value )
	assert( type(value)=='number' )
	--==--
	if self._marginX == value then return end
	self._marginX = value
	self._marginX_dirty=true
	self:__invalidateProperties__()
end


function TableViewCell.__setters:contentMargin( value )
	-- print( 'TableViewCell.__setters:contentMargin', value )
	assert( type(value)=='number' )
	--==--
	if self._contentMargin == value then return end
	self._contentMargin = value
	self._contentMargin_dirty=true
	self:__invalidateProperties__()
end




--====================================================================--
--== Private Methods


function TableViewCell:_removeAccessory( obj )
	if not obj then return end
	obj:removeSelf()
	return nil
end

function TableViewCell:_loadAccessory( name, obj )
	-- print( "TableViewCell:_loadAccessory" )
	local tbl = TableViewCell.ACCESSORY
	if obj then obj:removeSelf() end
	local info = tbl[ name ]
	local scale = 20/info.h
	local img = display.newImageRect( info.file, info.w*scale, info.h*scale )
	return img
end


function TableViewCell:_removeTextDetail()
	-- print( "TableViewCell:_removeTextDetail" )
	local o = self._wgtTextDetail
	if not o then return end
	o:removeSelf()
	self._wgtTextDetail = nil
end

function TableViewCell:_createTextDetail()
	-- print( "TableViewCell:_createTextDetail" )
	local style = self.curr_style
	local o -- object

	self:_removeTextDetail()

	local o = Widget.newText{
		defaultStyle = self.defaultStyle.label
	}
	o:setAnchor( o.CenterLeftReferencePoint )
	self:insert( o.view )
	self._wgtTextDetail = o

	--== Reset properties

	self._textDetailX_dirty=true
	self._textDetailWidth_dirty=true

	self._textColor_dirty=true
end


function TableViewCell:_removeTextLabel()
	-- print( "TableViewCell:_removeTextLabel" )
	local o = self._wgtTextLabel
	if not o then return end
	o:removeSelf()
	self._wgtTextLabel = nil
end

function TableViewCell:_createTextLabel()
	-- print( "TableViewCell:_createTextLabel" )
	local style = self.curr_style
	local o -- object

	self:_removeTextLabel()

	local o = Widget.newText{
		defaultStyle = self.defaultStyle.label
	}
	o:setAnchor( o.TopLeftReferencePoint )
	self:insert( o.view )
	self._wgtTextLabel = o

	--== Reset properties

	self._textLabelX_dirty=true
	self._textLabelWidth_dirty=true

	self._textColor_dirty=true
end



function TableViewCell:__commitProperties__()
	-- print( 'TableViewCell:__commitProperties__' )
	local style = self.curr_style
	-- local metric = FontMgr:getFontMetric( style.font, style.fontSize )
	metric={offsetX=0,offsetY=0}

	local view = self.view
	local bg = self._rectBg
	local imageView = self._imageView
	local textLabel = self._wgtTextLabel
	local textDetail = self._wgtTextDetail

	local marginX = self._marginX
	local contentMargin = self._contentMargin
	local height = self._height
	local layout = self._cellLayout
	local width = self._width

	--== position sensitive


	if self._marginX_dirty then
		self._marginX_dirty=false

		self._textLabelX_dirty=true
	end
	if self._width_dirty then
		bg.width = self._width
		self._width_dirty=false

		self._rectBgWidth_dirty=true
		self._textLabelWidth_dirty=true
		self._textDetailWidth_dirty=true
	end
	if self._height_dirty then
		bg.height = self._height
		self._height_dirty=false

		self._anchorY_dirty=true
		self._rectBgHeight_dirty=true
	end

	if self._marginX_dirty then
		self._marginX_dirty=false

		self._textLabelX_dirty=true
		self._textLabelWidth_dirty=true
		self._textDetailX_dirty=true
		self._textDetailWidth_dirty=true
	end
	if self._marginY_dirty then
		-- reminder, we don't set text height
		self._marginY_dirty=false

		self._rectBgHeight_dirty=true
		self._textLabelY_dirty=true
		self._displayHeight_dirty=true
	end

	-- virtual

	if self._contentMargin_dirty then
		self._contentMargin_dirty=true

		self._imageViewX_dirty=true
		self._textLabelX_dirty=true
		self._textDetailX_dirty=true
		self._accessoryX_dirty=true
	end

	-- bg width/height

	if self._rectBgWidth_dirty then
		self._rectBgWidth_dirty=false
	end
	if self._rectBgHeight_dirty then
		self._rectBgHeight_dirty=false
	end


	if self._accessory_dirty then
		local accessory = self._accessory
		local accessObj = self._accessoryObject

		if type(accessory)=='string' then
			if accessory==TableViewCell.CHECKMARK then
				accessObj = self:_loadAccessory( accessory, accessObj )
			elseif accessory==TableViewCell.DETAIL_BUTTON then
				accessObj = self:_loadAccessory( accessory, accessObj )
			elseif accessory==TableViewCell.DISCLOSURE_INDICATOR then
				accessObj = self:_loadAccessory( accessory, accessObj )
			else
				accessObj=self:_removeAccessory( accessObj )
			end
		else
			-- @TODO, allow other accessory objects
			accessObj = accessory
		end
		if accessObj then
			self.view:insert( accessObj )
			self._accessoryX_dirty=true
		end
		self._accessoryObject = accessObj
		self._accessory_dirty=false

		self._textLabelWidth_dirty=true
		self._textDetailWidth_dirty=true
	end

	if self._accessoryX_dirty then
		local accessObj = self._accessoryObject
		if not accessObj then return end
		local margin = self._marginX
		accessObj.anchorX, accessObj.anchorY = 1, 0.5
		accessObj.x, accessObj.y = width-margin, height*0.5
		self._accessoryX_dirty=false
	end

	-- anchorX/anchorY

	if self._anchorX_dirty then
		bg.anchorX = style.anchorX
		self._anchorX_dirty=false

		self._x_dirty=true
		self._textLabelX_dirty=true
	end
	if self._anchorY_dirty then
		bg.anchorY = style.anchorY
		self._anchorY_dirty=false

		self._y_dirty=true
		self._textLabelY_dirty=true
	end

	-- x/y

	if self._x_dirty then
		view.x = self._x
		self._x_dirty = false

		self._textLabelX_dirty=true
	end
	if self._y_dirty then
		view.y = self._y
		self._y_dirty = false

		self._textLabelY_dirty=true
	end

	if self._imageView_dirty then
		self._imageView_dirty=false

		self._imageViewX_dirty=true
		self._textLabelX_dirty=true
		self._textDetailX_dirty=true
	end

	if self._imageViewX_dirty then
		if not imageView then return end
		local margin = self._marginX
		local height = self._height -- use getter
		local offset = height/2
		imageView.x = margin
		imageView.y = offset
		imageView.height=30
		self._dgViews:insert( imageView )
		imageView.anchorX, imageView.anchorY = 0, 0.5
		self._imageViewX_dirty=false
	end


	-- text align x/y

	if self._textLabelX_dirty or self._textDetailX_dirty then
		local margin = marginX
		if imageView then
			margin = margin + imageView.width
		end
		if contentMargin then
			margin = margin + contentMargin
		end
		textLabel.x = margin
		textDetail.x = margin
		self._textDetailX_dirty=false
		self._textLabelX_dirty=false
	end

	if self._textLabelWidth_dirty or self._textDetailWidth_dirty then
		local accessObj = self._accessoryObject
		local margin = 2*marginX + 2*contentMargin
		if accessObj then
			margin = margin + accessObj.width
		end
		textLabel.width = width-margin
		textDetail.width = width-margin
		self._textDetailWidth_dirty=false
		self._textLabelWidth_dirty=false
	end

	if self._textLabelY_dirty then
		local offset
		if layout==TableViewCell.SUBTITLE then
			offset = height/3
		else
			offset = height/2
		end
		textLabel.anchorY = 0.5
		textLabel.y=offset
		self._textLabelY_dirty=false
	end

	if self._textDetailY_dirty then
		local offset
		if layout==TableViewCell.SUBTITLE then
			textDetail.isVisible=true
			offset = height-height/3
		else
			textDetail.isVisible=false
			offset = 0
		end
		textDetail.anchorY = 0.5
		textDetail.y=offset
		self._textDetailY_dirty=false
	end

	--== non-position sensitive

	-- textColor/fillColor

	if self._fillColor_dirty or self._debugOn_dirty then
		if style.debugOn==true then
			bg:setFillColor( 1,1,0,0.2 )
		else
			bg:setFillColor( unpack( style.fillColor ))
		end
		self._fillColor_dirty=false
		self._debugOn_dirty=false
	end
	if self._strokeColor_dirty then
		bg:setStrokeColor( unpack( style.strokeColor ))
		self._strokeColor_dirty=false
	end
	if self._strokeWidth_dirty then
		bg.strokeWidth = style.strokeWidth
		self._strokeWidth_dirty=false
	end

end




--====================================================================--
--== Event Handlers


function TableViewCell:stylePropertyChangeHandler( event )
	-- print( "TableViewCell:stylePropertyChangeHandler", event.type, event.property )
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

		self._align_dirty=true
		self._fillColor_dirty = true
		self._font_dirty=true
		self._fontSize_dirty=true
		self._marginX_dirty=true
		self._marginY_dirty=true
		self._strokeColor_dirty=true
		self._strokeWidth_dirty=true

		self._text_dirty=true
		self._textColor_dirty=true

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

		elseif property=='align' then
			self._align_dirty=true
		elseif property=='fillColor' then
			self._fillColor_dirty=true
		elseif property=='font' then
			self._font_dirty=true
		elseif property=='fontSize' then
			self._fontSize_dirty=true
		elseif property=='marginX' then
			self._marginX_dirty=true
		elseif property=='marginY' then
			self._marginY_dirty=true
		elseif property=='strokeColor' then
			self._strokeColor_dirty=true
		elseif property=='strokeWidth' then
			self._strokeWidth_dirty=true
		elseif property=='text' then
			self._text_dirty=true
		elseif property=='textColor' then
			self._textColor_dirty=true
		end

	end

	self:__invalidateProperties__()
	self:__dispatchInvalidateNotification__( property, value )
end




return TableViewCell
