
local tinsert = table.insert

local Utils = {}

-- http://lua-users.org/wiki/FunctionalLibrary

local function returnItem( item )
	return item
end
-- filter(function, table)
-- e.g: filter(is_even, {1,2,3,4}) -> {2,4}
function Utils.filter(func, tbl, proc)
	assert( type(func)=='function', "missing function for filter" )
	assert( type(tbl)=='table', "missing table for data" )
	proc = proc or returnItem

	local list = {}
	for i,v in ipairs(tbl) do
		if func(v) then
			tinsert( list, proc(v) )
		end
	end
	return list
end


-- takes in key,
-- returns list with all data
-- or empty list
function Utils.filterTableByName( tbl, name )
	assert( type(tbl)=='table', "missing table for data" )
	assert( type(name)=='string', "missing name for filter" )

	local function genTest( n )
		assert( n )
		-- sources, name
		return function( s )
			-- source, from filter()
			return (s[n]~=nil) -- has name
		end
	end
	local function getChild( n )
		assert( n )
		return function( s )
			return s[n]
		end
	end

	local test, process = genTest( name ), getChild( name )
	return Utils.filter( test, tbl, process )

end



return Utils
