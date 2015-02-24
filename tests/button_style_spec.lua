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


--[[
Test to ensure that the correct property values are
copied during initialization
--]]
function test_addMissingProperties_Rounded()

	local Button = Widgets.Style.Button


	local src, dest


end


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


function test_defaultInheritance()
	print( "test_defaultInheritance" )
	local Button = Widgets.Style.Button
	local StyleDefault = Button:getBaseStyle()

	local s1, child

	-- Default Style

	-- verifyButtonStyle( StyleDefault )

	-- default button

	marker()

	b1 = Widgets.newButtonStyle()

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

end






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

