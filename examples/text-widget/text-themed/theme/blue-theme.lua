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

	Theme.addStyle( 'home-text', Style.newTextStyle{
		textColor='#0000ff',
		fontSize=30
	})

end



return {
	initialize=initializeTheme
}
