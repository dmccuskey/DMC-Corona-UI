--====================================================================--
-- Blue Theme
--
-- Very simple theme setup for Text Widgets
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2015 David McCuskey. All Rights Reserved.
--====================================================================--



local function initializeTheme( Style )

	-- create a new Theme

	local Theme = Style.createTheme( 'blue-theme', {
		name="Blue Theme",
	})

	-- add styles to Theme

	-- https://color.adobe.com/Vintage-Romantic-color-theme-2646522

	Theme.addStyle( 'home-text', Style.newTextStyle{
		fillColor='#bfaf80',
		textColor='#260126',
		font='Times-BoldItalic',
		fontSize=30
	})

end




return {
	initialize=initializeTheme
}
