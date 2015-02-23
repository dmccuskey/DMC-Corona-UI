
--====================================================================--
-- Test: Text Widget
--====================================================================--

module(..., package.seeall)


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.1.0"



--====================================================================--
--== Imports


local Widgets = require 'lib.dmc_widgets'
local Utils = require 'tests.test_utils'



--====================================================================--
--== Setup, Constants


local W, H = display.contentWidth, display.contentHeight
local H_CENTER, V_CENTER = W*0.5, H*0.5


local hasPropertyValue = TestUtils.hasPropertyValue
local hasValidStyleProperties = TestUtils.hasValidStyleProperties
local hasInvalidStyleProperties = TestUtils.hasInvalidStyleProperties

local styleInheritsFrom = TestUtils.styleInheritsFrom

local styleRawPropertyValueIs = TestUtils.styleRawPropertyValueIs
local stylePropertyValueIs = TestUtils.stylePropertyValueIs

local styleHasProperty = TestUtils.styleHasProperty
local styleInheritsProp = TestUtils.styleInheritsProp

local styleHasPropertyValue = TestUtils.styleHasPropertyValue
local styleInheritsPropertyValueFrom = TestUtils.styleInheritsPropertyValueFrom



--====================================================================--
--== Support Functions




local function textStyleInheritsFrom( style, inherit )

	styleInheritsPropFrom( style, 'align', inherit )
end


--====================================================================--
--== Module Testing
--====================================================================--


-- function test_moduleBasics()

-- 	assert_equal( type(_G.getDMCObject), 'function', "should be function" )

-- 	assert_equal( _G.getDMCObject( { __dmc_ref=true } ), true, "should be true" )

-- 	assert_error( "not true", function() _G.getDMCObject( {} ) end )

-- end


-- assert_equal( ObjectBase.NAME, "Object Class", "name is incorrect" )

-- assert_true( ws_handshake.checkResponse( response, key ), "should be true" )

-- assert_false( ws_handshake.checkResponse( response, key ), "should be false" )

-- assert_error( function() ws_handshake.checkResponse( {}, nil ) end, "should be error" )



--====================================================================--
--== ObjectBase Testing
--====================================================================--

function suite_setup()

	Widgets._loadTextSupport()

end


function test_TextStyleClass()

	local TextStyle = Widgets.Style.Text
	local BaseStyle = Widgets.Style.Base

	local DefaultStyle = TextStyle:_getBaseStyle()

	assert_equal( TextStyle.NAME, "Text Style", "name is incorrect" )

	assert_equal( DefaultStyle.NAME, "Text Style", "NAME is incorrect" )
	-- assert_true( DefaultStyle:isa(BaseStyle), "Class is incorrect" )
	assert_true( DefaultStyle:isa(TextStyle), "Class is incorrect" )

end


