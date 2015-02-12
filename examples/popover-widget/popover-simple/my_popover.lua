--====================================================================--
-- Popover Simple Example Simple
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2015 David McCuskey. All Rights Reserved.
--====================================================================--



--====================================================================--
--== Imports


local Objects = require 'lib.dmc_corona.dmc_objects'
local Navigator = require 'lib.dmc_corona.dmc_navigator'
local Utils = require 'lib.dmc_corona.dmc_utils'

--== Components

local Widgets = require 'lib.dmc_widgets'

local GalleriesView = require 'views.galleries_view'
local GalleryView = require 'views.gallery_view'
local ImageView = require 'views.image_view'



--====================================================================--
--== Setup, Constants


local newClass = Objects.newClass
local ComponentBase = Objects.ComponentBase
local PopoverMix = Widgets.PopoverMixModule.PopoverMix

local LOCAL_DEBUG = false



--====================================================================--
--== My Custom Popover Class
--====================================================================--


local MyPopover = newClass( {ComponentBase,PopoverMix}, {name="My Popover"} )

--== Class Constants

MyPopover.DIMS = {w=200,h=250} -- this is for static size


--======================================================--
-- Start: Setup DMC Objects

function MyPopover:__init__( params )
	-- print( "MyPopover:__init__" )
	params = params or {}
	params.width = MyPopover.DIMS.w
	params.height = MyPopover.DIMS.h
	self:superCall( PopoverMix, '__init__', params )
	self:superCall( ComponentBase, '__init__', params )
	--==--

	--== Create Properties ==--

	self._width = params.width
	self._height = params.height

	self._view_height = 0 -- set later

	self._data = nil -- gallery data

	--== Display Groups ==--

	--== Object References ==--

	self._view_galleries_f = nil
	self._view_gallery_f = nil
	self._view_image_f = nil

	-- visual

	self._nav_bar = nil

	self._nav_mgr = nil
	self._nav_mgr_f = nil

	self._primer = nil -- ref to display primer object
end

function MyPopover:__undoInit__()
	-- print( "MyPopover:__undoInit__" )
	self._show_object = nil
	--==--
	self:superCall( ComponentBase, '__undoInit__', params )
	self:superCall( PopoverMix, '__undoInit__', params )
end


-- __createView__()
--
function MyPopover:__createView__()
	-- print( "MyPopover:__createView__" )
	self:superCall( ComponentBase, '__createView__' )
	--==--
	local W, H = self._width, self._height
	local H_CENTER, V_CENTER = W*0.5, H*0.5

	local o, tmp

	--== Setup display primer

	o = display.newRect(0, 0, W, H)
	o:setFillColor(0,0,0,0)
	if gDEPLOY == 'DEV' and LOCAL_DEBUG then
		o:setFillColor(159,150,150,150)
	end
	o.anchorX, o.anchorY = 0.5, 0
	o.x, o.y = 0,0

	self:insert( o )
	self._primer = o

	-- nav bar

	o = Widgets.newNavBar{
		width=W
	}
	o.x, o.y = 0, 0

	self:insert( o.view )
	self._nav_bar = o

	-- navigator

	tmp = self._nav_bar
	self._view_height = H-tmp.height

	o = Navigator:new{
		width=W, height=self._view_height,
		default_reference=display.TopCenterReferencePoint
	}
	o.x, o.y = 0, tmp.height
	self:insert( o.view )
	self._nav_mgr = o

end

function MyPopover:__undoCreateView__()
	-- print( "MyPopover:__undoCreateView__" )

	self._nav_mgr:removeSelf()
	self._nav_mgr = nil

	self._nav_bar:removeSelf()
	self._nav_bar = nil

	self._primer:removeSelf()
	self._primer = nil

	--==--
	self:superCall( ComponentBase, '__undoCreateView__' )
end


-- __initComplete__()
--
function MyPopover:__initComplete__()
	-- print( "MyPopover:__initComplete__" )
	self:superCall( ComponentBase, '__initComplete__' )
	--==--
	local o

	self._view_galleries_f = self:createCallback( self._galleriesViewEvent_handler )
	self._view_gallery_f = self:createCallback( self._galleryViewEvent_handler )
	self._view_image_f = self:createCallback( self._imageViewEvent_handler )
	self._nav_mgr_f = self:createCallback( self._navigationMgrEvent_handler )

	self:createPopover()

	o = self._nav_mgr
	o:addEventListener( o.EVENT, self._nav_mgr_f )
	o.nav_bar = self._nav_bar -- set nav bar delegate

