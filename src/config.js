const boolean = (v) => v === 'true';
const port = (v, name) => { const n=Number(v); if (!Number.isInteger(n)||n<1||n>65535) throw new Error(`${name} must be a valid port`); return n; };
export function loadConfig(env=process.env) {
 const mode=env.BOT_MODE||'polling'; if(!['polling','webhook','offline'].includes(mode)) throw new Error('BOT_MODE must be polling, webhook, or offline');
 const adminIds=(env.BOT_ADMIN_IDS||'').split(',').filter(Boolean).map(v=>{if(!/^\d+$/.test(v.trim())) throw new Error('BOT_ADMIN_IDS must contain numeric comma-separated IDs'); return Number(v.trim());});
 const config={mode,token:env.BOT_TOKEN||'',adminIds,demoMode:boolean(env.DEMO_MODE),healthHost:env.HEALTH_HOST||'127.0.0.1',healthPort:port(env.HEALTH_PORT||'3000','HEALTH_PORT'),webhookPublicUrl:env.WEBHOOK_PUBLIC_URL||'',webhookPath:env.WEBHOOK_PATH||'/telegram-webhook',webhookSecret:env.WEBHOOK_SECRET||'',webhookHost:env.WEBHOOK_HOST||'127.0.0.1',webhookPort:port(env.WEBHOOK_PORT||'3000','WEBHOOK_PORT'),logLevel:env.LOG_LEVEL||'info',startupFail:boolean(env.STARTUP_FAIL)};
 if(mode!=='offline'&&!config.token) throw new Error('BOT_TOKEN is required in polling and webhook modes');
 if(mode==='webhook'&&(!config.webhookPublicUrl||!config.webhookSecret)) throw new Error('WEBHOOK_PUBLIC_URL and WEBHOOK_SECRET are required in webhook mode');
 if(config.healthHost!=='127.0.0.1'||config.webhookHost!=='127.0.0.1') throw new Error('Training servers must bind to 127.0.0.1'); return config;
}
