--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:1a4722186156b7bf54b022eb038f8467:2ee196dff9edac5af19f0b1bfac7163b:243421fb25b42f5c40ab37573b9874cc$
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
            y=41,
            width=13,
            height=10,

        },
        {
            -- 02-TM
            x=48,
            y=17,
            width=10,
            height=10,

        },
        {
            -- 03-TR
            x=37,
            y=3,
            width=13,
            height=10,

        },
        {
            -- 04-ML
            x=3,
            y=27,
            width=13,
            height=20,

        },
        {
            -- 05-MM
            x=20,
            y=17,
            width=10,
            height=20,

        },
        {
            -- 06-MR
            x=3,
            y=3,
            width=13,
            height=20,

        },
        {
            -- 07-BL
            x=20,
            y=3,
            width=13,
            height=10,

        },
        {
            -- 08-BM
            x=34,
            y=17,
            width=10,
            height=10,

        },
        {
            -- 09-BR
            x=3,
            y=51,
            width=13,
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
