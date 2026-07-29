#!/bin/bash
set -euo pipefail
[[ $EUID == 0 ]] || {{ echo 'Run as root' >&2; exit 1; }}
UNIT=tg-bot-lab.service
DROP=/etc/systemd/system/$UNIT.d
ENV=/etc/tg-bot/tg-bot-lab.env
echo 'Changing lab only: WorkingDirectory'
mkdir -p $DROP; printf '[Service]\nWorkingDirectory=/nonexistent/tg-bot-lab\n' > $DROP/fault.conf
systemctl daemon-reload
systemctl restart $UNIT || true
