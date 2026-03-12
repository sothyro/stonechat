/**
 * One-time script to set Resend secrets in Firebase (Google Secret Manager).
 * Run from project root:
 *   node functions/scripts/set-resend-secrets.cjs
 * with env vars set:
 *   RESEND_API_KEY=your_resend_api_key
 *   CONTACT_NOTIFY_EMAIL=team@yourdomain.com
 * Or on Windows PowerShell:
 *   $env:RESEND_API_KEY='re_...'; $env:CONTACT_NOTIFY_EMAIL='team@example.com'; node functions/scripts/set-resend-secrets.cjs
 */
const { execSync } = require("child_process");
const fs = require("fs");
const path = require("path");
const os = require("os");

const projectRoot = path.resolve(__dirname, "../..");

function setSecret(name, value) {
  if (!value || typeof value !== "string") {
    console.error(`Missing or invalid ${name}. Set environment variable ${name}.`);
    process.exit(1);
  }
  const tmpFile = path.join(os.tmpdir(), `resend-${name}-${Date.now()}.tmp`);
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

const resendApiKey = process.env.RESEND_API_KEY;
const contactNotifyEmail = process.env.CONTACT_NOTIFY_EMAIL;

if (!resendApiKey && !contactNotifyEmail) {
  console.error("Set RESEND_API_KEY and/or CONTACT_NOTIFY_EMAIL, then run this script from project root.");
  process.exit(1);
}

if (resendApiKey) setSecret("RESEND_API_KEY", resendApiKey);
if (contactNotifyEmail) setSecret("CONTACT_NOTIFY_EMAIL", contactNotifyEmail);
console.log("Resend secrets set. Deploy: firebase deploy --only functions");
