--====================================================================--
-- Red Theme
--
-- background-themed's red theme: a red rectangle background
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2026 David McCuskey. All Rights Reserved.
--====================================================================--



local function initializeTheme( Style )

	local Theme = Style.createTheme( 'red-theme', {
		name="Red Theme",
	})

	Theme.addStyle( 'home-background', Style.newBackgroundStyle{
		width=140, height=60,
		type='rectangle',
		view={
			fillColor={ 0.8, 0.2, 0.2 },
			strokeColor={ 0.4, 0, 0 },
			strokeWidth=3,
		}
	} )

end



return {
	initialize=initializeTheme
}
