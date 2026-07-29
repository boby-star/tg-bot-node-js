# Troubleshooting runbook
Зберіть `scripts/triage.sh` **до restart**. Рухайтесь systemd → runtime → application → configuration → network.

| Ознака | Observe | Причина/виправлення | Recovery |
|---|---|---|---|
| 203/EXEC | `systemctl show tg-bot-lab -p ExecStart` | неправильний абсолютний node; виправити drop-in | daemon-reload, start, verify |
| CHDIR | `systemctl show ... -p WorkingDirectory` | каталог відсутній | повернути `/opt/tg-bot` |
| BOT_TOKEN required | journal | polling без token | заповнити lab env або offline |
| EADDRINUSE | `ss -lntp`, потім `ps -fp PID`, cgroup | власник 3001 | ідентифікувати, тоді прибрати blocker |
| EACCES | `namei -l`, `sudo -u tgbot test -r` | права entrypoint | відновити 0644/owner |
| NRestarts росте | `systemctl show ... -p NRestarts` | STARTUP_FAIL або crash | прибрати flag; перевірити стабільний PID |
| active, але timeout | `ps`, `top`, timed curl | event loop blocked | дочекатись hard limit ≤5s |

Після fix: `systemctl reset-failed tg-bot-lab; systemctl start tg-bot-lab`; порівняйте MainPID, `/proc/PID/exe`, readyz та journal startup. Production Telegram/manual: надішліть `/start`, `/ping`, `/status`; для crashdemo зафіксуйте PID, надішліть команду admin, перевірте `journalctl` і новий PID. Це потребує token і systemd VM.
