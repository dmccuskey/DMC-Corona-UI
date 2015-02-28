--====================================================================--
-- tests/test_utils.lua
--====================================================================--


--[[
copy the following into test file

local verifyButtonStyle = TestTestUtils.verifyButtonStyle
local verifyButtonStateStyle = TestTestUtils.verifyButtonStateStyle
local verifyBackgroundStyle = TestTestUtils.verifyBackgroundStyle
local verifyBackgroundViewStyle = TestTestUtils.verifyBackgroundViewStyle
local verifyTextStyle = TestTestUtils.verifyTextStyle

local hasProperty = TestTestUtils.hasProperty
local hasPropertyValue = TestTestUtils.hasPropertyValue

local hasValidStyleProperties = TestTestUtils.hasValidStyleProperties
local hasInvalidStyleProperties = TestTestUtils.hasInvalidStyleProperties


local styleInheritsFrom = TestTestUtils.styleInheritsFrom
local styleIsa = TestTestUtils.styleIsa

local styleRawPropertyValueIs = TestTestUtils.styleRawPropertyValueIs
local stylePropertyValueIs = TestTestUtils.stylePropertyValueIs

local styleHasProperty = TestTestUtils.styleHasProperty
local styleInheritsProperty = TestTestUtils.styleInheritsProperty


local styleHasPropertyValue = TestTestUtils.styleHasPropertyValue
local styleInheritsPropertyValue = TestTestUtils.styleInheritsPropertyValue

local styleInheritsPropertyValueFrom = TestTestUtils.styleInheritsPropertyValueFrom

--]]


--====================================================================--
--== Imports


local Widgets = require 'lib.dmc_widgets'



--====================================================================--
--== Setup, Constants


local Utils = {}

local sformat = string.format



--====================================================================--
--== Support Functions


function Utils.propertyIn( list, property )
	for i = 1, #list do
		if list[i] == property then return true end
	end
	return false
end


local function propertyIsColor( property )
	if Utils.propertyIn( {'fillColor', 'textColor', 'strokeColor'}, property ) then
		return true
	end
	return false
end


local function colorsAreEqual( c1, c2 )
	local result = true
	if c1==nil and c2==nil then
		result=true
	elseif c1==nil or c2==nil then
		result=false
	else
		if c1[1]~=c2[1] then result=false end
		if c1[2]~=c2[2] then result=false end
		if c1[3]~=c2[3] then result=false end
		if c1[4]~=c2[4] then result=false end
	end
	return result
end


local function formatColor( value )
	local str = ""
	if value==nil then
		str = sformat( "(nil, nil, nil, nil)" )
	elseif #value==3 then
		str = sformat( "(%s, %s, %s, nil)", unpack( value ) )
	else
		str = sformat( "(%s, %s, %s, %s)", unpack( value ) )
	end
	return str
end


local function format( property, value )
	-- print( "format", property, value )
	local str = ""
	if propertyIsColor( property ) then
		str = sformat( "'%s' %s", tostring(property), formatColor( value ) )
	else
		str = sformat( "'%s'", tostring(property) )
	end
	return str
end



--====================================================================--
--== DMC Widgets Test TestUtils
--====================================================================--


local TestUtils = {}


function TestUtils.outputMarker()
	print( "\n\n\n MARKER \n\n\n" )
end


--======================================================--
-- Base Style Verification

function TestUtils.verifyTextStyle( style )
	assert( style, "TestUtils.verifyTextStyle missing arg 'style'" )
	local Text = Widgets.Style.Text

	TestUtils.styleIsa( style, Text )

	TestUtils.hasProperty( style, 'debugOn' )
	--[[
	width & height can be optional
	-- TestUtils.hasProperty( style, 'width' )
	-- TestUtils.hasProperty( style, 'height' )
	--]]
	TestUtils.hasProperty( style, 'anchorX' )
	TestUtils.hasProperty( style, 'anchorY' )

	TestUtils.hasProperty( style, 'align' )
	TestUtils.hasProperty( style, 'fillColor' )
	TestUtils.hasProperty( style, 'font' )
	TestUtils.hasProperty( style, 'fontSize' )
	TestUtils.hasProperty( style, 'marginX' )
	TestUtils.hasProperty( style, 'marginY' )
	TestUtils.hasProperty( style, 'strokeColor' )
	TestUtils.hasProperty( style, 'strokeWidth' )
	TestUtils.hasProperty( style, 'textColor' )

end


