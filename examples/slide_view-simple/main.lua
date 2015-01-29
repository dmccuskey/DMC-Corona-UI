--====================================================================--
-- Slide View Simple
--
-- Shows simple use of the DMC Widget: Slide View
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2014 David McCuskey. All Rights Reserved.
--====================================================================--



print( "\n\n#########################################################\n\n" )



--===================================================================--
--== Imports


local Widgets = require 'lib.dmc_widgets'



--===================================================================--
--== Setup, Constants


local W,H = display.contentWidth, display.contentHeight
local H_CENTER, V_CENTER = W*0.5, H*0.5

local OFFSET = 100



--===================================================================--
--== Support Functions


-- onRender()
-- called when table view needs to display a row
--
local function onRender( event )
	-- print( 'Main:onRender' )

	local view = event.view
	local slide_data = event.data
	local index = slide_data.idx

	local o

	o = display.newText( tostring(index), 40,30, native.systemFont, 32)
	o.anchorX, o.anchorY = 0.5,0
	view:insert( o )

	view._o = o

end

-- onUnrender()
-- called when table view needs to destroy a row
--
local function onUnrender( event )
	-- print( 'Main:onUnrender' )

	local view = event.view
	local o

	o = view._o
	o:removeSelf()

	view._o = nil

end

local function onEvent( event )
	-- print( 'onEvent', event.type )
	local etype = event.type
	local sv = event.target -- our scroll view

	if etype == sv.ITEMS_MODIFIED then
		print( "Items Modified" )
	elseif etype == sv.ITEM_SELECTED then
		local slide_data = event.data
		print( "Item Selected", event.index, event.slide )
		print( ">data ", slide_data.idx, slide_data.str )
	elseif etype == sv.TAKE_FOCUS then
		print( "Take Focus" )
	elseif etype == sv.SCROLLING then
		print( "View Scrolling", event.x, event.y, event.velocity )
	elseif etype == sv.SCROLLED then
		print( "View Scrolled", event.x, event.y, event.velocity )

	elseif etype == sv.SLIDE_IN_FOCUS then
		print( "Slide in Focus", event.index, event.slide )
	else
		print( 'onEvent', event.type )
	end

end


--===================================================================--
-- Main
--===================================================================--

-- create Slide View

local o = Widgets.newSlideView{
	width=W-OFFSET,
	height=H-OFFSET,
}
o.x, o.y = OFFSET*0.5, OFFSET*0.5

o:addEventListener( o.EVENT, onEvent )


-- create slides

for i = 1, 4 do

	local p = {
		height = 300,
		onItemRender=onRender,
		onItemUnrender=onUnrender,
		onItemEvent=onEvent,
		bgColor={0.5,0.5,0.5},
		data = {idx=i, str="our-data-#"..i}
	}

	o:insertSlide( p )

end

