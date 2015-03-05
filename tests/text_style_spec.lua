
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
local Utils = require 'dmc_utils'



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


local marker = TestUtils.outputMarker



--====================================================================--
--== Support Functions



--====================================================================--
--== Module Testing
--====================================================================--


function suite_setup()

	Widgets._loadTextSupport( {mode='test'} )

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
	local TextStyle = Widgets.Style.Text
	local defaults = TextStyle:getDefaultStyleValues()
	local srcs, src, base, dest, label


	--== test empty base, empty source, empty destination

	src = {
		label = {}
	}
	label = src.label

	TextStyle.addMissingDestProperties( label, {parent=src} )

	hasPropertyValue( label, 'debugOn', defaults.debugOn )
	hasPropertyValue( label, 'width', defaults.width )
	hasPropertyValue( label, 'height', defaults.height )
	hasPropertyValue( label, 'anchorX', defaults.anchorX )
	hasPropertyValue( label, 'anchorY', defaults.anchorY )

	hasPropertyValue( label, 'align', defaults.align )
	hasPropertyValue( label, 'fillColor', defaults.fillColor )
	hasPropertyValue( label, 'font', defaults.font )
	hasPropertyValue( label, 'fontSize', defaults.fontSize )
	hasPropertyValue( label, 'marginX', defaults.marginX )
	hasPropertyValue( label, 'marginY', defaults.marginY )
	hasPropertyValue( label, 'strokeColor', defaults.strokeColor )
	hasPropertyValue( label, 'strokeWidth', defaults.strokeWidth )
	hasPropertyValue( label, 'textColor', defaults.textColor )


	--== test partial base, partial source, partial destination

	src = {
		width=200,
		debugOn=202,
		anchorX=210,
		anchorY=212,
		fontSize=220,
		label = {
			debugOn=300,
			anchorY=302,
			marginX=306,
			textColor={304,304,305,306},
		}
	}
	label = src.label

	TextStyle.addMissingDestProperties( label, {parent=src} )

	hasPropertyValue( label, 'debugOn', label.debugOn )
	hasPropertyValue( label, 'width', defaults.width )
	hasPropertyValue( label, 'height', nil )
	hasPropertyValue( label, 'anchorX', defaults.anchorX )
	hasPropertyValue( label, 'anchorY', label.anchorY )

	hasPropertyValue( label, 'align', defaults.align )
	hasPropertyValue( label, 'fillColor', defaults.fillColor )
	hasPropertyValue( label, 'font', defaults.font )
	hasPropertyValue( label, 'fontSize', defaults.fontSize )
	hasPropertyValue( label, 'marginX', label.marginX )
	hasPropertyValue( label, 'marginY', defaults.marginY )
	hasPropertyValue( label, 'strokeColor', defaults.strokeColor )
	hasPropertyValue( label, 'strokeWidth', defaults.strokeWidth )
	hasPropertyValue( label, 'textColor', label.textColor )

	hasPropertyValue( label, 'hitMarginX', nil )
	hasPropertyValue( label, 'type', nil )

end
--]]



--[[
Test to ensure that the correct property values are
copied during initialization
--]]
function test_copyExistingSrcProperties()
	-- print( "test_copyExistingSrcProperties" )
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


--[[
--]]
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
		fillColor={4,5,6},
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



function test_prepareData_minimal()

	local Text = Widgets.Style.Text
	local BaseStyle = Text:getBaseStyle()

	local dataSrc = {
		width=101,
		height=102,
		anchorX=103,
		anchorY=104,
		align='center-left',
		fillColor={101,102,103,106},
		font=100,
		fontSize=101,
		marginX=102,
		marginY=103,
		textColor={101,102,103,106},
	}
	local src

	src = {
		fontSize=54,
		marginX=55,
		height=56
	}

	-- minimal
	src = Text:_prepareData( src, dataSrc )

	hasPropertyValue( src, 'width', nil )
	hasPropertyValue( src, 'height', 56 )
	hasPropertyValue( src, 'anchorX', nil )
	hasPropertyValue( src, 'anchorY', nil )
	hasPropertyValue( src, 'align', nil )
	hasPropertyValue( src, 'fillColor', nil )
	hasPropertyValue( src, 'font', nil )
	hasPropertyValue( src, 'fontSize', 54 )
	hasPropertyValue( src, 'marginX', 55 )
	hasPropertyValue( src, 'marginY', nil )
	hasPropertyValue( src, 'textColor', nil )


	src = {
		fontSize=54,
		marginX=55,
		height=56
	}

	-- whole thing, using Base
	src = Text:_prepareData( src, nil )

	hasPropertyValue( src, 'width', nil )
	hasPropertyValue( src, 'height', 56 )
	hasPropertyValue( src, 'anchorX', nil )
	hasPropertyValue( src, 'anchorY', nil )
	hasPropertyValue( src, 'align', nil )
	hasPropertyValue( src, 'fillColor', nil )
	hasPropertyValue( src, 'font', nil )
	hasPropertyValue( src, 'fontSize', 54 )
	hasPropertyValue( src, 'marginX', 55 )
	hasPropertyValue( src, 'marginY', nil )
	hasPropertyValue( src, 'textColor', nil )

