--====================================================================--
-- Test: NavBar Widget
--====================================================================--

module(..., package.seeall)


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.1.0"



--====================================================================--
--== Imports


local Widget = require 'lib.dmc_widgets'
local TestUtils = require 'tests.test_utils'
local Utils = require 'dmc_utils'



--====================================================================--
--== Setup, Constants


local W, H = display.contentWidth, display.contentHeight
local H_CENTER, V_CENTER = W*0.5, H*0.5



--====================================================================--
--== Support Functions


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


local verifyTextFieldStyle = TestUtils.verifyTextFieldStyle
local marker = TestUtils.outputMarker



--====================================================================--
--== Module Testing
--====================================================================--


function suite_setup()

	Widget._loadNavBarSupport( {modex='test'} )

end



--====================================================================--
--== Test Static Functions



-- function test_verifyStyleProperties()
-- 	-- print( "test_verifyStyleProperties" )
-- 	local TextField = Widget.Style.TextField

-- 	local src

-- 	src = {
-- 		debugOn=true,
-- 		width=4,
-- 		height=10,
-- 		anchorX=1,
-- 		anchorY=5,

-- 		align='center',
-- 		backgroundStyle=5,
-- 		inputType=5,
-- 		isHitActive=true,
-- 		isSecure=true,
-- 		marginX=4,
-- 		marginY=5,
-- 		returnKey=5,

-- 		background={
-- 			debugOn=true,
-- 			width=4,
-- 			height=10,
-- 			anchorX=1,
-- 			anchorY=5,

-- 			type='rounded',

-- 			view={
-- 				debugOn=true,
-- 				width=4,
-- 				height=10,
-- 				anchorX=1,
-- 				anchorY=5,

-- 				cornerRadius=5,
-- 				fillColor=4,
-- 				strokeColor=4,
-- 				strokeWidth=5,
-- 			}
-- 		},

-- 		hint={
-- 			debugOn=true,
-- 			width=4,
-- 			height=10,
-- 			anchorX=1,
-- 			anchorY=5,

-- 			align='center',
-- 			fillColor=4,
-- 			font=4,
-- 			fontSize=5,
-- 			marginX=4,
-- 			marginY=5,
-- 			strokeColor=4,
-- 			strokeWidth=5,
-- 			textColor=5,
-- 		},

-- 		display={
-- 			debugOn=true,
-- 			width=4,
-- 			height=10,
-- 			anchorX=1,
-- 			anchorY=5,

-- 			align='center',
-- 			fillColor=4,
-- 			font=4,
-- 			fontSize=5,
-- 			marginX=4,
-- 			marginY=5,
-- 			strokeColor=4,
-- 			strokeWidth=5,
-- 			textColor=5,
-- 		},
-- 	}

-- 	hasValidStyleProperties( TextField, src )

-- 	src = {
-- 		debugOn=true,
-- 		width=4,
-- 		height=10,
-- 		anchorX=1,
-- 		anchorY=5,

-- 		align='center',
-- 		backgroundStyle=5,
-- 		inputType=5,
-- 		-- isHitActive=true,
-- 		isSecure=true,
-- 		marginX=4,
-- 		marginY=5,
-- 		returnKey=5,

-- 		background={
-- 			debugOn=true,
-- 			width=4,
-- 			height=10,
-- 			anchorX=1,
-- 			anchorY=5,

-- 			type='rounded',

-- 			view={
-- 				debugOn=true,
-- 				width=4,
-- 				-- height=10,
-- 				anchorX=1,
-- 				anchorY=5,

-- 				cornerRadius=5,
-- 				fillColor=4,
-- 				strokeColor=4,
-- 				strokeWidth=5,
-- 			}
-- 		},

-- 		hintx={ --<<
-- 			debugOn=true,
-- 			width=4,
-- 			height=10,
-- 			anchorX=1,
-- 			anchorY=5,

-- 			align='center',
-- 			fillColor=4,
-- 			font=4,
-- 			fontSize=5,
-- 			marginX=4,
-- 			marginY=5,
-- 			strokeColor=4,
-- 			strokeWidth=5,
-- 			textColor=5,
-- 		},

-- 		display={
-- 			debugOn=true,
-- 			width=4,
-- 			height=10,
-- 			-- anchorX=1,
-- 			anchorY=5,

-- 			align='center',
-- 			fillColor=4,
-- 			font=4,
-- 			fontSize=5,
-- 			marginX=4,
-- 			-- marginY=5,
-- 			strokeColor=4,
-- 			strokeWidth=5,
-- 			textColor=5,
-- 		},
-- 	}
-- 	hasInvalidStyleProperties( TextField, src )

-- end



-- function test_defaultStyleValues()
-- 	print( "test_defaultStyleValues" )
-- 	local TextField = Widget.Style.TextField

-- 	local defaults = TextField:getDefaultStyleValues()

-- 	hasValidStyleProperties( TextField, defaults )

-- end





-- function test_copyExistingSrcProperties()
-- 	-- print( "test_copyExistingSrcProperties" )
-- 	local TextField = Widget.Style.TextField

-- 	local src, dest

-- 	--== test empty source, empty destination

-- 	src = {
-- 		textfield={
-- 		}
-- 	}
-- 	dest = src.textfield

-- 	TextField.copyExistingSrcProperties( dest, src )

