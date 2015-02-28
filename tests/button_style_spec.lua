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
--== Module Testing
--====================================================================--


function suite_setup()

	Widgets._loadButtonSupport( {mode='test'} )

end



--====================================================================--
--== Test Static Functions


function test_defaultStyleValues()
	-- print( "test_defaultStyleValues" )
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
--[[
--]]
function test_addMissingProperties_Rounded()
	-- print( "test_addMissingProperties_Rounded" )
	local BackgroundFactory = Widgets.Style.BackgroundFactory
	local Button = Widgets.Style.Button
	local Text = Widgets.Style.Text
	local Background = Widgets.Style.Background
	local Rectangle = BackgroundFactory.Rectangle

	local defaults, bDefaults, tDefaults, vDefaults
	local src, base
	local child, label, background, view
	local vDef = nil

	--== Rectangle ==--

	defaults = Button:getDefaultStyleValues()
	bDefaults = Background:getDefaultStyleValues()
	tDefaults = Text:getDefaultStyleValues()
	vDefaults = Rectangle:getDefaultStyleValues()


	--== test empty base, empty source, empty destination

	-- src is like our user item
	src = {
		name='Like the Button',
		button={
			inactive={
				label={
					hello="base label"

				},
				background={
					type='rounded',
					view={}
				}
			},
			active={
				label={},
				background={
					type='rounded',
					view={}
				}
			},
			disabled={
				label={},
				background={
					type='rounded',
					view={}
				}
			}
		}
	}
	child = src.button

	Button.addMissingDestProperties( child, {parent=src} )

	local vDef = defaults

	hasPropertyValue( child, 'debugOn', vDef.debugOn )
	hasPropertyValue( child, 'width', vDef.width )
	hasPropertyValue( child, 'height', vDef.height )
	hasPropertyValue( child, 'anchorX', vDef.anchorX )
	hasPropertyValue( child, 'anchorY', vDef.anchorY )
	hasPropertyValue( child, 'hitMarginX', vDef.hitMarginX )
	hasPropertyValue( child, 'hitMarginY', vDef.hitMarginY )
	hasPropertyValue( child, 'isHitActive', vDef.isHitActive )
	hasPropertyValue( child, 'marginX', vDef.marginX )
	hasPropertyValue( child, 'marginY', vDef.marginY )

	local vDefState = vDef.inactive
	state = child.inactive

	hasPropertyValue( state, 'debugOn', vDefState.debugOn )
	hasPropertyValue( state, 'width', vDefState.width )
	hasPropertyValue( state, 'height', vDefState.height )
	hasPropertyValue( state, 'anchorX', vDefState.anchorX )
	hasPropertyValue( state, 'anchorY', vDefState.anchorY )
	hasPropertyValue( state, 'align', vDefState.align )
	hasPropertyValue( state, 'isHitActive', vDefState.isHitActive )
	hasPropertyValue( state, 'marginX', vDefState.marginX )
	hasPropertyValue( state, 'marginY', vDefState.marginY )

	local vDefLabel = vDefState.label
	label = state.label

	hasPropertyValue( label, 'debugOn', vDefLabel.debugOn )
	hasPropertyValue( label, 'width', vDefLabel.width )
	hasPropertyValue( label, 'height', vDefLabel.height )
	hasPropertyValue( label, 'anchorX', vDefLabel.anchorX )
	hasPropertyValue( label, 'anchorY', vDefLabel.anchorY )
	hasPropertyValue( label, 'align', vDefLabel.align )
	hasPropertyValue( label, 'font', vDefLabel.font )
	hasPropertyValue( label, 'fontSize', vDefLabel.fontSize )
	hasPropertyValue( label, 'textColor', vDefLabel.textColor )

	local vDefBackground = vDefState.background
	background = state.background

	hasPropertyValue( background, 'type', 'rounded' )
	hasPropertyValue( background, 'debugOn', vDefBackground.debugOn )
	hasPropertyValue( background, 'width', vDefBackground.width )
	hasPropertyValue( background, 'height', vDefBackground.height )
	hasPropertyValue( background, 'anchorX', vDefBackground.anchorX )
	hasPropertyValue( background, 'anchorY', vDefBackground.anchorY )

	local vDefView = vDefBackground.view
	view = background.view

	hasPropertyValue( view, 'debugOn', vDefView.debugOn )
	hasPropertyValue( view, 'width', vDefView.width )
	hasPropertyValue( view, 'height', vDefView.height )
	hasPropertyValue( view, 'anchorX', vDefView.anchorX )
	hasPropertyValue( view, 'anchorY', vDefView.anchorY )
	hasPropertyValue( view, 'fillColor', vDefView.fillColor )
	hasPropertyValue( view, 'strokeColor', vDefView.strokeColor )
	hasPropertyValue( view, 'strokeWidth', vDefView.strokeWidth )

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
Test to ensure that the correct property values are
copied during initialization
--]]
--[[
--]]
function test_basicStyleProperties()
	-- print( "test_classBackgroundStyle" )
	local Button = Widgets.Style.Button
	local StyleDefault

	StyleDefault = Button:getBaseStyle()

	assert_equal( Button.NAME, "Button Style", "name is incorrect" )
	assert_equal( StyleDefault.NAME, Button.NAME, "NAME is incorrect" )
	assert_true( StyleDefault:isa( Button ), "Class is incorrect" )

end


function test_defaultInheritance()
	-- print( "test_defaultInheritance" )
	local Button = Widgets.Style.Button
	local StyleDefault = Button:getBaseStyle()

	local s1, child

	-- Default Style

	verifyButtonStyle( StyleDefault )

	-- default button

	b1 = Widgets.newButtonStyle()

	styleInheritsFrom( b1, StyleDefault )
	hasValidStyleProperties( Button, b1 )
	verifyButtonStyle( b1 )

	StyleDefault = Widgets.Style.Text:getBaseStyle()

	styleInheritsFrom( child, nil )

	assert_true( b1.type, b1.view.type, "incorrect type" )

	-- rectangle

	s1 = Widgets.newRectangleBackgroundStyle()
	StyleBase = Button:getBaseStyle()

	styleInheritsFrom( s1, nil )
	hasValidStyleProperties( Button, s1 )

	assert_true( s1.type, s1.view.type, "incorrect type" )

	-- rounded

	s1 = Widgets.newRoundedBackgroundStyle()
	StyleBase = Button:getBaseStyle()

	styleInheritsFrom( s1, nil )
	hasValidStyleProperties( Button, s1 )

	assert_true( s1.type, s1.view.type, "incorrect type" )

end



-- TODO
function test_defaultInheritance()
	-- print( "test_defaultInheritance" )
	local Background = Widgets.Style.Background
	local StyleFactory = Widgets.Style.BackgroundFactory
	local RoundedStyle = StyleFactory.Rounded
	local StyleBase

	local s1 = Widgets.newRoundedBackgroundStyle()
	StyleBase = Background:getBaseStyle( s1.type )

	styleInheritsFrom( s1, nil )
	hasValidStyleProperties( RoundedStyle, s1.view )

end



-- TODO
function test_mismatchedInheritance()
	-- print( "test_mismatchedInheritance" )
	local Background = Widgets.Style.Background
	local StyleFactory = Widgets.Style.BackgroundFactory
	local RoundedStyle = StyleFactory.Rounded
	local StyleBase

	local s1 = Widgets.newRoundedBackgroundStyle()
	StyleBase = Background:getBaseStyle( s1.type )

	styleInheritsFrom( s1, nil )

end

