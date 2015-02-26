--====================================================================--
-- Test: Button Style
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


local verifyButtonStyle = TestUtils.verifyButtonStyle

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

	Widgets._loadButtonSupport()

end


function test_addMissingProperties_Rounded()
	-- print( "test_addMissingProperties_Rounded" )
	local Button = Widgets.Style.Button
	local Text = Widgets.Style.Text

	local state, background, text

	local defaults = Button:getDefaultStyleValues()
	-- 	bDefaults = Background:getDefaultStyleValues()
	local tDefaults = Text:getDefaultStyleValues()
	-- 	vDefaults = Rectangle:getDefaultStyleValues()

	hasPropertyValue( defaults, 'debugOn', defaults.debugOn )
	hasPropertyValue( defaults, 'width', defaults.width )
	hasPropertyValue( defaults, 'height', defaults.height )
	hasPropertyValue( defaults, 'anchorX', defaults.anchorX )
	hasPropertyValue( defaults, 'anchorY', defaults.anchorY )

	hasPropertyValue( defaults, 'hitMarginX', defaults.hitMarginX )
	hasPropertyValue( defaults, 'hitMarginY', defaults.hitMarginY )
	hasPropertyValue( defaults, 'isHitActive', defaults.isHitActive )
	hasPropertyValue( defaults, 'marginX', defaults.marginX )
	hasPropertyValue( defaults, 'marginY', defaults.marginY )

	state = defaults.inactive

	hasPropertyValue( state, 'debugOn', defaults.debugOn )
	hasPropertyValue( state, 'width', defaults.width )
	hasPropertyValue( state, 'height', defaults.height )
	hasPropertyValue( state, 'anchorX', defaults.anchorX )
	hasPropertyValue( state, 'anchorY', defaults.anchorY )

	hasPropertyValue( state, 'align', state.align )
	hasPropertyValue( state, 'isHitActive', defaults.isHitActive )
	hasPropertyValue( state, 'marginX', defaults.marginX )
	hasPropertyValue( state, 'marginY', defaults.marginY )
	-- hasPropertyValue( state, 'offsetX', defaults.offsetX )
	-- hasPropertyValue( state, 'offsetY', defaults.offsetY )

	text = state.label

	hasPropertyValue( text, 'debugOn', defaults.debugOn )
	hasPropertyValue( text, 'width', defaults.width )
	hasPropertyValue( text, 'height', defaults.height )
	hasPropertyValue( text, 'anchorX', defaults.anchorX )
	hasPropertyValue( text, 'anchorY', defaults.anchorY )

	hasPropertyValue( text, 'align', state.align )
	hasPropertyValue( text, 'fillColor', tDefaults.fillColor )
	hasPropertyValue( text, 'font', defaults.font )
	hasPropertyValue( text, 'fontSize', defaults.fontSize )
	hasPropertyValue( text, 'marginX', defaults.marginX )
	hasPropertyValue( text, 'marginY', defaults.marginY )
	hasPropertyValue( text, 'strokeColor', tDefaults.strokeColor )
	hasPropertyValue( text, 'strokeWidth', tDefaults.strokeWidth )
	hasPropertyValue( text, 'textColor', text.textColor )

	background = state.background

	hasPropertyValue( background, 'debugOn', defaults.debugOn )
	hasPropertyValue( background, 'width', defaults.width )
	hasPropertyValue( background, 'height', defaults.height )
	hasPropertyValue( background, 'anchorX', defaults.anchorX )
	hasPropertyValue( background, 'anchorY', defaults.anchorY )

	hasPropertyValue( background, 'type', background.type )

	view = background.view

	Utils.print( view )

	hasPropertyValue( view, 'debugOn', defaults.debugOn )
	hasPropertyValue( view, 'width', defaults.width )
	hasPropertyValue( view, 'height', defaults.height )
	hasPropertyValue( view, 'anchorX', defaults.anchorX )
	hasPropertyValue( view, 'anchorY', defaults.anchorY )

	hasPropertyValue( view, 'type', view.type )

	hasPropertyValue( view, 'fillColor', view.fillColor )
	hasPropertyValue( view, 'strokeColor', view.strokeColor )
	hasPropertyValue( view, 'strokeWidth', view.strokeWidth )

end



--[[
Test to ensure that the correct property values are
copied during initialization
--]]
-- function test_addMissingProperties_Rounded()
-- 	-- print( "test_addMissingProperties_Rounded" )
-- 	local BackgroundFactory = Widgets.Style.BackgroundFactory
-- 	local Button = Widgets.Style.Button
-- 	local Text = Widgets.Style.Text
-- 	local Background = Widgets.Style.Background
-- 	local Rectangle = BackgroundFactory.Rectangle