-- 	hasPropertyValue( dest, 'debugOn', nil )
-- 	hasPropertyValue( dest, 'width', nil )
-- 	hasPropertyValue( dest, 'height', nil )
-- 	hasPropertyValue( dest, 'anchorX', nil )
-- 	hasPropertyValue( dest, 'anchorY', nil )

-- 	hasPropertyValue( dest, 'align', nil )
-- 	hasPropertyValue( dest, 'backgroundStyle', nil )
-- 	hasPropertyValue( dest, 'inputType', nil )
-- 	hasPropertyValue( dest, 'isHitActive', nil )
-- 	hasPropertyValue( dest, 'isHitTestable', nil )
-- 	hasPropertyValue( dest, 'isSecure', nil )
-- 	hasPropertyValue( dest, 'marginX', nil )
-- 	hasPropertyValue( dest, 'marginY', nil )
-- 	hasPropertyValue( dest, 'returnKey', nil )


-- 	--== test non-empty source, empty destination

-- 	src = {
-- 		debugOn=100,
-- 		anchorX=101,
-- 		backgroundStyle='src-style',
-- 		isSecure=104,
-- 		marginX=103,

-- 		textfield={
-- 		}
-- 	}
-- 	dest = src.textfield

-- 	TextField.copyExistingSrcProperties( dest, src )

-- 	hasPropertyValue( dest, 'debugOn', src.debugOn )
-- 	hasPropertyValue( dest, 'width', nil )
-- 	hasPropertyValue( dest, 'height', nil )
-- 	hasPropertyValue( dest, 'anchorX', src.anchorX )
-- 	hasPropertyValue( dest, 'anchorY', nil )

-- 	hasPropertyValue( dest, 'align', nil )
-- 	hasPropertyValue( dest, 'backgroundStyle', src.backgroundStyle )
-- 	hasPropertyValue( dest, 'inputType', nil )
-- 	hasPropertyValue( dest, 'isHitActive', nil )
-- 	hasPropertyValue( dest, 'isHitTestable', nil )
-- 	hasPropertyValue( dest, 'isSecure', src.isSecure )
-- 	hasPropertyValue( dest, 'marginX', src.marginX )
-- 	hasPropertyValue( dest, 'marginY', nil )
-- 	hasPropertyValue( dest, 'returnKey', nil )


-- 	--== test non-empty source, non-empty destination

-- 	src = {
-- 		debugOn=100,
-- 		anchorX=101,
-- 		backgroundStyle='src-style',
-- 		isHitActive=106,
-- 		isSecure=104,
-- 		marginX=103,

-- 		textfield={
-- 			debugOn=200,
-- 			width=202,

-- 			align='tf-style',
-- 			isHitTestable=208,
-- 			marginX=204,
-- 			marginY=206,
-- 			returnKey=208
-- 		}
-- 	}
-- 	dest = src.textfield

-- 	TextField.copyExistingSrcProperties( dest, src )

-- 	hasPropertyValue( dest, 'debugOn', dest.debugOn )
-- 	hasPropertyValue( dest, 'width', dest.width )
-- 	hasPropertyValue( dest, 'height', nil )
-- 	hasPropertyValue( dest, 'anchorX', src.anchorX )
-- 	hasPropertyValue( dest, 'anchorY', nil )

-- 	hasPropertyValue( dest, 'align', dest.align )
-- 	hasPropertyValue( dest, 'backgroundStyle', src.backgroundStyle )
-- 	hasPropertyValue( dest, 'inputType', nil )
-- 	hasPropertyValue( dest, 'isHitActive', src.isHitActive )
-- 	hasPropertyValue( dest, 'isHitTestable', dest.isHitTestable )
-- 	hasPropertyValue( dest, 'isSecure', src.isSecure )
-- 	hasPropertyValue( dest, 'marginX', dest.marginX )
-- 	hasPropertyValue( dest, 'marginY', dest.marginY )
-- 	hasPropertyValue( dest, 'returnKey', dest.returnKey )

-- end


--====================================================================--
--== Test Class Methods



-- function test_styleClassBasics()
-- 	-- print( "test_styleClassBasics" )
-- 	local TextField = Widget.Style.TextField
-- 	local BaseStyle, defaultStyles
-- 	local style

-- 	defaultStyles = TextField:getDefaultStyleValues()
-- 	BaseStyle = TextField:getBaseStyle()

-- 	--== Verify a new button style

-- 	style = Widget.newTextFieldStyle()

-- 	TestUtils.verifyTextFieldStyle( style )
-- 	styleInheritsFrom( style, BaseStyle )

-- 	--== Destroy style

-- 	style:removeSelf()

-- end


function test_instanceBasics()
	-- print( "test_instanceBasics" )
	local style, widget, navItem

	-- style = Widget.newNavBarStyle()

	-- style = Widget.newNavItemStyle()

	widget = Widget.newNavBar()
	widget.x, widget.y = H_CENTER, V_CENTER

	-- widget = Widget.newNavItem()

	-- Add 1st Nav Item

	navItem=Widget.newNavItem{
		title="First"
	}
	widget:pushNavItem( navItem )

	timer.performWithDelay( 1000, function()
		navItem=Widget.newNavItem{
			title="Second"
		}
		widget:pushNavItem( navItem )
	end)

	timer.performWithDelay( 2000, function()
		navItem=Widget.newNavItem{
			title="Third"
		}
		widget:pushNavItem( navItem )
	end)

	-- timer.performWithDelay( 2000, function()
	-- 	widget:popNavItemAnimated()
	-- end)

end

