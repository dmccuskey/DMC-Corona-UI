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



--====================================================================--
--== Support Functions



--====================================================================--
--== Module Testing
--====================================================================--


function suite_setup()

	dUI.Style._loadBackgroundStyleSupport( {mode=dUI.TEST_MODE} )

end


--====================================================================--
--== Test Static Functions


--[[
Test to ensure that the correct property values are
copied during initialization
--]]
--[[
function test_addMissingProperties()
	-- print( "test_addMissingProperties" )
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
		hitMarginX=100,
		type='four',

		debugOn=102,
		anchorX=104,
		width=106,
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
		anchorX=104,
		fontSize=106,
		view = {
			debugOn=112,
			width=114,
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
	local RoundedStyle = BackgroundFactory.Rounded

	local src, dest

	--== test empty destination

	src = {
		debugOn=false,
		hitMarginX=101,
		type='rectangle',
		width=102,
		cornerRadius=104,
		strokeWidth=106,
		view={}
	}

	RoundedStyle.copyExistingSrcProperties( src.view, src )

	hasPropertyValue( src.view, 'debugOn', src.debugOn )
	hasPropertyValue( src.view, 'width', src.width )
	hasPropertyValue( src.view, 'height', nil )
	hasPropertyValue( src.view, 'anchorX', nil )
	hasPropertyValue( src.view, 'anchorY', nil )
	hasPropertyValue( src.view, 'cornerRadius', src.cornerRadius )
	hasPropertyValue( src.view, 'fillColor', nil )
	hasPropertyValue( src.view, 'strokeColor', nil )
	hasPropertyValue( src.view, 'strokeWidth', src.strokeWidth )

	hasPropertyValue( src.view, 'hitMarginX', nil )


	--== test non-empty destination

	src = {
		debugOn=false,
		hitMarginX=102,
		type='rectangle',
		width=104,
		cornerRadius=106,
		strokeWidth=108,
		view={
			debugOn=true,
			cornerRadius=112,
			fillColor={101,102,103,104},
			strokeWidth=116,
		}
	}

	RoundedStyle.copyExistingSrcProperties( src.view, src )

	hasPropertyValue( src.view, 'debugOn', true )
	hasPropertyValue( src.view, 'width', src.width )
	hasPropertyValue( src.view, 'height', nil )
	hasPropertyValue( src.view, 'anchorX', nil )
	hasPropertyValue( src.view, 'anchorY', nil )
	hasPropertyValue( src.view, 'cornerRadius', 112 )
	hasPropertyValue( src.view, 'fillColor', {101,102,103,104} )
	hasPropertyValue( src.view, 'strokeColor', nil )
	hasPropertyValue( src.view, 'strokeWidth', 116 )

	hasPropertyValue( src.view, 'hitMarginX', nil )


	--== test non-empty destination, force

	src = {
		debugOn=false,
		type='rectangle',
		hitMarginX=102,
		width=104,
		cornerRadius=106,
		strokeWidth=18,
		view={
			width=112,
			cornerRadius=114,
			fillColor={101,102,103,104},
			strokeWidth=118,
		}
	}

	RoundedStyle.copyExistingSrcProperties( src.view, src, {force=true} )

	hasPropertyValue( src.view, 'debugOn', src.debugOn )
	hasPropertyValue( src.view, 'width', src.width )
	hasPropertyValue( src.view, 'height', nil )
	hasPropertyValue( src.view, 'anchorX', nil )
	hasPropertyValue( src.view, 'anchorY', nil )
	hasPropertyValue( src.view, 'cornerRadius', src.cornerRadius )
	hasPropertyValue( src.view, 'fillColor', nil )
	hasPropertyValue( src.view, 'strokeColor', nil )
	hasPropertyValue( src.view, 'strokeWidth', src.strokeWidth )

	hasPropertyValue( src.view, 'hitMarginX', nil )

end


function test_verifyStyleProperties()
	-- print( "test_verifyStyleProperties" )
	local BackgroundFactory = dUI.Style.BackgroundFactory
	local RoundedStyle = BackgroundFactory.Rounded

	local src

	src = {
		debugOn=true,
		width=102,
		height=104,
		anchorX=106,
		anchorY=108,
		cornerRadius=112,
		fillColor={101,102,103,104},
		strokeColor=114,
		strokeWidth=116
	}
	hasValidStyleProperties( RoundedStyle, src )

	src = {
		debugOn=nil, -- <<
		width=102,
		height=103,
		anchorX=104,
		anchorY=105,
		cornerRadius=106,
		fillColor={101,102,103,104},
		strokeColor=18,
		strokeWidth=110
	}
	hasInvalidStyleProperties( RoundedStyle, src )

	src = {
		debugOn=true,
		width=102,
		height=104,
		anchorX=106,
		anchorY=108,
		cornerRadius=nil, -- <<
		fillColor=nil,
		strokeColor=110,
		strokeWidth=112
	}
	hasInvalidStyleProperties( RoundedStyle, src )

end



--====================================================================--
--== Test Class Methods


--[[
--]]
function test_styleClassBasics()
	-- print( "test_styleClassBasics" )
	local StyleFactory = dUI.Style.BackgroundFactory
	local RoundedView = StyleFactory.Rounded

	local Default = RoundedView:getDefaultStyleValues()
	local BaseStyle, style

	BaseStyle = RoundedView:getBaseStyle()
	TestUtils.verifyBackgroundViewStyle( BaseStyle )

	-- check properties initialized to the default values

	styleHasPropertyValue( BaseStyle, 'debugOn', Default.debugOn )
	styleHasPropertyValue( BaseStyle, 'width', Default.width )
	styleHasPropertyValue( BaseStyle, 'height', Default.height )
	styleHasPropertyValue( BaseStyle, 'anchorX', Default.anchorX )
	styleHasPropertyValue( BaseStyle, 'anchorY', Default.anchorY )

	styleHasPropertyValue( BaseStyle, 'cornerRadius', Default.cornerRadius )
	styleHasPropertyValue( BaseStyle, 'fillColor', Default.fillColor )
	styleHasPropertyValue( BaseStyle, 'strokeColor', Default.strokeColor )
	styleHasPropertyValue( BaseStyle, 'strokeWidth', Default.strokeWidth )


	style = StyleFactory.create( dUI.ROUNDED )

	verifyBackgroundViewStyle( style )
	styleInheritsFrom( style, BaseStyle )

	style:removeSelf()


end


--[[
--]]
function test_clearProperties()
	-- print( "test_clearProperties" )
	local StyleFactory = dUI.Style.BackgroundFactory
	local RoundedStyle = StyleFactory.Rounded

	local BaseStyle, StyleClass
	local s1, inherit
	local resetEvent, callback


	resetEvent = 0
	callback = function(e)
		if e.type==s1.STYLE_RESET then resetEvent=resetEvent+1 end
	end


	-- by default, style inherits properties from BaseStyle

	s1 = StyleFactory.create( dUI.ROUNDED )
	s1:addEventListener( s1.EVENT, callback )


	StyleClass = s1.class
	BaseStyle = StyleClass:getBaseStyle()
	assert_equal( StyleClass, RoundedStyle )
	styleInheritsFrom( s1, BaseStyle )

	-- test inherited properties

	styleInheritsPropertyValue( s1, 'cornerRadius', BaseStyle.cornerRadius )
	styleInheritsPropertyValue( s1, 'fillColor', BaseStyle.fillColor )
	styleInheritsPropertyValue( s1, 'strokeColor', BaseStyle.strokeColor )
	styleInheritsPropertyValue( s1, 'strokeWidth', BaseStyle.strokeWidth )

	-- set some properties, to make local

	s1.cornerRadius = 99
	s1.strokeWidth = 98

	verifyBackgroundViewStyle( s1 )

	styleHasPropertyValue( s1, 'cornerRadius', 99 )
	styleInheritsPropertyValue( s1, 'fillColor', BaseStyle.fillColor )
	styleInheritsPropertyValue( s1, 'strokeColor', BaseStyle.strokeColor )
	styleHasPropertyValue( s1, 'strokeWidth', 98 )

	--== Clear Properties, with inherit

	resetEvent = 0
	s1:clearProperties()

	styleInheritsFrom( s1, BaseStyle )
	assert_equal( 1, resetEvent, "incorrect count for reset" )

	styleInheritsPropertyValue( s1, 'cornerRadius', BaseStyle.cornerRadius )
	styleInheritsPropertyValue( s1, 'fillColor', BaseStyle.fillColor )
	styleInheritsPropertyValue( s1, 'strokeColor', BaseStyle.strokeColor )
	styleInheritsPropertyValue( s1, 'strokeWidth', BaseStyle.strokeWidth )

	-- set local properties

	s1.cornerRadius = 99
	s1.strokeWidth = 98

	--== Break inheritance

	s1.inherit = nil

	verifyBackgroundViewStyle( s1 )
	styleInheritsFrom( s1, BaseStyle )

	-- verify all properties have been copied

	styleInheritsPropertyValue( s1, 'cornerRadius', BaseStyle.cornerRadius )
	styleInheritsPropertyValue( s1, 'fillColor', BaseStyle.fillColor )
	styleInheritsPropertyValue( s1, 'strokeColor', BaseStyle.strokeColor )
	styleInheritsPropertyValue( s1, 'strokeWidth', BaseStyle.strokeWidth )


	--== Clear Properties, without Inherit

	resetEvent = 0
	s1:clearProperties()

	styleInheritsFrom( s1, BaseStyle )
	assert_equal( 1, resetEvent, "incorrect count for reset" )

	styleInheritsPropertyValue( s1, 'cornerRadius', BaseStyle.cornerRadius )
	styleInheritsPropertyValue( s1, 'fillColor', BaseStyle.fillColor )
	styleInheritsPropertyValue( s1, 'strokeColor', BaseStyle.strokeColor )
	styleInheritsPropertyValue( s1, 'strokeWidth', BaseStyle.strokeWidth )

end

