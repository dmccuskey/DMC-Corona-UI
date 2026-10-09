--====================================================================--
-- Blue Theme
--
-- background-themed's blue theme: a 9-slice background from an image sheet
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
		view={
			sheetInfo='asset.background.background-sheet',
			sheetImage='asset/background/background-sheet.png',
			offsetLeft=6,
			offsetRight=7,
			offsetTop=4,
			offsetBottom=12,
		}
	} )

end



return {
	initialize=initializeTheme
}
