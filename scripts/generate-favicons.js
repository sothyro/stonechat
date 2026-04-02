#!/usr/bin/env node
/**
 * Generates the complete web icon set referenced by:
 * - web/index.html (favicon.png, favicon-16x16.png, favicon-32x32.png, favicon.ico)
 * - web/manifest.json (/icons/Icon-192.png, /icons/Icon-512.png, plus maskable variants)
 *
 * Run: node scripts/generate-favicons.js
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import sharp from 'sharp';
import pngToIco from 'png-to-ico';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

function exists(p) {
  try {
    return fs.existsSync(p);
  } catch {
    return false;
  }
}

function ensureDir(dir) {
  fs.mkdirSync(dir, { recursive: true });
}

async function readMasterIcon(masterPath) {
  const inputBytes = fs.readFileSync(masterPath);
  const input = sharp(inputBytes, { failOn: 'none' });
  const meta = await input.metadata();
  if (!meta.width || !meta.height) {
    throw new Error(`Could not read image dimensions for: ${masterPath}`);
  }
  const size = Math.min(meta.width, meta.height);
  // Crop to square (center) so generated icons are consistent.
  return sharp(inputBytes, { failOn: 'none' }).extract({
    left: Math.floor((meta.width - size) / 2),
    top: Math.floor((meta.height - size) / 2),
    width: size,
    height: size,
  });
}

async function writePngSquare({ inputSquare, outPath, size }) {
  await inputSquare
    .clone()
    .resize(size, size, { fit: 'cover' })
    .png({ compressionLevel: 9, adaptiveFiltering: true })
    .toFile(outPath);
  console.log('Created', outPath);
}

async function writeMaskable({ inputSquare, outPath, size, safeAreaRatio = 0.8 }) {
  // Maskable icons should keep the core logo inside a safe area so OS/browser masks
  // (rounded squircle/circle) don't crop important details.
  const inner = Math.max(1, Math.floor(size * safeAreaRatio));
  const pad = Math.floor((size - inner) / 2);

  const innerPng = await inputSquare
    .clone()
    .resize(inner, inner, { fit: 'cover' })
    .png({ compressionLevel: 9, adaptiveFiltering: true })
    .toBuffer();

  await sharp({
    create: { width: size, height: size, channels: 4, background: { r: 0, g: 0, b: 0, alpha: 0 } },
  })
    .composite([{ input: innerPng, left: pad, top: pad }])
    .png({ compressionLevel: 9, adaptiveFiltering: true })
    .toFile(outPath);
  console.log('Created', outPath);
}

async function main() {
  const webDir = path.join(__dirname, '..', 'web');
  const webIconsDir = path.join(webDir, 'icons');

  // Master source selection (ordered fallback).
  const candidates = [
    path.join(webDir, 'favicon.png'),
    path.join(__dirname, '..', 'assets', 'icons', 'logo_png_big.png'),
    path.join(__dirname, '..', 'assets', 'icons', 'logo_with_name.png'),
  ];
  const masterPath = candidates.find((p) => exists(p));
  if (!masterPath) {
    console.error(
      [
        'No master icon found. Expected one of:',
        ...candidates.map((p) => `- ${p}`),
        '',
        'Add a master icon file (recommended: assets/icons/logo_png_big.png) or place web/favicon.png, then re-run.',
      ].join('\n'),
    );
    process.exit(1);
  }

  ensureDir(webDir);
  ensureDir(webIconsDir);

  const masterSquare = await readMasterIcon(masterPath);

  // Favicon base (referenced as /favicon.png). Keep this as a high-res square.
  const faviconPng = path.join(webDir, 'favicon.png');
  await writePngSquare({ inputSquare: masterSquare, outPath: faviconPng, size: 512 });

  // Standard favicon PNGs referenced in index.html.
  const favicon16 = path.join(webDir, 'favicon-16x16.png');
  const favicon32 = path.join(webDir, 'favicon-32x32.png');
  await writePngSquare({ inputSquare: masterSquare, outPath: favicon16, size: 16 });
  await writePngSquare({ inputSquare: masterSquare, outPath: favicon32, size: 32 });

  // favicon.ico (multi-size) for legacy/Windows bookmark surfaces.
  const ico = await pngToIco([favicon16, favicon32]);
  fs.writeFileSync(path.join(webDir, 'favicon.ico'), ico);
  console.log('Created', path.join(webDir, 'favicon.ico'));

  // PWA / Apple touch icons referenced by manifest + index.html.
  await writePngSquare({ inputSquare: masterSquare, outPath: path.join(webIconsDir, 'Icon-192.png'), size: 192 });
  await writePngSquare({ inputSquare: masterSquare, outPath: path.join(webIconsDir, 'Icon-512.png'), size: 512 });

  // Maskable variants referenced by manifest.json.
  await writeMaskable({
    inputSquare: masterSquare,
    outPath: path.join(webIconsDir, 'Icon-maskable-192.png'),
    size: 192,
    safeAreaRatio: 0.8,
  });
  await writeMaskable({
    inputSquare: masterSquare,
    outPath: path.join(webIconsDir, 'Icon-maskable-512.png'),
    size: 512,
    safeAreaRatio: 0.8,
  });
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
