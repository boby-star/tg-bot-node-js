# Маленький Telegram-бот для демонстрации Node.js и systemd

Проект намеренно небольшой: Telegraf polling, локальные health endpoints, JSON-логи и один systemd unit. Лабораторий, Docker, nginx, webhook и deployment-обвязки нет.

## Структура

```text
.
├── .env.example
├── package.json
├── package-lock.json
├── README.md
├── src
│   ├── index.js
│   ├── bot.js
│   ├── config.js
│   ├── health-server.js
│   ├── logger.js
│   ├── metrics.js
│   └── shutdown.js
├── systemd
│   ├── tg-bot.env.example
│   └── tg-bot.service
└── test
    ├── config.test.js
    ├── health-server.test.js
    └── logger.test.js
```

## Локальный запуск

Нужны Node.js 24.x и npm. Получите token у `@BotFather` и не добавляйте его в Git.

```bash
node --version
npm --version
npm ci
cp .env.example .env
nano .env
npm run dev
```

Проверка:

```bash
curl -fsS http://127.0.0.1:3000/healthz
curl -fsS http://127.0.0.1:3000/readyz
curl -fsS http://127.0.0.1:3000/status
```

Для запуска без Telegram укажите `BOT_MODE=offline`; token тогда не нужен.

## Ручная установка на сервер

Не используйте Node.js из `/root/.nvm`: пользователь `tgbot` не сможет выполнить его, и systemd покажет `203/EXEC`. Установите Node.js 24 системно и проверьте абсолютный путь:

```bash
command -v node
readlink -f "$(command -v node)"
```

Установка файлов из каталога репозитория:

```bash
sudo useradd --system --home /opt/tg-bot --shell /usr/sbin/nologin tgbot 2>/dev/null || true
sudo install -d -o tgbot -g tgbot /opt/tg-bot
sudo rsync -a --delete --exclude=.git --exclude=.env --exclude=node_modules ./ /opt/tg-bot/
sudo -u tgbot npm --prefix /opt/tg-bot ci --omit=dev
sudo chown -R tgbot:tgbot /opt/tg-bot

sudo install -m 640 -o root -g tgbot systemd/tg-bot.env.example /etc/tg-bot.env
sudoedit /etc/tg-bot.env

NODE_BIN=$(readlink -f "$(command -v node)")
sudo sed "s#/usr/bin/node#$NODE_BIN#" systemd/tg-bot.service | sudo tee /etc/systemd/system/tg-bot.service >/dev/null
sudo systemctl daemon-reload
sudo systemctl enable --now tg-bot
```

Если `/etc/tg-bot.env` уже содержит настоящий token, не копируйте example повторно — используйте только `sudoedit /etc/tg-bot.env`.

## Проверка и логи

```bash
systemctl status tg-bot --no-pager
systemctl show tg-bot -p MainPID -p ExecStart -p User -p WorkingDirectory
PID=$(systemctl show tg-bot -p MainPID --value)
readlink -f "/proc/$PID/exe"
curl -fsS http://127.0.0.1:3000/healthz
curl -fsS http://127.0.0.1:3000/readyz
journalctl -u tg-bot -n 30 --no-pager -o cat
```

Команды бота: `/start`, `/help`, `/ping`, `/status`, `/whoami`, `/asyncdemo`. Для `/cpudemo` и `/crashdemo` задайте `DEMO_MODE=true` и свой numeric ID в `BOT_ADMIN_IDS`, полученный через `/whoami`.

## Две частые ошибки

### `Cannot find module 'buffer-alloc'`

Эта ошибка была вызвана неполным lock-файлом в предыдущей версии проекта. Обновите репозиторий и выполните чистую установку строго из исправленного `package-lock.json`:

```bash
cd /opt/tg-bot-node-js
git pull --ff-only
rm -rf node_modules
npm ci
npm run dev
```

Не исправляйте её глобальной установкой пакета и не запускайте `npm update`.

### `status=203/EXEC` и путь `/root/.nvm/...`

Unit запускается от `tgbot`, поэтому он не может использовать runtime внутри `/root`. Самый простой вариант для уже установленного NVM Node.js — скопировать сам runtime в системный доступный путь и заменить `ExecStart`:

```bash
sudo systemctl stop tg-bot
sudo install -m 0755 "$(readlink -f "$(command -v node)")" /usr/local/bin/node
/usr/local/bin/node --version
sudo -u tgbot /usr/local/bin/node --version
sudo sed -i 's#^ExecStart=.*#ExecStart=/usr/local/bin/node /opt/tg-bot/src/index.js#' /etc/systemd/system/tg-bot.service
sudo systemctl daemon-reload
sudo systemctl reset-failed tg-bot
sudo systemctl start tg-bot
systemctl status tg-bot --no-pager
```

Для долгосрочной эксплуатации предпочтительнее установить Node.js 24 системным пакетным менеджером и указать его абсолютный путь. Перед запуском всегда проверяйте путь от имени service user:

```bash
NODE_BIN=$(readlink -f "$(command -v node)")
case "$NODE_BIN" in /root/*) echo "Нельзя использовать $NODE_BIN в unit"; exit 1;; esac
sudo -u tgbot test -x "$NODE_BIN"
```