end



--[[
--]]
function test_styleClassBasics()
	-- print( "test_styleClassBasics" )
	local Text = Widgets.Style.Text
	local BaseStyle, defaultStyles
	local style

	defaultStyles = Text:getDefaultStyleValues()
	BaseStyle = Text:getBaseStyle()

	TestUtils.verifyTextStyle( BaseStyle )
	styleInheritsFrom( BaseStyle, BaseStyle.NO_INHERIT )

	-- check properties initialized to the default values

	styleHasPropertyValue( BaseStyle, 'debugOn', defaultStyles.debugOn )
	-- width/height can be nil
	hasPropertyValue( BaseStyle, 'width', defaultStyles.width )
	hasPropertyValue( BaseStyle, 'height', defaultStyles.height )
	styleHasPropertyValue( BaseStyle, 'anchorX', defaultStyles.anchorX )
	styleHasPropertyValue( BaseStyle, 'anchorY', defaultStyles.anchorY )
	styleHasPropertyValue( BaseStyle, 'align', defaultStyles.align )
	styleHasPropertyValue( BaseStyle, 'fillColor', defaultStyles.fillColor )
	styleHasPropertyValue( BaseStyle, 'font', defaultStyles.font )
	styleHasPropertyValue( BaseStyle, 'fontSize', defaultStyles.fontSize )
	styleHasPropertyValue( BaseStyle, 'marginX', defaultStyles.marginX )
	styleHasPropertyValue( BaseStyle, 'marginY', defaultStyles.marginY )
	styleHasPropertyValue( BaseStyle, 'textColor', defaultStyles.textColor )


	--== Create a new text style

	style = Widgets.newTextStyle()

	TestUtils.verifyTextStyle( style )
	styleInheritsFrom( style, BaseStyle )

	styleInheritsPropertyValue( style, 'debugOn', defaultStyles.debugOn )
	-- width/height can be nil
	styleInheritsPropertyValue( style, 'width', defaultStyles.width )
	styleInheritsPropertyValue( style, 'height', defaultStyles.height )
	styleInheritsPropertyValue( style, 'anchorX', defaultStyles.anchorX )
	styleInheritsPropertyValue( style, 'anchorY', defaultStyles.anchorY )
	styleInheritsPropertyValue( style, 'align', defaultStyles.align )
	styleInheritsPropertyValue( style, 'fillColor', defaultStyles.fillColor )
	styleInheritsPropertyValue( style, 'font', defaultStyles.font )
	styleInheritsPropertyValue( style, 'fontSize', defaultStyles.fontSize )
	styleInheritsPropertyValue( style, 'marginX', defaultStyles.marginX )
	styleInheritsPropertyValue( style, 'marginY', defaultStyles.marginY )
	styleInheritsPropertyValue( style, 'textColor', defaultStyles.textColor )

	style:removeSelf()

	--== Create a new text style

	style = Widgets.newTextStyle{
		debugOn=true,
		height=12,
		fontSize=99
	}

	TestUtils.verifyTextStyle( style )
	styleInheritsFrom( style, BaseStyle )

	styleHasPropertyValue( style, 'debugOn', true )
	styleInheritsPropertyValue( style, 'width', defaultStyles.width )
	styleHasPropertyValue( style, 'height', 12 )
	styleInheritsPropertyValue( style, 'anchorX', defaultStyles.anchorX )
	styleInheritsPropertyValue( style, 'anchorY', defaultStyles.anchorY )
	styleInheritsPropertyValue( style, 'align', defaultStyles.align )
	styleInheritsPropertyValue( style, 'fillColor', defaultStyles.fillColor )
	styleInheritsPropertyValue( style, 'font', defaultStyles.font )
	styleHasPropertyValue( style, 'fontSize', 99 )
	styleInheritsPropertyValue( style, 'marginX', defaultStyles.marginX )
	styleInheritsPropertyValue( style, 'marginY', defaultStyles.marginY )
	styleInheritsPropertyValue( style, 'textColor', defaultStyles.textColor )

	style:removeSelf()

