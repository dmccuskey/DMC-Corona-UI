# Overview #

The **DMC Corona UI** library is collection of advanced widgets for the Corona SDK. They can be used in any size or type of application.

The module architecture is heavily object-oriented, but each module can be used with any style of coding. The OO-nature ensures that the modules can be easily re-used or modified as necessary.

**Features**

* Robust and efficient widgets
* Cascading style sheets
* Powerful controls

**Documentation & Examples**

There are examples and documentation available for the modules. Look in the `examples` folder for available examples which can be run directly in the Corona SDK. Documentation and some simple screencasts of examples are online at: [docs.davidmccuskey.com](http://docs.davidmccuskey.com/dmc+corona+ui)


**Questions or Comments**

If you have questions or comments you can either (preferred order):
* send me an email: corona-lib at davidmccuskey com
* post an issue here on github
* send a PM @ coronalabs.com: @dmccuskey
* post to the Corona forums: http://forums.coronalabs.com


**Issues**

If you have any issues, please post them here on github: [dmc-corona-ui issues](http://github.com/dmccuskey/dmc-corona-ui/issues)



## Installation & Use ##

For easy installation, copy the following items to the same location anywhere in your Corona project:

* The entire `dmc_corona` folder
* The file `dmc_corona_boot.lua`
* `dmc_corona.cfg`
* The entire `dmc_ui` folder
* The file `dmc_ui.lua`

`dmc-corona-ui` depends on `dmc-corona-library` for some of its functionality. It is included in this repo for convenience. 

As in the examples, if you placed both items inside of a directory `lib`, the widgets module would be imported like so:

```lua
local dUI = require 'lib.dmc_ui'

local button = dUI.newPushButton( params )
...
```


As with `dmc-corona-library`, `dmc-corona-ui` has been designed to give a lot of flexibility where it is located in your project. For more information regarding the library and individual widgets, visit [DMC Corona UI](http://docs.davidmccuskey.com/dmc+corona+ui).



## Current Widgets & Styles ##

* Background

  A widget used to provide a backing image. This is used in other widgets, eg TextField, Button, TableViewCell, etc. Several display types – image, rectangle shape, rounded shape, 9-slice, etc.

* Button

  A fancy button set.

* NavBar

  A navigation bar.

* NavItem

  An item used in the NavBar.

* ScrollView

  A robust 2D scroll surface.
  
* Segmented Control

  A horizontal control made of multiple segments, each segment functioning as a discrete button.

* TableView

  A high-performance TableView widget, inherits from ScrollView.

* TableViewCell

  A general-purpose row for a TableView.

* Text

  A widget to display textual information.

* TextField

  No-fuss, all action text-input widget.



## Current Controls ##


* Navigation Control

  Builds on NavBar to deliver precise page navigation.
  


## License ##

The MIT License (MIT)

Copyright (c) 2013-2015 David McCuskey

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
