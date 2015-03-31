--====================================================================--
-- dmc_ui/ui_constants.lua
--
-- Documentation: http://docs.davidmccuskey.com/
--====================================================================--

--[[

The MIT License (MIT)

Copyright (c) 2015 David McCuskey

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

--]]



--====================================================================--
--== DMC Corona UI : UI Consstants
--====================================================================--


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.1.0"



--====================================================================--
--== DMC Corona UI : Module Constants
--====================================================================--



--====================================================================--
--== Setup, Constants


local PLATFORM = system.getInfo( 'platformName' )



--====================================================================--
--== Constants
--====================================================================--


local Constant = {}



--====================================================================--
--== Module


Constant.RUN_MODE = 'run'
Constant.TEST_MODE = 'test'



--====================================================================--
--== Platform & OS


Constant.ANDROID = 'Android'
Constant.ANDROID_20 = "2.0.0"
Constant.ANDROID_21 = "2.1.0"

Constant.IOS = 'iOS'
Constant.IOS_7x = "7.0.0"
Constant.IOS_8x = "8.0.0"

Constant.WINDOWS = 'WinPhone'

Constant.IS_IOS = ( PLATFORM=='iPhone OS' or PLATFORM=='Mac OS X' )
Constant.IS_ANDROID = ( PLATFORM=='Android' )
Constant.IS_WINDOWS = ( PLATFORM=='WinPhone' )
Constant.IS_SIMULATOR = ( PLATFORM=='Mac OS X' or PLATFORM=='Win' )

Constant.ANDROID_KEYBOARD = 80
Constant.IOS_KEYBOARD = 80

function Constant.getKeyboardHeight()
	if Constant.IS_IOS then
		return Constant.IOS_KEYBOARD
	else
		return Constant.ANDROID_KEYBOARD
	end
end

function Constant.getSystemSeparator()
	if Constant.IS_IOS then
		return '/'
	else
		return '\\'
	end
end


--====================================================================--
--== Views


Constant.VIEW_LAYOUT_MARGINS = {top=8,left=8,bottom=8,right=8}



--====================================================================--
--== Widgets & Styles


Constant.BACKGROUND = 'Background'
Constant.BUTTON = 'Button'
Constant.BUTTON_STATE = 'Button-State'
Constant.NAVITEM = 'NavItem'
Constant.NAVBAR = 'NavBar'
Constant.SCROLLVIEW = 'ScrollView'
Constant.TABLEVIEW = 'TableView'
Constant.TABLEVIEWCELL = 'TableViewCell'
Constant.TABLEVIEWCELL_STATE = 'TableViewCell-State'
Constant.TEXT = 'Text'
Constant.TEXTFIELD = 'TextField'

-- View Types

Constant.ROUNDED = 'rounded'
Constant.RECTANGLE = 'rectangle'



--====================================================================--
--== Controls


-- Transition Times

Constant.NAVBAR_TRANSITION_TIME = 400
Constant.PRESENT_CONTROL_TRANSITION_TIME = 100

-- Modal Types

Constant.POPOVER = 'popover'
Constant.POPOVER_PREFERRED_SIZE = {width=320,height=600}



return Constant
