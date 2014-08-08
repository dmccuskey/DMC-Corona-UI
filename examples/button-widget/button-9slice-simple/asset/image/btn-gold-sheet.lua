--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:51855dcd2810c6db326ab4aef3138cb6$
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
            x=20,
            y=34,
            width=14,
            height=16,

        },
        {
            -- 02-TM
            x=2,
            y=98,
            width=138,
            height=16,

        },
        {
            -- 03-TR
            x=18,
            y=66,
            width=16,
            height=16,

        },
        {
            -- 04-ML
            x=2,
            y=66,
            width=14,
            height=30,

        },
        {
            -- 05-MM
            x=2,
            y=2,
            width=138,
            height=30,

        },
        {
            -- 06-MR
            x=2,
            y=34,
            width=16,
            height=30,

        },
        {
            -- 07-BL
            x=142,
            y=18,
            width=14,
            height=14,

        },
        {
            -- 08-BM
            x=36,
            y=34,
            width=138,
            height=14,

        },
        {
            -- 09-BR
            x=142,
            y=2,
            width=16,
            height=14,

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
