import { Telegraf } from 'telegraf';
import { cpuBlock } from './metrics.js';
import { errorFields, log } from './logger.js';

const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));
const mib = (bytes) => (bytes / 1024 / 1024).toFixed(1);

function isAdmin(ctx, config) {
  return config.demoMode && config.adminIds.includes(ctx.from?.id);
}

export function createBot(config, metrics) {
  const bot = new Telegraf(config.token);

  bot.use(async (ctx, next) => {
    if (!metrics.state.accepting) return;
    const started = performance.now();
    const command = ctx.message?.text?.match(/^\/(\w+)/)?.[1];
    metrics.state.active += 1;
    try {
      await next();
      metrics.state.updates += 1;
    } finally {
      metrics.state.active -= 1;
      log('info', 'update_processed', {
        updateId: ctx.update?.update_id,
        userId: ctx.from?.id,
        chatId: ctx.chat?.id,
        command,
        durationMs: Number((performance.now() - started).toFixed(2)),
      });
    }
  });

  bot.start((ctx) => ctx.reply('Training Node.js bot is online.\nUse /help to see available commands.'));
  bot.help((ctx) => ctx.reply('/start /help /ping /status /whoami /asyncdemo'));
  bot.command('ping', (ctx) => ctx.reply(`pong\ntimestamp: ${new Date().toISOString()}\npid: ${process.pid}`));
  bot.command('whoami', (ctx) => ctx.reply(`User ID: ${ctx.from?.id}\nChat ID: ${ctx.chat?.id}`));
  bot.command('status', (ctx) => {
    const status = metrics.status();
    return ctx.reply([
      `Node: ${status.nodeVersion}`,
      `PID: ${status.pid}`,
      `Uptime: ${status.uptimeSeconds}s`,
      `RSS: ${mib(status.rssBytes)} MiB`,
      `Heap: ${mib(status.heapUsedBytes)} MiB`,
      `Mode: ${status.mode}`,
      `Ready: ${status.ready}`,
      `Updates: ${status.updatesProcessed}`,
      `Errors: ${status.errors}`,
      `Event loop delay: ${status.eventLoopDelayMs} ms`,
    ].join('\n'));
  });
  bot.command('asyncdemo', async (ctx) => {
    await sleep(5000);
    await ctx.reply('Async wait finished; the event loop remained available.');
  });
  bot.command('cpudemo', async (ctx) => {
    if (!isAdmin(ctx, config)) return ctx.reply('Forbidden or demo mode is disabled.');
    cpuBlock(5000);
    return ctx.reply('CPU demo finished.');
  });
  bot.command('crashdemo', async (ctx) => {
    if (!isAdmin(ctx, config)) return ctx.reply('Forbidden or demo mode is disabled.');
    log('warn', 'demo_crash_requested', { userId: ctx.from?.id, pid: process.pid });
    await ctx.reply('Process will exit; systemd should restart it.');
    setTimeout(() => process.exit(1), 500);
  });

  bot.catch((error, ctx) => {
    metrics.state.errors += 1;
    log('error', 'telegraf_error', { ...errorFields(error), updateId: ctx.update?.update_id });
  });
  return bot;
}
