# Development

How DMC Corona UI is built and tested, and what could change.

## Where the Code Lives

The library's own code is `lib/dmc_ui.lua` and `lib/dmc_ui/`, along with the example apps' own files (`main.lua`, `config.lua`, `view/`, `theme/`, assets) and the tests in `tests/`. The rest is generated: copied from the repositories that own it by the build below. Fix a generated file in its own repository, then rebuild:

| file | owner |
|---|---|
| `lib/dmc_corona/` | [DMC-Corona-Library](https://github.com/dmccuskey/DMC-Corona-Library), the bundle of every DMC Corona library; DMC Corona UI uses [dmc-objects](https://github.com/dmccuskey/dmc-objects), [dmc-kolor](https://github.com/dmccuskey/dmc-kolor), dmc-utils, dmc-events-mixin, dmc-states-mixin, dmc-lifecycle-mixin, dmc-patch, dmc-path, dmc-touchmanager and dmc-gestures from it |
| `lib/dmc_corona/lib/dmc_lua/` | [DMC-Lua-Library](https://github.com/dmccuskey/DMC-Lua-Library) |
| `dmc_corona_boot.lua` | [dmc-corona-boot](https://github.com/dmccuskey/dmc-corona-boot) |
| `examples/*/*/lib/`, `examples/*/*/dmc_corona_boot.lua` | this repository's `lib/`, and the above |

The `dmc_corona.cfg` files, at the root and in each example, aren't generated: edit them here.

## Building

The `Snakefile` lists the library's files, the libraries it requires, and the example apps. Its build rules are in `snakemake/Snakefile`, a variant of the shared rules in DMC-Corona-Library (`snakemake/Snakefile` there): it installs into `lib/` instead of `dmc_corona/`, and copies any file type, not only `.lua` (the theme images, the table view cell icons). `snakemake/snakeconfig.json` says where each library lands. The build expects every required repository checked out next to this one. From this repository:

```sh
snakemake --cores 1 build_all     # lib/ and every example's lib/
snakemake --cores 1 -n build_all  # dry run: show what would be copied
```

The build copies the sibling checkouts as they are on disk, on whatever branch each one has checked out.

## How Widgets Draw

A widget doesn't redraw when a property or its style changes. The change marks the property as changed (`_width_dirty = true` and so on) and asks for an update on the next frame (`__invalidateProperties__()`, from dmc-lifecycle-mixin); at the next `enterFrame`, `__commitProperties__()` applies every change at once. The model is the component lifecycle of Adobe Flex. So a series of changes costs one redraw, and a change shows one frame later: code that reads a display object's size right after changing the widget sees the old size. Text is the exception for a size that comes from its text: its `width`, `height` and `getTextHeight()` commit pending changes first (`_commitNow()`).

A widget's style sends it an event for each property that changes, and for a reset; the widget's `stylePropertyChangeHandler()` marks what to redraw. A widget's own style inherits from the style it was given, so changes there reach it through the same events ([What the Widget Holds](styles.md#what-the-widget-holds)).

## Testing

`tests/` holds unit tests for the styles, in [lunatest](https://github.com/silentbicycle/lunatest). The repository's own `main.lua` runs them: open it in the Solar2D Simulator, and the console ends with

```text
174 passed, 0 failed, 0 error(s), 0 skipped.
```

(October 2026, Simulator 2026.3731). `main.lua` puts dmc-kolor in its test mode first: the tests give colors as raw numbers and expect them back as given. lunatest runs the suites in the order `main.lua` adds them (the copy in `tests/` is changed for that: its own order moved whenever a suite was added) but the tests of a suite in random order, and skips `teardown()` after a failed test, so a test that changes shared state (the color format, the active theme) sets it back itself, or in `setup()`. Apart from `background_widget_spec`, `text_widget_spec`, `button_widget_spec`, `textfield_widget_spec`, `scrollview_widget_spec`, `tableview_widget_spec` (TableView and TableViewCell) and `navbar_widget_spec` (NavBar and NavItem), the widgets have no automated tests: check a change by running the examples in the Simulator. A widget spec runs after the style specs, which load the base styles with their test defaults (a width of 117, no height): it gives each widget a full style of its own, and calls `widget:__validate__()` to redraw at once instead of waiting a frame. A button can be pressed from code with `button:press()`, and any widget's touch area can take touch events from `dispatchEvent()`, to test without a mouse or for a screenshot. A text field's native field takes `userInput` events the same way; `textfield_widget_spec` replaces `dUI.setKeyboardFocus()`, `unsetKeyboardFocus()` and `native.setKeyboardFocus()` for a test, to count the focus changes without a keyboard (the Simulator's native field ends and restarts an edit when it is focused again). A scroll view moves on `enterFrame`: `scrollview_widget_spec` calls `enterFrame()` on its motion objects (`_axisX`, `_axisY`, `_scaleMotion`) with a time of its choice, to run an animation to any point without waiting; `tableview_widget_spec` does the same, and reads which rows exist from the table view's `_renderedTableCells`. A nav bar slides on `enterFrame` too: `navbar_widget_spec` calls the bar's `_enterFrame_f` with a time of its choice.

The API comments in the source are written for [LDoc](https://github.com/lunarmodules/LDoc); `config.ld` generates HTML into `docs/api/` (not kept in git).

## Possible Future Changes

Each needs discussion and a concrete use case before it is worked on.

- Fix the [Known Issues](api.md#known-issues): fix or remove the broken and missing functions; update the three examples that use `lib.dmc_widgets`; remove the spurious notices and the keyboard debug print.
- Port from the mimetic fork of this library: the SlideView's auto-advance and `scroll_to_slide` (fixing `type(index)=="integer"`, always false in Lua 5.1, and the undeclared global `params` in `scroll_one_slide`).
- Check `View:setAnchor()` against dmc-objects' `ComponentBase:setAnchor()`, which reads its arguments from the wrong place.
- Tests that run in plain Lua, like dmc-sockets' `tests/run_unit.sh`, so the style tests can run without the Simulator.