end


function test_copyStyle()

	local Text = Widgets.Style.Text
	local BaseStyle = Text:getBaseStyle()
	local style, copy

	style = BaseStyle
	copy = style:copyStyle()

	styleInheritsPropertyValue( copy, 'width', BaseStyle.width )
	styleInheritsPropertyValue( copy, 'height', BaseStyle.height )
	styleInheritsPropertyValue( copy, 'anchorX', BaseStyle.anchorX )
	styleInheritsPropertyValue( copy, 'anchorY', BaseStyle.anchorY )
	styleInheritsPropertyValue( copy, 'align', BaseStyle.align )
	styleInheritsPropertyValue( copy, 'fillColor', BaseStyle.fillColor )
	styleInheritsPropertyValue( copy, 'font', BaseStyle.font )
	styleInheritsPropertyValue( copy, 'fontSize', BaseStyle.fontSize )
	styleInheritsPropertyValue( copy, 'marginX', BaseStyle.marginX )
	styleInheritsPropertyValue( copy, 'marginY', BaseStyle.marginY )
	styleInheritsPropertyValue( copy, 'textColor', BaseStyle.textColor )


	style = Widgets.newTextStyle{
		width=10,
		height=100,
		fontSize=100,
		marginX=20,
	}

	copy = style:copyStyle()

	styleInheritsPropertyValue( copy, 'width', style.width )
	styleInheritsPropertyValue( copy, 'height', style.height )
	styleInheritsPropertyValue( copy, 'anchorX', BaseStyle.anchorX )
	styleInheritsPropertyValue( copy, 'anchorY', BaseStyle.anchorY )
	styleInheritsPropertyValue( copy, 'align', BaseStyle.align )
	styleInheritsPropertyValue( copy, 'fillColor', BaseStyle.fillColor )
	styleInheritsPropertyValue( copy, 'font', BaseStyle.font )
	styleInheritsPropertyValue( copy, 'fontSize', style.fontSize )
	styleInheritsPropertyValue( copy, 'marginX', style.marginX )
	styleInheritsPropertyValue( copy, 'marginY', BaseStyle.marginY )
	styleInheritsPropertyValue( copy, 'textColor', BaseStyle.textColor )

end




