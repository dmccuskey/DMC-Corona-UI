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

	Theme.addStyle( 'home-text', Style.newTextStyle{
		textColor='#00ff00',
		fontSize=20
	})

end



return {
	initialize=initializeTheme
}
