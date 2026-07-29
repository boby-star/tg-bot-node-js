#!/bin/bash
set -euo pipefail
[[ $EUID == 0 ]] || {{ echo 'Run as root' >&2; exit 1; }}
UNIT=tg-bot-lab.service
DROP=/etc/systemd/system/$UNIT.d
ENV=/etc/tg-bot/tg-bot-lab.env
echo 'Changing lab only: event loop block'
cp -a $ENV ${ENV}.lab-backup 2>/dev/null || true; sed -i -E 's/^DEMO_MODE=.*/DEMO_MODE=true/' $ENV
systemctl daemon-reload
/usr/bin/time -f 'elapsed=%e' curl -fsS 'http://127.0.0.1:3001/demo/cpu-block?ms=5000' &
sleep 0.2
/usr/bin/time -f 'health elapsed=%e' curl -fsS http://127.0.0.1:3001/healthz
wait
