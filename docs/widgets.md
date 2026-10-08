# Widgets

Each widget: how to make it, its options, properties, methods and style. How styles work (inline, shared, named, inheritance) is in [Using Styles](styles.md).

The examples assume:

```lua
local dUI = require 'lib.dmc_ui'
```

## What All Widgets Share

A widget is a [dmc-objects](https://github.com/dmccuskey/dmc-objects) component: a Lua object with a display group, `widget.view`, that is on the stage from the start. Every widget has:

| Property / method | Meaning |
|---|---|
| `x`, `y` | position; also options of the constructor |
| `id` | any value, for your use; also an option |
| `style` | the widget's style ([What the Widget Holds](styles.md#what-the-widget-holds)); set it to a style, a style's name, a table or `nil` |
| `width`, `height`, `anchorX`, `anchorY`, `debugOn` | shortcuts to the same style properties |
| `setAnchor( { x, y } )` | sets `anchorX` and `anchorY` |
| `removeSelf()` | removes the widget from the screen and frees it |
| `addEventListener( name, f )`, `removeEventListener( name, f )` | the widget's own events (such as `button.EVENT`) |
| `autoMask` (constructor option) | `true` masks the widget to its size. Default `false`: Solar2D allows only three nested masks, and a full-screen widget needs none. |

Every style has `width`, `height`, `anchorX`, `anchorY` and `debugOn` (`true` draws helper outlines, depending on the widget).

A widget redraws after a change at the next frame, not at once, so several changes in a row cost one redraw ([Development](development.md#how-widgets-draw)).

A widget which takes touches keeps them: a touch or a tap on a Button, a TextField, a NavBar, a ScrollView or a TableView doesn't reach what lies behind it. Background and Text draw only, and let both through.

## Background

A backdrop: a rectangle, a rounded rectangle, a 9-slice image or an image, sized by its style. Other widgets use it for their own backgrounds: the button, the text field, the navigation bar.

```lua
local bg = dUI.newBackground{
	style={
		width=200, height=80,
		type='rounded',
		view={ cornerRadius=12, fillColor={ 0.3, 0.7, 0.3 } },
	}
}
bg.x, bg.y = 160, 120
```

`newRectangleBackground()`, `newRoundedBackground()`, `new9SliceBackground()` and `newImageBackground()` make one of that type; its style then leaves out `type`. The same goes for `newBackgroundStyle()` and `newRectangleBackgroundStyle()` and so on. A shared style or a style's name keeps its own type, whichever constructor it's given to.

**Style**: `type` and a child style `view`, whose properties depend on the type:

| `type` | `view` properties |
|---|---|
| `'rectangle'` | `fillColor`, `strokeColor`, `strokeWidth` |
| `'rounded'` | `cornerRadius`, `fillColor`, `strokeColor`, `strokeWidth` |
| `'9-slice'` | `sheetImage`, `sheetInfo` (an image sheet and its Texture Packer info module), `spriteFrames` (which frame is `topLeft`, `topMiddle`, ... `bottomRight`), `offsetLeft`, `offsetRight`, `offsetTop`, `offsetBottom` |
| `'image'` | `imagePath`, `offsetLeft`, `offsetRight`, `offsetTop`, `offsetBottom` |

The offsets are the image's margins, in pixels, that lie outside the background's size, such as a drop shadow: a 9-slice or image background of 100x50 draws its body at 100x50 and its shadow around it. A 9-slice background smaller than its corners draws only the corners. An image background is scaled to fit; with a `width` and `height` of 0 it's drawn at the image's own size.

The constants `dUI.RECTANGLE`, `dUI.ROUNDED`, `dUI.NINE_SLICE` and `dUI.IMAGE` hold the type names. The default 9-slice image is in `lib/dmc_ui/theme/default/background/`; the default offsets (1, 0, 0, 0) draw its shadow inside the size, and offsets of 6, 7, 4 and 12 draw it outside. `debugOn=true` covers the background in translucent red.

**Widget properties**: `type` (the style's `type`: setting it changes the drawing), `viewStyle` (the `view` child style).

## Text

A single line of text, drawn over an optional background rectangle. Without a `width`, the widget fits the text; with one, text that is too long ends in an ellipsis (`...`).

```lua
local title = dUI.newText{
	text="Wonderful",
	style={
		width=200, height=40,
		align='left',
		font=native.systemFont,
		fontSize=16,
		marginX=10, marginY=5,
		textColor={ 0, 0, 0 },
	}
}
title.text = "World"
```

**Options**: `text` (default `""`), `style`.

**Style**:

| Property | Meaning |
|---|---|
| `align` | `'left'`, `'center'` or `'right'`, within the width |
| `font`, `fontSize` | the font |
| `fontSizeMinimum` | with a `width`: text that doesn't fit is first shrunk down to this font size, then truncated. Default `0`, no shrinking. |
| `textColor` | text color |
| `marginX`, `marginY` | space between the edge and the text |
| `fillColor`, `strokeColor`, `strokeWidth` | the background rectangle; clear by default. Meant as a guide for checking margins while building a screen, but usable as a plain background. |

`height` sets the widget's height; the text inside keeps the height of its font. A `width` or `height` of `0` (the default) fits the text plus its margins; setting `text.width = nil` goes back to the style's width. A size that comes from the text is up to date as soon as you read it, even before the next frame redraws the widget.

**Widget properties**: `text`. Helpers for the style: `align`, `font`, `fontSize`, `marginX`, `textColor`, `fillColor`, `strokeWidth`, and the methods `setTextColor( r, g, b [, a] )`, `setFillColor()`, `setStrokeColor()`. `getTextHeight()` returns the height of the text.

**Events**: while the widget is sized to its text, it sends `text.EVENT`, type `text.DIMENSION_CHANGED`, with the new `width` and `height` each time it redraws its text:

```lua
title:addEventListener( title.EVENT, function( event )
	if event.type == title.DIMENSION_CHANGED then
		print( event.width, event.height )
	end
end )
```

## TextField

A text input. While it isn't being edited, it shows its text (or its hint) as a Text widget, drawn by Solar2D's graphics, so it can be styled like any widget and moves with its display group. Tapping it swaps in a native text field for the editing, and the Text widget comes back when editing ends.

```lua
local email = dUI.newTextField{
	hintText="Enter email:",
	style={
		width=300, height=50,
		inputType='email',
		returnKey='done',
		hint={ textColor={ 0.5, 0.5, 0.5 } },
	}
}
email.x, email.y = 160, 200

email:addEventListener( email.EVENT, function( event )
	if event.phase == 'ended' or event.phase == 'submitted' then
		print( 'email:', event.target.text )
	end
end )
```

**Options**: `text`, `hintText` (both default `""`), `style`.

**Style**:

| Property | Meaning |
|---|---|
| `align` | text alignment |
| `marginX`, `marginY` | space between the edge and the text |
| `inputType` | the keyboard: `'default'`, `'number'`, `'decimal'`, `'phone'`, `'url'`, `'email'` (constants `INPUT_DEFAULT` and so on on the widget) |
| `isSecure` | `true` hides the text, for passwords |
| `returnKey` | the return key's label: `'done'`, `'go'`, `'next'`, `'search'`, `'send'`, ... (constants `RETURN_DONE` and so on) |
| `isHitActive` | `false` ignores taps |
| `backgroundStyle` | background type, as a Background's `type` |
| `background` | child style: a Background style; with no `type`, the default 9-slice skin (drawn for a white page) |
| `hint`, `display` | child styles: Text styles for the hint and for the text |

**Widget properties**: `text`, `hintText`, `inputType`, `isSecure`, `isHitActive`, `isEditing` (read only), `delegate` (below). Child styles: `backgroundStyle`, `hintStyle`, `displayStyle`. Helpers: `align`, `marginX`, `marginY`, `hintFont`, `hintFontSize`, `displayFont`, `displayFontSize` (set only), `setHintTextColor()`, `setDisplayTextColor()`.

**Methods**: `setKeyboardFocus()` starts editing and shows the keyboard (while editing, it does nothing), `unsetKeyboardFocus()` ends it; `setEditActive( true | false )` shows or hides the native field; `setReturnKey( key )` sets the style's `returnKey`.

**Events**: `TextField.EVENT` (`'userInput'`), with Solar2D's `userInput` fields (`phase`: `'began'`, `'editing'`, `'ended'`, `'submitted'`; `text`, ...) and `target`, the widget. `widget.text` is up to date in every phase. As in Solar2D, `'submitted'` (the return key) is followed by `'ended'`.

**Delegate**: an object with any of these methods can accept or refuse edits; each is called on the delegate (`delegate:shouldBeginEditing( textfield )`) and returns `true` or `false`: `shouldBeginEditing( textfield )` on a tap, `shouldEndEditing( textfield )` on `'submitted'` and `'ended'` (`false` keeps editing; a field that lost the focus takes it back), and `shouldChangeCharacters( event )` (`event.target` is the text field; `startPosition`, `newCharacters`, `numDeleted` and `text` as in Solar2D's `userInput`; `false` puts the text back). `shouldClearTextField( textfield )` is never called: the field has no clear button. Set it with the `delegate` option or property.

**Keyboard**: `dUI.adjustForKeyboard()` slides a display group up so that the field being edited stays above the keyboard, and back when it closes ([Keyboard](api.md#keyboard)).

## Button

A button with a label and a background for each of its states: `inactive`, `active` (while pressed) and `disabled`.

- `newPushButton()` (or `newButton()`): active while pressed.
- `newToggleButton()`: each press switches it between active and inactive.
- `newRadioButton()`: a press makes it active; it stays active. A [Button Group](#button-group) makes the others inactive.

```lua
local ok = dUI.newPushButton{
	id='ok',
	labelText="OK",
	style={
		width=100, height=50,
		inactive={
			label={ textColor={ 0, 0, 0 } },
			background={ type='rounded', view={ fillColor={ 0.8, 0.8, 0.8 } } },
		},
		active={
			background={ type='rounded', view={ fillColor={ 0.5, 0.8, 0.5 } } },
		},
	},
	onRelease=function( event ) print( 'released', event.id ) end,
}
```

**Options**: `labelText` (default `"OK"`), `id`, `data` (any value, passed in events), `onPress`, `onRelease`, `onEvent` (functions), `style`.

**Style**:

| Property | Meaning |
|---|---|
| `inactive`, `active`, `disabled` | child styles, one for each state: `label` (a Text style), `background` (a Background style), `align`, `marginX`, `marginY`, `offsetX`, `offsetY` (moves the label; negative values too) |
| `align`, `marginX`, `marginY`, `offsetX`, `offsetY` | the label's alignment, margins and offset, handed to each state that doesn't set its own (later changes to `align` and the margins don't reach the label: [Known Issues](api.md#known-issues)) |
| `hitMarginX`, `hitMarginY` | extra touch area around the button |
| `isHitActive` | `false` ignores touches |

**Widget properties**: `labelText`, `id`, `data`, `isEnabled` (`false` shows `disabled` and ignores touches; the style, which other buttons may share, is left as is), `isActive` (read only), `hitMarginX`, `hitMarginY`, `isHitActive`, `onPress`, `onRelease`, `onEvent` (set only); the state styles `inactiveStyle`, `activeStyle`, `disabledStyle` (read only). `setHitMargin( x, y )` or `setHitMargin( { x, y } )`.

**Methods**: `press()` presses and releases the button from code.

**Events**: each press calls `onPress` then `onEvent`, each release `onRelease` then `onEvent`, and dispatches `button.EVENT` (`'button-event'`) to listeners. The event has `phase` (`button.PRESSED` or `button.RELEASED`), `target` (the button), `id`, `data` and `state`.

### Button Group

Keeps one button of a set active, like a row of tabs or options. Add radio or toggle buttons to it:

```lua
local group = dUI.newButtonGroup{ type='radio' }
group:addEventListener( group.EVENT, function( event )
	print( 'selected', event.id )
end )
for i, size in ipairs{ 'Small', 'Large' } do
	local bn = dUI.newRadioButton{ id=size, labelText=size }
	bn.x, bn.y = 60+i*100, 100
	group:add( bn )
end
```

- `type='radio'`: one button is always active, the first one added to start with; a press on another makes it the active one.
- `type='toggle'`: at most one is active, none to start with (`set_first_active=true` makes it the first); pressing the active one turns it off.

**Methods**: `add( button [, { set_active=true } ] )`, `remove( button )`, `getButton( id )`. **Properties**: `selected` (the active button, or `nil`).

**Events**: on each change the group dispatches `group.EVENT` (`'button_group_event'`) with `type` `group.CHANGED`, `button`, `id` and `state` (the pressed button's). The group doesn't draw anything or remove its buttons; remove them yourself, then the group with `removeSelf()`.

## NavBar and NavItem

A navigation bar: a title with a back button and optional left and right buttons. Each screen has a NavItem, which holds its title and buttons; the bar keeps a stack of them and slides between them.

```lua
local navBar = dUI.newNavBar()
navBar.x, navBar.y = 160, 20

navBar:pushNavItem( dUI.newNavItem{ titleText="Home" } )
navBar:pushNavItem( dUI.newNavItem{ titleText="Settings" } )
-- a "< Back" button appears; pressing it pops "Settings"
```

The bar is as wide as the content area (`dUI.WIDTH`) and 40 high unless its `width` and `height` say otherwise; they and its anchors can change later, and the item on show follows. Options: `delegate`, and `transitionTime`, how long a slide takes (400 ms).

**The stack.** `pushNavItem( item [, { animate=false } ] )` puts an item on top and slides it in; the first one is shown at once. `popNavItemAnimated()` slides back to the item below, then removes the popped item, along with its buttons. The first item stays: with one item on the stack, a pop does nothing. A push or a pop during a slide takes that slide to its end first, so several pushes in a row are fine.

**The Back button** pops the top item. Every item but the first shows one, unless it has a left button, which takes its place. A press during a slide is ignored. A delegate can step in:

```lua
navBar.delegate = {
	-- Back was released: return false to keep the item
	shouldPopItem=function( self, navBar, navItem ) return true end,
	-- the item has slid off, and is about to be removed
	didPopItem=function( self, navBar, navItem ) print( navItem.titleText ) end,
}
```

Both are optional. Each release of Back also dispatches `navBar.EVENT` with `type` `navBar.BACK_BUTTON`, popped or not.

**A NavItem** has the options `titleText`, `leftButton` and `rightButton` (buttons from `dUI.newButton()`); set the buttons before the item is pushed. `titleText` can change later. `item.title` is its Text widget and `item.backButton` its Back button, e.g. `item.backButton.labelText = "Home"`. An item draws nothing by itself: its parts are hidden until a bar shows them, 5 from the bar's edges and centered on its height.

**Styles.** The NavBar style has a `background` child, a rectangle unless its `type` says otherwise. The NavItem style has `title`, `backButton`, `leftButton` and `rightButton`; the item gives its left and right buttons these styles (blue text, no background) in place of their own.

Most apps use the [Navigation Control](controls.md) instead, which makes the NavBar and switches the screens with it.

## ScrollView

A surface larger than the widget, scrolled by touch in both directions, with bounce, and optionally zoom.

```lua
local sv = dUI.newScrollView{
	width=200, height=300,              -- the visible area
	scrollWidth=300, scrollHeight=800,  -- the content
	autoMask=true,                      -- clip the content to the visible area
}

-- the content goes into its scroller, at 0,0 for the top left
local photo = display.newImage( 'photo.jpg' )
photo.anchorX, photo.anchorY = 0, 0
sv.scroller:insert( photo )
```

Without `autoMask=true` the content shows outside the widget too, which is fine for one that fills the screen ([What All Widgets Share](#what-all-widgets-share)).

Options and properties: `width`, `height`, `scrollWidth`, `scrollHeight` (never smaller than the widget), `horizontalScrollEnabled`, `verticalScrollEnabled`, `bounceIsActive`, `upperHorizontalOffset`, `lowerHorizontalOffset`, `upperVerticalOffset`, `lowerVerticalOffset` (each moves the place where the content comes to rest at that edge). All can change later: the content comes back inside the new limits. Content no larger than the widget on an axis can still be pulled along it and bounces back; turn that axis off (`horizontalScrollEnabled=false`) for a list that only scrolls up and down.

Methods: `getContentPosition()` returns the content's x and y, 0 at the top left and negative as it scrolls; `setContentPosition{ x=, y= [, time=, onComplete=] }` scrolls there, in 500 ms unless `time` says otherwise (0 for at once); `takeFocus( event )` takes over a touch from a child.

**Scroll indicators**, thin bars at the right and bottom edges, show while the content moves and fade when it stops; each is as long as the share of the content in view, and is squeezed against its end during a bounce. An axis that is turned off or whose content fits has none. `showVerticalScrollIndicator=false` or `showHorizontalScrollIndicator=false` (options or properties) turns one off; `flashScrollIndicators()` shows them for a moment, to say that a view scrolls. Their color is the style's `indicatorColor` (translucent black by default; set a light one over dark content: `style={ indicatorColor={ 1, 1, 1, 0.6 } }`). The upper and lower offsets shorten an indicator's track, so it stays clear of a bar which covers part of the widget.

**Zoom** needs a delegate whose `getViewForZoom( self, event )` returns the object to scale (something in the scroller), and `minimumZoom` and `maximumZoom` (options or properties). Then a pinch zooms, and so does `setZoomScale( scale [, { time=, onComplete= } ] )`; `zoomScale` reads the scale (there is no `zoomScale` option: zoom once the content is in). The delegate's optional `willBeginZooming`, `didZoom` and `didEndZooming` get `self, event` with `event.view` and `event.scale`.

```lua
local sv = dUI.newScrollView{
	width=200, height=300, scrollWidth=1024, scrollHeight=680,
	minimumZoom=0.2, maximumZoom=1,
	delegate={ getViewForZoom=function( self, event ) return photo end },
}
sv.scroller:insert( photo )
sv:setZoomScale( 0.5 )
```

**Scrolling** is reported to the delegate, by touch or from code. Each method is optional and gets `self, event`:

| Delegate method | |
|---|---|
| `willBeginScrolling` | the content starts to move |
| `didScroll` | it moved: once per axis that moved, each frame |
| `didEndScrolling` | it came to rest on both axes |

`event.x` and `event.y` are the content's position, as `getContentPosition()` returns it. `event.verticalLimit` is `sv.HIT_TOP_LIMIT` or `sv.HIT_BOTTOM_LIMIT` while the content is at or past that edge (past it in a bounce), `event.horizontalLimit` is `sv.HIT_LEFT_LIMIT` or `sv.HIT_RIGHT_LIMIT`; each is `nil` in between, and on an axis that is off or whose content fits. `event.target` is the scroll view.

```lua
delegate={
	didEndScrolling=function( self, event )
		if event.verticalLimit==event.target.HIT_BOTTOM_LIMIT then
			-- at the end: load more
		end
	end,
}
```

A ScrollView sends no events: it reports through its delegate.

See `examples/scrollview-widget/` for content, locking, zoom and the indicator color.

## TableView and TableViewCell

A scrolling list that creates the display objects of a row only while the row is visible. A delegate supplies the rows:

```lua
local list = dUI.newTableView{
	width=300, height=400,
	estimatedRowHeight=40,
	delegate={
		numberOfRows=function( self, tableview, section ) return 50 end,
		onRowRender=function( self, event )
			-- event.view is the row's group, event.index its number
			local t = display.newText( "row " .. event.index, 10, 5, native.systemFont, 16 )
			t.anchorX, t.anchorY = 0, 0
			t:setFillColor( 0 )
			event.view:insert( t )
		end,
		onRowUnrender=function( self, event )
			-- remove what onRowRender made
		end,
	},
}
list:reloadData()
```

`numberOfRows` and `onRowRender` are required; `onRowUnrender` is optional, for what a row made outside its view, or wants to keep (a row's view is removed with everything in it). Both row events carry `view`, `index`, `row` and `data`, a table that stays with the row. A row is as wide as the table view and `estimatedRowHeight` high (20 unless given; every row has that height); `event.row:setBackgroundColor( r, g, b, a )` and `event.row:setLineColor( ... )` color it and the line at its bottom (white, and no line, by default). Rows exist for the part of the list in view plus `renderMargin` (100) above and below.

The list belongs to the app: change it, then tell the table view.

| Method | |
|---|---|
| `reloadData()` | ask the delegate again for the number of rows, and make the rows in view again |
| `insertRowAt( index )` | a row was added at `index` (1 to the number of rows plus 1, which adds it at the end) |
| `removeRowAt( index )` | the row at `index` was removed |
| `removeAllRows()` | no rows are left |
| `getRowAt( index )` | the row's view, or `nil` while the row is out of view |
| `scrollToRowAt( index [, { position=, time=, onComplete= } ] )` | scroll until the row is at the `'top'`, `'middle'` (the default) or `'bottom'` of the view, as far as the list can scroll: the first row stays at the top. At once unless `time` (ms) is given |
| `getContentPosition()` | the list's y: 0 at the top, negative as it scrolls |
| `setContentPosition{ y= [, time=, onComplete=] }` | scroll there, as in a ScrollView |

A TableView is a ScrollView which scrolls up and down only: its options and properties apply (`autoMask`, `bounceIsActive`, `upperVerticalOffset`, `lowerVerticalOffset`, `showVerticalScrollIndicator`, a new `width` or `height` later), and `scrollEnabled` turns its scrolling on and off. Its style adds a `fillColor`, which shows where the rows don't cover the view (transparent by default).

**Touching a row** highlights it, and a tap selects it. The delegate's optional methods follow that, each with `self, event` (`event.index`, `event.view`, `event.data`):

| Delegate method | |
|---|---|
| `shouldHighlightRow` | return `false` to leave the row as it is |
| `didHighlightRow`, `didUnhighlightRow` | the row was highlighted, and no longer is (the touch ended, or became a scroll) |
| `willSelectRow` | return the index of the row to select: `event.index`, another row's, or `nil` for none |
| `didSelectRow` | the row was selected |

The delegate also gets the ScrollView's `willBeginScrolling`, `didScroll` and `didEndScrolling` ([ScrollView](#scrollview)); in `didScroll` the rows for the new position already exist. A TableView sends no events: it reports through its delegate.

### TableViewCell

`newTableViewCell()` is a ready-made row: a label, a detail line below it, an image on the left and an accessory on the right. Make it in `onRowRender`, and put it in the row's view as `cell`: the table view then highlights it when the row is touched (the cell style's `active` state).

```lua
onRowRender=function( self, event )
	local cell = dUI.newTableViewCell{
		width=300, height=40,
		labelText="Row " .. event.index,
		detailText="the line below",
	}
	cell.imageView = display.newImageRect( 'flag.png', 26, 26 )
	event.view:insert( cell.view )
	event.view.cell = cell
end,
onRowUnrender=function( self, event )
	event.view.cell:removeSelf()
end,
```

Options: `width`, `height`, `labelText`, `detailText`, `style`. Properties: `width`, `height`, `textLabel` and `textDetail` (the two [Text](#text) widgets: `cell.textLabel.text = "..."`), `imageView` (a display object of your size, which the cell places), `highlight`, and from its style:

| Property | Values |
|---|---|
| `accessory` | `cell.DISCLOSURE_INDICATOR` (the default), `cell.CHECKMARK`, `cell.DETAIL_BUTTON`, `cell.NONE` |
| `cellLayout` | `cell.SUBTITLE` (the default: label and detail line), `cell.DEFAULT` (the label only) |
| `cellMargin` | the space at the left and right edges (5) |
| `contentMargin` | the space between the image, the text and the accessory (5) |

The default style is laid out for a row of 30: for a taller one, give the states' `labelY` and `detailY` (the middle of each line, from the top) and font sizes in a style from `newTableViewCellStyle()`, shared by all the cells:

```lua
local cellStyle = dUI.newTableViewCellStyle{
	inactive={ labelY=14, detailY=31, label={ fontSize=15 }, detail={ fontSize=11 } },
	active={ labelY=14, detailY=31, label={ fontSize=15 }, detail={ fontSize=11 } },
}
```

A long list makes and removes many cells as it scrolls; `examples/tableview-widget/tableview-tableviewcell` keeps the cells of the rows that leave the screen and gives them to the rows that appear.

See `examples/tableview-widget/` for a simple list, inserting and removing rows, scrolling to a row, and cells.
