#!/usr/bin/env node
/**
 * Generates favicon.ico, favicon-16x16.png, and favicon-32x32.png from web/favicon.png.
 * Run: node scripts/generate-favicons.js
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import sharp from 'sharp';
import pngToIco from 'png-to-ico';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

async function main() {
  const webDir = path.join(__dirname, '..', 'web');
  const src = path.join(webDir, 'favicon.png');

  if (!fs.existsSync(src)) {
    console.error('Source favicon.png not found in web/');
    process.exit(1);
  }

  const sizes = [16, 32];
  const pngPaths = [];

  for (const size of sizes) {
    const outPath = path.join(webDir, `favicon-${size}x${size}.png`);
    await sharp(src)
      .resize(size, size)
      .png()
      .toFile(outPath);
    console.log('Created', outPath);
    pngPaths.push(outPath);
  }

  const ico = await pngToIco(pngPaths);
  fs.writeFileSync(path.join(webDir, 'favicon.ico'), ico);
  console.log('Created web/favicon.ico');
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
