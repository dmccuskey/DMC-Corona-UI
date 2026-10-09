--
-- drawn by tools/example-art.py: a rounded rectangle over its shadow, cut into nine frames
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {

        {
            -- 01-TL
            x=2,
            y=2,
            width=18,
            height=14,

        },
        {
            -- 02-TM
            x=20,
            y=2,
            width=8,
            height=14,

        },
        {
            -- 03-TR
            x=28,
            y=2,
            width=17,
            height=14,

        },
        {
            -- 04-ML
            x=2,
            y=16,
            width=18,
            height=40,

        },
        {
            -- 05-MM
            x=20,
            y=16,
            width=8,
            height=40,

        },
        {
            -- 06-MR
            x=28,
            y=16,
            width=17,
            height=40,

        },
        {
            -- 07-BL
            x=2,
            y=56,
            width=18,
            height=22,

        },
        {
            -- 08-BM
            x=20,
            y=56,
            width=8,
            height=22,

        },
        {
            -- 09-BR
            x=28,
            y=56,
            width=17,
            height=22,

        },
    },

    sheetContentWidth = 64,
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
