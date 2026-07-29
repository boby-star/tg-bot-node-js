# Slide demo plan

П’ять live-блоків: **A 2–4 (2 хв), B 5–6 (2 хв), C 10–13 (2–3 хв), D 15–17 (3 хв), E 18–20 (2–3 хв)**; разом 10–12 хв. Інтерактивні питання: слайди 8 і 19.

## Слайд 1. Node.js для системних адміністраторів

- **Мета/на слайді:** керований Linux-процес.

- **Дія викладача, точна команда:** `systemctl status tg-bot --no-pager`.

- **Очікувано:** команда демонструє: керований Linux-процес.

- **Слухач помічає:** керований Linux-процес.

- **Fallback:** показати заздалегідь збережений JSON journal/status і пояснити ту саму причинно-наслідкову послідовність.

- **Час:** 20–30 с.

## Слайд 2. Node.js — runtime, не мова

- **Мета/на слайді:** runtime і JS entrypoint.

- **Дія викладача, точна команда:** `node --version; command -v node; systemctl show tg-bot -p ExecStart`.

- **Очікувано:** команда демонструє: runtime і JS entrypoint.

- **Слухач помічає:** runtime і JS entrypoint.

- **Fallback:** показати заздалегідь збережений JSON journal/status і пояснити ту саму причинно-наслідкову послідовність.

- **Час:** 30 с.

## Слайд 3. Технічні компоненти

- **Мета/на слайді:** V8, libuv, OpenSSL.

- **Дія викладача, точна команда:** `node -p "process.versions"`.

- **Очікувано:** команда демонструє: V8, libuv, OpenSSL.

- **Слухач помічає:** V8, libuv, OpenSSL.

- **Fallback:** показати заздалегідь збережений JSON journal/status і пояснити ту саму причинно-наслідкову послідовність.

- **Час:** 30–40 с.

## Слайд 4. Node.js-процес у Linux

- **Мета/на слайді:** PID і ресурси.

- **Дія викладача, точна команда:** `PID=$(systemctl show tg-bot -p MainPID --value); pgrep -a node; ps -o pid,ppid,user,%cpu,%mem,etime,cmd -p "$PID"; curl -s http://127.0.0.1:3000/status`.

- **Очікувано:** команда демонструє: PID і ресурси.

- **Слухач помічає:** PID і ресурси.

- **Fallback:** показати заздалегідь збережений JSON journal/status і пояснити ту саму причинно-наслідкову послідовність.

- **Час:** 40 с.

## Слайд 5. Асинхронна робота

- **Мета/на слайді:** ping не чекає timer.

- **Дія викладача, точна команда:** `Telegram: /asyncdemo; одночасно /ping`.

- **Очікувано:** команда демонструє: ping не чекає timer.

- **Слухач помічає:** ping не чекає timer.

- **Fallback:** показати заздалегідь збережений JSON journal/status і пояснити ту саму причинно-наслідкову послідовність.

- **Час:** 45–60 с.

## Слайд 6. Блокування event loop

- **Мета/на слайді:** затримка і CPU.

- **Дія викладача, точна команда:** `curl http://127.0.0.1:3000/demo/cpu-block & curl http://127.0.0.1:3000/healthz; top -p "$(systemctl show tg-bot -p MainPID --value)"`.

- **Очікувано:** команда демонструє: затримка і CPU.

- **Слухач помічає:** затримка і CPU.

- **Fallback:** показати заздалегідь збережений JSON journal/status і пояснити ту саму причинно-наслідкову послідовність.

- **Час:** 60 с.

## Слайд 7. Версія Node.js

- **Мета/на слайді:** shell/systemd можуть різнитись.

- **Дія викладача, точна команда:** `node --version; readlink -f "$(command -v node)"; PID=$(systemctl show tg-bot -p MainPID --value); readlink -f "/proc/$PID/exe"`.

- **Очікувано:** команда демонструє: shell/systemd можуть різнитись.

- **Слухач помічає:** shell/systemd можуть різнитись.

- **Fallback:** показати заздалегідь збережений JSON journal/status і пояснити ту саму причинно-наслідкову послідовність.

- **Час:** 30–40 с.

## Слайд 8. Тест про event loop

- **Мета/на слайді:** I/O wait не блокує, CPU блокує.

- **Дія викладача, точна команда:** `Спочатку голосування; потім /asyncdemo і /cpudemo`.

- **Очікувано:** команда демонструє: I/O wait не блокує, CPU блокує.

- **Слухач помічає:** I/O wait не блокує, CPU блокує.

- **Fallback:** показати заздалегідь збережений JSON journal/status і пояснити ту саму причинно-наслідкову послідовність.

- **Час:** 60 с.

## Слайд 9. npm і lock-файл

- **Мета/на слайді:** npm ci відтворює lock; не npm update.

- **Дія викладача, точна команда:** `cd /opt/tg-bot; cat package.json; ls -l package-lock.json; npm list --depth=0`.

- **Очікувано:** команда демонструє: npm ci відтворює lock; не npm update.

- **Слухач помічає:** npm ci відтворює lock; не npm update.

- **Fallback:** показати заздалегідь збережений JSON journal/status і пояснити ту саму причинно-наслідкову послідовність.

- **Час:** 40–50 с.

## Слайд 10. Перевірка за 30 секунд

- **Мета/на слайді:** read-only evidence.

- **Дія викладача, точна команда:** `sudo /opt/tg-bot/scripts/triage.sh`.

- **Очікувано:** команда демонструє: read-only evidence.

