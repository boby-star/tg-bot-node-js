import test from 'node:test';import assert from 'node:assert/strict';import { setSecrets,redact } from '../src/logger.js';
test('redacts every known secret',()=>{setSecrets(['token123','secret456']);const out=redact({a:'token123',b:'secret456'});assert.equal(out.includes('token123'),false);assert.match(out,/\[REDACTED\]/)});
