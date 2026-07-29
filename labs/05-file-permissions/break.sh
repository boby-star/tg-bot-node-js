#!/bin/bash
set -euo pipefail
[[ $EUID == 0 ]] || {{ echo 'Run as root' >&2; exit 1; }}
UNIT=tg-bot-lab.service
DROP=/etc/systemd/system/$UNIT.d
ENV=/etc/tg-bot/tg-bot-lab.env
echo 'Changing lab only: file permissions'
cp -a /opt/tg-bot/src/index.js /opt/tg-bot/src/index.js.lab-backup 2>/dev/null || true; chmod 600 /opt/tg-bot/src/index.js; chown root:root /opt/tg-bot/src/index.js
systemctl daemon-reload
systemctl restart $UNIT || true
