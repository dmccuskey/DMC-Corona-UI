--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:fa22c90c1adb5eafa0d75fe6bb0cfdd2:7e4b4f56e49922a27bb72090b6c16c52:36dcfdad9421bd541d066e4ad9df7e87$
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
            x=31,
            y=38,
            width=10,
            height=10,

        },
        {
            -- 02-TM
            x=45,
            y=31,
            width=10,
            height=10,

        },
        {
            -- 03-TR
            x=45,
            y=17,
            width=10,
            height=10,

        },
        {
            -- 04-ML
            x=31,
            y=3,
            width=10,
            height=31,

        },
        {
            -- 05-MM
            x=17,
            y=3,
            width=10,
            height=31,

        },
        {
            -- 06-MR
            x=3,
            y=3,
            width=10,
            height=31,

        },
        {
            -- 07-BL
            x=45,
            y=3,
            width=10,
            height=10,

        },
        {
            -- 08-BM
            x=17,
            y=38,
            width=10,
            height=10,

        },
        {
            -- 09-BR
            x=3,
            y=38,
            width=10,
            height=10,

        },
    },
    
    sheetContentWidth = 64,
    sheetContentHeight = 64
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