-- 	local defaults, bDefaults, tDefaults, vDefaults
-- 	local src, base
-- 	local child, label, background, view

-- 	--== Rectangle ==--

-- 	defaults = Button:getDefaultStyleValues()
-- 	bDefaults = Background:getDefaultStyleValues()
-- 	tDefaults = Text:getDefaultStyleValues()
-- 	vDefaults = Rectangle:getDefaultStyleValues()


-- 	--== test empty base, empty source, empty destination

-- 	-- src is like our user item
-- 	src = {
-- 		name='Like the Button',
-- 		button={
-- 			inactive={
-- 				label={
-- 					hello="base label"

-- 				},
-- 				background={
-- 					type='rounded',
-- 					view={}
-- 				}
-- 			},
-- 			active={
-- 				label={},
-- 				background={
-- 					type='rounded',
-- 					view={}
-- 				}
-- 			},
-- 			disabled={
-- 				label={},
-- 				background={
-- 					type='rounded',
-- 					view={}
-- 				}
-- 			}
-- 		}
-- 	}
-- 	child = src.button

-- 	marker()

	-- Button.addMissingDestProperties( child, {parent=src} )

	-- Utils.print( child )

	-- hasPropertyValue( child, 'debugOn', defaults.debugOn )
	-- hasPropertyValue( child, 'width', defaults.width )
	-- hasPropertyValue( child, 'height', defaults.height )
	-- hasPropertyValue( child, 'anchorX', defaults.anchorX )
	-- hasPropertyValue( child, 'anchorY', defaults.anchorY )
	-- hasPropertyValue( child, 'hitMarginX', defaults.hitMarginX )
	-- hasPropertyValue( child, 'hitMarginY', defaults.hitMarginY )
	-- hasPropertyValue( child, 'isHitActive', defaults.isHitActive )
	-- hasPropertyValue( child, 'marginX', defaults.marginX )
	-- hasPropertyValue( child, 'marginY', defaults.marginY )


	-- state = child.inactive

	-- Utils.print( state )

	-- hasPropertyValue( state, 'debugOn', defaults.debugOn )
	-- hasPropertyValue( state, 'width', defaults.width )
	-- hasPropertyValue( state, 'height', defaults.height )
	-- hasPropertyValue( state, 'anchorX', defaults.anchorX )
	-- hasPropertyValue( state, 'anchorY', defaults.anchorY )
	-- hasPropertyValue( state, 'align', defaults.inactive.align )
	-- hasPropertyValue( state, 'isHitActive', defaults.isHitActive )
	-- hasPropertyValue( state, 'marginX', defaults.marginX )
	-- hasPropertyValue( state, 'marginY', defaults.marginY )

	-- label = state.label

	-- Utils.print( label )

	-- hasPropertyValue( label, 'debugOn', defaults.debugOn )
	-- hasPropertyValue( label, 'width', defaults.width )
	-- hasPropertyValue( label, 'height', defaults.height )
	-- hasPropertyValue( label, 'anchorX', defaults.anchorX )
	-- hasPropertyValue( label, 'anchorY', defaults.anchorY )
	-- hasPropertyValue( label, 'align', defaults.inactive.align )
	-- hasPropertyValue( label, 'font', defaults.font )
	-- hasPropertyValue( label, 'fontSize', defaults.fontSize )
	-- hasPropertyValue( label, 'textColor', defaults.inactive.label.textColor )

	-- background = state.background

	-- hasPropertyValue( background, 'type', 'rounded' )
	-- hasPropertyValue( background, 'debugOn', defaults.debugOn )
	-- hasPropertyValue( background, 'width', defaults.width )
	-- hasPropertyValue( background, 'height', defaults.height )
	-- hasPropertyValue( background, 'anchorX', defaults.anchorX )
	-- hasPropertyValue( background, 'anchorY', defaults.anchorY )

	-- view = background.view

	-- hasPropertyValue( view, 'debugOn', base.debugOn )
	-- hasPropertyValue( view, 'width', defaults.width )
	-- hasPropertyValue( view, 'height', defaults.height )
	-- hasPropertyValue( view, 'anchorX', base.anchorX )
	-- hasPropertyValue( view, 'anchorY', defaults.anchorY )
	-- hasPropertyValue( view, 'fillColor', vDefaults.fillColor )
	-- hasPropertyValue( view, 'strokeColor', vDefaults.strokeColor )
	-- hasPropertyValue( view, 'strokeWidth', vDefaults.strokeWidth )


-- end


