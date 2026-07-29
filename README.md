# Node.js Telegram bot + systemd training lab

Навчальний ESM-проєкт показує один Node.js-процес, event loop, відтворювані npm-залежності, Telegram updates, polling/webhook, localhost health API, JSON-журнал та ізольовані systemd fault labs.

## Архітектура й вимоги
`src/index.js` запускає Telegraf у `polling`/`webhook` або лише HTTP у `offline`. Polling виконує вихідні HTTPS-запити й не потребує DNS; webhook приймає вхідний HTTPS через nginx, DNS/TLS і перевіряє secret. Debian/Ubuntu, systemd, Node.js 24 LTS, npm, amd64/arm64; Docker/PM2/БД не потрібні.

## Локально
```bash
./scripts/preflight.sh
npm ci
cp .env.example .env
BOT_MODE=offline HEALTH_PORT=3000 node src/index.js
curl -fsS http://127.0.0.1:3000/healthz
curl -fsS http://127.0.0.1:3000/readyz
```
Завершіть `Ctrl-C` (SIGINT). Для Telegram створіть бота у **@BotFather**, скопіюйте token лише до локального `.env` (ніколи в Git/CLI), встановіть `BOT_MODE=polling`, запустіть `node --env-file=.env src/index.js`. `/whoami` поверне ID; додайте його в `BOT_ADMIN_IDS=123,456`. Public commands: `/start`, `/help`, `/ping`, `/status`, `/whoami`, `/asyncdemo`; admin-only `/cpudemo`, `/crashdemo` потребують `DEMO_MODE=true`.

## systemd deployment
```bash
node --version; npm --version; command -v node; command -v npm; systemctl --version
command -v node; readlink -f "$(command -v node)"
sudo ./scripts/deploy.sh
sudoedit /etc/tg-bot/tg-bot.env
sudo systemctl enable --now tg-bot
sudo /opt/tg-bot/scripts/verify.sh
```
Unit-приклад містить `/usr/bin/node`; `deploy.sh` замінює його на фактичний абсолютний шлях. Token зберігається тільки в root-owned `EnvironmentFile`, не unit.

Директиви: `User`/`Group` знижують привілеї; `WorkingDirectory` визначає cwd; `EnvironmentFile` дає конфігурацію; `ExecStart` задає runtime та entrypoint; `Restart=on-failure` відновлює crash; `RestartSec` стримує loop; `KillSignal=SIGTERM` запускає graceful shutdown; `TimeoutStopSec` обмежує його; `StandardOutput`/`StandardError=journal` направляють JSON у journald; `WantedBy` підключає unit до normal multi-user boot.

## Режими, webhook і логи
Polling є типовим. Для webhook спочатку зупиніть polling, задайте public URL/path/secret, налаштуйте `nginx/tg-bot.conf.example`, виконайте `npm run telegram:set-webhook`, змініть `BOT_MODE=webhook`, потім запустіть один instance. Повернення: зупинити webhook instance, `npm run telegram:delete-webhook`, змінити mode на polling, запустити. Token читається з environment, не аргументу. `npm run telegram:info` безпечно показує лише webhook metadata.
```bash
journalctl -u tg-bot -f -o cat
curl -fsS http://127.0.0.1:3000/status
```

## Troubleshooting, labs, rollback
Спочатку збирайте дані без restart: `sudo ./scripts/triage.sh`; потім дивіться `docs/troubleshooting-runbook.md`. Небезпечні labs працюють **лише** з `tg-bot-lab.service` на 3001: `cd labs/01-wrong-execstart && sudo ./break.sh`, потім `observe.sh`, `fix.sh`, `verify.sh`. Rollback описано в `docs/rollback.md`. Повне видалення: `sudo scripts/cleanup.sh`, перевірити backups, потім вручну `sudo rm -rf /opt/tg-bot /etc/tg-bot`; користувача видаляти лише після перевірки інших залежностей.
