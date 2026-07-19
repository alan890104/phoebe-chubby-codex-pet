#!/usr/bin/env python3
from __future__ import annotations

import argparse
from pathlib import Path

from PIL import Image

CELL_WIDTH = 192
CELL_HEIGHT = 208
STATES = {
    "idle": (0, [280, 110, 110, 140, 140, 320]),
    "running-right": (1, [120, 120, 120, 120, 120, 120, 120, 220]),
    "running-left": (2, [120, 120, 120, 120, 120, 120, 120, 220]),
    "waving": (3, [140, 140, 140, 280]),
    "jumping": (4, [140, 140, 140, 140, 280]),
    "failed": (5, [140, 140, 140, 140, 140, 140, 140, 240]),
    "waiting": (6, [150, 150, 150, 150, 150, 260]),
    "running": (7, [120, 120, 120, 120, 120, 220]),
    "review": (8, [150, 150, 150, 150, 150, 280]),
}


def crop_cell(atlas: Image.Image, row: int, column: int) -> Image.Image:
    left = column * CELL_WIDTH
    top = row * CELL_HEIGHT
    return atlas.crop((left, top, left + CELL_WIDTH, top + CELL_HEIGHT)).convert("RGBA")


def key_fringe_pixels(frames: list[Image.Image]) -> int:
    count = 0
    for frame in frames:
        for red, green, blue, alpha in frame.get_flattened_data():
            if alpha and green >= 96 and green >= red * 1.7 and green >= blue * 1.7:
                count += 1
    return count


def save_gif(frames: list[Image.Image], durations: list[int], output: Path) -> None:
    fringe = key_fringe_pixels(frames)
    if fringe:
        raise SystemExit(f"Refusing to publish {output.name}: found {fringe} chroma-green fringe pixels")
    output.parent.mkdir(parents=True, exist_ok=True)
    frames[0].save(
        output,
        save_all=True,
        append_images=frames[1:],
        duration=durations,
        loop=0,
        disposal=2,
        optimize=False,
    )


def main() -> None:
    parser = argparse.ArgumentParser(description="Build public GIF previews from the cleaned final Codex pet atlas.")
    parser.add_argument("--atlas", default="pet/spritesheet.webp")
    parser.add_argument("--output-dir", default="media/actions")
    args = parser.parse_args()

    atlas_path = Path(args.atlas).expanduser().resolve()
    output_dir = Path(args.output_dir).expanduser().resolve()
    with Image.open(atlas_path) as opened:
        atlas = opened.convert("RGBA")
    if atlas.size != (1536, 2288):
        raise SystemExit(f"Expected a 1536x2288 v2 atlas, got {atlas.size}")

    for state, (row, durations) in STATES.items():
        frames = [crop_cell(atlas, row, column) for column in range(len(durations))]
        save_gif(frames, durations, output_dir / f"{state}.gif")

    look_frames = [crop_cell(atlas, 9, column) for column in range(8)]
    look_frames.extend(crop_cell(atlas, 10, column) for column in range(8))
    save_gif(look_frames, [100] * 16, output_dir / "look-around.gif")
    print(f"Built 10 clean GIF previews in {output_dir}")


if __name__ == "__main__":
    main()
