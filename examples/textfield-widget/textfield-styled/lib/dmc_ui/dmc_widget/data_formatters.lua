--====================================================================--
-- dmc_widget/data_formatters.lua
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
--== DMC Corona Widgets : Widget Data Formatter
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
--== DMC Widgets : newFormatter
--====================================================================--



--====================================================================--
--== Setup, Constants


local sfind = string.find



--====================================================================--
--== Support Functions


local function newClass( parent, params )
	params = params or {}
	if params.name==nil then params.name="<unknown class>" end
	--==--
	local o = {}
	local o_mt = {
		__index=parent or o
	}
	setmetatable( o, o_mt )

	o.NAME=params.name

	return o
end



--====================================================================--
--== Formatter Base Class
--====================================================================--


local FormatterBase = newClass( nil, {name="Formatter Base"}  )

FormatterBase.TYPE = 'formatter-base'

function FormatterBase:areCharactersValid( chars, text )
	return true
end

function FormatterBase:isTextValid( text )
	return true
end



--====================================================================--
--== US Zipcode Formatter Class
--====================================================================--


local USZipcode = newClass( FormatterBase, {name="Zipcode Formatter"}  )

USZipcode.TYPE = 'us-zipcode-formatter'

function USZipcode:areCharactersValid( chars, text )
	local length = (#text<=5)
	local value = ( sfind( chars,"[^0-9]" ) == nil )
	return ( length and value )
end

function USZipcode:isTextValid( text )
	local length = (#text==0 or #text==5)
	local value = ( sfind( text,"[^0-9]" ) == nil )
	return ( length and value )
end




--====================================================================--
--== Formatter Factory
--====================================================================--


local Formatter = {}

Formatter.BASE = FormatterBase.TYPE
Formatter.US_ZIPCODE = USZipcode.TYPE

Formatter.create = function( params )
	params = params or {}
	assert( type(params.type)=='string' )
	--==--
	local ftype = params.type

	if ftype==Formatter.US_ZIPCODE then
		return USZipcode
	else
		return FormatterBase.TYPE
	end

end


return Formatter
