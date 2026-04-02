#!/usr/bin/env node
/**
 * Verifies the web icon set required by web/index.html and web/manifest.json.
 *
 * Run: node scripts/verify-icons.js
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import sharp from 'sharp';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const projectRoot = path.join(__dirname, '..');
const webDir = path.join(projectRoot, 'web');
const iconsDir = path.join(webDir, 'icons');

function assertExists(p) {
  if (!fs.existsSync(p)) {
    throw new Error(`Missing required file: ${p}`);
  }
}

async function assertPngSize(p, w, h) {
  const meta = await sharp(p, { failOn: 'none' }).metadata();
  if (meta.format !== 'png') {
    throw new Error(`Expected PNG but got ${meta.format ?? 'unknown'}: ${p}`);
  }
  if (meta.width !== w || meta.height !== h) {
    throw new Error(`Wrong dimensions for ${p}: expected ${w}x${h}, got ${meta.width}x${meta.height}`);
  }
}

function reportOk(label) {
  process.stdout.write(`OK  ${label}\n`);
}

async function main() {
  // These are the on-disk targets that must exist for web bookmarks/PWA/app identity.
  const requiredFiles = [
    path.join(webDir, 'favicon.png'),
    path.join(webDir, 'favicon-16x16.png'),
    path.join(webDir, 'favicon-32x32.png'),
    path.join(webDir, 'favicon.ico'),
    path.join(webDir, 'manifest.json'),
    path.join(webDir, 'index.html'),
    path.join(iconsDir, 'Icon-192.png'),
    path.join(iconsDir, 'Icon-512.png'),
    path.join(iconsDir, 'Icon-maskable-192.png'),
    path.join(iconsDir, 'Icon-maskable-512.png'),
  ];

  for (const p of requiredFiles) assertExists(p);
  reportOk('all required files exist');

  await assertPngSize(path.join(webDir, 'favicon-16x16.png'), 16, 16);
  await assertPngSize(path.join(webDir, 'favicon-32x32.png'), 32, 32);
  await assertPngSize(path.join(webDir, 'favicon.png'), 512, 512);
  await assertPngSize(path.join(iconsDir, 'Icon-192.png'), 192, 192);
  await assertPngSize(path.join(iconsDir, 'Icon-512.png'), 512, 512);
  await assertPngSize(path.join(iconsDir, 'Icon-maskable-192.png'), 192, 192);
  await assertPngSize(path.join(iconsDir, 'Icon-maskable-512.png'), 512, 512);
  reportOk('png dimensions validated');

  // Basic content checks so links don’t drift.
  const indexHtml = fs.readFileSync(path.join(webDir, 'index.html'), 'utf8');
  const manifestJson = fs.readFileSync(path.join(webDir, 'manifest.json'), 'utf8');

  const expectedIndexRefs = [
    '/favicon-32x32.png',
    '/favicon-16x16.png',
    '/favicon.ico',
    '/favicon.png',
    '/manifest.json',
    '/icons/Icon-192.png',
    '/icons/Icon-512.png',
  ];
  const expectedManifestRefs = [
    '/icons/Icon-192.png',
    '/icons/Icon-512.png',
    '/icons/Icon-maskable-192.png',
    '/icons/Icon-maskable-512.png',
  ];

  for (const ref of expectedIndexRefs) {
    if (!indexHtml.includes(ref)) {
      throw new Error(`index.html is missing expected reference: ${ref}`);
    }
  }
  for (const ref of expectedManifestRefs) {
    if (!manifestJson.includes(ref)) {
      throw new Error(`manifest.json is missing expected reference: ${ref}`);
    }
  }
  reportOk('index.html and manifest.json references validated');

  process.stdout.write('All icon checks passed.\n');
}

main().catch((err) => {
  console.error(err?.stack ?? String(err));
  process.exit(1);
});

