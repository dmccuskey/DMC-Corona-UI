--====================================================================--
-- Galleries View
--
--====================================================================--



--====================================================================--
--== Imports


local Objects = require 'lib.dmc_corona.dmc_objects'
local Widgets = require 'lib.dmc_widgets'



--====================================================================--
--== Setup, Constants


-- setup some aliases to make code cleaner
local newClass = Objects.newClass
local ComponentBase = Objects.ComponentBase



--====================================================================--
--== Galleries View Class
--====================================================================--


local GalleriesView = newClass( ComponentBase, {name="Galleries View"} )

--== Event Constants

GalleriesView.EVENT = 'galleries_view-event'

GalleriesView.SELECTED = 'gallery-selected-event'


--======================================================--
-- Start: Setup DMC Objects

function GalleriesView:__init__( params )
	-- print( "GalleriesView:__init__" )
	params = params or {}
	self:superCall( '__init__', params )
	--==--

	--== Sanity Check ==--

	if self.is_class then return end

	assert( params.width and params.height, "Gallery View: requires dimensions" )
	assert( params.data, "Gallery View: requires param 'data'" )

	--== Create Properties ==--

	self._width = params.width
	self._height = params.height

	self.nav_bar_item = nil -- for navigation view

	self._data = params.data -- galleries data

	--== Object References ==--

	self._btn_gallery1 = nil
	self._table_view = nil

end


-- __createView__()
--
function GalleriesView:__createView__()
	-- print( "GalleriesView:__createView__" )
	self:superCall( '__createView__' )
	--==--
	local W, H = self._width, self._height
	local H_CENTER, V_CENTER = W*0.5, H*0.5

	local o

	-- display primer

	o = display.newRect(0, 0, W, H)
	o:setFillColor(0.2,0.2,0.2,1)
	o.anchorX, o.anchorY = 0.5, 0
	o.x, o.y = 0, 0

	self:insert( o )
	self._primer = o

	-- button

	o = Widgets.newButton{
		-- button info
		id='button-gallery1',
		type='push',

		-- label stuff
		label ="Gallery 1",

		-- view info
		view='shape',
		width = 100,
		height = 60,
		shape='roundedRect',
		corner_radius = 4,
		fill_color={1,1,0.5, 0.5},
		stroke_width=4,
		stroke_color={0.75,0.75,0.75,0.5},
	}
	o.x, o.y = 0, V_CENTER

	self:insert( o.view )
	self._btn_gallery1 = o

end

function GalleriesView:__undoCreateView__()
	--print( "GalleriesView:__undoCreateView__" )

	local o

	o = self._btn_gallery1
	o:removeSelf()
	self._btn_gallery1 = nil

	o = self._primer
	o:removeSelf()
	self._primer = nil

	--==--
	self:superCall( '__undoCreateView__' )
end


-- __initComplete__()
--
function GalleriesView:__initComplete__()
	-- print( "GalleriesView:__initComplete__" )
	self:superCall( '__initComplete__' )
	--==--

	local o -- object

	o = self._btn_gallery1
	o.onRelease = self:createCallback( self._gallery1Button_handler )

	-- setup our nav item

	o = Widgets.newNavItem{
		title="My Galleries"
	}
	self.nav_bar_item = o

end

function GalleriesView:__undoInitComplete__()
	-- print( "GalleriesView:__undoInitComplete__" )
	self._btn_gallery1.onRelease = nil
	self.nav_bar_item = nil
	--==--
	self:superCall( '__undoInitComplete__' )
end

-- END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Public Methods


-- none



--====================================================================--
--== Private Methods


-- none



--====================================================================--
--== Event Handlers


function GalleriesView:_gallery1Button_handler( event )
	-- print( "GalleriesView:_gallery1Button_handler ", event.type )
	self:dispatchEvent( self.SELECTED, self._data[1] )
end




return GalleriesView
