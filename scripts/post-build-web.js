#!/usr/bin/env node
/**
 * Post-build script for Flutter web: inject cache-busting into index.html.
 * Run after: flutter build web
 * Ensures each deployment loads fresh flutter_bootstrap.js instead of cached old version.
 */

const fs = require('fs');
const path = require('path');

const buildDir = path.join(__dirname, '..', 'build', 'web');
const bootstrapPath = path.join(buildDir, 'flutter_bootstrap.js');
const indexPath = path.join(buildDir, 'index.html');

if (!fs.existsSync(bootstrapPath)) {
  console.error('flutter_bootstrap.js not found. Run "flutter build web" first.');
  process.exit(1);
}
if (!fs.existsSync(indexPath)) {
  console.error('index.html not found. Run "flutter build web" first.');
  process.exit(1);
}

const bootstrapContent = fs.readFileSync(bootstrapPath, 'utf8');
const match = bootstrapContent.match(/serviceWorkerVersion:\s*"(\d+)"/);
const version = match ? match[1] : String(Math.floor(Date.now() / 1000));

let indexContent = fs.readFileSync(indexPath, 'utf8');
const oldScript = 'src="flutter_bootstrap.js"';
const newScript = `src="flutter_bootstrap.js?v=${version}"`;

if (indexContent.includes(oldScript)) {
  indexContent = indexContent.replace(oldScript, newScript);
  fs.writeFileSync(indexPath, indexContent);
  console.log(`Post-build: injected cache-busting v=${version} into index.html`);
} else {
  console.warn('flutter_bootstrap.js script tag not found in expected format.');
}

const versionJsonPath = path.join(buildDir, 'version.json');
if (fs.existsSync(versionJsonPath)) {
  const ver = JSON.parse(fs.readFileSync(versionJsonPath, 'utf8'));
  console.log(`Build version: ${ver.version}+${ver.build_number} (cache key: ${version})`);
}
