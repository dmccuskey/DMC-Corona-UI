--====================================================================--
-- dmc_widgets/widget_navitem.lua
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
--== DMC Corona Widgets : Widget Nav Item
--====================================================================--


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.1.0"



--====================================================================--
--== DMC Widgets Setup
--====================================================================--


local dmc_widget_data, dmc_widget_func
dmc_widget_data = _G.__dmc_widget
dmc_widget_func = dmc_widget_data.func



--====================================================================--
--== DMC Widgets : newNavItem
--====================================================================--



--====================================================================--
--== Imports


local Objects = require 'dmc_objects'

--== To be set in initialize()
local Widgets = nil
local ThemeMgr = nil
local NavBar = nil
local Button = nil


--====================================================================--
--== Setup, Constants


-- setup some aliases to make code cleaner
local newClass = Objects.newClass
local ObjectBase = Objects.ObjectBase

local tinsert = table.insert
local tremove = table.remove

local LOCAL_DEBUG = false



--====================================================================--
--== Nav Item Widget Class
--====================================================================--


local NavItem = newClass( ObjectBase, {name="Nav Item"}  )

--== Theme Constants

NavItem.THEME_ID = 'navitem'
NavItem.STYLE_CLASS = nil -- added later


--======================================================--
-- Start: Setup DMC Objects

function NavItem:__init__( params )
	-- print( "NavItem:__init__" )
	params = params or {}
	if params.title==nil then params.title="" end
	self:superCall( '__init__', params )
	--==--

	--== Sanity Check ==--

	--== Create Properties ==--

	self._title = params.title

	--== Object References ==--

	self._btn_back = nil
	self._btn_left = nil
	self._txt_title = nil
	self._btn_right = nil

end

--[[
function NavItem:_undoInit()
	-- print( "NavItem:_undoInit" )
	--==--
	self:superCall( "_undoInit" )
end
--]]


-- __initComplete__()
--
function NavItem:__initComplete__()
	--print( "NavItem:__initComplete__" )
	self:superCall( '__initComplete__' )
	--==--

	local o

	o = Widgets.newPushButton{
		id='button-back',
		labelText="Back",

		style={
			debugOn=false,

			width=80,
			height=35,

			inactive={
				label = {
					textColor={0,0,0},
				},
				background={
					view={
						type='rectangle'
					}
				}
			},
			active={
				label = {
					textColor={0,0,0},
				},
				background={
					view={
						type='rectangle'
					}
				}
			},
			disabled={
				label = {
					textColor={0,0,0},
				},
				background={
					view={
						type='rectangle'
					}
				}
			}
		}
	}
	self._btn_back = o

	o = Widgets.newPushButton{
		id='button-title',
		labelText="Title",

		style={
			debugOn=false,

			width=80,
			height=35,

			inactive={
				label = {
					textColor={0,0,0},
				},
				background={
					view={
						type='rectangle'
					}
				}
			},
			active={
				label = {
					textColor={0,0,0},
				},
				background={
					view={
						type='rectangle'
					}
				}
			},
			disabled={
				label = {
					textColor={0,0,0},
				},
				background={
					view={
						type='rectangle'
					}
				}
			}
		}
	}
	self._txt_title = o


end

function NavItem:__undoInitComplete__()
	-- print( "NavItem:__undoInitComplete__" )

	local o

	o = self._btn_back
	if o then
		o:removeSelf()
		self._btn_back = nil
	end

	o = self._txt_title
	if o then
		o:removeSelf()
		self._txt_title = nil
	end

	--== Though this aren't default, check them

	o = self._btn_left
	if o then
		o:removeSelf()
		self._btn_left = nil
	end

	o = self._btn_right
	if o then
		o:removeSelf()
		self._btn_right = nil
	end

	--==--
	self:superCall( '__undoInitComplete__' )
end


-- END: Setup DMC Objects
--======================================================--



--====================================================================--
--== Static Methods


function NavItem.initialize( manager )
	-- print( "NavItem.initialize" )
	Widgets = manager
	ThemeMgr = Widgets.ThemeMgr
	Button = Widgets.Button
	NavBar = Widgets.NavBar

	ThemeMgr:registerWidget( NavItem.THEME_ID, NavItem )
end



--====================================================================--
--== Public Methods


-- getter, back button
--
function NavItem.__getters:back_button()
	-- print( "NavItem.__getters:back_button" )
	return self._btn_back
end


-- getter/setter, left button
--
function NavItem.__getters:left_button()
	-- print( "NavItem.__getters:left_button" )
	return self._btn_left
end
function NavItem.__setters:left_button( button )
	-- print( "NavItem.__setters:left_button", button )
	assert( type(button)=='table' and button.isa, "wrong type for button" )
	assert( button:isa( Button ), "wrong type for button" )
	--==--
	self._btn_left = button
end


-- getter/setter, right button
--
function NavItem.__getters:right_button()
	-- print( "NavItem.__getters:right_button" )
	return self._btn_right
end
function NavItem.__setters:right_button( button )
	-- print( "NavItem.__setters:right_button", button )
	assert( type(button)=='table' and button.isa, "wrong type for button" )
	assert( button:isa( Button ), "wrong type for button" )
	self._btn_right = button
end


-- getter/setter, title TODO (inside of buttons)
--
function NavItem.__getters:title()
	-- print( "NavItem.__getters:right_button" )
	return self._txt_title
end
function NavItem.__setters:title( title )
	-- print( "NavItem.__setters:title", button )
	assert( type(title)=='string', "title must be a string" )
	--==--
	self._txt_title.text = title
end




return NavItem
