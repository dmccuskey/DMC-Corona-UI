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


local dUI = require 'lib.dmc_ui'



--===================================================================--
--== Setup, Constants


local W, H = display.contentWidth, display.contentHeight
local H_CENTER, V_CENTER = W*0.5, H*0.5



--===================================================================--
--== Support Functions


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
--== create textfield widget, default style

function run_example1()

	local bw1

	tf1 = dUI.newTextField{
		text="",
		hintText="Pizza Topping:"
	}
	-- tf1:addEventListener( tf1.EVENT, widgetEvent_handler )
	-- tf1.onProperty = widgetOnPropertyEvent_handler
	tf1.debugOn = true
	tf1.x = H_CENTER
	tf1.y = V_CENTER

	tf1:setAnchor( {0,0} )
	tf1:setAnchor( {0.5,0.5} )
	-- tf1:setAnchor( {1,1} )

	-- tf1.y = 300

	tf1.width=300
	tf1.height=60
	tf1.align='left'
	tf1.marginX=10
	tf1.hintFontSize=18
	tf1:setBackgroundFillColor( 1,0.5,0.2,1 )

	-- tf1.isSecure=true
	-- tf1.isHitActive=true

	timer.performWithDelay( 1000, function()
		print("\n\n Update Properties")
		-- test background props

		-- tf1.x = H_CENTER-50
		-- tf1.y = V_CENTER+100

		-- tf1.isSecure=false

		tf1.align='center'
		tf1.text="hello"
		-- tf1.marginX=10

		-- tf1.width=200
		-- tf1.height=100

		-- -- tf1.isHitActive=false

		-- tf1:setHintTextColor( 1,1,0 )
		-- tf1.hintFontSize = 18

		-- tf1:setAnchor( {0,0} )

		-- tf1:setBackgroundStrokeColor( 0.2,0.2,0.9,0.5 )
		-- tf1:setBackgroundFillColor( 0.2,0.2,0.2,0.2 )
		-- tf1.backgroundStrokeWidth = 10

		-- tf1:setBackgroundStrokeColor( 0.2,0.2,0.9,0.5 )
		-- tf1:setBackgroundFillColor( 0.2,0.2,0.2,0.2 )
		-- tf1.backgroundStrokeWidth = 10

		-- tf1.hintFont = native.systemFontBold
		-- tf1.hintFontSize = 30
		-- tf1:setHintTextColor(1,0,0,1)

		-- tf1.displayFont = native.systemFontBold
		-- tf1.displayFontSize = 30
		-- tf1:setDisplayTextColor(1,0,0,1)

	end)

	timer.performWithDelay( 2000, function()
		print("\n\n Update Properties")
		-- test background props
		-- tf1.width=100
		-- tf1.height=80
		-- tf1.x = 100

		-- tf1.isSecure=true

		-- tf1.x = H_CENTER+50
		-- tf1.y = V_CENTER+50

		-- tf1.isHitActive=false

	end)

end

run_example1()




--======================================================--
--== create textfield widget, default style


function run_example2()


	-- timer.performWithDelay( 2000, function()
	-- 	print("\n\n Update Properties")
	-- 	-- test hint-text props

	-- 	tf1.x = H_CENTER
	-- 	tf1.y = V_CENTER

	-- 	-- testing hint properties
	-- 	tf1.text=""

	-- 	tf1.align='right'

	-- 	-- tf1.marginX=5
	-- 	-- tf1.marginY=10

	-- 	-- tf1.width=200
	-- 	-- tf1.height=60

	-- 	-- tf1:setAnchor( {0,0} )
	-- 	-- tf1:setAnchor( {0,1} )
	-- 	-- tf1:setAnchor( {1,1} )

	-- 	tf1.hintFont = native.systemFontBold
	-- 	tf1.hintFontSize = 50
	-- 	tf1:setHintColor( 0.5,0.5,0.5, 1)

	-- end)


	-- tf1.text="hamburger"


	-- timer.performWithDelay( 1000, function()
	-- 	print("\n\n Update Properties")
	-- 	-- test hint-text props

	-- 	tf1.x = H_CENTER
	-- 	tf1.y = V_CENTER

	-- 	-- testing text properties

	-- 	tf1.align='right'

	-- 	tf1.marginX=5
	-- 	tf1.marginY=10

	-- 	tf1.width=200
	-- 	tf1.height=60

	-- 	tf1:setAnchor( {0,0} )
	-- 	-- tf1:setAnchor( {0,1} )
	-- 	-- tf1:setAnchor( {1,1} )

	-- 		tf1:setBackgroundFillColor( 1,0.5,0.2,0.5 )
	-- 		tf1:setBackgroundStrokeColor( 2,0,0,1 )
	-- 		tf1.backgroundStrokeWidth = 1

	-- 	tf1.textFont = native.systemFontBold
	-- 	tf1.textFontSize = 20
	-- 	tf1:setTextColor( 0.5,0.5,0.5, 1)

	-- end)


