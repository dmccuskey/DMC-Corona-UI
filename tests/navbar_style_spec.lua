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


--====================================================================--
--== Test Class Methods


function test_instanceBasics()
	-- print( "test_instanceBasics" )
	local style, widget, navItem

	widget = Widget.newNavBar()
	widget.x, widget.y = H_CENTER, V_CENTER

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

	timer.performWithDelay( 3000, function()
		widget:popNavItemAnimated()
	end)

end

