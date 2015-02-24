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



--[[
--]]
function test_clearProperties()
	-- print( "test_clearProperties" )
	local StyleFactory = Widgets.Style.BackgroundFactory
	local RectangleStyle = StyleFactory.Rectangle

	local StyleBase, StyleClass
	local s1, inherit
	local receivedClearedEvent, callback


	-- by default, style inherits properties from StyleBase

	s1 = StyleFactory.create( 'rectangle' )

	StyleClass = s1.class
	StyleBase = StyleClass:getBaseStyle()
	assert_equal( StyleClass, RectangleStyle )
	styleInheritsFrom( s1, StyleBase )

	inherit = StyleBase
	sView, iView = s1.view, inherit.view

	-- test inherited properties

	styleInheritsPropertyValue( s1, 'fillColor', inherit.fillColor )
	styleInheritsPropertyValue( s1, 'strokeColor', inherit.strokeColor )
	styleInheritsPropertyValue( s1, 'strokeWidth', inherit.strokeWidth )

	-- set some properties, to make local

	local my_fill = {1,1,1}
	s1.fillColor = my_fill
	s1.strokeWidth = 98

	verifyBackgroundViewStyle( s1 )

	styleHasPropertyValue( s1, 'fillColor', my_fill )
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

	styleInheritsPropertyValue( s1, 'fillColor', inherit.fillColor )
	styleInheritsPropertyValue( s1, 'strokeColor', inherit.strokeColor )
	styleInheritsPropertyValue( s1, 'strokeWidth', inherit.strokeWidth )

	-- set local properties

	s1.strokeWidth = 98

	--== Break inheritance

	s1.inherit = nil

	verifyBackgroundViewStyle( s1 )
	styleInheritsFrom( s1, nil )

	-- verify all properties have been copied

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

	styleHasPropertyValue( s1, 'fillColor', inherit.fillColor )
	styleHasPropertyValue( s1, 'strokeColor', inherit.strokeColor )
	styleHasPropertyValue( s1, 'strokeWidth', inherit.strokeWidth )

end



