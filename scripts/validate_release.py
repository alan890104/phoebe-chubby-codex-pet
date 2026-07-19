#!/usr/bin/env python3
from __future__ import annotations

import hashlib
import json
import re
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
EXPECTED_GIFS = {
    "idle.gif": 6,
    "running-right.gif": 8,
    "running-left.gif": 8,
    "waving.gif": 4,
    "jumping.gif": 5,
    "failed.gif": 8,
    "waiting.gif": 6,
    "running.gif": 6,
    "review.gif": 6,
    "look-around.gif": 16,
}


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def key_fringe_pixels(image: Image.Image) -> int:
    count = 0
    for frame_index in range(image.n_frames):
        image.seek(frame_index)
        for red, green, blue, alpha in image.convert("RGBA").get_flattened_data():
            if alpha and green >= 96 and green >= red * 1.7 and green >= blue * 1.7:
                count += 1
    return count


EXPECTED_MANIFESTS = {
    "pet/pet.json": (
        "Phoebe Chubby",
        "Phoebe Chubby runs, waits, reviews, and celebrates alongside your Codex work.",
    ),
    "pet/pet.zh-TW.json": (
        "菲比啾比",
        "菲比啾比會跟著 Codex 的工作狀態跑動、等待、審查與慶祝完成。",
    ),
    "pet/pet.zh-CN.json": (
        "菲比啾比",
        "菲比啾比会跟随 Codex 的工作状态跑动、等待、审查与庆祝完成。",
    ),
}

for relative, (display_name, description) in EXPECTED_MANIFESTS.items():
    manifest = json.loads((ROOT / relative).read_text(encoding="utf-8"))
    require(manifest["id"] == "phoebe-chubby", f"Unexpected pet id in {relative}")
    require(manifest["displayName"] == display_name, f"Unexpected display name in {relative}")
    require(manifest["description"] == description, f"Unexpected description in {relative}")
    require(manifest["spriteVersionNumber"] == 2, f"{relative} must use sprite format v2")
    require(manifest["spritesheetPath"] == "spritesheet.webp", f"Unexpected sprite path in {relative}")

with Image.open(ROOT / "pet/spritesheet.webp") as atlas:
    require(atlas.size == (1536, 2288), f"Unexpected atlas size: {atlas.size}")
    require(atlas.format == "WEBP", f"Unexpected atlas format: {atlas.format}")
    require(atlas.mode == "RGBA", f"Unexpected atlas mode: {atlas.mode}")

for filename, frames in EXPECTED_GIFS.items():
    path = ROOT / "media/actions" / filename
    require(path.exists(), f"Missing preview: {filename}")
    with Image.open(path) as image:
        require(image.format == "GIF", f"{filename} is not a GIF")
        require(image.n_frames == frames, f"{filename}: expected {frames} frames, got {image.n_frames}")
        require(key_fringe_pixels(image) == 0, f"{filename} contains chroma-green fringe pixels")

expected_checksums = {}
for line in (ROOT / "checksums.txt").read_text(encoding="utf-8").splitlines():
    digest, relative = line.split(maxsplit=1)
    expected_checksums[relative.lstrip("*")] = digest.lower()

checksummed_files = (*EXPECTED_MANIFESTS, "pet/spritesheet.webp")
require(set(expected_checksums) == set(checksummed_files), "checksums.txt must cover only the public pet files")
for relative in checksummed_files:
    digest = hashlib.sha256((ROOT / relative).read_bytes()).hexdigest()
    require(expected_checksums.get(relative) == digest, f"Checksum mismatch: {relative}")

README_SITES = {
    "README.md": "https://alan890104.github.io/phoebe-chubby-codex-pet/",
    "README.zh-TW.md": "https://alan890104.github.io/phoebe-chubby-codex-pet/zh-TW/",
    "README.zh-CN.md": "https://alan890104.github.io/phoebe-chubby-codex-pet/zh-CN/",
}

for readme, site_url in README_SITES.items():
    text = (ROOT / readme).read_text(encoding="utf-8")
    require(site_url in text, f"Missing localized project website in {readme}")
    require("/install.html" not in text, f"Obsolete install page remains in {readme}")
    require("codex://pets/install?" not in text, f"Deep-link code must stay on the website, not {readme}")
    require("quality report" not in text.lower(), f"Internal quality-report copy leaked into {readme}")
    for filename in EXPECTED_GIFS:
        require(f"media/actions/{filename}" in text, f"{readme} does not show {filename}")

require(not (ROOT / "docs/install.html").exists(), "The obsolete GitHub Pages installer must not ship")
require((ROOT / "docs/.nojekyll").exists(), "GitHub Pages must bypass Jekyll processing")

SITE_PAGES = {
    "docs/index.html": ("lang=\"en\"", "Add Phoebe Chubby to Codex.", "assets/actions/"),
    "docs/zh-TW/index.html": ("lang=\"zh-Hant\"", "把菲比啾比裝進 Codex。", "../assets/actions/"),
    "docs/zh-CN/index.html": ("lang=\"zh-Hans\"", "把菲比啾比装进 Codex。", "../assets/actions/"),
}

