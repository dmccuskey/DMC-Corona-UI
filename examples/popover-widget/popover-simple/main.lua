--====================================================================--
-- Navigator Simple
--
-- basic streaming example
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2014 David McCuskey. All Rights Reserved.
--====================================================================--



print( '\n\n##############################################\n\n' )



--====================================================================--
--== Imports


local MyPopover = require 'my_popover'

local galleries_data = require 'data.gallery'



--====================================================================--
--== Setup, Constants


local W, H = display.contentWidth, display.contentHeight
local H_CENTER, V_CENTER = W*0.5, H*0.5

local popover

local createGalleriesView, removeGalleriesView, galleriesView_handler



--====================================================================--
--== Support Functions


local onAccept, onCancel, onError

-- Create Items

onAccept = function()
	print( "\n\n" )
	print( "Watchlist Add Popup Test onAccept: " )
	print( "\n\n" )
	-- o:removeSelf()
end
onCancel = function( event )
	print( "\n\n" )
	print( "Watchlist Add Popup Test onCancel: " )
	print( "\n\n" )
	o:removeSelf()
end
onError = function( event )
	print( "\n\n" )
	print( "Watchlist Add Popup Test onError: " )
	print( "\n\n" )
	o:removeSelf()
end

popover = MyPopover:new{}

-- show, customized
popover:show{
	data=galleries_data,
	pos={x=H_CENTER, y=V_CENTER-100}
}

-- popover.x, popover.y = 100, 50


timer.performWithDelay( 20000, function()
	popover:removeSelf()
end)



