--====================================================================--
-- Test: Background Widget Views
--====================================================================--

module(..., package.seeall)


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.1.0"



--====================================================================--
--== Imports


local dUI = require 'lib.dmc_ui'
local TestUtils = require 'tests.test_utils'
local Utils = require 'dmc_utils'



--====================================================================--
--== Setup, Constants


local W, H = display.contentWidth, display.contentHeight
local H_CENTER, V_CENTER = W*0.5, H*0.5


local verifyBackgroundViewStyle = TestUtils.verifyBackgroundViewStyle

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

local marker = TestUtils.outputMarker



--====================================================================--
--== Support Functions



--====================================================================--
--== Module Testing
--====================================================================--


function suite_setup()

	dUI.Style._loadBackgroundStyleSupport( {mode=dUI.TEST_MODE} )

end


--[[
Test to ensure that the correct property values are
copied during initialization
--]]
--[[
function test_addMissingProperties()
	local BackgroundFactory = Widgets.Style.BackgroundFactory
	local Rectangle = BackgroundFactory.Rectangle
	local defaults = Rectangle:getDefaultStyleValues()
	local srcs, src, base, dest, child


	--== test empty source, empty destination

	src = {
		view = {}
	}
	child = src.view

	Rectangle.addMissingDestProperties( child, {parent=src} )

	hasPropertyValue( child, 'debugOn', defaults.debugOn )
	hasPropertyValue( child, 'width', defaults.width )
	hasPropertyValue( child, 'height', defaults.height )
	hasPropertyValue( child, 'anchorX', defaults.anchorX )
	hasPropertyValue( child, 'anchorY', defaults.anchorY )

	hasPropertyValue( child, 'fillColor', defaults.fillColor )
	hasPropertyValue( child, 'strokeColor', defaults.strokeColor )
	hasPropertyValue( child, 'strokeWidth', defaults.strokeWidth )


	--== test partial source, empty destination

	src = {
		hitMarginX=111,
		type='four',

		debugOn=100,
		anchorX=101,
		width=121,
		view = {}
	}
	child = src.view

	Rectangle.addMissingDestProperties( child, {parent=src} )

	hasPropertyValue( child, 'debugOn', defaults.debugOn )
	hasPropertyValue( child, 'width', defaults.width )
	hasPropertyValue( child, 'height', defaults.height )
	hasPropertyValue( child, 'anchorX', defaults.anchorX )
	hasPropertyValue( child, 'anchorY', defaults.anchorY )

	hasPropertyValue( child, 'fillColor', defaults.fillColor )
	hasPropertyValue( child, 'strokeColor', defaults.strokeColor )
	hasPropertyValue( child, 'strokeWidth', defaults.strokeWidth )

	hasPropertyValue( child, 'hitMarginX', nil )
	hasPropertyValue( child, 'type', nil )

	--== test partial source, partial destination

	src = {
		width=100,
		debugOn=102,
		anchorX=111,
		fontSize=110,
		view = {
			debugOn=120,
			width=126,
		}
	}
	child = src.view

	Rectangle.addMissingDestProperties( child, {parent=src} )

	hasPropertyValue( child, 'debugOn', child.debugOn )
	hasPropertyValue( child, 'width', child.width )
	hasPropertyValue( child, 'height', defaults.height )
	hasPropertyValue( child, 'anchorX', defaults.anchorX )
	hasPropertyValue( child, 'anchorY', defaults.anchorY )

	hasPropertyValue( child, 'fillColor', defaults.fillColor )
	hasPropertyValue( child, 'strokeColor', defaults.strokeColor )
	hasPropertyValue( child, 'strokeWidth', defaults.strokeWidth )

	hasPropertyValue( child, 'hitMarginX', nil )
	hasPropertyValue( child, 'type', nil )

end
--]]


