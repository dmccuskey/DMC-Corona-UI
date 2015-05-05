--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
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
            -- 01-leftInactive
            x=57,
            y=3,
            width=4,
            height=42,

            sourceX = 2,
            sourceY = 1,
            sourceWidth = 6,
            sourceHeight = 44
        },
        {
            -- 02-middleInactive
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
            x=49,
            y=3,
            width=4,
            height=42,

            sourceX = 2,
            sourceY = 1,
            sourceWidth = 6,
            sourceHeight = 44
        },
        {
            -- 05-middleActive
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
            -- 07-dividerAI
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
            -- 08-dividerII
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
            -- 09-dividerIA
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

    ["01-leftInactive"] = 1,
    ["02-middleInactive"] = 2,
    ["03-rightInactive"] = 3,
    ["04-leftActive"] = 4,
    ["05-middleActive"] = 5,
    ["06-rightActive"] = 6,
    ["07-dividerAI"] = 7,
    ["08-dividerII"] = 8,
    ["09-dividerIA"] = 9,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
