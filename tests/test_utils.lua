--====================================================================--
-- tests/test_utils.lua
--====================================================================--


--[[
copy the following into test file

local verifyButtonStyle = TestUtils.verifyButtonStyle
local verifyButtonStateStyle = TestUtils.verifyButtonStateStyle
local verifyBackgroundStyle = TestUtils.verifyBackgroundStyle
local verifyBackgroundViewStyle = TestUtils.verifyBackgroundViewStyle
local verifyTextStyle = TestUtils.verifyTextStyle

local hasProperty = TestUtils.hasProperty
local hasPropertyValue = TestUtils.hasPropertyValue

local hasValidStyleProperties = TestUtils.hasValidStyleProperties
local hasInvalidStyleProperties = TestUtils.hasInvalidStyleProperties


local styleInheritsFrom = TestUtils.styleInheritsFrom
local styleIsa = TestUtils.styleIsa

local styleRawPropertyValueIs = TestUtils.styleRawPropertyValueIs
local stylePropertyValueIs = TestUtils.stylePropertyValueIs

local styleHasProperty = TestUtils.styleHasProperty
local styleInheritsProperty = TestUtils.styleInheritsProperty


local styleHasPropertyValue = TestUtils.styleHasPropertyValue
local styleInheritsPropertyValue = TestUtils.styleInheritsPropertyValue

local styleInheritsPropertyValueFrom = TestUtils.styleInheritsPropertyValueFrom

--]]


--====================================================================--
--== Imports


local Widgets = require 'lib.dmc_widgets'



--====================================================================--
--== Setup, Constants


local sformat = string.format



--====================================================================--
--== DMC Widgets Test Utils
--====================================================================--


local Utils = {}


--======================================================--
-- Base Style Verification

function Utils.verifyTextStyle( style )
	assert( style, "Utils.verifyTextStyle missing arg 'style'" )
	local Text = Widgets.Style.Text

	Utils.styleIsa( style, Text )

	Utils.hasProperty( style, 'debugOn' )
	--[[
	width & height can be optional
	-- Utils.hasProperty( style, 'width' )
	-- Utils.hasProperty( style, 'height' )
	--]]
	Utils.hasProperty( style, 'anchorX' )
	Utils.hasProperty( style, 'anchorY' )

	Utils.hasProperty( style, 'align' )
	Utils.hasProperty( style, 'fillColor' )
	Utils.hasProperty( style, 'font' )
	Utils.hasProperty( style, 'fontSize' )
	Utils.hasProperty( style, 'marginX' )
	Utils.hasProperty( style, 'marginY' )
	Utils.hasProperty( style, 'strokeColor' )
	Utils.hasProperty( style, 'strokeWidth' )
	Utils.hasProperty( style, 'textColor' )

end


function Utils.verifyBackgroundViewStyle( style )
	assert( style, "Utils.verifyBackgroundViewStyle missing arg 'style'" )
	local StyleFactory = Widgets.Style.BackgroundFactory
	local BaseViewStyle = StyleFactory.Style.Base
	local Rectangle = StyleFactory.Style.Rectangle
	local Rounded = StyleFactory.Style.Rounded

	Utils.styleIsa( style, BaseViewStyle )

	Utils.hasProperty( style, 'debugOn' )
	Utils.hasProperty( style, 'width' )
	Utils.hasProperty( style, 'height' )
	Utils.hasProperty( style, 'anchorX' )
	Utils.hasProperty( style, 'anchorY' )
	Utils.hasProperty( style, 'type' )

	local type = style.type

	if style.type==Rectangle.type then
		Utils.styleIsa( style, Rectangle )
		assert_equal( style.NAME, Rectangle.NAME, "background view name is incorrect" )
		Utils.hasProperty( style, 'fillColor' )
		Utils.hasProperty( style, 'strokeColor' )
		Utils.hasProperty( style, 'strokeWidth' )

	elseif style.type==Rounded.type then
		Utils.styleIsa( style, Rounded )
		assert_equal( style.NAME, Rounded.NAME, "background view name is incorrect" )
		Utils.hasProperty( style, 'cornerRadius' )
		Utils.hasProperty( style, 'fillColor' )
		Utils.hasProperty( style, 'strokeColor' )
		Utils.hasProperty( style, 'strokeWidth' )
	else
		error( sformat( "Background view type not implemented '%s'", tostring( style.type ) ))
	end


end

function Utils.verifyBackgroundStyle( style )
	assert( style, "Utils.verifyBackgroundStyle missing arg 'style'" )
	local Background = Widgets.Style.Background
	local child, emsg

	Utils.styleIsa( style, Background )

	if style.inherit then
		Utils.styleIsa( style.inherit, Background )
	else
		Utils.styleInheritsFrom( style, nil )
	end

	assert_equal( style.NAME, Background.NAME, "background name is incorrect" )

	Utils.hasProperty( style, 'debugOn' )
	Utils.hasProperty( style, 'width' )
	Utils.hasProperty( style, 'height' )
	Utils.hasProperty( style, 'anchorX' )
	Utils.hasProperty( style, 'anchorY' )
	Utils.hasProperty( style, 'type' )
	Utils.hasProperty( style, 'view' )

	child = style.view
	assert_true( child, "Background style is missing child property 'view'" )
	assert_equal( style.type, child.type, "type mismatch in background type, child view" )

	Utils.verifyBackgroundViewStyle( child )
end


function Utils.verifyButtonStateStyle( style )
	assert( style, "Utils.verifyButtonStateStyle missing arg 'style'" )

	local child

	child = style.label
	assert_true( child )
	Utils.verifyTextStyle( child )

	child = style.background
	assert_true( child )
	Utils.verifyBackgroundStyle( child )

