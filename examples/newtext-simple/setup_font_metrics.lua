

--===================================================================--
-- Imports
--===================================================================--

local ShuNewText = require( 'lib.shufouna_newText' )


--===================================================================--
-- Setup, Constants
--===================================================================--


local PLATFORM = system.getInfo( 'platformName' )
local IS_IOS = ( PLATFORM ==  'iPhone OS' )
local IS_ANDROID = ( PLATFORM ==  'Android' )
local IS_SIMULATOR = ( PLATFORM ==  'Mac OS X' or PLATFORM ==  'Win' )


if IS_ANDROID then
	p = {
		sizes = { 12, 16, 25, 50, 100 },
		[12] = { offsetX=0, offsetY=0 },
		[16] = { offsetX=0, offsetY=-5 },
		[25] = { offsetX=0, offsetY=-5 },
		[50] = { offsetX=0, offsetY=-5 },
		[100] = { offsetX=0, offsetY=-5 }
	}
	ShuNewText:setFontMetric( 'HelveticaNeueLTArabic-Roman', p )
	p = {
		sizes = { 25, 50, 100 },
		[25] = { offsetX=0, offsetY=0 },
		[50] = { offsetX=0, offsetY=0 },
		[100] = { offsetX=0, offsetY=0 }
	}
	ShuNewText:setFontMetric( 'Maybe-Bold', p )
	p = {
		sizes = { 35 },
		[35] = { offsetX=0, offsetY=5 },
	}
	ShuNewText:setFontMetric( 'GESSTwoBold-Bold', p )


elseif IS_IOS then
	p = {
		sizes = { 12, 16, 25, 50, 100 },
		[12] = { offsetX=0, offsetY=0 },
		[16] = { offsetX=0, offsetY=0 },
		[25] = { offsetX=0, offsetY=-5 },
		[50] = { offsetX=0, offsetY=-5 },
		[100] = { offsetX=0, offsetY=-5 }
	}
	ShuNewText:setFontMetric( 'HelveticaNeueLTArabic-Roman', p )
	p = {
		sizes = { 25, 50, 100 },
		[25] = { offsetX=0, offsetY=5 },
		[50] = { offsetX=0, offsetY=5 },
		[100] = { offsetX=0, offsetY=5 }
	}
	ShuNewText:setFontMetric( 'Maybe-Bold', p )


elseif IS_SIMULATOR then
	p = {
		sizes = { 12, 16, 25, 50, 100 },
		[12] = { offsetX=0, offsetY=0 },
		[16] = { offsetX=0, offsetY=-5 },
		[25] = { offsetX=0, offsetY=-5 },
		[50] = { offsetX=0, offsetY=-5 },
		[100] = { offsetX=0, offsetY=-5 }
	}
	ShuNewText:setFontMetric( 'HelveticaNeueLTArabic-Roman', p )
	p = {
		sizes = { 25, 50, 100 },
		[25] = { offsetX=0, offsetY=5 },
		[50] = { offsetX=0, offsetY=5 },
		[100] = { offsetX=0, offsetY=5 }
	}
	ShuNewText:setFontMetric( 'Maybe-Bold', p )
	p = {
		sizes = { 35 },
		[35] = { offsetX=0, offsetY=5 },
	}
	ShuNewText:setFontMetric( 'GESSTwoBold-Bold', p )

end
