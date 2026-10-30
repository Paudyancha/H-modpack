#!/usr/bin/env bash
set -euo pipefail

PACK_NAME="${PACK_NAME:-Mod Pack}"
PACK_VERSION="${PACK_VERSION:-dev}"

SLUG="${PACK_NAME// /_}"
OUT="./dist/${SLUG}-${PACK_VERSION}"

mkdir -p ./dist

packwiz refresh --build

packwiz cf export -o "${OUT}-client.zip" -s client
packwiz cf export -o "${OUT}-server.zip" -s server

packwiz refresh

echo "===Client==="
ls -lh "${OUT}-client.zip"
echo "===Server==="
ls -lh "${OUT}-server.zip"