param(
  [switch]$NoBackup
)

$ErrorActionPreference = "Stop"
$PetId = "phoebe-chubby"
$Repo = if ($env:PHOEBE_CHUBBY_REPO) { $env:PHOEBE_CHUBBY_REPO } else { "alan890104/phoebe-chubby-codex-pet" }
$Ref = if ($env:PHOEBE_CHUBBY_REF) { $env:PHOEBE_CHUBBY_REF } else { "main" }
$BaseUrl = if ($env:PHOEBE_CHUBBY_BASE_URL) { $env:PHOEBE_CHUBBY_BASE_URL } else { "https://raw.githubusercontent.com/$Repo/$Ref" }
$CodexHome = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $HOME ".codex" }
$PetsDir = Join-Path $CodexHome "pets"
$PetDir = Join-Path $PetsDir $PetId
$BackupRoot = Join-Path (Join-Path $CodexHome "pet-backups") $PetId
$TempDir = Join-Path ([System.IO.Path]::GetTempPath()) ("phoebe-chubby-" + [guid]::NewGuid())
$StagePet = Join-Path $TempDir "pet"
$BackupDir = Join-Path $BackupRoot ((Get-Date -Format "yyyyMMdd-HHmmss") + "-" + [guid]::NewGuid().ToString("N"))
$OldDir = Join-Path $TempDir "previous-pet"
$PreviousMovedTo = $null

$RawLocale = if ($env:PHOEBE_CHUBBY_LOCALE) {
  $env:PHOEBE_CHUBBY_LOCALE
} else {
  [System.Globalization.CultureInfo]::CurrentUICulture.Name
}
if ([string]::IsNullOrWhiteSpace($RawLocale)) { $RawLocale = "en" }
$NormalizedLocale = $RawLocale.ToLowerInvariant().Replace("_", "-")

if ($NormalizedLocale -match '^zh-(tw|hk|mo|hant)') {
  $ManifestPath = "pet/pet.zh-TW.json"
  $PetName = "菲比啾比"
  $LocaleName = "繁體中文"
  $MsgDownloading = "正在下載菲比啾比..."
  $MsgBackup = "舊版本已備份到 Pets 掃描範圍之外。"
  $MsgMigrated = "已將舊備份移出 Pets 資料夾，避免出現重複寵物。"
  $MsgInstalled = "菲比啾比安裝完成。"
  $MsgRefresh = "請在 Codex 開啟 Settings > Pets > Refresh，再選擇「菲比啾比」。"
  $MsgUpdate = "下次更新只要重新執行同一行指令。啾比！"
} elseif ($NormalizedLocale -match '^zh-(cn|sg|hans)') {
  $ManifestPath = "pet/pet.zh-CN.json"
  $PetName = "菲比啾比"
  $LocaleName = "简体中文"
  $MsgDownloading = "正在下载菲比啾比..."
  $MsgBackup = "旧版本已备份到 Pets 扫描范围之外。"
  $MsgMigrated = "已将旧备份移出 Pets 文件夹，避免出现重复宠物。"
  $MsgInstalled = "菲比啾比安装完成。"
  $MsgRefresh = "请在 Codex 打开 Settings > Pets > Refresh，再选择「菲比啾比」。"
  $MsgUpdate = "下次更新只需重新执行同一行命令。啾比！"
} else {
  $ManifestPath = "pet/pet.json"
  $PetName = "Phoebe Chubby"
  $LocaleName = "English"
  $MsgDownloading = "Downloading Phoebe Chubby..."
  $MsgBackup = "The previous version was backed up outside the Pets scan folder."
  $MsgMigrated = "Legacy backups were moved outside the Pets folder to prevent duplicate pets."
  $MsgInstalled = "Phoebe Chubby is installed."
  $MsgRefresh = "In Codex, open Settings > Pets > Refresh, then choose Phoebe Chubby."
  $MsgUpdate = "Run the same command again whenever you want to update. Chubby!"
}

try {
  New-Item -ItemType Directory -Force -Path $StagePet, $PetsDir | Out-Null
  Write-Host $MsgDownloading

  Invoke-WebRequest "$BaseUrl/$ManifestPath" -OutFile (Join-Path $StagePet "pet.json")
  Invoke-WebRequest "$BaseUrl/pet/spritesheet.webp" -OutFile (Join-Path $StagePet "spritesheet.webp")
  Invoke-WebRequest "$BaseUrl/checksums.txt" -OutFile (Join-Path $TempDir "checksums.txt")

  $Expected = @{}
  foreach ($Line in Get-Content (Join-Path $TempDir "checksums.txt")) {
    if ($Line -match '^([0-9a-fA-F]{64})\s+\*?(.+)$') {
      $Expected[$Matches[2]] = $Matches[1].ToLowerInvariant()
    }
  }

  $FilesToVerify = @(
    @{ Source = $ManifestPath; Local = (Join-Path $StagePet "pet.json") },
    @{ Source = "pet/spritesheet.webp"; Local = (Join-Path $StagePet "spritesheet.webp") }
  )
  foreach ($File in $FilesToVerify) {
    $Actual = (Get-FileHash $File.Local -Algorithm SHA256).Hash.ToLowerInvariant()
    if (-not $Expected.ContainsKey($File.Source) -or $Actual -ne $Expected[$File.Source]) {
      throw "SHA-256 verification failed for $($File.Source)"
    }
  }
  Get-Content (Join-Path $StagePet "pet.json") -Raw | ConvertFrom-Json | Out-Null

  $LegacyMigrated = $false
  foreach ($LegacyDir in Get-ChildItem -LiteralPath $PetsDir -Directory -Filter "$PetId.backup.*") {
    New-Item -ItemType Directory -Force -Path $BackupRoot | Out-Null
    $LegacyDestination = Join-Path $BackupRoot $LegacyDir.Name
    if (Test-Path $LegacyDestination) {
      $LegacyDestination = Join-Path $BackupRoot ($LegacyDir.Name + "." + [guid]::NewGuid().ToString("N"))
    }
    Move-Item -LiteralPath $LegacyDir.FullName -Destination $LegacyDestination
    $LegacyMigrated = $true
  }
  if ($LegacyMigrated) { Write-Host $MsgMigrated }

  if (Test-Path $PetDir) {
    if ($NoBackup) {
      Move-Item $PetDir $OldDir
      $PreviousMovedTo = $OldDir
    } else {
      New-Item -ItemType Directory -Force -Path $BackupRoot | Out-Null
      Move-Item $PetDir $BackupDir
      $PreviousMovedTo = $BackupDir
      Write-Host $MsgBackup
    }
  }

  Move-Item $StagePet $PetDir
  Write-Host ""
  Write-Host "$MsgInstalled ($LocaleName`: $PetName)"
  Write-Host $MsgRefresh
  Write-Host $MsgUpdate
} catch {
  if ($PreviousMovedTo -and (Test-Path $PreviousMovedTo) -and -not (Test-Path $PetDir)) {
    Move-Item $PreviousMovedTo $PetDir
  }
  throw
} finally {
  if (Test-Path $TempDir) { Remove-Item -Recurse -Force $TempDir }
}
