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
--]]
--[[
function test_addMissingProperties()

	local Background = Widgets.Style.Background

	local src, dest
end
--]]


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
	local BaseStyle, style
	local Default = Background:getDefaultStyleValues()

	--== rounded

	BaseStyle = Background:getBaseStyle( 'rounded' )
	TestUtils.verifyBackgroundStyle( BaseStyle )

	styleInheritsFrom( BaseStyle, nil )

	-- check properties initialized to the default values

	styleHasPropertyValue( BaseStyle, 'debugOn', Default.debugOn )
	styleHasPropertyValue( BaseStyle, 'width', Default.width )
	styleHasPropertyValue( BaseStyle, 'height', Default.height )
	styleHasPropertyValue( BaseStyle, 'anchorX', Default.anchorX )
	styleHasPropertyValue( BaseStyle, 'anchorY', Default.anchorY )
	styleHasPropertyValue( BaseStyle, 'type', 'rounded' )

	--== rectangle

	BaseStyle = Background:getBaseStyle( 'rectangle' )
	TestUtils.verifyBackgroundStyle( BaseStyle )

	styleInheritsFrom( BaseStyle, nil )

	-- check properties initialized to the default values

	styleHasPropertyValue( BaseStyle, 'debugOn', Default.debugOn )
	styleHasPropertyValue( BaseStyle, 'width', Default.width )
	styleHasPropertyValue( BaseStyle, 'height', Default.height )
	styleHasPropertyValue( BaseStyle, 'anchorX', Default.anchorX )
	styleHasPropertyValue( BaseStyle, 'anchorY', Default.anchorY )
	styleHasPropertyValue( BaseStyle, 'type', 'rectangle' )

	--== Test constructors

	style = Widgets.newBackgroundStyle()

	TestUtils.verifyBackgroundStyle( style )
	styleInheritsFrom( BaseStyle, nil )

	style = Widgets.newRoundedBackgroundStyle()

	TestUtils.verifyBackgroundStyle( style )
	styleInheritsFrom( BaseStyle, nil )

	style = Widgets.newRectangleBackgroundStyle()

	TestUtils.verifyBackgroundStyle( style )
	styleInheritsFrom( BaseStyle, nil )

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

	styleInheritsPropertyValue( s1, 'debugOn', false )

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








