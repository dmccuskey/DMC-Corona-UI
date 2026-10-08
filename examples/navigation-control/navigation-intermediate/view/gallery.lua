--====================================================================--
-- view/gallery.lua
--
-- the second view: a button for each image of one gallery
--====================================================================--



--====================================================================--
--== Imports


local dUI = require 'lib.dmc_ui'

local Common = require 'view.common'
local ImageView = require 'view.image'



--===================================================================--
--== Gallery View
--===================================================================--


-- a button was released: push that image's view
--
local function buttonHandler( event )
	local navView, image = unpack( event.data )

	-- the Navigation Control put itself in the view's 'parent'
	local navCtrl = navView.parent

	navCtrl:pushView( ImageView.new( image, navCtrl ) )
end


local function createGalleryView( gallery, navCtrl )
	-- print( "createGalleryView", gallery )

	--[[
	the view which the Navigation Control shows for us:
	a plain table
	--]]

	local navView = {

		_data = gallery,

		-- shown in the nav bar
		title = gallery.title,

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

	Common.newBackground( dg, navCtrl, { 0.2, 0.5, 0.2 } )

	-- a button for each image

	local pos, offset = 80, 75
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
