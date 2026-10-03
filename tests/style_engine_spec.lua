--====================================================================--
-- Test: Style Engine
--
-- the shared style machinery: names, destroy, themes,
-- inherit changes, base styles, change events
--====================================================================--

module(..., package.seeall)

--====================================================================--
-- Test: Style Engine
--====================================================================--

-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.1.0"



--====================================================================--
--== Imports


local dUI = require 'lib.dmc_ui'
local Kolor = require 'dmc_kolor'
local TestUtils = require 'tests.test_utils'



--====================================================================--
--== Setup, Constants


local StyleMgr = dUI.Style.Manager

local styleInheritsFrom = TestUtils.styleInheritsFrom
local styleHasPropertyValue = TestUtils.styleHasPropertyValue
local styleInheritsPropertyValue = TestUtils.styleInheritsPropertyValue



--====================================================================--
--== Support Functions


local function colorIs( color, r, g, b )
	assert_equal( 'table', type(color), "color should be a table" )
	assert_equal( r, color[1], "incorrect red" )
	assert_equal( g, color[2], "incorrect green" )
	assert_equal( b, color[3], "incorrect blue" )
end



--====================================================================--
--== Test Setup


-- in setup: lunatest skips teardown after a failure
function setup()
	StyleMgr.purgeStyles()
	StyleMgr._activeTheme = nil
	StyleMgr._theme = {}
end

function teardown()
	StyleMgr.purgeStyles()
	StyleMgr._activeTheme = nil
	StyleMgr._theme = {}
end



--====================================================================--
--== Names


function test_navItemStyleHasType()
	local s1 = dUI.newNavItemStyle()

	assert_equal( 'NavItem', s1.TYPE, "incorrect TYPE" )

	s1.name = 'nav-item'
	assert_equal( s1, StyleMgr.getStyle( 'NavItem', 'nav-item' ), "style should be found by name" )
end


function test_refusedDuplicateNameKeepsOther()
	local s1 = dUI.newTextStyle()
	local s2 = dUI.newTextStyle()

	s1.name = 'dup'
	s2.name = 'dup' -- refused, already taken
	assert_equal( s1, StyleMgr.getStyle( 'Text', 'dup' ), "first style should keep name" )

	s2.name = 'other'
	assert_equal( s1, StyleMgr.getStyle( 'Text', 'dup' ), "first style should not be removed" )
	assert_equal( s2, StyleMgr.getStyle( 'Text', 'other' ), "second style should be added" )
end



--====================================================================--
--== Destroy


function test_destroyedStyleLeavesManager()
	local s1 = dUI.newTextStyle()
	s1.name = 'gone'
	assert_equal( s1, StyleMgr.getStyle( 'Text', 'gone' ), "style should be added" )

	s1:removeSelf()
	assert_nil( StyleMgr.getStyle( 'Text', 'gone' ), "style should be removed" )
end


function test_destroyedInheritFallsBackToBase()
	local Text = dUI.Style.Text
	local StyleBase = Text:getBaseStyle()

	local s1 = dUI.newTextStyle{ fontSize=77 }
	local s2 = dUI.newTextStyle{ inherit=s1, marginX=5 }
	styleInheritsPropertyValue( s2, 'fontSize', 77 )

	local resets = 0
	s2:addEventListener( s2.EVENT, function(e)
		if e.type==s2.STYLE_RESET then resets=resets+1 end
	end)

	s1:removeSelf()

	styleInheritsFrom( s2, StyleBase )
	styleInheritsPropertyValue( s2, 'fontSize', StyleBase.fontSize )
	styleHasPropertyValue( s2, 'marginX', 5 )
	assert_equal( 1, resets, "incorrect count for reset" )
end



--====================================================================--
--== Themes


function test_themeFallsBackToGlobalStyles()
	local s1 = dUI.newTextStyle()
	s1.name = 'global-text'

	local t1 = dUI.newTextStyle()
	local Theme = dUI.createTheme( 'test-theme', { name="Test Theme" } )
	Theme.addStyle( 'theme-text', t1 )

	dUI.activateTheme( 'test-theme' )
	assert_equal( 'test-theme', dUI.getActiveThemeId(), "theme should be active" )

	assert_equal( t1, StyleMgr.getStyle( 'Text', 'theme-text' ), "theme style should be found" )
	assert_equal( s1, StyleMgr.getStyle( 'Text', 'global-text' ), "global style should be found" )
	assert_nil( StyleMgr.getStyle( 'Text', 'missing' ), "missing style should be nil" )
end


