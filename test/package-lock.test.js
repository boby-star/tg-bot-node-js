import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';

test('package lock includes safe-compare runtime dependencies', async () => {
  const lock = JSON.parse(await readFile(new URL('../package-lock.json', import.meta.url), 'utf8'));
  const packages = lock.packages;
  assert.equal(packages['node_modules/safe-compare'].dependencies['buffer-alloc'], '^1.2.0');
  assert.equal(packages['node_modules/buffer-alloc'].version, '1.2.0');
  assert.ok(packages['node_modules/buffer-alloc-unsafe']);
  assert.ok(packages['node_modules/buffer-fill']);
  assert.ok(packages['node_modules/p-finally']);
});
