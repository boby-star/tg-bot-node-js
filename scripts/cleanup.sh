#!/bin/bash
set -euo pipefail
[[ $EUID == 0 ]] || { echo 'Run as root' >&2; exit 1; }; systemctl disable --now tg-bot tg-bot-lab 2>/dev/null || true; rm -f /etc/systemd/system/tg-bot{,-lab}.service; systemctl daemon-reload; echo 'Units removed. Review, then manually remove /opt/tg-bot and /etc/tg-bot.'
