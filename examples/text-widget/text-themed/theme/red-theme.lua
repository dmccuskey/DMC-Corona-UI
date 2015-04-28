--====================================================================--
-- Red Theme
--
-- Very simple theme setup for Text Widgets
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2015 David McCuskey. All Rights Reserved.
--====================================================================--



local function initializeTheme( Style, Path )

	-- create a new Theme

	local Theme = Style.createTheme( 'red-theme', {
		name="Red Theme",
	})

	-- add styles to Theme

	-- https://color.adobe.com/Dark-Sunset-color-theme-2629114

	Theme.addStyle( 'home-text', Style.newTextStyle{
		fillColor='#160a47',
		textColor='#f2671f',
		font='HelveticaNeue-Bold',
		fontSize=30
	})

	-- activating here is optional

	Style.activateTheme( 'red-theme' )

end



return {
	initialize=initializeTheme
}