--[[
--]]
function test_clearPropertiesWithoutInherit()
	-- print( "test_clearPropertiesWithoutInherit" )
	local Text = Widgets.Style.Text

	local StyleBase, StyleClass
	local s1, inherit
	local receivedClearedEvent, callback


	-- by default, style has no inheritance

	s1 = Widgets.newTextStyle()

	StyleClass = s1.class
	StyleBase = StyleClass:getBaseStyle()

	assert_equal( StyleClass, Text )
	styleInheritsFrom( s1, StyleBase )

	-- test inherited properties

	styleInheritsPropertyValue( s1, 'align', StyleBase.align )
	styleInheritsPropertyValue( s1, 'fillColor', StyleBase.fillColor )
	styleInheritsPropertyValue( s1, 'font', StyleBase.font )
	styleInheritsPropertyValue( s1, 'fontSize', StyleBase.fontSize )
	styleInheritsPropertyValue( s1, 'marginX', StyleBase.marginX )
	styleInheritsPropertyValue( s1, 'marginY', StyleBase.marginY )
	styleInheritsPropertyValue( s1, 'strokeColor', StyleBase.strokeColor )
	styleInheritsPropertyValue( s1, 'strokeWidth', StyleBase.strokeWidth )
	styleInheritsPropertyValue( s1, 'textColor', StyleBase.textColor )

	-- set some properties, to make local

	s1.align = 'left'
	s1.marginX = 99

	verifyTextStyle( s1 )

	styleHasPropertyValue( s1, 'align', 'left' )
	styleInheritsPropertyValue( s1, 'fillColor', StyleBase.fillColor )
	styleInheritsPropertyValue( s1, 'font', StyleBase.font )
	styleInheritsPropertyValue( s1, 'fontSize', StyleBase.fontSize )
	styleHasPropertyValue( s1, 'marginX', 99 )
	styleInheritsPropertyValue( s1, 'marginY', StyleBase.marginY )
	styleInheritsPropertyValue( s1, 'strokeColor', StyleBase.strokeColor )
	styleInheritsPropertyValue( s1, 'strokeWidth', StyleBase.strokeWidth )
	styleInheritsPropertyValue( s1, 'textColor', StyleBase.textColor )


	--== Clear Properties, with inherit

	receivedClearedEvent = false
	callback = function(e)
		if e.type==s1.STYLE_RESET then receivedClearedEvent=true end
	end
	s1:addEventListener( s1.EVENT, callback )

	s1:clearProperties()

	styleInheritsFrom( s1, StyleBase )
	assert_true( receivedClearedEvent, "missing clear event" )

	styleInheritsPropertyValue( s1, 'align', StyleBase.align )
	styleInheritsPropertyValue( s1, 'fillColor', StyleBase.fillColor )
	styleInheritsPropertyValue( s1, 'font', StyleBase.font )
	styleInheritsPropertyValue( s1, 'fontSize', StyleBase.fontSize )
	styleInheritsPropertyValue( s1, 'marginX', StyleBase.marginX )
	styleInheritsPropertyValue( s1, 'marginY', StyleBase.marginY )
	styleInheritsPropertyValue( s1, 'strokeColor', StyleBase.strokeColor )
	styleInheritsPropertyValue( s1, 'strokeWidth', StyleBase.strokeWidth )
	styleInheritsPropertyValue( s1, 'textColor', StyleBase.textColor )

	-- set local properties

	s1.align = 'left'
	s1.marginX = 99

	styleHasPropertyValue( s1, 'align', 'left' )
	styleHasPropertyValue( s1, 'marginX', 99 )


	--== Break inheritance

	s1.inherit = nil

	verifyTextStyle( s1 )
	styleInheritsFrom( s1, StyleBase )

	-- verify all properties have been copied

	styleInheritsPropertyValue( s1, 'align', StyleBase.align )
	styleInheritsPropertyValue( s1, 'fillColor', StyleBase.fillColor )
	styleInheritsPropertyValue( s1, 'font', StyleBase.font )
	styleInheritsPropertyValue( s1, 'fontSize', StyleBase.fontSize )
	styleInheritsPropertyValue( s1, 'marginX', StyleBase.marginX )
	styleInheritsPropertyValue( s1, 'marginY', StyleBase.marginY )
	styleInheritsPropertyValue( s1, 'strokeColor', StyleBase.strokeColor )
	styleInheritsPropertyValue( s1, 'strokeWidth', StyleBase.strokeWidth )
	styleInheritsPropertyValue( s1, 'textColor', StyleBase.textColor )


	--== Clear Properties, without Inherit

	receivedClearedEvent = false
	callback = function(e)
		if e.type==s1.STYLE_RESET then receivedClearedEvent=true end
	end
	s1:addEventListener( s1.EVENT, callback )

	s1:clearProperties()

	styleInheritsFrom( s1, StyleBase )
	assert_true( receivedClearedEvent, "missing clear event" )

	styleInheritsPropertyValue( s1, 'align', StyleBase.align )
	styleInheritsPropertyValue( s1, 'fillColor', StyleBase.fillColor )
	styleInheritsPropertyValue( s1, 'font', StyleBase.font )
	styleInheritsPropertyValue( s1, 'fontSize', StyleBase.fontSize )
	styleInheritsPropertyValue( s1, 'marginX', StyleBase.marginX )
	styleInheritsPropertyValue( s1, 'marginY', StyleBase.marginY )
	styleInheritsPropertyValue( s1, 'strokeColor', StyleBase.strokeColor )
	styleInheritsPropertyValue( s1, 'strokeWidth', StyleBase.strokeWidth )
	styleInheritsPropertyValue( s1, 'textColor', StyleBase.textColor )

end



