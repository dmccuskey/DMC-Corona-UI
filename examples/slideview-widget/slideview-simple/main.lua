--====================================================================--
-- SlideView Simple
--
-- A slide view which fills the screen below the status bar, on any
-- device, with five slides side by side: each is a color, a large
-- number and a line of text. Drag a slide more than half way, or flick
-- it, and the next one slides in; less, and it slides back. The first
-- and the last bounce at their edge.
--
-- A delegate supplies the slides: numberOfSlides() says how many,
-- onSlideRender() fills the view of a slide when it comes near the
-- screen (only the slide showing and its neighbors exist), and
-- didShowSlide() updates the line at the bottom, "2 of 5".
--
-- After a second the app moves to the second slide by itself
-- (gotoSlide()). A tap on a slide (didSelectSlide()) starts the
-- auto-advance: every two seconds the next slide, and the first after
-- the last (startAutoAdvance()). It waits while a finger is on the
-- view. Another tap stops it (stopAutoAdvance()).
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2026 David McCuskey. All Rights Reserved.
--====================================================================--



print( '\n\n##############################################\n\n' )



--====================================================================--
--== Imports


local dUI = require 'lib.dmc_ui'



--====================================================================--
--== Setup, Constants


-- the screen, as the device reports it: config.lua asks for 320x480
-- 'letterbox', so a taller screen has room above and below the content
local SCREEN_W, SCREEN_H = display.actualContentWidth, display.actualContentHeight
local SCREEN_X, SCREEN_Y = display.screenOriginX, display.screenOriginY
local H_CENTER = display.contentCenterX
local STATUS_BAR_H = display.topStatusBarContentHeight

local tdelay = timer.performWithDelay

local ADVANCE_TIME = 2000

-- the content: a color and a line of text for each slide
local SLIDES = {
	{ color={ 0.16, 0.50, 0.73 }, text="Drag or flick to the next slide" },
	{ color={ 0.15, 0.68, 0.38 }, text="Less than half way slides back" },
	{ color={ 0.90, 0.49, 0.13 }, text="Only the slides near the screen exist" },
	{ color={ 0.56, 0.27, 0.68 }, text="Tap for the auto-advance" },
	{ color={ 0.75, 0.22, 0.17 }, text="The last slide bounces at its edge" },
}

local slideView, status = nil, nil -- the widget and the bottom line, later



--====================================================================--
--== Support Functions


local function updateStatus()
	local str = string.format( "%d of %d", slideView.index, slideView.numberOfSlides )
	if slideView.isAutoAdvancing then
		str = str .. "  ·  auto-advance"
	end
	status.text = str
end


-- the delegate: the slide view asks it for its slides,
-- and tells it what happens
--
local delegate = {

	numberOfSlides=function( self, slideView )
		return #SLIDES
	end,

	-- fill the view of a slide. its origin is the top left
	-- of the slide; 'width' and 'height' are the slide's size
	--
	onSlideRender=function( self, event )
		print( "onSlideRender", event.index )
		local view = event.view
		local w, h = event.width, event.height
		local info = SLIDES[ event.index ]
		local o

		o = display.newRect( 0, 0, w, h )
		o.anchorX, o.anchorY = 0, 0
		o:setFillColor( unpack( info.color ) )
		view:insert( o )

		o = display.newText( tostring( event.index ), w*0.5, h*0.4, native.systemFontBold, 120 )
		view:insert( o )

		o = display.newText{
			text=info.text, x=w*0.5, y=h*0.4+110,
			width=w-60, align='center',
			font=native.systemFont, fontSize=18,
		}
		view:insert( o )
	end,

	-- optional: the view is removed with everything in it
	--
	onSlideUnrender=function( self, event )
		print( "onSlideUnrender", event.index )
	end,

	-- a slide has come to rest in the view
	--
	didShowSlide=function( self, event )
		print( "didShowSlide", event.index )
		updateStatus()
	end,

	-- a tap on a slide
	--
	didSelectSlide=function( self, event )
		print( "didSelectSlide", event.index )
		local sv = event.target
		if sv.isAutoAdvancing then
			sv:stopAutoAdvance()
		else
			sv:startAutoAdvance( ADVANCE_TIME )
		end
		updateStatus()
	end,
}



--===================================================================--
--== Main
--===================================================================--


-- the line at the bottom, over the slides

status = display.newText( "", H_CENTER, SCREEN_Y+SCREEN_H-30, native.systemFont, 16 )

-- the slide view: its slides are the size of the widget

slideView = dUI.newSlideView{
	width=SCREEN_W,
	height=SCREEN_H-STATUS_BAR_H,
	delegate=delegate,
}
slideView.x, slideView.y = SCREEN_X, SCREEN_Y+STATUS_BAR_H

slideView:reloadData()
status:toFront()


tdelay( 1000, function()
	print( "goto slide 2" )
	slideView:gotoSlide( 2 )
end)
