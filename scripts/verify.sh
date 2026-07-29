#!/bin/bash
set -uo pipefail
fail=0
for cmd in 'systemctl is-active tg-bot' 'systemctl is-enabled tg-bot' 'systemctl show tg-bot -p MainPID' 'systemctl show tg-bot -p ExecStart' 'systemctl show tg-bot -p User' 'systemctl show tg-bot -p WorkingDirectory'; do echo "+ $cmd"; eval "$cmd" || fail=1; done
PID=$(systemctl show tg-bot -p MainPID --value 2>/dev/null); [[ $PID =~ ^[1-9][0-9]*$ ]] && readlink -f "/proc/$PID/exe" || fail=1
curl -fsS http://127.0.0.1:3000/healthz || fail=1; echo; curl -fsS http://127.0.0.1:3000/readyz || fail=1; echo
ss -lntp | grep -F ':3000' || fail=1; journalctl -u tg-bot -n 20 --no-pager; exit "$fail"
