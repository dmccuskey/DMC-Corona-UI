--====================================================================--
-- Unit Tests for DMC-Widgets
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2014-2015 David McCuskey. All Rights Reserved.
--====================================================================--



print( '\n\n##############################################\n\n' )



--====================================================================--
--== Imports


require 'tests.lunatest'



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


setupBackground()


--====================================================================--
--== Setup test suites and run


-- Styles with no children

lunatest.suite( 'tests.text_style_spec' )
lunatest.suite( 'tests.rectangle_view_style_spec' )
lunatest.suite( 'tests.rounded_view_style_spec' )

-- Styles with children

lunatest.suite( 'tests.background_style_spec' )
lunatest.suite( 'tests.button_style_spec' )
lunatest.suite( 'tests.textfield_style_spec' )

-- managers

lunatest.suite( 'tests.style_mgr_spec' )


lunatest.run({
	-- verbose=true,
	-- suite='style_mgr_spec',
	 -- test='test_addStyleToWidget'
	-- test='test_clearProperties'
})

