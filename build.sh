#!/usr/bin/env bash
set -euo pipefail

PACK_NAME="${PACK_NAME:-Mod Pack}"
PACK_VERSION="${PACK_VERSION:-dev}"

SLUG="${PACK_NAME// /_}"
OUT="./dist/${SLUG}-${PACK_VERSION}.zip"

mkdir -p ./dist

packwiz refresh

packwiz cf export -o "$OUT" -s client

ls -lh "$OUT"