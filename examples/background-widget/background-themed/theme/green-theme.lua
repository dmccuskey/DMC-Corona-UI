--====================================================================--
-- Green Theme
--
-- background-themed's green theme: a green rounded background
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2026 David McCuskey. All Rights Reserved.
--====================================================================--



local function initializeTheme( Style )

	local Theme = Style.createTheme( 'green-theme', {
		name="Green Theme",
	})

	Theme.addStyle( 'home-background', Style.newBackgroundStyle{
		width=140, height=60,
		type='rounded',
		view={
			cornerRadius=16,
			fillColor={ 0.3, 0.7, 0.3 },
			strokeColor={ 0, 0.3, 0 },
			strokeWidth=3,
		}
	} )

end



return {
	initialize=initializeTheme
}
