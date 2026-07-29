#!/bin/bash
set -euo pipefail
[[ $EUID == 0 ]] || {{ echo 'Run as root' >&2; exit 1; }}
UNIT=tg-bot-lab.service
DROP=/etc/systemd/system/$UNIT.d
ENV=/etc/tg-bot/tg-bot-lab.env
echo 'Changing lab only: STARTUP_FAIL'
cp -a $ENV ${ENV}.lab-backup 2>/dev/null || true; sed -i -E 's/^STARTUP_FAIL=.*/STARTUP_FAIL=true/' $ENV
systemctl daemon-reload
systemctl restart $UNIT || true
