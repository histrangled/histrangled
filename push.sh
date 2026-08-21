#!/usr/bin/env bash
# Pusht den Hexo-Blog nach https://github.com/histrangled/histrangled
# Nutzung:  bash push.sh            (HTTPS)
#           bash push.sh ssh        (SSH-Remote statt HTTPS)
set -euo pipefail

REPO_HTTPS="https://github.com/histrangled/histrangled.git"
REPO_SSH="git@github.com:histrangled/histrangled.git"
REMOTE="$REPO_HTTPS"
[[ "${1:-}" == "ssh" ]] && REMOTE="$REPO_SSH"

# Im Ordner mit _config.yml ausführen
if [[ ! -f _config.yml || ! -d source ]]; then
  echo "Fehler: bitte im entpackten hexo-blog/-Ordner ausfuehren." >&2
  exit 1
fi

# Sicherheitsnetz: nichts Gebautes committen
rm -rf public db.json

[[ -d .git ]] || git init -q
git add -A
git commit -q -m "Hexo blog + GitHub Pages workflow" || echo "Nichts Neues zu committen."
git branch -M main

if git remote get-url origin >/dev/null 2>&1; then
  git remote set-url origin "$REMOTE"
else
  git remote add origin "$REMOTE"
fi

git push -u origin main

echo
echo "Push fertig. Jetzt noch GitHub Pages auf 'GitHub Actions' stellen:"
echo "  https://github.com/histrangled/histrangled/settings/pages"
echo "Danach: https://github.com/histrangled/histrangled/actions"
echo "Live in ca. 1-2 Minuten: https://histrangled.github.io/histrangled/"

# Optional automatisch, falls GitHub CLI installiert und eingeloggt ist:
if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
  echo
  echo "GitHub CLI gefunden - setze Pages-Source auf GitHub Actions ..."
  gh api -X POST repos/histrangled/histrangled/pages \
     -f "build_type=workflow" >/dev/null 2>&1 \
  || gh api -X PUT repos/histrangled/histrangled/pages \
     -f "build_type=workflow" >/dev/null 2>&1 \
  || echo "Konnte Pages nicht automatisch setzen - bitte manuell in den Settings."
fi
