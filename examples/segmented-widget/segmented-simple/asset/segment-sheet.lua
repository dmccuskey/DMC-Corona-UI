--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:e9133adfd7de441686d319a057021420:38240b359cee80bae90791f91061f94b:a7033980e37402c6fac3f53e895e264c$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- 01-leftInctive
            x=30,
            y=49,
            width=4,
            height=42,

            sourceX = 2,
            sourceY = 1,
            sourceWidth = 6,
            sourceHeight = 44
        },
        {
            -- 02-middleInactive
            x=49,
            y=3,
            width=5,
            height=42,

            sourceX = 0,
            sourceY = 1,
            sourceWidth = 5,
            sourceHeight = 44
        },
        {
            -- 03-rightInactive
            x=3,
            y=49,
            width=6,
            height=42,

            sourceX = 0,
            sourceY = 1,
            sourceWidth = 6,
            sourceHeight = 44
        },
        {
            -- 04-leftActive
            x=22,
            y=49,
            width=4,
            height=42,

            sourceX = 2,
            sourceY = 1,
            sourceWidth = 6,
            sourceHeight = 44
        },
        {
            -- 05-middleActive
            x=40,
            y=3,
            width=5,
            height=42,

            sourceX = 0,
            sourceY = 1,
            sourceWidth = 5,
            sourceHeight = 44
        },
        {
            -- 06-rightActive
            x=3,
            y=3,
            width=6,
            height=42,

            sourceX = 0,
            sourceY = 1,
            sourceWidth = 6,
            sourceHeight = 44
        },
        {
            -- 07-dividerII
            x=31,
            y=3,
            width=5,
            height=42,

            sourceX = 0,
            sourceY = 1,
            sourceWidth = 5,
            sourceHeight = 44
        },
        {
            -- 08-dividerIA
            x=22,
            y=3,
            width=5,
            height=42,

            sourceX = 0,
            sourceY = 1,
            sourceWidth = 5,
            sourceHeight = 44
        },
        {
            -- 09-dividerAA
            x=13,
            y=49,
            width=5,
            height=42,

            sourceX = 0,
            sourceY = 1,
            sourceWidth = 5,
            sourceHeight = 44
        },
        {
            -- 10-dividerAI
            x=13,
            y=3,
            width=5,
            height=42,

            sourceX = 0,
            sourceY = 1,
            sourceWidth = 5,
            sourceHeight = 44
        },
    },
    
    sheetContentWidth = 64,
    sheetContentHeight = 128
}

SheetInfo.frameIndex =
{

    ["01-leftInctive"] = 1,
    ["02-middleInactive"] = 2,
    ["03-rightInactive"] = 3,
    ["04-leftActive"] = 4,
    ["05-middleActive"] = 5,
    ["06-rightActive"] = 6,
    ["07-dividerII"] = 7,
    ["08-dividerIA"] = 8,
    ["09-dividerAA"] = 9,
    ["10-dividerAI"] = 10,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
