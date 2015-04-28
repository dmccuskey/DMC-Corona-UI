--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:dc27214098507109c813ae89fcbdd52f:a520fe5686be187d89a74e0d44eec1be:29118b179ae1ff931d7d4fdfaa76c912$
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
            -- Slice-01
            x=43,
            y=121,
            width=18,
            height=15,

        },
        {
            -- Slice-02
            x=43,
            y=229,
            width=258,
            height=15,

        },
        {
            -- Slice-03
            x=43,
            y=104,
            width=19,
            height=15,

        },
        {
            -- Slice-04
            x=23,
            y=104,
            width=18,
            height=100,

        },
        {
            -- Slice-05
            x=2,
            y=2,
            width=258,
            height=100,

        },
        {
            -- Slice-06
            x=2,
            y=104,
            width=19,
            height=100,

        },
        {
            -- Slice-07
            x=23,
            y=229,
            width=18,
            height=21,

        },
        {
            -- Slice-08
            x=2,
            y=206,
            width=258,
            height=21,

        },
        {
            -- Slice-09
            x=2,
            y=229,
            width=19,
            height=21,

        },
    },
    
    sheetContentWidth = 512,
    sheetContentHeight = 256
}

SheetInfo.frameIndex =
{

    ["Slice-01"] = 1,
    ["Slice-02"] = 2,
    ["Slice-03"] = 3,
    ["Slice-04"] = 4,
    ["Slice-05"] = 5,
    ["Slice-06"] = 6,
    ["Slice-07"] = 7,
    ["Slice-08"] = 8,
    ["Slice-09"] = 9,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
