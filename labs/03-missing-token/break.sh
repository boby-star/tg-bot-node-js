#!/bin/bash
set -euo pipefail
[[ $EUID == 0 ]] || {{ echo 'Run as root' >&2; exit 1; }}
UNIT=tg-bot-lab.service
DROP=/etc/systemd/system/$UNIT.d
ENV=/etc/tg-bot/tg-bot-lab.env
echo 'Changing lab only: missing BOT_TOKEN'
cp -a $ENV ${ENV}.lab-backup 2>/dev/null || true; sed -i -E 's/^BOT_MODE=.*/BOT_MODE=polling/;s/^BOT_TOKEN=.*/BOT_TOKEN=/' $ENV
systemctl daemon-reload
systemctl restart $UNIT || true
