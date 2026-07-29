#!/bin/bash
set -euo pipefail
[[ $EUID == 0 ]] || {{ echo 'Run as root' >&2; exit 1; }}
UNIT=tg-bot-lab.service
DROP=/etc/systemd/system/$UNIT.d
ENV=/etc/tg-bot/tg-bot-lab.env
echo 'Rolling back lab fault'
if [[ -f /opt/tg-bot/src/index.js.lab-backup ]]; then cp -a /opt/tg-bot/src/index.js.lab-backup /opt/tg-bot/src/index.js; else chmod 644 /opt/tg-bot/src/index.js; chown tgbot:tgbot /opt/tg-bot/src/index.js; fi
systemctl daemon-reload
systemctl reset-failed $UNIT || true
systemctl restart $UNIT
