--====================================================================--
-- Simple Text Button
--
-- Four push buttons that differ in their label, each state styled on its
-- own: "Back" turns red and moves right while pressed; "Middle" has a large
-- hit area (hitMarginX/Y, shown in red by debugOn); "Orange" sits right with
-- an offset and jumps left while pressed (each state's align and offsetX/Y);
-- "Disabled" shows the disabled style and ignores presses. Each press and
-- release prints the button's id.
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2014-2015 David McCuskey. All Rights Reserved.
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
--== Support Functions


local function setupBackground()
	local o = display.newRect( 0, 0, W, H )
	o:setFillColor( 0.5, 0.5, 0.5 )
	o.x, o.y = H_CENTER, V_CENTER
end


local function onPress_handler( event )
	print( 'Main: onPress_handler: id', event.id )
end

local function onRelease_handler( event )
	print( 'Main: onRelease_handler: id', event.id )
end



--===================================================================--
--== Main
--===================================================================--


setupBackground()


--== "Back": the label changes color and alignment while pressed

local bn = dUI.newPushButton{
	id='button-back',
	labelText="Back",
	style={
		width=100,
		height=50,
		marginX=10,
		active={
			align='right',
			label={ textColor={ 1, 0, 0 } },
		},
	},
	onPress=onPress_handler,
	onRelease=onRelease_handler,
}
bn.x, bn.y = H_CENTER, 70


--== "Middle": a hit area larger than the button, shown by debugOn

bn = dUI.newPushButton{
	id='button-middle',
	labelText="Middle",
	style={
		debugOn=true,
		width=152,
		height=50,
		hitMarginX=20,
		hitMarginY=15,
		active={
			label={ textColor={ 1, 0.2, 0 } },
		},
	},
	onPress=onPress_handler,
	onRelease=onRelease_handler,
}
bn.x, bn.y = H_CENTER, 175


--== "Orange": each state has its own alignment and offset

bn = dUI.newPushButton{
	id='button-orange',
	labelText="Orange",
	style={
		width=152,
		height=50,
		marginX=10,
		inactive={
			align='right',
			offsetX=-5,
			offsetY=-3,
			label={ textColor={ 1, 0.2, 0 } },
		},
		active={
			align='left',
			offsetX=10,
			offsetY=0,
			label={ textColor={ 1, 1, 0 } },
		},
	},
	onPress=onPress_handler,
	onRelease=onRelease_handler,
}
bn.x, bn.y = H_CENTER, 280


--== "Disabled": the disabled style; presses are ignored

bn = dUI.newPushButton{
	id='button-disabled',
	labelText="Disabled",
	style={
		width=152,
		height=50,
		disabled={
			label={
				font=native.systemFontBold,
				textColor={ 0.6, 0.6, 0.6 },
			},
		},
	},
	onPress=onPress_handler,
	onRelease=onRelease_handler,
}
bn.x, bn.y = H_CENTER, 385
bn.isEnabled = false