--[[
Test to ensure that the correct property values are
copied during initialization
--]]
function test_copyExistingSrcProperties()
	-- print( "test_copyExistingSrcProperties" )
	local BackgroundFactory = dUI.Style.BackgroundFactory
	local RectangleStyle = BackgroundFactory.Rectangle

	local src, dest

	--== test empty destination

	src = {
		debugOn=false,
		hitMarginX=101,
		type='rectangle',
		width=102,
		cornerRadius=103,
		strokeWidth=106,
		view={}
	}

	RectangleStyle.copyExistingSrcProperties( src.view, src )

	hasPropertyValue( src.view, 'debugOn', src.debugOn )
	hasPropertyValue( src.view, 'width', src.width )
	hasPropertyValue( src.view, 'height', nil )
	hasPropertyValue( src.view, 'anchorX', nil )
	hasPropertyValue( src.view, 'anchorY', nil )
	hasPropertyValue( src.view, 'cornerRadius', nil )
	hasPropertyValue( src.view, 'fillColor', nil )
	hasPropertyValue( src.view, 'strokeColor', nil )
	hasPropertyValue( src.view, 'strokeWidth', src.strokeWidth )

	hasPropertyValue( src.view, 'hitMarginX', nil )

	--== test non-empty destination

	src = {
		debugOn=false,
		hitMarginX=100,
		type='rectangle',
		width=102,
		cornerRadius=104,
		strokeWidth=106,
		view={
			debugOn=true,
			fillColor={10,11,12,13},
			strokeWidth=118,
		}
	}

	RectangleStyle.copyExistingSrcProperties( src.view, src )

	hasPropertyValue( src.view, 'debugOn', true )
	hasPropertyValue( src.view, 'width', src.width )
	hasPropertyValue( src.view, 'height', nil )
	hasPropertyValue( src.view, 'anchorX', nil )
	hasPropertyValue( src.view, 'anchorY', nil )
	hasPropertyValue( src.view, 'cornerRadius', nil )
	hasPropertyValue( src.view, 'fillColor', {10,11,12,13} )
	hasPropertyValue( src.view, 'strokeColor', nil )
	hasPropertyValue( src.view, 'strokeWidth', src.view.strokeWidth )

	hasPropertyValue( src.view, 'hitMarginX', nil )

	--== test non-empty destination, force

	src = {
		debugOn=false,
		type='rectangle',
		hitMarginX=100,
		width=102,
		cornerRadius=104,
		strokeWidth=106,
		view={
			width=111,
			fillColor=114,
			strokeWidth=116,
		}
	}

	RectangleStyle.copyExistingSrcProperties( src.view, src, {force=true} )

	hasPropertyValue( src.view, 'debugOn', src.debugOn )
	hasPropertyValue( src.view, 'width', src.width )
	hasPropertyValue( src.view, 'height', nil )
	hasPropertyValue( src.view, 'anchorX', nil )
	hasPropertyValue( src.view, 'anchorY', nil )
	hasPropertyValue( src.view, 'cornerRadius', nil )
	hasPropertyValue( src.view, 'fillColor', nil )
	hasPropertyValue( src.view, 'strokeColor', nil )
	hasPropertyValue( src.view, 'strokeWidth', src.strokeWidth )

	hasPropertyValue( src.view, 'hitMarginX', nil )

end


function test_verifyStyleProperties()
	-- print( "test_verifyStyleProperties" )
	local BackgroundFactory = dUI.Style.BackgroundFactory
	local RectangleStyle = BackgroundFactory.Rectangle

	local src

	src = {
		debugOn=true,
		width=102,
		height=104,
		anchorX=106,
		anchorY=108,
		fillColor={10,11,12,13},
		strokeColor=110,
		strokeWidth=112
	}
	hasValidStyleProperties( RectangleStyle, src )

	src = {
		debugOn=nil, -- <<
		width=101,
		height=102,
		anchorX=103,
		anchorY=104,
		fillColor={10,11,12,13},
		strokeColor=105,
		strokeWidth=106
	}
	hasInvalidStyleProperties( RectangleStyle, src )

	src = {
		debugOn=true, -- <<
		width=101,
		height=102,
		anchorX=103,
		anchorY=104,
		fillColor=nil, -- <<
		strokeColor=105,
		strokeWidth=106
	}
	hasInvalidStyleProperties( RectangleStyle, src )

