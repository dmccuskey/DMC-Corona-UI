--====================================================================--
-- dmc_corona/dmc_websockets/exception.lua
--
-- Documentation: http://docs.davidmccuskey.com/
--====================================================================--

--[[

The MIT License (MIT)

Copyright (C) 2014-2015 David McCuskey. All Rights Reserved.

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
--== DMC Corona Library : WebSockets Exception
--====================================================================--


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.2.0"



--====================================================================--
--== Imports


local Error = require 'lib.dmc_lua.lua_error'
local Objects = require 'lib.dmc_lua.lua_objects'



--====================================================================--
--== Setup, Constants


-- setup some aliases to make code cleaner
local newClass = Objects.newClass



--====================================================================--
--== Protocol Error Class
--====================================================================--


local ProtocolError = newClass( Error, { name="Protocol Error" } )

-- params:
-- code
-- reason
-- message
--
function ProtocolError:__new__( params )
	-- print( "ProtocolError:__init__" )
	params = params or {}
	self:superCall( '__new__', params.message, params )
	--==--

	if self.is_class then return end

	assert( params.code, "ProtocolError: missing protocol code" )

	self.code = params.code
	self.reason = params.reason or ""

end




--====================================================================--
--== Exception Facade
--====================================================================--


return {
	ProtocolError=ProtocolError
}
