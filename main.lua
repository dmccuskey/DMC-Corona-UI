--====================================================================--
-- Unit Tests for DMC-Widgets
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2014-2015 David McCuskey. All Rights Reserved.
--====================================================================--



print( '\n\n##############################################\n\n' )



--====================================================================--
--== Imports

require 'tests.lunatest'



--====================================================================--
--== Setup test suites and run


lunatest.suite( 'tests.text_style_spec' )
lunatest.suite( 'tests.rounded_view_style_spec' )
lunatest.suite( 'tests.rectangle_view_style_spec' )
lunatest.run()
