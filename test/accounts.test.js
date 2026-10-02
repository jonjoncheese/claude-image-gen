// Run with: node --test
// Checks the account bookkeeping that runs after a sign-in, on throwaway folders. No browser, no Google.
'use strict';
const test = require('node:test');
const assert = require('node:assert');
const fs = require('fs');
const os = require('os');
const path = require('path');

process.env.CIG_HOME = fs.mkdtempSync(path.join(os.tmpdir(), 'cig-test-'));
const { fileAccount, accounts } = require('../claude-image-gen.js');
const ACCOUNTS = path.join(process.env.CIG_HOME, 'accounts');

// A folder shaped like a just-signed-in profile.
function signedIn(name, marker) {
  const dir = path.join(ACCOUNTS, name);
  fs.mkdirSync(path.join(dir, 'profile'), { recursive: true });
  fs.writeFileSync(path.join(dir, 'profile', 'marker'), marker);
  return dir;
}

test('accounts are filed by email, the first one is active, signing in again replaces it', async () => {
  assert.deepStrictEqual(accounts(), { list: [], active: undefined });

  let r = await fileAccount(signedIn('.signing-in-1', 'one'), 'First@Example.com');
  assert.deepStrictEqual(r, { key: 'first@example.com', replaced: false });
  assert.deepStrictEqual(accounts(), { list: ['first@example.com'], active: 'first@example.com' });
  fs.writeFileSync(path.join(ACCOUNTS, 'first@example.com', 'project.txt'), 'https://flow.google.com/project/1');

  await fileAccount(signedIn('.signing-in-2', 'two'), 'second@example.com');
  assert.deepStrictEqual(accounts(), { list: ['first@example.com', 'second@example.com'], active: 'first@example.com' });

  r = await fileAccount(signedIn('.signing-in-3', 'three'), 'first@example.com');
  assert.strictEqual(r.replaced, true);
  const first = path.join(ACCOUNTS, 'first@example.com');
  assert.strictEqual(fs.readFileSync(path.join(first, 'profile', 'marker'), 'utf8'), 'three');
  assert.strictEqual(fs.readFileSync(path.join(first, 'project.txt'), 'utf8'), 'https://flow.google.com/project/1');
  assert.ok(!fs.readdirSync(ACCOUNTS).some(n => n.startsWith('.')), 'no leftover sign-in folders');
});

test.after(() => fs.rmSync(process.env.CIG_HOME, { recursive: true, force: true }));