--[[
Test to ensure that the correct property values are
copied during initialization
--]]
--[[
function test_basicStyleProperties()
	-- print( "test_classBackgroundStyle" )
	local Button = Widgets.Style.Button
	local StyleDefault

	StyleDefault = Button:getBaseStyle()

	assert_equal( Button.NAME, "Button Style", "name is incorrect" )
	assert_equal( StyleDefault.NAME, Button.NAME, "NAME is incorrect" )
	assert_true( StyleDefault:isa( Button ), "Class is incorrect" )

end
--]]


-- function test_defaultInheritance()
-- 	print( "test_defaultInheritance" )
-- 	local Button = Widgets.Style.Button
-- 	local StyleDefault = Button:getBaseStyle()

-- 	local s1, child

	-- Default Style

	-- verifyButtonStyle( StyleDefault )

	-- default button


	-- b1 = Widgets.newButtonStyle()

	-- styleInheritsFrom( b1, StyleDefault )
	-- hasValidStyleProperties( Button, b1 )
	-- verifyButtonStyle( b1 )

	-- print( ">>", b1.active.background.type, b1.inactive.background.type, b1.disabled.background.type )

	-- StyleDefault = Widgets.Style.Text:getBaseStyle()

	-- styleInheritsFrom( child, StyleBase )

	-- assert_true( b1.type, b1.view.type, "incorrect type" )
	-- print( ">>", b1.type, b1.view )

	-- -- rectangle

	-- s1 = Widgets.newRectangleBackgroundStyle()
	-- StyleBase = Button:getBaseStyle()

	-- styleInheritsFrom( s1, StyleBase )
	-- hasValidStyleProperties( Button, s1 )

	-- assert_true( s1.type, s1.view.type, "incorrect type" )

	-- -- rounded

	-- s1 = Widgets.newRoundedBackgroundStyle()
	-- StyleBase = Button:getBaseStyle()

	-- styleInheritsFrom( s1, StyleBase )
	-- hasValidStyleProperties( Button, s1 )

	-- assert_true( s1.type, s1.view.type, "incorrect type" )

-- end






-- function test_verifyStyleProperties()
-- 	-- print( "test_verifyStyleProperties" )
-- 	local BackgroundFactory = Widgets.Style.BackgroundFactory
-- 	local RoundedStyle = BackgroundFactory.Rounded

-- 	local src

-- 	src = {
-- 		debugOn=true,
-- 		width=4,
-- 		height=10,
-- 		anchorX=1,
-- 		anchorY=5,
-- 		cornerRadius=5,
-- 		fillColor={},
-- 		strokeColor=1,
-- 		strokeWidth=4
-- 	}
-- 	hasValidStyleProperties( RoundedStyle, src )

-- 	src = {
-- 		debugOn=nil, -- <<
-- 		width=4,
-- 		height=10,
-- 		anchorX=1,
-- 		anchorY=5,
-- 		cornerRadius=5,
-- 		fillColor={},
-- 		strokeColor=1,
-- 		strokeWidth=4
-- 	}
-- 	hasInvalidStyleProperties( RoundedStyle, src )

-- 	src = {
-- 		debugOn=true,
-- 		width=4,
-- 		height=10,
-- 		anchorX=1,
-- 		anchorY=5,
-- 		cornerRadius=nil,
-- 		fillColor=nil,
-- 		strokeColor=1,
-- 		strokeWidth=4
-- 	}
-- 	hasInvalidStyleProperties( RoundedStyle, src )

-- end




-- function test_defaultInheritance()
-- 	print( "test_defaultInheritance" )
-- 	local Background = Widgets.Style.Background
-- 	local StyleFactory = Widgets.Style.BackgroundFactory
-- 	local RoundedStyle = StyleFactory.Rounded
-- 	local StyleBase

-- 	local s1 = Widgets.newRoundedBackgroundStyle()
-- 	StyleBase = Background:getBaseStyle( s1.type )

-- 	styleInheritsFrom( s1, StyleBase )
-- 	hasValidStyleProperties( RoundedStyle, s1.view )

-- end



-- function test_mismatchedInheritance()
-- 	print( "test_mismatchedInheritance" )
-- 	local Background = Widgets.Style.Background
-- 	local StyleFactory = Widgets.Style.BackgroundFactory
-- 	local RoundedStyle = StyleFactory.Rounded
-- 	local StyleBase

-- 	local s1 = Widgets.newRoundedBackgroundStyle()
-- 	StyleBase = Background:getBaseStyle( s1.type )

-- 	print( ">>> styles", s1.type, StyleBase, s1 )
-- 	assert( s1 )

-- 	print( s1.inherit )
-- 	styleInheritsFrom( s1, StyleBase )


-- end

