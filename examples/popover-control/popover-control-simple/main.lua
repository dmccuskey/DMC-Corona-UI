--====================================================================--
-- Popover Control Simple
--
-- A control shown as a popover (modalStyle = dUI.POPOVER): a panel
-- which belongs to a button, with an arrow pointing at it, on any
-- device. The app is a screen with three buttons; a press on one opens
-- the same Navigation Control next to it (popoverControl.buttonItem).
--
-- The popover opens on a side of its button where there is room, and
-- stays on the screen: below "Top" at the top right, with its arrow
-- pointing up; above "Bottom", with its arrow pointing down. "Side"
-- names its side (arrowDirections = dUI.ARROW_LEFT), so its popover
-- opens to the right of it. A tap anywhere outside the popover closes
-- it. Inside is a short menu; an entry pushes a second view, and
-- "< Back" returns: navigation inside a popover. The app opens the
-- popover of "Top" by itself after a second.
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2014-2026 David McCuskey. All Rights Reserved.
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
local H_CENTER, V_CENTER = display.contentCenterX, display.contentCenterY
local STATUS_BAR_H = display.topStatusBarContentHeight

local POPOVER_SIZE = { width=220, height=240 }

local MENU = {
	{ title="Summer", color={ 0.8, 0.6, 0.2 } },
	{ title="Winter", color={ 0.3, 0.5, 0.7 } },
}

local navCtrl = nil -- the control in the popover, later



--====================================================================--
--== Support Functions


-- the room for a view in the control, below its bar
--
local function viewSize()
	return navCtrl.width, navCtrl.height - navCtrl.navBar.height
end


-- the second view: a colored view with the entry's title
--
local function newDetailView( entry )
	local w, h = viewSize()
	local dg = display.newGroup()
	local o

	o = display.newRect( 0, 0, w, h )
	o.anchorY = 0
	o:setFillColor( unpack( entry.color ) )
	dg:insert( o )

	o = display.newText{
		text="\"< Back\" returns to the menu.",
		x=0, y=h*0.5,
		width=w-40,
		font=native.systemFont, fontSize=14,
		align='center',
	}
	dg:insert( o )

	return {
		title=entry.title,
		view=dg,
		-- a popped view is hidden, not removed: that is ours to do
		willBeRemoved=function( self ) self.view:removeSelf() end,
	}
end


-- the first view: a button per menu entry, which pushes its view
--
local function newMenuView()
	local w, h = viewSize()
	local dg = display.newGroup()
	local o

	o = display.newRect( 0, 0, w, h )
	o.anchorY = 0
	o:setFillColor( 0.95, 0.95, 0.95 )
	dg:insert( o )

	for i, entry in ipairs( MENU ) do
		o = dUI.newPushButton{
			labelText=entry.title,
			onRelease=function( event )
				navCtrl:pushView( newDetailView( entry ) )
			end,
			style={ width=160 },
		}
		o.x, o.y = 0, i*60
		dg:insert( o.view )
	end

	return { title="Menu", view=dg }
end


-- open the popover at a button. 'directions' are the ways
-- its arrow may point; nil is any, on the first side with room
--
local function openPopover( button, directions )
	local popover = navCtrl.popoverControl
	popover.arrowDirections = directions
	popover.buttonItem = button
	navCtrl:presentControl{
		onComplete=function()
			print( "Main: presented, its arrow points", popover.arrowDirection )
		end
	}
end


-- the Popover Control tells its delegate about each step
--
local delegate = {
	-- a tap outside the popover: return false to keep it
	shouldDismiss=function( self, popover )
		print( "Delegate: shouldDismiss" )
		return true
	end,
	dismissalEnded=function( self, popover )
		print( "Delegate: dismissalEnded" )
	end,
}


local function newAppButton( text, x, y, directions )
	local button -- forward
	button = dUI.newPushButton{
		labelText=text,
		onRelease=function( event ) openPopover( button, directions ) end,
		style={ width=80 },
	}
	button.x, button.y = x, y
	return button
end



--===================================================================--
--== Main
--===================================================================--


--== The app: a background the size of the screen, three buttons

local o

o = display.newRect( H_CENTER, V_CENTER, SCREEN_W, SCREEN_H )
o:setFillColor( 0.84, 0.9, 0.92 )

o = display.newText{
	text="Press a button to open its popover,\ntap outside the popover to close it.",
	x=H_CENTER, y=SCREEN_Y+SCREEN_H-120,
	width=SCREEN_W-40,
	font=native.systemFont, fontSize=14,
	align='center',
}
o:setFillColor( 0.3, 0.3, 0.3 )

local topButton = newAppButton(
	"Top", SCREEN_X+SCREEN_W-55, SCREEN_Y+STATUS_BAR_H+30
)
local sideButton = newAppButton(
	"Side", SCREEN_X+55, V_CENTER, dUI.ARROW_LEFT
)
local bottomButton = newAppButton(
	"Bottom", H_CENTER, SCREEN_Y+SCREEN_H-40
)


--== The popover: a Navigation Control with a menu

navCtrl = dUI.newNavigationControl{
	modalStyle=dUI.POPOVER, -- << this makes it a popover
	preferredContentSize=POPOVER_SIZE,
}
navCtrl:pushView( newMenuView() )
navCtrl.popoverControl.delegate = delegate


--== Open the popover of "Top" after a second

timer.performWithDelay( 1000, function()
	openPopover( topButton )
end )
