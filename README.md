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
