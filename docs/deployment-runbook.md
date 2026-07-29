# Deployment runbook
1. Виконайте `scripts/preflight.sh`; потрібен Node 24.x. Порівняйте `readlink -f "$(command -v node)"` з ExecStart.
2. `sudo scripts/deploy.sh`; відредагуйте `/etc/tg-bot/tg-bot.env` (640 root:tgbot), не показуйте файл на екрані.
3. Polling: token + `BOT_MODE=polling`; `systemctl enable --now tg-bot`; `scripts/verify.sh`.
4. Webhook: DNS/TLS/nginx, URL/path/secret; зупиніть polling; зареєструйте webhook зі змінних environment; запустіть webhook mode. Ніколи не запускайте два poller з одним token.
