# Rollback
До deployment архівуйте попередній release/unit. Зупиніть unit, відновіть узгоджені application files **разом із package-lock.json**, виконайте `npm ci --omit=dev`, відновіть unit/env permissions, `daemon-reload`, start і `verify.sh`. Не використовуйте `npm update`. Lab fix scripts відновлюють свої backups/drop-ins.
