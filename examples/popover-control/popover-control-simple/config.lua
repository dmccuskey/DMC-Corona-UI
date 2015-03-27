--====================================================================--
-- Config.lua
--
-- references
-- http://developer.coronalabs.com/content/configuring-projects
-- http://www.coronalabs.com/blog/2012/12/04/the-ultimate-config-lua-file/
--====================================================================--


local ratio = display.pixelHeight / display.pixelWidth

application = {}

--== iPad & iPad Retina
application.content = {
	width = 768,
	height = 1024,
	scale = 'letterBox',
	xAlign = 'center',
	yAlign = 'center',
	imageSuffix = {
		['@2x'] = 1.5,
		['@4x'] = 3.0,
	},
}

