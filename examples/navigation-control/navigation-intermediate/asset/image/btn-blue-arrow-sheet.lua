--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:2699f697f8d9dc3584c823a138a6350b$
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
            -- 01-TL
            x=46,
            y=108,
            width=22,
            height=14,

            sourceX = 8,
            sourceY = 0,
            sourceWidth = 30,
            sourceHeight = 14
        },
        {
            -- 02-TM
            x=2,
            y=56,
            width=120,
            height=14,

        },
        {
            -- 03-TR
            x=52,
            y=72,
            width=16,
            height=14,

        },
        {
            -- 04-ML
            x=2,
            y=72,
            width=30,
            height=34,

        },
        {
            -- 05-MM
            x=2,
            y=2,
            width=120,
            height=34,

        },
        {
            -- 06-MR
            x=34,
            y=72,
            width=16,
            height=34,

        },
        {
            -- 07-BL
            x=2,
            y=108,
            width=24,
            height=16,

            sourceX = 6,
            sourceY = 0,
            sourceWidth = 30,
            sourceHeight = 16
        },
        {
            -- 08-BM
            x=2,
            y=38,
            width=120,
            height=16,

        },
        {
            -- 09-BR
            x=28,
            y=108,
            width=16,
            height=16,

        },
    },
    
    sheetContentWidth = 128,
    sheetContentHeight = 128
}

SheetInfo.frameIndex =
{

    ["01-TL"] = 1,
    ["02-TM"] = 2,
    ["03-TR"] = 3,
    ["04-ML"] = 4,
    ["05-MM"] = 5,
    ["06-MR"] = 6,
    ["07-BL"] = 7,
    ["08-BM"] = 8,
    ["09-BR"] = 9,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
