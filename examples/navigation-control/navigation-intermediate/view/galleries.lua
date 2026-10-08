--====================================================================--
-- view/galleries.lua
--
-- the first view: a button for each gallery
--====================================================================--



--====================================================================--
--== Imports


local dUI = require 'lib.dmc_ui'

local Common = require 'view.common'
local GalleryView = require 'view.gallery'



--===================================================================--
--== Galleries View
--===================================================================--


-- a button was released: push that gallery's view
--
local function buttonHandler( event )
	local navView, gallery = unpack( event.data )

	-- the Navigation Control put itself in the view's 'parent'
	local navCtrl = navView.parent

	navCtrl:pushView( GalleryView.new( gallery, navCtrl ) )
end


local function createGalleriesView( data, navCtrl )
	-- print( "createGalleriesView", data )

	--[[
	the view which the Navigation Control shows for us:
	a plain table
	--]]

	local navView = {

		_data = data,

		-- shown in the nav bar
		title = "Galleries",

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

	Common.newBackground( dg, navCtrl, { 0, 0.2, 0.1 } )

	-- a button for each gallery

	local pos, offset = 80, 75
	for i, gallery in ipairs( data ) do
		local o = dUI.newPushButton{
			labelText = "Show "..gallery.title,
			data = { navView, gallery },
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
	new = createGalleriesView
}
