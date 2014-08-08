--====================================================================--
-- Simple 9-Slice Button
--
-- Shows basic use of the DMC Widget: Button
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2014 David McCuskey. All Rights Reserved.
--====================================================================--


print( "\n\n#########################################################\n\n" )


--===================================================================--
--== Imports

local Widgets = require 'lib.dmc_widgets'


--===================================================================--
--== Setup, Constants

local o


--===================================================================--
-- Support Functions

local function onPress_handler( event )
	print( 'Main: onPress_handler: id', event.id )
end

local function onRelease_handler( event )
	print( 'Main: onRelease_handler: id', event.id )
end

local function onEvent_handler( event )
	print( 'Main: onEvent_handler: id', event.id, event.phase )
end


local function createBlueCloudSheet()
	local button_info = require 'asset.image.button-cloud-sheet'
	return graphics.newImageSheet( 'asset/image/button-cloud-sheet.png', button_info:getSheet() )
end

local function createBlueButtonSheet()
	local button_info = require 'asset.image.btn-blue-sheet'
	return graphics.newImageSheet( 'asset/image/btn-blue-sheet.png', button_info:getSheet() )
end

local function createGoldButtonSheet()
	local button_info = require 'asset.image.btn-gold-sheet'
	return graphics.newImageSheet( 'asset/image/btn-gold-sheet.png', button_info:getSheet() )
end


--===================================================================--
-- Main
--===================================================================--


--== Create Buttons

--[[
	button shows:
	* simple label
	* more complex 'active' view (alignment, color)
--]]
o = Widgets.newButton{
	-- button info
	type='push',
	id='button-back',
	hit_width = 200,
	hit_height = 76,

	-- label info
	label = {
		text = "Press",
		color={0,0,0},
	},

	-- view info
	view='9-slice',
	width = 200,
	height = 80,
	sheet = createBlueButtonSheet(),
	frames = {
		top_left=1,
		top_middle=2,
		top_right=3,
		middle_left=4,
		middle=5,
		middle_right=6,
		bottom_left=7,
		bottom_middle=8,
		bottom_right=9,
	},

	active = {
		sheet = createGoldButtonSheet(),
		label = {
			text = "Me",
			color={1,0.3,0.3},
		},
	},

	-- handlers
	onPress = onPress_handler,
	onRelease = onRelease_handler,
	onEvent = onEvent_handler,
}
o.x, o.y = 150, 70


--[[
	button shows:
	* simple label
	* more complex 'active' view (alignment, color)
--]]
o = Widgets.newButton{
	-- button info
	type='push',
	id='button-back',
	hit_width = 200,
	hit_height = 100,

	-- label info
	label = {
		text = "Back",
		color={0,0,0},
	},

	-- view info
	view='9-slice',
	width = 122,
	height = 72,
	sheet = createBlueCloudSheet(),
	frames = {
		top_left=1,
		top_middle=2,
		top_right=3,
		middle_left=4,
		middle=5,
		middle_right=6,
		bottom_left=7,
		bottom_middle=8,
		bottom_right=9,
	},

	active = {
		label = {
			color={1,1,1},
		},
	},

	-- handlers
	onPress = onPress_handler,
	onRelease = onRelease_handler,
	onEvent = onEvent_handler,
}
o.x, o.y = 150, 200
