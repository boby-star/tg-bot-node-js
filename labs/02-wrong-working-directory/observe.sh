#!/bin/bash
set -euo pipefail
[[ $EUID == 0 ]] || {{ echo 'Run as root' >&2; exit 1; }}
UNIT=tg-bot-lab.service
DROP=/etc/systemd/system/$UNIT.d
ENV=/etc/tg-bot/tg-bot-lab.env
systemctl status $UNIT --no-pager || true
systemctl cat $UNIT
systemctl show $UNIT -p ExecStart -p WorkingDirectory -p MainPID -p NRestarts
journalctl -u $UNIT -n 30 --no-pager
ss -lntp | grep ':3001' || true
PID=$(systemctl show $UNIT -p MainPID --value); [[ $PID =~ ^[1-9] ]] && { ps -fp $PID; cat /proc/$PID/cgroup; } || true
