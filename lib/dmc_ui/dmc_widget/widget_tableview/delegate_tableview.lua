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
-- the interface for controlling a TableView via a delegate.
--
-- @classmod Delegate.TableView
-- @usage
-- local dUI = require 'dmc_ui'
--
-- -- setup delegate object
-- local delegate = {
--   numberOfRows=function(self, tableview, section)
--     -- return row data here
--   end,
--   onRowRender=function(self, event)
--     -- create row view
--   end,
--   onRowUnrender=function(self, event)
--     -- destroy row view
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


--- description of parameters for method :onRowRender().
-- this is the complete list of properties for the :onRowRender() parameter table.
--
-- @within Parameters
-- @tfield string name the event name (TableView.EVENT)
-- @tfield string type event type (TableView.RENDER_ROW)
-- @tfield object target the TableView
-- @tfield object view the view (Display Group) to populate with items
-- @tfield number index the index of the row inside of the TableView.
-- @tfield table data a table for general data storage for the row.
-- @table .shouldHighlightRowEvent


--- description of parameters for method :onRowRender().
-- this is the complete list of properties for the :onRowRender() parameter table.
--
-- @within Parameters
-- @tfield string name the event name (TableView.EVENT)
-- @tfield string type event type (TableView.RENDER_ROW)
-- @tfield object target the TableView
-- @tfield object view the view (Display Group) to populate with items
-- @tfield number index the index of the row inside of the TableView.
-- @tfield table data a table for general data storage for the row.
-- @table .didHighlightRowEvent


--- description of parameters for method :onRowRender().
-- this is the complete list of properties for the :onRowRender() parameter table.
--
-- @within Parameters
-- @tfield string name the event name (TableView.EVENT)
-- @tfield string type event type (TableView.RENDER_ROW)
-- @tfield object target the TableView
-- @tfield object view the view (Display Group) to populate with items
-- @tfield number index the index of the row inside of the TableView.
-- @tfield table data a table for general data storage for the row.
-- @table .didUnhighlightRowEvent


--- description of parameters for method :onRowRender().
-- this is the complete list of properties for the :onRowRender() parameter table.
--
-- @within Parameters
-- @tfield string name the event name (TableView.EVENT)
-- @tfield string type event type (TableView.RENDER_ROW)
-- @tfield object target the TableView
-- @tfield object view the view (Display Group) to populate with items
-- @tfield number index the index of the row inside of the TableView.
-- @tfield table data a table for general data storage for the row.
-- @table .willSelectRowEvent


--- description of parameters for method :onRowRender().
-- this is the complete list of properties for the :onRowRender() parameter table.
--
-- @within Parameters
-- @tfield string name the event name (TableView.EVENT)
-- @tfield string type event type (TableView.RENDER_ROW)
-- @tfield object target the TableView
-- @tfield object view the view (Display Group) to populate with items
-- @tfield number index the index of the row inside of the TableView.
-- @tfield table data a table for general data storage for the row.
-- @table .didSelectRowEvent



--- (optional) asks delegate if row should be highlighted.
-- return boolean value.
--
-- @within Methods
-- @function :shouldHighlightRow
-- @param event the @{shouldHighlightRowEvent} object


--- (optional) informs delegate that Nav Item was popped off stack.
-- tells delegate that this Nav Item was popped off of the navigation stack. the delegate can respond appropriately.
--
-- @within Methods
-- @function :didHighlightRow
-- @param event the @{didHighlightRowEvent} object


--- (optional) informs delegate that Nav Item was popped off stack.
-- tells delegate that this Nav Item was popped off of the navigation stack. the delegate can respond appropriately.
--
-- @within Methods
-- @function :didUnhighlightRow
-- @param event the @{didUnhighlightRowEvent} object


--- (optional) informs delegate that Nav Item was popped off stack.
-- tells delegate that this Nav Item was popped off of the navigation stack. the delegate can respond appropriately.
--
-- @within Methods
-- @function :willSelectRow
-- @param event the @{willSelectRowEvent} object


--- (optional) informs delegate that Nav Item was popped off stack.
-- tells delegate that this Nav Item was popped off of the navigation stack. the delegate can respond appropriately.
--
-- @within Methods
-- @function :didSelectRow
-- @param event the @{didSelectRowEvent} object

