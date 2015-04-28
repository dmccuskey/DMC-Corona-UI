--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:76f004e624c28d642989d038819feb08$
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
            x=226,
            y=2,
            width=18,
            height=18,

        },
        {
            -- 02-TM
            x=22,
            y=66,
            width=182,
            height=18,

        },
        {
            -- 03-TR
            x=186,
            y=24,
            width=18,
            height=18,

        },
        {
            -- 04-ML
            x=2,
            y=86,
            width=18,
            height=40,

        },
        {
            -- 05-MM
            x=2,
            y=2,
            width=182,
            height=40,

        },
        {
            -- 06-MR
            x=2,
            y=44,
            width=18,
            height=40,

        },
        {
            -- 07-BL
            x=206,
            y=2,
            width=18,
            height=20,

        },
        {
            -- 08-BM
            x=22,
            y=44,
            width=182,
            height=20,

        },
        {
            -- 09-BR
            x=186,
            y=2,
            width=18,
            height=20,

        },
    },
    
    sheetContentWidth = 256,
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
