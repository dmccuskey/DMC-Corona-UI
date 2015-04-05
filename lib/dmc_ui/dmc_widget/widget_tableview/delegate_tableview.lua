--====================================================================--
-- dmc_ui/dmc_widget/widget_tableview/delegate_tableview.lua
--
-- Documentation: http://docs.davidmccuskey.com/
--====================================================================--

--[[

The MIT License (MIT)

Copyright (c) 2015 David McCuskey

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

--]]


--====================================================================--
--== DMC Corona UI : TableView Delegate
--====================================================================--


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.1.0"


--- TableView Delegate Interface.
-- the interface for controlling a TableView via a delegate. currently all are optional, so it's only necessary to implement those which are needed.
--
-- @classmod Delegate.TableView
-- @usage
-- local dUI = require 'dmc_ui'
--
-- -- setup delegate object
-- local delegate = {
--   shouldHighlightRow=function(self, event)
--     return true
--   end,
--   willSelectRow=function(self, event)
--     return event.index
--   end,
-- }
-- @usage
-- local widget = dUI.newTableView()
-- widget.delegate = <delgate object>
-- @usage
-- local dUI = require 'dmc_ui'
-- local widget = dUI.newTableView{
--   delegate=<delegate object>
-- }



--- (optional) asks delegate if specified row should be highlighted.
-- return true if row should be highlighted otherwise return false if not. if this method is not implemented, the default return value is true.
--
-- @within Methods
-- @function :shouldHighlightRow
-- @param event the event table
-- @tparam string event.name the event name (`TableView.EVENT`)
-- @tparam string event.type the event type (`TableView.SHOULD_HIGHLIGHT_ROW`)
-- @object event.target the TableView
-- @tparam number event.index the index of the row inside of the TableView
-- @object event.view the row's Display Group, for visual items
-- @tab event.data a table for general data storage for the row.
-- @treturn bool true if row should be highlighted.


--- (optional) informs delegate that row was highlighted.
--
-- @within Methods
-- @function :didHighlightRow
-- @param event the event table
-- @tparam string event.name the event name (`TableView.EVENT`)
-- @tparam string event.type the event type (`TableView.HIGHLIGHT_ROW`)
-- @object event.target the TableView
-- @tparam number event.index the index of the row inside of the TableView
-- @object event.view the row's Display Group, for visual items
-- @tab event.data a table for general data storage for the row.


--- (optional) informs delegate that row has been unhighlighted.
--
-- @within Methods
-- @function :didUnhighlightRow
-- @param event the event table
-- @tparam string event.name the event name (`TableView.EVENT`)
-- @tparam string event.type the event type (`TableView.UNHIGHLIGHT_ROW`)
-- @object event.target the TableView
-- @tparam number event.index the index of the row inside of the TableView
-- @object event.view the row's Display Group, for visual items
-- @tab event.data a table for general data storage for the row.


--- (optional) asks delegate if specified row should be selected.
-- this method must either return the `index` given (to select that row), an alternate `index` (to select another row) or `nil` to not select anything. if this method is not implemented, the default return value is the index passed in.
--
-- @within Methods
-- @function :willSelectRow
-- @param event the event table
-- @tparam string event.name the event name (`TableView.EVENT`)
-- @tparam string event.type the event type (`TableView.WILL_SELECT_ROW`)
-- @object event.target the TableView
-- @tparam number event.index the index of the row inside of the TableView
-- @object event.view the row's Display Group, for visual items
-- @tab event.data a table for general data storage for the row.
-- @return index passed in, a different index, or nil


--- (optional) informs delegate that Nav Item was popped off stack.
-- tells delegate that this Nav Item was popped off of the navigation stack. the delegate can respond appropriately.
--
-- @within Methods
-- @function :didSelectRow
-- @param event the event table
-- @tparam string event.name the event name (`TableView.EVENT`)
-- @tparam string event.type the event type (`TableView.SELECTED_ROW`)
-- @object event.target the TableView
-- @tparam number event.index the index of the row inside of the TableView
-- @object event.view the row's Display Group, for visual items
-- @tab event.data a table for general data storage for the row.

