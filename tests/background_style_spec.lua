--====================================================================--
-- Test: Background Style
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


local verifyBackgroundStyle = Utils.verifyBackgroundStyle

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

	Widgets._loadBackgroundSupport()

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
--]]
function test_addMissingProperties_Rectangle()
	-- print( "test_addMissingProperties_Rectangle" )
	local BackgroundFactory = Widgets.Style.BackgroundFactory
	local Rectangle = BackgroundFactory.Rectangle
	local Background = Widgets.Style.Background
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
		debugOn=200,
		width=202,
		fillColor={0,1,1,1,1,},

		background = {
			type='rectangle',
			height=300,
			anchorY=302,
			view={
				debugOn=400,
				anchorX=402,
				height=404
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

end


--[[
function test_copyExistingSrcProperties()
	-- print( "test_copyExistingSrcProperties" )
	local BackgroundFactory = Widgets.Style.BackgroundFactory
	local RoundedStyle = BackgroundFactory.Rounded

	local src

end
--]]


--[[
function test_verifyStyleProperties()
	-- print( "test_verifyStyleProperties" )
	local BackgroundFactory = Widgets.Style.BackgroundFactory
	local RoundedStyle = BackgroundFactory.Rounded

	local src

end
--]]



--====================================================================--
--== Test Class Methods


--[[
test basic characteristics
--]]
--[[
--]]
function test_backgroundStyleClassBasics()
	-- print( "test_backgroundStyleClassBasics" )
	local Background = Widgets.Style.Background
	local BaseStyle, defaults, vDefaults
	local style, view

	defaults = Background:getDefaultStyleValues()

	--== rounded

	BaseStyle = Background:getBaseStyle( 'rounded' )
	TestUtils.verifyBackgroundStyle( BaseStyle )

	styleInheritsFrom( BaseStyle, nil )
	styleHasPropertyValue( BaseStyle, 'master', BaseStyle )

	-- check properties initialized to the default values

	styleHasPropertyValue( BaseStyle, 'debugOn', defaults.debugOn )
	styleHasPropertyValue( BaseStyle, 'width', defaults.width )
	styleHasPropertyValue( BaseStyle, 'height', defaults.height )
	styleHasPropertyValue( BaseStyle, 'anchorX', defaults.anchorX )
	styleHasPropertyValue( BaseStyle, 'anchorY', defaults.anchorY )
	styleHasPropertyValue( BaseStyle, 'type', 'rounded' )

	view = BaseStyle.view
	vDefaults = view:getDefaultStyleValues()
	styleHasPropertyValue( view, 'debugOn', vDefaults.debugOn )
	styleHasPropertyValue( view, 'width', defaults.width )
	styleHasPropertyValue( view, 'height', defaults.height )
	styleHasPropertyValue( view, 'anchorX', vDefaults.anchorX )
	styleHasPropertyValue( view, 'anchorY', vDefaults.anchorY )
	styleHasPropertyValue( view, 'fillColor', vDefaults.fillColor )
	styleHasPropertyValue( view, 'strokeColor', vDefaults.strokeColor )
	styleHasPropertyValue( view, 'strokeWidth', vDefaults.strokeWidth )

	--== rectangle

	BaseStyle = Background:getBaseStyle( 'rectangle' )
	TestUtils.verifyBackgroundStyle( BaseStyle )

	styleInheritsFrom( BaseStyle, nil )
	styleHasPropertyValue( BaseStyle, 'master', BaseStyle )

	-- check properties initialized to the default values

	styleHasPropertyValue( BaseStyle, 'debugOn', defaults.debugOn )
	styleHasPropertyValue( BaseStyle, 'width', defaults.width )
	styleHasPropertyValue( BaseStyle, 'height', defaults.height )
	styleHasPropertyValue( BaseStyle, 'anchorX', defaults.anchorX )
	styleHasPropertyValue( BaseStyle, 'anchorY', defaults.anchorY )
	styleHasPropertyValue( BaseStyle, 'type', 'rectangle' )

	view = BaseStyle.view
	vDefaults = view:getDefaultStyleValues()
	styleHasPropertyValue( view, 'debugOn', vDefaults.debugOn )
	styleHasPropertyValue( view, 'width', vDefaults.width )
	styleHasPropertyValue( view, 'height', vDefaults.height )
	styleHasPropertyValue( view, 'anchorX', vDefaults.anchorX )
	styleHasPropertyValue( view, 'anchorY', vDefaults.anchorY )
	styleHasPropertyValue( view, 'fillColor', vDefaults.fillColor )
	styleHasPropertyValue( view, 'strokeColor', vDefaults.strokeColor )
	styleHasPropertyValue( view, 'strokeWidth', vDefaults.strokeWidth )


	--== Test constructors

	style = Widgets.newBackgroundStyle()

	TestUtils.verifyBackgroundStyle( style )
	styleInheritsFrom( BaseStyle, nil )
	styleHasPropertyValue( style, 'master', style )
	styleHasPropertyValue( style.view, 'master', style )

	style = Widgets.newRoundedBackgroundStyle()

	TestUtils.verifyBackgroundStyle( style )
	styleInheritsFrom( BaseStyle, nil )
	styleHasPropertyValue( style, 'master', style )
	styleHasPropertyValue( style.view, 'master', style )

	style = Widgets.newRectangleBackgroundStyle()

	TestUtils.verifyBackgroundStyle( style )
	styleInheritsFrom( BaseStyle, nil )
	styleHasPropertyValue( style, 'master', style )
	styleHasPropertyValue( style.view, 'master', style )

end



--[[
--]]
function test_defaultInheritance()
	-- print( "test_defaultInheritance" )
	local Background = Widgets.Style.Background
	local StyleDefault
	local StyleBase

	local s1, s1View
	local inherit, iView

	-- default

	s1 = Widgets.newBackgroundStyle()
	s1View = s1.view

	StyleBase = Background:getBaseStyle( s1.type )

	styleInheritsFrom( s1, nil )
	hasValidStyleProperties( Background, s1 )

	styleHasProperty( s1, 'type' )
	assert_true( s1.type, s1View.type, "incorrect type" )


	-- change inheritance, same type

	inherit = Widgets.newBackgroundStyle()
	iView = inherit.view

	styleInheritsFrom( s1, nil )
	hasValidStyleProperties( Background, s1 )

	styleInheritsFrom( iView, nil )

	styleHasProperty( inherit, 'type' )
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

	s1 = Widgets.newRectangleBackgroundStyle()
	StyleBase = Background:getBaseStyle( s1.type )

	styleInheritsFrom( s1, nil )
	hasValidStyleProperties( Background, s1 )

	assert_true( s1.type, s1View.type, "incorrect type" )

	-- rounded

	s1 = Widgets.newRoundedBackgroundStyle()
	StyleBase = Background:getBaseStyle( s1.type )

	styleInheritsFrom( s1, nil )
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
	local Background = Widgets.Style.Background
	local StyleDefault

	local s1, sView
	local inherit, iView
	local sDefaults, prevView
	local receivedResetEvent, callback


	--== start

	s1 = Widgets.newBackgroundStyle()
	inherit = Widgets.newBackgroundStyle()

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

	s1.type = 'rounded'

	sView, iView = s1.view, inherit.view

	assert_true( receivedResetEvent, "missing reset event" )

	styleInheritsFrom( s1, inherit )
	styleInheritsFrom( sView, nil )
	styleRawPropertyValueIs( s1, 'type', 'rounded' )

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
	local Background = Widgets.Style.Background
	local StyleFactory = Widgets.Style.BackgroundFactory
	local RectangleBackground = StyleFactory.Rectangle
	local RoundedBackground = StyleFactory.Rounded
	local StyleDefault

	local s1, sView
	local inherit, iView
	local sDefaults, prevView
	local receivedResetEvent, callback

	s1 = Widgets.newRoundedBackgroundStyle()
	inherit = Widgets.newBackgroundStyle()

	sView, iView = s1.view, inherit.view

	styleHasPropertyValue( s1, 'type', 'rounded' )

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

	sDefaults = RectangleBackground:getDefaultStyleValues()

	receivedResetEvent = false
	callback = function(e)
		if e.type==s1.view.STYLE_RESET then receivedResetEvent=true end
	end
	s1:addEventListener( s1.EVENT, callback )

	prevView = sView
	s1.type = 'rectangle'

	sView, iView = s1.view, inherit.view

	assert_true( sView~=prevView, "incorrect views" )
	assert_true( receivedResetEvent, "missing reset event" )

	styleInheritsFrom( s1, inherit )
	styleInheritsFrom( sView, nil )
	styleRawPropertyValueIs( s1, 'type', 'rectangle' )

	styleIsa( sView, RectangleBackground )

	-- style view inherit inactive, all properties local

	styleHasPropertyValue( sView, 'debugOn', sDefaults.debugOn )
	styleHasPropertyValue( sView, 'width', sDefaults.width )
	styleHasPropertyValue( sView, 'height', sDefaults.height )
	styleHasPropertyValue( sView, 'anchorX', sDefaults.anchorX )
	styleHasPropertyValue( sView, 'anchorY', sDefaults.anchorY )
	styleHasPropertyValue( sView, 'fillColor', sDefaults.fillColor )
	styleHasPropertyValue( sView, 'strokeColor', sDefaults.strokeColor )
	styleHasPropertyValue( sView, 'strokeWidth', sDefaults.strokeWidth )


	--== block inheritance, type='rounded'

	sDefaults = RoundedBackground:getDefaultStyleValues()

	receivedResetEvent = false
	callback = function(e)
		if e.type==s1.view.STYLE_RESET then receivedResetEvent=true end
	end
	s1:addEventListener( s1.EVENT, callback )

	prevView = sView
	s1.type = 'rounded'

	sView, iView = s1.view, inherit.view

	assert_true( sView~=prevView, "incorrect views" )
	assert_true( receivedResetEvent, "missing reset event" )

	styleInheritsFrom( s1, inherit )
	styleInheritsFrom( sView, nil )
	styleRawPropertyValueIs( s1, 'type', 'rounded' )

	-- style view inherit inactive, all properties local

	styleHasPropertyValue( sView, 'debugOn', sDefaults.debugOn )
	styleHasPropertyValue( sView, 'width', sDefaults.width )
	styleHasPropertyValue( sView, 'height', sDefaults.height )
	styleHasPropertyValue( sView, 'anchorX', sDefaults.anchorX )
	styleHasPropertyValue( sView, 'anchorY', sDefaults.anchorY )
	styleHasPropertyValue( sView, 'cornerRadius', sDefaults.cornerRadius )
	styleHasPropertyValue( sView, 'fillColor', sDefaults.fillColor )
	styleHasPropertyValue( sView, 'strokeColor', sDefaults.strokeColor )
	styleHasPropertyValue( sView, 'strokeWidth', sDefaults.strokeWidth )


	--== unblock inheritance, unset type

	receivedResetEvent = false
	callback = function(e)
		if e.type==sView.STYLE_RESET then receivedResetEvent=true end
	end
	s1:addEventListener( s1.EVENT, callback )

	prevView = sView
	s1.type = nil

	sView, iView = s1.view, inherit.view

	assert_true( sView==prevView, "incorrect views" )
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
	local Background = Widgets.Style.Background
	local StyleFactory = Widgets.Style.BackgroundFactory
	local RectangleBackground = StyleFactory.Rectangle
	local RoundedBackground = StyleFactory.Rounded
	local StyleDefault

	local s1, sView
	local inherit, iView
	local sDefaults, prevView
	local receivedResetEvent, callback

	--== start

	s1 = Widgets.newRoundedBackgroundStyle()
	TestUtils.verifyBackgroundStyle( s1 )

	--== update inheritance, rectangle

	inherit = Widgets.newRectangleBackgroundStyle()

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

	inherit = Widgets.newRoundedBackgroundStyle()


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
	local Background = Widgets.Style.Background
	local StyleFactory = Widgets.Style.BackgroundFactory
	local Rectangle = StyleFactory.Rectangle
	local Rounded = StyleFactory.Rounded
	local StyleDefault

	local s1, sView
	local inherit, iView
	local sDefaults, prevView
	local receivedResetEvent, callback
	local c1, c2 = {1,1,1}, {0,0,0}


	--======================================================--
	-- Example one, Rectangle and Rounded

	--== start

	inherit = Widgets.newRectangleBackgroundStyle{
		view={
			fillColor=c2,
			strokeWidth=65
		}
	}

	s1 = Widgets.newRoundedBackgroundStyle{
		view={
			cornerRadius=100,
			fillColor=c1,
			strokeWidth=99
		}
	}

	sView, iView = s1.view, inherit.view


	sDefaults = Rounded:getBaseStyle()

	TestUtils.verifyBackgroundStyle( s1 )
	styleInheritsFrom( s1, nil )
	styleInheritsFrom( sView, nil )
	styleHasPropertyValue( s1, 'type', 'rounded' )
	hasPropertyValue( sView, 'type', 'rounded' )

	styleHasPropertyValue( sView, 'cornerRadius', 100 )
	styleHasPropertyValue( sView, 'fillColor', c1 )
	styleHasPropertyValue( sView, 'strokeColor', sDefaults.strokeColor )
	styleHasPropertyValue( sView, 'strokeWidth', 99 )


	sDefaults = Rectangle:getBaseStyle()

	TestUtils.verifyBackgroundStyle( inherit )
	styleInheritsFrom( inherit, nil )
	styleInheritsFrom( iView, nil )
	styleHasPropertyValue( inherit, 'type', 'rectangle' )
	hasPropertyValue( iView, 'type', 'rectangle' )

	styleHasPropertyValue( iView, 'fillColor', c2 )
	styleHasPropertyValue( iView, 'strokeColor', sDefaults.strokeColor )
	styleHasPropertyValue( iView, 'strokeWidth', 65 )


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
	stylePropertyValueIs( sView , 'type', iView.type )

	styleRawPropertyValueIs( sView, 'cornerRadius', nil ) -- erased
	styleInheritsPropertyValue( sView, 'fillColor', c2 )
	styleInheritsPropertyValue( sView, 'strokeColor', sDefaults.strokeColor )
	styleInheritsPropertyValue( sView, 'strokeWidth', 65 )


	--======================================================--
	-- Example Two, Rectangle and Rounded

	--== start

	inherit = Widgets.newRectangleBackgroundStyle{
		view={
			fillColor=c2,
			strokeWidth=65
		}
	}

	s1 = Widgets.newRoundedBackgroundStyle({
		view={
			cornerRadius=100,
			fillColor=c1,
			strokeWidth=99
		}
	},
	{inherit=inherit}
	)

	sView, iView = s1.view, inherit.view

	styleInheritsFrom( s1, inherit )
	styleInheritsPropertyValue( s1, 'type', inherit.type )
	stylePropertyValueIs( sView , 'type', iView.type )

	styleRawPropertyValueIs( sView, 'cornerRadius', nil ) -- erased
	styleInheritsPropertyValue( sView, 'fillColor', c2 )
	styleInheritsPropertyValue( sView, 'strokeColor', sDefaults.strokeColor )
	styleInheritsPropertyValue( sView, 'strokeWidth', 65 )

end




--[[
tests when changing inheritance using the property 'type'
--]]
--[[
--]]
function test_initializeStyleWithLuaStructure()
	-- print( "test_initializeStyleWithLuaStructure" )
	local Background = Widgets.Style.Background
	local StyleFactory = Widgets.Style.BackgroundFactory
	local RectangleBackground = StyleFactory.Rectangle
	local Rounded = StyleFactory.Rounded
	local StyleDefault

	local s1, sView
	local inherit, iView
	local sDefaults, prevView
	local receivedResetEvent, callback


	sDefaults = Rounded:getBaseStyle()

	s1 = Widgets.newRoundedBackgroundStyle{
		view={
			cornerRadius=100,
			strokeWidth=99
		}
	}

	sView = s1.view

	styleInheritsFrom( s1, nil )
	styleInheritsFrom( sView, nil )
	styleHasPropertyValue( s1, 'type', 'rounded' )
	hasPropertyValue( sView, 'type', 'rounded' )

	styleHasPropertyValue( sView, 'cornerRadius', 100 )
	styleHasPropertyValue( sView, 'fillColor', sDefaults.fillColor )
	styleHasPropertyValue( sView, 'strokeColor', sDefaults.strokeColor )
	styleHasPropertyValue( sView, 'strokeWidth', 99 )


	--== with inherit in params

	inherit = sDefaults

	s1 = Widgets.newRoundedBackgroundStyle( {
			view={
				cornerRadius=100,
				strokeWidth=99
			}
		},
		{inherit=inherit}
	)

	sView, iView = s1.view, inherit.view

	styleInheritsFrom( s1, sDefaults )
	styleInheritsFrom( sView, iView )
	styleInheritsPropertyValue( s1, 'type', 'rounded' )
	hasPropertyValue( sView, 'type', 'rounded' )

	styleHasPropertyValue( sView, 'cornerRadius', 100 )
	styleHasPropertyValue( sView, 'fillColor', sDefaults.fillColor )
	styleHasPropertyValue( sView, 'strokeColor', sDefaults.strokeColor )
	styleHasPropertyValue( sView, 'strokeWidth', 99 )


	--== any type is overridden

	s1 = Widgets.newRoundedBackgroundStyle( {
			type='rectangle',
			view={
				cornerRadius=100,
				strokeWidth=99
			}
		},
		{inherit=inherit}
	)

	sView, iView = s1.view, inherit.view

	styleInheritsFrom( s1, sDefaults )
	styleInheritsFrom( sView, iView )
	styleInheritsPropertyValue( s1, 'type', 'rounded' )
	hasPropertyValue( sView, 'type', 'rounded' )

	styleHasPropertyValue( sView, 'cornerRadius', 100 )
	styleHasPropertyValue( sView, 'fillColor', sDefaults.fillColor )
	styleHasPropertyValue( sView, 'strokeColor', sDefaults.strokeColor )
	styleHasPropertyValue( sView, 'strokeWidth', 99 )


	--== no inherit, no type, so go to default view

	s1 = Widgets.newBackgroundStyle{
		view={
			cornerRadius=100,
			strokeWidth=99
		}
	}

	sView = s1.view

	styleInheritsFrom( s1, nil )
	styleInheritsFrom( sView, nil )
	styleHasPropertyValue( s1, 'type', 'rounded' )
	hasPropertyValue( sView, 'type', 'rounded' )

	styleHasPropertyValue( sView, 'cornerRadius', 100 )
	styleHasPropertyValue( sView, 'fillColor', sDefaults.fillColor )
	styleHasPropertyValue( sView, 'strokeColor', sDefaults.strokeColor )
	styleHasPropertyValue( sView, 'strokeWidth', 99 )

end


