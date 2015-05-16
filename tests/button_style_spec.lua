--====================================================================--
-- Test: Button Style
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

	dUI.Style._loadButtonStyleSupport( {mode=dUI.TEST_MODE} )

end



--====================================================================--
--== Test Static Functions


function test_defaultStyleValues()
	-- print( "test_defaultStyleValues" )
	local Button = dUI.Style.Button
	local Text = dUI.Style.Text

	local state, background, text

	local defaults = Button:getDefaultStyleValues()
	local defaults = Button:getBaseStyle()
	-- 	bDefaults = Background:getDefaultStyleValues()
	local tDefaults = Text:getDefaultStyleValues()
	-- 	vDefaults = Rectangle:getDefaultStyleValues()

	hasValidStyleProperties( Button, defaults )

	-- TODO: check values

	-- hasPropertyValue( defaults, 'debugOn', defaults.debugOn )
	-- hasPropertyValue( defaults, 'width', defaults.width )
	-- hasPropertyValue( defaults, 'height', defaults.height )
	-- hasPropertyValue( defaults, 'anchorX', defaults.anchorX )
	-- hasPropertyValue( defaults, 'anchorY', defaults.anchorY )

	-- hasPropertyValue( defaults, 'hitMarginX', defaults.hitMarginX )
	-- hasPropertyValue( defaults, 'hitMarginY', defaults.hitMarginY )
	-- hasPropertyValue( defaults, 'isHitActive', defaults.isHitActive )
	-- hasPropertyValue( defaults, 'marginX', defaults.marginX )
	-- hasPropertyValue( defaults, 'marginY', defaults.marginY )

	-- state = defaults.inactive

	-- hasPropertyValue( state, 'debugOn', defaults.debugOn )
	-- hasPropertyValue( state, 'width', defaults.width )
	-- hasPropertyValue( state, 'height', defaults.height )
	-- hasPropertyValue( state, 'anchorX', defaults.anchorX )
	-- hasPropertyValue( state, 'anchorY', defaults.anchorY )

	-- hasPropertyValue( state, 'align', state.align )
	-- hasPropertyValue( state, 'isHitActive', defaults.isHitActive )
	-- hasPropertyValue( state, 'marginX', defaults.marginX )
	-- hasPropertyValue( state, 'marginY', defaults.marginY )
	-- -- hasPropertyValue( state, 'offsetX', defaults.offsetX )
	-- -- hasPropertyValue( state, 'offsetY', defaults.offsetY )

	-- text = state.label

	-- hasPropertyValue( text, 'debugOn', defaults.debugOn )
	-- hasPropertyValue( text, 'width', defaults.width )
	-- hasPropertyValue( text, 'height', defaults.height )
	-- hasPropertyValue( text, 'anchorX', defaults.anchorX )
	-- hasPropertyValue( text, 'anchorY', defaults.anchorY )

	-- hasPropertyValue( text, 'align', state.align )
	-- hasPropertyValue( text, 'fillColor', tDefaults.fillColor )
	-- hasPropertyValue( text, 'font', defaults.font )
	-- hasPropertyValue( text, 'fontSize', defaults.fontSize )
	-- hasPropertyValue( text, 'marginX', defaults.marginX )
	-- hasPropertyValue( text, 'marginY', defaults.marginY )
	-- hasPropertyValue( text, 'strokeColor', tDefaults.strokeColor )
	-- hasPropertyValue( text, 'strokeWidth', tDefaults.strokeWidth )
	-- hasPropertyValue( text, 'textColor', text.textColor )

	-- background = state.background

	-- hasPropertyValue( background, 'debugOn', defaults.debugOn )
	-- hasPropertyValue( background, 'width', defaults.width )
	-- hasPropertyValue( background, 'height', defaults.height )
	-- hasPropertyValue( background, 'anchorX', defaults.anchorX )
	-- hasPropertyValue( background, 'anchorY', defaults.anchorY )

	-- hasPropertyValue( background, 'type', background.type )

	-- view = background.view

	-- hasPropertyValue( view, 'debugOn', defaults.debugOn )
	-- hasPropertyValue( view, 'width', defaults.width )
	-- hasPropertyValue( view, 'height', defaults.height )
	-- hasPropertyValue( view, 'anchorX', defaults.anchorX )
	-- hasPropertyValue( view, 'anchorY', defaults.anchorY )

	-- hasPropertyValue( view, 'type', view.type )

	-- hasPropertyValue( view, 'fillColor', view.fillColor )
	-- hasPropertyValue( view, 'strokeColor', view.strokeColor )
	-- hasPropertyValue( view, 'strokeWidth', view.strokeWidth )

