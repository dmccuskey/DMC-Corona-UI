--====================================================================--
-- Simple 9-Slice Button
--
-- Shows basic use of the DMC Widget: Button
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2015 David McCuskey. All Rights Reserved.
--====================================================================--



print( "\n\n#########################################################\n\n" )



--===================================================================--
--== Imports


local dUI = require 'lib.dmc_ui'



--===================================================================--
--== Setup, Constants


local W, H = display.contentWidth, display.contentHeight
local H_CENTER, V_CENTER = W*0.5, H*0.5



--===================================================================--
-- Support Functions


--======================================================--
-- Setup Visual Screen Items

local function setupBackground()
	local width, height = 100, 50
	local o

	o = display.newRect(0,0,W,H)
	o:setFillColor(0.5,0.5,0.5)
	o.x, o.y = H_CENTER, V_CENTER

	o = display.newRect(0,0,width+4,height+4)
	o:setStrokeColor(0,0,0)
	o.strokeWidth=2
	o.x, o.y = H_CENTER, V_CENTER

	o = display.newRect( 0,0,10,10)
	o:setFillColor(1,0,0)
	o.x, o.y = H_CENTER, V_CENTER
end


--======================================================--
-- Button Handlers

local function onPress_handler( event )
	print( 'Main: onPress_handler: id', event.id )
end

local function onRelease_handler( event )
	print( 'Main: onRelease_handler: id', event.id )
end

local function onEvent_handler( event )
	print( 'Main: onEvent_handler: id', event.id, event.phase )
end



--===================================================================--
--== Main
--===================================================================--


setupBackground()



--======================================================--
--== create background, default style

function run_example1a()

	local bw1

	bw1 = dUI.newPushButton{

		id='9-slice-button',
		labelText="Press",

		data="your data",
		onPress=onPress_handler,

		style={
			anchorX=0.5,
			anchorY=1,
			hitMarginX=10,
			hitMarginY=10,

			inactive = {
				background = {
					type=dUI.NINE_SLICE,
					view = {
						sheetInfo='asset.image.cloud_button.button-sheet',
						sheetImage='asset/image/cloud_button/button-sheet.png',
						offsetLeft=8,
						offsetRight=7,
						offsetTop=4,
						offsetBottom=12,
					}
				}
			}
		}
	}
	bw1.width, bw1.height = 200, 100
	bw1.x, bw1.y = H_CENTER, V_CENTER+0

	-- timer.performWithDelay( 1000, function()
	-- 	bw1.width=100
	-- 	bw1.anchorX=1
	-- end)

end

-- run_example1a()




--======================================================--
--== create 9slice example, width move

function run_example2()

	local bw1

	bw1 = dUI.newPushButton{

		id='9-slice-button',
		labelText="Press Here for Fun",

		data="your data",
		onPress=onPress_handler,

		style={
			anchorX=0.5,
			anchorY=1,
			hitMarginX=10,
			hitMarginY=10,
			marginX=10,

			inactive = {
				background = {
					type=dUI.NINE_SLICE,
					view = {
						sheetInfo='asset.image.cloud_button.button-sheet',
						sheetImage='asset/image/cloud_button/button-sheet.png',
						offsetLeft=8,
						offsetRight=7,
						offsetTop=4,
						offsetBottom=12,
					}
				}
			}
		}
	}
	bw1.width, bw1.height = 200, 100
	bw1.x, bw1.y = H_CENTER, V_CENTER+0

	local narrow, wide

	wide = function()
		transition.to( bw1, {time=2000, width=225, height=100, onComplete=narrow} )
	end
	narrow = function()
		transition.to( bw1, {time=2000, width=60, height=40, onComplete=wide} )
	end

	narrow()

end

run_example2()


