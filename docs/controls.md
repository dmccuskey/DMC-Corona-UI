# Controls

A control coordinates several widgets and your own views; elsewhere it would be called a controller. DMC Corona UI has one, the Navigation Control.

## Navigation Control

A Navigation Control switches between the screens of your app, which it calls views, and makes its own [NavBar](widgets.md#navbar-and-navitem) to go with them. Its views form a stack: pushing a view slides it in from the right and shows its title in the bar, with a `< Back` button; the Back button slides it out again, back to the view below. Usually you only push: the Back button does the popping.

```lua
local dUI = require 'lib.dmc_ui'

local W, H = display.contentWidth, display.contentHeight

-- the control, top center, below the status bar
local navCtrl = dUI.newNavigationControl()
navCtrl.x, navCtrl.y = W/2, display.topStatusBarContentHeight

local function newView( title, r, g, b )
	local view = display.newRect( 0, 0, W, H )
	view:setFillColor( r, g, b )
	view.anchorX, view.anchorY = 0.5, 0
	view.title = title
	return view
end

navCtrl:pushView( newView( "View 1", 0.3, 0.4, 0.5 ) )

timer.performWithDelay( 1000, function()
	navCtrl:pushView( newView( "View 2", 0.7, 0.5, 0.3 ) )
end )
```

The first view appears at once, without the slide. A second later View 2 slides in, and the bar shows its title and `< Back`.

### Views

A view can be a display object or group, a [dmc-objects](https://github.com/dmccuskey/dmc-objects) component, or a plain table whose `view` property is a display group. The control shows it below the bar, anchored top center (`anchorX = 0.5`, `anchorY = 0`), and gives it these properties:

| Property | Meaning |
|---|---|
| `title` | yours to set: the text in the bar while the view is on top. Without it, the bar says `Unknown`. |
| `navItem` | yours to set, optionally: a [NavItem](widgets.md#navbar-and-navitem) for the bar, to add left or right buttons. Without it, one is made from `title`. |
| `parent` | set by the control on a table view: the Navigation Control itself, so the view can push the next one (`view.parent:pushView( nextView )`). A display object's `parent` stays its display group. |

A table view can also have these functions, which the control calls with the view:

| Function | When |
|---|---|
| `viewInMotion( view, isMoving )` | a slide starts (`true`) or ends (`false`) |
| `viewDidAppear( view )` | the view is on top, after its slide |
| `viewDidDisappear( view )` | the view has been covered or popped |
| `willBeRemoved( view )` | the view has been popped: remove its display objects here |

A popped view is hidden, not removed: remove it in `willBeRemoved`, or when the control's `navCtrl.REMOVED_VIEW` event says so (`navCtrl:addEventListener( navCtrl.REMOVED_VIEW, f )`, with `event.view`).

### Methods and Options

| | |
|---|---|
| `pushView( view [, { animate=false } ] )` | put a view on top of the stack |
| `popViewAnimated()` | go back one view, like the Back button |
| `transitionTime` (constructor option) | the length of a slide, in milliseconds |
| `x`, `y`, `width`, `height` | position and size; setting `width` or `height` resizes the bar and every view to match |

Pushing or popping while a slide is still running raises `Animation already in progress`.

See `examples/navigation-control/`: `navigation-control-simple` pushes three colored rectangles, `navigation-intermediate` browses galleries of images, with each view a table that pushes the next.

## Popover Control

A control that shows a view in a popover, as iOS does, was in development: `examples/popover-control/popover-control-simple` sets `navCtrl.modalStyle = dUI.POPOVER`, but the module doesn't export a constructor ([Known Issues](api.md#known-issues)).
