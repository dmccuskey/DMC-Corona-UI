--====================================================================--
-- Test: Background Style
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


local verifyBackgroundStyle = TestUtils.verifyBackgroundStyle

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

	dUI.Style._loadBackgroundStyleSupport( {dUI.TEST_MODE} )

end



--====================================================================--
--== Test Static Functions


--[[
Test to ensure that the correct property values are
copied during initialization
src is like user data
base is like globals for Style
--]]
--[[
function test_addMissingProperties_Rectangle()
	-- print( "test_addMissingProperties_Rectangle" )
	local BackgroundFactory = dUI.Style.BackgroundFactory
	local Rectangle = BackgroundFactory.Rectangle
	local Background = dUI.Style.Background
	local defaults, vDefaults
	local src, base
	local child, label, view

	--== Rectangle ==--

	defaults = Background:getDefaultStyleValues()
	vDefaults = Rectangle:getDefaultStyleValues()

	--== test empty base, empty source, empty destination

	-- src 'user data'
	src = {
		background = {
			type='rectangle',
			view={}
		}
	}
	child = src.background

	Background.addMissingDestProperties( child, {parent=src} )

	hasPropertyValue( child, 'debugOn', defaults.debugOn )
	hasPropertyValue( child, 'width', defaults.width )
	hasPropertyValue( child, 'height', defaults.height )
	hasPropertyValue( child, 'anchorX', defaults.anchorX )
	hasPropertyValue( child, 'anchorY', defaults.anchorY )
	hasPropertyValue( child, 'type', child.type )

	view = child.view

	hasPropertyValue( view, 'debugOn', vDefaults.debugOn )
	hasPropertyValue( view, 'width', vDefaults.width )
	hasPropertyValue( view, 'height', vDefaults.height )
	hasPropertyValue( view, 'anchorX', vDefaults.anchorX )
	hasPropertyValue( view, 'anchorY', vDefaults.anchorY )
	hasPropertyValue( view, 'fillColor', vDefaults.fillColor )
	hasPropertyValue( view, 'strokeColor', vDefaults.strokeColor )
	hasPropertyValue( view, 'strokeWidth', vDefaults.strokeWidth )


	--== test partial base, empty source, empty destination

	src = {
		debugOn=100,
		anchorX=102,
		strokeWidth=104,
		background = { -- << this is like Background
			type='rectangle',
			view={}
		}
	}
	child = src.background

	Background.addMissingDestProperties( child, {parent=src} )

	hasPropertyValue( child, 'debugOn', defaults.debugOn )
	hasPropertyValue( child, 'width', defaults.width )
	hasPropertyValue( child, 'height', defaults.height )
	hasPropertyValue( child, 'anchorX', defaults.anchorX )
	hasPropertyValue( child, 'anchorY', defaults.anchorY )
	hasPropertyValue( child, 'type', child.type )

	view = child.view

	hasPropertyValue( view, 'debugOn', vDefaults.debugOn )
	hasPropertyValue( view, 'width', vDefaults.width )
	hasPropertyValue( view, 'height', vDefaults.height )
	hasPropertyValue( view, 'anchorX', vDefaults.anchorX )
	hasPropertyValue( view, 'anchorY', vDefaults.anchorY )
	hasPropertyValue( view, 'fillColor', vDefaults.fillColor )
	hasPropertyValue( view, 'strokeColor', vDefaults.strokeColor )
	hasPropertyValue( view, 'strokeWidth', vDefaults.strokeWidth )


	--== test partial base, partial source, partial destination, partial view

	src = {
		debugOn=100,
		width=102,
		fillColor={101,102,103,104,},

		background = {
			type='rectangle',
			height=110,
			anchorY=112,
			view={
				debugOn=120,
				anchorX=122,
				height=124
			}
		}
	}
	child = src.background

	Background.addMissingDestProperties( child, {parent=src} )

	hasPropertyValue( child, 'debugOn', defaults.debugOn )
	hasPropertyValue( child, 'width', defaults.width )
	hasPropertyValue( child, 'height', child.height )
	hasPropertyValue( child, 'anchorX', defaults.anchorX )
	hasPropertyValue( child, 'anchorY', child.anchorY )
	hasPropertyValue( child, 'type', child.type )

	view = child.view

	hasPropertyValue( view, 'debugOn', view.debugOn )
	hasPropertyValue( view, 'width', vDefaults.width )
	hasPropertyValue( view, 'height', view.height )
	hasPropertyValue( view, 'anchorX', view.anchorX )
	hasPropertyValue( view, 'anchorY', vDefaults.anchorY )
	hasPropertyValue( view, 'fillColor', vDefaults.fillColor )
	hasPropertyValue( view, 'strokeColor', vDefaults.strokeColor )
	hasPropertyValue( view, 'strokeWidth', vDefaults.strokeWidth )

	src = {
		debugOn=100,
		width=102,
		fillColor={10,12,14,16,},

		background = {
			type='rectangle',
			height=112,
			anchorY=114,
			view={
				fillColor={11,12,13,14},
				debugOn=122,
				anchorX=124,
				height=126
			}
		}
	}
	child = src.background

	Background.addMissingDestProperties( child, {parent=src} )

	hasPropertyValue( child, 'debugOn', defaults.debugOn )
	hasPropertyValue( child, 'width', defaults.width )
	hasPropertyValue( child, 'height', child.height )
	hasPropertyValue( child, 'anchorX', defaults.anchorX )
	hasPropertyValue( child, 'anchorY', child.anchorY )
	hasPropertyValue( child, 'type', child.type )

	view = child.view

	hasPropertyValue( view, 'debugOn', view.debugOn )
	hasPropertyValue( view, 'width', vDefaults.width )
	hasPropertyValue( view, 'height', view.height )
	hasPropertyValue( view, 'anchorX', view.anchorX )
	hasPropertyValue( view, 'anchorY', vDefaults.anchorY )
	hasPropertyValue( view, 'fillColor', {11,12,13,14} )
	hasPropertyValue( view, 'strokeColor', vDefaults.strokeColor )
	hasPropertyValue( view, 'strokeWidth', vDefaults.strokeWidth )

end
--]]


-- --[[
-- function test_copyExistingSrcProperties()
-- 	-- print( "test_copyExistingSrcProperties" )
-- 	local BackgroundFactory = dUI.Style.BackgroundFactory
-- 	local RoundedStyle = BackgroundFactory.Rounded

-- 	local src

-- end
-- --]]


