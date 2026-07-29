import { telegram } from './tg-api.mjs';await telegram('deleteWebhook',{drop_pending_updates:false});console.log('Webhook deleted.');
