--====================================================================--
-- ScrollView Simple
--
-- shows basic use of scrollview widget
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2015 David McCuskey. All Rights Reserved.
--====================================================================--



print( '\n\n##############################################\n\n' )



--====================================================================--
--== Imports


local dUI = require 'lib.dmc_ui'



--====================================================================--
--== Setup, Constants


local W, H = dUI.WIDTH, dUI.HEIGHT
local H_CENTER, V_CENTER = W*0.5, H*0.5



--===================================================================--
--== Main
--===================================================================--


local scrollView = dUI.newScrollView{
	width=200,
	height=100,
	scrollWidth=500,
	scrollHeight=400
}
scrollView.x, scrollView.y = H_CENTER/2, V_CENTER/2




