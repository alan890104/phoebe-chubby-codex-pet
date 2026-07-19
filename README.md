# Phoebe Chubby — Codex Pet

[繁體中文](README.zh-TW.md) · [简体中文](README.zh-CN.md) · [English](README.md)

[![Release](https://img.shields.io/github/v/release/alan890104/phoebe-chubby-codex-pet?style=flat-square&label=release)](https://github.com/alan890104/phoebe-chubby-codex-pet/releases/latest) [![MIT](https://img.shields.io/badge/project-MIT-7c3aed?style=flat-square)](LICENSE)

[Open the animated project website](https://alan890104.github.io/phoebe-chubby-codex-pet/)

![Phoebe Chubby waving hello](media/actions/waving.gif)

> Add Phoebe Chubby to Codex. She runs, waits, reviews, celebrates, and occasionally gets mad as your work changes.

Phoebe is the friendly, devout priest from the Order of the Deep in Wuthering Waves. The internet gradually transformed her into the round, wildly expressive, occasionally furious creature known as 菲比啾比 — Phoebe Chubby. This project turns that meme version into a Codex desktop pet.

## Install or update

You need the Codex desktop app. Run the installer for your platform; running the same command again updates the existing pet in place.

### macOS / Linux

```bash
curl -fsSL https://raw.githubusercontent.com/alan890104/phoebe-chubby-codex-pet/main/scripts/install.sh | bash
```

### Windows PowerShell

```powershell
irm https://raw.githubusercontent.com/alan890104/phoebe-chubby-codex-pet/main/scripts/install.ps1 | iex
```

After installation:

1. Open **Settings → Pets** in Codex.
2. Click **Refresh**.
3. Select **Phoebe Chubby**. You can also use `/pet` or **Wake pet** in a workspace.

The installer automatically chooses English, Traditional Chinese, or Simplified Chinese from your system language. Every language uses the same stable pet ID (`phoebe-chubby`), so an update replaces the current pet instead of creating another one. Backups are kept outside Codex's scanned `pets` folder, and the installer also moves backups left there by older versions.

To override language detection on macOS or Linux:

```bash
curl -fsSL https://raw.githubusercontent.com/alan890104/phoebe-chubby-codex-pet/main/scripts/install.sh | PHOEBE_CHUBBY_LOCALE=en bash
```

On Windows PowerShell:

```powershell
$env:PHOEBE_CHUBBY_LOCALE = "en"; irm https://raw.githubusercontent.com/alan890104/phoebe-chubby-codex-pet/main/scripts/install.ps1 | iex
```

Downloads are verified with SHA-256 before installation.

For a manual install, download the [latest Release](https://github.com/alan890104/phoebe-chubby-codex-pet/releases/latest) and place these files in `~/.codex/pets/phoebe-chubby/`:

- `pet.json` (English), or rename `pet.zh-TW.json` / `pet.zh-CN.json` to `pet.json`
- `spritesheet.webp`

## When does each animation appear?

These GIFs show every action in the actual package. Exact micro-triggers may vary slightly between Codex versions, but the state mapping is:

| Codex state / action | Animation preview |
|---|---|
| **Idle** — no active work; quietly keeping you company | ![Idle](media/actions/idle.gif) |
| **Running right** — moving right across the scene | ![Running right](media/actions/running-right.gif) |
| **Running left** — moving left across the scene | ![Running left](media/actions/running-left.gif) |
| **Waving** — waking up or saying hello | ![Waving](media/actions/waving.gif) |
| **Jumping** — a happy jump or small celebration | ![Jumping](media/actions/jumping.gif) |
| **Failed** — work is blocked or an error occurred | ![Failed](media/actions/failed.gif) |
| **Waiting** — Codex needs your input or approval | ![Waiting](media/actions/waiting.gif) |
| **Running** — Codex is actively working | ![Running](media/actions/running.gif) |
| **Review** — work is ready and waiting for you to review | ![Review](media/actions/review.gif) |
| **Look around** — 16 gaze directions follow the interaction direction | ![Look around](media/actions/look-around.gif) |

## About the images, meme, and origin

The pet images in this project were generated with **GPT Image 2**, then selected, assembled, and turned into a Codex animation set by us. This is not a direct repack of a third-party sticker collection.

After years of reposts, edits, and fan remixes, the exact first artist behind every circulating Phoebe Chubby image is difficult to verify. We will not casually assign that title to one person. If you have a reliable primary source, please open an [attribution issue](https://github.com/alan890104/phoebe-chubby-codex-pet/issues/new?template=attribution.yml) and help improve the internet archaeology.

This is an unofficial, non-commercial fan project. The code, docs, and GPT Image 2-generated pet files we created for this repository are shared under MIT; existing names, characters, and third-party rights remain with their respective owners. See [NOTICE](NOTICE.md).

No ads. No sales. No crypto. No mysterious Phoebe coin. Just Chubby.

## References and thanks

- [OpenAI Codex Pets documentation](https://learn.chatgpt.com/docs/pets) — installation, custom pets, and status behavior.
- [Phoebe at Wuthering.gg](https://wuthering.gg/characters/phoebe) — character background reference.
- [Genius-Society/phoebe_chubby](https://github.com/Genius-Society/phoebe_chubby) — community project and sharing inspiration.
- [Origin notes](docs/ORIGIN.md) — how this project handles uncertain meme provenance.

## License

[MIT](LICENSE). For Phoebe Chubby fans.