--[[
--]]
function test_verifyStyleProperties_rounded()
	-- print( "test_verifyStyleProperties" )
	local Background = dUI.Style.Background

	local src

	src = {
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

	hasValidStyleProperties( Background, src )


	src = {
		debugOn=true,
		width=4,
		-- height=10,
		anchorX=1,
		anchorY=5,

		type='rounded',

		view={
			debugOn=true,
			width=4,
			height=10,
			-- anchorX=1,
			anchorY=5,

			cornerRadius=5,
			fillColor=4,
			strokeColor=4,
			strokeWidth=5,
		}
	}

	hasInvalidStyleProperties( Background, src )


	src = {
		-- debugOn=true,
		width=4,
		height=10,
		anchorX=1,
		anchorY=5,

		-- type='rounded',

		view={
			debugOn=true,
			width=4,
			height=10,
			anchorX=1,
			anchorY=5,

			-- cornerRadius=5,
			fillColor=4,
			-- strokeColor=4,
			strokeWidth=5,
		}
	}

	hasInvalidStyleProperties( Background, src )

end


function test_verifyStyleProperties_rectangle()
	-- print( "test_verifyStyleProperties" )
	local Background = dUI.Style.Background

	local src

	src = {
		debugOn=true,
		width=4,
		height=10,
		anchorX=1,
		anchorY=5,

		type='rectangle',

		view={
			debugOn=true,
			width=4,
			height=10,
			anchorX=1,
			anchorY=5,

			fillColor=4,
			strokeColor=4,
			strokeWidth=5,
		}
	}

	hasValidStyleProperties( Background, src )


	src = {
		debugOn=true,
		width=4,
		-- height=10,
		anchorX=1,
		anchorY=5,

		type='rectangle',

		view={
			debugOn=true,
			width=4,
			height=10,
			-- anchorX=1,
			anchorY=5,

			fillColor=4,
			strokeColor=4,
			strokeWidth=5,
		}
	}

	hasInvalidStyleProperties( Background, src )


	src = {
		-- debugOn=true,
		width=4,
		height=10,
		anchorX=1,
		anchorY=5,

		-- type='rectangle',

		view={
			debugOn=true,
			width=4,
			height=10,
			anchorX=1,
			anchorY=5,

			fillColor=4,
			-- strokeColor=4,
			strokeWidth=5,
		}
	}

	hasInvalidStyleProperties( Background, src )

end


function test_defaultStyleValues()
	-- print( "test_defaultStyleValues" )
	local Background = dUI.Style.Background
	local defaults

	defaults = Background:getDefaultStyleValues( dUI.ROUNDED )
	hasValidStyleProperties( Background, defaults )

	-- TODO: check values

	defaults = Background:getDefaultStyleValues( dUI.RECTANGLE )
	hasValidStyleProperties( Background, defaults )

	-- TODO: check values

	-- hasPropertyValue( defaults, 'debugOn', defaults.debugOn )
	-- hasPropertyValue( defaults, 'width', defaults.width )
	-- hasPropertyValue( defaults, 'height', defaults.height )
	-- hasPropertyValue( defaults, 'anchorX', defaults.anchorX )
	-- hasPropertyValue( defaults, 'anchorY', defaults.anchorY )

end

-- --====================================================================--
-- --== Test Class Methods


--[[
test basic characteristics
--]]
--[[
--]]
function test_backgroundStyleClassBasics()
	-- print( "test_backgroundStyleClassBasics" )
	local Background = dUI.Style.Background
	local BaseStyle, defaults, vDefaults
	local style, view

	defaults = Background:getDefaultStyleValues()

	--== rounded

	BaseStyle = Background:getBaseStyle( dUI.ROUNDED )
	print( BaseStyle)
	verifyBackgroundStyle( BaseStyle )

	styleInheritsFrom( BaseStyle, BaseStyle.NO_INHERIT )

	-- check properties initialized to the default values

	styleHasPropertyValue( BaseStyle, 'debugOn', defaults.debugOn )
	styleHasPropertyValue( BaseStyle, 'width', defaults.width )
	styleHasPropertyValue( BaseStyle, 'height', defaults.height )
	styleHasPropertyValue( BaseStyle, 'anchorX', defaults.anchorX )
	styleHasPropertyValue( BaseStyle, 'anchorY', defaults.anchorY )
	styleHasPropertyValue( BaseStyle, 'type', dUI.ROUNDED )

	view = BaseStyle.view
	vDefaults = view:getDefaultStyleValues()

	styleHasPropertyValue( view, 'debugOn', defaults.debugOn )
	styleHasPropertyValue( view, 'width', defaults.width )
	styleHasPropertyValue( view, 'height', defaults.height )
	styleHasPropertyValue( view, 'anchorX', vDefaults.anchorX )
	styleHasPropertyValue( view, 'anchorY', vDefaults.anchorY )
	styleHasPropertyValue( view, 'fillColor', vDefaults.fillColor )
	styleHasPropertyValue( view, 'strokeColor', vDefaults.strokeColor )
	styleHasPropertyValue( view, 'strokeWidth', vDefaults.strokeWidth )

	--== rectangle

	BaseStyle = Background:getBaseStyle( dUI.RECTANGLE )
	verifyBackgroundStyle( BaseStyle )

	styleInheritsFrom( BaseStyle, BaseStyle.NO_INHERIT )

	-- check properties initialized to the default values

	styleHasPropertyValue( BaseStyle, 'debugOn', defaults.debugOn )
	styleHasPropertyValue( BaseStyle, 'width', defaults.width )
	styleHasPropertyValue( BaseStyle, 'height', defaults.height )
	styleHasPropertyValue( BaseStyle, 'anchorX', defaults.anchorX )
	styleHasPropertyValue( BaseStyle, 'anchorY', defaults.anchorY )
	styleHasPropertyValue( BaseStyle, 'type', dUI.RECTANGLE )

	view = BaseStyle.view
	vDefaults = view:getDefaultStyleValues()

	styleHasPropertyValue( view, 'debugOn', BaseStyle.debugOn )
	styleHasPropertyValue( view, 'width', BaseStyle.width )
	styleHasPropertyValue( view, 'height', BaseStyle.height )
	styleHasPropertyValue( view, 'anchorX', BaseStyle.anchorX )
	styleHasPropertyValue( view, 'anchorY', BaseStyle.anchorY )
	styleHasPropertyValue( view, 'fillColor', vDefaults.fillColor )
	styleHasPropertyValue( view, 'strokeColor', vDefaults.strokeColor )
	styleHasPropertyValue( view, 'strokeWidth', vDefaults.strokeWidth )


	--== Test constructors

	style = dUI.newBackgroundStyle()

	verifyBackgroundStyle( style )
	styleInheritsFrom( BaseStyle, BaseStyle.NO_INHERIT )

	style:removeSelf()

	style = dUI.newRoundedBackgroundStyle()

	verifyBackgroundStyle( style )
	styleInheritsFrom( BaseStyle, BaseStyle.NO_INHERIT )

	style:removeSelf()

	style = dUI.newRectangleBackgroundStyle()

	verifyBackgroundStyle( style )
	styleInheritsFrom( BaseStyle, BaseStyle.NO_INHERIT )

	style:removeSelf()

end



function test_inheritedViewUpdate_levels2_diffType()
	-- print( "test_inheritedViewUpdate_levels2_diffType" )
	local Background = dUI.Style.Background
	local BaseStyle, defaults, vDefaults

	local StyleBase, sbView
	local StyleClass

	local style, sReset, sResetCB
	local sView, sViewReset, sViewCB
	local inherit, iReset, iResetCB
	local iView, iViewReset, iViewDestroy, iViewCB


	iReset = 0
	iResetProperty = 0
	iResetCB = function(e)
		local target=e.target
		if e.type==target.STYLE_RESET then
			iReset=iReset+1
		elseif e.type==target.PROPERTY_CHANGED then
			if e.property=='type' then
			end
			iResetProperty=iResetProperty+1
		end
	end

	iViewReset = 0
	iViewDestroy=0
	iViewCB = function(e)
		local target=e.target
		if e.type==target.STYLE_RESET then
			iViewReset=iViewReset+1
		elseif e.type==target.STYLE_DESTROYED then
			target:removeEventListener( target.EVENT, iViewCB )
			iViewDestroy=iViewDestroy+1
		end
	end

	sReset = 0
	sResetCB = function(e)
		if e.type==style.STYLE_RESET then sReset=sReset+1 end
	end

	sViewReset = 0
	sViewCB = function(e)
		if e.type==style.STYLE_RESET then sViewReset=sViewReset+1 end
	end

	--== Setup Inheritance

	inherit = dUI.newRoundedBackgroundStyle()

	style = dUI.newRoundedBackgroundStyle()
	style.inherit = inherit

	iView = inherit.view
	sView = style.view

	inherit:addEventListener( inherit.EVENT, iResetCB )
	iView:addEventListener( iView.EVENT, iViewCB )

	-- Check properties

	styleInheritsFrom( style, inherit )
	styleInheritsPropertyValue( style, 'type', dUI.ROUNDED )

	styleInheritsFrom( sView, iView )
	hasPropertyValue( sView, 'type', dUI.ROUNDED )

	styleInheritsPropertyValue( sView, 'cornerRadius', iView.cornerRadius )
	styleInheritsPropertyValue( sView, 'fillColor', iView.fillColor )
	styleInheritsPropertyValue( sView, 'strokeColor', iView.strokeColor )
	styleInheritsPropertyValue( sView, 'strokeWidth', iView.strokeWidth )

	--== Change Type

	iReset, iResetProperty = 0,0
	iViewReset, iViewDestroy = 0,0
	inherit.type = dUI.RECTANGLE

	assert_equal( 1, iReset, "incorrect count for iReset" )
	assert_equal( 1, iResetProperty, "incorrect count for iResetProperty" )

	assert_equal( 1, iViewDestroy, "incorrect count for iViewDestroy" )

	-- get new views

	iView = inherit.view
	sView = style.view

	styleInheritsFrom( style, inherit )
	styleInheritsPropertyValue( style, 'type', dUI.RECTANGLE )

	styleInheritsFrom( sView, iView )
	hasPropertyValue( sView, 'type', dUI.RECTANGLE )


end




function test_inheritedViewUpdate_levels3_diffType()
	-- print( "test_inheritedViewUpdate_levels3_diffType" )
	local Background = dUI.Style.Background
	local BaseStyle, defaults, vDefaults

	local StyleBase, sbView
	local StyleClass

	local style, sReset, sResetCB
	local sView, sViewReset, sViewCB
	local inherit, iReset, iResetCB
	local iView, iViewReset, iViewDestroy, iViewCB

	local inherit2, i2Reset, i2ResetCB
	local i2View, i2ViewReset, i2ViewDestroy, i2ViewCB


	iReset = 0
	iResetProperty = 0
	iResetCB = function(e)
		local target=e.target
		if e.type==target.STYLE_RESET then
			iReset=iReset+1
		elseif e.type==target.PROPERTY_CHANGED then
			if e.property=='type' then
			end
			iResetProperty=iResetProperty+1
		end
	end

	iViewReset = 0
	iViewDestroy=0
	iViewCB = function(e)
		local target=e.target
		if e.type==target.STYLE_RESET then
			iViewReset=iViewReset+1
		elseif e.type==target.STYLE_DESTROYED then
			target:removeEventListener( target.EVENT, iViewCB )
			iViewDestroy=iViewDestroy+1
		end
	end

	sReset = 0
	sResetCB = function(e)
		if e.type==style.STYLE_RESET then sReset=sReset+1 end
	end

	sViewReset = 0
	sViewCB = function(e)
		if e.type==style.STYLE_RESET then sViewReset=sViewReset+1 end
	end

	--== Setup Inheritance

	inherit2 = dUI.newRoundedBackgroundStyle()

	inherit = dUI.newRoundedBackgroundStyle()
	inherit.inherit = inherit2

	style = dUI.newRoundedBackgroundStyle()
	style.inherit = inherit

	i2View = inherit2.view
	iView = inherit.view
	sView = style.view

	inherit:addEventListener( inherit.EVENT, iResetCB )
	iView:addEventListener( iView.EVENT, iViewCB )

	-- Check properties

	styleInheritsFrom( inherit, inherit2 )
	styleInheritsPropertyValue( inherit, 'type', dUI.ROUNDED )

	styleInheritsFrom( iView, i2View )
	hasPropertyValue( iView, 'type', dUI.ROUNDED )

	styleInheritsFrom( style, inherit )
	styleInheritsPropertyValue( style, 'type', dUI.ROUNDED )

	styleInheritsFrom( sView, iView )
	hasPropertyValue( sView, 'type', dUI.ROUNDED )

	styleInheritsPropertyValue( sView, 'cornerRadius', iView.cornerRadius )
	styleInheritsPropertyValue( sView, 'fillColor', iView.fillColor )
	styleInheritsPropertyValue( sView, 'strokeColor', iView.strokeColor )
	styleInheritsPropertyValue( sView, 'strokeWidth', iView.strokeWidth )

	--== Change Type

	iReset, iResetProperty = 0,0
	iViewReset, iViewDestroy = 0,0
	inherit2.type = dUI.RECTANGLE

	-- assert_equal( 1, iReset, "incorrect count for iReset" )
	-- assert_equal( 1, iResetProperty, "incorrect count for iResetProperty" )

	-- assert_equal( 1, iViewDestroy, "incorrect count for iViewDestroy" )

	-- get new views

	i2View = inherit2.view
	iView = inherit.view
	sView = style.view

	styleInheritsFrom( inherit, inherit2 )
	styleInheritsPropertyValue( inherit, 'type', dUI.RECTANGLE )

	styleInheritsFrom( iView, i2View )
	hasPropertyValue( iView, 'type', dUI.RECTANGLE )

	styleInheritsFrom( style, inherit )
	styleInheritsPropertyValue( style, 'type', dUI.RECTANGLE )

	styleInheritsFrom( sView, iView )
	hasPropertyValue( sView, 'type', dUI.RECTANGLE )

end



function test_inheritedViewUpdate_levels3_blockType()
	-- print( "test_inheritedViewUpdate_levels3_blockType" )
	local Background = dUI.Style.Background
	local BaseStyle, defaults, vDefaults

	local StyleBase, sbView
	local StyleClass

	local style, sReset, sResetCB
	local sView, sViewReset, sViewCB
	local inherit, iReset, iResetCB
	local iView, iViewReset, iViewDestroy, iViewCB

	local inherit2, i2Reset, i2ResetCB
	local i2View, i2ViewReset, i2ViewDestroy, i2ViewCB

	local BaseStyle = Background:getBaseStyle( dUI.ROUNDED )
	local bsView = BaseStyle.view

	iReset = 0
	iResetProperty = 0
	iResetCB = function(e)
		local target=e.target
		if e.type==target.STYLE_RESET then
			iReset=iReset+1
		elseif e.type==target.PROPERTY_CHANGED then
			if e.property=='type' then
			end
			iResetProperty=iResetProperty+1
		end
	end

	iViewReset = 0
	iViewDestroy=0
	iViewCB = function(e)
		local target=e.target
		if e.type==target.STYLE_RESET then
			iViewReset=iViewReset+1
		elseif e.type==target.STYLE_DESTROYED then
			target:removeEventListener( target.EVENT, iViewCB )
			iViewDestroy=iViewDestroy+1
		end
	end

	sReset = 0
	sResetCB = function(e)
		if e.type==style.STYLE_RESET then sReset=sReset+1 end
	end

	sViewReset = 0
	sViewCB = function(e)
		if e.type==style.STYLE_RESET then sViewReset=sViewReset+1 end
	end

	--== Setup Inheritance

	inherit2 = dUI.newRoundedBackgroundStyle()

	inherit = dUI.newRoundedBackgroundStyle()
	inherit.inherit = inherit2
	inherit.type = dUI.ROUNDED -- block type

	style = dUI.newRoundedBackgroundStyle()
	style.inherit = inherit

	i2View = inherit2.view
	iView = inherit.view
	sView = style.view

	inherit:addEventListener( inherit.EVENT, iResetCB )
	iView:addEventListener( iView.EVENT, iViewCB )

	-- Check properties

	styleInheritsFrom( inherit2, BaseStyle )
	styleInheritsPropertyValue( inherit2, 'type', dUI.ROUNDED )

	styleInheritsFrom( inherit, inherit2 )
	styleHasPropertyValue( inherit, 'type', dUI.ROUNDED )

	styleInheritsFrom( iView, bsView )
	hasPropertyValue( iView, 'type', dUI.ROUNDED )

	styleInheritsFrom( style, inherit )
	styleInheritsPropertyValue( style, 'type', dUI.ROUNDED )

	styleInheritsFrom( sView, iView )
	hasPropertyValue( sView, 'type', dUI.ROUNDED )

	styleInheritsPropertyValue( sView, 'cornerRadius', iView.cornerRadius )
	styleInheritsPropertyValue( sView, 'fillColor', iView.fillColor )
	styleInheritsPropertyValue( sView, 'strokeColor', iView.strokeColor )
	styleInheritsPropertyValue( sView, 'strokeWidth', iView.strokeWidth )

	--== Change Type

	iReset, iResetProperty = 0,0
	iViewReset, iViewDestroy = 0,0

	inherit2.type = dUI.RECTANGLE

	-- assert_equal( 1, iReset, "incorrect count for iReset" )
	-- assert_equal( 1, iResetProperty, "incorrect count for iResetProperty" )

	-- assert_equal( 1, iViewDestroy, "incorrect count for iViewDestroy" )

	-- get new views

	local rBaseStyle = Background:getBaseStyle( inherit2.type )
	local rBsView = rBaseStyle.view

	local rBaseStyle = Background:getBaseStyle( inherit2.type )
	local rBsView = rBaseStyle.view


	i2View = inherit2.view

	styleInheritsFrom( inherit2, BaseStyle )
	styleHasPropertyValue( inherit2, 'type', dUI.RECTANGLE )

	styleInheritsFrom( inherit, inherit2 )
	styleHasPropertyValue( inherit, 'type', dUI.ROUNDED )

	styleInheritsFrom( iView, bsView )
	hasPropertyValue( iView, 'type', dUI.ROUNDED )

	styleInheritsFrom( style, inherit )
	styleInheritsPropertyValue( style, 'type', dUI.ROUNDED )

	styleInheritsFrom( sView, iView )
	hasPropertyValue( sView, 'type', dUI.ROUNDED )

end



--[[
CHANGE Type
with:
unset Inherit
same Type
--]]
function test_updateView_deltaTYPE_unsetI_sameT()
	-- print( "test_updateView_deltaTYPE_unsetI_sameT" )
	local Background = dUI.Style.Background
	local BaseStyle, defaults, vDefaults

	local BaseStyle, sbView
	local StyleClass

	local style, sReset, sResetCB
	local sView, sViewReset, sViewCB
	local inherit, iReset, iResetCB
	local iView, iViewReset, iViewCB


	sReset = 0
	sResetCB = function(e)
		if e.type==style.STYLE_RESET then sReset=sReset+1 end
	end

	sViewReset = 0
	sViewCB = function(e)
		if e.type==style.STYLE_RESET then sViewReset=sViewReset+1 end
	end

	--== Setup Rounded

	style = dUI.newRoundedBackgroundStyle()
	sView = style.view

	BaseStyle = Background:getBaseStyle( style.type )
	bsView = BaseStyle.view

	styleInheritsFrom( style, BaseStyle )
	styleInheritsPropertyValue( style, 'type', dUI.ROUNDED )

	styleInheritsFrom( sView, bsView )
	styleInheritsPropertyValue( sView, 'cornerRadius', bsView.cornerRadius )
	styleInheritsPropertyValue( sView, 'fillColor', bsView.fillColor )
	styleInheritsPropertyValue( sView, 'strokeColor', bsView.strokeColor )
	styleInheritsPropertyValue( sView, 'strokeWidth', bsView.strokeWidth )

	--== Change Type - same

	sReset = 0
	sViewReset = 0
	style.type = style.type

	assert_equal( 0, sReset, "incorrect count for sReset" )
	assert_equal( 0, sViewReset, "incorrect count for sViewReset" )

	styleInheritsFrom( style, BaseStyle )
	styleHasPropertyValue( style, 'type', dUI.ROUNDED )

	styleInheritsFrom( sView, bsView )
	styleHasPropertyValue( sView, 'cornerRadius', bsView.cornerRadius )
	styleHasPropertyValue( sView, 'fillColor', bsView.fillColor )
	styleHasPropertyValue( sView, 'strokeColor', bsView.strokeColor )
	styleHasPropertyValue( sView, 'strokeWidth', bsView.strokeWidth )

end


--[[
CHANGE Type
with:
unset Inherit
different Type
--]]
function test_updateView_deltaTYPE_unsetI_diffT()
	-- print( "test_updateView_deltaTYPE_unsetI_diffT" )
	local Background = dUI.Style.Background
	local BaseStyle, defaults, vDefaults

	local StyleBase, sbView
	local StyleBase2, sbView2
	local StyleClass

	local style, sReset, sResetCB
	local sView, sViewReset, sViewCB
	local inherit, iReset, iResetCB
	local iView, iViewReset, iViewCB


	sReset = 0
	sResetCB = function(e)
		if e.type==style.STYLE_RESET then sReset=sReset+1 end
	end

	sViewReset = 0
	sViewCB = function(e)
		if e.type==style.STYLE_RESET then sViewReset=sViewReset+1 end
	end

	--== Setup Rounded

	style = dUI.newRoundedBackgroundStyle()

	StyleBase = Background:getBaseStyle( style.type )
	sbView = StyleBase.view
	styleHasPropertyValue( StyleBase, 'type', dUI.ROUNDED )
	hasPropertyValue( sbView, 'type', dUI.ROUNDED )

	sView = style.view
	style:addEventListener( style.EVENT, sResetCB )
	sView:addEventListener( sView.EVENT, sViewCB )


	styleInheritsFrom( style, StyleBase )
	styleInheritsPropertyValue( style, 'type', dUI.ROUNDED )

	styleInheritsFrom( sView, sbView )
	hasPropertyValue( sView, 'type', dUI.ROUNDED )

	styleInheritsPropertyValue( sView, 'cornerRadius', sbView.cornerRadius )
	styleInheritsPropertyValue( sView, 'fillColor', sbView.fillColor )
	styleInheritsPropertyValue( sView, 'strokeColor', sbView.strokeColor )
	styleInheritsPropertyValue( sView, 'strokeWidth', sbView.strokeWidth )

	--== Change Type - different

	sReset = 0
	sViewReset = 0
	style.type = dUI.RECTANGLE

	StyleBase2 = Background:getBaseStyle( style.type )
	sbView2 = StyleBase2.view
	styleHasPropertyValue( StyleBase2, 'type', dUI.RECTANGLE )
	hasPropertyValue( sbView2, 'type', dUI.RECTANGLE )

	sView = style.view

	assert_gt( 0, sReset, "incorrect count for sReset" )
	-- assert_gt( 0, sViewReset, "incorrect count for sViewReset" )

	styleInheritsFrom( style, StyleBase )
	styleHasPropertyValue( style, 'type', dUI.RECTANGLE )

	styleInheritsFrom( sView, sbView2 )
	hasPropertyValue( style, 'type', dUI.RECTANGLE )

	styleRawPropertyValueIs( sView, 'cornerRadius', nil )
	styleHasPropertyValue( sView, 'fillColor', sbView2.fillColor )
	styleHasPropertyValue( sView, 'strokeColor', sbView2.strokeColor )
	styleHasPropertyValue( sView, 'strokeWidth', sbView2.strokeWidth )

end


--[[
CHANGE Inherit
with:
unset Inherit
same Type
--]]
function test_updateView_deltaINHERIT_unsetI_sameT()
	-- print( "test_updateView_deltaINHERIT_unsetI_sameT" )
	local Background = dUI.Style.Background
	local BaseStyle, defaults, vDefaults

	local StyleBase, sbView
	local StyleClass

	local style, sReset, sResetCB
	local sView, sViewReset, sViewCB
	local inherit, iReset, iResetCB
	local iView, iViewReset, iViewCB


	sReset = 0
	sResetCB = function(e)
		if e.type==style.STYLE_RESET then sReset=sReset+1 end
	end

	sViewReset = 0
	sViewCB = function(e)
		if e.type==style.STYLE_RESET then sViewReset=sViewReset+1 end
	end

	--== Setup Rounded

	style = dUI.newRoundedBackgroundStyle()

	StyleBase = Background:getBaseStyle( style.type )
	sbView = StyleBase.view
	styleHasPropertyValue( StyleBase, 'type', dUI.ROUNDED )
	hasPropertyValue( sbView, 'type', dUI.ROUNDED )

	sView = style.view
	style:addEventListener( style.EVENT, sResetCB )
	sView:addEventListener( sView.EVENT, sViewCB )

	-- Check properties

	styleInheritsFrom( style, StyleBase )
	styleInheritsPropertyValue( style, 'type', dUI.ROUNDED )

	styleInheritsFrom( sView, sbView )
	hasPropertyValue( sView, 'type', dUI.ROUNDED )

	styleInheritsPropertyValue( sView, 'cornerRadius', sbView.cornerRadius )
	styleInheritsPropertyValue( sView, 'fillColor', sbView.fillColor )
	styleInheritsPropertyValue( sView, 'strokeColor', sbView.strokeColor )
	styleInheritsPropertyValue( sView, 'strokeWidth', sbView.strokeWidth )

	--== Setup Inherit Style


	inherit = dUI.newRoundedBackgroundStyle()

	iView = inherit.view

	-- inherit:addEventListener( inherit.EVENT, iResetCB )
	-- iView:addEventListener( iView.EVENT, iViewResetCB )

	-- Check properties

	styleInheritsFrom( inherit, StyleBase )
	styleInheritsPropertyValue( inherit, 'type', dUI.ROUNDED )

	styleInheritsFrom( iView, sbView )

	styleInheritsPropertyValue( iView, 'cornerRadius', sbView.cornerRadius )
	styleInheritsPropertyValue( iView, 'fillColor', sbView.fillColor )
	styleInheritsPropertyValue( iView, 'strokeColor', sbView.strokeColor )
	styleInheritsPropertyValue( iView, 'strokeWidth', sbView.strokeWidth )

	--== Change Inheritance - same type

	sReset = 0
	sViewReset = 0
	style.inherit = inherit

	sView = style.view

	assert_gt( 0, sReset, "incorrect count for sReset" )
	assert_gt( 0, sViewReset, "incorrect count for sViewReset" )

	styleInheritsFrom( style, inherit )
	styleInheritsProperty( style, 'type', dUI.ROUNDED )

	styleInheritsFrom( sView, iView )
	hasPropertyValue( sView, 'type', dUI.ROUNDED )

	styleInheritsProperty( sView, 'cornerRadius', iView.cornerRadius )
	styleInheritsProperty( sView, 'fillColor', iView.fillColor )
	styleInheritsProperty( sView, 'strokeColor', iView.strokeColor )
	styleInheritsProperty( sView, 'strokeWidth', iView.strokeWidth )


	-- check changes

	iView.strokeWidth=99
	styleHasProperty( iView, 'strokeWidth', 99 )

	styleInheritsProperty( sView, 'strokeWidth', 99 )

end


--[[
CHANGE Inherit
with:
unset Inherit
different Type
--]]
function test_updateView_deltaINHERIT_unsetI_diffT()
	-- print( "test_updateView_deltaINHERIT_unsetI_diffT" )
	local Background = dUI.Style.Background
	local BaseStyle, defaults, vDefaults

	local StyleBase, sbView
	local StyleClass

	local style, sReset, sResetCB
	local sView, sViewReset, sViewCB
	local inherit, iReset, iResetCB
	local iView, iViewReset, iViewCB


	sReset = 0
	sResetCB = function(e)
		if e.type==style.STYLE_RESET then sReset=sReset+1 end
	end

	sViewReset = 0
	sViewCB = function(e)
		if e.type==style.STYLE_RESET then sViewReset=sViewReset+1 end
	end

	--== Setup Rounded

	style = dUI.newRoundedBackgroundStyle()

	StyleBase = Background:getBaseStyle( style.type )
	sbView = StyleBase.view
	styleHasPropertyValue( StyleBase, 'type', dUI.ROUNDED )
	hasPropertyValue( sbView, 'type', dUI.ROUNDED )

	sView = style.view
	style:addEventListener( style.EVENT, sResetCB )
	sView:addEventListener( sView.EVENT, sViewCB )

	-- Check properties

	styleInheritsFrom( style, StyleBase )
	styleInheritsPropertyValue( style, 'type', dUI.ROUNDED )

	styleInheritsFrom( sView, sbView )
	hasPropertyValue( sView, 'type', dUI.ROUNDED )

	styleInheritsPropertyValue( sView, 'cornerRadius', sbView.cornerRadius )
	styleInheritsPropertyValue( sView, 'fillColor', sbView.fillColor )
	styleInheritsPropertyValue( sView, 'strokeColor', sbView.strokeColor )
	styleInheritsPropertyValue( sView, 'strokeWidth', sbView.strokeWidth )

	--== Setup Inherit Style

	inherit = dUI.newRectangleBackgroundStyle()

	StyleBase = Background:getBaseStyle( inherit.type )
	sbView = StyleBase.view

	iView = inherit.view

	-- inherit:addEventListener( inherit.EVENT, iResetCB )
	-- iView:addEventListener( iView.EVENT, iViewResetCB )

	-- Check properties

	styleInheritsFrom( inherit, StyleBase )
	styleInheritsPropertyValue( inherit, 'type', dUI.RECTANGLE )

	styleInheritsFrom( iView, sbView )
	styleRawPropertyValueIs( iView, 'cornerRadius', nil )
	styleInheritsPropertyValue( iView, 'fillColor', sbView.fillColor )
	styleInheritsPropertyValue( iView, 'strokeColor', sbView.strokeColor )
	styleInheritsPropertyValue( iView, 'strokeWidth', sbView.strokeWidth )

	--== Change Inheritance - same type

	sReset = 0
	sViewReset = 0
	style.inherit = inherit

	sView = style.view

	assert_gt( 0, sReset, "incorrect count for sReset" )
	-- assert_gt( 0, sViewReset, "incorrect count for sViewReset" )

	styleInheritsFrom( style, inherit )
	styleInheritsPropertyValue( style, 'type', dUI.RECTANGLE )

	styleInheritsFrom( sView, iView )
	hasPropertyValue( sView, 'type', dUI.RECTANGLE )
	styleRawPropertyValueIs( sView, 'cornerRadius', nil )
	styleInheritsProperty( sView, 'fillColor', iView.fillColor )
	styleInheritsProperty( sView, 'strokeColor', iView.strokeColor )
	styleInheritsProperty( sView, 'strokeWidth', iView.strokeWidth )

	-- check changes

	iView.strokeWidth=99
	styleHasProperty( iView, 'strokeWidth', 99 )

	styleInheritsProperty( sView, 'strokeWidth', 99 )

end



--[[
CHANGE Type
with:
set Inherit
same Type
--]]
function test_updateView_deltaTYPE_setI_sameT()
	-- print( "test_updateView_deltaTYPE_setI_sameT" )
	local Background = dUI.Style.Background
	local BaseStyle, defaults, vDefaults

	local StyleBase, sbView
	local StyleClass

	local style, sReset, sResetCB
	local sView, sViewReset, sViewCB
	local inherit, iReset, iResetCB
	local iView, iViewReset, iViewCB


	sReset = 0
	sResetCB = function(e)
		if e.type==style.STYLE_RESET then sReset=sReset+1 end
	end

	sViewReset = 0
	sViewCB = function(e)
		if e.type==style.STYLE_RESET then sViewReset=sViewReset+1 end
	end

	--== Setup Inheritance

	inherit = dUI.newRoundedBackgroundStyle()
	iView = inherit.view

	style = dUI.newRoundedBackgroundStyle()
	style.inherit = inherit

	sView = style.view

	style:addEventListener( style.EVENT, sResetCB )

	-- Quick Property Check

	styleInheritsFrom( style, inherit )
	styleInheritsPropertyValue( style, 'type', dUI.ROUNDED )

	styleInheritsFrom( sView, iView )
	hasPropertyValue( sView, 'type', dUI.ROUNDED )
	styleInheritsProperty( sView, 'cornerRadius', iView.cornerRadius )
	styleInheritsProperty( sView, 'fillColor', iView.fillColor )
	styleInheritsProperty( sView, 'strokeColor', iView.strokeColor )
	styleInheritsProperty( sView, 'strokeWidth', iView.strokeWidth )

	iView.strokeWidth=99
	styleHasProperty( iView, 'strokeWidth', 99 )

	styleInheritsProperty( sView, 'strokeWidth', 99 )

	--== Change Type, same

	sReset = 0
	sViewReset = 0
	style.type = dUI.ROUNDED

	sView = style.view -- attach to new view

	assert_gt( 0, sReset, "incorrect count for sReset" )
	-- assert_gt( 0, sViewReset, "incorrect count for sViewReset" )

	StyleBase = Background:getBaseStyle( style.type )
	sbView = StyleBase.view
	styleHasPropertyValue( StyleBase, 'type', dUI.ROUNDED )
	hasPropertyValue( sbView, 'type', dUI.ROUNDED )


	-- Check properties

	styleInheritsFrom( style, inherit )
	styleHasPropertyValue( style, 'type', dUI.ROUNDED )

	styleInheritsFrom( sView, sbView )
	hasPropertyValue( sView, 'type', dUI.ROUNDED )

	styleHasPropertyValue( sView, 'cornerRadius', iView.cornerRadius )
	styleHasPropertyValue( sView, 'fillColor', iView.fillColor )
	styleHasPropertyValue( sView, 'strokeColor', iView.strokeColor )
	styleHasPropertyValue( sView, 'strokeWidth', iView.strokeWidth )

	local sw = iView.strokeWidth

	--== Setup Inherit Style

	-- check changes

	iView.strokeWidth=99
	styleHasProperty( iView, 'strokeWidth', 99 )

	-- value should stay same, inheritance is stopped for view

	styleHasPropertyValue( sView, 'strokeWidth', sw )

end


--[[
CHANGE Type
with:
set Inherit
different Type
--]]
function test_updateView_deltaTYPE_setI_diffT()
	-- print( "test_updateView_deltaTYPE_setI_diffT" )
	local Background = dUI.Style.Background
	local BaseStyle, defaults, vDefaults

	local StyleBase, sbView
	local StyleClass

	local style, sReset, sResetCB
	local sView, sViewReset, sViewCB
	local inherit, iReset, iResetCB
	local iView, iViewReset, iViewCB


	sReset = 0
	sResetCB = function(e)
		if e.type==style.STYLE_RESET then sReset=sReset+1 end
	end

	sViewReset = 0
	sViewCB = function(e)
		if e.type==style.STYLE_RESET then sViewReset=sViewReset+1 end
	end

	--== Setup Inheritance

	inherit = dUI.newRoundedBackgroundStyle()
	iView = inherit.view

	style = dUI.newRoundedBackgroundStyle()
	style.inherit = inherit

	sView = style.view

	style:addEventListener( style.EVENT, sResetCB )

	-- Quick Property Check

	styleInheritsFrom( style, inherit )
	styleInheritsPropertyValue( style, 'type', dUI.ROUNDED )

	styleInheritsFrom( sView, iView )
	hasPropertyValue( sView, 'type', dUI.ROUNDED )
	styleInheritsProperty( sView, 'cornerRadius', iView.cornerRadius )
	styleInheritsProperty( sView, 'fillColor', iView.fillColor )
	styleInheritsProperty( sView, 'strokeColor', iView.strokeColor )
	styleInheritsProperty( sView, 'strokeWidth', iView.strokeWidth )

	iView.strokeWidth=99
	styleHasProperty( iView, 'strokeWidth', 99 )

	styleInheritsProperty( sView, 'strokeWidth', 99 )

	--== Change Type, same

	sReset = 0
	sViewReset = 0
	style.type = dUI.RECTANGLE

	sView = style.view -- attach to new view

	assert_gt( 0, sReset, "incorrect count for sReset" )
	-- assert_gt( 0, sViewReset, "incorrect count for sViewReset" )

	StyleBase = Background:getBaseStyle( style.type )
	sbView = StyleBase.view
	styleHasPropertyValue( StyleBase, 'type', dUI.RECTANGLE )
	hasPropertyValue( sbView, 'type', dUI.RECTANGLE )


	-- Check properties

	styleInheritsFrom( style, inherit )
	styleHasPropertyValue( style, 'type', dUI.RECTANGLE )

	styleInheritsFrom( sView, sbView )
	hasPropertyValue( sView, 'type', dUI.RECTANGLE )

	styleRawPropertyValueIs( sView, 'cornerRadius', nil )
	styleHasPropertyValue( sView, 'fillColor', sbView.fillColor )
	styleHasPropertyValue( sView, 'strokeColor', sbView.strokeColor )
	styleHasPropertyValue( sView, 'strokeWidth', sbView.strokeWidth )

	--== Setup Inherit Style

	-- check changes

	iView.strokeWidth=99
	styleHasProperty( iView, 'strokeWidth', 99 )

	-- value should stay same, inheritance is stopped for view

	styleHasPropertyValue( sView, 'strokeWidth', sbView.strokeWidth )

end



--[[
CHANGE Inherit
with:
set Inherit
unset Type
--]]
function test_updateView_deltaINHERIT_setI_unsetT()
	-- print( "test_updateView_deltaINHERIT_setI_unsetT" )
	local Background = dUI.Style.Background
	local BaseStyle, defaults, vDefaults

	local StyleBase, sbView
	local StyleClass

	local style, sReset, sResetCB
	local sView, sViewReset, sViewCB
	local inherit, iReset, iResetCB
	local iView, iViewReset, iViewCB


	sReset = 0
	sResetCB = function(e)
		if e.type==style.STYLE_RESET then sReset=sReset+1 end
	end

	sViewReset = 0
	sViewCB = function(e)
		if e.type==style.STYLE_RESET then sViewReset=sViewReset+1 end
	end

	--== Setup Test (unset inheritance)

	inherit = dUI.newRoundedBackgroundStyle()
	iView = inherit.view

	style = dUI.newRoundedBackgroundStyle()
	style.inherit = inherit

	sView = style.view

	style:addEventListener( style.EVENT, sResetCB )

	-- Quick Property Check

	styleInheritsFrom( style, inherit )
	styleInheritsPropertyValue( style, 'type', dUI.ROUNDED )

	styleInheritsFrom( sView, iView )
	hasPropertyValue( sView, 'type', dUI.ROUNDED )
	styleInheritsProperty( sView, 'cornerRadius', iView.cornerRadius )
	styleInheritsProperty( sView, 'fillColor', iView.fillColor )
	styleInheritsProperty( sView, 'strokeColor', iView.strokeColor )
	styleInheritsProperty( sView, 'strokeWidth', iView.strokeWidth )

	iView.fillColor={8,1,3}
	iView.strokeWidth=99
	styleHasPropertyValue( iView, 'fillColor', {8,1,3} )
	styleHasPropertyValue( iView, 'strokeWidth', 99 )

	styleInheritsProperty( sView, 'fillColor', {8,1,3} )
	styleInheritsProperty( sView, 'strokeWidth', 99 )

	--== Unset (break) Inheritance

	sReset = 0
	sViewReset = 0
	style.inherit = nil

	sView = style.view -- attach to new view

	assert_equal( 1, sReset, "incorrect count for sReset" )

	StyleBase = Background:getBaseStyle( style.type )
	sbView = StyleBase.view
	styleHasPropertyValue( StyleBase, 'type', dUI.ROUNDED )
	hasPropertyValue( sbView, 'type', dUI.ROUNDED )


	-- Check properties

	styleInheritsFrom( style, StyleBase )
	styleInheritsPropertyValue( style, 'type', dUI.ROUNDED )

	styleInheritsFrom( sView, sbView )
	hasPropertyValue( sView, 'type', dUI.ROUNDED )

	styleInheritsPropertyValue( sView, 'cornerRadius', sbView.cornerRadius )
	styleInheritsPropertyValue( sView, 'fillColor', sbView.fillColor )
	styleInheritsPropertyValue( sView, 'strokeColor', sbView.strokeColor )
	styleInheritsPropertyValue( sView, 'strokeWidth', sbView.strokeWidth )

	--== Setup Inherit Style

	-- check changes

	iView.strokeWidth=99
	styleHasProperty( iView, 'strokeWidth', 99 )

	-- value should stay same, inheritance is stopped for view

	styleInheritsPropertyValue( sView, 'strokeWidth', sbView.strokeWidth )

end




--[[
CHANGE Inherit
with:
set Inherit
set Type (to same)
--]]
function test_updateView_deltaINHERIT_setI_setSameT()
	-- print( "test_updateView_deltaINHERIT_setI_setSameT" )
	local Background = dUI.Style.Background
	local BaseStyle, defaults, vDefaults

	local StyleBase, sbView
	local StyleClass

	local style, sReset, sResetCB
	local sView, sViewReset, sViewCB
	local inherit, iReset, iResetCB
	local iView, iViewReset, iViewCB


	sReset = 0
	sResetCB = function(e)
		if e.type==style.STYLE_RESET then sReset=sReset+1 end
	end

	sViewReset = 0
	sViewCB = function(e)
		if e.type==style.STYLE_RESET then sViewReset=sViewReset+1 end
	end

	--== Setup Test

	inherit = dUI.newRoundedBackgroundStyle()
	iView = inherit.view

	style = dUI.newRoundedBackgroundStyle()
	style.inherit = inherit

	style.type = dUI.ROUNDED -- set same type

	StyleBase = Background:getBaseStyle( style.type )
	sbView = StyleBase.view

	sView = style.view

	style:addEventListener( style.EVENT, sResetCB )

	-- Quick Property Check

	styleInheritsFrom( style, inherit )
	styleHasPropertyValue( style, 'type', dUI.ROUNDED )

	styleInheritsFrom( sView, sbView )
	hasPropertyValue( sView, 'type', dUI.ROUNDED )
	styleHasPropertyValue( sView, 'cornerRadius', iView.cornerRadius )
	styleHasPropertyValue( sView, 'fillColor', iView.fillColor )
	styleHasPropertyValue( sView, 'strokeColor', iView.strokeColor )
	styleHasPropertyValue( sView, 'strokeWidth', iView.strokeWidth )

	iView.fillColor={8,1,3}
	iView.strokeWidth=99
	styleHasPropertyValue( iView, 'fillColor', {8,1,3} )
	styleHasPropertyValue( iView, 'strokeWidth', 99 )

	styleHasPropertyValue( sView, 'fillColor', sbView.fillColor )
	styleHasPropertyValue( sView, 'strokeWidth', sbView.strokeWidth )

	--== Unset (break) Inheritance

	sReset = 0
	sViewReset = 0
	style.inherit = nil

	sView = style.view -- attach to new view

	assert_equal( 1, sReset, "incorrect count for sReset" )

	StyleBase = Background:getBaseStyle( style.type )
	sbView = StyleBase.view
	styleHasPropertyValue( StyleBase, 'type', dUI.ROUNDED )
	hasPropertyValue( sbView, 'type', dUI.ROUNDED )

	-- Check properties

	styleInheritsFrom( style, StyleBase )
	styleInheritsPropertyValue( style, 'type', dUI.ROUNDED )

	styleInheritsFrom( sView, sbView )
	hasPropertyValue( sView, 'type', dUI.ROUNDED )

	styleInheritsPropertyValue( sView, 'cornerRadius', sbView.cornerRadius )
	styleInheritsPropertyValue( sView, 'fillColor', sbView.fillColor )
	styleInheritsPropertyValue( sView, 'strokeColor', sbView.strokeColor )
	styleInheritsPropertyValue( sView, 'strokeWidth', sbView.strokeWidth )

	--== Setup Inherit Style

	-- check changes

	iView.strokeWidth=99
	styleHasProperty( iView, 'strokeWidth', 99 )

	-- value should stay same, inheritance is stopped for view

	styleInheritsPropertyValue( sView, 'strokeWidth', sbView.strokeWidth )

end




--[[
CHANGE Inherit
with:
set Inherit
set Type (to different)
--]]
function test_updateView_deltaINHERIT_setI_setDiffT()
	-- print( "test_updateView_deltaINHERIT_setI_setDiffT" )
	local Background = dUI.Style.Background
	local BaseStyle, defaults, vDefaults

	local StyleBase, sbView
	local StyleClass

	local style, sReset, sResetCB
	local sView, sViewReset, sViewCB
	local inherit, iReset, iResetCB
	local iView, iViewReset, iViewCB


	sReset = 0
	sResetCB = function(e)
		if e.type==style.STYLE_RESET then sReset=sReset+1 end
	end

	sViewReset = 0
	sViewCB = function(e)
		if e.type==style.STYLE_RESET then sViewReset=sViewReset+1 end
	end

	--== Setup Test

	inherit = dUI.newRoundedBackgroundStyle()
	iView = inherit.view

	iView.fillColor={8,1,3}
	iView.strokeWidth=99

	styleHasPropertyValue( iView, 'fillColor', {8,1,3} )
	styleHasPropertyValue( iView, 'strokeWidth', 99 )


	style = dUI.newRoundedBackgroundStyle()
	style.inherit = inherit

	style.type = dUI.RECTANGLE -- set same type

	StyleBase = Background:getBaseStyle( style.type )
	sbView = StyleBase.view

	sView = style.view

	style:addEventListener( style.EVENT, sResetCB )

	-- Quick Property Check

	styleInheritsFrom( style, inherit )
	styleHasPropertyValue( style, 'type', dUI.RECTANGLE )

	styleInheritsFrom( sView, sbView )
	hasPropertyValue( sView, 'type', dUI.RECTANGLE )
	styleRawPropertyValueIs( sView, 'cornerRadius', nil )
	styleHasPropertyValue( sView, 'fillColor', sbView.fillColor )
	styleHasPropertyValue( sView, 'strokeColor', sbView.strokeColor )
	styleHasPropertyValue( sView, 'strokeWidth', sbView.strokeWidth )

	sView.strokeWidth = 101

	styleHasPropertyValue( sView, 'strokeWidth', 101 )

	--== Unset (break) Inheritance

	sReset = 0
	sViewReset = 0
	style.inherit = nil

	sView = style.view -- attach to new view

	StyleBase = Background:getBaseStyle( style.type )
	sbView = StyleBase.view

	styleInheritsFrom( style, StyleBase )
	styleInheritsPropertyValue( style, 'type', dUI.ROUNDED )

	styleInheritsFrom( sView, sbView )
	styleInheritsPropertyValue( sView, 'strokeWidth', sbView.strokeWidth )

	assert_equal( 1, sReset, "incorrect count for sReset" )

	-- Check properties

	styleInheritsFrom( style, StyleBase )
	styleInheritsPropertyValue( style, 'type', dUI.ROUNDED )

	styleInheritsFrom( sView, sbView )
	hasPropertyValue( sView, 'type', dUI.ROUNDED )

	styleRawPropertyValueIs( sView, 'cornerRadius', nil )
	styleInheritsPropertyValue( sView, 'fillColor', sbView.fillColor )
	styleInheritsPropertyValue( sView, 'strokeColor', sbView.strokeColor )
	styleInheritsPropertyValue( sView, 'strokeWidth', sView.strokeWidth )

	--== Setup Inherit Style

	-- check changes

	iView.strokeWidth=99
	styleHasProperty( iView, 'strokeWidth', 99 )

	-- value should stay same, inheritance is stopped for view

	styleInheritsPropertyValue( sView, 'strokeWidth', sView.strokeWidth )

end




--[[
CHANGE Inherit
with:
unset Inherit
set Type
--]]
function test_updateView_deltaINHERIT_unsetI_setT()
	-- print( "test_updateView_deltaINHERIT_unsetI_setT" )
	local Background = dUI.Style.Background
	local BaseStyle, defaults, vDefaults

	local StyleBase, sbView
	local StyleClass

	local style, sReset, sResetCB
	local sView, sViewReset, sViewCB
	local inherit, iReset, iResetCB
	local iView, iViewReset, iViewCB


	sReset = 0
	sResetCB = function(e)
		if e.type==style.STYLE_RESET then sReset=sReset+1 end
	end

	sViewReset = 0
	sViewCB = function(e)
		if e.type==style.STYLE_RESET then sViewReset=sViewReset+1 end
	end

	--== Setup Test

	style = dUI.newRoundedBackgroundStyle()

	StyleBase = Background:getBaseStyle( style.type )
	sbView = StyleBase.view

	sView = style.view

	style:addEventListener( style.EVENT, sResetCB )

	-- Quick Property Check

	styleInheritsFrom( style, StyleBase )
	styleInheritsPropertyValue( style, 'type', dUI.ROUNDED )

	styleInheritsFrom( sView, sbView )
	hasPropertyValue( sView, 'type', dUI.ROUNDED )
	styleInheritsPropertyValue( sView, 'cornerRadius', sbView.cornerRadius )
	styleInheritsPropertyValue( sView, 'fillColor', sbView.fillColor )
	styleInheritsPropertyValue( sView, 'strokeColor', sbView.strokeColor )
	styleInheritsPropertyValue( sView, 'strokeWidth', sbView.strokeWidth )


	--== Unset (break) Inheritance

	sReset = 0
	sViewReset = 0
	style.inherit = nil

	sView = style.view -- attach to new view

	styleInheritsPropertyValue( sView, 'strokeWidth', sbView.strokeWidth )

	assert_equal( 1, sReset, "incorrect count for sReset" )

	StyleBase = Background:getBaseStyle( style.type )
	sbView = StyleBase.view
	styleHasPropertyValue( StyleBase, 'type', dUI.ROUNDED )
	hasPropertyValue( sbView, 'type', dUI.ROUNDED )

	-- Check properties

	styleInheritsFrom( style, StyleBase )
	styleInheritsPropertyValue( style, 'type', dUI.ROUNDED )

	styleInheritsFrom( sView, sbView )
	hasPropertyValue( sView, 'type', dUI.ROUNDED )

	styleInheritsPropertyValue( sView, 'cornerRadius', sbView.cornerRadius )
	styleInheritsPropertyValue( sView, 'fillColor', sbView.fillColor )
	styleInheritsPropertyValue( sView, 'strokeColor', sbView.strokeColor )
	styleInheritsPropertyValue( sView, 'strokeWidth', sbView.strokeWidth )

	--== Setup Inherit Style


end





--[[
--]]
function test_clearProperties()
	-- print( "test_clearProperties" )
	local Background = dUI.Style.Background
	local BaseStyle, defaults, vDefaults

	local StyleBase, sbView
	local StyleClass

	local style, sReset, sResetCB
	local sView, sViewReset, sViewCB
	local inherit, iReset, iResetCB
	local iView, iViewReset, iViewCB


	sReset = 0
	sResetCB = function(e)
		if e.type==style.STYLE_RESET then sReset=sReset+1 end
	end

	sViewReset = 0
	sViewCB = function(e)
		if e.type==style.STYLE_RESET then sViewReset=sViewReset+1 end
	end

	--== clear properties on non-inherited

	-- by default, style from nil

	style = dUI.newRoundedBackgroundStyle{
		view={
			cornerRadius=101,
			strokeWidth=42,
		}
	}
	sView = style.view

	style:addEventListener( style.EVENT, sResetCB )
	sView:addEventListener( sView.EVENT, sViewCB )

	StyleBase = Background:getBaseStyle( style.type )
	sbView = StyleBase.view

	styleInheritsFrom( style, StyleBase )
	styleInheritsFrom( sView, sbView )

	-- check local properties

	styleInheritsPropertyValue( style, 'type', dUI.ROUNDED )

	styleHasPropertyValue( sView, 'cornerRadius', 101 )
	styleInheritsPropertyValue( sView, 'fillColor', sbView.fillColor )
	styleInheritsPropertyValue( sView, 'strokeColor', sbView.strokeColor )
	styleHasPropertyValue( sView, 'strokeWidth', 42 )

	--== Clear Properties, with no inherit

	sReset = 0
	sViewReset = 0
	style:clearProperties()

	assert_gt( 0, sReset, "incorrect count for sReset" )
	assert_gt( 0, sViewReset, "incorrect count for sViewReset" )

	styleInheritsPropertyValue( sView, 'cornerRadius', sbView.cornerRadius )
	styleInheritsPropertyValue( sView, 'fillColor', sbView.fillColor )
	styleInheritsPropertyValue( sView, 'strokeColor', sbView.strokeColor )
	styleInheritsPropertyValue( sView, 'strokeWidth', sbView.strokeWidth )


	--== Create inherit

	iReset = 0
	iResetCB = function(e)
		if e.type==style.STYLE_RESET then iReset=iReset+1 end
	end

	iViewReset = 0
	iViewResetCB = function(e)
		if e.type==style.STYLE_RESET then iViewReset=iViewReset+1 end
	end

	inherit = dUI.newRoundedBackgroundStyle{
		view={
			strokeColor={0.15, 0.15, 0,15},
			strokeWidth=99
		}
	}
	iView = inherit.view

	StyleBase = Background:getBaseStyle( inherit.type )
	sbView = StyleBase.view

	styleInheritsFrom( inherit, StyleBase )
	styleInheritsFrom( iView, sbView )

	inherit:addEventListener( inherit.EVENT, iResetCB )
	iView:addEventListener( iView.EVENT, iViewResetCB )

	-- check properties

	styleInheritsPropertyValue( inherit, 'type', dUI.ROUNDED )

	styleInheritsPropertyValue( iView, 'fillColor', sbView.fillColor )
	styleHasPropertyValue( iView, 'strokeColor', iView.strokeColor )
	styleHasPropertyValue( iView, 'strokeWidth', iView.strokeWidth )


	--== Setup inherit

	sReset = 0
	sViewReset = 0
	style.inherit = inherit  -- << set style

	assert_gt( 0, sReset, "incorrect count for sReset" )
	assert_gt( 0, sViewReset, "incorrect count for sViewReset" )

	styleInheritsFrom( inherit, StyleBase )
	styleInheritsFrom( iView, sbView )
	styleInheritsFrom( style, inherit )
	styleInheritsFrom( sView, iView )


	styleInheritsPropertyValue( inherit, 'type', dUI.ROUNDED )
	styleInheritsPropertyValue( iView, 'cornerRadius', sbView.cornerRadius )
	styleInheritsPropertyValue( iView, 'fillColor', sbView.fillColor )
	styleHasPropertyValue( iView, 'strokeColor', iView.strokeColor )
	styleHasPropertyValue( iView, 'strokeWidth', iView.strokeWidth )

	styleInheritsPropertyValue( style, 'type', iView.type )
	styleInheritsPropertyValue( sView, 'cornerRadius', iView.cornerRadius )
	styleInheritsPropertyValue( sView, 'fillColor', iView.fillColor )
	styleInheritsPropertyValue( sView, 'strokeColor', iView.strokeColor )
	styleInheritsPropertyValue( sView, 'strokeWidth', iView.strokeWidth )


	--== add properties

	iView.cornerRadius = 89
	iView.strokeWidth = 121

	styleHasPropertyValue( iView, 'cornerRadius', 89 )
	styleInheritsPropertyValue( iView, 'fillColor', sbView.fillColor )
	styleHasPropertyValue( iView, 'strokeColor', iView.strokeColor )
	styleHasPropertyValue( iView, 'strokeWidth', 121 )

	-- at this point style is clear

	styleInheritsPropertyValue( sView, 'cornerRadius', iView.cornerRadius )
	styleInheritsPropertyValue( sView, 'fillColor', iView.fillColor )
	styleInheritsPropertyValue( sView, 'strokeColor', iView.strokeColor )
	styleInheritsPropertyValue( sView, 'strokeWidth', iView.strokeWidth )


	iView.cornerRadius = 131
	sView.strokeWidth = 23

	styleInheritsPropertyValue( sView, 'cornerRadius', iView.cornerRadius )
	styleHasPropertyValue( sView, 'strokeWidth', 23 )


	--== Clear sub property

	sReset = 0
	sViewReset = 0
	style:clearProperties()

	assert_gt( 0, sReset, "incorrect count for sReset" )
	assert_gt( 0, sViewReset, "incorrect count for sViewReset" )

	styleInheritsPropertyValue( sView, 'cornerRadius', iView.cornerRadius )
	styleInheritsPropertyValue( sView, 'fillColor', iView.fillColor )
	styleInheritsPropertyValue( sView, 'strokeColor', iView.strokeColor )
	styleInheritsPropertyValue( sView, 'strokeWidth', iView.strokeWidth )


	iView.cornerRadius = 89
	sView.cornerRadius = 191
	sView.fillColor = {0,0.1,1,0.1}

	styleHasPropertyValue( sView, 'cornerRadius', sView.cornerRadius )
	styleHasPropertyValue( sView, 'fillColor', sView.fillColor )
	styleInheritsPropertyValue( sView, 'strokeColor', iView.strokeColor )
	styleInheritsPropertyValue( sView, 'strokeWidth', iView.strokeWidth )


	--== Clear inheritance

	sReset = 0
	sViewReset = 0
	inherit:clearProperties()

	sView = style.view

	assert_gt( 0, sReset, "incorrect count for sReset" )
	assert_gt( 0, sViewReset, "incorrect count for sViewReset" )

	styleInheritsPropertyValue( iView, 'cornerRadius', sbView.cornerRadius )
	styleInheritsPropertyValue( iView, 'fillColor', sbView.fillColor )
	styleInheritsPropertyValue( iView, 'strokeColor', sbView.strokeColor )
	styleInheritsPropertyValue( iView, 'strokeWidth', sbView.strokeWidth )

	styleHasPropertyValue( sView, 'cornerRadius', sView.cornerRadius )
	styleHasPropertyValue( sView, 'fillColor', sView.fillColor )
	styleInheritsPropertyValue( sView, 'strokeColor', iView.strokeColor )
	styleInheritsPropertyValue( sView, 'strokeWidth', iView.strokeWidth )

	--== Break inheritance


	local cR, fC = sView.cornerRadius, sView.fillColor
	local sC, sW = sView.strokeColor, sView.strokeWidth

	sReset = 0
	sViewReset = 0
	style.inherit = nil

	sView = style.view

	StyleBase = Background:getBaseStyle( inherit.type )
	sbView = StyleBase.view

	assert_gt( 0, sReset, "incorrect count for sReset" )
	assert_gt( 0, sViewReset, "incorrect count for sViewReset" )

	styleInheritsFrom( style, StyleBase )
	styleInheritsFrom( sView, sbView )

	styleInheritsPropertyValue( style, 'type', inherit.type )
	hasPropertyValue( sView, 'type', style.type )

	styleInheritsPropertyValue( sView, 'cornerRadius', sbView.cornerRadius )
	styleInheritsPropertyValue( sView, 'fillColor', sbView.fillColor )
	styleInheritsPropertyValue( sView, 'strokeColor', sbView.strokeColor )
	styleInheritsPropertyValue( sView, 'strokeWidth', sbView.strokeWidth )

end


--[[
--]]
function test_defaultInheritance()
	-- print( "test_defaultInheritance" )
	local Background = dUI.Style.Background
	local StyleDefault
	local StyleBase

	local s1, s1View
	local inherit, iView

	-- default

	s1 = dUI.newBackgroundStyle()
	s1View = s1.view

	StyleBase = Background:getBaseStyle( s1.type )

	styleInheritsFrom( s1, StyleBase )
	hasValidStyleProperties( Background, s1 )

	styleInheritsProperty( s1, 'type' )
	assert_true( s1.type, s1View.type, "incorrect type" )


	-- change inheritance, same type

	inherit = dUI.newBackgroundStyle()
	iView = inherit.view

	styleInheritsFrom( inherit, StyleBase )
	hasValidStyleProperties( Background, s1 )

	styleInheritsFrom( iView, StyleBase.view )

	styleInheritsProperty( inherit, 'type' )
	assert_true( inherit.type, iView.type, "incorrect type" )

	iView.strokeWidth=4
	styleHasPropertyValue( iView, 'strokeWidth', 4 )

	s1.inherit = inherit

	styleInheritsFrom( s1View, iView )
	styleInheritsPropertyValue( s1View, 'strokeWidth', 4 )

	-- set property on inherited, see in sub view
	iView.strokeWidth=6
	styleInheritsPropertyValue( s1View, 'strokeWidth', 6 )

	styleInheritsPropertyValue( s1, 'debugOn', StyleBase.debugOn )

	-- rectangle

	s1 = dUI.newRectangleBackgroundStyle()
	StyleBase = Background:getBaseStyle( s1.type )

	styleInheritsFrom( s1, StyleBase )
	hasValidStyleProperties( Background, s1 )

	assert_true( s1.type, s1View.type, "incorrect type" )

	-- rounded

	s1 = dUI.newRoundedBackgroundStyle()
	StyleBase = Background:getBaseStyle( s1.type )

	styleInheritsFrom( s1, StyleBase )
	hasValidStyleProperties( Background, s1 )

	assert_true( s1.type, s1View.type, "incorrect type" )

end


--[[
test changing inheritance, but with view-types which are
the same.
in this case, the underlying Background view is the same
Instance, but just gets re/set.
--]]

--[[
--]]
function test_similarInheritance()
	-- print( "test_similarInheritance" )
	local Background = dUI.Style.Background
	local StyleDefault

	local s1, sView
	local inherit, iView
	local sDefaults, prevView
	local receivedResetEvent, callback
	local BaseStyle, bsView

	--== start

	s1 = dUI.newRoundedBackgroundStyle()
	inherit = dUI.newRoundedBackgroundStyle()

	sView = s1.view
	iView = inherit.view

	iView.strokeWidth=4
	styleHasPropertyValue( iView, 'strokeWidth', 4 )


	--== update inheritance

	receivedResetEvent = false
	callback = function(e)
		if e.type==s1.view.STYLE_RESET then receivedResetEvent=true end
	end
	s1:addEventListener( s1.EVENT, callback )

	s1.inherit = inherit

	assert_true( receivedResetEvent, "missing reset event" )

	styleInheritsFrom( s1, inherit )
	styleInheritsFrom( sView, iView )
	styleInheritsProperty( s1, 'type' )

	styleInheritsPropertyValue( sView, 'strokeWidth', 4 )
	inherit.view.strokeWidth=6
	styleInheritsPropertyValue( sView, 'strokeWidth', 6 )

	--== block inheritance, set type

	receivedResetEvent = false
	callback = function(e)
		if e.type==s1.view.STYLE_RESET then receivedResetEvent=true end
	end
	s1:addEventListener( s1.EVENT, callback )

	s1.type = dUI.ROUNDED

	BaseStyle = Background:getBaseStyle( s1.type )
	bsView = BaseStyle.view

	sView, iView = s1.view, inherit.view

	assert_true( receivedResetEvent, "missing reset event" )

	styleInheritsFrom( s1, inherit )
	styleInheritsFrom( sView, bsView )
	styleRawPropertyValueIs( s1, 'type', dUI.ROUNDED )

	StyleBase = Background:getBaseStyle( s1.type )
	sbView = StyleBase.view

	-- style view inherit inactive, all properties local

	styleHasPropertyValue( sView, 'debugOn', iView.debugOn )
	styleHasPropertyValue( sView, 'width', iView.width )
	styleHasPropertyValue( sView, 'height', iView.height )
	styleHasPropertyValue( sView, 'anchorX', iView.anchorX )
	styleHasPropertyValue( sView, 'anchorY', iView.anchorY )
	styleHasPropertyValue( sView, 'cornerRadius', iView.cornerRadius )
	styleHasPropertyValue( sView, 'fillColor', iView.fillColor )
	styleHasPropertyValue( sView, 'strokeColor', iView.strokeColor )
	styleHasPropertyValue( sView, 'strokeWidth', iView.strokeWidth )


	--== unblock inheritance, unset type

	receivedResetEvent = false
	callback = function(e)
		if e.type==s1.view.STYLE_RESET then receivedResetEvent=true end
	end
	s1:addEventListener( s1.EVENT, callback )

	s1.type = nil

	sView, iView = s1.view, inherit.view

	assert_true( receivedResetEvent, "missing reset event" )

	styleInheritsFrom( s1, inherit )
	styleInheritsFrom( sView, iView )
	styleRawPropertyValueIs( s1, 'type', nil )
	styleInheritsPropertyValue( s1, 'type', inherit.type )

	StyleBase = Background:getBaseStyle( s1.type )
	sbView = StyleBase.view

	assert_true( receivedResetEvent, "missing reset event" )

	-- style view inherit active, all properties inherited

	styleInheritsPropertyValue( sView, 'debugOn', iView.debugOn )
	styleInheritsPropertyValue( sView, 'width', iView.width )
	styleInheritsPropertyValue( sView, 'height', iView.height )
	styleInheritsPropertyValue( sView, 'anchorX', iView.anchorX )
	styleInheritsPropertyValue( sView, 'anchorY', iView.anchorY )
	styleInheritsPropertyValue( sView, 'cornerRadius', iView.cornerRadius )
	styleInheritsPropertyValue( sView, 'fillColor', iView.fillColor )
	styleInheritsPropertyValue( sView, 'strokeColor', iView.strokeColor )
	styleInheritsPropertyValue( sView, 'strokeWidth', iView.strokeWidth )

end



--[[
tests when changing inheritance using the property 'type'
--]]
--[[
--]]
function test_inheritanceChangesUsingTypeProperty()
	-- print( "test_inheritanceChangesUsingTypeProperty" )
	local Background = dUI.Style.Background
	local StyleFactory = dUI.Style.BackgroundFactory
	local RectangleBackground = StyleFactory.Rectangle
	local RoundedBackground = StyleFactory.Rounded
	local StyleDefault

	local s1, sView
	local inherit, iView
	local sDefaults, prevView
	local receivedResetEvent, callback
	local BaseStyle, bsView

	s1 = dUI.newRoundedBackgroundStyle()
	inherit = dUI.newRoundedBackgroundStyle()

	sView, iView = s1.view, inherit.view

	styleInheritsPropertyValue( s1, 'type', dUI.ROUNDED )

	--== start

	iView.strokeWidth=4
	styleHasPropertyValue( iView, 'strokeWidth', 4 )

	--== update inheritance

	s1.inherit = inherit

	sView, iView = s1.view, inherit.view

	styleInheritsProperty( s1, 'type' )
	styleInheritsPropertyValue( sView, 'strokeWidth', 4 )

	iView.strokeWidth=6
	styleInheritsPropertyValue( sView, 'strokeWidth', 6 )


	--== block inheritance, type='rectangle'


	receivedResetEvent = false
	callback = function(e)
		if e.type==s1.view.STYLE_RESET then receivedResetEvent=true end
	end
	s1:addEventListener( s1.EVENT, callback )

	prevView = sView
	s1.type = dUI.RECTANGLE

	sView, iView = s1.view, inherit.view

	assert_true( sView~=prevView, "incorrect views" )
	assert_true( receivedResetEvent, "missing reset event" )

	BaseStyle = Background:getBaseStyle( s1.type )
	bsView = BaseStyle.view

	styleInheritsFrom( s1, inherit )
	styleInheritsFrom( sView, bsView )
	styleRawPropertyValueIs( s1, 'type', dUI.RECTANGLE )

	styleIsa( sView, RectangleBackground )

	-- style view inherit inactive, all properties local

	styleHasPropertyValue( sView, 'debugOn', BaseStyle.debugOn )
	styleHasPropertyValue( sView, 'width', BaseStyle.width )
	styleHasPropertyValue( sView, 'height', BaseStyle.height )
	styleHasPropertyValue( sView, 'anchorX', BaseStyle.anchorX )
	styleHasPropertyValue( sView, 'anchorY', BaseStyle.anchorY )
	styleHasPropertyValue( sView, 'fillColor', bsView.fillColor )
	styleHasPropertyValue( sView, 'strokeColor', bsView.strokeColor )
	styleHasPropertyValue( sView, 'strokeWidth', bsView.strokeWidth )


	--== block inheritance, type='rounded'

	receivedResetEvent = false
	callback = function(e)
		if e.type==s1.view.STYLE_RESET then receivedResetEvent=true end
	end
	s1:addEventListener( s1.EVENT, callback )

	prevView = sView
	s1.type = dUI.ROUNDED

	sView, iView = s1.view, inherit.view

	BaseStyle = Background:getBaseStyle( s1.type )
	bsView = BaseStyle.view

	assert_true( sView~=prevView, "incorrect views" )
	assert_true( receivedResetEvent, "missing reset event" )

	styleInheritsFrom( s1, inherit )
	styleInheritsFrom( sView, bsView )

	styleRawPropertyValueIs( s1, 'type', dUI.ROUNDED )

	StyleBase = Background:getBaseStyle( s1.type )
	sbView = StyleBase.view


	-- style view inherit inactive, all properties local

	styleHasPropertyValue( sView, 'debugOn', sbView.debugOn )
	styleHasPropertyValue( sView, 'width', sbView.width )
	styleHasPropertyValue( sView, 'height', sbView.height )
	styleHasPropertyValue( sView, 'anchorX', sbView.anchorX )
	styleHasPropertyValue( sView, 'anchorY', sbView.anchorY )
	styleHasPropertyValue( sView, 'cornerRadius', sbView.cornerRadius )
	styleHasPropertyValue( sView, 'fillColor', sbView.fillColor )
	styleHasPropertyValue( sView, 'strokeColor', sbView.strokeColor )
	styleHasPropertyValue( sView, 'strokeWidth', sbView.strokeWidth )


	--== unblock inheritance, unset type

	receivedResetEvent = false
	callback = function(e)
		if e.type==sView.STYLE_RESET then receivedResetEvent=true end
	end
	s1:addEventListener( s1.EVENT, callback )

	s1.type = nil
	s1.type = nil

	sView, iView = s1.view, inherit.view

	assert_true( receivedResetEvent, "missing reset event" )

	styleInheritsFrom( s1, inherit )
	styleInheritsFrom( sView, iView )
	styleRawPropertyValueIs( s1, 'type', nil )
	styleInheritsPropertyValue( s1, 'type', inherit.type )

	-- style view inherit active, all properties inherited

	styleInheritsPropertyValue( sView, 'debugOn', iView.debugOn )
	styleInheritsPropertyValue( sView, 'width', iView.width )
	styleInheritsPropertyValue( sView, 'height', iView.height )
	styleInheritsPropertyValue( sView, 'anchorX', iView.anchorX )
	styleInheritsPropertyValue( sView, 'anchorY', iView.anchorY )
	styleInheritsPropertyValue( sView, 'cornerRadius', iView.cornerRadius )
	styleInheritsPropertyValue( sView, 'fillColor', iView.fillColor )
	styleInheritsPropertyValue( sView, 'strokeColor', iView.strokeColor )
	styleInheritsPropertyValue( sView, 'strokeWidth', iView.strokeWidth )

end



--[[
tests when changing inheritance using the property 'inherit'
--]]
--[[
--]]
function test_inheritanceChangesUsingInheritanceProperty()
	-- print( "test_inheritanceChangesUsingInheritanceProperty" )
	local Background = dUI.Style.Background
	local StyleFactory = dUI.Style.BackgroundFactory
	local RectangleBackground = StyleFactory.Rectangle
	local RoundedBackground = StyleFactory.Rounded
	local StyleDefault

	local s1, sView
	local inherit, iView
	local sDefaults, prevView
	local receivedResetEvent, callback

	--== start

	s1 = dUI.newRoundedBackgroundStyle()
	TestUtils.verifyBackgroundStyle( s1 )

	--== update inheritance, rectangle

	inherit = dUI.newRectangleBackgroundStyle()

	receivedResetEvent = false
	callback = function(e)
		if e.type==s1.view.STYLE_RESET then receivedResetEvent=true end
	end
	s1:addEventListener( s1.EVENT, callback )

	prevView = sView
	s1.inherit = inherit

	sView, iView = s1.view, inherit.view

	TestUtils.verifyBackgroundStyle( s1 )
	assert_true( receivedResetEvent, "missing reset event" )

	styleInheritsFrom( s1, inherit )
	styleInheritsPropertyValue( s1, 'type', inherit.type )
	stylePropertyValueIs( sView , 'type', iView.type )


	--== update inheritance, rounded

	inherit = dUI.newRoundedBackgroundStyle()


	receivedResetEvent = false
	callback = function(e)
		if e.type==s1.view.STYLE_RESET then receivedResetEvent=true end
	end
	s1:addEventListener( s1.EVENT, callback )

	prevView = sView
	s1.inherit = inherit

	assert_true( receivedResetEvent, "missing reset event" )
	styleInheritsFrom( s1, inherit )
	TestUtils.verifyBackgroundStyle( s1 )
	styleInheritsPropertyValue( s1, 'type', inherit.type )

	sView, iView = s1.view, inherit.view

	stylePropertyValueIs( sView , 'type', iView.type )

end



--[[
tests when changing inheritance using the property 'inherit'
--]]
--[[
--]]
function test_inheritanceChangesUsingInheritancePropertyMismatch()
	-- print( "test_inheritanceChangesUsingInheritancePropertyMismatch" )
	local Background = dUI.Style.Background
	local StyleFactory = dUI.Style.BackgroundFactory
	local Rectangle = StyleFactory.Rectangle
	local Rounded = StyleFactory.Rounded
	local StyleDefault

	local s1, sView, sDefaults
	local inherit, iView, iDefaults
	local prevView
	local receivedResetEvent, callback
	local BaseStyle, bsView


	--======================================================--
	-- Example one, Rectangle and Rounded

	--== start

	inherit = dUI.newRectangleBackgroundStyle{
		view={
			fillColor={101,102,103,104},
			strokeWidth=66
		}
	}

	iView = inherit.view

	BaseStyle = Background:getBaseStyle( inherit.type )
	bsView = BaseStyle.view

	iDefaults = Rectangle:getBaseStyle()

	TestUtils.verifyBackgroundStyle( inherit )

	styleInheritsFrom( inherit, BaseStyle )
	styleInheritsFrom( iView, bsView )
	styleInheritsPropertyValue( inherit, 'type', dUI.RECTANGLE )
	hasPropertyValue( iView, 'type', dUI.RECTANGLE )

	styleHasPropertyValue( iView, 'fillColor', {101,102,103,104} )
	styleInheritsPropertyValue( iView, 'strokeColor', bsView.strokeColor )
	styleHasPropertyValue( iView, 'strokeWidth', 66 )



	s1 = dUI.newRoundedBackgroundStyle{
		view={
			cornerRadius=100,
			fillColor={111,112,113,114},
			strokeWidth=99
		}
	}

	sView = s1.view

	BaseStyle = Background:getBaseStyle( s1.type )
	bsView = BaseStyle.view

	sDefaults = Rounded:getBaseStyle()

	TestUtils.verifyBackgroundStyle( s1 )
	styleInheritsFrom( s1, BaseStyle )
	styleInheritsFrom( sView, bsView )
	styleInheritsPropertyValue( s1, 'type', dUI.ROUNDED )
	hasPropertyValue( sView, 'type', dUI.ROUNDED )

	styleHasPropertyValue( sView, 'cornerRadius', 100 )
	styleHasPropertyValue( sView, 'fillColor', {111,112,113,114} )
	styleInheritsPropertyValue( sView, 'strokeColor', sDefaults.strokeColor )
	styleHasPropertyValue( sView, 'strokeWidth', 99 )


	--== update inheritance, rectangle

	receivedResetEvent = false
	callback = function(e)
		if e.type==s1.view.STYLE_RESET then receivedResetEvent=true end
	end
	s1:addEventListener( s1.EVENT, callback )

	prevView = sView
	s1.inherit = inherit

	sView, iView = s1.view, inherit.view

	TestUtils.verifyBackgroundStyle( s1 )
	assert_true( receivedResetEvent, "missing reset event" )

	styleInheritsFrom( s1, inherit )
	styleInheritsPropertyValue( s1, 'type', inherit.type )
	styleInheritsFrom( sView, iView )
	stylePropertyValueIs( sView , 'type', iView.type )

	styleRawPropertyValueIs( sView, 'cornerRadius', nil ) -- erased
	styleInheritsPropertyValue( sView, 'fillColor', {101,102,103,104} )
	styleInheritsPropertyValue( sView, 'strokeColor', iDefaults.strokeColor )
	styleInheritsPropertyValue( sView, 'strokeWidth', 66 )


	--======================================================--
	-- Example Two, Rectangle and Rounded

	--== start

	inherit = dUI.newRectangleBackgroundStyle{
		view={
			fillColor={111,112,113,114},
			strokeWidth=65
		}
	}

	s1 = dUI.newRoundedBackgroundStyle({
		view={
			cornerRadius=100,
			fillColor={101,102,103,104},
			strokeWidth=99
		}
	},
	{inherit=inherit}
	)

	sView, iView = s1.view, inherit.view

	BaseStyle = Background:getBaseStyle( s1.type )
	bsView = BaseStyle.view

	styleInheritsFrom( s1, inherit )
	styleHasPropertyValue( s1, 'type', dUI.ROUNDED )
	styleInheritsFrom( sView, bsView )
	stylePropertyValueIs( sView , 'type', dUI.ROUNDED )

	styleHasPropertyValue( sView, 'cornerRadius', 100 ) -- erased
	styleHasPropertyValue( sView, 'fillColor', {101,102,103,104} )
	styleInheritsPropertyValue( sView, 'strokeColor', sDefaults.strokeColor )
	styleHasPropertyValue( sView, 'strokeWidth', 99 )

end




--[[
tests when changing inheritance using the property 'type'
--]]
--[[
--]]
function test_initializeStyleWithLuaStructure()
	-- print( "test_initializeStyleWithLuaStructure" )
	local Background = dUI.Style.Background
	local StyleFactory = dUI.Style.BackgroundFactory
	local RectangleBackground = StyleFactory.Rectangle
	local Rounded = StyleFactory.Rounded
	local StyleDefault

	local s1, sView
	local inherit, iView
	local BaseStyle, prevView, bsView
	local receivedResetEvent, callback



	s1 = dUI.newRoundedBackgroundStyle{
		view={
			cornerRadius=100,
			strokeWidth=99
		}
	}

	sView = s1.view

	BaseStyle = Background:getBaseStyle( s1.type )
	bsView = BaseStyle.view

	styleInheritsFrom( s1, BaseStyle )
	styleInheritsFrom( sView, bsView )
	styleInheritsPropertyValue( s1, 'type', dUI.ROUNDED )
	hasPropertyValue( sView, 'type', dUI.ROUNDED )

	styleHasPropertyValue( sView, 'cornerRadius', 100 )
	styleInheritsPropertyValue( sView, 'fillColor', bsView.fillColor )
	styleInheritsPropertyValue( sView, 'strokeColor', bsView.strokeColor )
	styleHasPropertyValue( sView, 'strokeWidth', 99 )


	--== with inherit in params

	inherit = BaseStyle

	s1 = dUI.newRoundedBackgroundStyle( {
			view={
				cornerRadius=100,
				strokeWidth=99
			}
		},
		{inherit=inherit}
	)

	sView, iView = s1.view, inherit.view

	styleInheritsFrom( s1, inherit )
	styleInheritsFrom( sView, iView )
	styleInheritsPropertyValue( s1, 'type', dUI.ROUNDED )
	hasPropertyValue( sView, 'type', dUI.ROUNDED )

	styleHasPropertyValue( sView, 'cornerRadius', 100 )
	styleInheritsPropertyValue( sView, 'fillColor', iView.fillColor )
	styleInheritsPropertyValue( sView, 'strokeColor', iView.strokeColor )
	styleHasPropertyValue( sView, 'strokeWidth', 99 )


	--== any type is overridden

	s1 = dUI.newRoundedBackgroundStyle( {
			type='rectangle',
			view={
				cornerRadius=100,
				strokeWidth=99
			}
		},
		{inherit=inherit}
	)

	sView, iView = s1.view, inherit.view

	styleInheritsFrom( s1, inherit )
	styleInheritsFrom( sView, iView )
	styleInheritsPropertyValue( s1, 'type', dUI.ROUNDED )
	hasPropertyValue( sView, 'type', dUI.ROUNDED )

	styleHasPropertyValue( sView, 'cornerRadius', 100 )
	styleInheritsPropertyValue( sView, 'fillColor', iView.fillColor )
	styleInheritsPropertyValue( sView, 'strokeColor', iView.strokeColor )
	styleHasPropertyValue( sView, 'strokeWidth', 99 )


	--== no inherit, no type, so go to default view

	s1 = dUI.newBackgroundStyle{
		view={
			cornerRadius=100,
			strokeWidth=99
		}
	}

	sView = s1.view

	BaseStyle = Background:getBaseStyle( s1.type )
	bsView = BaseStyle.view

	styleInheritsFrom( s1, BaseStyle )
	styleInheritsFrom( sView, bsView )
	styleInheritsPropertyValue( s1, 'type', dUI.ROUNDED )
	hasPropertyValue( sView, 'type', dUI.ROUNDED )

	styleHasPropertyValue( sView, 'cornerRadius', 100 )
	styleInheritsPropertyValue( sView, 'fillColor', bsView.fillColor )
	styleInheritsPropertyValue( sView, 'strokeColor', bsView.strokeColor )
	styleHasPropertyValue( sView, 'strokeWidth', 99 )

end


