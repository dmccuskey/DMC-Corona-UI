# Examples

Each app folder is a complete Solar2D project with its own copy of the library: open its `main.lua` in the Solar2D Simulator. The apps are grouped by the widget or control they show; `*-memtest` apps create and remove widgets in a loop to check memory use, with [dmc-performance](https://github.com/dmccuskey/dmc-performance).

| Folder | Apps | Docs |
|---|---|---|
| `background-widget/` | `background-9slice`, `background-image`, `background-rectangle`, `background-rounded`, `background-styled`, `background-themed`, `background-memtest` | [Background](../docs/widgets.md#background); [below](#background) |
| `button-widget/` | `button-shape-simple`, `button-9slice-simple`, `button-image-simple`, `button-text-simple`, `button-radio-group` | [Button](../docs/widgets.md#button); [below](#button) |
| `navbar-widget/` | `navbar-simple` | [NavBar](../docs/widgets.md#navbar-and-navitem) |
| `navigation-control/` | `navigation-control-simple`, `navigation-intermediate` | [Navigation Control](../docs/controls.md#navigation-control) |
| `popover-control/` | `popover-control-simple` | [Popover Control](../docs/controls.md#popover-control) |
| `scrollview-widget/` | `scrollview-simple`, `scrollview-zoom`, `scrollview-memtest` | [ScrollView](../docs/widgets.md#scrollview) |
| `tableview-widget/` | `tableview-simple`, `tableview-modify`, `tableview-scroll`, `tableview-tableviewcell`, `tableview-memtest` | [TableView](../docs/widgets.md#tableview-and-tableviewcell) |
| `text-widget/` | `text-simple`, `text-styled`, `text-themed`, `text-memtest` | [Text](../docs/widgets.md#text); [below](#text) |
| `textfield-widget/` | `textfield-simple`, `textfield-styled`, `textfield-keyboard` | [TextField](../docs/widgets.md#textfield) |

The sections below describe each app, with a screenshot; the other widgets' apps get theirs as each widget is checked. In most apps a white box with a red dot marks the widget's position.

## Background

| | |
|---|---|
| <img src="screenshots/background-9slice.png" width="240" alt="background-9slice: a blue 9-slice background with rounded corners and a drop shadow, its top-left corner on the red dot"> | **background-9slice**: a 9-slice background from an image sheet (Texture Packer) and its drop-shadow offsets, 150x100 and anchored at its bottom-right corner; after a second it's 100 wide and anchored at its top-left (`setAnchor()`). |
| <img src="screenshots/background-image.png" width="240" alt="background-image: a blue gradient image stretched to 200 wide, its left edge on the red dot, running off the right of the screen"> | **background-image**: an image background with its drop-shadow offsets, scaled to 100x100; after a second it's 200 wide (the screenshot), and after two a width and height of 0 show the image at its own size. |
| <img src="screenshots/background-rectangle.png" width="240" alt="background-rectangle: a tall grey rectangle with a thin pink border, its top-left corner on the red dot"> | **background-rectangle**: an orange rectangle background with a red border, anchored at its bottom center; after a second its `viewStyle` makes it grey with a thin pink border, and it's anchored at its top-left. |
| <img src="screenshots/background-rounded.png" width="240" alt="background-rounded: a grey rounded square with a thin pink border, its top-left corner on the red dot"> | **background-rounded**: a blue rounded background with a red border, 150x100; after a second it's 100 wide, grey with a thin pink border and a corner radius of 20, anchored at its top-left. |
| <img src="screenshots/background-styled.png" width="240" alt="background-styled: a yellow rounded background with a red border, two grey default backgrounds, and two translucent red ones, the debug overlay"> | **background-styled**: styles on backgrounds. Defaults changed through `viewStyle` (the yellow one, then moved up), the default rounded and rectangle backgrounds (grey), a shared style from `newBackgroundStyle()`, and a widget whose style is swapped (rounded, rectangle, rounded again) while it moves up. Their styles set `debugOn=true`, which covers a background in translucent red. |
| <img src="screenshots/background-themed.png" width="240" alt="background-themed: two green rounded backgrounds, from the green theme"> | **background-themed**: three themes in `theme/` (red, green, blue), each with a background style named `home-background`: a rectangle, a rounded and a 9-slice background. Both backgrounds use the style by name, so they change with the active theme, every second (`dUI.loadThemes()`, `dUI.activateTheme()`). The screenshot is the green theme. |
| <img src="screenshots/background-memtest.png" width="240" alt="background-memtest: a small default 9-slice background, a blue pill, in the white box"> | **background-memtest**: creates and removes a default 9-slice background every 75 ms and prints memory use with [dmc-performance](https://github.com/dmccuskey/dmc-performance); `run_example1()` does the same with a rectangle. Each background is up for about a frame; for the screenshot, one was kept on the screen. |


## Button

| | |
|---|---|
| <img src="screenshots/button-shape-simple.png" width="240" alt="button-shape-simple: a grey rectangle button with a thick yellow border, labeled Press, its bottom-right corner on the red dot"> | **button-shape-simple**: a button drawn with shapes, a grey rectangle with a yellow border, a green rounded rectangle while pressed. After a second its anchor becomes (1,0) and its hit margin grows; after two the anchor is (1,1) (the screenshot). `run_example1()` shows the four button types with the default style, `run_example3()` a shared style and `clearStyle()`. |
| <img src="screenshots/button-9slice-simple.png" width="240" alt="button-9slice-simple: a blue 9-slice button with a drop shadow, its label cut to 'Press Here...', its bottom center on the red dot"> | **button-9slice-simple**: a button with a 9-slice background (an image sheet) anchored at its bottom center. Its size animates between 60x40 and 225x100; when it's narrow, the label "Press Here for Fun" ends in `...` (the screenshot). The pressed state uses the default rounded style. `run_example1a()` is the same button at a fixed size, `run_example3()` adds `debugOn`. |
| <img src="screenshots/button-image-simple.png" width="240" alt="button-image-simple: an orange image button labeled OK, up and to the right of the white box"> | **button-image-simple**: a button made of two images, orange and a darker orange while pressed. A background `width` and `height` of 0 draws each image at its own size. |
| <img src="screenshots/button-text-simple.png" width="240" alt="button-text-simple: four buttons, Back, Middle in translucent red with a larger red hit area, Orange held down with a yellow left-aligned label on a dark background, and a greyed-out Disabled"> | **button-text-simple**: four push buttons that differ in their label, each state styled on its own: "Back" turns red and moves right while pressed; "Middle" has a hit area larger than the button (`hitMarginX`, `hitMarginY`), shown in red by `debugOn`; "Orange" sits right with an offset and jumps left while pressed (each state's `align`, `offsetX`, `offsetY`; held down in the screenshot); "Disabled" shows the disabled style and ignores presses. |
| <img src="screenshots/button-radio-group.png" width="240" alt="button-radio-group: a row of Small, Medium and Large with Large green, a row of Left and Right with Right green, and the line 'size: Large   side: Right'"> | **button-radio-group**: two button groups (`newButtonGroup()`). In the radio group one of "Small", "Medium" and "Large" is always active; in the toggle group at most one of "Left" and "Right" is, and pressing it again turns it off. The line below shows the selection, from each group's change event. In the screenshot "Large" and "Right" were pressed. |


## Text

| | |
|---|---|
| <img src="screenshots/text-simple.png" width="240" alt="text-simple: a narrow purple Text in the white box, its text in a smaller font and cut short with an ellipsis"> | **text-simple**: a Text whose width animates between 40 and 250. With `fontSizeMinimum`, text that doesn't fit first shrinks, then ends in `...` (the screenshot). It starts sized to its text, which its size event (`DIMENSION_CHANGED`) prints. `run_example1()` to `3()` change properties on a timer, set them back to `nil`, and animate the width with anchors, fonts and colors. |
| <img src="screenshots/text-styled.png" width="240" alt="text-styled: pink text 'pizza' on a dark blue box with a red border, its top-left corner on the red dot"> | **text-styled**: an inline style, then the default style (`style=nil`); after two seconds "hamburger" in a 300x70 box anchored at its bottom-right, then "pizza" sized to its text and anchored at its top-left (the screenshot). `run_example1()` to `6()` show the default style, shared and named styles, `clearStyle()` and long text. |
| <img src="screenshots/text-themed.png" width="240" alt="text-themed: 'One Two Three' and 'Four Five' in red on teal boxes, from the green theme"> | **text-themed**: three themes in `theme/` (red, green, blue), each with a text style named `home-text`. Both Texts use the style by name, so they change with the active theme, every second (`dUI.loadThemes()`, `dUI.activateTheme()`). The screenshot is the green theme. |
| <img src="screenshots/text-memtest.png" width="240" alt="text-memtest: the word 'memtest' in the white box"> | **text-memtest**: creates and removes a Text every 50 ms and prints memory use with [dmc-performance](https://github.com/dmccuskey/dmc-performance); `run_example1()` and `2()` do the same with a text style (new, and `copyStyle()`). Each Text is up for about a frame; for the screenshot, one was kept on the screen. |
