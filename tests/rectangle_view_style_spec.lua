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



--====================================================================--
--== Module Testing
--====================================================================--


function suite_setup()

	Widgets._loadBackgroundSupport()

end


--[[
Test to ensure that the correct property values are
copied during initialization
--]]
function test_addMissingProperties()

	local BackgroundFactory = Widgets.Style.BackgroundFactory
	local RectangleStyle = BackgroundFactory.Rectangle


	local src, dest


end


--[[
Test to ensure that the correct property values are
copied during initialization
--]]
function test_copyExistingSrcProperties()
	-- print( "test_copyExistingSrcProperties" )
	local BackgroundFactory = Widgets.Style.BackgroundFactory
	local RectangleStyle = BackgroundFactory.Rectangle

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
		hitMarginX=4,
		type='rectangle',
		width=4,
		cornerRadius=4,
		strokeWidth=2,
		view={
			debugOn=true,
			fillColor=4,
			strokeWidth=6,
		}
	}

	RectangleStyle.copyExistingSrcProperties( src.view, src )

	hasPropertyValue( src.view, 'debugOn', true )
	hasPropertyValue( src.view, 'width', src.width )
	hasPropertyValue( src.view, 'height', nil )
	hasPropertyValue( src.view, 'anchorX', nil )
	hasPropertyValue( src.view, 'anchorY', nil )
	hasPropertyValue( src.view, 'cornerRadius', nil )
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
			fillColor=4,
			strokeWidth=6,
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
	local BackgroundFactory = Widgets.Style.BackgroundFactory
	local RectangleStyle = BackgroundFactory.Rectangle

	local src

	src = {
		debugOn=true,
		width=4,
		height=10,
		anchorX=1,
		anchorY=5,
		fillColor={},
		strokeColor=1,
		strokeWidth=4
	}
	hasValidStyleProperties( RectangleStyle, src )

	src = {
		debugOn=nil, -- <<
		width=4,
		height=10,
		anchorX=1,
		anchorY=5,
		fillColor={},
		strokeColor=1,
		strokeWidth=4
	}
	hasInvalidStyleProperties( RectangleStyle, src )

	src = {
		debugOn=true, -- <<
		width=4,
		height=10,
		anchorX=1,
		anchorY=5,
		fillColor=nil,
		strokeColor=1,
		strokeWidth=4
	}
	hasInvalidStyleProperties( RectangleStyle, src )

end




function test_defaultInheritance()
	print( "test_defaultInheritance" )
	local Background = Widgets.Style.Background
	local StyleFactory = Widgets.Style.BackgroundFactory
	local RectangleStyle = StyleFactory.Rectangle
	local StyleBase

	local s1 = Widgets.newRectangleBackgroundStyle()
	StyleBase = Background:_getBaseStyle( s1.type )

	styleInheritsFrom( s1, StyleBase )
	hasValidStyleProperties( RectangleStyle, s1.view )

end


