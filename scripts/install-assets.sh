#!/bin/sh
# Installs what the blue theme needs outside of this repo (no sudo, everything goes to $HOME):
#   - Play font                      -> ~/.local/share/fonts/play
#   - ACYLS icon pack                -> ~/.icons/ACYLS
#   - ACYLS recolored to theme teal  -> ~/.icons/ACYLS-steel   (used by menu and notifications)
# Safe to run again: existing files are kept.
set -e

FONT_DIR="$HOME/.local/share/fonts/play"
ICONS="$HOME/.icons"

echo "== Play font"
mkdir -p "$FONT_DIR"
for f in Play-Regular.ttf Play-Bold.ttf; do
	[ -f "$FONT_DIR/$f" ] || curl -fsSL -o "$FONT_DIR/$f" "https://github.com/google/fonts/raw/main/ofl/play/$f"
done
fc-cache -f "$FONT_DIR" >/dev/null

echo "== ACYLS icons"
mkdir -p "$ICONS"
[ -d "$ICONS/ACYLS" ] || git clone -q --depth 1 https://github.com/worron/ACYLS.git "$ICONS/ACYLS"

echo "== ACYLS-steel (recolored copy)"
if [ ! -d "$ICONS/ACYLS-steel" ]; then
	cp -a "$ICONS/ACYLS" "$ICONS/ACYLS-steel"
	python3 - "$ICONS/ACYLS-steel" <<'PY'
import os, sys
root = sys.argv[1]
old = '<stop offset="100%" style="stop-color:#A0A0A0;stop-opacity:1.000000"/>'
new = ('<stop offset="0%" style="stop-color:#8CC3D4;stop-opacity:1.000000"/>'
       '<stop offset="100%" style="stop-color:#3F92AE;stop-opacity:1.000000"/>')
n = 0
for d, _, files in os.walk(os.path.join(root, "scalable")):
    for f in files:
        p = os.path.join(d, f)
        if not f.endswith(".svg") or os.path.islink(p):
            continue
        s = open(p, encoding="utf-8", errors="surrogateescape").read()
        if old in s:
            open(p, "w", encoding="utf-8", errors="surrogateescape").write(s.replace(old, new))
            n += 1
print("recolored", n, "icons")
PY
	sed -i 's/^Name=.*/Name=ACYLS-steel/' "$ICONS/ACYLS-steel/index.theme"
fi

echo "== Done. System packages the config uses (install with apt if missing):"
for p in lm-sensors:sensors pulseaudio-utils:pactl copyq:copyq numlockx:numlockx; do
	pkg=${p%%:*}; bin=${p##*:}
	command -v "$bin" >/dev/null && echo "   ok       $pkg" || echo "   missing  $pkg   (sudo apt install $pkg)"
done
