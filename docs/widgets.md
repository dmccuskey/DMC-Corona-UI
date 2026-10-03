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

`height` sets the widget's height; the text inside keeps the height of its font.

**Widget properties**: `text`. Helpers for the style: `align`, `font`, `fontSize`, `marginX`, `textColor`, `fillColor`, `strokeWidth`, and the methods `setTextColor( r, g, b [, a] )`, `setFillColor()`, `setStrokeColor()`. `getTextHeight()` returns the height of the text.

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
| `background` | child style: a Background style |
| `hint`, `display` | child styles: Text styles for the hint and for the text |

**Widget properties**: `text`, `hintText`, `inputType`, `isSecure`, `isEditing` (read only), `delegate` (below). Child styles: `backgroundStyle`, `hintStyle`, `displayStyle`. Helpers: `align`, `marginX`, `marginY`, `hintFont`, `hintFontSize`, `displayFont`, `displayFontSize` (set only), `setHintTextColor()`, `setDisplayTextColor()`.

**Methods**: `setKeyboardFocus()` starts editing and shows the keyboard, `unsetKeyboardFocus()` ends it; `setEditActive( true | false )` shows or hides the native field; `setReturnKey( key )`.

**Events**: `TextField.EVENT` (`'userInput'`), with Solar2D's `userInput` fields (`phase`: `'began'`, `'editing'`, `'ended'`, `'submitted'`; `text`, ...) and `target`, the widget. `widget.text` is up to date in every phase.

**Delegate**: an object with any of these methods can accept or refuse edits; each is called on the delegate (`delegate:shouldBeginEditing( textfield )`) and returns `true` or `false`: `shouldBeginEditing( textfield )`, `shouldEndEditing( textfield )`, `shouldClearTextField( textfield )`, and `shouldChangeCharacters( event )` (`event.target` is the text field; `startPosition`, `newCharacters`, `numDeleted` and `text` as in Solar2D's `userInput`). Set it with the `delegate` option or property.

**Keyboard**: `dUI.adjustForKeyboard()` slides a display group up so that the field being edited stays above the keyboard, and back when it closes ([Keyboard](api.md#keyboard)).

## Button

A button with a label and a background for each of its states: `inactive`, `active` (while pressed) and `disabled`.

- `newPushButton()` (or `newButton()`): active while pressed.
- `newToggleButton()`: each press switches it between active and inactive.
- `newRadioButton()`: a press makes it active; it stays active. Radio groups don't work yet ([Known Issues](api.md#known-issues)).

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
| `inactive`, `active`, `disabled` | child styles, one for each state: `label` (a Text style), `background` (a Background style), `align`, `marginX`, `marginY`, `offsetX`, `offsetY` (moves the label) |
| `align`, `marginX`, `marginY` | the label's alignment and margins |
| `hitMarginX`, `hitMarginY` | extra touch area around the button |
| `isHitActive` | `false` ignores touches |

**Widget properties**: `labelText`, `id`, `data`, `isEnabled` (`false` shows `disabled` and ignores touches), `isActive` (read only), `hitMarginX`, `hitMarginY`, `isHitActive`, `onPress`, `onRelease`, `onEvent` (set only); the state styles `inactiveStyle`, `activeStyle`, `disabledStyle` (read only). `setHitMargin( x, y )` or `setHitMargin( { x, y } )`.

**Methods**: `press()` presses and releases the button from code.

**Events**: each press calls `onPress` then `onEvent`, each release `onRelease` then `onEvent`, and dispatches `button.EVENT` (`'button-event'`) to listeners. The event has `phase` (`button.PRESSED` or `button.RELEASED`), `target` (the button), `id`, `data` and `state`.

## NavBar and NavItem

A navigation bar: a title with a back button and optional left and right buttons. Each screen has a NavItem, which holds its title and buttons; the bar keeps a stack of them and slides between them.

```lua
local navBar = dUI.newNavBar()
navBar.x, navBar.y = 160, 20

navBar:pushNavItem( dUI.newNavItem{ titleText="Home" } )
navBar:pushNavItem( dUI.newNavItem{ titleText="Settings" } )
-- a "< Back" button appears; pressing it pops "Settings"
```

`pushNavItem( item [, { animate=true|false } ] )`, `popNavItemAnimated()`. A NavItem's options: `titleText`, `leftButton`, `rightButton` (buttons). The NavBar style has a `background` child, the NavItem style `title`, `backButton`, `leftButton` and `rightButton`.

Most apps use the [Navigation Control](controls.md) instead, which makes the NavBar and switches the screens with it.

## ScrollView

A surface larger than the widget, scrolled by touch in both directions, with bounce, and optionally zoom.

```lua
local sv = dUI.newScrollView{
	width=200, height=300,              -- the visible area
	scrollWidth=300, scrollHeight=800,  -- the content
}
```

Options and properties: `width`, `height`, `scrollWidth`, `scrollHeight`, `horizontalScrollEnabled`, `verticalScrollEnabled`, `bounceIsActive`, `upperHorizontalOffset`, `lowerHorizontalOffset`, `upperVerticalOffset`, `lowerVerticalOffset`, `zoomScale`. Methods: `getContentPosition()`, `setContentPosition{ x=, y= [, time=, onComplete=] }`, `setZoomScale()`, `takeFocus( event )` (take over a touch from a child).

See `examples/scrollview-widget/` for content, locking and zoom.

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

Optional delegate methods: `shouldHighlightRow`, `didHighlightRow`, `didUnhighlightRow`, `willSelectRow`, `didSelectRow` (each gets `self, event`). Methods: `reloadData()`, `insertRowAt()`, `removeRowAt()`, `removeAllRows()`, `getRowAt()`, `scrollToRowAt()`, `getContentPosition()`, `setContentPosition()`. A TableView is a ScrollView, with its options.

`newTableViewCell()` is a ready-made row, made in `onRowRender`: a label (`labelText`), a detail line (`detailText`), an image and an accessory (checkmark, disclosure indicator or detail button), styled with `newTableViewCellStyle()` (children `inactive` and `active`).

See `examples/tableview-widget/` for simple lists, inserting and removing rows, scrolling to a row, and cells.
