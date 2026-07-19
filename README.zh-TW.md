# 菲比啾比 × Phoebe Chubby — Codex Pet

[繁體中文](README.zh-TW.md) · [简体中文](README.zh-CN.md) · [English](README.md)

[![Release](https://img.shields.io/github/v/release/alan890104/phoebe-chubby-codex-pet?style=flat-square&label=release)](https://github.com/alan890104/phoebe-chubby-codex-pet/releases/latest) [![MIT](https://img.shields.io/badge/project-MIT-7c3aed?style=flat-square)](LICENSE)

[開啟菲比啾比動畫網站](https://alan890104.github.io/phoebe-chubby-codex-pet/zh-TW/)

![菲比啾比揮手打招呼](media/actions/waving.gif)

> 把菲比啾比加進 Codex。她會跟著工作狀態跑動、等待、審查，完成時還會跳起來。

菲比是《鳴潮》中深海教團友善又虔誠的祭司；到了網路上，她逐漸變成圓滾滾、表情超多、偶爾氣噗噗的「菲比啾比」。這個專案把迷因版本的她做成 Codex 桌面寵物。

## 安裝或更新

需要已安裝 Codex 桌面版。依照作業系統執行下面的指令；之後重新執行同一行，就是原地更新，不會再多出一隻。

### macOS / Linux

```bash
curl -fsSL https://raw.githubusercontent.com/alan890104/phoebe-chubby-codex-pet/main/scripts/install.sh | bash
```

### Windows PowerShell

```powershell
irm https://raw.githubusercontent.com/alan890104/phoebe-chubby-codex-pet/main/scripts/install.ps1 | iex
```

安裝完成後：

1. 開啟 Codex 的 **Settings → Pets**。
2. 按 **Refresh**。
3. 選擇「菲比啾比」。也可以在工作區使用 `/pet` 或 **Wake pet**。

安裝器會依系統語言自動選擇英文、繁體中文或簡體中文。三種語言都使用固定 ID `phoebe-chubby`，所以更新時會取代既有寵物。備份會放在 Codex 不會掃描的 `pet-backups` 資料夾；舊版安裝器留在 `pets` 裡的備份也會自動移出去。

若要強制使用繁體中文，可在 macOS 或 Linux 執行：

```bash
curl -fsSL https://raw.githubusercontent.com/alan890104/phoebe-chubby-codex-pet/main/scripts/install.sh | PHOEBE_CHUBBY_LOCALE=zh-TW bash
```

Windows PowerShell：

```powershell
$env:PHOEBE_CHUBBY_LOCALE = "zh-TW"; irm https://raw.githubusercontent.com/alan890104/phoebe-chubby-codex-pet/main/scripts/install.ps1 | iex
```

安裝前會核對 SHA-256，確認下載內容完整。

想手動安裝也可以從 [最新 Release](https://github.com/alan890104/phoebe-chubby-codex-pet/releases/latest) 下載，將這兩個檔案放進 `~/.codex/pets/phoebe-chubby/`：

- 將 `pet.zh-TW.json` 重新命名為 `pet.json`
- `spritesheet.webp`

## 她什麼時候會做什麼？

以下 GIF 就是實際包內的全部動作。不同 Codex 版本的細部觸發時機可能略有差異，但狀態對應如下。

| Codex 狀態 / 動作 | 動畫預覽 |
|---|---|
| **Idle** — 沒有進行中的工作，安靜陪你 | ![Idle](media/actions/idle.gif) |
| **Running right** — 在畫面上往右移動 | ![Running right](media/actions/running-right.gif) |
| **Running left** — 在畫面上往左移動 | ![Running left](media/actions/running-left.gif) |
| **Waving** — 被喚醒、打招呼 | ![Waving](media/actions/waving.gif) |
| **Jumping** — 開心跳躍、慶祝一下 | ![Jumping](media/actions/jumping.gif) |
| **Failed** — 工作受阻或發生錯誤 | ![Failed](media/actions/failed.gif) |
| **Waiting** — 等待你的輸入或核准 | ![Waiting](media/actions/waiting.gif) |
| **Running** — Codex 正在努力工作 | ![Running](media/actions/running.gif) |
| **Review** — 工作完成、等你回來查看 | ![Review](media/actions/review.gif) |
| **Look around** — 16 個注視方向，依互動方向轉動眼神 | ![Look around](media/actions/look-around.gif) |

## 關於圖像、迷因與來源

這個專案裡的寵物圖像由 **GPT Image 2** 生成，再由我們整理、挑選與製作成 Codex 動畫；不是把第三方貼圖包直接重新打包。

菲比啾比迷因經過大量轉貼、改圖和二創後，已很難可靠確認每一張流傳圖片最初是誰畫的，所以我們不會隨便指定某個人是「原作者」。若你握有可信的一手來源，歡迎開 [Attribution issue](https://github.com/alan890104/phoebe-chubby-codex-pet/issues/new?template=attribution.yml)，一起把網路考古補完整。

這是非官方、非商業的同好專案。我們為這個倉庫製作的程式、文件與 GPT Image 2 寵物圖像以 MIT 分享；既有名稱、角色與第三方權利仍屬各自權利人。詳細內容請看 [NOTICE](NOTICE.md)。

沒有廣告、沒有販售、沒有加密貨幣，也沒有神祕的菲比幣。只有啾比。

## 參考與感謝

- [OpenAI Codex Pets 文件](https://learn.chatgpt.com/docs/pets) — 安裝、自訂寵物與狀態說明。
- [Wuthering.gg 的 Phoebe 角色介紹](https://wuthering.gg/zh-Hant/characters/phoebe) — 角色背景參考。
- [Genius-Society/phoebe_chubby](https://github.com/Genius-Society/phoebe_chubby) — 社群專案與分享方式參考。
- [來源筆記](docs/ORIGIN.md) — 我們怎麼處理不確定的迷因來源。

## License

[MIT](LICENSE)。獻給我們喜愛的菲比啾比。
