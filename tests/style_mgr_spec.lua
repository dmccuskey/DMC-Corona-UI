--====================================================================--
-- Test: Style Manager
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

local StyleMgr = Widget.StyleMgr



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


local marker = TestUtils.outputMarker



--====================================================================--
--== Module Testing
--====================================================================--


function suite_setup()

end

function setup()

	StyleMgr:purgeStyles()

end



--====================================================================--
--== Test Class Methods


--== Add Style

function test_errorAddStyle_badStyles()
	-- print( "test_errorAddStyle_badStyles" )
	assert_error( function() StyleMgr:addStyle( nil ) end, "style can't be nil" )
	assert_error( function() StyleMgr:addStyle( {} ) end, "style can't be nil" )
	assert_error( function() StyleMgr:addStyle( 4 ) end, "style can't be nil" )
	assert_error( function() StyleMgr:addStyle( "bad style" ) end, "style can't be nil" )
end

function test_errorAddStyle_noName()
	-- print( "test_errorAddStyle_noName" )
	local s1 = Widget.newRoundedBackgroundStyle()
	assert_equal( StyleMgr:addStyle( s1 ), nil, "style should be added" )
end

function test_errorAddStyle_duplicateName()
	-- print( "test_errorAddStyle_noName" )
	local name = 'rounded-background-style'
	local s1, s2

	s1 = Widget.newRoundedBackgroundStyle()
	s1.name = name
	s2 = Widget.newRoundedBackgroundStyle()
	s2.name = name

	assert_equal( StyleMgr:getStyle( s1.TYPE, name ), s1, "style should be added" )

end

function test_addStyleViaNameAdd()
	-- print( "test_addStyleViaNameAdd" )
	local s1, name

	name = 'rounded-background-style'
	s1 = Widget.newRoundedBackgroundStyle()
	s1.name = name

	assert_equal( StyleMgr:getStyle( s1.TYPE, name ), s1, "style should be added" )
end


function test_changeStyleViaNameChange()
	-- print( "test_changeStyleViaNameChange" )
	local s1
	local n1, n2

	n1 = 'rounded-background-style'
	n2 = 'rounded-background-style2'

	s1 = Widget.newRoundedBackgroundStyle()
	s1.name = n1

	assert_equal( StyleMgr:getStyle( s1.TYPE, n1 ), s1, "style should be added" )

	s1.name = n2
	assert_equal( StyleMgr:getStyle( s1.TYPE, n2 ), s1, "style should be renamed")

end


--== Get Style

function test_errorGetStyle_badNames()
	-- print( "test_errorGetStyle_badNames" )
	assert_error( function() StyleMgr:getStyle( '', nil ) end, "name can't be nil" )
	assert_error( function() StyleMgr:getStyle( nil, {} ) end, "name can't be nil" )
	assert_error( function() StyleMgr:getStyle( 'hello', 4 ) end, "name can't be nil" )
end

function test_getStyle_stringName()
	-- print( "test_getStyle_stringName" )
	local s1, name

	name = 'rounded-background-style'
	s1 = Widget.newRoundedBackgroundStyle()
	s1.name = name

	assert_equal( StyleMgr:getStyle( s1.TYPE, name ), s1, "style should be added" )
end


--== Remove Style

function test_errorRemoveStyle_badNames()
	-- print( "test_errorRemoveStyle_badNames" )
	assert_error( function() StyleMgr:removeStyle( nil, nil ) end, "style can't be nil" )
	assert_error( function() StyleMgr:removeStyle( '', {} ) end, "style can't be nil" )
	assert_error( function() StyleMgr:removeStyle( nil, 4 ) end, "style can't be nil" )
end

function test_removeStyleViaNameChange()
	-- print( "test_removeStyleViaNameChange" )
	local s1, name

	name = 'rounded-background-style'
	s1 = Widget.newRoundedBackgroundStyle()
	s1.name = name

	assert_equal( StyleMgr:getStyle( s1.TYPE, name ), s1, "style should be added" )

	s1.name = nil
	assert_equal( StyleMgr:getStyle( s1.TYPE, name ), nil, "style should be removed")

end

function test_removeStyleViaNameChange()
	-- print( "test_removeStyleViaNameChange" )
	local s1, name

	name = 'rounded-background-style'
	s1 = Widget.newRoundedBackgroundStyle()
	s1.name = name

	assert_equal( StyleMgr:getStyle( s1.TYPE, name ), s1, "style should be added" )

	s1.name = nil
	assert_equal( StyleMgr:getStyle( s1.TYPE, name ), nil, "style should be removed")

end


--== Inherit

function test_inheritStyleByName()
	-- print( "test_inheritStyleByName" )
	local s1, s2
	local name

	name = 'rounded-background-style'
	s1 = Widget.newRoundedBackgroundStyle()
	s1.name = name

	assert_equal( StyleMgr:getStyle( s1.TYPE, name ), s1, "style could be added" )

	s2 = Widget.newRoundedBackgroundStyle()
	s2.inherit = name

	styleInheritsFrom( s2, s1 )

end


--[[
this test needs to be run by itself
since we're using timer.performWithDelay()
--]]
--[[
--]]
function test_addStyleToWidgetByName()
	-- print( "test_addStyleToWidgetByName" )
	local s1, s2
	local w1
	local n1, n2

	n1 = 'rounded-background-style'
	n2 = 'rounded-background-style2'

	s1 = Widget.newRoundedBackgroundStyle{
		width=200,
		height=100,
	}
	s1.name = n1

	s2 = Widget.newRoundedBackgroundStyle{
		width=100,
		height=50,
		view={
			fillColor={1,0,1,0.5}
		}
	}
	s2.name = n2

	assert_equal( StyleMgr:getStyle( s1.TYPE, n1 ), s1, "style could be added" )
	assert_equal( StyleMgr:getStyle( s2.TYPE, n2 ), s2, "style could be added" )

	w1 = Widget.newRoundedBackground()
	w1.x, w1.y = H_CENTER, V_CENTER

	w1.style = n1

	timer.performWithDelay( 1000, function()
		w1.style = n2
	end)

	timer.performWithDelay( 2000, function()
		w1.style = n1
	end)

end


--[[
add a style to a theme, create theme first
--]]
function test_addStyleToTheme()
	-- print( "test_addStyleToTheme" )
	local s1, n1
	local t1, tId

	tId = 'red-theme'
	t1 = Widget.createTheme{
		id = tId,
		name='Red Theme',
	}

	n1 = 'home-background-style'
	s1 = Widget.newRoundedBackgroundStyle{
		width=100,
		height=50,
		view={
			fillColor={1,0,1,0.5}
		}
	}

	Widget.addThemeStyle( tId, s1, n1 )

end

