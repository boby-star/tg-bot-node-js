import test from 'node:test';
import assert from 'node:assert/strict';
import { loadConfig } from '../src/config.js';

test('offline works without token and parses admins', () => {
  const config = loadConfig({ BOT_MODE: 'offline', BOT_ADMIN_IDS: '12,34' });
  assert.deepEqual(config.adminIds, [12, 34]);
  assert.equal(config.healthPort, 3000);
});

test('polling requires token', () => {
  assert.throws(() => loadConfig({ BOT_MODE: 'polling' }), /BOT_TOKEN/);
});

test('rejects unsupported mode', () => {
  assert.throws(() => loadConfig({ BOT_MODE: 'webhook', BOT_TOKEN: 'x' }), /BOT_MODE/);
});
