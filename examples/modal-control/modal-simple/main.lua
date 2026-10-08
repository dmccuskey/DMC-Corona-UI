--====================================================================--
-- Modal Simple
--
-- A control shown as a page over the app (modalStyle = dUI.MODAL),
-- on any device. The app is a screen with two buttons; each presents
-- a Navigation Control whose bar has a "Close" button.
--
-- "Open Page" shows the control the size of the screen below the
-- status bar: it slides up from the bottom, and slides back down on
-- "Close". "Open Panel" shows a control with a 'preferredContentSize'
-- as a panel in the middle of the dimmed app: it fades in
-- (transition = dUI.FADE), and a tap outside it closes it too
-- (dismissOnTapOutside). While either shows, the app's buttons
-- behind it get no touches. The app opens the page by itself after
-- a second.
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
local SCREEN_Y = display.screenOriginY
local H_CENTER, V_CENTER = display.contentCenterX, display.contentCenterY
local STATUS_BAR_H = display.topStatusBarContentHeight

local PANEL_SIZE = { width=260, height=300 }

local page, panel = nil, nil -- the two controls, later



--====================================================================--
--== Support Functions


-- make a Navigation Control to be presented, with one view.
-- its bar gets a "Close" button, which dismisses the control
--
local function newModalControl( params )

	local ctrl = dUI.newNavigationControl{
		modalStyle=dUI.MODAL, -- << this makes it a page over the app
		preferredContentSize=params.size, -- nil: the screen below the status bar
	}

	-- the control has its presented size already: lay the view out
	-- for the room below the bar, from its top center

	local w, h = ctrl.width, ctrl.height - ctrl.navBar.height
	local dg = display.newGroup()
	local o

	o = display.newRect( 0, 0, w, h )
	o.anchorY = 0
	o:setFillColor( unpack( params.color ) )
	dg:insert( o )

	o = display.newText{
		text=params.text,
		x=0, y=h*0.5,
		width=w-40,
		font=native.systemFont, fontSize=14,
		align='center',
	}
	dg:insert( o )

	ctrl:pushView{
		view=dg,
		navItem=dUI.newNavItem{
			titleText=params.title,
			rightButton=dUI.newButton{
				labelText="Close",
				onRelease=function( event )
					ctrl:dismissControl{
						onComplete=function() print( "Main: dismissed:", params.title ) end
					}
				end,
			},
		},
	}

	return ctrl
end


-- the Presentation Control tells its delegate about each step
--
local delegate = {
	presentationWillBegin=function( self, presentation )
		print( "Delegate: presentationWillBegin" )
	end,
	presentationEnded=function( self, presentation )
		print( "Delegate: presentationEnded" )
	end,
	-- a tap outside the panel: return false to keep it
	shouldDismiss=function( self, presentation )
		print( "Delegate: shouldDismiss" )
		return true
	end,
	dismissalWillBegin=function( self, presentation )
		print( "Delegate: dismissalWillBegin" )
	end,
	dismissalEnded=function( self, presentation )
		print( "Delegate: dismissalEnded" )
	end,
}


local function openPage()
	-- slides up, the default
	page:presentControl{
		onComplete=function() print( "Main: presented: Page" ) end
	}
end

local function openPanel()
	panel:presentControl{
		transition=dUI.FADE,
		onComplete=function() print( "Main: presented: Panel" ) end
	}
end



--===================================================================--
--== Main
--===================================================================--


--== The app: a background the size of the screen, a title at
--== the top and two buttons at the bottom

local o

o = display.newRect( H_CENTER, V_CENTER, SCREEN_W, SCREEN_H )
o:setFillColor( 0.92, 0.9, 0.84 )

o = display.newText{
	text="The app",
	x=H_CENTER, y=SCREEN_Y+STATUS_BAR_H+40,
	font=native.systemFontBold, fontSize=20,
}
o:setFillColor( 0.3, 0.3, 0.3 )

o = dUI.newPushButton{
	labelText="Open Page",
	onRelease=openPage,
	style={ width=160 },
}
o.x, o.y = H_CENTER, SCREEN_Y+SCREEN_H-100

o = dUI.newPushButton{
	labelText="Open Panel",
	onRelease=openPanel,
	style={ width=160 },
}
o.x, o.y = H_CENTER, SCREEN_Y+SCREEN_H-50


--== The page: all of the screen below the status bar

page = newModalControl{
	title="Page",
	text="A page over the app.\n\n\"Close\" slides it back down.",
	color={ 0.3, 0.4, 0.5 },
}
page.presentationControl.delegate = delegate


--== The panel: its preferred size, in the middle of the dimmed app

panel = newModalControl{
	title="Panel",
	text="A panel over the app.\n\n\"Close\" or a tap outside closes it.",
	color={ 0.5, 0.4, 0.3 },
	size=PANEL_SIZE,
}
panel.presentationControl.delegate = delegate
panel.presentationControl.dismissOnTapOutside = true


--== Open the page after a second

timer.performWithDelay( 1000, openPage )
