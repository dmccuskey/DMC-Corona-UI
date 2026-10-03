--====================================================================--
-- Blue Theme
--
-- background-themed's blue theme: the default 9-slice background
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2026 David McCuskey. All Rights Reserved.
--====================================================================--



local function initializeTheme( Style )

	local Theme = Style.createTheme( 'blue-theme', {
		name="Blue Theme",
	})

	Theme.addStyle( 'home-background', Style.newBackgroundStyle{
		width=140, height=60,
		type='9-slice',
	} )

end



return {
	initialize=initializeTheme
}