--[[
--]]
function test_clearPropertiesWithInherit()
	-- print( "test_clearPropertiesWithInherit" )
	local Text = Widgets.Style.Text

	local StyleBase, StyleClass
	local s1, inherit
	local receivedClearedEvent, callback

	StyleBase = Text:getBaseStyle()

	-- by default, style has no inheritance

	s1 = Widgets.newTextStyle()
	s1.inherit = StyleBase

	StyleClass = s1.class
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
	styleInheritsPropertyValue( s1, 'textColor', StyleBase.textColor )

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
		if e.type==s1.STYLE_RESET then receivedClearedEvent=true end
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

	styleHasPropertyValue( s1, 'align', 'left' )
	styleHasPropertyValue( s1, 'marginX', 99 )


	--== Break inheritance

	s1.inherit = nil
	-- inherit = StyleBase -- reminder

	verifyTextStyle( s1 )
	styleInheritsFrom( s1, StyleBase )

	-- verify all properties have been copied, except for our changes

	styleInheritsPropertyValue( s1, 'align', inherit.align )
	styleInheritsPropertyValue( s1, 'fillColor', inherit.fillColor )
	styleInheritsPropertyValue( s1, 'font', inherit.font )
	styleInheritsPropertyValue( s1, 'fontSize', inherit.fontSize )
	styleInheritsPropertyValue( s1, 'marginX', inherit.marginX )
	styleInheritsPropertyValue( s1, 'marginY', inherit.marginY )
	styleInheritsPropertyValue( s1, 'strokeColor', inherit.strokeColor )
	styleInheritsPropertyValue( s1, 'strokeWidth', inherit.strokeWidth )
	styleInheritsPropertyValue( s1, 'textColor', StyleBase.textColor )


	--== Clear Properties, without Inherit

	receivedClearedEvent = false
	callback = function(e)
		if e.type==s1.STYLE_RESET then receivedClearedEvent=true end
	end
	s1:addEventListener( s1.EVENT, callback )

	s1:clearProperties()

	styleInheritsFrom( s1, StyleBase )
	assert_true( receivedClearedEvent, "missing clear event" )

	-- values reset to inherit

	styleInheritsPropertyValue( s1, 'align', inherit.align )
	styleInheritsPropertyValue( s1, 'fillColor', inherit.fillColor )
	styleInheritsPropertyValue( s1, 'font', inherit.font )
	styleInheritsPropertyValue( s1, 'fontSize', inherit.fontSize )
	styleInheritsPropertyValue( s1, 'marginX', inherit.marginX )
	styleInheritsPropertyValue( s1, 'marginY', inherit.marginY )
	styleInheritsPropertyValue( s1, 'strokeColor', inherit.strokeColor )
	styleInheritsPropertyValue( s1, 'strokeWidth', inherit.strokeWidth )
	styleInheritsPropertyValue( s1, 'textColor', inherit.textColor )

end


