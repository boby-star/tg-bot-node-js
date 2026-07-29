import test from 'node:test';import assert from 'node:assert/strict';import { loadConfig } from '../src/config.js';
test('offline works without token and parses admins',()=>{const c=loadConfig({BOT_MODE:'offline',BOT_ADMIN_IDS:'12,34'});assert.deepEqual(c.adminIds,[12,34]);assert.equal(c.healthPort,3000)});
test('polling requires token',()=>assert.throws(()=>loadConfig({BOT_MODE:'polling'}),/BOT_TOKEN/));
test('rejects public health bind',()=>assert.throws(()=>loadConfig({BOT_MODE:'offline',HEALTH_HOST:'0.0.0.0'}),/127/));
