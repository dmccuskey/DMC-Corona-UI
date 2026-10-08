# Controls

A control coordinates several widgets and your own views; elsewhere it would be called a controller. DMC Corona UI has one, the Navigation Control.

## Navigation Control

A Navigation Control switches between the screens of your app, which it calls views, and makes its own [NavBar](widgets.md#navbar-and-navitem) to go with them. Its views form a stack: pushing a view slides it in from the right and shows its title in the bar, with a `< Back` button; the Back button slides it out again, back to the view below. Usually you only push: the Back button does the popping.

```lua
local dUI = require 'lib.dmc_ui'

local W, H = display.contentWidth, display.contentHeight
local STATUS_BAR_H = display.topStatusBarContentHeight

-- the control: the screen below the status bar, placed by its top center
local navCtrl = dUI.newNavigationControl{ width=W, height=H-STATUS_BAR_H }
navCtrl.x, navCtrl.y = W/2, STATUS_BAR_H

local function newView( title, r, g, b )
	local view = display.newRect( 0, 0, 100, 100 )  -- the control sizes it
	view:setFillColor( r, g, b )
	view.title = title
	return view
end

navCtrl:pushView( newView( "View 1", 0.3, 0.4, 0.5 ) )

timer.performWithDelay( 1000, function()
	navCtrl:pushView( newView( "View 2", 0.7, 0.5, 0.3 ) )
end )
```

The first view appears at once, without the slide, and has no Back button: it is never popped. A second later View 2 slides in, and the bar shows its title and `< Back`.

The control is positioned by its top center, and is as large as the content area unless `width` and `height` say otherwise. With a `letterbox` `config.lua` the screen is larger than the content area: the [examples](../examples/README.md#navigation-control) size the control from `display.actualContentWidth`, `actualContentHeight` and `screenOriginY`.

### Views

A view can be a display object, a [dmc-objects](https://github.com/dmccuskey/dmc-objects) component, or a plain table whose `view` property is a display group. The control shows it below the bar, anchored top center (`anchorX = 0.5`, `anchorY = 0`), so 0,0 in a view's group is the middle of its top edge. A display object or a component is given the size of the room below the bar (`width`, `height`), again whenever the control's size changes. A display group has no size of its own (setting one would scale what it holds), so a table view lays out its own content: the room is `navCtrl.width` by `navCtrl.height - navCtrl.navBar.height`.

| Property | Meaning |
|---|---|
| `title` | yours to set: the text in the bar while the view is on top. Without it, the bar says `Unknown`. |
| `navItem` | yours to set, optionally: a [NavItem](widgets.md#navbar-and-navitem) for the bar, to add left or right buttons. Without it, one is made from `title`. The bar removes a view's item when the view is popped, and the control clears the property: a view which is pushed again gets a new item from its `title`, unless you set one first. |
| `parent` | set by the control on a table view: the Navigation Control itself, so the view can push the next one (`view.parent:pushView( nextView )`). A display object's `parent` stays its display group. |

A table view can also have these functions, each optional, which the control calls with the view:

| Function | When |
|---|---|
| `willBeAdded( view )` | the view has been pushed, and is about to go into the control |
| `viewInMotion( view, isMoving )` | a slide starts (`true`) or ends (`false`) |
| `viewDidAppear( view )` | the view is on top, after its slide |
| `viewDidDisappear( view )` | the view has been covered or popped |
| `willBeRemoved( view )` | the view has been popped: remove its display objects here |

The stack has already changed when `viewDidAppear` and `viewDidDisappear` run, so they can push or pop.

A popped view is hidden, not removed: remove it in `willBeRemoved`, or when the control's `REMOVED_VIEW` event says so:

```lua
navCtrl:addEventListener( navCtrl.EVENT, function( event )
	if event.type == navCtrl.REMOVED_VIEW then
		event.view:removeSelf()
	end
end )
```

Removing the control (`navCtrl:removeSelf()`) pops every view, top first, with `willBeRemoved` and the event for each, then removes its bar and whatever display objects the views left in it.

### Methods and Options

| | |
|---|---|
| `pushView( view [, { animate=false, wait=false } ] )` | put a view on top of the stack. A view which is already on the stack, or on its way there, raises an error. |
| `popViewAnimated( [ { wait=false } ] )` | go back one view, like the Back button. Returns `true`, or `false` when the first view is on top (or will be, once the calls which wait are done): the first view stays. |
| `isViewInMotion` (read only) | `true` while a push or pop is under way: from the call until its slide, and each call which waits in line, has ended |
| `navBar` (read only) | the control's [NavBar](widgets.md#navbar-and-navitem), e.g. for its `height` or its style |
| `transitionTime` (constructor option) | the length of a slide, in milliseconds (400 unless given) |
| `x`, `y`, `width`, `height` | position and size; `width` and `height` are options too. Setting them resizes the bar and the views. |

A push or pop while a slide is running waits for the slide to end, then does its own. Several wait in line and are done in the order of the calls, each with its own slide, so no call is lost. A view is hidden from the moment it is pushed, also while it waits:

```lua
navCtrl:pushView( home )      -- the first view, at once
navCtrl:pushView( albums )    -- slides in
navCtrl:pushView( photo )     -- slides in when albums has arrived
```

With `wait=false` a call doesn't wait: the running slide, and each call in line behind it, is put at its end at once, as if its time were up, then the call's own slide starts. With `animate=false` as well nothing slides, for example to restore where the user was:

```lua
navCtrl:pushView( home )
navCtrl:pushView( albums, { animate=false, wait=false } )
navCtrl:pushView( photo, { animate=false, wait=false } )
```

The Back button is ignored during a slide. Your own buttons aren't: one tapped twice quickly pushes two views, one after the other. Where that matters, ask the control first:

```lua
local function onRelease( event )
	if navCtrl.isViewInMotion then return end
	navCtrl:pushView( nextView )
end
```

A touch or a tap on the control stays with it: the bar and its buttons keep theirs, a view gets those on its own objects, and what the view doesn't take doesn't reach whatever lies behind the control.

See `examples/navigation-control/` ([screenshots](../examples/README.md#navigation-control)): `navigation-control-simple` pushes colored rectangles, `navigation-intermediate` browses galleries of images, with each view a table that pushes the next.

## Popover Control

A control that shows a view in a popover, as iOS does, was in development: `examples/popover-control/popover-control-simple` sets `navCtrl.modalStyle = dUI.POPOVER`, but the module doesn't export a constructor ([Known Issues](api.md#known-issues)).
