# Examples

Each app folder is a complete Solar2D project with its own copy of the library: open its `main.lua` in the Solar2D Simulator. The apps are grouped by the widget or control they show; `*-memtest` apps create and remove widgets in a loop to check memory use, with [dmc-performance](https://github.com/dmccuskey/dmc-performance).

| Folder | Apps | Docs |
|---|---|---|
| `background-widget/` | `background-9slice`, `background-image`, `background-rectangle`, `background-rounded`, `background-styled`, `background-themed`, `background-memtest` | [Background](../docs/widgets.md#background) |
| `button-widget/` | `button-shape-simple`, `button-9slice-simple`, `button-image-simple`, `button-text-simple`, `button-radio-group` | [Button](../docs/widgets.md#button) |
| `navbar-widget/` | `navbar-simple` | [NavBar](../docs/widgets.md#navbar-and-navitem) |
| `navigation-control/` | `navigation-control-simple`, `navigation-intermediate` | [Navigation Control](../docs/controls.md#navigation-control) |
| `popover-control/` | `popover-control-simple` | [Popover Control](../docs/controls.md#popover-control) |
| `scrollview-widget/` | `scrollview-simple`, `scrollview-zoom`, `scrollview-memtest` | [ScrollView](../docs/widgets.md#scrollview) |
| `tableview-widget/` | `tableview-simple`, `tableview-modify`, `tableview-scroll`, `tableview-tableviewcell`, `tableview-memtest` | [TableView](../docs/widgets.md#tableview-and-tableviewcell) |
| `text-widget/` | `text-simple`, `text-styled`, `text-themed`, `text-memtest` | [Text](../docs/widgets.md#text) |
| `textfield-widget/` | `textfield-simple`, `textfield-styled`, `textfield-keyboard` | [TextField](../docs/widgets.md#textfield) |

`background-themed`, `button-radio-group` and `button-text-simple` use the library's old module name and don't run ([Known Issues](../docs/api.md#known-issues)).
