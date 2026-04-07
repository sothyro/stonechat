# Cloud Functions – Stonechat Communications

Firebase Cloud Functions for appointments (slots, booking, PlasGate SMS) and contact form (Resend email).

## Resend (contact form email)

Set `RESEND_API_KEY` and `CONTACT_NOTIFY_EMAIL` to enable email notifications when someone submits the contact form:

```powershell
$env:RESEND_API_KEY='re_xxxxxxxx'
$env:CONTACT_NOTIFY_EMAIL='team@yourdomain.com'
node functions/scripts/set-resend-secrets.cjs
```

## PlasGate SMS setup

When a new document is created in the `appointments` collection, **3 SMS** are sent (sender **Stonechat**): (1) customer, (2) admin, (3) Stonechat business line (+85512222211).

### Required secrets

| Secret | Description |
|--------|-------------|
| `PLASGATE_PRIVATE_KEY` | Your PlasGate API private key |
| `PLASGATE_SECRET` | Your PlasGate secret (X-Secret header) |
| `ADMIN_SMS_PHONE` | Admin phone (E.164, e.g. `855XXXXXXXXX`) to receive an SMS when a booking is **created by admin** on behalf of a client. Set to `0` to disable. **Must be set at least once** (e.g. to `0`) for deploy to succeed. |

**Option A – Script (recommended)**  
From project root, set env vars and run:

```powershell
# PowerShell (use single quotes so $ in secret is not expanded)
$env:PLASGATE_PRIVATE_KEY='your_private_key'
$env:PLASGATE_SECRET='your_secret'
node functions/scripts/set-plasgate-secrets.cjs
```

**Option B – Manual**  
From project root:

```bash
firebase functions:secrets:set PLASGATE_PRIVATE_KEY
firebase functions:secrets:set PLASGATE_SECRET
```

Paste the values when prompted. Then deploy:

```bash
cd functions && npm ci && cd ..
firebase deploy --only functions
```

### Deploying only some functions (codebase prefix)

This project sets `"codebase": "default"` in [firebase.json](../firebase.json). The Firebase CLI treats `--only functions:NAME` as a **codebase** named `NAME` first, so **single-function deploys must use three segments**: `functions:<codebase>:<exportName>`.

Example — site announcement callables only:

**Windows PowerShell** must quote comma-separated `--only` values (otherwise commas split the command into multiple arguments and deploy fails with “No function matches the filter”):

```powershell
firebase deploy --only "functions:default:getSiteAnnouncement,functions:default:getSiteAnnouncementAdmin,functions:default:setSiteAnnouncement"
```

Command Prompt, bash, or zsh can use the same quoted form; unquoted commas are fine on most Unix shells.

If you omit the codebase (`functions:getSiteAnnouncement`), you may see: `No function matches given --only filters`.

### Testing SMS

- **From the app**: Book a consultation and confirm; an SMS is sent to the phone number you enter.
- **Callable `sendTestSms`**: Requires an authenticated user. Call with `{ "phone": "855XXXXXXXXX", "message": "Optional text" }` to send a test SMS and confirm PlasGate is working.

### Behaviour

On every new booking (customer or admin):

1. **Customer SMS**: Sent to the customer's phone (from the booking). Message: consultation confirmed, date, time, ref. If phone is invalid or missing, customer SMS is skipped and `smsStatus: "skipped"` is set on the document.
2. **Admin SMS**: Sent to `ADMIN_SMS_PHONE` (summary: name, date, time, ref, customer phone). Skipped if secret not set or invalid.
3. **Stonechat business SMS**: Always sent to the configured business number with the same summary.

Phone numbers are normalized to E.164. One automatic retry on 5xx or network errors per SMS. Customer SMS result is written to the appointment document (`smsStatus`, `smsSentAt`, and on failure `smsErrorReason`, `smsErrorBody`, etc.).

## Subscriptions (email updates)

The Subscribe CTA uses a callable Function to store subscriber emails and send a confirmation email, then a scheduled Function sends monthly updates.

### Callable: `subscribeEmail`

- No auth required.
- Call with:
  - `{ "email": "user@example.com" }`
- Behavior:
  - Validates the email address
  - Deduplicates by email (stored in Firestore collection `email_subscriptions`)
  - Sends an immediate confirmation email to the submitted address via Resend

### Scheduled: `sendMonthlyUpdates`

- Runs monthly (`0 0 1 * *`, i.e. the 1st day of each month at 00:00 UTC).
- Sends `"[Stonechat] Monthly updates"` to subscribers where `status == "active"`.
- Idempotency:
  - Skips sending if `newsletter_runs/{YYYY-MM}` has `status: "done"`.

### Required secrets

- `RESEND_API_KEY` (already used by the contact form email notifications)

### Admin list callables (authenticated)

- `listEmailSubscribers` — requires Firebase Auth. Optional `{ "limit": 500 }`. Returns `{ subscribers: [{ id, email, status, createdAt, lastConfirmedAt }] }` (ISO date strings), ordered by `lastConfirmedAt` desc.
- `listContactSubmissions` — requires Firebase Auth. Optional `{ "limit": 200 }`. Returns `{ submissions: [...] }` from `contact_submissions`, ordered by `createdAt` desc.

### Site announcement (public + admin)

- `getSiteAnnouncement` — no auth. Returns `{ announcement: null }` or `{ announcement: { title, body, ctaLabel, ctaUrl, revision } }` when enabled and within schedule (Firestore: `site_settings/announcement`).
- `getSiteAnnouncementAdmin` — requires Firebase Auth (same model as subscriber list).
- `setSiteAnnouncement` — requires Firebase Auth; saves settings and bumps `revision`.

If the Operations Hub shows an error when opening the Announcement tab, open **Google Cloud → Cloud Run → Logs** (or **Firebase → Functions → Logs**) for `getSiteAnnouncementAdmin`. After deploying the latest `index.js`, failures return a more specific message in logs and in the client. Typical causes: function not deployed yet, Firestore API disabled for the project, or **App Check** blocking callables (temporarily turn off enforcement for debugging).
