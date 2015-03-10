--====================================================================--
-- Gallery View
--
--====================================================================--



--====================================================================--
--== Imports


local dUI = require 'lib.dmc_ui'
local ImageView = require 'view.image'



--====================================================================--
--== Setup, Constants


local W, H = dUI.WIDTH, dUI.HEIGHT



--===================================================================--
--== Gallery View
--===================================================================--


local function buttonHandler( event )
	local button = event.target
	local data = event.data

	local navView, record = unpack( data )
	local navControl = navView.parent

	local gV = ImageView.new( record )

	navControl:pushView( gV )

end

local function willBeRemoved_handler( view )
	print( "View Will Be Removed" )
end


local function createGalleryView( gallery )
	-- print( "createGalleryView", gallery )

	--[[
	this is our view that the Nav Control
	is going to show for us

	it's just a very simple object/table
	--]]

	local navView = {

		_data = gallery,

		-- title will show up in nav bar automatically
		title = gallery.title,

		-- navItem is our "marker" in the navigation stack
		--[[
		navItem = dUI.newNavItem{
			title="Gallery"
		},
		--]]

		-- this display group is our content
		-- the Nav Control will modify view area as necessary
		-- by default, will be full-screen less the Nav Bar
		-- and anchor Top Center

		view = display.newGroup(),


		-- the Nav Control will put a reference to itself
		-- inside of your view so that you can send messages

		parent = nil,


		--== Some function callbacks

		willBeAdded=nil,
		viewInMotion=nil,
		viewDidAppear=nil,
		viewDidDisappear=nil,
		willBeRemoved=willBeRemoved_handler,

	}


	--== Setup the components of the view

	local dg = navView.view -- reference to our 'view'
	local o

	-- background

	o = display.newRect(0, 0, W, H)
	o:setFillColor(0.2,0.5,0.2)
	o.anchorX, o.anchorY = 0.5, 0
	dg:insert( o )

	-- add buttons

	local pos, offset = 100, 75
	for i, image in ipairs( gallery.images ) do

		local o = dUI.newPushButton{
			labelText = "Show "..image.title,
			data = { navView, image },
			onRelease = buttonHandler,
			style={
				width=200
			}
		}
		o.x, o.y = 0, pos
		dg:insert( o.view )

		pos = pos + offset
	end

	return navView
end



return {
	new = createGalleryView
}
