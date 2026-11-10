#!/usr/bin/env python3
"""Turns the bird illustrations of Psito Nest into stamps, and makes the icon.

Usage: tool/prepare_art.py <folder with 01_ovo.jpeg ... 11_rainha.jpeg> [feather.jpeg]

A stamp is the drawing without its plain background. Birds cut by the bottom
of the picture keep a soft fade there, so that they do not end in a hard line.
"""
import random
import sys
from pathlib import Path

from PIL import Image, ImageChops, ImageDraw, ImageFilter

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "assets" / "stamps"
SIZE = 256
CROP = .94
MARKER = (255, 0, 255)
NAMES = [
    "01_ovo", "02_trincando", "03_pelado", "04_penugem", "05_jovem", "06_cinza",
    "07_perola", "08_canela", "09_lutino", "10_arlequim", "11_rainha",
]


def drawing_mask(img: Image.Image, threshold: int = 30, near: int = 60) -> Image.Image:
    """The drawing: everything the background, flooded from the top, misses."""
    flood = img.copy()
    w, h = img.size
    seeds = [(x, 0) for x in range(0, w, 6)]
    seeds += [(side, y) for y in range(0, h, 6) for side in (0, w - 1)]
    seeds += [(x, h - 1) for x in range(0, w, 6)]
    for seed in seeds:
        if flood.getpixel(seed) != MARKER and _near_background(img, seed, near):
            ImageDraw.floodfill(flood, seed, MARKER, thresh=threshold)
    mask = Image.eval(
        ImageChops.difference(flood, Image.new("RGB", (w, h), MARKER)).convert("L"),
        lambda v: 255 if v > 6 else 0,
    )
    return mask.filter(ImageFilter.MinFilter(3)).filter(ImageFilter.GaussianBlur(1.2))


def _near_background(img: Image.Image, seed, near: int) -> bool:
    corner = img.getpixel((3, 3))
    pixel = img.getpixel(seed)
    return sum(abs(a - b) for a, b in zip(corner, pixel)) < near


def fade_bottom(mask: Image.Image) -> Image.Image:
    """Birds that touch the bottom fade out there instead of ending in a line."""
    w, h = mask.size
    ramp = Image.linear_gradient("L").resize((w, h)).transpose(Image.FLIP_TOP_BOTTOM)
    ramp = Image.eval(ramp, lambda v: min(255, v * 5))
    return ImageChops.multiply(mask, ramp)


def stamp(art: Path, name: str, level: int) -> None:
    img = Image.open(art / f"{name}.jpeg").convert("RGB")
    side = int(img.width * CROP)
    img = img.crop((0, 0, side, side))
    mask = drawing_mask(img)
    bottom = mask.crop((0, side - 4, side, side)).getbbox()
    if bottom:
        mask = fade_bottom(mask)
    out = img.convert("RGBA")
    out.putalpha(mask)
    out = out.crop(mask.getbbox())
    out.thumbnail((SIZE, SIZE), Image.LANCZOS)
    out.save(OUT / f"{level}.png", optimize=True)


def rounded(size: int, radius: int) -> Image.Image:
    big = Image.new("L", (size * 3, size * 3), 0)
    ImageDraw.Draw(big).rounded_rectangle((0, 0, size * 3 - 1, size * 3 - 1), radius * 3, fill=255)
    return big.resize((size, size), Image.LANCZOS)


def icon(feather: Path) -> None:
    img = Image.open(feather).convert("RGB")
    side = int(img.width * CROP)
    img = img.crop((0, 0, side, side))
    # The feather lies on a lighter halo, so the background needs more room.
    mask = drawing_mask(img, threshold=70)
    art = img.convert("RGBA")
    art.putalpha(mask)
    art = art.crop(mask.getbbox())
    size = 512
    grain = Image.new("L", (size // 6, size // 6))
    rng = random.Random(2)
    grain.putdata([128 + rng.randint(-7, 7) for _ in range(grain.width**2)])
    grain = grain.resize((size, size), Image.BICUBIC).filter(ImageFilter.GaussianBlur(3))
    ground = ImageChops.overlay(Image.new("RGB", (size, size), (64, 84, 96)), grain.convert("RGB")).convert("RGBA")
    ground.putalpha(rounded(size, 110))
    canvas = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    canvas.alpha_composite(ground)
    art.thumbnail((420, 420), Image.LANCZOS)
    canvas.alpha_composite(art, ((size - art.width) // 2, (size - art.height) // 2))
    canvas.save(ROOT / "icon.png", optimize=True)
    canvas.save(ROOT / "site" / "icon.png", optimize=True)
    canvas.resize((256, 256), Image.LANCZOS).save(
        ROOT / "windows" / "runner" / "resources" / "app_icon.ico",
        sizes=[(16, 16), (32, 32), (48, 48), (64, 64), (128, 128), (256, 256)],
    )


def largest_part(mask: Image.Image) -> Image.Image:
    """Only the biggest connected part of [mask]: the feather, not the drop."""
    small = mask.resize((mask.width // 4, mask.height // 4), Image.NEAREST)
    w, h = small.size
    seen = [[False] * w for _ in range(h)]
    best = []
    for y in range(h):
        for x in range(w):
            if seen[y][x] or small.getpixel((x, y)) < 128:
                continue
            part, stack = [], [(x, y)]
            seen[y][x] = True
            while stack:
                cx, cy = stack.pop()
                part.append((cx, cy))
                for nx, ny in ((cx + 1, cy), (cx - 1, cy), (cx, cy + 1), (cx, cy - 1)):
                    if 0 <= nx < w and 0 <= ny < h and not seen[ny][nx] and small.getpixel((nx, ny)) >= 128:
                        seen[ny][nx] = True
                        stack.append((nx, ny))
            if len(part) > len(best):
                best = part
    keep = Image.new("L", (w, h), 0)
    for x, y in best:
        keep.putpixel((x, y), 255)
    keep = keep.resize(mask.size, Image.NEAREST).filter(ImageFilter.MaxFilter(9))
    return ImageChops.multiply(mask, keep)


def feather_brush(feather: Path) -> None:
    """The feather of the icon, upright and in light greys, so that the brush
    can tint it with any colour and keep its shading."""
    img = Image.open(feather).convert("RGB")
    side = int(img.width * CROP)
    img = img.crop((0, 0, side, side))
    mask = largest_part(drawing_mask(img, threshold=70))
    grey = img.convert("L")
    # Light greys: the darkest line keeps some of the colour that tints it.
    grey = Image.eval(grey, lambda v: 140 + v * 115 // 255)
    out = Image.merge("RGBA", (grey, grey, grey, mask))
    out = out.crop(mask.getbbox())
    # The drawing leans 45 degrees to the right; the brush wants it upright.
    out = out.rotate(45, resample=Image.BICUBIC, expand=True)
    out = out.crop(out.getchannel("A").getbbox())
    out.thumbnail((96, 96), Image.LANCZOS)
    brushes = ROOT / "assets" / "brushes"
    brushes.mkdir(parents=True, exist_ok=True)
    out.save(brushes / "feather.png", optimize=True)


def main() -> None:
    art = Path(sys.argv[1])
    OUT.mkdir(parents=True, exist_ok=True)
    for level, name in enumerate(NAMES, 1):
        stamp(art, name, level)
    if len(sys.argv) > 2:
        icon(Path(sys.argv[2]))
        feather_brush(Path(sys.argv[2]))


if __name__ == "__main__":
    main()
