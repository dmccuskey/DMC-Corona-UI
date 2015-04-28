--====================================================================--
-- Image View
--
--====================================================================--



--====================================================================--
--== Imports


local dUI = require 'lib.dmc_ui'



--====================================================================--
--== Setup, Constants


local W, H = dUI.WIDTH, dUI.HEIGHT



--===================================================================--
--== Image View
--===================================================================--


local function willBeRemoved_handler( view )
	print( "View Will Be Removed" )
end


local function createImageView( image )

	--[[
	this is our view that the Nav Control
	is going to show for us

	it's just a very simple object/table
	--]]

	local navView = {

		_data = image,

		-- title will show up in nav bar automatically
		title = image.title,

		-- navItem is our "marker" in the navigation stack
		--[[
		navItem = dUI.newNavItem{
			title=image.title
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
	o:setFillColor(0.5,0.2,0.2)
	o.anchorX, o.anchorY = 0.5, 0
	dg:insert( o )

	-- image

	-- o.x, o.y = 0, 50
	-- dg:insert( o.view )


	return navView
end



return {
	new = createImageView
}