end

function MyPopover:__undoInitComplete__()
	-- print( "MyPopover:__undoInitComplete__" )
	local o

	o = self._nav_mgr
	o:cleanUp() -- clean FIRST !!!
	o:removeEventListener( o.EVENT, self._nav_mgr_f )

	self:removePopover()

	self._nav_mgr_f = nil
	self._view_list_f = nil
	self._view_crud_f = nil
	--==--
	self:superCall( ComponentBase, '__undoInitComplete__' )
end

-- END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Public Methods


function MyPopover:show( params )
	-- print( "MyPopover:show" )
	params = params or {}
	assert( params.data, "need gallery data" )
	assert( params.pos, "need position object" )
	--==--

	local view = self:_createGalleriesView( params.data )
	self._nav_mgr:pushView( view )

	self:showPopover( params.pos, {} )
end


function MyPopover:isDismissed()
	-- print( "MyPopover:isDismissed" )
	self:removeSelf()
end

function MyPopover:shouldDismiss()
	-- print( "MyPopover:shouldDismiss" )
	return true
end



--====================================================================--
--== Private Methods


function MyPopover:_createGalleriesView( galleries )
	-- print( "createGalleriesView", galleries )
	local width, height = self._width, self._view_height
	local o = GalleriesView:new{
		width=width,
		height=height,
		data=galleries
	}
	o:addEventListener( o.EVENT, self._view_galleries_f )
	return o
end
function MyPopover:_removeGalleriesView( o )
	-- print( "removeGalleriesView", o )
	o:removeEventListener( o.EVENT, self._view_galleries_f )
	o:removeSelf()
end


function MyPopover:_createGalleryView( gallery )
	local width, height = self._width, self._view_height
	local o = GalleryView:new{
		width=width,
		height=height,
		data=gallery
	}
	o:addEventListener( o.EVENT, self._view_gallery_f )
	return o
end
function MyPopover:_removeGalleryView( o )
	-- print( "removeGalleryView", o )
	o:removeEventListener( o.EVENT, self._view_gallery_f )
	o:removeSelf()
end


function MyPopover:_createImageView( image )
	local width, height = self._width, self._view_height
	local o = ImageView:new{
		width=width,
		height=height,
		data=image
	}
	o:addEventListener( o.EVENT, self._view_image_f )
	return o
end
function MyPopover:_removeImageView( o )
	-- print( "removeImageView", o )
	o:removeEventListener( o.EVENT, self._view_image_f )
	o:removeSelf()
end



--====================================================================--
--== Event Handlers


function MyPopover:_galleriesViewEvent_handler( event )
	-- print( "MyPopover:_galleriesViewEvent_handler", event.type )
	-- Utils.print( event )
	local gallery_data = event.data
	local o = self:_createGalleryView( gallery_data, self._width, self._view_height )
	self._nav_mgr:pushView( o )
end


function MyPopover:_galleryViewEvent_handler( event )
	-- print( "MyPopover:_galleryViewEvent_handler", event.type )
	-- Utils.print( event )
	local image_data = event.data
	local o = self:_createImageView( image_data, self._width, self._view_height )
	self._nav_mgr:pushView( o )
end


function MyPopover:_imageViewEvent_handler( event )
	-- print( "MyPopover:_imageViewEvent_handler", event.type )
	-- print( "Main:imageView_handler", event.type )
	-- none
end


function MyPopover:_navigationMgrEvent_handler( event )
	-- print( "MyPopover:_navigationMgrEvent_handler", event.type )
	local nav = event.target
	if event.type == nav.REMOVED_VIEW then
		assert( event.view )
		local view = event.view
		if view:isa( GalleriesView ) then
			self:_removeGalleriesView( view )
		elseif view:isa( GalleryView ) then
			self:_removeGalleryView( view )
		elseif view:isa( ImageView ) then
			self:_removeImageView( view )
		end
	end
end




return MyPopover
