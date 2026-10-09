--====================================================================--
-- Radio Group Simple
--
-- Two button groups. The top row is a radio group: one of "Small",
-- "Medium" and "Large" is always active (the first to start with), and a
-- press makes another one active. The bottom row is a toggle group: at most
-- one of "Left" and "Right" is active, and pressing the active one turns it
-- off. A caption above each row says how its group behaves. The line at
-- the bottom shows the selection, updated from each group's change event
-- (also printed). The active look is from dUI.Palette. The backdrop fills
-- the screen on any device.
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


-- the screen, as the device reports it: config.lua asks for 320x480
-- 'letterbox', so a taller or a wider screen has room around the content
local SCREEN_W, SCREEN_H = display.actualContentWidth, display.actualContentHeight
local SCREEN_Y = display.screenOriginY
local H_CENTER, V_CENTER = display.contentCenterX, display.contentCenterY
local STATUS_BAR_H = display.topStatusBarContentHeight

-- the line at the bottom, later
local status = nil

-- one look for every button here: green while active
local buttonStyle = dUI.newButtonStyle{
	width=90,
	height=50,
	active={
		label={ textColor={ 1, 1, 1 } },
		background={
			type='rounded',
			view={
				cornerRadius=8,
				fillColor=dUI.Palette.green,
				strokeWidth=1,
				strokeColor=dUI.Palette.greenDark,
			}
		},
	},
}

local radioGroup, toggleGroup



--===================================================================--
--== Support Functions


-- a backdrop the size of the screen, the example's name at the top,
-- and a line at the bottom which says what the widgets show (setStatus())
--
local function setupBackground()
	local o

	o = display.newRect( H_CENTER, V_CENTER, SCREEN_W, SCREEN_H )
	o:setFillColor( 0.17, 0.24, 0.31 )

	o = display.newText( "Radio Group Simple", H_CENTER, SCREEN_Y+STATUS_BAR_H+30, native.systemFontBold, 20 )

	status = display.newText( "", H_CENTER, SCREEN_Y+SCREEN_H-30, native.systemFont, 16 )
end

local function setStatus( text )
	status.text = text
end


local function updateStatus()
	local radio = radioGroup.selected
	local toggle = toggleGroup.selected
	setStatus( "size: "..( radio and radio.labelText or "none" )
		.."   side: "..( toggle and toggle.labelText or "none" ) )
end


local function groupEvent_handler( event )
	print( 'Main: groupEvent_handler', event.type, event.id, event.state )
	updateStatus()
end


-- a row of buttons in a group, under a caption which says how it behaves
--
local function newRow( group, action, caption, labels, y )
	local x = H_CENTER - ( #labels-1 )*50
	display.newText( caption, H_CENTER, y-42, native.systemFont, 15 )
	for i, label in ipairs( labels ) do
		local bn = dUI.newButton{
			action=action,
			id=string.lower( label ),
			labelText=label,
			style=buttonStyle,
		}
		bn.x, bn.y = x+( i-1 )*100, y
		group:add( bn )
	end
end



--===================================================================--
--== Main
--===================================================================--


setupBackground()

-- radio group: one button always active
radioGroup = dUI.newButtonGroup{ type='radio' }
radioGroup:addEventListener( radioGroup.EVENT, groupEvent_handler )
newRow( radioGroup, 'radio', "Radio group: one is always active",
	{ "Small", "Medium", "Large" }, V_CENTER-45 )

-- toggle group: at most one button active
toggleGroup = dUI.newButtonGroup{ type='toggle' }
toggleGroup:addEventListener( toggleGroup.EVENT, groupEvent_handler )
newRow( toggleGroup, 'toggle', "Toggle group: press again to turn it off",
	{ "Left", "Right" }, V_CENTER+70 )

updateStatus()
