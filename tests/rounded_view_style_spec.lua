--====================================================================--
-- Test: Background Widget Views
--====================================================================--

module(..., package.seeall)


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.1.0"



--====================================================================--
--== Imports


local Widgets = require 'lib.dmc_widgets'

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

	Widgets._loadBackgroundSupport()

end


--====================================================================--
--== Test Static Functions


--[[
Test to ensure that the correct property values are
copied during initialization
--]]
function test_addMissingProperties()
	-- print( "test_addMissingProperties" )

	local BackgroundFactory = Widgets.Style.BackgroundFactory
	local RoundedView = BackgroundFactory.Rounded


	local src, dest


end


--[[
Test to ensure that the correct property values are
copied during initialization
--]]
function test_copyExistingSrcProperties()
	-- print( "test_copyExistingSrcProperties" )
	local BackgroundFactory = Widgets.Style.BackgroundFactory
	local RoundedStyle = BackgroundFactory.Rounded

	local src, dest

	--== test empty destination

	src = {
		debugOn=false,
		hitMarginX=4,
		type='rectangle',
		width=4,
		cornerRadius=4,
		strokeWidth=6,
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
		hitMarginX=4,
		type='rectangle',
		width=4,
		cornerRadius=4,
		strokeWidth=2,
		view={
			debugOn=true,
			cornerRadius=1,
			fillColor=4,
			strokeWidth=6,
		}
	}

	RoundedStyle.copyExistingSrcProperties( src.view, src )

	hasPropertyValue( src.view, 'debugOn', true )
	hasPropertyValue( src.view, 'width', src.width )
	hasPropertyValue( src.view, 'height', nil )
	hasPropertyValue( src.view, 'anchorX', nil )
	hasPropertyValue( src.view, 'anchorY', nil )
	hasPropertyValue( src.view, 'cornerRadius', 1 )
	hasPropertyValue( src.view, 'fillColor', 4 )
	hasPropertyValue( src.view, 'strokeColor', nil )
	hasPropertyValue( src.view, 'strokeWidth', 6 )

	hasPropertyValue( src.view, 'hitMarginX', nil )


	--== test non-empty destination, force

	src = {
		debugOn=false,
		type='rectangle',
		hitMarginX=4,
		width=4,
		cornerRadius=4,
		strokeWidth=2,
		view={
			width=12,
			cornerRadius=1,
			fillColor=4,
			strokeWidth=6,
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
	local BackgroundFactory = Widgets.Style.BackgroundFactory
	local RoundedStyle = BackgroundFactory.Rounded

	local src

	src = {
		debugOn=true,
		width=4,
		height=10,
		anchorX=1,
		anchorY=5,
		cornerRadius=5,
		fillColor={},
		strokeColor=1,
		strokeWidth=4
	}
	hasValidStyleProperties( RoundedStyle, src )

	src = {
		debugOn=nil, -- <<
		width=4,
		height=10,
		anchorX=1,
		anchorY=5,
		cornerRadius=5,
		fillColor={},
		strokeColor=1,
		strokeWidth=4
	}
	hasInvalidStyleProperties( RoundedStyle, src )

	src = {
		debugOn=true,
		width=4,
		height=10,
		anchorX=1,
		anchorY=5,
		cornerRadius=nil,
		fillColor=nil,
		strokeColor=1,
		strokeWidth=4
	}
	hasInvalidStyleProperties( RoundedStyle, src )

end



--====================================================================--
--== Test Class Methods


--[[
--]]
function test_styleClassBasics()
	-- print( "test_styleClassBasics" )
	local StyleFactory = Widgets.Style.BackgroundFactory
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

end


--[[
--]]
function test_clearProperties()
	-- print( "test_clearProperties" )
	local StyleFactory = Widgets.Style.BackgroundFactory
	local RoundedStyle = StyleFactory.Rounded

	local StyleBase, StyleClass
	local s1, inherit
	local receivedClearedEvent, callback


	-- by default, style inherits properties from StyleBase

	s1 = StyleFactory.create( 'rounded' )

	StyleClass = s1.class
	StyleBase = StyleClass:getBaseStyle()
	assert_equal( StyleClass, RoundedStyle )
	styleInheritsFrom( s1, StyleBase )

	inherit = StyleBase
	sView, iView = s1.view, inherit.view

	-- test inherited properties

	styleInheritsPropertyValue( s1, 'cornerRadius', inherit.cornerRadius )
	styleInheritsPropertyValue( s1, 'fillColor', inherit.fillColor )
	styleInheritsPropertyValue( s1, 'strokeColor', inherit.strokeColor )
	styleInheritsPropertyValue( s1, 'strokeWidth', inherit.strokeWidth )

	-- set some properties, to make local

	s1.cornerRadius = 99
	s1.strokeWidth = 98

	verifyBackgroundViewStyle( s1 )

	styleHasPropertyValue( s1, 'cornerRadius', 99 )
	styleInheritsPropertyValue( s1, 'fillColor', inherit.fillColor )
	styleInheritsPropertyValue( s1, 'strokeColor', inherit.strokeColor )
	styleHasPropertyValue( s1, 'strokeWidth', 98 )

	--== Clear Properties, with inherit

	receivedClearedEvent = false
	callback = function(e)
		if e.type==s1.STYLE_CLEARED then receivedClearedEvent=true end
	end
	s1:addEventListener( s1.EVENT, callback )

	s1:clearProperties()

	styleInheritsFrom( s1, inherit )
	assert_true( receivedClearedEvent, "missing clear event" )

	styleInheritsPropertyValue( s1, 'cornerRadius', inherit.cornerRadius )
	styleInheritsPropertyValue( s1, 'fillColor', inherit.fillColor )
	styleInheritsPropertyValue( s1, 'strokeColor', inherit.strokeColor )
	styleInheritsPropertyValue( s1, 'strokeWidth', inherit.strokeWidth )

	-- set local properties

	s1.cornerRadius = 99
	s1.strokeWidth = 98

	--== Break inheritance

	s1.inherit = nil

	verifyBackgroundViewStyle( s1 )
	styleInheritsFrom( s1, nil )

	-- verify all properties have been copied

	styleHasPropertyValue( s1, 'cornerRadius', 99 )
	styleHasPropertyValue( s1, 'fillColor', inherit.fillColor )
	styleHasPropertyValue( s1, 'strokeColor', inherit.strokeColor )
	styleHasPropertyValue( s1, 'strokeWidth', 98 )


	--== Clear Properties, without Inherit

	receivedClearedEvent = false
	callback = function(e)
		if e.type==s1.STYLE_CLEARED then receivedClearedEvent=true end
	end
	s1:addEventListener( s1.EVENT, callback )

	s1:clearProperties()

	styleInheritsFrom( s1, nil )
	assert_true( receivedClearedEvent, "missing clear event" )

	styleHasPropertyValue( s1, 'cornerRadius', inherit.cornerRadius )
	styleHasPropertyValue( s1, 'fillColor', inherit.fillColor )
	styleHasPropertyValue( s1, 'strokeColor', inherit.strokeColor )
	styleHasPropertyValue( s1, 'strokeWidth', inherit.strokeWidth )

end