--[[
--]]
function test_initializeStyleWithLuaStructure()
	-- print( "test_initializeStyleWithLuaStructure" )
	local Text = Widgets.Style.Text

	local StyleBase, StyleClass
	local s1, inherit
	local receivedClearedEvent, callback

	StyleBase = Text:getBaseStyle()

	-- by default, style has no inheritance

	s1 = Widgets.newTextStyle{
		width=10,
		height=100,
		marginX=20,
		fontSize=100
	}

	StyleClass = s1.class
	assert_equal( StyleClass, Text )
	styleInheritsFrom( s1, StyleBase )

	-- inherit = StyleBase

	-- test inherited properties

	styleHasPropertyValue( s1, 'width', 10 )
	styleHasPropertyValue( s1, 'height', 100 )
	styleInheritsPropertyValue( s1, 'anchorX', StyleBase.anchorX )
	styleInheritsPropertyValue( s1, 'anchorY', StyleBase.anchorY )
	styleInheritsPropertyValue( s1, 'font', StyleBase.font )
	styleHasPropertyValue( s1, 'fontSize', 100 )
	styleHasPropertyValue( s1, 'marginX', 20 )
	styleInheritsPropertyValue( s1, 'marginY', StyleBase.marginY )
	styleInheritsPropertyValue( s1, 'strokeColor', StyleBase.strokeColor )
	styleInheritsPropertyValue( s1, 'strokeWidth', StyleBase.strokeWidth )
	styleInheritsPropertyValue( s1, 'textColor', StyleBase.textColor )

	-- set some properties, to make local

	s1.align = 'left'
	s1.marginX = 99

	verifyTextStyle( s1 )

	styleHasPropertyValue( s1, 'align', 'left' )
	styleInheritsPropertyValue( s1, 'fillColor', StyleBase.fillColor )
	styleInheritsPropertyValue( s1, 'font', StyleBase.font )
	styleHasPropertyValue( s1, 'fontSize', 100 )
	styleHasPropertyValue( s1, 'marginX', 99 )
	styleInheritsPropertyValue( s1, 'marginY', StyleBase.marginY )
	styleInheritsPropertyValue( s1, 'strokeColor', StyleBase.strokeColor )
	styleInheritsPropertyValue( s1, 'strokeWidth', StyleBase.strokeWidth )
	styleInheritsPropertyValue( s1, 'textColor', StyleBase.textColor )


	--== Clear Properties, with inherit

	receivedClearedEvent = false
	callback = function(e)
		if e.type==s1.STYLE_RESET then receivedClearedEvent=true end
	end
	s1:addEventListener( s1.EVENT, callback )

	inherit = StyleBase
	s1.inherit = inherit

	styleInheritsFrom( s1, inherit )
	assert_true( receivedClearedEvent, "missing clear event" )

	styleInheritsPropertyValue( s1, 'width', inherit.width )
	styleInheritsPropertyValue( s1, 'height', inherit.height )
	styleInheritsPropertyValue( s1, 'anchorX', inherit.anchorX )
	styleInheritsPropertyValue( s1, 'anchorY', inherit.anchorY )
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

	styleHasPropertyValue( s1, 'align', 'left' )
	styleHasPropertyValue( s1, 'marginX', 99 )


	--== Break inheritance

	s1.inherit = nil

	verifyTextStyle( s1 )
	styleInheritsFrom( s1, StyleBase )

	-- verify all properties have been copied, except for our changes

	hasPropertyValue( s1, 'width', StyleBase.width )
	hasPropertyValue( s1, 'height', StyleBase.height )
	styleInheritsPropertyValue( s1, 'anchorX', StyleBase.anchorX )
	styleInheritsPropertyValue( s1, 'anchorY', StyleBase.anchorY )
	styleInheritsPropertyValue( s1, 'align', StyleBase.align )
	styleInheritsPropertyValue( s1, 'fillColor', StyleBase.fillColor )
	styleInheritsPropertyValue( s1, 'font', StyleBase.font )
	styleInheritsPropertyValue( s1, 'fontSize', StyleBase.fontSize )
	styleInheritsPropertyValue( s1, 'marginX', StyleBase.marginX )
	styleInheritsPropertyValue( s1, 'marginY', StyleBase.marginY )
	styleInheritsPropertyValue( s1, 'strokeColor', StyleBase.strokeColor )
	styleInheritsPropertyValue( s1, 'strokeWidth', StyleBase.strokeWidth )
	styleInheritsPropertyValue( s1, 'textColor', StyleBase.textColor )


	--== Clear Properties, without Inherit

	receivedClearedEvent = false
	callback = function(e)
		if e.type==s1.STYLE_RESET then receivedClearedEvent=true end
	end
	s1:addEventListener( s1.EVENT, callback )

	s1:clearProperties()

	styleInheritsFrom( s1, StyleBase )
	assert_true( receivedClearedEvent, "missing clear event" )

	-- values reset to inherit

	styleInheritsPropertyValue( s1, 'align', StyleBase.align )
	styleInheritsPropertyValue( s1, 'fillColor', StyleBase.fillColor )
	styleInheritsPropertyValue( s1, 'font', StyleBase.font )
	styleInheritsPropertyValue( s1, 'fontSize', StyleBase.fontSize )
	styleInheritsPropertyValue( s1, 'marginX', StyleBase.marginX )
	styleInheritsPropertyValue( s1, 'marginY', StyleBase.marginY )
	styleInheritsPropertyValue( s1, 'strokeColor', StyleBase.strokeColor )
	styleInheritsPropertyValue( s1, 'strokeWidth', StyleBase.strokeWidth )
	styleInheritsPropertyValue( s1, 'textColor', StyleBase.textColor )

end


