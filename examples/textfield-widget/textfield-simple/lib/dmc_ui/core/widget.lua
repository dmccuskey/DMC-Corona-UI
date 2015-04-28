--====================================================================--
-- dmc_ui/core/view.lua
--
-- Documentation:
--====================================================================--

--[[

The MIT License (MIT)

Copyright (C) 2015 David McCuskey. All Rights Reserved.

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
--== DMC Corona UI : UI View Base
--====================================================================--


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.1.0"



--====================================================================--
--== DMC Corona UI Setup
--====================================================================--


local dmc_ui_data = _G.__dmc_ui
local dmc_ui_func = dmc_ui_data.func
local ui_find = dmc_ui_func.find



--====================================================================--
--== DMC UI :
--====================================================================--



--====================================================================--
--== Imports


local Objects = require 'dmc_objects'
local Patch = require 'dmc_patch'

local uiConst = require( ui_find( 'ui_constants' ) )

local LifecycleMixModule = require 'dmc_lifecycle_mix'
local StyleMixModule = require( ui_find( 'dmc_style.style_mix' ) )



--====================================================================--
--== Setup, Constants


Patch.addPatch( 'table-pop' )

local newClass = Objects.newClass
local ComponentBase = Objects.ComponentBase

local LifecycleMix = LifecycleMixModule.LifecycleMix
local StyleMix = StyleMixModule.StyleMix

local tinsert = table.insert
local tpop = table.pop

--== To be set in initialize()
local dUI = nil



--====================================================================--
--== Widget Base Class
--====================================================================--


--- Widget Base Class.
-- The base class used for all Widgets.
--
-- @classmod Core.Widget

local View = newClass(
	{ StyleMix, ComponentBase, LifecycleMix },
	{name="dUI View"}
)

--== Event Constants

View.EVENT = 'view-event'


--======================================================--
-- Start: Setup DMC Objects

--== Init

function View:__init__( params )
	-- print( "View:__init__" )
	params = params or {}
	if params.x==nil then params.x=0 end
	if params.y==nil then params.y=0 end
	if params.id==nil then params.id='' end
	if params.autoMask==nil then params.autoMask=false end
	if params.autoResizeSubViews==nil then params.autoResizeSubViews=true end
	if params.layoutMargins==nil then params.layoutMargins=uiConst.VIEW_LAYOUT_MARGINS end

	self:superCall( LifecycleMix, '__init__', params )
	self:superCall( ComponentBase, '__init__', params )
	self:superCall( StyleMix, '__init__', params )
	--==--

	-- save params for later
	self._wc_tmp_params = params -- tmp

	--== Create Properties ==--

	-- properties stored in Class

	self._x = params.x
	self._x_dirty = true
	self._y = params.y
	self._y_dirty = true

	self._id = ''

	self._isRendered = false

	-- properties from style

	self._debugOn_dirty=true
	self._width_dirty=true
	self._height_dirty=true
	self._anchorX_dirty=true
	self._anchorY_dirty=true

	self._autoResizeSubViews = params.autoResizeSubViews
	self._autoResizeSubViews_dirty=true

	self._layoutMargins_dirty=true


	--[[
	references to main View/Control objects, not their property 'view'
	--]]
	self._subViews = {}

	--[[
	{width=0,height=0}
	--]]
	self._preferredContentSize = params.preferredContentSize

	--== Display Groups ==--

	self._dgBg = nil
	self._dgViews = nil

	--== Object References ==--

	self._delegate = nil

	self._parentView = params.parentView

	if params.autoMask == true then
		self:_setView( display.newContainer( params.width, params.height ) )
		self.view.anchorChildren = false
		self.view.anchorX, self.view.anchorY = 0, 0
	end

end

function View:__undoInit__()
	--print( "View:__undoInit__" )
	--==--
	self:superCall( StyleMix, '__undoInit__' )
	self:superCall( ComponentBase, '__undoInit__' )
	self:superCall( LifecycleMix, '__undoInit__' )
end


function View:__createView__()
	-- print( "View:__createView__" )
	self:superCall( ComponentBase, '__createView__' )
	--==--
	local dg

	dg = display.newGroup()
	self.view:insert( dg )
	self._dgBg = dg

	dg = display.newGroup()
	self.view:insert( dg )
	self._dgViews = dg

end

function View:__undoCreateView__()
	-- print( "View:__undoCreateView__" )
	self._dgViews:removeSelf()
	self._dgViews = nil

	self._dgBg:removeSelf()
	self._dgBg=nil
	--==--
	self:superCall( ComponentBase, '__undoCreateView__' )
end

--== initComplete

function View:__initComplete__()
	-- print( "View:__initComplete__" )
	self:superCall( StyleMix, '__initComplete__' )
	self:superCall( ComponentBase, '__initComplete__' )
	--==--
	local tmp = self._wc_tmp_params

	self._isRendered = true
	self.id = tmp.id
	self.delegate = tmp.delegate

	self.style = tmp.style

	self:_loadViews()
end

function View:__undoInitComplete__()
	-- print( "View:__undoInitComplete__" )
	self.delegate = nil
	self.style = nil
	self._isRendered = false
	--==--
	self:superCall( ComponentBase, '__undoInitComplete__' )
	self:superCall( StyleMix, '__undoInitComplete__' )
end

-- END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Static Methods


function View.initialize( manager )
	-- print( "View.initialize" )
	dUI = manager
end



--====================================================================--
--== Public Methods

--[[
Inherited Methods
--]]

--- set/get x position.
--
-- @within Properties
-- @function .x
-- @usage widget.x = 5
-- @usage print( widget.x )


--- set/get y position.
--
-- @within Properties
-- @function .y
-- @usage widget.y = 5
-- @usage print( widget.y )


--- set/get anchorX.
--
-- @within Properties
-- @function .anchorX
-- @usage widget.anchorX = 5
-- @usage print( widget.anchorX )

--- set/get anchorY.
--
-- @within Properties
-- @function .anchorY
-- @usage widget.anchorY = 5
-- @usage print( widget.anchorY )

--- set/get widget style.
-- style can be a style name or a Style Object.
-- Style Object must be appropriate style for Widget, eg style for Background widget comes from dUI.newBackgroundStyle().
-- @within Properties
-- @function .style
-- @usage widget.style = 'widget-home-page'
-- @usage
-- local wStyle = dUI.newTextStyle()
-- widget.style = wStyle


--- clear any local properties on style.
-- convenience method, calls clearProperties() on active style.
--
-- @within Methods
-- @function :clearStyle
-- @usage widget:clearStyle()




--== .X

function View.__getters:x()
	return self._x
end
function View.__setters:x( value )
	-- print( "View.__setters:x", value )
	assert( type(value)=='number' )
	--==--
	if self._x == value then return end
	self._x = value
	self._x_dirty=true
	self:__invalidateProperties__()
end

--== .Y

function View.__getters:y()
	return self._y
end
function View.__setters:y( value )
	-- print( "View.__setters:y", value )
	assert( type(value)=='number' )
	--==--
	if self._y == value then return end
	self._y = value
	self._y_dirty=true
	self:__invalidateProperties__()
end

--== .id

function View.__getters:id()
	return self._id
end
function View.__setters:id( value )
	-- print( "View.__setters:id", value )
	assert( type(value)=='string' )
	--==--
	if self._id == value then return end
	self._id = value
end


--== .delegate

--- set/get delegate for item.
--
-- @within Properties
-- @function .delegate
-- @usage widget.delegate = <delegate object>
-- @usage print( widget.delegate )

function View.__getters:delegate()
	-- print( "View.__getters:delegate" )
	return self._delegate
end
function View.__setters:delegate( value )
	-- print( "View.__setters:delegate", value )
	self._delegate = value
end

--== .width

function View:_widthChanged()
	-- print( "OVERRIDE View:_widthChanged" )
end
function View.__setters:width( value )
	-- print("View.__setters:width", value)
	StyleMix.__setters.width( self, value )
	self:_widthChanged()
end

--== .height

function View:_heightChanged()
	-- print( "OVERRIDE View:_heightChanged" )
end
function View.__setters:height( value )
	-- print( "View.__setters:height", value )
	StyleMix.__setters.height( self, value )
	self:_heightChanged()
end


--== _addSubView()

function View:_addSubView( subview, params )
	-- print( "View:_addSubView" )
	params = params or {}
	--==--
	tinsert( self._subViews, 1, subview )
	self.view:insert( subview.view )
end

--== _removeSubView()

function View:_removeSubView( View, params )
	-- print( "View:_removeSubView" )
	params = params or {}
	--==--
end

--== .preferredContentSize

function View.__getters:preferredContentSize()
	-- print( "View.__getters:preferredContentSize" )
	return self._preferredContentSize
end
function View.__setters:preferredContentSize( value )
	-- print( "View.__setters:preferredContentSize" )
	value = value or {}
	assert( value.width and value.height )
	--==--
	self._preferredContentSize = value
end



--====================================================================--
--== Private Methods


--[[
hook so that View knows when to load Sub Views
which are permanent to functionality, eg NavBar
--]]
function View:_loadViews() end



--======================================================--
-- DMC Lifecycle Methods

function View:__commitProperties__()
	-- print( "View:__commitProperties__" )
end



--====================================================================--
--== Event Handlers


-- none



return View
