/**
 * One-time script to set PlasGate secrets in Firebase (Google Secret Manager).
 * Run from project root:
 *   node functions/scripts/set-plasgate-secrets.cjs
 * with env vars set:
 *   PLASGATE_PRIVATE_KEY=your_private_key
 *   PLASGATE_SECRET=your_secret
 * Or on Windows PowerShell (use single quotes for secret to avoid $ expansion):
 *   $env:PLASGATE_PRIVATE_KEY='...'; $env:PLASGATE_SECRET='...'; node functions/scripts/set-plasgate-secrets.cjs
 */
const { execSync } = require("child_process");
const fs = require("fs");
const path = require("path");
const os = require("os");

const projectRoot = path.resolve(__dirname, "../..");

function setSecret(name, value) {
  if (!value || typeof value !== "string") {
    console.error(`Missing or invalid ${name}. Set environment variable PLASGATE_${name === "PLASGATE_PRIVATE_KEY" ? "PRIVATE_KEY" : "SECRET"}.`);
    process.exit(1);
  }
  const tmpFile = path.join(os.tmpdir(), `plasgate-${name}-${Date.now()}.tmp`);
  try {
    fs.writeFileSync(tmpFile, value, "utf8");
    execSync(`firebase functions:secrets:set ${name} --data-file="${tmpFile}"`, {
      cwd: projectRoot,
      stdio: "inherit",
    });
    console.log(`Set ${name} successfully.`);
  } finally {
    try {
      fs.unlinkSync(tmpFile);
    } catch (_) {}
  }
}

const privateKey = process.env.PLASGATE_PRIVATE_KEY;
const secret = process.env.PLASGATE_SECRET;
const adminPhone = process.env.ADMIN_SMS_PHONE;

if (!privateKey && !secret && !adminPhone) {
  console.error("Set PLASGATE_PRIVATE_KEY, PLASGATE_SECRET, and optionally ADMIN_SMS_PHONE, then run this script from project root.");
  process.exit(1);
}

if (privateKey) setSecret("PLASGATE_PRIVATE_KEY", privateKey);
if (secret) setSecret("PLASGATE_SECRET", secret);
if (adminPhone !== undefined && adminPhone !== "") setSecret("ADMIN_SMS_PHONE", adminPhone);
console.log("Secrets set. Deploy: firebase deploy --only functions");
