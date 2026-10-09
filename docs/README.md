# DMC Corona UI Documentation

New here? The [Quick Start](../README.md#quick-start) makes a text and a button, then shares a style between buttons, in about 10 minutes.

## Start

- [Quick Start](../README.md#quick-start): copy the library in, a text and a button, share a style by name

## Use

- [Using Styles](styles.md): a style for each widget, inline, shared and named styles, what the widget holds, child styles, inheritance, themes, the palette
- [Widgets](widgets.md): Background, Text, TextField, Button, NavBar and NavItem, ScrollView, SlideView, PageIndicator, TableView and TableViewCell
- [Controls](controls.md): the Navigation Control and its views, and presenting a control as a page over the app or as a popover
- [API reference](api.md): the module's functions, themes, keyboard, constants, configuration, known issues
- [Examples](../examples/): an app for each widget and control

## Contribute

- [Development](development.md): which files are generated, building, how widgets draw, testing, possible future changes
- [Issues](https://github.com/dmccuskey/DMC-Corona-UI/issues)

## Project Structure

```text
README.md                   landing page and Quick Start
LICENSE
docs/                       this documentation
└── images/                 screenshots for the README
lib/                        what apps copy
├── dmc_ui.lua              the module (source)
├── dmc_ui/                 widgets, styles, controls, default theme (source)
└── dmc_corona/             DMC Corona libraries it uses (generated copies)
dmc_corona_boot.lua         loader, from dmc-corona-boot (generated copy)
dmc_corona.cfg              library configuration
main.lua                    runs the unit tests in the Simulator
tests/                      unit tests for the styles
examples/                   sample apps, by widget, each with its own generated lib/
Snakefile                   build: this library's files, requirements, examples
snakemake/                  build rules and install locations
config.ld                   LDoc configuration for the API comments
```
