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

declare -A zh=()
if [[ -d ./zh-cn ]]; then
    while IFS= read -r -d '' f; do
        zh["${f#./zh-cn/}"]=1
    done < <(find ./zh-cn -type f -print0)
fi

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

overlaid=0
for rel in "${!zh[@]}"; do
    [[ -f "./$rel" ]] && cmp -s -- "../zh-cn/$rel" "./$rel" && continue
    install -D -p "../zh-cn/$rel" "./$rel"
    overlaid=$((overlaid + 1))
done
echo "overlaid ${overlaid} file(s) from zh-cn/"

packwiz refresh --build

packwiz cf export -o "${OUT}-client-zh_cn.zip" -s client

packwiz refresh

echo "===Client==="
ls -lh "${OUT}-client.zip"
ls -lh "${OUT}-client-zh_cn.zip"
echo "===Server==="
ls -lh "${OUT}-server.zip"

cd ..