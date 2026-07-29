#!/bin/bash
set -euo pipefail
[[ $EUID == 0 ]] || {{ echo 'Run as root' >&2; exit 1; }}
UNIT=tg-bot-lab.service
DROP=/etc/systemd/system/$UNIT.d
ENV=/etc/tg-bot/tg-bot-lab.env
echo 'Changing lab only: ExecStart'
mkdir -p $DROP; printf '[Service]\nExecStart=\nExecStart=/nonexistent/node /opt/tg-bot/src/index.js\n' > $DROP/fault.conf
systemctl daemon-reload
systemctl restart $UNIT || true
