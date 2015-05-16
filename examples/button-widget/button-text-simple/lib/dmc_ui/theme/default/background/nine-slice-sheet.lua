--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:c043502ae2b0e89ca3b8fc4fcb0f4581:0853e3dffa716350f89af9e6d10f8024:243421fb25b42f5c40ab37573b9874cc$
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
            x=26,
            y=107,
            width=18,
            height=15,

        },
        {
            -- 02-TM
            x=48,
            y=107,
            width=8,
            height=15,

        },
        {
            -- 03-TR
            x=3,
            y=107,
            width=19,
            height=15,

        },
        {
            -- 04-ML
            x=26,
            y=3,
            width=18,
            height=100,

        },
        {
            -- 05-MM
            x=48,
            y=3,
            width=8,
            height=100,

        },
        {
            -- 06-MR
            x=3,
            y=3,
            width=19,
            height=100,

        },
        {
            -- 07-BL
            x=83,
            y=3,
            width=18,
            height=21,

        },
        {
            -- 08-BM
            x=105,
            y=3,
            width=8,
            height=21,

        },
        {
            -- 09-BR
            x=60,
            y=3,
            width=19,
            height=21,

        },
    },

    sheetContentWidth = 128,
    sheetContentHeight = 128
}

SheetInfo.frameIndex =
{

    ["topLeft"] = 1,
    ["topMiddle"] = 2,
    ["topRight"] = 3,
    ["middleLeft"] = 4,
    ["middleMiddle"] = 5,
    ["middleRight"] = 6,
    ["bottomLeft"] = 7,
    ["bottomMiddle"] = 8,
    ["bottomRight"] = 9,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
