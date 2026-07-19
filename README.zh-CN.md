# 菲比啾比 × Phoebe Chubby — Codex Pet

[繁體中文](README.zh-TW.md) · [简体中文](README.zh-CN.md) · [English](README.md)

[![Release](https://img.shields.io/github/v/release/alan890104/phoebe-chubby-codex-pet?style=flat-square&label=release)](https://github.com/alan890104/phoebe-chubby-codex-pet/releases/latest) [![MIT](https://img.shields.io/badge/project-MIT-7c3aed?style=flat-square)](LICENSE)

[打开菲比啾比动画网站](https://alan890104.github.io/phoebe-chubby-codex-pet/zh-CN/)

![菲比啾比挥手打招呼](media/actions/waving.gif)

> 把菲比啾比加进 Codex。她会跟随工作状态跑动、等待、审查，完成时还会跳起来。

菲比是《鸣潮》中深海教团友善又虔诚的祭司；到了网上，她逐渐变成圆滚滚、表情超多、偶尔气鼓鼓的“菲比啾比”。这个项目把迷因版本的她做成 Codex 桌面宠物。

## 安装或更新

需要先安装 Codex 桌面版。按操作系统执行下面的命令；以后重新执行同一行就是原地更新，不会再多出一只。

### macOS / Linux

```bash
curl -fsSL https://raw.githubusercontent.com/alan890104/phoebe-chubby-codex-pet/main/scripts/install.sh | bash
```

### Windows PowerShell

```powershell
irm https://raw.githubusercontent.com/alan890104/phoebe-chubby-codex-pet/main/scripts/install.ps1 | iex
```

安装完成后：

1. 打开 Codex 的 **Settings → Pets**。
2. 点击 **Refresh**。
3. 选择“菲比啾比”。也可以在工作区使用 `/pet` 或 **Wake pet**。

安装器会根据系统语言自动选择英文、繁体中文或简体中文。三种语言都使用固定 ID `phoebe-chubby`，所以更新时会替换现有宠物。备份会放在 Codex 不会扫描的 `pet-backups` 文件夹；旧版安装器留在 `pets` 中的备份也会自动移出去。

如需强制使用简体中文，可在 macOS 或 Linux 执行：

```bash
curl -fsSL https://raw.githubusercontent.com/alan890104/phoebe-chubby-codex-pet/main/scripts/install.sh | PHOEBE_CHUBBY_LOCALE=zh-CN bash
```

Windows PowerShell：

```powershell
$env:PHOEBE_CHUBBY_LOCALE = "zh-CN"; irm https://raw.githubusercontent.com/alan890104/phoebe-chubby-codex-pet/main/scripts/install.ps1 | iex
```

安装前会校验 SHA-256，确认下载内容完整。

也可以从 [最新 Release](https://github.com/alan890104/phoebe-chubby-codex-pet/releases/latest) 手动下载，把下面两个文件放进 `~/.codex/pets/phoebe-chubby/`：

- 将 `pet.zh-CN.json` 重命名为 `pet.json`
- `spritesheet.webp`

## 她什么时候会做什么？

下面的 GIF 就是实际包内的全部动作。不同 Codex 版本的具体触发时机可能略有差异，但状态对应如下。

| Codex 状态 / 动作 | 动画预览 |
|---|---|
| **Idle** — 没有进行中的工作，安静陪你 | ![Idle](media/actions/idle.gif) |
| **Running right** — 在画面上向右移动 | ![Running right](media/actions/running-right.gif) |
| **Running left** — 在画面上向左移动 | ![Running left](media/actions/running-left.gif) |
| **Waving** — 被唤醒、打招呼 | ![Waving](media/actions/waving.gif) |
| **Jumping** — 开心跳跃、庆祝一下 | ![Jumping](media/actions/jumping.gif) |
| **Failed** — 工作受阻或发生错误 | ![Failed](media/actions/failed.gif) |
| **Waiting** — 等待你的输入或批准 | ![Waiting](media/actions/waiting.gif) |
| **Running** — Codex 正在努力工作 | ![Running](media/actions/running.gif) |
| **Review** — 工作完成，等你回来查看 | ![Review](media/actions/review.gif) |
| **Look around** — 16 个注视方向，按交互方向转动眼神 | ![Look around](media/actions/look-around.gif) |

## 关于图像、迷因与来源

这个项目中的宠物图像由 **GPT Image 2** 生成，再由我们整理、挑选并制作成 Codex 动画；不是把第三方贴图包直接重新打包。

菲比啾比迷因经历了大量转载、改图和二创后，已经很难可靠确认每一张流传图片最初是谁画的，所以我们不会随便指定某个人为“原作者”。如果你有可信的一手来源，欢迎提交 [Attribution issue](https://github.com/alan890104/phoebe-chubby-codex-pet/issues/new?template=attribution.yml)，一起把网络考古补完整。

这是非官方、非商业的爱好者项目。我们为这个仓库制作的程序、文档与 GPT Image 2 宠物图像以 MIT 分享；已有名称、角色与第三方权利仍归各自权利人。详细内容请看 [NOTICE](NOTICE.md)。

没有广告、没有销售、没有加密货币，也没有神秘的菲比币。只有啾比。

## 参考与感谢

- [OpenAI Codex Pets 文档](https://learn.chatgpt.com/docs/pets) — 安装、自定义宠物与状态说明。
- [Wuthering.gg 的 Phoebe 角色介绍](https://wuthering.gg/zh-Hans/characters/phoebe) — 角色背景参考。
- [Genius-Society/phoebe_chubby](https://github.com/Genius-Society/phoebe_chubby) — 社区项目与分享方式参考。
- [来源笔记](docs/ORIGIN.md) — 我们如何处理不确定的迷因来源。

## License

[MIT](LICENSE)。献给我们喜爱的菲比啾比。
