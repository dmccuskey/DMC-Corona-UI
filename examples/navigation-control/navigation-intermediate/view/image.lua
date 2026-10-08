--====================================================================--
-- view/image.lua
--
-- the third view: one image, a colored square
--====================================================================--



--====================================================================--
--== Imports


local dUI = require 'lib.dmc_ui'

local Common = require 'view.common'



--===================================================================--
--== Image View
--===================================================================--


local function infoHandler( event )
	print( "Image: Info released:", event.data.title )
end


local function createImageView( image, navCtrl )
	-- print( "createImageView", image )

	--[[
	the view which the Navigation Control shows for us:
	a plain table
	--]]

	local navView = {

		_data = image,

		-- our place in the nav bar. without it the control makes
		-- one from 'title'; with our own we can add buttons
		navItem = dUI.newNavItem{
			titleText=image.title,
			rightButton=dUI.newButton{
				labelText="Info",
				data=image,
				onRelease=infoHandler,
			},
		},

		-- used by the functions below
		title = image.title,

		-- our content: the control puts this display group
		-- below its bar, anchored top center
		view = display.newGroup(),

		-- set by the control when the view is pushed:
		-- the Navigation Control itself
		parent = nil,

	}

	Common.addViewFunctions( navView )

	--== Setup the components of the view

	local dg = navView.view
	local w, h = Common.viewSize( navCtrl )
	local o

	Common.newBackground( dg, navCtrl, { 0.15, 0.15, 0.18 } )

	-- the image

	o = display.newRect( 0, 40, w-80, w-80 )
	o:setFillColor( unpack( image.color ) )
	o.anchorY = 0
	dg:insert( o )

	return navView
end



return {
	new = createImageView
}
