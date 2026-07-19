#!/usr/bin/env bash
set -eu

pet_id=phoebe-chubby
repo=${PHOEBE_CHUBBY_REPO:-alan890104/phoebe-chubby-codex-pet}
ref=${PHOEBE_CHUBBY_REF:-main}
base_url=${PHOEBE_CHUBBY_BASE_URL:-https://raw.githubusercontent.com/$repo/$ref}
codex_home=${CODEX_HOME:-$HOME/.codex}
pets_dir=$codex_home/pets
pet_dir=$pets_dir/$pet_id
backup_root=$codex_home/pet-backups/$pet_id
keep_backup=1

raw_locale=${PHOEBE_CHUBBY_LOCALE:-${LC_ALL:-${LC_MESSAGES:-${LANG:-en}}}}
normalized_locale=$(printf '%s' "$raw_locale" | tr '[:upper:]-' '[:lower:]_')
case "$normalized_locale" in
  zh_tw*|zh_hk*|zh_mo*|zh_hant*)
    manifest_path=pet/pet.zh-TW.json
    pet_name=菲比啾比
    locale_name=繁體中文
    msg_downloading="正在下載菲比啾比…"
    msg_backup="舊版本已備份到 Pets 掃描範圍之外。"
    msg_migrated="已將舊備份移出 Pets 資料夾，避免出現重複寵物。"
    msg_installed="菲比啾比安裝完成。"
    msg_refresh="請在 Codex 開啟 Settings > Pets > Refresh，再選擇「菲比啾比」。"
    msg_update="下次更新只要重新執行同一行指令。啾比！"
    ;;
  zh_cn*|zh_sg*|zh_hans*)
    manifest_path=pet/pet.zh-CN.json
    pet_name=菲比啾比
    locale_name=简体中文
    msg_downloading="正在下载菲比啾比…"
    msg_backup="旧版本已备份到 Pets 扫描范围之外。"
    msg_migrated="已将旧备份移出 Pets 文件夹，避免出现重复宠物。"
    msg_installed="菲比啾比安装完成。"
    msg_refresh="请在 Codex 打开 Settings > Pets > Refresh，再选择“菲比啾比”。"
    msg_update="下次更新只需重新执行同一行命令。啾比！"
    ;;
  *)
    manifest_path=pet/pet.json
    pet_name="Phoebe Chubby"
    locale_name=English
    msg_downloading="Downloading Phoebe Chubby…"
    msg_backup="The previous version was backed up outside the Pets scan folder."
    msg_migrated="Legacy backups were moved outside the Pets folder to prevent duplicate pets."
    msg_installed="Phoebe Chubby is installed."
    msg_refresh="In Codex, open Settings > Pets > Refresh, then choose Phoebe Chubby."
    msg_update="Run the same command again whenever you want to update. Chubby!"
    ;;
esac

if [ "${1:-}" = "--no-backup" ]; then
  keep_backup=0
elif [ "$#" -gt 0 ]; then
  echo "Usage: install.sh [--no-backup]" >&2
  exit 2
fi

command -v curl >/dev/null 2>&1 || { echo "curl is required." >&2; exit 1; }

tmp_dir=$(mktemp -d "${TMPDIR:-/tmp}/phoebe-chubby.XXXXXX")
cleanup() { rm -rf "$tmp_dir"; }
trap cleanup EXIT INT TERM
mkdir -p "$tmp_dir/pet" "$pets_dir"

echo "$msg_downloading"
curl -fsSL "$base_url/$manifest_path" -o "$tmp_dir/pet/pet.json"
curl -fsSL "$base_url/pet/spritesheet.webp" -o "$tmp_dir/pet/spritesheet.webp"
curl -fsSL "$base_url/checksums.txt" -o "$tmp_dir/checksums.txt"

hash_file() {
  if command -v shasum >/dev/null 2>&1; then
    shasum -a 256 "$1" | awk '{print $1}'
  elif command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$1" | awk '{print $1}'
  else
    echo "A SHA-256 checker (shasum or sha256sum) is required." >&2
    exit 1
  fi
}

verify_file() {
  source_path=$1
  local_path=$2
  expected=$(awk -v target="$source_path" '$2 == target || $2 == "*" target { print $1; exit }' "$tmp_dir/checksums.txt")
  [ -n "$expected" ] || { echo "Missing checksum for $source_path" >&2; exit 1; }
  actual=$(hash_file "$local_path")
  [ "$actual" = "$expected" ] || { echo "SHA-256 verification failed for $source_path" >&2; exit 1; }
}

verify_file "$manifest_path" "$tmp_dir/pet/pet.json"
verify_file pet/spritesheet.webp "$tmp_dir/pet/spritesheet.webp"

if command -v python3 >/dev/null 2>&1; then
  python3 -m json.tool "$tmp_dir/pet/pet.json" >/dev/null
fi

timestamp=$(date +%Y%m%d-%H%M%S)
backup_dir=$backup_root/$timestamp-$$
old_dir=$tmp_dir/previous-pet

legacy_migrated=0
for legacy_dir in "$pets_dir"/"$pet_id".backup.*; do
  [ -d "$legacy_dir" ] || continue
  mkdir -p "$backup_root"
  legacy_name=$(basename "$legacy_dir")
  legacy_destination=$backup_root/$legacy_name
  if [ -e "$legacy_destination" ]; then
    legacy_destination=$backup_root/$legacy_name.$timestamp-$$
  fi
  mv "$legacy_dir" "$legacy_destination"
  legacy_migrated=1
done
[ "$legacy_migrated" -eq 0 ] || echo "$msg_migrated"

if [ -e "$pet_dir" ]; then
  if [ "$keep_backup" -eq 1 ]; then
    mkdir -p "$backup_root"
    mv "$pet_dir" "$backup_dir"
    echo "$msg_backup"
  else
    mv "$pet_dir" "$old_dir"
  fi
fi

if ! mv "$tmp_dir/pet" "$pet_dir"; then
  echo "Install failed; restoring the previous pet." >&2
  if [ -e "$backup_dir" ]; then mv "$backup_dir" "$pet_dir"; fi
  if [ -e "$old_dir" ]; then mv "$old_dir" "$pet_dir"; fi
  exit 1
fi

echo
echo "$msg_installed ($locale_name: $pet_name)"
echo "$msg_refresh"
echo "$msg_update"