function TestUtils.verifyBackgroundViewStyle( style )
	assert( style, "TestUtils.verifyBackgroundViewStyle missing arg 'style'" )
	local StyleFactory = Widgets.Style.BackgroundFactory
	local BaseViewStyle = StyleFactory.Style.Base
	local Rectangle = StyleFactory.Style.Rectangle
	local Rounded = StyleFactory.Style.Rounded

	TestUtils.styleIsa( style, BaseViewStyle )

	TestUtils.hasProperty( style, 'debugOn' )
	TestUtils.hasProperty( style, 'width' )
	TestUtils.hasProperty( style, 'height' )
	TestUtils.hasProperty( style, 'anchorX' )
	TestUtils.hasProperty( style, 'anchorY' )
	TestUtils.hasProperty( style, 'type' )

	local type = style.type

	if style.type==Rectangle.type then
		TestUtils.styleIsa( style, Rectangle )
		assert_equal( style.NAME, Rectangle.NAME, "background view name is incorrect" )
		TestUtils.hasProperty( style, 'fillColor' )
		TestUtils.hasProperty( style, 'strokeColor' )
		TestUtils.hasProperty( style, 'strokeWidth' )

	elseif style.type==Rounded.type then
		TestUtils.styleIsa( style, Rounded )
		assert_equal( style.NAME, Rounded.NAME, "background view name is incorrect" )
		TestUtils.hasProperty( style, 'cornerRadius' )
		TestUtils.hasProperty( style, 'fillColor' )
		TestUtils.hasProperty( style, 'strokeColor' )
		TestUtils.hasProperty( style, 'strokeWidth' )
	else
		error( sformat( "Background view type not implemented '%s'", tostring( style.type ) ))
	end


end

function TestUtils.verifyBackgroundStyle( style )
	assert( style, "TestUtils.verifyBackgroundStyle missing arg 'style'" )
	local Background = Widgets.Style.Background
	local child, emsg

	TestUtils.styleIsa( style, Background )

	if style.inherit then
		TestUtils.styleIsa( style.inherit, Background )
	else
		TestUtils.styleInheritsFrom( style, nil )
	end

	assert_equal( style.NAME, Background.NAME, "background name is incorrect" )

	TestUtils.hasProperty( style, 'debugOn' )
	TestUtils.hasProperty( style, 'width' )
	TestUtils.hasProperty( style, 'height' )
	TestUtils.hasProperty( style, 'anchorX' )
	TestUtils.hasProperty( style, 'anchorY' )
	TestUtils.hasProperty( style, 'type' )
	TestUtils.hasProperty( style, 'view' )

	child = style.view
	assert_true( child, "Background style is missing child property 'view'" )
	assert_equal( style.type, child.type, "type mismatch in background type, child view" )

	TestUtils.verifyBackgroundViewStyle( child )
end


function TestUtils.verifyButtonStateStyle( style )
	assert( style, "TestUtils.verifyButtonStateStyle missing arg 'style'" )

	local child

	child = style.label
	assert_true( child )
	TestUtils.verifyTextStyle( child )

	child = style.background
	assert_true( child )
	TestUtils.verifyBackgroundStyle( child )

end

function TestUtils.verifyButtonStyle( style )
	assert( style, "TestUtils.verifyButtonStyle missing arg 'style'" )

	local child

	-- has children

	child = style.active
	assert_true( child )
	TestUtils.verifyButtonStateStyle( child )

	child = style.inactive
	assert_true( child )
	TestUtils.verifyButtonStateStyle( child )

	child = style.disabled
	assert_true( child )
	TestUtils.verifyButtonStateStyle( child )

end


--======================================================--
-- Table tests

-- can be used on tables or Style instances

-- checks whether style has a non-nil property
-- via inheritance or local
--
function TestUtils.hasProperty( source, property )
	assert( source, "TestUtils.hasProperty missing arg 'source'" )
	assert( property, "TestUtils.hasProperty missing arg 'property'" )
	local emsg = sformat( "missing property '%s'", tostring( property ) )
	assert_true( source[property]~=nil, emsg )
end


-- checks whether style has a value for property
-- via inheritance or local
--
function TestUtils.hasPropertyValue( source, property, value )
	assert( source, "TestUtils.hasPropertyValue missing arg 'source'" )
	assert( property, "TestUtils.hasPropertyValue missing arg 'property'" )
	local emsg = sformat( "incorrect value for property '%s'", tostring( property ) )
	if propertyIsColor( property ) then
		emsg = sformat( "color mismatch %s<>%s", formatColor( source[property] ), formatColor( value ) )
		assert_true( colorsAreEqual( value, source[property] ), emsg )
	else
		assert_equal( value, source[property], emsg )
	end
end


function TestUtils.hasValidStyleProperties( class, source )
	assert( class, "TestUtils.hasValidStyleProperties missing 'class'" )
	assert( source, "TestUtils.hasValidStyleProperties missing 'source'" )
	local emsg = sformat( "invalid class properties for '%s'", tostring( class ) )
	assert_true( class._verifyStyleProperties( source ), emsg )
end

