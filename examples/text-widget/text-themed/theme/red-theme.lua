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

	Theme.addStyle( 'home-text', Style.newTextStyle{
		textColor='#ff0000',
		fontSize=40
	})

	-- activating here is optional

	Style.activateTheme( 'red-theme' )

end



return {
	initialize=initializeTheme
}