--[[
Test to ensure that the correct property values are
copied during initialization
--]]
function test_copyingProperties()

	local TextStyle = Widgets.Style.Text
	local DefaultStyle = TextStyle:_getBaseStyle()

	local src, dest

	src = TextStyle._STYLE_DEFAULTS
	dest = { name="albert", width=1, anchorX=100 }

	TextStyle.addMissingDestProperties( dest, src )

	assert_equal( dest.debugOn, src.debugOn, "property incorrect: debugOn" )

	assert_equal( dest.width, 1, "property incorrect: width" )
	assert_equal( dest.height, src.height, "property incorrect: width" )

	stylePropertyValueIs( dest, 'align', src.align )
	stylePropertyValueIs( dest, 'anchorX', 100 )

	assert_equal( dest.align, src.align, "property incorrect: align" )
	assert_equal( dest.anchorX, 100, "property incorrect: anchorX" )
	assert_equal( dest.anchorY, src.anchorY, "property incorrect: anchorY" )
	assert_equal( dest.fillColor, src.fillColor, "property incorrect: fillColor" )
	assert_equal( dest.font, src.font, "property incorrect: font" )
	assert_equal( dest.fontSize, src.fontSize, "property incorrect: fontSize" )
	assert_equal( dest.marginX, src.marginX, "property incorrect: marginX" )
	assert_equal( dest.marginY, src.marginY, "property incorrect: marginY" )
	assert_equal( dest.strokeColor, src.strokeColor, "property incorrect: strokeColor" )
	assert_equal( dest.strokeWidth, src.strokeWidth, "property incorrect: strokeWidth" )
	assert_equal( dest.textColor, src.textColor, "property incorrect: textColor" )

	hasValidStyleProperties( TextStyle, dest )


	src = { width=10, height=10, anchorX=10, }
	dest = { width=1, anchorY=100, fontSize=24 }

	TextStyle.copyExistingSrcProperties( dest, src )

	assert_equal( dest.debugOn, nil, "property incorrect: debugOn" )

	assert_equal( dest.width, 1, "property incorrect: width" )
	assert_equal( dest.height, 10, "property incorrect: height" )

	assert_equal( dest.align, src.align, "property incorrect: align" )
	assert_equal( dest.anchorX, 10, "property incorrect: anchorX" )
	assert_equal( dest.anchorY, 100, "property incorrect: anchorY" )
	assert_equal( dest.fillColor, nil, "property incorrect: fillColor" )
	assert_equal( dest.font, nil, "property incorrect: font" )
	assert_equal( dest.fontSize, 24, "property incorrect: fontSize" )
	assert_equal( dest.marginX, nil, "property incorrect: marginX" )
	assert_equal( dest.marginY, nil, "property incorrect: marginY" )
	assert_equal( dest.strokeColor, nil, "property incorrect: strokeColor" )
	assert_equal( dest.strokeWidth, nil, "property incorrect: strokeWidth" )
	assert_equal( dest.textColor, nil, "property incorrect: textColor" )

end


--[[
Test to ensure that the Default Text Style has all
of its properties initialized to the default values
--]]
function test_defaultPropertyValues()

	local TextStyle = Widgets.Style.Text -- after creation
	local Default = TextStyle:getDefaultStyles()
	local BaseStyle = TextStyle:_getBaseStyle()

	assert( Default )
	assert( BaseStyle )

	styleHasPropertyValue( BaseStyle, 'debugOn', Default.debugOn )
	styleRawPropertyValueIs( BaseStyle, 'width', Default.width )
	styleRawPropertyValueIs( BaseStyle, 'height', Default.height )
	styleHasPropertyValue( BaseStyle, 'anchorX', Default.anchorX )
	styleHasPropertyValue( BaseStyle, 'anchorY', Default.anchorY )
	styleHasPropertyValue( BaseStyle, 'align', Default.align )
	styleHasPropertyValue( BaseStyle, 'fillColor', Default.fillColor )
	styleHasPropertyValue( BaseStyle, 'font', Default.font )
	styleHasPropertyValue( BaseStyle, 'fontSize', Default.fontSize )
	styleHasPropertyValue( BaseStyle, 'marginX', Default.marginX )
	styleHasPropertyValue( BaseStyle, 'marginY', Default.marginY )
	styleHasPropertyValue( BaseStyle, 'textColor', Default.textColor )

end



function test_TextStyleInheritanceClass()

	local o = Widgets.newTextStyle()

	local TextStyle = Widgets.Style.Text
	local BaseStyle = Widgets.Style.Base

	local DefaultStyle = TextStyle:_getBaseStyle()

	assert_equal( DefaultStyle, o.inherit, "inheritance is incorrect" )

end


function test_eventMixinBasics()

	-- assert_equal( type(ObjectBase.dispatchEvent), 'function', "should be function" )
	-- assert_equal( type(ObjectBase.addEventListener), 'function', "should be function" )
	-- assert_equal( type(ObjectBase.removeEventListener), 'function', "should be function" )

end



