


local sformat = string.format

local Utils = {}

--======================================================--
-- Table tests


function Utils.hasPropertyValue( source, property, value )
	assert( source, "'source' missing from test" )
	assert( property, "'property' missing from test" )
	local emsg = sformat( "incorrect value for property '%s'", tostring( property ) )
	assert_equal( source[property], value, emsg )
end


function Utils.hasValidStyleProperties( class, source )
	assert( class, "'class' missing from test" )
	assert( source, "'source' missing from test" )
	local emsg = sformat( "invalid class properties for '%s'", tostring( class ) )
	assert_true( class._verifyStyleProperties( source ), emsg )
end

function Utils.hasInvalidStyleProperties( class, source )
	assert( class, "'class' missing from test" )
	assert( source, "'source' missing from test" )
	local emsg = sformat( "invalid class properties for '%s'", tostring( class.NAME ) )
	assert_false( class._verifyStyleProperties( source ), emsg )
end




--======================================================--
-- Style-instance tests

-- styleInheritsFrom()
-- tests to see if Style inheritance matches
-- tests for Inherit match
--
function Utils.styleInheritsFrom( style, class )
	assert( style, "'style' missing from test" )
	assert( class, "'class' missing from test" )
	local emsg = sformat( "incorrect class value for '%s'", tostring( style ) )
	assert_equal( style._inherit, class, emsg )
end



-- styleRawPropValueIs()
-- tests to see whether the property value matches test value
-- test only local property value
--
function Utils.styleRawPropertyValueIs( style, property, value )
	assert( style, "'style' missing from test" )
	assert( property, "'property' missing from test" )
	-- local value
	assert_equal( style:_getRawProperty( property), value, "inherit value for ''"..tostring(property) )
end

-- stylePropValueIs()
-- tests to see whether the property value matches test value
-- tests either local or inherited values
--
function Utils.stylePropertyValueIs( style, property, value )
	assert( style, "'style' missing from test" )
	assert( property, "'property' missing from test" )
	-- using getters (inheritance)
	assert_equal( style[property], value, "property value is incorrect" )
end



-- styleHasProperty()
-- tests to see whether the property value is local to Style
-- test whether local property is NOT nil
--
function Utils.styleHasProperty( style, property )
	assert( style, "'style' missing from test" )
	assert( property, "'property' missing from test" )
	assert_true( style:_getRawProperty( property) ~= nil, "inherit value for ''"..tostring(property) )
end

-- styleInheritsProp()
-- tests to see whether the style inherits its property
-- test whether local property is nil
--
function Utils.styleInheritsProperty( style, property )
	assert( style, "'style' missing from test" )
	assert( property, "'property' missing from test" )
	assert_true( style:_getRawProperty( property) == nil, "inherit value for ''"..tostring(property) )
end



-- styleHasPropertyValue()
-- combo test to see whether the property value is local to Style
-- checks all possibilities
--
function Utils.styleHasPropertyValue( style, property, value )
	Utils.stylePropertyValueIs( style, property, value )
	Utils.styleHasProperty( style, property )
	Utils.styleRawPropertyValueIs( style, property, value )
end

-- styleInheritsPropValueFrom()
-- combo test to see whether the property value is inherited
-- checks all possibilities
--
function Utils.styleInheritsPropertyValueFrom( style, property, value, inherit )
	Utils.stylePropertyValueIs( style, property, value )
	Utils.styleInheritsProp( style, property )
	Utils.styleInheritsFrom( style, inherit )
end




return Utils
