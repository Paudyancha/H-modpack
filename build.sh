#!/usr/bin/env bash
set -euo pipefail

command -v packwiz >/dev/null 2>&1 || { echo "Packwiz not found" >&2; exit 1; }
command -v git >/dev/null 2>&1 || { echo "Git not found" >&2; exit 1; }
[[ -f pack.toml ]] || { echo "no pack.toml：$PWD" >&2; exit 1; }

PACK_NAME="${PACK_NAME:-Mod Pack}"
PACK_VERSION="${PACK_VERSION:-dev}"

SLUG="${PACK_NAME// /_}"
OUT="./dist/${SLUG}-${PACK_VERSION}"

SCRATCH="$(mktemp -d)"
trap 'rm -rf "$SCRATCH"' EXIT
export GIT_DIR="$SCRATCH/git" GIT_WORK_TREE="$PWD"
git init -q

mkdir -p ./build/dist

declare -A want=()
while IFS= read -r -d '' f; do
    case "$f" in build/*|dist/*) continue ;; esac
    want["$f"]=1
done < <(git -c core.excludesFile="$PWD/.packwizignore" -c core.quotepath=false \
             ls-files -z --others --exclude-standard -- .)
unset GIT_DIR GIT_WORK_TREE

for rel in "${!want[@]}"; do
    dst="./build/$rel"
    [[ -f $dst ]] && cmp -s -- "$rel" "$dst" && continue
    mkdir -p "./build/$(dirname "$rel")"
    cp -p -- "$rel" "$dst"
done

deleted=0
while IFS= read -r -d '' p; do
    rel="${p#./build/}"
    if [[ -z ${want[$rel]:-} ]]; then
        rm -f -- "$p"
        deleted=$((deleted + 1))
    fi
done < <(find ./build -path ./build/dist -prune -o -type f -print0)
echo "removed ${deleted} stale file(s)"

cd build

packwiz refresh --build

packwiz cf export -o "${OUT}-client.zip" -s client
packwiz cf export -o "${OUT}-server.zip" -s server

packwiz refresh

cd "$(dirname "$0")"

echo "===Client==="
ls -lh "${OUT}-client.zip"
echo "===Server==="
ls -lh "${OUT}-server.zip"