
--====================================================================--
-- Test: Text Widget
--====================================================================--

module(..., package.seeall)


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.1.0"



--====================================================================--
--== Imports


local Widgets = require 'lib.dmc_widgets'

local TestUtils = require 'tests.test_utils'
local Utils = require 'tests.test_utils'



--====================================================================--
--== Setup, Constants


local W, H = display.contentWidth, display.contentHeight
local H_CENTER, V_CENTER = W*0.5, H*0.5


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



--====================================================================--
--== Support Functions



--====================================================================--
--== Module Testing
--====================================================================--


function suite_setup()

	Widgets._loadTextSupport()

end



--====================================================================--
--== Test Static Functions


--[[
Test to ensure that the correct property values are
copied during initialization
--]]
function test_addMissingProperties()
	-- print( "test_addMissingProperties" )
	local TextStyle = Widgets.Style.Text

	local src, dest


	--== test empty destination

	--== test non-empty destination


end



--[[
Test to ensure that the correct property values are
copied during initialization
--]]
function test_copyExistingSrcProperties()
	print( "test_copyExistingSrcProperties" )
	local TextStyle = Widgets.Style.Text

	local src, dest

	--== test empty destination

	src = {
		debugOn=false,

		hitMarginX=4,
		type='rectangle',
		width=4,

		align='right',
		fontSize=4,
		strokeColor={0,0,1},
		textColor={0,1,0},

		label = {}
	}

	TextStyle.copyExistingSrcProperties( src.label, src )

	hasPropertyValue( src.label, 'debugOn', src.debugOn )
	hasPropertyValue( src.label, 'width', src.width )
	hasPropertyValue( src.label, 'height', nil )
	hasPropertyValue( src.label, 'anchorX', nil )
	hasPropertyValue( src.label, 'anchorY', nil )
	hasPropertyValue( src.label, 'align', src.align )
	hasPropertyValue( src.label, 'fillColor', nil )
	hasPropertyValue( src.label, 'font', nil )
	hasPropertyValue( src.label, 'fontSize', src.fontSize )
	hasPropertyValue( src.label, 'marginX', nil )
	hasPropertyValue( src.label, 'marginY', nil )
	hasPropertyValue( src.label, 'strokeColor', src.strokeColor )
	hasPropertyValue( src.label, 'strokeWidth', nil )
	hasPropertyValue( src.label, 'textColor', src.textColor )

	hasPropertyValue( src.label, 'hitMarginX', nil )
	hasPropertyValue( src.label, 'type', nil )


	--== test non-empty destination

	src = {
		debugOn=false,

		hitMarginX=4,
		type='rectangle',
		width=4,

		align='right',
		fontSize=4,
		marginX=0,
		strokeColor={0,0,1},
		textColor={0,1,0},

		label = {
			fontSize=24,
			marginX=10,
			height=10
		}
	}

	TextStyle.copyExistingSrcProperties( src.label, src )

	hasPropertyValue( src.label, 'debugOn', src.debugOn )
	hasPropertyValue( src.label, 'width', src.width )
	hasPropertyValue( src.label, 'height', 10 )
	hasPropertyValue( src.label, 'anchorX', nil )
	hasPropertyValue( src.label, 'anchorY', nil )
	hasPropertyValue( src.label, 'align', src.align )
	hasPropertyValue( src.label, 'fillColor', nil )
	hasPropertyValue( src.label, 'font', nil )
	hasPropertyValue( src.label, 'fontSize', 24 )
	hasPropertyValue( src.label, 'marginX', 10 )
	hasPropertyValue( src.label, 'marginY', nil )
	hasPropertyValue( src.label, 'strokeColor', src.strokeColor )
	hasPropertyValue( src.label, 'strokeWidth', nil )
	hasPropertyValue( src.label, 'textColor', src.textColor )

	hasPropertyValue( src.label, 'hitMarginX', nil )
	hasPropertyValue( src.label, 'type', nil )


	--== test non-empty destination, force

	src = {
		debugOn=false,

		hitMarginX=4,
		type='rectangle',
		width=4,

		align='right',
		fontSize=4,
		marginX=0,
		strokeColor={0,0,1},
		textColor={0,1,0},

		label = {
			fontSize=24,
			marginX=10,
			height=10
		}
	}

	TextStyle.copyExistingSrcProperties( src.label, src, {force=true} )

	hasPropertyValue( src.label, 'debugOn', src.debugOn )
	hasPropertyValue( src.label, 'width', src.width )
	hasPropertyValue( src.label, 'height', nil )
	hasPropertyValue( src.label, 'anchorX', nil )
	hasPropertyValue( src.label, 'anchorY', nil )
	hasPropertyValue( src.label, 'align', src.align )
	hasPropertyValue( src.label, 'fillColor', nil )
	hasPropertyValue( src.label, 'font', nil )
	hasPropertyValue( src.label, 'fontSize', src.fontSize )
	hasPropertyValue( src.label, 'marginX', src.marginX )
	hasPropertyValue( src.label, 'marginY', nil )
	hasPropertyValue( src.label, 'strokeColor', src.strokeColor )
	hasPropertyValue( src.label, 'strokeWidth', nil )
	hasPropertyValue( src.label, 'textColor', src.textColor )

	hasPropertyValue( src.label, 'hitMarginX', nil )
	hasPropertyValue( src.label, 'type', nil )

