#!/bin/bash
set -euo pipefail
[[ $EUID == 0 ]] || { echo 'Run as root' >&2; exit 1; }
ROOT=$(cd "$(dirname "$0")/.." && pwd); "$ROOT/scripts/preflight.sh"; NODE=$(readlink -f "$(command -v node)")
id tgbot &>/dev/null || useradd --system --home /opt/tg-bot --shell /usr/sbin/nologin tgbot
install -d -o tgbot -g tgbot /opt/tg-bot /etc/tg-bot
rsync -a --delete --exclude=node_modules --exclude=.git --exclude=.env "$ROOT/" /opt/tg-bot/
(cd /opt/tg-bot && npm ci --omit=dev); chown -R tgbot:tgbot /opt/tg-bot
install -m 640 -o root -g tgbot -C systemd/tg-bot.env.example /etc/tg-bot/tg-bot.env
install -m 640 -o root -g tgbot -C systemd/tg-bot-lab.env.example /etc/tg-bot/tg-bot-lab.env
for u in tg-bot tg-bot-lab; do sed "s#ExecStart=/usr/bin/node#ExecStart=$NODE#" "systemd/$u.service" > "/etc/systemd/system/$u.service"; done
systemctl daemon-reload
echo 'Edit /etc/tg-bot/tg-bot.env, then: systemctl enable --now tg-bot'; echo 'Lab: systemctl enable --now tg-bot-lab'