function test_themeStyleWinsOverGlobal()
	local s1 = dUI.newTextStyle()
	s1.name = 'title'

	local t1 = dUI.newTextStyle()
	local Theme = dUI.createTheme( 'test-theme', { name="Test Theme" } )
	Theme.addStyle( 'title', t1 )

	assert_equal( s1, StyleMgr.getStyle( 'Text', 'title' ), "global style without theme" )
	dUI.activateTheme( 'test-theme' )
	assert_equal( t1, StyleMgr.getStyle( 'Text', 'title' ), "theme style with theme" )
end



--====================================================================--
--== Inherit Change


function test_inheritChangeKeepsLocalProperties()
	local s1 = dUI.newTextStyle{ fontSize=11, marginX=21 }
	local s2 = dUI.newTextStyle{ fontSize=12, marginX=22 }
	local s3 = dUI.newTextStyle{ inherit=s1, fontSize=40 }

	styleHasPropertyValue( s3, 'fontSize', 40 )
	styleInheritsPropertyValue( s3, 'marginX', 21 )

	local resets = 0
	s3:addEventListener( s3.EVENT, function(e)
		if e.type==s3.STYLE_RESET then resets=resets+1 end
	end)

	s3.inherit = s2

	styleInheritsFrom( s3, s2 )
	styleHasPropertyValue( s3, 'fontSize', 40 )
	styleInheritsPropertyValue( s3, 'marginX', 22 )
	assert_equal( 1, resets, "incorrect count for reset" )

	-- clean slate

	s3:clearProperties()
	styleInheritsPropertyValue( s3, 'fontSize', 12 )
end


function test_inheritChangeKeepsLocalChildProperties()
	local s1 = dUI.newButtonStyle()
	local s2 = dUI.newButtonStyle()
	local s3 = dUI.newButtonStyle{ inherit=s1 }

	s3.active.label.fontSize = 41

	s3.inherit = s2

	styleInheritsFrom( s3.active.label, s2.active.label )
	styleHasPropertyValue( s3.active.label, 'fontSize', 41 )
end



--====================================================================--
--== Base Styles


function test_baseStyleClearsToDefaults()
	local Text = dUI.Style.Text
	local StyleBase = Text:getBaseStyle()
	local defaults = Text:getDefaultStyleValues()

	local fontSize = StyleBase.fontSize
	StyleBase.fontSize = fontSize + 1
	StyleBase:clearProperties()

	assert_equal( defaults.fontSize, StyleBase.fontSize, "incorrect value for fontSize" )
	assert_equal( defaults.font, StyleBase.font, "incorrect value for font" )
	assert_equal( defaults.align, StyleBase.align, "incorrect value for align" )
end


function test_baseStyleRejectsNil()
	local StyleBase = dUI.Style.Text:getBaseStyle()

	assert_error( function() StyleBase.fontSize = nil end, "base style property can't be nil" )
	assert_error( function() StyleBase.textColor = nil end, "base style color can't be nil" )
	assert_not_nil( StyleBase.fontSize, "fontSize should be kept" )
end



--====================================================================--
--== Colors


function test_colorEventHasStoredValue()
	local s1 = dUI.newTextStyle()
	local value

	s1:addEventListener( s1.EVENT, function(e)
		if e.type==s1.PROPERTY_CHANGED and e.property=='textColor' then value=e.value end
	end)

	s1.textColor = {0.5,0.25,0}

	assert_equal( s1.textColor, value, "event should send stored color" )
end


local function colorNotTranslatedTwice()
	local s1 = dUI.newTextStyle()
	local value

	s1:addEventListener( s1.EVENT, function(e)
		if e.type==s1.PROPERTY_CHANGED and e.property=='textColor' then value=e.value end
	end)

	s1.textColor = {255,0,0}
	colorIs( s1.textColor, 1, 0, 0 )
	colorIs( value, 1, 0, 0 )

	local s2 = s1:cloneStyle()
	colorIs( s2.textColor, 1, 0, 0 )

	local s3 = dUI.newTextStyle()
	s3.textColor = s1.textColor
	colorIs( s3.textColor, 1, 0, 0 )
end

function test_colorNotTranslatedTwice()
	-- 0-255 colors, translated for real (not test mode);
	-- set back here: lunatest skips teardown after a failure
	Kolor.setRunMode( 'run' )
	Kolor.setColorFormat( Kolor.hRGBA )
	local ok, err = pcall( colorNotTranslatedTwice )
	Kolor.setColorFormat( Kolor.dRGBA )
	Kolor.setRunMode( 'test' )
	if not ok then error( err, 0 ) end
end



--====================================================================--
--== Parent to Child


function test_textFieldBackgroundSkipsTextProperties()
	local s1 = dUI.newTextFieldStyle{ align='center', marginX=4, marginY=6 }
	local bg = s1.background

	assert_nil( rawget( bg, 'align' ), "background should not get align" )
	assert_nil( rawget( bg, 'marginX' ), "background should not get marginX" )
	assert_nil( rawget( bg, 'marginY' ), "background should not get marginY" )
end