end


function test_verifyStyleProperties()
	-- print( "test_verifyStyleProperties" )
	local Text = Widgets.Style.Text

	local src

	src = {
		debugOn=true,
		width=4,
		height=nil,
		anchorX=1,
		anchorY=5,

		align='right',
		fillColor={1,1,0},
		font=native.systemFont,
		fontSize=5,
		marginX=15,
		marginY=4,
		strokeColor={1,1,1},
		strokeWidth=4,
		textColor={0.5,1,1}
	}
	hasValidStyleProperties( Text, src )

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
	hasInvalidStyleProperties( Text, src )

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
	hasInvalidStyleProperties( Text, src )

end



--====================================================================--
--== Test Class Methods


function test_styleClassBasics()
	-- print( "test_styleClassBasics" )
	local Text = Widgets.Style.Text
	local BaseStyle, style
	local Default = Text:getDefaultStyleValues()

	BaseStyle = Text:getBaseStyle()
	TestUtils.verifyTextStyle( BaseStyle )

	-- check properties initialized to the default values

	styleHasPropertyValue( BaseStyle, 'debugOn', Default.debugOn )
	--[[
	-- width/height can be nil
	-- styleHasPropertyValue( BaseStyle, 'width', Default.width )
	-- styleHasPropertyValue( BaseStyle, 'height', Default.height )
	--]]
	styleHasPropertyValue( BaseStyle, 'anchorX', Default.anchorX )
	styleHasPropertyValue( BaseStyle, 'anchorY', Default.anchorY )
	styleHasPropertyValue( BaseStyle, 'align', Default.align )
	styleHasPropertyValue( BaseStyle, 'fillColor', Default.fillColor )
	styleHasPropertyValue( BaseStyle, 'font', Default.font )
	styleHasPropertyValue( BaseStyle, 'fontSize', Default.fontSize )
	styleHasPropertyValue( BaseStyle, 'marginX', Default.marginX )
	styleHasPropertyValue( BaseStyle, 'marginY', Default.marginY )
	styleHasPropertyValue( BaseStyle, 'textColor', Default.textColor )

	-- verify a new text style

	style = Widgets.newTextStyle()
	TestUtils.verifyTextStyle( style )

end



