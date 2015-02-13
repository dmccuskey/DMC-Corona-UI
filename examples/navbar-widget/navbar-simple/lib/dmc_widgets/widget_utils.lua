
local Utils = {}


local PLATFORM = system.getInfo( 'platformName' )
Utils.IS_IOS = ( PLATFORM == 'iPhone OS' )
Utils.IS_ANDROID = ( PLATFORM == 'Android' )
Utils.IS_SIMULATOR = ( PLATFORM == 'Mac OS X' or PLATFORM == 'Win' )


return Utils
