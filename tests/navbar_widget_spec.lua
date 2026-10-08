--====================================================================--
-- Test: NavBar Widget, NavItem
--====================================================================--

module(..., package.seeall)


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.1.0"



--====================================================================--
--== Imports


local dUI = require 'lib.dmc_ui'



--====================================================================--
--== Support Functions


local W, H = 320, 40 -- the bar's size
local MARGIN = 5 -- between the bar's edge and a button

local widgets

local function track( w )
	widgets[ #widgets+1 ] = w
	return w
end

-- run the widget's pending commit now, instead of on the next frame
local function commit( w )
	w:__validate__()
	return w
end

-- run one frame of the bar's slide, 'ms' from now
-- (it moves on enterFrame; a test doesn't wait for frames)
local function frame( bar, ms )
	commit( bar )
	local f = bar._enterFrame_f
	if f then f( { name='enterFrame', time=system.getTimer()+( ms or 0 ) } ) end
	commit( bar )
end

-- the style specs load the base styles with their test defaults
-- (anchorX 503, ...): give each bar usable values
local function newNavBar( params )
	params = params or {}
	params.style = params.style or {}
	local s = params.style
	if s.debugOn==nil then s.debugOn = false end
	if s.width==nil then s.width = W end
	if s.height==nil then s.height = H end
	if s.anchorX==nil then s.anchorX = 0.5 end
	if s.anchorY==nil then s.anchorY = 0.5 end
	return commit( track( dUI.newNavBar( params ) ) )
end

-- an item is removed by its bar
local function newNavItem( title, params )
	params = params or {}
	params.titleText = title
	return commit( dUI.newNavItem( params ) )
end

-- a bar with items already on its stack, at rest
local function newNavBarWith( ... )
	local bar = newNavBar()
	local items = {}
	for i, title in ipairs( { ... } ) do
		items[i] = newNavItem( title )
		bar:pushNavItem( items[i], { animate=false } )
		commit( bar )
	end
	return bar, items
end

local function stack( bar )
	local t = {}
	for i, item in ipairs( bar._items ) do t[i] = item.titleText end
	return table.concat( t, ',' )
end

-- a delegate which counts its calls
local function newDelegate( shouldPop )
	return {
		asked=0,
		popped={},
		shouldPopItem=function( self, bar, item )
			self.asked = self.asked + 1
			return shouldPop
		end,
		didPopItem=function( self, bar, item )
			self.popped[ #self.popped+1 ] = item.titleText
		end,
	}
end



--====================================================================--
--== Module Testing
--====================================================================--


function setup()
	widgets = {}
end

function teardown()
	for _, w in ipairs( widgets ) do
		if w.view then w:removeSelf() end
	end
	widgets = nil
end



--====================================================================--
--== Test NavBar


--[[
two pushes before a frame has passed: both items are on the stack
(the second replaced the first, and its slide raised an error)
--]]
function test_twoPushesInOneFrame()
	local bar = newNavBar()
	local home, settings = newNavItem( "Home" ), newNavItem( "Settings" )

	bar:pushNavItem( home )
	bar:pushNavItem( settings )
	frame( bar, 1000 )

	assert_equal( "Home,Settings", stack( bar ) )
	assert_nil( bar._enterFrame_f )
	assert_false( home.title.isVisible )
	assert_true( settings.title.isVisible )
	assert_true( settings.backButton.isVisible )
end


--[[
a change to the bar after a push doesn't run the push again
(every later commit pushed the item once more)
--]]
function test_commitDoesNotRepeatTransition()
	local bar = newNavBarWith( "One", "Two" )

	bar.x = 10
	commit( bar )
	bar.width = 200
	commit( bar )
	bar.debugOn = true
	commit( bar )

	assert_equal( "One,Two", stack( bar ) )
end


--[[
a push during a slide takes the slide to its end (it raised an error)
--]]
function test_pushDuringSlide()
	local bar = newNavBarWith( "One" )
	local two, three = newNavItem( "Two" ), newNavItem( "Three" )

	bar:pushNavItem( two )
	frame( bar, 100 )
	assert_not_nil( bar._enterFrame_f, "slide is running" )

	bar:pushNavItem( three )
	assert_equal( "One,Two", stack( bar ) )
	frame( bar, 100 )
	frame( bar, 1000 )

	assert_equal( "One,Two,Three", stack( bar ) )
	assert_nil( bar._enterFrame_f )
	assert_false( two.title.isVisible )
	assert_true( three.title.isVisible )
end


--[[
pushing an item which is on the stack is refused
--]]
function test_pushItemTwice()
	local bar, items = newNavBarWith( "One", "Two" )

	assert_error( function() bar:pushNavItem( items[1] ) end )
	assert_error( function() bar:pushNavItem( "Three" ) end )
	assert_equal( "One,Two", stack( bar ) )
end


--[[
the left and back buttons rest at the left edge, the title in the
middle, the right button at the right edge, inside the bar (it was
drawn outside, anchored at its left side)
--]]
function test_itemLayout()
	local bar = newNavBar()
	local left, right = dUI.newButton{ labelText="Menu" }, dUI.newButton{ labelText="Add" }
	local root = newNavItem( "Root", { leftButton=left, rightButton=right } )
	local nxt = newNavItem( "Next" )

	bar:pushNavItem( root )
	commit( bar )

	assert_equal( -W*0.5+MARGIN, left.x )
	assert_equal( 0, left.anchorX )
	assert_true( left.isVisible )
	assert_false( root.backButton.isVisible )
	assert_equal( 0, root.title.x )
	assert_equal( W*0.5-MARGIN, right.x )
	assert_equal( 1, right.anchorX )
	assert_true( right.isVisible )

	bar:pushNavItem( nxt, { animate=false } )
	commit( bar )

	assert_false( left.isVisible )
	assert_false( right.isVisible )
	assert_true( nxt.backButton.isVisible )
	assert_equal( -W*0.5+MARGIN, nxt.backButton.x )
end


--[[
the top item follows the bar's width, height and anchors
(its parts stayed where the last slide left them)
--]]
function test_sizeAndAnchorChange()
	local bar = newNavBar()
	local right = dUI.newButton{ labelText="Add" }
	local root = newNavItem( "Root", { rightButton=right } )
	local nxt = newNavItem( "Next", { rightButton=dUI.newButton{ labelText="Edit" } } )
	bar:pushNavItem( root )
	commit( bar )
	bar:pushNavItem( nxt, { animate=false } )
	commit( bar )

	bar.width = 200
	commit( bar )
	assert_equal( -100+MARGIN, nxt.backButton.x )
	assert_equal( 0, nxt.title.x )
	assert_equal( 100-MARGIN, nxt.rightButton.x )

	-- anchored at its top left: the bar's middle is at 100, 30
	bar.anchorX, bar.anchorY = 0, 0
	bar.height = 60
	commit( bar )
	assert_equal( MARGIN, nxt.backButton.x )
	assert_equal( 100, nxt.title.x )
	assert_equal( 200-MARGIN, nxt.rightButton.x )
	assert_equal( 30, nxt.title.y )
	assert_equal( 30, nxt.backButton.y )
	assert_equal( 30, nxt.rightButton.y )
	-- the items below the top one too
	assert_equal( 30, root.title.y )
	assert_equal( 30, right.y )
end


--[[
a pop slides back to the item below, tells the delegate, and removes
the popped item. the right button comes back to its place (it was 5
off after a pop)
--]]
function test_popNavItem()
	local bar = newNavBar()
	local right = dUI.newButton{ labelText="Add" }
	local one, two = newNavItem( "One", { rightButton=right } ), newNavItem( "Two" )
	local del = newDelegate( true )
	bar.delegate = del
	bar:pushNavItem( one )
	commit( bar )
	bar:pushNavItem( two, { animate=false } )
	commit( bar )

	bar:popNavItemAnimated()
	frame( bar, 100 )
	assert_equal( "One,Two", stack( bar ) )
	assert_equal( 0, #del.popped, "not popped during the slide" )
	frame( bar, 1000 )

	assert_equal( "One", stack( bar ) )
	assert_nil( bar._enterFrame_f )
	assert_equal( "Two", del.popped[1] )
	assert_equal( 1, #del.popped )
	assert_nil( two.title, "popped item is removed" )
	assert_true( one.title.isVisible )
	assert_false( one.backButton.isVisible )
	assert_equal( W*0.5-MARGIN, right.x )
end


--[[
the root item stays (popping it raised an error)
--]]
function test_popRootItem()
	local bar, items = newNavBarWith( "One" )

	bar:popNavItemAnimated()
	frame( bar, 1000 )

	assert_equal( "One", stack( bar ) )
	assert_true( items[1].title.isVisible )
end


--[[
the back button asks the delegate. a refusal pops nothing, and
didPopItem isn't called (it was, every time)
--]]
function test_backButtonRefused()
	local bar, items = newNavBarWith( "One", "Two" )
	local del = newDelegate( false )
	local events = 0
	bar.delegate = del
	bar:addEventListener( bar.EVENT, function( e )
		if e.type==bar.BACK_BUTTON then events = events + 1 end
	end )

	items[2].backButton:press()
	frame( bar, 1000 )

	assert_equal( 1, del.asked )
	assert_equal( 0, #del.popped )
	assert_equal( 1, events )
	assert_equal( "One,Two", stack( bar ) )
end


--[[
a second press during the slide is ignored (it raised an error)
--]]
function test_backButtonTwice()
	local bar, items = newNavBarWith( "One", "Two", "Three" )
	local del = newDelegate( true )
	bar.delegate = del

	items[3].backButton:press()
	frame( bar, 100 )
	items[3].backButton:press()
	frame( bar, 100 )
	frame( bar, 1000 )

	assert_equal( 1, del.asked )
	assert_equal( "One,Two", stack( bar ) )
	assert_equal( "Three", del.popped[1] )
	assert_equal( 1, #del.popped )
end


--[[
a bar removed during a slide stops it, and removes its items
(the slide went on and raised an error; so did the background, a frame
after any bar was removed)
--]]
function test_removeDuringSlide()
	local bar, items = newNavBarWith( "One" )
	local two = newNavItem( "Two" )
	local bg = bar._wgtBg
	bar:pushNavItem( two )
	frame( bar, 100 )
	assert_not_nil( bar._enterFrame_f, "slide is running" )

	bar:removeSelf()

	assert_nil( bar._enterFrame_f )
	assert_nil( items[1].title )
	assert_nil( two.title )
	assert_nil( bg.view, "background is removed" )
end


--[[
a style written inline keeps the bar's background type
(it became Background's own default, 'rounded', drawn 78 wide)
--]]
function test_inlineStyle()
	local plain = newNavBar()
	local bar = newNavBar{ style={ height=60 } }

	assert_equal( plain.style.background.type, bar.style.background.type )
	assert_equal( 60, bar.style.background.height )
	assert_equal( W, bar.style.background.width )
end


--[[
debugOn shows the bar's touch area
--]]
function test_debugOn()
	local bar = newNavBarWith( "One" )

	bar.debugOn = true
	commit( bar )
	assert_true( bar._rctHit.fill.a > 0 )

	bar.debugOn = false
	commit( bar )
	assert_equal( 0, bar._rctHit.fill.a )
end



--[[
a touch or a tap on the bar stays with it (a tap reached what lies
behind the bar: 'tap' is sent apart from 'touch')
--]]
function test_touchAndTapAreKept()
	local bar, items = newNavBarWith( "One", "Two" )
	local o = bar._rctHit

	assert_true( o:dispatchEvent{ name='touch', phase='began', target=o, x=0, y=0 } )
	assert_true( o:dispatchEvent{ name='tap', target=o, x=0, y=0, numTaps=1 } )

	-- its buttons keep their taps too
	o = items[2].backButton._rctHit
	assert_true( o:dispatchEvent{ name='tap', target=o, x=0, y=0, numTaps=1 } )
end



--====================================================================--
--== Test NavItem


--[[
an item's parts are hidden until its bar shows them
(they were drawn at the top left of the screen)
--]]
function test_itemHiddenUntilPushed()
	local left = dUI.newButton{ labelText="Menu" }
	local item = newNavItem( "Alone", { leftButton=left } )

	assert_false( item.title.isVisible )
	assert_false( item.backButton.isVisible )
	assert_false( left.isVisible )
	assert_equal( "Alone", item.title.text )

	item.titleText = "Renamed"
	commit( item )
	assert_equal( "Renamed", item.title.text )

	item:removeSelf()
end


--[[
a style written inline keeps the type of its buttons' backgrounds
(they became Background's own default, 'rounded': a gray button behind
"< Back")
--]]
function test_itemInlineStyle()
	local plain = newNavItem( "Plain" )
	local item = newNavItem( "Styled", { style={ title={ textColor={ 1, 0, 0, 1 } } } } )

	for _, name in ipairs( { 'backButton', 'leftButton', 'rightButton' } ) do
		for _, state in ipairs( { 'inactive', 'active', 'disabled' } ) do
			assert_equal(
				plain.style[ name ][ state ].background.type,
				item.style[ name ][ state ].background.type,
				name .. ' ' .. state
			)
		end
	end

	plain:removeSelf()
	item:removeSelf()
end


--[[
an item removed with a change waiting (it raised an error on the next
frame), and no global left behind
--]]
function test_itemRemoved()
	local item = dUI.newNavItem{ titleText="Alone", rightButton=dUI.newButton() }

	item:removeSelf()
	item:__commitProperties__()

	assert_nil( item.title )
	assert_nil( item.backButton )
	assert_nil( rawget( _G, 'o' ) )
end