FORBIDDEN_SITE_COPY = (
    "A little sea breeze for every coding session.",
    "讓每一次寫程式，都吹來一點海風。",
    "让每一次写程序，都吹来一点海风。",
    "Download the package",
    "下載完整套件",
    "下载完整套件",
    "Animated pet format v2",
    "第二版動畫格式",
    "第二版动画格式",
    "Bring Phoebe Chubby home.",
    "把菲比啾比帶回家。",
    "把菲比啾比带回家。",
    "A highly serious happiness study",
    "非常認真的快樂研究",
    "非常认真的快乐研究",
)

for relative, (language, headline, action_prefix) in SITE_PAGES.items():
    html = (ROOT / relative).read_text(encoding="utf-8")
    require(language in html, f"Wrong or missing language declaration in {relative}")
    require(headline in html, f"Missing localized hero headline in {relative}")
    install_controls = len(re.findall(r"\sdata-install(?:\s|>)", html))
    require(install_controls == 1, f"{relative} must expose exactly one install control")
    require("release-link" not in html, f"{relative} still exposes the manual package link")
    require("install-section" not in html, f"{relative} still contains the duplicate install section")
    for forbidden_copy in FORBIDDEN_SITE_COPY:
        require(forbidden_copy not in html, f"Stale marketing copy remains in {relative}: {forbidden_copy}")
    require("/install.html" not in html, f"{relative} references the obsolete install page")
    for filename in EXPECTED_GIFS:
        require(f"{action_prefix}{filename}" in html, f"{relative} does not use {filename}")

english_site = (ROOT / "docs/index.html").read_text(encoding="utf-8")
english_interface_copy = english_site.replace("繁體中文", "").replace("简体中文", "")
require(
    not re.search(r"[\u3400-\u9fff]", english_interface_copy),
    "English website contains Chinese text outside native language names",
)
for relative in SITE_PAGES:
    html = (ROOT / relative).read_text(encoding="utf-8")
    for native_language_name in ("English", "繁體中文", "简体中文"):
        require(native_language_name in html, f"{relative} is missing {native_language_name}")
for relative in ("docs/zh-TW/index.html", "docs/zh-CN/index.html"):
    html = (ROOT / relative).read_text(encoding="utf-8")
    for english_phrase in ("Install in Codex", "Every mood, animated", "Download the package", "Did Codex stay closed"):
        require(english_phrase not in html, f"English interface copy leaked into {relative}")

site_script = (ROOT / "docs/assets/site.js").read_text(encoding="utf-8")
for required_fragment in (
    "codex://pets/install?name=",
    "&imageUrl=",
    "&description=",
    "&spriteVersionNumber=2",
):
    require(required_fragment in site_script, f"Website install link is missing {required_fragment}")
require("phoebe-chubby-locale" in english_site, "English entry page must detect the browser locale")
require("navigator.languages" in english_site, "English entry page must inspect browser languages")
require("zh-TW/" in english_site and "zh-CN/" in english_site, "Locale routing destinations are missing")

for filename in EXPECTED_GIFS:
    published = ROOT / "docs/assets/actions" / filename
    require(published.exists(), f"GitHub Pages is missing {filename}")
    require(
        published.read_bytes() == (ROOT / "media/actions" / filename).read_bytes(),
        f"GitHub Pages preview is stale: {filename}",
    )

for filename in ("hero-frame.webp", "install-plaque.webp", "title-ribbon.webp"):
    path = ROOT / "docs/assets/ornaments" / filename
    require(path.exists(), f"Missing generated website ornament: {filename}")
    with Image.open(path) as ornament:
        rgba = ornament.convert("RGBA")
        corners = (
            rgba.getpixel((0, 0))[3],
            rgba.getpixel((rgba.width - 1, 0))[3],
            rgba.getpixel((0, rgba.height - 1))[3],
            rgba.getpixel((rgba.width - 1, rgba.height - 1))[3],
        )
        require(corners == (0, 0, 0, 0), f"{filename} must have transparent corners")
        visible_green = sum(
            1
            for red, green, blue, alpha in rgba.get_flattened_data()
            if alpha > 16 and green >= 96 and green >= red * 1.7 and green >= blue * 1.7
        )
        require(visible_green == 0, f"{filename} contains visible chroma-key fringe")

shell_installer = (ROOT / "scripts/install.sh").read_text(encoding="utf-8")
powershell_installer = (ROOT / "scripts/install.ps1").read_text(encoding="utf-8")
for installer, name in ((shell_installer, "install.sh"), (powershell_installer, "install.ps1")):
    require("pet-backups" in installer, f"{name} must keep backups outside the Pets scan folder")
    require("PHOEBE_CHUBBY_LOCALE" in installer, f"{name} must support explicit locale selection")
    for relative in EXPECTED_MANIFESTS:
        require(relative in installer, f"{name} does not select {relative}")

print("Phoebe Chubby release validation passed: atlas, localized manifests, idempotent installers, checksums, docs, and all 10 GIFs are ready. 啾比！")