- **Слухач помічає:** read-only evidence.

- **Fallback:** показати заздалегідь збережений JSON journal/status і пояснити ту саму причинно-наслідкову послідовність.

- **Час:** 60 с.

## Слайд 11. Природа Telegram-бота

- **Мета/на слайді:** update → handler → reply.

- **Дія викладача, точна команда:** `journalctl -u tg-bot -f -o cat; потім /ping`.

- **Очікувано:** команда демонструє: update → handler → reply.

- **Слухач помічає:** update → handler → reply.

- **Fallback:** показати заздалегідь збережений JSON journal/status і пояснити ту саму причинно-наслідкову послідовність.

- **Час:** 45 с.

## Слайд 12. Update

- **Мета/на слайді:** ID/type/user/command/duration без тексту.

- **Дія викладача, точна команда:** `Telegram: /status`.

- **Очікувано:** команда демонструє: ID/type/user/command/duration без тексту.

- **Слухач помічає:** ID/type/user/command/duration без тексту.

- **Fallback:** показати заздалегідь збережений JSON journal/status і пояснити ту саму причинно-наслідкову послідовність.

- **Час:** 30–40 с.

## Слайд 13. Polling і webhook

- **Мета/на слайді:** outbound проти inbound HTTPS.

- **Дія викладача, точна команда:** `npm run telegram:info; sed -n "1,120p" nginx/tg-bot.conf.example`.

- **Очікувано:** команда демонструє: outbound проти inbound HTTPS.

- **Слухач помічає:** outbound проти inbound HTTPS.

- **Fallback:** показати заздалегідь збережений JSON journal/status і пояснити ту саму причинно-наслідкову послідовність.

- **Час:** 50–60 с.

## Слайд 14. Структура проєкту

- **Мета/на слайді:** код, scripts, units, labs.

- **Дія викладача, точна команда:** `cd /opt/tg-bot; find . -maxdepth 3 -type f | sort`.

- **Очікувано:** команда демонструє: код, scripts, units, labs.

- **Слухач помічає:** код, scripts, units, labs.

- **Fallback:** показати заздалегідь збережений JSON journal/status і пояснити ту саму причинно-наслідкову послідовність.

- **Час:** 45 с.

## Слайд 15. Від коду до production

- **Мета/на слайді:** pipeline (показати, не reinstall live).

- **Дія викладача, точна команда:** `npm ci; sudo systemctl daemon-reload; sudo systemctl restart tg-bot; sudo /opt/tg-bot/scripts/verify.sh`.

- **Очікувано:** команда демонструє: pipeline (показати, не reinstall live).

- **Слухач помічає:** pipeline (показати, не reinstall live).

- **Fallback:** показати заздалегідь збережений JSON journal/status і пояснити ту саму причинно-наслідкову послідовність.

- **Час:** 45 с.

## Слайд 16. systemd unit

- **Мета/на слайді:** unit відповідає процесу.

- **Дія викладача, точна команда:** `systemctl cat tg-bot; systemctl show tg-bot -p User -p Group -p WorkingDirectory -p ExecStart -p Restart`.

- **Очікувано:** команда демонструє: unit відповідає процесу.

- **Слухач помічає:** unit відповідає процесу.

- **Fallback:** показати заздалегідь збережений JSON journal/status і пояснити ту саму причинно-наслідкову послідовність.

- **Час:** 60 с.

## Слайд 17. Квест: manually працює

- **Мета/на слайді:** 203/EXEC через шлях.

- **Дія викладача, точна команда:** `cd /opt/tg-bot/labs/01-wrong-execstart; sudo ./break.sh; sudo ./observe.sh; sudo ./fix.sh; sudo ./verify.sh`.

- **Очікувано:** команда демонструє: 203/EXEC через шлях.

- **Слухач помічає:** 203/EXEC через шлях.

- **Fallback:** показати заздалегідь збережений JSON journal/status і пояснити ту саму причинно-наслідкову послідовність.

- **Час:** 2 хв.

## Слайд 18. Карта несправностей

- **Мета/на слайді:** systemd → runtime → app → config → network.

- **Дія викладача, точна команда:** `cd /opt/tg-bot/labs/04-port-conflict; sudo ./break.sh; sudo ./observe.sh`.

- **Очікувано:** команда демонструє: systemd → runtime → app → config → network.

- **Слухач помічає:** systemd → runtime → app → config → network.

- **Fallback:** показати заздалегідь збережений JSON journal/status і пояснити ту саму причинно-наслідкову послідовність.

- **Час:** 1.5–2 хв.

## Слайд 19. Polling чи webhook

- **Мета/на слайді:** не перемикати production.

- **Дія викладача, точна команда:** `Голосування; показати polling outbound / webhook inbound DNS+TLS+nginx`.

- **Очікувано:** команда демонструє: не перемикати production.

- **Слухач помічає:** не перемикати production.

- **Fallback:** показати заздалегідь збережений JSON journal/status і пояснити ту саму причинно-наслідкову послідовність.

- **Час:** 60 с.

## Слайд 20. Підсумок

- **Мета/на слайді:** active, PID, port, ready, logs.

- **Дія викладача, точна команда:** `sudo /opt/tg-bot/scripts/verify.sh; Telegram: /status`.

- **Очікувано:** команда демонструє: active, PID, port, ready, logs.

- **Слухач помічає:** active, PID, port, ready, logs.

- **Fallback:** показати заздалегідь збережений JSON journal/status і пояснити ту саму причинно-наслідкову послідовність.

- **Час:** 45 с.
