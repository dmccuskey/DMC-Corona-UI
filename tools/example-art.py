#!/usr/bin/env python3
"""example-art.py: draw the art of the examples which bring their own (plain Python 3, no image library needed).

Writes, under examples/ of this repository:
  button-widget/button-9slice-simple/asset/image/cloud_button/button-sheet.png + .lua
      a 9-slice button in the palette's blue with a drop shadow. The shadow lies outside the button's
      body, which is what the example's offsets (left 8, right 7, top 4, bottom 12) tell the widget.
"""
import importlib.util, math, os

here = os.path.dirname(os.path.abspath(__file__))
spec = importlib.util.spec_from_file_location('default_art', os.path.join(here, 'default-art.py'))
art = importlib.util.module_from_spec(spec); spec.loader.exec_module(art)

BLUE_TOP, BLUE, BLUE_DARK = (0.36, 0.67, 0.88), (0.22, 0.56, 0.80), (0.15, 0.44, 0.67)

def dist(x, y, x0, y0, x1, y1, r):
    # distance from the point to the edge of a rounded rect: negative inside
    qx = max(x0 + r - x, x - (x1 - r), 0); qy = max(y0 + r - y, y - (y1 - r), 0)
    if qx or qy: return math.hypot(qx, qy) - r
    return -min(x - x0, x1 - x, y - y0, y1 - y)

def clamp(v): return min(max(v, 0), 1)

def shadowed(sw, sh, w, h, r, left, top, top_color, bottom_color, border, ox=2, oy=2, drop=4, blur=7, dark=0.4):
    # a w x h body (1 px border, vertical gradient) at left, top of its frame, over a soft shadow below it
    px = [(0, 0, 0, 0)] * (sw * sh)
    x0, y0, x1, y1 = left, top, left + w, top + h
    for y in range(sh - oy):
        t = clamp((y - top) / (h - 1))
        fill = tuple(a + (b - a) * t for a, b in zip(top_color, bottom_color))
        for x in range(sw - ox):
            cx, cy = x + 0.5, y + 0.5
            d = dist(cx, cy, x0, y0, x1, y1, r)
            body, inner = clamp(0.5 - d), clamp(0.5 - (d + 1))
            shade = dark * clamp(1 - (dist(cx, cy, x0, y0 + drop, x1, y1 + drop, r) + 1) / blur) ** 2
            alpha = body + shade * (1 - body)
            if alpha <= 0: continue
            k = inner / body if body else 0
            c = tuple((g + (f - g) * k) * body / alpha for g, f in zip(border, fill))
            px[(oy + y) * sw + ox + x] = tuple(round(v * 255) for v in c) + (round(255 * alpha),)
    return px

# button-9slice-simple: a 28x60 body, radius 8; margins left 8, right 7, top 4, bottom 12 for the shadow
d = os.path.join(here, '..', 'examples', 'button-widget', 'button-9slice-simple', 'asset', 'image', 'cloud_button')
art.png(os.path.join(d, 'button-sheet.png'), 64, 128, shadowed(64, 128, 28, 60, 8, 8, 4, BLUE_TOP, BLUE, BLUE_DARK))
art.info(os.path.join(d, 'button-sheet.lua'), 64, 128, (18, 8, 17), (14, 40, 22),
         ['01-TL', '02-TM', '03-TR', '04-ML', '05-MM', '06-MR', '07-BL', '08-BM', '09-BR'],
         by='tools/example-art.py: a rounded rectangle over its shadow')
print('wrote the example art under', os.path.normpath(d))
