#!/bin/bash
set -euo pipefail
[[ $EUID == 0 ]] || {{ echo 'Run as root' >&2; exit 1; }}
UNIT=tg-bot-lab.service
DROP=/etc/systemd/system/$UNIT.d
ENV=/etc/tg-bot/tg-bot-lab.env
systemctl is-active --quiet $UNIT
PID=$(systemctl show $UNIT -p MainPID --value); [[ $PID =~ ^[1-9][0-9]*$ ]]
curl -fsS http://127.0.0.1:3001/healthz; echo
curl -fsS http://127.0.0.1:3001/readyz; echo
echo "Lab recovered; PID=$PID"
