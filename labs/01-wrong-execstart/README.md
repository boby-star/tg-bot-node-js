# ExecStart
Expected: `203/EXEC`. Run `sudo ./break.sh`, inspect without premature repair via `sudo ./observe.sh`, then `sudo ./fix.sh && sudo ./verify.sh`. Backup/drop-in is retained or removed during rollback. Only `tg-bot-lab.service` is touched.
