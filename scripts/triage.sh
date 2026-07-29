#!/bin/bash
set -uo pipefail
redact(){ sed -E 's/(BOT_TOKEN|WEBHOOK_SECRET)=([^ ]+)/\1=[REDACTED]/g'; }
exec > >(redact) 2>&1
echo '=== READ-ONLY TG-BOT TRIAGE ==='; date -Is; hostname; uname -a; node --version; npm --version; command -v node
systemctl status tg-bot --no-pager; systemctl cat tg-bot; systemctl show tg-bot -p MainPID -p ExecStart -p User -p Group -p WorkingDirectory -p NRestarts
journalctl -u tg-bot -n 100 --no-pager; pgrep -a node; PID=$(systemctl show tg-bot -p MainPID --value 2>/dev/null); [[ $PID =~ ^[1-9] ]] && { ps -fp "$PID"; readlink -f "/proc/$PID/exe"; readlink -f "/proc/$PID/cwd"; }
ss -lntp; curl -fsS --max-time 3 http://127.0.0.1:3000/healthz; echo; curl -fsS --max-time 3 http://127.0.0.1:3000/readyz; echo; df -h; free -h
