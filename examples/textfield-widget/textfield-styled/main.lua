--====================================================================--
-- Styled TextField
--
-- Three text fields with their own styles. "Username:" has a pink 9-slice
-- background and an italic purple hint (bold text once there's some); its
-- width animates between 270 and 60, and the background, hint and native
-- field follow. "Email" has a shadowed 9-slice background, the hint on the
-- right, the text on the left and the email keyboard. "Address" uses the
-- default style. Tap one to edit it. The line at the bottom says which way
-- "Username:" is going. The backdrop fills the screen on any device.
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2015 David McCuskey. All Rights Reserved.
--====================================================================



print( "\n\n#########################################################\n\n" )



--===================================================================--
--== Imports


local dUI = require 'lib.dmc_ui'



--===================================================================--
--== Setup, Constants


-- the screen, as the device reports it: config.lua asks for 320x480
-- 'letterbox', so a taller or a wider screen has room around the content
local SCREEN_W, SCREEN_H = display.actualContentWidth, display.actualContentHeight
local SCREEN_Y = display.screenOriginY
local H_CENTER, V_CENTER = display.contentCenterX, display.contentCenterY
local STATUS_BAR_H = display.topStatusBarContentHeight

-- the line at the bottom, later
local status = nil



--===================================================================--
--== Support Functions


--======================================================--
-- Setup Visual Screen Items

-- a backdrop the size of the screen, the example's name at the top,
-- a line at the bottom which says what the widget shows (setStatus()),
-- and a marker at the screen's center, a white box with a red dot,
-- which makes a change of the widget's anchor easy to see
--
local function setupBackground()
	local o

	o = display.newRect( H_CENTER, V_CENTER, SCREEN_W, SCREEN_H )
	o:setFillColor( 0.17, 0.24, 0.31 )

	o = display.newText( "Styled TextField", H_CENTER, SCREEN_Y+STATUS_BAR_H+30, native.systemFontBold, 20 )

	status = display.newText( "", H_CENTER, SCREEN_Y+SCREEN_H-30, native.systemFont, 16 )

	o = display.newRect( H_CENTER, V_CENTER, 104, 54 )

	o = display.newRect( H_CENTER, V_CENTER, 10, 10 )
	o:setFillColor( 1, 0, 0 )
end

local function setStatus( text )
	status.text = text
end


--===================================================================--
--== Main
--===================================================================--


setupBackground()



--======================================================--
--== create textfield widgets, three styles

function run_example1()

	local w1, w2, w3


	w1 = dUI.newTextField{
		text="",
		hintText="Username:",
		style = {
			width=270,
			height=40,
			marginX=10,
			align='left',
			background={
				type='9-slice',
				view={
					sheetInfo='asset.textfield-pink-sheet',
					sheetImage='asset/textfield-pink-sheet.png',
				}
			},
			hint={
				font='Optima-Italic',
				fontSize=16,
				textColor='#663366',
			},
			display={
				font='Optima-Bold',
				fontSize=16,
				textColor='#663366',
			}

		}
	}
	w1.x, w1.y = H_CENTER, V_CENTER-150

	w2 = dUI.newTextField{
		text="",
		hintText="Email",
		style = {
			width=280,
			marginX=15,
			height=45,
			align='left',
			inputType='email',
			background={
				type='9-slice',
				view={
					sheetInfo='asset.textfield-nice-sheet',
					sheetImage='asset/textfield-nice-sheet.png',
				}
			},
			hint={
				align='right',
				fontSize=16,
				textColor='#999999',
			},
			display={
				align='left',
				fontSize=16,
				textColor='#444444',
			}
		}
	}
	w2.x, w2.y = H_CENTER, V_CENTER-90


	w3 = dUI.newTextField{
		text="",
		hintText="Address",
	}
	w3.x, w3.y = H_CENTER, V_CENTER



	local narrow, wide, pause

	pause = function( f )
		timer.performWithDelay( 1000, f )
	end

	wide = function()
		setStatus( "Username: widening to 270" )
		transition.to( w1, {time=3000, width=270, onComplete=function() pause(narrow) end } )
	end
	narrow = function()
		setStatus( "Username: narrowing to 60" )
		transition.to( w1, {time=3000, width=60, onComplete=function() pause(wide) end} )
	end

	narrow()


end

run_example1()
