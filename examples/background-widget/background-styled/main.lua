--====================================================================--
-- Background Styled
--
-- Shows styling of the DMC Widget: Background
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2014-2015 David McCuskey. All Rights Reserved.
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

-- handles button-type taps
--
local function widgetEvent_handler( event )
	print( 'Main: widgetEvent_handler', event.type )
	local etype= event.type
	local target=event.target

	if etype==target.PRESSED then
		print( "Background: touch started" )
	elseif etype==target.MOVED then
		print( "Background: moved ", event.isWithinBounds )
	elseif etype==target.RELEASED then
		print( "Background: touch ended" )
	end

end



--===================================================================--
-- Main
--===================================================================--


setupBackground()


--======================================================--
--== create background, default style

function run_example1()

	local bw1

	bw1 = Widgets.newBackground{}
	bw1.x, bw1.y = H_CENTER, V_CENTER-100

	bw1:setViewFillColor( 1, 1, 0 )
	bw1:setViewStrokeColor( 1, 0, 0 )
	bw1.viewStrokeWidth = 5

	timer.performWithDelay( 1000, function()
		bw1.y=100
	end)

end

-- run_example1()


--======================================================--
--== create background rectangle style

function run_example2()

	local st2, bw2

	st2 = Widgets.newBackgroundStyle{
		debugOn=true,

		width = 125,
		height = 50,

		anchorX=0.5,
		anchorY=0.5,
		hitMarginX=0,
		hitMarginY=20,

		view={
			type='rectangle',
			fillColor={ 0,1,0.5,0.5},
			strokeWidth=4,
			strokeColor={ 0,0,0,1 },
		}
	}

	-- apply style to widgete

	bw2 = Widgets.newBackground{
		style=st2
	}

	-- make some updates

	-- bw2.x, bw2.y = H_CENTER-100, V_CENTER+100
	bw2.x, bw2.y = H_CENTER, V_CENTER

	bw2:setAnchor( {1,1})
	bw2.width=124


	-- make more updates after time

	timer.performWithDelay( 1000, function()
		bw2:setAnchor( {0,0} )
		bw2:setAnchor( {0.5,0.5} )
		bw2:setAnchor( {1,1} )
		bw2.viewStrokeWidth = 1
		bw2:setViewFillColor( 1,0,0,1 )
		bw2:setViewStrokeColor( 0,1,0,1 )

		-- bw2.width=100
		-- bw2.height=40

		bw2.x, bw2.y = H_CENTER, V_CENTER

	end)

end

-- run_example2()


--======================================================--
--== create background rounded background style

function run_example3()

	local st2, st3, bw3

	st2 = Widgets.newBackgroundStyle{
		debugOn=true,

		width = 125,
		height = 50,

		hitMarginX=0,
		hitMarginY=20,

		anchorX=1,
		anchorY=1,

		view={
			type='rectangle',
			fillColor={ 0,1,0.5,0.5},
			strokeWidth=4,
			strokeColor={ 0,0,0,1 },
		}
	}

	st3 = Widgets.newBackgroundStyle{
		debugOn=true,

		width = 125,
		height = 50,

		anchorX=1,
		anchorY=1,

		view = {
			type='rounded',
			cornerRadius=4,
			fillColor={ 0,1,0.5,0.5},
			strokeWidth=4,
			strokeColor={ 0,0,0,1 },
		}
	}


	bw3 = Widgets.newBackground{
		style=st3
	}
	-- bw3.x, bw3.y = H_CENTER-100, V_CENTER+100
	bw3.x, bw3.y = H_CENTER, V_CENTER

	-- bw3:setAnchor( {1,1})
	-- bw3.width=124

	transition.to( bw3, {time=5000, x=10})

	timer.performWithDelay( 1000, function()
		bw3:setAnchor( {0,0})
		-- bw3:setAnchor( {0.5,0.5})
		-- bw3:setAnchor( {1,1})
		-- bw3.viewStrokeWidth = 1
		bw3:setViewFillColor( 1,0,0,1)
		bw3:setViewStrokeColor( 0,1,0,1)
		bw3.cornerRadius = 20

		-- bw3.width=100
		-- bw3.height=40

		-- bw3.x, bw3.y = H_CENTER, V_CENTER-100

	end)

	timer.performWithDelay( 1500, function()
		print("\n\nUpdate New Style")
		bw3.style = st2
	end)


	timer.performWithDelay( 3000, function()
		print("\n\nUpdate New Style")
		bw3.style = st3
	end)

end

run_example3()

