--====================================================================--
-- Green Theme
--
-- Very simple theme setup for Text Widgets
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2015 David McCuskey. All Rights Reserved.
--====================================================================--



local function initializeTheme( Style )

	-- create a new Theme

	local Theme = Style.createTheme( 'green-theme', {
		name="Green Theme",
	})

	-- add styles to Theme

	-- https://color.adobe.com/The-Color-of-Traffic-color-theme-2589902

	Theme.addStyle( 'home-text', Style.newTextStyle{
		fillColor='#63aca6',
		textColor='#d93240',
		font='Optima-Bold',
		fontSize=20
	})

end



return {
	initialize=initializeTheme
}
