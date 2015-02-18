--====================================================================--
-- Themed Background
--
-- Shows themed use of the DMC Widget: Background
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2015 David McCuskey. All Rights Reserved.
--====================================================================--



print( "\n\n#########################################################\n\n" )



--===================================================================--
--== Imports


local Widgets = require 'lib.dmc_widgets'



--===================================================================--
--== Setup, Constants


local W, H = display.contentWidth, display.contentHeight
local H_CENTER, V_CENTER = W*0.5, H*0.5



--===================================================================--
-- Support Functions


-- Setup Visual Screen Items
--
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


local function widgetOnPropertyEvent_handler( event )
	print( 'Main: widgetOnPropertyEvent_handler', event.id, event.phase )
	local etype= event.type
	local property= event.property
	local value = event.value

	print( "Widget Property Changed", etype, property, value )

end

local function widgetEvent_handler( event )
	print( 'Main: widgetEvent_handler', event.id, event.phase )
	local etype= event.type

	print( "Widget Event", etype )

end



--===================================================================--
--== Main
--===================================================================--


setupBackground()



--======================================================--
--== create widget, default style

function run_example1()

	local txt1

	txt1 = Widgets.newText{}
	txt1.text = "default style"
	txt1.x, txt1.y = H_CENTER, 100

end

run_example1()


--======================================================--
--== Create Widget, inline style

function run_example2()

	local txt2

	txt2 = Widgets.newText{
		text="inline style",

		style={
			width=225,
			height=35,

			align='right',
			fontSize=26,
			marginX=5,
			fillColor={0.5,0,0.25},
			textColor={1,0,0},
		}
	}

	txt2.x = H_CENTER
	txt2.y = V_CENTER

	txt2.align='left'
	txt2.align='center'
	-- txt2.align='right'

	txt2:setAnchor( {0,0} )
	txt2:setAnchor( {0.5,0.5} )
	-- txt2:setAnchor( {1,1} )


	timer.performWithDelay( 1000, function()
		txt2.style=nil -- clear style, to default
	end)


	timer.performWithDelay( 2000, function()
		print( "\n\nUpdate properties" )

		transition.to( txt2, {time=5000, x=100, y=400})

		txt2.text="hamburger"

		txt2.width=300
		txt2.height=70

		txt2.align='right'

		txt2:setAnchor( {1,1} )

		txt2:setFillColor( 1,0,0,0.5 )
		txt2:setTextColor( 1,0,0,0.5 )

		txt2.font = native.systemFontBold

		txt2:setStrokeColor( 0,0,0,0.5 )
		txt2.strokeWidth = 4

		txt2.fontSize = 18
		txt2.marginX = 15
		txt2.marginY = 15

	end)

	timer.performWithDelay( 3000, function()
		print( "\n\nUpdate properties" )

		-- txt2.x=100

		txt2.text="pizza"

		txt2.width=nil
		txt2.height=nil

		txt2.align='center'
		-- txt2:setAnchor( {0.5,0.5} )

		txt2.strokeWidth = 2
		txt2:setStrokeColor( 1,0,0,1 )

		txt2.font = native.systemFontBold
		txt2.fontSize = 30

		txt2:setFillColor( 0,0,0.5,0.8 )
		txt2:setTextColor( 1,0,1,0.5 )

	end)


end

-- run_example2()



--======================================================--
--== create style, apply to widget

function run_example3()

	local st1, txt3, txt4

	st3 = Widgets.newTextStyle{
		name='my-text-style',
		fillColor={0.5,0.8,0.2},
		marginX=5,
		marginY=10,
		textColor={0,0,0},
	}

	txt3 = Widgets.newText{
		text="Text One"
	}
	txt3.style = st3
	txt3.x, txt3.y = H_CENTER, V_CENTER-100


	-- add another text widget, with same style

	timer.performWithDelay( 1500, function()
		print( "\n\nUpdate Properties" )

		txt4 = Widgets.newText{
			text="Text Two",
			style=st3
		}
		txt4.x=H_CENTER
		txt4.y=V_CENTER+100

	end)

	-- change some styles on one widget

	timer.performWithDelay( 3000, function()
		print( "\n\nUpdate Properties" )

		txt3:setFillColor( 1,0.5,0.5,0.5 )
		txt3:setTextColor( 1,0,0,0.5 )
		txt3.align='left'
		txt3.width=200

		txt3:setTextColor( 0.5,0.2,0,0.5 )

		-- st3:setFillColor(1,0,0)

	end)


	-- then reset both to original look

	timer.performWithDelay( 4500, function()
		print( "\n\nUpdate Properties" )

		txt3:clearStyle()
		txt4:clearStyle()
	end)


	-- remove a widget

	timer.performWithDelay( 10000, function()
		print( "\n\nRemoving Widget" )
		txt3:removeSelf()
	end)

end

-- run_example3()
