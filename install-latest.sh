#!/bin/zsh
# 下载本仓库最新 release 的去广告 dmg 并安装到 /Applications (需要 gh CLI 已登录)
set -euo pipefail

REPO=vcxzvfe/animeko-noad
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

gh release download --repo "$REPO" --pattern '*.dmg' --dir "$TMP"
DMG=$(ls "$TMP"/*.dmg | head -1)

MNT=$(hdiutil attach -nobrowse -readonly "$DMG" | awk -F'\t' '/\/Volumes\//{print $NF}' | tail -1)
trap 'hdiutil detach "$MNT" -quiet 2>/dev/null; rm -rf "$TMP"' EXIT

osascript -e 'tell application "Ani" to quit' 2>/dev/null || true
sleep 2
rm -rf /Applications/Ani.app
ditto "$MNT/Ani.app" /Applications/Ani.app
xattr -dr com.apple.quarantine /Applications/Ani.app 2>/dev/null || true

echo "✅ 已安装 $(basename "$DMG") 到 /Applications/Ani.app"
