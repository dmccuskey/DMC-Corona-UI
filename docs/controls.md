# Controls

A control coordinates several widgets and your own views; elsewhere it would be called a controller. DMC Corona UI has the Navigation Control, which can also be [shown as a page over your app](#presenting-a-control).

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

## Presenting a Control

A control can be shown over the rest of your app, as a page which comes and goes: a settings screen, a form, a detail view. Give the control a `modalStyle` of `dUI.MODAL`, then ask it to present itself. The app behind it is dimmed and gets no touches until the page is dismissed.

```lua
local dUI = require 'lib.dmc_ui'

local page = dUI.newNavigationControl{ modalStyle=dUI.MODAL }

local view = display.newRect( 0, 0, 100, 100 )  -- the control sizes it
view:setFillColor( 0.3, 0.4, 0.5 )

-- the page brings its own way out: a Close button in its bar
page:pushView{
	view=view,
	navItem=dUI.newNavItem{
		titleText="Settings",
		rightButton=dUI.newButton{
			labelText="Close",
			onRelease=function() page:dismissControl() end,
		},
	},
}

page:presentControl()
```

The page slides up from the bottom of the screen and covers it below the status bar; `Close` slides it back down. A control with a `modalStyle` isn't part of your layout any more: it is hidden until presented, and its position and size are set for it.

A dismissed control is hidden, not removed: present it again whenever it is needed, or remove it (`page:removeSelf()`), which removes its presentation too.

### Size

Without a size the page is the screen below the status bar, whatever the device and `config.lua`. With a `preferredContentSize` it is a panel of that size in the middle of the dimmed app, no larger than the screen:

```lua
local panel = dUI.newNavigationControl{
	modalStyle=dUI.MODAL,
	preferredContentSize={ width=260, height=300 },
}
```

The control has its presented size from then on (`panel.width`, `panel.height`), so a view which lays out its own content can do so before the control is shown. The panel clips what it holds. A change of `preferredContentSize` while the control shows moves and resizes it at once.

### Transitions

| `transition` | |
|---|---|
| `dUI.SLIDE_UP` | the control slides up from the bottom of the screen while the app dims (300 ms). The default. |
| `dUI.FADE` | the control fades in at its place (100 ms) |
| `dUI.NO_TRANSITION` | the control is there at once |

```lua
panel:presentControl{ transition=dUI.FADE }
```

A dismissal uses the transition of its presentation unless it names another. `time` sets the length in milliseconds, and `animated=false` skips the transition for that one call, e.g. to start the app with the page already up.

A call which changes nothing is harmless: presenting a control which is up, or dismissing one which isn't, only calls its `onComplete`. A dismissal while the control is still on its way in (or the other way around) turns the motion around from where it is; the `onComplete` of the call which was cut short isn't called.

### Methods and Properties

On the control:

| | |
|---|---|
| `modalStyle` | `dUI.MODAL`, `dUI.POPOVER` ([below](#popover-control)) or `nil`; a constructor option too. Setting it to `nil` puts the control back where it was: its parent, position and size. |
| `preferredContentSize` | a table `{ width=, height= }`, or `nil` for the whole screen; a constructor option too |
| `presentControl( [ { transition=, time=, animated=, onComplete= } ] )` | show the control. `onComplete` is called when it is in place. Without a `modalStyle` it raises an error. |
| `dismissControl( [ { transition=, time=, animated=, onComplete= } ] )` | take the control off the screen |
| `isPresented` (read only) | `true` from `presentControl()` until `dismissControl()` |
| `presentationControl` (read only) | the Presentation Control which shows this control; `nil` without a `modalStyle` |

The Presentation Control is the object behind the page: the dimming layer and the panel. The control makes it when it gets its `modalStyle`. It has the settings of the presentation itself:

| | |
|---|---|
| `dismissOnTapOutside` | `true`: a tap outside the panel dismisses the control. `false` unless set. |
| `dimColor` | the color over the app, `{ r, g, b, a }`; `{ 0, 0, 0, 0.4 }` unless set |
| `panelColor` | the color of the panel behind the control's views, `{ r, g, b, a }`; white unless set |
| `delegate` | an object which is told about each step (below) |
| `state` (read only) | `DISMISSED`, `PRESENTING`, `PRESENTED` or `DISMISSING` (constants of the Presentation Control) |

```lua
local presentation = panel.presentationControl
presentation.dismissOnTapOutside = true
presentation.dimColor = { 0, 0, 0, 0.6 }
```

A delegate is a table or object with any of these functions, each called with the delegate and the Presentation Control:

| Function | When |
|---|---|
| `presentationWillBegin( self, presentation )` | the control is about to come in |
| `presentationEnded( self, presentation )` | the control is in place |
| `shouldDismiss( self, presentation )` | a tap outside the panel, with `dismissOnTapOutside`: return `false` to keep the control up |
| `dismissalWillBegin( self, presentation )` | the control is about to go |
| `dismissalEnded( self, presentation )` | the control is off the screen |

A touch or a tap anywhere on the screen stays with the presentation: the control's widgets get theirs, and nothing reaches the app behind it.

The page isn't moved out of the way of the keyboard, and native objects on it (a text field while it is edited) aren't clipped by the panel.

See `examples/modal-control/modal-simple` ([screenshot](../examples/README.md#modal-control)): a page and a panel, each with a Close button.

## Popover Control

A popover is a panel which belongs to a button: it opens next to it, and a tap anywhere else closes it. It is a presentation like the page above, with `modalStyle = dUI.POPOVER`: the same methods, the same delegate, a fade for its transition, `dismissOnTapOutside` on, and a `preferredContentSize` of 320x600 unless set. The control's `popoverControl` is its Presentation Control, with one more property, `buttonItem`: the display object the popover belongs to.

```lua
navCtrl.modalStyle = dUI.POPOVER
navCtrl.popoverControl.buttonItem = button
navCtrl:presentControl()
```

It is being finished: today the panel is placed below its button and kept on the screen, without the arrow which points at the button ([Known Issues](api.md#known-issues)).