function TestUtils.hasInvalidStyleProperties( class, source )
	assert( class, "TestUtils.hasInvalidStyleProperties missing arg 'class'" )
	assert( source, "TestUtils.hasInvalidStyleProperties missing arg 'source'" )
	local emsg = sformat( "invalid class properties for '%s'", tostring( class.NAME ) )
	assert_false( class._verifyStyleProperties( source ), emsg )
end



--======================================================--
-- Style-instance tests

-- styleInheritsFrom()
-- tests to see if Style inheritance matches
-- tests for Inherit match
--
function TestUtils.styleInheritsFrom( style, class )
	assert( style, "TestUtils.styleInheritsFrom missing arg 'style'" )
	local emsg = sformat( "incorrect class inheritance for '%s'", tostring( style ) )
	assert_equal( style._inherit, class, emsg )
end


function TestUtils.styleIsa( style, class )
	assert( style, "TestUtils.styleIsa missing arg 'style'" )
	assert( class, "TestUtils.styleIsa missing arg 'class'" )
	local emsg = sformat( "incorrect base class for '%s', expected '%s'", tostring(style), tostring(class) )
	assert_true( style:isa( class ), emsg )
end


-- styleRawPropValueIs()
-- tests to see whether the property value matches test value
-- test only local property value
--
function TestUtils.styleRawPropertyValueIs( style, property, value )
	assert( style, "TestUtils.styleRawPropertyValueIs missing arg 'style'" )
	assert( property, "TestUtils.styleRawPropertyValueIs missing arg 'property'" )
	local emsg = sformat( "incorrect local property value for '%s'", format( property, value ) )

	if propertyIsColor( property ) then
		local color = style:_getRawProperty( property )
		emsg = sformat( "color mismatch for property '%s' %s<>%s", property, formatColor( color ), formatColor( value ) )
		assert_true( colorsAreEqual( value, color ), emsg )
	else
		-- local value
		assert_equal( style:_getRawProperty( property ), value, emsg )
	end
end

-- stylePropValueIs()
-- tests to see whether the property value matches test value
-- tests either local or inherited values
--
function TestUtils.stylePropertyValueIs( style, property, value )
	assert( style, "TestUtils.stylePropertyValueIs missing arg 'style'" )
	assert( property, "TestUtils.stylePropertyValueIs missing arg 'property'" )
	local emsg = sformat( "incorrect value for property '%s'", format( property, value ) )
	-- using getters (inheritance)
	if propertyIsColor( property ) then
		emsg = sformat( "color mismatch for '%s' %s<>%s", property, formatColor( style[property] ), formatColor( value ) )
		assert_true( colorsAreEqual( value, style[property] ), emsg )
	else
		assert_equal( style[property], value, emsg )
	end
end


-- styleHasProperty()
-- tests to see whether the property value is local to Style
-- test whether local property is NOT nil
--
function TestUtils.styleHasProperty( style, property )
	assert( style, "TestUtils.styleHasProperty missing arg 'style'" )
	assert( property, "TestUtils.styleHasProperty missing arg 'property'" )
	local emsg = sformat( "style inherits property '%s'", tostring( property ) )
	assert_true( style:_getRawProperty(property)~=nil, emsg )
end

-- styleInheritsProp()
-- tests to see whether the style inherits its property
-- test whether local property is nil
--
function TestUtils.styleInheritsProperty( style, property )
	assert( style, "TestUtils.styleInheritsProperty missing arg style'" )
	assert( property, "TestUtils.styleInheritsProperty missing arg 'property'" )
	local emsg = sformat( "style has local property '%s'", tostring( property ) )
	assert_true( style:_getRawProperty(property)==nil, emsg )
end


--======================================================--
-- Style-instance "combo" tests

-- styleHasPropertyValue()
-- combo test to see whether the property value is local to Style
-- checks all possibilities
--
function TestUtils.styleHasPropertyValue( style, property, value )
	TestUtils.stylePropertyValueIs( style, property, value )
	TestUtils.styleHasProperty( style, property )
	TestUtils.styleRawPropertyValueIs( style, property, value )
end


-- styleInheritsPropertyValue()
-- combo test to see whether the property value is local to Style
-- checks all possibilities
--
function TestUtils.styleInheritsPropertyValue( style, property, value )
	TestUtils.stylePropertyValueIs( style, property, value )
	TestUtils.styleInheritsProperty( style, property )
	-- last item is supposed to be nil
	TestUtils.styleRawPropertyValueIs( style, property, nil )
end


-- styleInheritsPropValueFrom()
-- combo test to see whether the property value is inherited
-- checks all possibilities
--
function TestUtils.styleInheritsPropertyValueFrom( style, property, value, inherit )
	TestUtils.stylePropertyValueIs( style, property, value )
	TestUtils.styleInheritsProperty( style, property )
	TestUtils.styleInheritsFrom( style, inherit )
end




return TestUtils
