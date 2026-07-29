#!/bin/bash
set -euo pipefail
[[ $EUID == 0 ]] || {{ echo 'Run as root' >&2; exit 1; }}
UNIT=tg-bot-lab.service
DROP=/etc/systemd/system/$UNIT.d
ENV=/etc/tg-bot/tg-bot-lab.env
echo 'Changing lab only: port conflict'
mkdir -p /run/tg-bot-lab; [[ -f /run/tg-bot-lab/blocker.pid ]] || { /usr/bin/node -e "require('node:http').createServer((q,s)=>s.end('lab blocker')).listen(3001,'127.0.0.1')" & echo $! > /run/tg-bot-lab/blocker.pid; }
systemctl daemon-reload
systemctl restart $UNIT || true
