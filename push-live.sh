#!/usr/bin/env bash
# Origin: created by Claude at Brett's request (Japan Day Board, 2026-11-22).
#
# One-shot: point this repo at Brett's new GitHub repo and push it.
#   ./push-live.sh <github-username>            (assumes repo name japan-day-board)
#   ./push-live.sh <github-username> <repo>
#
# The first push will pop a browser window from Git Credential Manager asking to
# authorise GitHub. One click, because Chrome is already signed in.

set -euo pipefail

USER_NAME="${1:-}"
REPO="${2:-japan-day-board}"
if [ -z "$USER_NAME" ]; then
  echo "usage: ./push-live.sh <github-username> [repo-name]" >&2
  exit 2
fi

URL="https://github.com/${USER_NAME}/${REPO}.git"
cd "$(dirname "$0")"

echo "repo        : $URL"
echo "commits     : $(git rev-list --count HEAD)"
echo "files       : $(git ls-files | wc -l)"

if git remote | grep -q '^origin$'; then
  git remote set-url origin "$URL"
else
  git remote add origin "$URL"
fi

git branch -M main
echo
echo "pushing..."
git push -u origin main

echo
echo "pushed. now turn Pages on, one toggle:"
echo "  https://github.com/${USER_NAME}/${REPO}/settings/pages"
echo "  Source: Deploy from a branch | Branch: main | Folder: / (root) | Save"
echo
echo "about a minute later the board is live at:"
echo "  https://${USER_NAME}.github.io/${REPO}/"
echo "  pin check: https://${USER_NAME}.github.io/${REPO}/check-pins.html"