end

-- run_example2()



function run_example3()



-- tf1.text="hamburger"
-- tf1:_startEdit()
-- tf1:setAnchor( {0,0} )
-- tf1:setAnchor( {0.5,0.5} )
-- tf1:setAnchor( {1,1} )

-- timer.performWithDelay( 1000, function()
-- 	print("\n\n Update Properties")
-- 	-- test input-text props

-- 	-- tf1.x = H_CENTER
-- 	-- tf1.y = V_CENTER

-- 	-- testing text properties

-- 	-- tf1.text="hotdog"
-- 	tf1.align='center'

-- 	-- tf1.marginX=5
-- 	-- tf1.marginY=10

-- 	-- tf1.width=200
-- 	-- tf1.height=60

-- 	-- tf1:setAnchor( {0,0} )
-- 	-- tf1:setAnchor( {0,1} )
-- 	tf1:setAnchor( {1,1} )

-- 	tf1:setBackgroundFillColor( 1,0.5,0.2,0.5 )
-- 		-- tf1:setBackgroundStrokeColor( 2,0,0,1 )
-- 		-- tf1.backgroundStrokeWidth = 1

-- 	tf1.textFont = native.systemFontBold
-- 	tf1.textFontSize = 24
-- 	tf1:setTextColor( 1,0.5,0.5, 1)


-- end)


-- timer.performWithDelay( 3000, function()
-- 	-- tf1.style=nil -- shouldn't change, already default
-- end)



end

-- run_example3()



--======================================================--
--== create textfield widget, zipcode formatter

-- create formatter



function run_example4()


-- formatter = dUI.newFormatter( dUI.Formatter.US_ZIPCODE )

-- style = dUI.newTextFieldStyle{
-- 	name="text-field-default",
-- 	width=200,
-- 	height=40,
-- }

-- -- create text field

-- textfield = dUI.newTextField{

-- 	text="",
-- 	hintText = "Zipcode",
-- 	style=nil,
-- 	formatter=formatter
-- }

-- -- textfield.formatter = formatter
-- textfield.x = H_CENTER
-- textfield.y = V_CENTER


-- --== Main Text Field Tests

-- if true then
-- 	timer.performWithDelay( 1000, function()
-- 		print("\n\n\n UPDATED")

-- 		-- textfield.x = 100
-- 		-- textfield.y = 350

-- 		-- textfield.y = 350

-- 		textfield:setAnchor( {0,0} )
-- 		-- textfield:setAnchor( {0.5,0.5} )
-- 		-- textfield:setAnchor( {1,1} )

-- 		-- textfield.width = 300
-- 		-- textfield.height = 100

-- 		-- textfield.align = 'left'
-- 		-- textfield.align = 'center'
-- 		-- textfield.align = 'right'

-- 		-- textfield.marginX = 10
-- 		-- textfield.marginY = 10

-- 		textfield.text = "331122" -- ok

-- 		-- textfield:setEditActive( true )

-- 	end)
-- end


-- --== Background Tests

