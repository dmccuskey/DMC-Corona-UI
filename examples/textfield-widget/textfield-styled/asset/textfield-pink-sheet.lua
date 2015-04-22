--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:19ac68ce119242464c8792efdc81ac02:61129b229c94dc25014cfc5eb7332fc1:36dcfdad9421bd541d066e4ad9df7e87$
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
            x=23,
            y=46,
            width=6,
            height=6,

        },
        {
            -- 02-TM
            x=13,
            y=46,
            width=6,
            height=6,

        },
        {
            -- 03-TR
            x=23,
            y=36,
            width=6,
            height=6,

        },
        {
            -- 04-ML
            x=23,
            y=3,
            width=6,
            height=29,

        },
        {
            -- 05-MM
            x=13,
            y=3,
            width=6,
            height=29,

        },
        {
            -- 06-MR
            x=3,
            y=3,
            width=6,
            height=29,

        },
        {
            -- 07-BL
            x=13,
            y=36,
            width=6,
            height=6,

        },
        {
            -- 08-BM
            x=3,
            y=46,
            width=6,
            height=6,

        },
        {
            -- 09-BR
            x=3,
            y=36,
            width=6,
            height=6,

        },
    },
    
    sheetContentWidth = 32,
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
