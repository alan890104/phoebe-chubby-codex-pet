#!/usr/bin/env bash
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repo_root=$(CDPATH= cd -- "$script_dir/.." && pwd)
version=$(tr -d '[:space:]' < "$repo_root/VERSION")
dist_dir=$repo_root/dist
archive=$dist_dir/phoebe-chubby-codex-pet-v$version.zip
sum_file=$dist_dir/SHA256SUMS

mkdir -p "$dist_dir"
rm -f "$archive" "$sum_file"

(
  cd "$repo_root"
  zip -qr "$archive" \
    pet README.md README.zh-TW.md README.zh-CN.md \
    LICENSE NOTICE.md VERSION version.json CHANGELOG.md
)

if command -v shasum >/dev/null 2>&1; then
  (cd "$dist_dir" && shasum -a 256 "$(basename "$archive")" > "$(basename "$sum_file")")
else
  (cd "$dist_dir" && sha256sum "$(basename "$archive")" > "$(basename "$sum_file")")
fi

echo "Built: $archive"
echo "Checksum: $sum_file"
