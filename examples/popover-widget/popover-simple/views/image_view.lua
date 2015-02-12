--====================================================================--
-- Image View
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
--== Image View Class
--====================================================================--


local ImageView = newClass( ComponentBase, {name="Image View"} )


--======================================================--
-- Start: Setup DMC Objects

function ImageView:__init__( params )
	-- print( "ImageView:__init__" )
	params = params or {}
	self:superCall( '__init__', params )
	--==--

	--== Sanity Check ==--

	if self.is_class then return end

	assert( params.width and params.height, "Image View: requires dimensions" )
	assert( params.data, "Image View: requires param 'data'" )

	--== Create Properties ==--

	self._width = params.width
	self._height = params.height

	self.nav_bar_item = nil -- for navigation view

	self._data = params.data -- gallery data

	--== Object References ==--

	self._primer = nil
end


-- __createView__()
--
function ImageView:__createView__()
	-- print( "ImageView:__createView__" )
	self:superCall( '__createView__' )
	--==--
	local W, H = self._width, self._height
	local H_CENTER, V_CENTER = W*0.5, H*0.5

	local o

	-- display primer

	o = display.newRect(0, 0, W, H)
	o:setFillColor(0.2,0.4,0.2,1)
	o.anchorX, o.anchorY = 0.5, 0
	o.x, o.y = 0, 0

	self:insert( o )
	self._primer = o

end

function ImageView:__undoCreateView__()
	--print( "ImageView:__undoCreateView__" )

	local o

	o = self._primer
	o:removeSelf()
	self._primer = nil

	--==--
	self:superCall( '__undoCreateView__' )
end


-- __initComplete__()
--
function ImageView:__initComplete__()
	-- print( "ImageView:__initComplete__" )
	self:superCall( '__initComplete__' )
	--==--
	-- setup our nav item
	local o = Widgets.newNavItem{
		title="Image"
	}
	self.nav_bar_item = o
end

function ImageView:__undoInitComplete__()
	-- print( "ImageView:__undoInitComplete__" )
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


-- none




return ImageView
