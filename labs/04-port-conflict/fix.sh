#!/bin/bash
set -euo pipefail
[[ $EUID == 0 ]] || {{ echo 'Run as root' >&2; exit 1; }}
UNIT=tg-bot-lab.service
DROP=/etc/systemd/system/$UNIT.d
ENV=/etc/tg-bot/tg-bot-lab.env
echo 'Rolling back lab fault'
if [[ -f /run/tg-bot-lab/blocker.pid ]]; then kill "$(cat /run/tg-bot-lab/blocker.pid)" 2>/dev/null || true; rm -f /run/tg-bot-lab/blocker.pid; fi
systemctl daemon-reload
systemctl reset-failed $UNIT || true
systemctl restart $UNIT
