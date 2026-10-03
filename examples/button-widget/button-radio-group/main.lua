--====================================================================--
-- Radio Group Simple
--
-- Two button groups. The top row is a radio group: one of "Small",
-- "Medium" and "Large" is always active (the first to start with), and a
-- press makes another one active. The bottom row is a toggle group: at most
-- one of "Left" and "Right" is active, and pressing the active one turns it
-- off. The line at the bottom shows the selection, updated from each
-- group's change event (also printed).
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

-- one look for every button here: green while active
local buttonStyle = dUI.newButtonStyle{
	width=90,
	height=50,
	inactive={
		label={ textColor={ 0.2, 0.2, 0.2 } },
	},
	active={
		label={ textColor={ 1, 1, 1 } },
		background={
			type='rounded',
			view={
				cornerRadius=9,
				fillColor={ 0.2, 0.6, 0.2 },
				strokeWidth=2,
				strokeColor={ 0.1, 0.3, 0.1 },
			}
		},
	},
}

local radioGroup, toggleGroup, status



--===================================================================--
--== Support Functions


local function setupBackground()
	local o = display.newRect( 0, 0, W, H )
	o:setFillColor( 0.5, 0.5, 0.5 )
	o.x, o.y = H_CENTER, V_CENTER
end


local function updateStatus()
	local radio = radioGroup.selected
	local toggle = toggleGroup.selected
	status.text = "size: "..( radio and radio.labelText or "none" )
		.."   side: "..( toggle and toggle.labelText or "none" )
end


local function groupEvent_handler( event )
	print( 'Main: groupEvent_handler', event.type, event.id, event.state )
	updateStatus()
end


local function newRow( group, action, labels, y )
	local x = H_CENTER - ( #labels-1 )*50
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
newRow( radioGroup, 'radio', { "Small", "Medium", "Large" }, 120 )

-- toggle group: at most one button active
toggleGroup = dUI.newButtonGroup{ type='toggle' }
toggleGroup:addEventListener( toggleGroup.EVENT, groupEvent_handler )
newRow( toggleGroup, 'toggle', { "Left", "Right" }, 220 )

status = dUI.newText{
	text="",
	style={ fontSize=16, textColor={ 1, 1, 1 } },
}
status.x, status.y = H_CENTER, 320

updateStatus()
