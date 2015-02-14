--====================================================================--
-- dmc_widgets/widget_theme_mix.lua
--
-- Documentation: http://docs.davidmccuskey.com/
--====================================================================--

--[[

The MIT License (MIT)

Copyright (C) 2015 David McCuskey. All Rights Reserved.

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
--== DMC Corona Widgets : Widget Theme Mixin
--====================================================================--


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.1.0"



--====================================================================--
--== Support Functions


function _patch( obj )

	obj = obj or {}

	-- add properties
	Theme.__init__( obj )

	-- add methods
	obj.resetTheme = Theme.resetTheme
	obj.setTheme = Theme.setTheme
	obj.setDebug = Theme.setDebug

	return obj
end



--====================================================================--
--== Theme Mixin
--====================================================================--


local Theme = {}

Theme.NAME = "Theme Mixin"

--======================================================--
-- START: Mixin Setup for DMC Objects

function Theme.__init__( self, params )
	-- print( "Theme.__init__" )
	params = params or {}
	--==--
	Theme.resetTheme( self, params )
end

function Theme.__undoInit__( self )
	-- print( "Theme.__undoInit__" )
	Theme.resetTheme( self )
end

-- END: Mixin Setup for DMC Objects
--======================================================--



--====================================================================--
--== Public Methods


function Theme.resetTheme( self, params )
	params = params or {}
	if params.debug_on==nil then params.debug_on=false end
	--==--
	if self.__debug_on then
		print( outStr( "resetTheme: resetting popover" ) )
	end
	self.__collection_name = nil -- 'navbar-home'
	self.__curr_style_collection = nil -- <style collection obj>
	self.__curr_style = nil -- <style obj>
	self.__curr_style_f = nil
	self.__styles = {}
	self.__debug_on = params.debug_on

end


function Theme.setActiveStyle( self, style )
	local o = self.__curr_style
	if o then
		o.onProperty = nil
	end
	o = style
	o.onProperty = self.__curr_style_f
	self.__curr_style = o
	self.curr_style = o
end

function Theme.setStyleCallback( self, func )
	-- print( "Theme.setStyleCallback", func )
	self.__curr_style_f = func
end

function Theme.resetStyles( self )
	self.__styles = {}
end


function Theme.addTheme( self )
end

function Theme.removeTheme( self )
end



function Theme.setDebug( self, value )
	self.__debug_on = value
end



--====================================================================--
--== Theme Facade
--====================================================================--


return {
	ThemeMix=Theme,
	patch=_patch,
}