end

function Utils.verifyButtonStyle( style )
	assert( style, "Utils.verifyButtonStyle missing arg 'style'" )

	local child

	-- has children

	child = style.active
	assert_true( child )
	Utils.verifyButtonStateStyle( child )

	child = style.inactive
	assert_true( child )
	Utils.verifyButtonStateStyle( child )

	child = style.disabled
	assert_true( child )
	Utils.verifyButtonStateStyle( child )

end


--======================================================--
-- Table tests

-- can be used on tables or Style instances

-- checks whether style has a non-nil property
-- via inheritance or local
--
function Utils.hasProperty( source, property )
	assert( source, "Utils.hasProperty missing arg 'source'" )
	assert( property, "Utils.hasProperty missing arg 'property'" )
	local emsg = sformat( "missing property '%s'", tostring( property ) )
	assert_true( source[property]~=nil, emsg )
end


-- checks whether style has a value for property
-- via inheritance or local
--
function Utils.hasPropertyValue( source, property, value )
	assert( source, "Utils.hasPropertyValue missing arg 'source'" )
	assert( property, "Utils.hasPropertyValue missing arg 'property'" )
	local emsg = sformat( "incorrect value for property '%s'", tostring( property ) )
	assert_equal( source[property], value, emsg )
end


function Utils.hasValidStyleProperties( class, source )
	assert( class, "Utils.hasValidStyleProperties missing 'class'" )
	assert( source, "Utils.hasValidStyleProperties missing 'source'" )
	local emsg = sformat( "invalid class properties for '%s'", tostring( class ) )
	assert_true( class._verifyStyleProperties( source ), emsg )
end

function Utils.hasInvalidStyleProperties( class, source )
	assert( class, "Utils.hasInvalidStyleProperties missing arg 'class'" )
	assert( source, "Utils.hasInvalidStyleProperties missing arg 'source'" )
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
	assert( style, "Utils.styleInheritsFrom missing arg 'style'" )
	local emsg = sformat( "incorrect class inheritance for '%s'", tostring( style ) )
	assert_equal( style._inherit, class, emsg )
end


function Utils.styleIsa( style, class )
	assert( style, "Utils.styleIsa missing arg 'style'" )
	assert( class, "Utils.styleIsa missing arg 'class'" )
	local emsg = sformat( "incorrect base class for '%s', expected '%s'", tostring(style), tostring(class) )
	assert_true( style:isa( class ), emsg )
end


-- styleRawPropValueIs()
-- tests to see whether the property value matches test value
-- test only local property value
--
function Utils.styleRawPropertyValueIs( style, property, value )
	assert( style, "Utils.styleRawPropertyValueIs missing arg 'style'" )
	assert( property, "Utils.styleRawPropertyValueIs missing arg 'property'" )
	local emsg = sformat( "incorrect local property value for '%s'", tostring( property ) )

	-- local value
	assert_equal( style:_getRawProperty( property), value, emsg )
end

-- stylePropValueIs()
-- tests to see whether the property value matches test value
-- tests either local or inherited values
--
function Utils.stylePropertyValueIs( style, property, value )
	assert( style, "Utils.stylePropertyValueIs missing arg 'style'" )
	assert( property, "Utils.stylePropertyValueIs missing arg 'property'" )
	local emsg = sformat( "incorrect value for property '%s'", tostring( property ) )
	-- using getters (inheritance)
	assert_equal( style[property], value, emsg )
end


-- styleHasProperty()
-- tests to see whether the property value is local to Style
-- test whether local property is NOT nil
--
function Utils.styleHasProperty( style, property )
	assert( style, "Utils.styleHasProperty missing arg 'style'" )
	assert( property, "Utils.styleHasProperty missing arg 'property'" )
	local emsg = sformat( "style inherits property '%s'", tostring( property ) )
	assert_true( style:_getRawProperty(property)~=nil, emsg )
end

-- styleInheritsProp()
-- tests to see whether the style inherits its property
-- test whether local property is nil
--
function Utils.styleInheritsProperty( style, property )
	assert( style, "Utils.styleInheritsProperty missing arg style'" )
	assert( property, "Utils.styleInheritsProperty missing arg 'property'" )
	local emsg = sformat( "style has local property '%s'", tostring( property ) )
	assert_true( style:_getRawProperty(property)==nil, emsg )
end


--======================================================--
-- Style-instance "combo" tests

-- styleHasPropertyValue()
-- combo test to see whether the property value is local to Style
-- checks all possibilities
--
function Utils.styleHasPropertyValue( style, property, value )
	Utils.stylePropertyValueIs( style, property, value )
	Utils.styleHasProperty( style, property )
	Utils.styleRawPropertyValueIs( style, property, value )
end


-- styleInheritsPropertyValue()
-- combo test to see whether the property value is local to Style
-- checks all possibilities
--
function Utils.styleInheritsPropertyValue( style, property, value )
	print( ">>", style, property, value )
	Utils.stylePropertyValueIs( style, property, value )
	Utils.styleInheritsProperty( style, property )
	Utils.styleRawPropertyValueIs( style, property, nil )
end


-- styleInheritsPropValueFrom()
-- combo test to see whether the property value is inherited
-- checks all possibilities
--
function Utils.styleInheritsPropertyValueFrom( style, property, value, inherit )
	Utils.stylePropertyValueIs( style, property, value )
	Utils.styleInheritsProperty( style, property )
	Utils.styleInheritsFrom( style, inherit )
end




return Utils
