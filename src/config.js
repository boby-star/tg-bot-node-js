function parsePort(value) {
  const port = Number(value);
  if (!Number.isInteger(port) || port < 1 || port > 65535) throw new Error('HEALTH_PORT must be a valid port');
  return port;
}

export function loadConfig(env = process.env) {
  const mode = env.BOT_MODE || 'polling';
  if (!['polling', 'offline'].includes(mode)) throw new Error('BOT_MODE must be polling or offline');
  if (mode === 'polling' && !env.BOT_TOKEN) throw new Error('BOT_TOKEN is required in polling mode');

  const adminIds = (env.BOT_ADMIN_IDS || '').split(',').filter(Boolean).map((value) => {
    if (!/^\d+$/.test(value.trim())) throw new Error('BOT_ADMIN_IDS must contain numeric IDs');
    return Number(value.trim());
  });

  return {
    mode,
    token: env.BOT_TOKEN || '',
    adminIds,
    demoMode: env.DEMO_MODE === 'true',
    healthHost: '127.0.0.1',
    healthPort: parsePort(env.HEALTH_PORT || '3000'),
  };
}
