#!/bin/bash
set -euo pipefail
[[ $EUID == 0 ]] || {{ echo 'Run as root' >&2; exit 1; }}
UNIT=tg-bot-lab.service
DROP=/etc/systemd/system/$UNIT.d
ENV=/etc/tg-bot/tg-bot-lab.env
echo 'Rolling back lab fault'
[[ -f ${ENV}.lab-backup ]] && cp -a ${ENV}.lab-backup $ENV || sed -i -E "s/^DEMO_MODE=.*/DEMO_MODE=false/" $ENV
systemctl daemon-reload
systemctl reset-failed $UNIT || true
systemctl restart $UNIT
