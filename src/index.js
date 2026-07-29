import { createBot } from './bot.js';
import { loadConfig } from './config.js';
import { startHealthServer } from './health-server.js';
import { errorFields, log, setSecrets } from './logger.js';
import { createMetrics } from './metrics.js';
import { installShutdown } from './shutdown.js';

let exiting = false;
function fatal(event, error) {
  log('error', event, errorFields(error));
  if (!exiting) {
    exiting = true;
    setTimeout(() => process.exit(1), 10);
  }
}

process.on('unhandledRejection', (error) => fatal('unhandled_rejection', error));
process.on('uncaughtException', (error) => fatal('uncaught_exception', error));

async function main() {
  const config = loadConfig();
  setSecrets([config.token]);
  const metrics = createMetrics(config.mode);
  log('info', 'startup', { pid: process.pid, nodeVersion: process.version, mode: config.mode });

  const server = await startHealthServer(config, metrics);
  let bot = null;
  if (config.mode === 'polling') {
    bot = createBot(config, metrics);
    log('info', 'telegram_initializing', { mode: config.mode });
    await bot.launch();
    log('info', 'bot_started', { pid: process.pid, mode: config.mode });
  }

  metrics.state.ready = true;
  log('info', 'application_ready', { mode: config.mode });
  installShutdown({ bot, server, metrics });
}

main().catch((error) => fatal('startup_error', error));
