# API Reference

Everything the `dmc_ui` module provides. Each widget's own options, properties and methods are in [Widgets](widgets.md), the Navigation Control's in [Controls](controls.md), how styles work in [Using Styles](styles.md).

## The Module

```lua
local dUI = require 'lib.dmc_ui'
```

The path follows where `dmc_ui.lua` is: `lib.dmc_ui` for the layout in the [Quick Start](../README.md#1-copy-the-library-into-your-project). The module sets itself up when it is first required, and loads each widget's code the first time one is made.

## Widgets

| Function | Makes |
|---|---|
| `dUI.newBackground( [options] )` | a [Background](widgets.md#background) of the style's `type` |
| `dUI.newRectangleBackground()`, `newRoundedBackground()`, `new9SliceBackground()`, `newImageBackground()` | a Background of that type |
| `dUI.newText( [options] )` | a [Text](widgets.md#text) |
| `dUI.newTextField( [options] )` | a [TextField](widgets.md#textfield) |
| `dUI.newButton( [options] )`, `newPushButton()` | a push [Button](widgets.md#button) |
| `dUI.newToggleButton()`, `newRadioButton()` | a toggle or radio button |
| `dUI.newButtonGroup{ type=... }` | a [Button Group](widgets.md#button-group) (`'radio'` or `'toggle'`) |
| `dUI.newNavBar( [options] )`, `newNavItem()` | a [NavBar](widgets.md#navbar-and-navitem) and its items |
| `dUI.newScrollView( [options] )` | a [ScrollView](widgets.md#scrollview) |
| `dUI.newSlideView( [options] )` | a [SlideView](widgets.md#slideview) |
| `dUI.newPageIndicator( [options] )` | a [PageIndicator](widgets.md#pageindicator), the dots for a set of pages |
| `dUI.newTableView( [options] )`, `newTableViewCell()` | a [TableView](widgets.md#tableview-and-tableviewcell) and its rows |
| `dUI.newNavigationControl( [options] )` | a [Navigation Control](controls.md#navigation-control); with `modalStyle=dUI.MODAL`, [a page over the app](controls.md#presenting-a-control); with `dUI.POPOVER`, [a popover](controls.md#popover-control) |

`options` is a table: the widget's own options, plus `x`, `y`, `id`, `style` and `autoMask` ([What All Widgets Share](widgets.md#what-all-widgets-share)).

## Styles

| Function | Makes |
|---|---|
| `dUI.newBackgroundStyle( [properties] )` | a Background style; `newRectangleBackgroundStyle()`, `newRoundedBackgroundStyle()`, `newNineSliceBackgroundStyle()`, `newImageBackgroundStyle()` for one type |
| `dUI.newTextStyle()`, `newTextFieldStyle()`, `newButtonStyle()` | a style for that widget |
| `dUI.newNavBarStyle()`, `newNavItemStyle()`, `newTableViewCellStyle()` | a style for that widget |
| `dUI.newScrollViewStyle()`, `newTableViewStyle()`, `newPageIndicatorStyle()` | a style for that widget |

`properties` is a table of the style's properties and child styles, plus `name` to register it as a named style and `inherit` (a style, or a style's name) to inherit from ([Inheritance](styles.md#inheritance)).

| Function | Does |
|---|---|
| `dUI.getStyle( type, name )` | returns the named style of that type (`'Text'`, `'Button'`, ...), from the active theme first; `nil` if there is none |
| `dUI.removeStyle( type, name )` | unregisters a named style |
| `dUI.addStyle( style )` | registers a style under its `name` (a style with a `name` is registered when it is made) |
| `dUI.purgeStyles()` | unregisters every named style outside themes |

## Palette

`dUI.Palette` is a table of colors for an app's styles: `red`, `orange`, `yellow`, `green`, `teal`, `blue`, `purple`, `slate`, `gray` and `cloud`, each `{ r, g, b }`, and each with a darker partner (`redDark`, ...). See [Palette](styles.md#palette).

## Themes

| Function | Does |
|---|---|
| `dUI.loadTheme( path )` | loads a theme file, such as `'theme/blue-theme.lua'`, relative to the project folder |
| `dUI.loadThemes( folder )` | loads every `.lua` file in a folder of the project |
| `dUI.createTheme( id [, { name=... } ] )` | makes a theme, or returns the one with that id; its `addStyle( name, style )` adds a named style to it |
| `dUI.activateTheme( id )` | makes a theme the active one; widgets using a style by name redraw |
| `dUI.getActiveThemeId()`, `getActiveThemeName()` | the active theme's id or name, or `nil` |
| `dUI.getAvailableThemeIds()` | a list of the loaded themes' ids |

A theme file is a module that returns `{ initialize=function( Style ) ... end }`; see [Themes](styles.md#themes).

## Keyboard

| | |
|---|---|
| `dUI:addEventListener( dUI.EVENT, f )` | keyboard events: `event.type` is `dUI.KEYBOARD_SHOWING` when a text field takes the focus (not when the focus moves to another field while the keyboard is up), `dUI.KEYBOARD_HIDING` when editing ends, then `'hidden'` |
| `dUI.adjustForKeyboard( group [, { proxy=, offset= } ] )` | the first call slides a display group up so that `proxy` (a text field in it; default the group itself) is above the keyboard, `offset` more; the next call slides it back, and a call while it slides back slides it up again |
| `dUI.cancelAdjustForKeyboard( group )` | stops a slide and forgets it, without moving the group back |
| `dUI.getKeyboardStatus()` | `'shown'`, `'hiding'` or `'hidden'` |

The keyboard's height isn't known to Solar2D, so `adjustForKeyboard()` assumes one: the bottom quarter of the screen in portrait, a little under half of it in landscape.

```lua
dUI:addEventListener( dUI.EVENT, function( event )
	if event.type == dUI.KEYBOARD_SHOWING then
		dUI.adjustForKeyboard( screen, { proxy=field, offset=-10 } )
	elseif event.type == dUI.KEYBOARD_HIDING then
		dUI.adjustForKeyboard( screen )
	end
end )
```

From `examples/textfield-widget/textfield-keyboard`.

## Constants

| Name | Value |
|---|---|
| `dUI.WIDTH`, `dUI.HEIGHT` | `display.contentWidth`, `display.contentHeight` when the module was loaded |
| `dUI.RECTANGLE`, `dUI.ROUNDED`, `dUI.NINE_SLICE`, `dUI.IMAGE` | `'rectangle'`, `'rounded'`, `'9-slice'`, `'image'`: Background types |
| `dUI.EVENT` | `'dmc-ui-event'`, the name of the module's events |
| `dUI.MODAL`, `dUI.POPOVER` | a control's `modalStyle`: [a page over the app](controls.md#presenting-a-control), or a [popover](controls.md#popover-control) |
| `dUI.SLIDE_UP`, `dUI.FADE`, `dUI.NO_TRANSITION` | the [transitions](controls.md#transitions) of a presented control |
| `dUI.ARROW_UP`, `dUI.ARROW_DOWN`, `dUI.ARROW_LEFT`, `dUI.ARROW_RIGHT`, `dUI.ARROW_ANY` | the [directions](controls.md#placement) a popover's arrow may point in |

`dUI.setOS( platform [, version] )` picks the look for `'iOS'` or `'android'`; the module calls it at load for the device it runs on (iOS in the Simulator).

## Configuration

DMC Corona UI has no settings of its own: there is no `[DMC_UI]` section in `dmc_corona.cfg`. The file must still be there, with the `[DMC_CORONA]` section, so that the libraries in `lib/dmc_corona/` can be found; its format is described in [dmc-corona-boot's Configuration](https://github.com/dmccuskey/dmc-corona-boot/blob/master/docs/configuration.md).

The `dmc_corona.cfg` in this repository has further sections, `[DMC_KOLOR]`, `[DMC_OBJECTS]` and `[DMC_STATES]`, for libraries DMC Corona UI uses; they can be left out. `[DMC_KOLOR]` sets how [dmc-kolor](https://github.com/dmccuskey/dmc-kolor) reads colors, including the colors in styles.

## Known Issues

Checked in the Solar2D Simulator (2026.3731) in September 2026.

- **Some functions fail or are missing.** `dUI.newFormatter()` raises an error.
- **A button's label keeps its alignment and margins** when `align`, `marginX` or `marginY` change on the button style or a state style after the button is made: they reach the state, not its `label`. Change them on the label itself (`button.inactiveStyle.label.align = 'left'`). `offsetX` and `offsetY` do follow.
- **A TableView's rows all have one height** (`estimatedRowHeight`): the common case, and cheap to compute. Rows of different heights (section headers, separate row types) are planned.
- **A TableViewCell's two lines of text sit where its style says** (`labelY`, `detailY`), whatever its height.
- **A NavItem's title isn't shortened** to fit between its buttons: a long one runs under them. And a left or right button given to an item which is already on a bar isn't shown: set an item's buttons before it is pushed.
- The Navigation Control anchors each view top center, doesn't size a view which is a display group, and hides popped views instead of removing them ([Views](controls.md#views)).