--[[
--]]
function test_clearProperties()
	-- print( "test_clearProperties" )
	local Text = Widgets.Style.Text

	local StyleBase, StyleClass
	local s1, inherit
	local receivedClearedEvent, callback


	-- by default, style inherits properties from StyleBase

	s1 = Widgets.newTextStyle()

	StyleClass = s1.class
	StyleBase = StyleClass:getBaseStyle()
	assert_equal( StyleClass, Text )
	styleInheritsFrom( s1, StyleBase )

	inherit = StyleBase

	-- test inherited properties

	styleInheritsPropertyValue( s1, 'align', inherit.align )
	styleInheritsPropertyValue( s1, 'fillColor', inherit.fillColor )
	styleInheritsPropertyValue( s1, 'font', inherit.font )
	styleInheritsPropertyValue( s1, 'fontSize', inherit.fontSize )
	styleInheritsPropertyValue( s1, 'marginX', inherit.marginX )
	styleInheritsPropertyValue( s1, 'marginY', inherit.marginY )
	styleInheritsPropertyValue( s1, 'strokeColor', inherit.strokeColor )
	styleInheritsPropertyValue( s1, 'strokeWidth', inherit.strokeWidth )
	styleInheritsPropertyValue( s1, 'textColor', inherit.textColor )

	-- set some properties, to make local

	s1.align = 'left'
	s1.marginX = 99

	verifyTextStyle( s1 )

	styleHasPropertyValue( s1, 'align', 'left' )
	styleInheritsPropertyValue( s1, 'fillColor', inherit.fillColor )
	styleInheritsPropertyValue( s1, 'font', inherit.font )
	styleInheritsPropertyValue( s1, 'fontSize', inherit.fontSize )
	styleHasPropertyValue( s1, 'marginX', 99 )
	styleInheritsPropertyValue( s1, 'marginY', inherit.marginY )
	styleInheritsPropertyValue( s1, 'strokeColor', inherit.strokeColor )
	styleInheritsPropertyValue( s1, 'strokeWidth', inherit.strokeWidth )
	styleInheritsPropertyValue( s1, 'textColor', inherit.textColor )


	--== Clear Properties, with inherit

	receivedClearedEvent = false
	callback = function(e)
		if e.type==s1.STYLE_CLEARED then receivedClearedEvent=true end
	end
	s1:addEventListener( s1.EVENT, callback )

	s1:clearProperties()

	styleInheritsFrom( s1, inherit )
	assert_true( receivedClearedEvent, "missing clear event" )

	styleInheritsPropertyValue( s1, 'align', inherit.align )
	styleInheritsPropertyValue( s1, 'fillColor', inherit.fillColor )
	styleInheritsPropertyValue( s1, 'font', inherit.font )
	styleInheritsPropertyValue( s1, 'fontSize', inherit.fontSize )
	styleInheritsPropertyValue( s1, 'marginX', inherit.marginX )
	styleInheritsPropertyValue( s1, 'marginY', inherit.marginY )
	styleInheritsPropertyValue( s1, 'strokeColor', inherit.strokeColor )
	styleInheritsPropertyValue( s1, 'strokeWidth', inherit.strokeWidth )
	styleInheritsPropertyValue( s1, 'textColor', inherit.textColor )

	-- set local properties

	s1.align = 'left'
	s1.marginX = 99

	--== Break inheritance

	s1.inherit = nil

	verifyTextStyle( s1 )
	styleInheritsFrom( s1, nil )

	-- verify all properties have been copied

	styleHasPropertyValue( s1, 'align', 'left' )
	styleHasPropertyValue( s1, 'fillColor', inherit.fillColor )
	styleHasPropertyValue( s1, 'font', inherit.font )
	styleHasPropertyValue( s1, 'fontSize', inherit.fontSize )
	styleHasPropertyValue( s1, 'marginX', 99 )
	styleHasPropertyValue( s1, 'marginY', inherit.marginY )
	styleHasPropertyValue( s1, 'strokeColor', inherit.strokeColor )
	styleHasPropertyValue( s1, 'strokeWidth', inherit.strokeWidth )
	styleHasPropertyValue( s1, 'textColor', inherit.textColor )


	--== Clear Properties, without Inherit

	receivedClearedEvent = false
	callback = function(e)
		if e.type==s1.STYLE_CLEARED then receivedClearedEvent=true end
	end
	s1:addEventListener( s1.EVENT, callback )

	s1:clearProperties()

	styleInheritsFrom( s1, nil )
	assert_true( receivedClearedEvent, "missing clear event" )

	styleHasPropertyValue( s1, 'align', inherit.align )
	styleHasPropertyValue( s1, 'fillColor', inherit.fillColor )
	styleHasPropertyValue( s1, 'font', inherit.font )
	styleHasPropertyValue( s1, 'fontSize', inherit.fontSize )
	styleHasPropertyValue( s1, 'marginX', inherit.marginX )
	styleHasPropertyValue( s1, 'marginY', inherit.marginY )
	styleHasPropertyValue( s1, 'strokeColor', inherit.strokeColor )
	styleHasPropertyValue( s1, 'strokeWidth', inherit.strokeWidth )
	styleHasPropertyValue( s1, 'textColor', inherit.textColor )

end

