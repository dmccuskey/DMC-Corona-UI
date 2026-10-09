#!/usr/bin/env python3
"""default-art.py: draw the library's default 9-slice art (plain Python 3, no image library needed).

Writes, under lib/dmc_ui/theme/default/ of this repository:
  background/nine-slice-sheet.png + .lua   the default 9-slice background: the default button's look
  textfield/textfield-sheet.png + .lua     the default TextField: a white field, transparent around it
Each sheet is one rounded rectangle with a 1 px border, cut into nine frames which touch each other
in the sheet, so a stretched frame's edge blends into its real neighbor (no seams, no padding needed).
"""
import os, struct, zlib

GRAY = (0.62, 0.66, 0.70)

def png(path, w, h, px):
    raw = b''.join(b'\x00' + bytes(v for p in px[y*w:(y+1)*w] for v in p) for y in range(h))
    def chunk(t, d): return struct.pack('>I', len(d)) + t + d + struct.pack('>I', zlib.crc32(t + d))
    with open(path, 'wb') as f:
        f.write(b'\x89PNG\r\n\x1a\n' + chunk(b'IHDR', struct.pack('>IIBBBBB', w, h, 8, 6, 0, 0, 0))
                + chunk(b'IDAT', zlib.compress(raw, 9)) + chunk(b'IEND', b''))

def inside(x, y, w, h, r, inset):
    # is the point inside the rounded rect w x h (radius r), shrunk by inset on every side
    x0, y0, x1, y1, r = inset, inset, w - inset, h - inset, max(r - inset, 0)
    if not (x0 <= x <= x1 and y0 <= y <= y1): return False
    cx = min(max(x, x0 + r), x1 - r); cy = min(max(y, y0 + r), y1 - r)
    return (x - cx) ** 2 + (y - cy) ** 2 <= r * r

def draw(sw, sh, w, h, r, top, bottom, ox=2, oy=2, ss=4):
    px = [(0, 0, 0, 0)] * (sw * sh)
    for y in range(h):
        t = y / (h - 1)
        fill = tuple(a + (b - a) * t for a, b in zip(top, bottom))
        for x in range(w):
            outer = inner = 0
            for j in range(ss):
                for i in range(ss):
                    sx, sy = x + (i + 0.5) / ss, y + (j + 0.5) / ss
                    if inside(sx, sy, w, h, r, 0):
                        outer += 1
                        if inside(sx, sy, w, h, r, 1): inner += 1
            if outer:
                k = inner / outer
                c = tuple(g + (f - g) * k for g, f in zip(GRAY, fill))
                px[(oy + y) * sw + ox + x] = tuple(round(v * 255) for v in c) + (round(255 * outer / (ss * ss)),)
    return px

def info(path, sw, sh, cols, rows, names, ox=2, oy=2, by='tools/default-art.py: one rounded rectangle'):
    xs, ys, out = [ox], [oy], []
    for c in cols[:-1]: xs.append(xs[-1] + c)
    for r in rows[:-1]: ys.append(ys[-1] + r)
    for j in range(3):
        for i in range(3):
            out.append("        {\n            -- %s\n            x=%d,\n            y=%d,\n            width=%d,\n            height=%d,\n\n        },"
                       % (names[j*3+i], xs[i], ys[j], cols[i], rows[j]))
    index = '\n'.join('    ["%s"] = %d,' % (n, k + 1) for k, n in enumerate(names))
    with open(path, 'w') as f:
        f.write("""--
-- drawn by %s, cut into nine frames
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {

%s
    },

    sheetContentWidth = %d,
    sheetContentHeight = %d
}

SheetInfo.frameIndex =
{

%s
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
""" % (by, '\n'.join(out), sw, sh, index))

if __name__ == '__main__':
    here = os.path.dirname(os.path.abspath(__file__))
    repo = os.path.join(here, '..')
    base = os.path.join(repo, 'lib', 'dmc_ui', 'theme', 'default')

    # the default 9-slice background: 24x60, radius 8, the default button's gradient
    d = os.path.join(base, 'background')
    png(os.path.join(d, 'nine-slice-sheet.png'), 32, 64, draw(32, 64, 24, 60, 8, (0.99, 0.99, 0.99), (0.88, 0.89, 0.91)))
    info(os.path.join(d, 'nine-slice-sheet.lua'), 32, 64, (10, 4, 10), (10, 40, 10),
         ['topLeft', 'topMiddle', 'topRight', 'middleLeft', 'middleMiddle', 'middleRight', 'bottomLeft', 'bottomMiddle', 'bottomRight'])

    # the default TextField: 20x20, radius 6, white
    d = os.path.join(base, 'textfield')
    png(os.path.join(d, 'textfield-sheet.png'), 32, 32, draw(32, 32, 20, 20, 6, (1, 1, 1), (1, 1, 1)))
    info(os.path.join(d, 'textfield-sheet.lua'), 32, 32, (8, 4, 8), (8, 4, 8),
         ['01-TL', '02-TM', '03-TR', '04-ML', '05-MM', '06-MR', '07-BL', '08-BM', '09-BR'])
    print('wrote the default art under', os.path.normpath(base))
