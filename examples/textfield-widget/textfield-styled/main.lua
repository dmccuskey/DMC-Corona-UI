--====================================================================--
-- Styled TextField
--
-- Three text fields with their own styles. "Username:" has a pink 9-slice
-- background and an italic purple hint (bold text once there's some); its
-- width animates between 270 and 60, and the background, hint and native
-- field follow. "Email" has a shadowed 9-slice background, the hint on the
-- right, the text on the left and the email keyboard. "Address" uses the
-- default style. Tap one to edit it.
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


local W, H = display.contentWidth, display.contentHeight
local H_CENTER, V_CENTER = W*0.5, H*0.5



--===================================================================--
--== Support Functions


--======================================================--
-- Setup Visual Screen Items

local function setupBackground()
	local width, height = 100, 50
	local o

	o = display.newRect(0,0,W,H)
	o:setFillColor(1,1,1)
	o.x, o.y = H_CENTER, V_CENTER

	o = display.newRect(0,0,width+4,height+4)
	o:setStrokeColor(0,0,0)
	o.strokeWidth=2
	o.x, o.y = H_CENTER, V_CENTER

	o = display.newRect( 0,0,10,10)
	o:setFillColor(1,0,0)
	o.x, o.y = H_CENTER, V_CENTER
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
		transition.to( w1, {time=3000, width=270, onComplete=function() pause(narrow) end } )
	end
	narrow = function()
		transition.to( w1, {time=3000, width=60, onComplete=function() pause(wide) end} )
	end

	narrow()


end

run_example1()