end



--====================================================================--
--== Test Class Methods


function test_styleClassBasics()
	-- print( "test_styleClassBasics" )
	local StyleFactory = dUI.Style.BackgroundFactory
	local RectangleStyle = StyleFactory.Rectangle

	local BaseStyle, defaultStyles
	local style

	defaultStyles = RectangleStyle:getDefaultStyleValues()
	BaseStyle = RectangleStyle:getBaseStyle()

	style = StyleFactory.create( dUI.RECTANGLE )

	verifyBackgroundViewStyle( style )
	styleInheritsFrom( style, BaseStyle )

	style:removeSelf()

end


--[[
--]]
function test_clearProperties()
	-- print( "test_clearProperties" )
	local StyleFactory = dUI.Style.BackgroundFactory
	local RectangleStyle = StyleFactory.Rectangle

	local BaseStyle, StyleClass
	local s1, inherit
	local resetEvent, callback


	resetEvent = 0
	callback = function(e)
		if e.type==s1.STYLE_RESET then resetEvent=resetEvent+1 end
	end

	-- by default, style inherits properties from BaseStyle

	s1 = StyleFactory.create( dUI.RECTANGLE )
	s1:addEventListener( s1.EVENT, callback )


	StyleClass = s1.class
	BaseStyle = StyleClass:getBaseStyle()
	assert_equal( StyleClass, RectangleStyle )
	styleInheritsFrom( s1, BaseStyle )

	-- test inherited properties

	styleInheritsPropertyValue( s1, 'fillColor', BaseStyle.fillColor )
	styleInheritsPropertyValue( s1, 'strokeColor', BaseStyle.strokeColor )
	styleInheritsPropertyValue( s1, 'strokeWidth', BaseStyle.strokeWidth )

	-- set some properties, to make local

	local my_fill = {1,1,1}
	s1.fillColor = my_fill
	s1.strokeWidth = 98

	verifyBackgroundViewStyle( s1 )

	styleHasPropertyValue( s1, 'fillColor', my_fill )
	styleInheritsPropertyValue( s1, 'strokeColor', BaseStyle.strokeColor )
	styleHasPropertyValue( s1, 'strokeWidth', 98 )

	--== Clear Properties, with inherit

	resetEvent = 0
	s1:clearProperties()

	styleInheritsFrom( s1, BaseStyle )
	assert_equal( 1, resetEvent, "incorrect count for reset" )

	styleInheritsPropertyValue( s1, 'fillColor', BaseStyle.fillColor )
	styleInheritsPropertyValue( s1, 'strokeColor', BaseStyle.strokeColor )
	styleInheritsPropertyValue( s1, 'strokeWidth', BaseStyle.strokeWidth )

	-- set local properties

	s1.strokeWidth = 98

	--== Break inheritance

	s1.inherit = nil

	verifyBackgroundViewStyle( s1 )
	styleInheritsFrom( s1, BaseStyle )

	-- verify all properties have been copied

	styleInheritsPropertyValue( s1, 'fillColor', BaseStyle.fillColor )
	styleInheritsPropertyValue( s1, 'strokeColor', BaseStyle.strokeColor )
	styleInheritsPropertyValue( s1, 'strokeWidth', BaseStyle.strokeWidth )


	--== Clear Properties, without Inherit

	resetEvent = 0
	s1:clearProperties()

	styleInheritsFrom( s1, BaseStyle )
	assert_equal( 1, resetEvent, "incorrect count for reset" )

	styleInheritsPropertyValue( s1, 'fillColor', BaseStyle.fillColor )
	styleInheritsPropertyValue( s1, 'strokeColor', BaseStyle.strokeColor )
	styleInheritsPropertyValue( s1, 'strokeWidth', BaseStyle.strokeWidth )

end