-- if false then
-- 	timer.performWithDelay( 1000, function()
-- 		textfield.y = V_CENTER-100
-- 		print("\n\n\n UPDATED")
-- 		-- textfield.backgroundStrokeWidth = 6
-- 		-- textfield:setBackgroundFillColor( 0,0.5,1,1)
-- 		-- textfield:setBackgroundStrokeColor( 0,0,1,1)

-- 		-- textfield.width = 400
-- 		-- textfield.height = 200

-- 		-- !!! no text to test hint !!!
-- 		textfield.text = ""
-- 		textfield.hintText = "zebra"
-- 		textfield.align = 'right'
-- 		textfield.hintFont = native.systemFontBold
-- 		textfield.hintFontSize = 40
-- 		textfield:setHintColor( 0.5,0.5,0.5,1)

-- 		-- textfield.text = "89122"
-- 		-- textfield.textFont = native.systemFontBold
-- 		-- textfield.textFontSize = 30
-- 		-- textfield:setTextColor( 0.5,0.5,0.5,1)

-- 		-- textfield:setEditActive( true )

-- 		-- textfield:setTextColor( 0.5, 0.2, 0.1 )
-- 		-- textfield.hintFontSize = 40
-- 	end)
-- end

-- if false then
-- 	timer.performWithDelay( 1000, function()
-- 		textfield.y = V_CENTER-100
-- 		print("\n\n\n UPDATED")
-- 		-- textfield.backgroundStrokeWidth = 6
-- 		-- textfield:setBackgroundFillColor( 0,0.5,1,1)
-- 		-- textfield:setBackgroundStrokeColor( 0,0,1,1)

-- 		-- textfield.width = 400
-- 		-- textfield.height = 200

-- 		-- !!! no text to test hint !!!
-- 		textfield.text = ""
-- 		textfield.hintText = "zebra"
-- 		textfield.align = 'right'
-- 		textfield.hintFont = native.systemFontBold
-- 		textfield.hintFontSize = 40
-- 		textfield:setHintColor( 0.5,0.5,0.5,1)

-- 		-- textfield.text = "89122"
-- 		-- textfield.textFont = native.systemFontBold
-- 		-- textfield.textFontSize = 30
-- 		-- textfield:setTextColor( 0.5,0.5,0.5,1)

-- 		-- textfield:setEditActive( true )

-- 		-- textfield:setTextColor( 0.5, 0.2, 0.1 )
-- 		-- textfield.hintFontSize = 40
-- 	end)
-- end


-- textfield.onEvent = textFieldOnEvent_handler
-- textfield:addEventListener( textfield.EVENT, textFieldOnEvent_handler )

-- timer.performWithDelay( 1, function() textfield.width( 0.5, 0.2, 0.1 ) end)

-- create a theme

-- textfield.x = H_CENTER
-- textfield.y = V_CENTER

-- textfield:setAnchor( {0,0} )
-- textfield:setAnchor( {0.5,0.5} )
-- textfield:setAnchor( {1,1} )

-- --== APIT

-- textfield.x = 200
-- textfield.y = 200
-- textfield.width = 150
-- textfield.height = 75

-- textfield.align = 'center'
-- textfield.anchorX = 0.5
-- textfield.anchorY = 0.5
-- textfield.backgroundStyle = 'none'
-- textfield.inputType = 'password'
-- textfield.marginX = 10
-- textfield.marginY = 10
-- textfield.returnKey = 'done'

-- textfield.backgroundStrokeWidth = 4
-- textfield:setBackgroundStrokeColor( 1,0,1)
-- textfield:setBackgroundFillColor( 1,0,1)

-- textfield.hintFont = native.systemFont
-- textfield.hintFontSize = 30
-- textfield:setHintColor( 0,1,1)

-- textfield.textFont = native.systemFont
-- textfield.textFontSize = 40
-- textfield:setTextColor( 1,1,0)


-- theme = dUI.newTextFieldTheme{
-- 	placeholder={
-- 		font=
-- 		fontSize=
-- 		color
-- 	},
-- 	text={
-- 		font=
-- 		fontSize=
-- 		color
-- 	},

-- }

-- theme.default.width
-- theme.default.placeholder.font
-- theme = dUI.newTheme( 'textfield' )

-- theme.

end

-- run_example4()