end



--[[
Test to ensure that the correct property values are
copied during initialization
--]]
--[[
function test_addMissingProperties_Rounded()
	-- print( "test_addMissingProperties_Rounded" )
	local BackgroundFactory = dUI.Style.BackgroundFactory
	local Button = dUI.Style.Button
	local Text = dUI.Style.Text
	local Background = dUI.Style.Background
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
--]]


--[[
function test_addMissingProperties_Rounded2()
	-- print( "test_addMissingProperties_Rounded2" )
	local BackgroundFactory = dUI.Style.BackgroundFactory
	local Button = dUI.Style.Button
	local Text = dUI.Style.Text
	local Background = dUI.Style.Background
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

marker()
	Utils.print( defaults )
	--== test empty base, empty source, empty destination
	marker()

	-- src is like our user item
	src = {
		name='Like the Button',
		button={
			width=1,
			height=1,
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

marker()

	Button.addMissingDestProperties( child, {parent=src} )

	local vDef = defaults

	-- Utils.print( child )

	hasPropertyValue( child, 'debugOn', vDef.debugOn )
	hasPropertyValue( child, 'width', 1 )
	hasPropertyValue( child, 'height', 1 )
	hasPropertyValue( child, 'anchorX', vDef.anchorX )
	hasPropertyValue( child, 'anchorY', vDef.anchorY )
	hasPropertyValue( child, 'hitMarginX', vDef.hitMarginX )
	hasPropertyValue( child, 'hitMarginY', vDef.hitMarginY )
	hasPropertyValue( child, 'isHitActive', vDef.isHitActive )
	hasPropertyValue( child, 'marginX', vDef.marginX )
	hasPropertyValue( child, 'marginY', vDef.marginY )

	local vDefState = vDef.inactive
	state = child.inactive

	print(">>", state.align )

	hasPropertyValue( state, 'debugOn', vDefState.debugOn )
	hasPropertyValue( state, 'width', 1 )
	hasPropertyValue( state, 'height', 1 )
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

	-- local vDefView = vDefBackground.view
	-- view = background.view

	-- hasPropertyValue( view, 'debugOn', vDefView.debugOn )
	-- hasPropertyValue( view, 'width', vDefView.width )
	-- hasPropertyValue( view, 'height', vDefView.height )
	-- hasPropertyValue( view, 'anchorX', vDefView.anchorX )
	-- hasPropertyValue( view, 'anchorY', vDefView.anchorY )
	-- hasPropertyValue( view, 'fillColor', vDefView.fillColor )
	-- hasPropertyValue( view, 'strokeColor', vDefView.strokeColor )
	-- hasPropertyValue( view, 'strokeWidth', vDefView.strokeWidth )

end
--]]




function test_copyExistingSrcProperties()
	-- print( "test_copyExistingSrcProperties" )
	local Button = dUI.Style.Button

	local src, dest

	--== test empty source, empty destination

	src = {
		button={
		}
	}
	dest = src.button

	Button.copyExistingSrcProperties( dest, src )

	hasPropertyValue( dest, 'debugOn', nil )
	hasPropertyValue( dest, 'width', nil )
	hasPropertyValue( dest, 'height', nil )
	hasPropertyValue( dest, 'anchorX', nil )
	hasPropertyValue( dest, 'anchorY', nil )

	hasPropertyValue( dest, 'align', nil )
	hasPropertyValue( dest, 'hitMarginX', nil )
	hasPropertyValue( dest, 'hitMarginY', nil )
	hasPropertyValue( dest, 'isHitActive', nil )
	hasPropertyValue( dest, 'marginX', nil )
	hasPropertyValue( dest, 'marginY', nil )


	--== test non-empty source, empty destination

	src = {
		debugOn=100,
		anchorX=101,
		hitMarginX=102,
		marginX=103,

		button={
		}
	}
	dest = src.button

	Button.copyExistingSrcProperties( dest, src )

	hasPropertyValue( dest, 'debugOn', src.debugOn )
	hasPropertyValue( dest, 'width', nil )
	hasPropertyValue( dest, 'height', nil )
	hasPropertyValue( dest, 'anchorX', src.anchorX )
	hasPropertyValue( dest, 'anchorY', nil )

	hasPropertyValue( dest, 'align', nil )
	hasPropertyValue( dest, 'hitMarginX', src.hitMarginX )
	hasPropertyValue( dest, 'hitMarginY', nil )
	hasPropertyValue( dest, 'isHitActive', nil )
	hasPropertyValue( dest, 'marginX', src.marginX )
	hasPropertyValue( dest, 'marginY', nil )


	--== test non-empty source, non-empty destination

	src = {
		debugOn=100,
		anchorX=101,
		hitMarginX=102,
		marginX=103,

		button={
			debugOn=200,
			width=202,
			marginX=204,
			marginY=206,
		}
	}
	dest = src.button

	Button.copyExistingSrcProperties( dest, src )

	hasPropertyValue( dest, 'debugOn', dest.debugOn )
	hasPropertyValue( dest, 'width', dest.width )
	hasPropertyValue( dest, 'height', nil )
	hasPropertyValue( dest, 'anchorX', src.anchorX )
	hasPropertyValue( dest, 'anchorY', nil )

	hasPropertyValue( dest, 'align', nil )
	hasPropertyValue( dest, 'hitMarginX', src.hitMarginX )
	hasPropertyValue( dest, 'hitMarginY', nil )
	hasPropertyValue( dest, 'isHitActive', nil )
	hasPropertyValue( dest, 'marginX', dest.marginX )
	hasPropertyValue( dest, 'marginY', dest.marginY )

end


function test_copyExistingSrcProperties_withForce()
	-- print( "test_copyExistingSrcProperties_withForce" )
	local Button = dUI.Style.Button

	local src, dest

	--== test empty source, empty destination

	src = {
		button={
		}
	}
	dest = src.button

	Button.copyExistingSrcProperties( dest, src, {force=true} )

	hasPropertyValue( dest, 'debugOn', nil )
	hasPropertyValue( dest, 'width', nil )
	hasPropertyValue( dest, 'height', nil )
	hasPropertyValue( dest, 'anchorX', nil )
	hasPropertyValue( dest, 'anchorY', nil )

	hasPropertyValue( dest, 'align', nil )
	hasPropertyValue( dest, 'hitMarginX', nil )
	hasPropertyValue( dest, 'hitMarginY', nil )
	hasPropertyValue( dest, 'isHitActive', nil )
	hasPropertyValue( dest, 'marginX', nil )
	hasPropertyValue( dest, 'marginY', nil )


	--== test non-empty source, empty destination

	src = {
		debugOn=100,
		anchorX=101,
		hitMarginX=102,
		marginX=103,

		button={
		}
	}
	dest = src.button

	Button.copyExistingSrcProperties( dest, src, {force=true} )

	hasPropertyValue( dest, 'debugOn', src.debugOn )
	hasPropertyValue( dest, 'width', nil )
	hasPropertyValue( dest, 'height', nil )
	hasPropertyValue( dest, 'anchorX', src.anchorX )
	hasPropertyValue( dest, 'anchorY', nil )

	hasPropertyValue( dest, 'align', nil )
	hasPropertyValue( dest, 'hitMarginX', src.hitMarginX )
	hasPropertyValue( dest, 'hitMarginY', nil )
	hasPropertyValue( dest, 'isHitActive', nil )
	hasPropertyValue( dest, 'marginX', src.marginX )
	hasPropertyValue( dest, 'marginY', nil )


	--== test non-empty source, non-empty destination

	src = {
		debugOn=100,
		anchorX=101,
		hitMarginX=102,
		marginX=103,

		button={
			debugOn=200,
			width=202,
			marginX=204,
			marginY=206,
		}
	}
	dest = src.button

	Button.copyExistingSrcProperties( dest, src, {force=true} )

	hasPropertyValue( dest, 'debugOn', src.debugOn )
	hasPropertyValue( dest, 'width', dest.width )
	hasPropertyValue( dest, 'height', nil )
	hasPropertyValue( dest, 'anchorX', src.anchorX )
	hasPropertyValue( dest, 'anchorY', nil )

	hasPropertyValue( dest, 'align', nil )
	hasPropertyValue( dest, 'hitMarginX', src.hitMarginX )
	hasPropertyValue( dest, 'hitMarginY', nil )
	hasPropertyValue( dest, 'isHitActive', nil )
	hasPropertyValue( dest, 'marginX', src.marginX )
	hasPropertyValue( dest, 'marginY', dest.marginY )

end




function test_verifyStyleProperties()
	-- print( "test_verifyStyleProperties" )
	local Button = dUI.Style.Button

	local src

	src = {
		debugOn=true,
		width=4,
		height=10,
		anchorX=1,
		anchorY=5,

		align='center',
		hitMarginX=5,
		hitMarginY=5,
		isHitActive=true,
		marginX=4,
		marginY=5,

		inactive={
			debugOn=true,
			width=4,
			height=10,
			anchorX=1,
			anchorY=5,

			align='center',
			isHitActive=true,
			offsetX=4,
			offsetY=5,
			marginX=4,
			marginY=5,

			label={
				debugOn=true,
				width=4,
				height=10,
				anchorX=1,
				anchorY=5,

				align='center',
				fillColor=4,
				font=4,
				fontSize=5,
				fontSizeMinimum=0,
				marginX=4,
				marginY=5,
				strokeColor=4,
				strokeWidth=5,
				textColor=5,
			},
			background={
				debugOn=true,
				width=4,
				height=10,
				anchorX=1,
				anchorY=5,

				type='rounded',

				view={
					debugOn=true,
					width=4,
					height=10,
					anchorX=1,
					anchorY=5,

					cornerRadius=5,
					fillColor=4,
					strokeColor=4,
					strokeWidth=5,
				}
			}
		},

		active={
			debugOn=true,
			width=4,
			height=10,
			anchorX=1,
			anchorY=5,

			align='center',
			isHitActive=true,
			offsetX=4,
			offsetY=5,
			marginX=4,
			marginY=5,

			label={
				debugOn=true,
				width=4,
				height=10,
				anchorX=1,
				anchorY=5,

				align='center',
				fillColor=4,
				font=4,
				fontSize=5,
				fontSizeMinimum=0,
				marginX=4,
				marginY=5,
				strokeColor=4,
				strokeWidth=5,
				textColor=5,
			},
			background={
				debugOn=true,
				width=4,
				height=10,
				anchorX=1,
				anchorY=5,

				type='rounded',

				view={
					debugOn=true,
					width=4,
					height=10,
					anchorX=1,
					anchorY=5,

					cornerRadius=5,
					fillColor=4,
					strokeColor=4,
					strokeWidth=5,
				}
			}
		},

		disabled={
			debugOn=true,
			width=4,
			height=10,
			anchorX=1,
			anchorY=5,

			align='center',
			isHitActive=true,
			offsetX=4,
			offsetY=5,
			marginX=4,
			marginY=5,

			label={
				debugOn=true,
				width=4,
				height=10,
				anchorX=1,
				anchorY=5,

				align='center',
				fillColor=4,
				font=4,
				fontSize=5,
				fontSizeMinimum=0,
				marginX=4,
				marginY=5,
				strokeColor=4,
				strokeWidth=5,
				textColor=5,
			},
			background={
				debugOn=true,
				width=4,
				height=10,
				anchorX=1,
				anchorY=5,

				type='rounded',

				view={
					debugOn=true,
					width=4,
					height=10,
					anchorX=1,
					anchorY=5,

					cornerRadius=5,
					fillColor=4,
					strokeColor=4,
					strokeWidth=5,
				}
			}
		}
	}

	hasValidStyleProperties( Button, src )

	src = {
		debugOn=true,
		width=4,
		height=10,
		anchorX=1,
		anchorY=5,

		align='center',
		hitMarginX=5,
		hitMarginY=5,
		isHitActive=true,
		marginX=4,
		marginY=5,

		inactive={
			debugOn=true,
			width=4,
			height=10,
			anchorX=1,
			anchorY=5,

			align='center',
			isHitActive=true,
			offsetX=4,
			offsetY=5,
			marginX=4,
			marginY=5,

			label={
				debugOn=true,
				width=4,
				height=10,
				anchorX=1,
				anchorY=5,

				align='center',
				fillColor=4,
				font=4,
				fontSize=5,
				marginX=4,
				marginY=5,
				strokeColor=4,
				strokeWidth=5,
				textColor=5,
			},
			background={
				debugOn=true,
				width=4,
				height=10,
				anchorX=1,
				anchorY=5,

				-- type='rounded', --<<

				view={
					debugOn=true,
					width=4,
					height=10,
					anchorX=1,
					anchorY=5,

					cornerRadius=5,
					fillColor=4,
					strokeColor=4,
					strokeWidth=5,
				}
			}
		},

		activex={ --<<
			debugOn=true,
			width=4,
			height=10,
			anchorX=1,
			anchorY=5,

			align='center',
			isHitActive=true,
			offsetX=4,
			offsetY=5,
			marginX=4,
			marginY=5,

			label={
				debugOn=true,
				width=4,
				height=10,
				anchorX=1,
				anchorY=5,

				align='center',
				fillColor=4,
				font=4,
				fontSize=5,
				marginX=4,
				marginY=5,
				strokeColor=4,
				strokeWidth=5,
				textColor=5,
			},
			background={
				debugOn=true,
				width=4,
				height=10,
				anchorX=1,
				anchorY=5,

				type='rounded',

				view={
					debugOn=true,
					width=4,
					height=10,
					anchorX=1,
					anchorY=5,

					cornerRadius=5,
					fillColor=4,
					strokeColor=4,
					strokeWidth=5,
				}
			}
		},

		disabled={
			debugOn=true,
			width=4,
			height=10,
			anchorX=1,
			anchorY=5,

			align='center',
			isHitActive=true,
			offsetX=4,
			offsetY=5,
			marginX=4,
			marginY=5,

			label={
				debugOn=true,
				width=4,
				height=10,
				anchorX=1,
				anchorY=5,

				align='center',
				fillColor=4,
				font=4,
				fontSize=5,
				marginX=4,
				marginY=5,
				-- strokeColor=nil, --<<
				strokeWidth=5,
				textColor=5,
			},
			background={
				debugOn=true,
				width=4,
				height=10,
				anchorX=1,
				anchorY=5,

				type='rounded',

				view={
					-- debugOn=nil, --<<
					width=4,
					height=10,
					anchorX=1,
					anchorY=5,

					cornerRadius=5,
					fillColor=4,
					strokeColor=4,
					strokeWidth=5,
				}
			}
		}
	}
	hasInvalidStyleProperties( Button, src )

end



--====================================================================--
--== Test Class Methods


function test_generalTest_01()
	local Button = dUI.Style.Button
	local Background = dUI.Style.Background
	local BaseStyle, bsState, bsLabel, bsBg, bsView
	local style, state, label, background, view
	local bgBase

	BaseStyle = Button:getBaseStyle()

	style = dUI.newButtonStyle{
		debugOn=true,
		width=55,
		height=56,
		align='right',
		inactive={
			width=66,
			-- height=67,
			label={},
			background={
				-- width=200,
				height=77,
				type='rectangle',
				view={
					width=87,
					-- height=200
					fillColor={23,23,22}
				}
			}
		}
	}

	styleInheritsFrom( style, BaseStyle )

	styleHasPropertyValue( style, 'debugOn', true )
	styleHasPropertyValue( style, 'width', 55 )
	styleHasPropertyValue( style, 'height', 56 )
	styleInheritsPropertyValue( style, 'anchorX', BaseStyle.anchorX )
	styleInheritsPropertyValue( style, 'anchorY', BaseStyle.anchorY )
	styleInheritsPropertyValue( style, 'hitMarginX', BaseStyle.hitMarginX )
	styleInheritsPropertyValue( style, 'hitMarginY', BaseStyle.hitMarginY )
	styleInheritsPropertyValue( style, 'isHitActive', BaseStyle.isHitActive )
	styleInheritsPropertyValue( style, 'marginX', BaseStyle.marginX )
	styleInheritsPropertyValue( style, 'marginY', BaseStyle.marginY )

	bsState = BaseStyle.inactive
	state = style.inactive
	styleInheritsFrom( state, bsState )

	styleHasPropertyValue( state, 'debugOn', true )
	styleHasPropertyValue( state, 'width', 66 )
	styleHasPropertyValue( state, 'height', 56 )
	styleInheritsPropertyValue( state, 'anchorX', bsState.anchorX )
	styleInheritsPropertyValue( state, 'anchorY', bsState.anchorY )
	styleHasPropertyValue( state, 'align', 'right' )
	styleInheritsPropertyValue( state, 'isHitActive', bsState.isHitActive )
	styleInheritsPropertyValue( state, 'marginX', bsState.marginX )
	styleInheritsPropertyValue( state, 'marginY', bsState.marginY )

	bsLabel = bsState.label
	label = state.label
	styleInheritsFrom( label, bsLabel )

	styleHasPropertyValue( label, 'debugOn', true )
	styleHasPropertyValue( label, 'width', 66 )
	styleHasPropertyValue( label, 'height', 56 )
	styleInheritsPropertyValue( label, 'anchorX', bsLabel.anchorX )
	styleInheritsPropertyValue( label, 'anchorY', bsLabel.anchorY )
	styleHasPropertyValue( label, 'align', 'right' )
	styleInheritsPropertyValue( label, 'font', bsLabel.font )
	styleInheritsPropertyValue( label, 'fontSize', bsLabel.fontSize )
	styleInheritsPropertyValue( label, 'textColor', bsLabel.textColor )

	bsBg = bsState.background
	background = state.background
	styleInheritsFrom( background, bsBg )

	styleHasPropertyValue( background, 'type', 'rectangle' )
	styleHasPropertyValue( background, 'debugOn', true )
	styleHasPropertyValue( background, 'width', 66 )
	styleHasPropertyValue( background, 'height', 77 )
	styleInheritsPropertyValue( background, 'anchorX', bsBg.anchorX )
	styleInheritsPropertyValue( background, 'anchorY', bsBg.anchorY )

	bgBase = Background:getBaseStyle( background.type )
	bsView = bgBase.view
	view = background.view
	styleInheritsFrom( view, bsView )

	styleHasPropertyValue( view, 'debugOn', true )
	styleHasPropertyValue( view, 'width', 87 )
	styleHasPropertyValue( view, 'height', 77 )
	styleInheritsPropertyValue( view, 'anchorX', bsView.anchorX )
	styleInheritsPropertyValue( view, 'anchorY', bsView.anchorY )
	styleHasPropertyValue( view, 'fillColor', {23,23,22} )
	styleInheritsPropertyValue( view, 'strokeColor', bsView.strokeColor )
	styleInheritsPropertyValue( view, 'strokeWidth', bsView.strokeWidth )

end


function test_styleClassBasics()
	-- print( "test_styleClassBasics" )
	local Button = dUI.Style.Button
	local BaseStyle, defaultStyles
	local style

	defaultStyles = Button:getDefaultStyleValues()
	BaseStyle = Button:getBaseStyle()

	--== Verify a new button style

	style = dUI.newButtonStyle()

	TestUtils.verifyButtonStyle( style )
	styleInheritsFrom( style, BaseStyle )

	--== Destroy style

	style:removeSelf()

end


--[[
Test to ensure that the correct property values are
copied during initialization
--]]
--[[
--]]
function test_basicStyleProperties()
	-- print( "test_classBackgroundStyle" )
	local Button = dUI.Style.Button
	local BaseStyle = Button:getBaseStyle()

	assert_equal( Button.NAME, "Button Style", "name is incorrect" )

	assert_equal( BaseStyle.NAME, Button.NAME, "NAME is incorrect" )
	assert_true( BaseStyle:isa( Button ), "Class is incorrect" )

end


function test_defaultInheritance()
	-- print( "test_defaultInheritance" )
	local Button = dUI.Style.Button
	local Background = dUI.Style.Background
	local BaseStyle, bsState, bsLabel, bsBg, bsView
	local s1, s1State, s1Label, s1Bg, s1View
	local bgBase

	BaseStyle = Button:getBaseStyle()

	--== default button

	s1 = dUI.newButtonStyle()
	verifyButtonStyle( s1 )

	styleInheritsFrom( s1, BaseStyle )
	hasValidStyleProperties( Button, s1 )

	-- inactive

	bsState = BaseStyle.inactive
	s1State = s1.inactive
	styleInheritsFrom( s1State, bsState )

	bsLabel = bsState.label
	s1Label = s1State.label
	styleInheritsFrom( s1Label, bsLabel )

	bsBg = bsState.background
	s1Bg = s1State.background
	styleInheritsFrom( s1Bg, bsBg )

	bsView = bsBg.view
	s1View = s1Bg.view
	styleInheritsFrom( s1View, bsView )

	-- active

	bsState = BaseStyle.active
	s1State = s1.active
	styleInheritsFrom( s1State, bsState )

	bsLabel = bsState.label
	s1Label = s1State.label
	styleInheritsFrom( s1Label, bsLabel )

	bsBg = bsState.background
	s1Bg = s1State.background
	styleInheritsFrom( s1Bg, bsBg )

	bgBase = Background:getBaseStyle( s1Bg.type )

	bsView = bgBase.view
	s1View = s1Bg.view
	styleInheritsFrom( s1View, bsView )

	-- disabled

	bsState = BaseStyle.disabled
	s1State = s1.disabled
	styleInheritsFrom( s1State, bsState )

	bsLabel = bsState.label
	s1Label = s1State.label
	styleInheritsFrom( s1Label, bsLabel )

	bsBg = bsState.background
	s1Bg = s1State.background
	styleInheritsFrom( s1Bg, bsBg )

	bsView = bsBg.view
	s1View = s1Bg.view
	styleInheritsFrom( s1View, bsView )

end




function test_copyStyle()

	local Button = dUI.Style.Button
	local BaseStyle = Button:getBaseStyle()
	local style, copy
	local child, label, background, view

	style = BaseStyle
	copy = style:copyStyle()

	styleInheritsFrom( copy, style )
	styleInheritsPropertyValue( copy, 'debugOn', BaseStyle.debugOn )
	styleInheritsPropertyValue( copy, 'width', BaseStyle.width )
	styleInheritsPropertyValue( copy, 'height', BaseStyle.height )
	styleInheritsPropertyValue( copy, 'anchorX', BaseStyle.anchorX )
	styleInheritsPropertyValue( copy, 'anchorY', BaseStyle.anchorY )
	styleInheritsPropertyValue( copy, 'hitMarginX', BaseStyle.hitMarginX )
	styleInheritsPropertyValue( copy, 'hitMarginY', BaseStyle.hitMarginY )
	styleInheritsPropertyValue( copy, 'isHitActive', BaseStyle.isHitActive )
	styleInheritsPropertyValue( copy, 'marginX', BaseStyle.marginX )
	styleInheritsPropertyValue( copy, 'marginY', BaseStyle.marginY )

	local vDefState = BaseStyle.inactive
	state = copy.inactive

	styleInheritsFrom( state, vDefState )
	styleInheritsPropertyValue( state, 'debugOn', vDefState.debugOn )
	styleInheritsPropertyValue( state, 'width', vDefState.width )
	styleInheritsPropertyValue( state, 'height', vDefState.height )
	styleInheritsPropertyValue( state, 'anchorX', vDefState.anchorX )
	styleInheritsPropertyValue( state, 'anchorY', vDefState.anchorY )
	styleInheritsPropertyValue( state, 'align', vDefState.align )
	styleInheritsPropertyValue( state, 'isHitActive', vDefState.isHitActive )
	styleInheritsPropertyValue( state, 'marginX', vDefState.marginX )
	styleInheritsPropertyValue( state, 'marginY', vDefState.marginY )

	local vDefLabel = vDefState.label
	label = state.label

	styleInheritsFrom( label, vDefLabel )
	styleInheritsPropertyValue( label, 'debugOn', vDefLabel.debugOn )
	styleInheritsPropertyValue( label, 'width', vDefLabel.width )
	styleInheritsPropertyValue( label, 'height', vDefLabel.height )
	styleInheritsPropertyValue( label, 'anchorX', vDefLabel.anchorX )
	styleInheritsPropertyValue( label, 'anchorY', vDefLabel.anchorY )
	styleInheritsPropertyValue( label, 'align', vDefLabel.align )
	styleInheritsPropertyValue( label, 'font', vDefLabel.font )
	styleInheritsPropertyValue( label, 'fontSize', vDefLabel.fontSize )
	styleInheritsPropertyValue( label, 'textColor', vDefLabel.textColor )

	local vDefBackground = vDefState.background
	background = state.background

	styleInheritsFrom( background, vDefBackground )
	styleInheritsPropertyValue( background, 'type', 'rounded' )
	styleInheritsPropertyValue( background, 'debugOn', vDefBackground.debugOn )
	styleInheritsPropertyValue( background, 'width', vDefBackground.width )
	styleInheritsPropertyValue( background, 'height', vDefBackground.height )
	styleInheritsPropertyValue( background, 'anchorX', vDefBackground.anchorX )
	styleInheritsPropertyValue( background, 'anchorY', vDefBackground.anchorY )

	local vDefView = vDefBackground.view
	view = background.view

	styleInheritsFrom( view, vDefView )
	styleInheritsPropertyValue( view, 'debugOn', vDefView.debugOn )
	styleInheritsPropertyValue( view, 'width', vDefView.width )
	styleInheritsPropertyValue( view, 'height', vDefView.height )
	styleInheritsPropertyValue( view, 'anchorX', vDefView.anchorX )
	styleInheritsPropertyValue( view, 'anchorY', vDefView.anchorY )
	styleInheritsPropertyValue( view, 'fillColor', vDefView.fillColor )
	styleInheritsPropertyValue( view, 'strokeColor', vDefView.strokeColor )
	styleInheritsPropertyValue( view, 'strokeWidth', vDefView.strokeWidth )

end



