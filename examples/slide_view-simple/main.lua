--====================================================================--
-- Table View Simple
--
-- Shows simple use of the DMC Widget: Table View
--
-- by David McCuskey
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2014 David McCuskey. All Rights Reserved.
--====================================================================--

print("---------------------------------------------------")



--===================================================================--
-- Imports
--===================================================================--

local widgets = require( 'dmc_widgets' )


--===================================================================--
-- Setup, Constants
--===================================================================--

local W,H = display.contentWidth, display.contentHeight
local H_CENTER, V_CENTER = W*0.5, H*0.5

local OFFSET = 100

local o, p, f


--===================================================================--
-- Support Functions
--===================================================================--

-- onRender()
-- called when table view needs to display a row
--
local function onRender( event )
	-- print( 'Main:onRender' )

	local view = event.view
	local index = event.data

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
	-- print( 'onEvent' )

end


--===================================================================--
-- Main
--===================================================================--

-- create Slide View

p = {
	width=W-OFFSET,
	height=H-OFFSET,
}
o = widgets.newSlideView( p )
o.x, o.y = OFFSET*0.5, OFFSET*0.5


-- create slides

for i = 1, 5 do

	local p = {
		height = 300,
		onItemRender=onRender,
		onItemUnrender=onUnrender,
		onItemEvent=onEvent,
		data = i
	}

	o:insertSlide( p )

end

