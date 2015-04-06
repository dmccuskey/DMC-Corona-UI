--====================================================================--
-- dmc_ui/dmc_widget/widget_tableview/datasource_tableview.lua
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
--== DMC Corona UI : TableView DataSource
--====================================================================--


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.1.0"


--- TableView DataSource Interface.
-- the interface for providing data to a TableView.
--
-- @classmod DataSource.TableView
-- @usage
-- local dUI = require 'dmc_ui'
--
-- -- setup dataSource object
-- local dataSource = {
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
-- widget.dataSource = <dataSource object>
-- @usage
-- local dUI = require 'dmc_ui'
-- local widget = dUI.newTableView{
--   dataSource=<dataSource object>
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
-- @table .onRowRenderEvent


--- description of parameters for method :onRowRender().
-- this is the complete list of properties for the :onRowRender() parameter table.
--
-- @within Parameters
-- @tfield string name the event name (TableView.EVENT)
-- @tfield string type event type (TableView.UNRENDER_ROW)
-- @tfield object target the TableView
-- @tfield object view the view (Display Group) to remove items
-- @tfield number index the index of the row inside of the TableView.
-- @tfield table data a table for general data storage for the row.
-- @table .onRowUnrenderEvent



--- (required) tells the data source to return the number of rows in the TableView.
--
-- @within Methods
-- @function :numberOfRows
-- @param tableview the @{Widget.TableView} object
-- @param section the section in question (not implemented)
-- @treturn number


--- (required) asks the data source to render the view for the row to be added to the display.
--
-- @within Methods
-- @function :onRowRender
-- @param event the @{onRowRenderEvent} object


--- (required) asks the data source to unrender the view for the row to be removed from the display.
--
-- @within Methods
-- @function :onRowUnrender
-- @param event the @{onRowUnrenderEvent} object

