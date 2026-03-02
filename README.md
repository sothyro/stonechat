# Stonechat Communications

Stonechat Communications is a handy apps and digital solutions studio. This Flutter web app showcases our services: modern, beautiful, affordable applications for Web, Desktop, macOS, iOS, and Android; communication skills training (The Art of Human-Centered Communication and The Art of AI-Enhanced Communication); and book publishing and authoring. Localized in Khmer, English, and Chinese.

**Website:** https://www.stonechat.vip

## Getting started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable, with web support)
- Dart 3.9+

### Run locally

```bash
# Install dependencies
flutter pub get

# Run on web (Chrome by default)
flutter run -d chrome

# Or build for production
flutter build web
```

Output is in `build/web/`. Serve with any static host or use `dart run webdev serve` for local preview.

### Tests

```bash
flutter test
```

### Lint / analyze

```bash
flutter analyze
```

## Project structure

- `lib/` – app code  
  - `config/` – content and event data  
  - `l10n/` – localized strings (ARB + generated)  
  - `router/` – GoRouter setup and 404 handling  
  - `screens/` – route screens and home sections  
  - `theme/` – colors, typography, theme  
  - `widgets/` – shared UI (header, footer, shell, dialogs)  
  - `services/` – e.g. appointment booking API  
- `assets/` – images, icons, video  
- `web/` – `index.html`, PWA manifest, favicon  
  - `web/videos/` – hero video for web (e.g. `videobackground720.mp4`); copy from `assets/videos/` if missing so the release build serves it as a static file.  

## Configuration

- **App copy & URLs**: `lib/config/app_content.dart`  
- **Appointment API**: set `AppContent.appointmentBookingApiUrl` for live booking; leave empty for demo mode.  
- **Localizations**: edit `lib/l10n/app_*.arb`, then run `flutter gen-l10n`.  

## Firebase / Firestore

### Two separate entities

| Collection              | Purpose                    | Used by                          |
|-------------------------|----------------------------|----------------------------------|
| **`appointments`**       | Consultation bookings     | Consultations page, admin dashboard, SMS (PlasGate) |
| **`contact_submissions`** | Contact form messages    | Contact page only                |

They do not share data or logic. Contact form submissions do not affect the booking system.

### Notifying the team when someone submits the contact form

1. **Option A – Check Firestore manually**  
   In [Firebase Console](https://console.firebase.google.com) → Firestore → `contact_submissions`. New documents appear as soon as a user submits.

2. **Option B – Email notification (automatic)**  
   When a document is created in `contact_submissions`, a Cloud Function can send an email to your team.

   - Sign up at [Resend](https://resend.com) and create an API key.
   - Set Firebase secrets (from project root):
     ```bash
     firebase functions:secrets:set RESEND_API_KEY
     firebase functions:secrets:set CONTACT_NOTIFY_EMAIL
     ```
     When prompted, enter your Resend API key and the email address that should receive contact form notifications (e.g. `team@yourdomain.com`).
   - Redeploy functions. From project root, first install dependencies in `functions`, then deploy:
     ```powershell
     cd functions; npm ci; cd ..
     firebase deploy --only functions
     ```
     (PowerShell: use `;` to chain commands. If you see "Couldn't find firebase-functions", run `npm ci` inside `functions` before deploying.)

   Each new submission will trigger an email to `CONTACT_NOTIFY_EMAIL` with the sender's name, email, phone, subject, and message.  
   Resend's free tier allows sending from `onboarding@resend.dev`; for a custom "From" address, verify your domain in Resend.

### PlasGate SMS (appointment confirmations)

When a new document is created in `appointments`, a Cloud Function sends an SMS confirmation via [PlasGate](https://support.plasgate.com/article/api-overview) (sender: **PlasGateUAT**).

1. **Set Firebase secrets** (from project root). You need your PlasGate **private key** and **secret** from the PlasGate portal, and (optional) an admin phone for "create booking on behalf of client" SMS:
   ```bash
   firebase functions:secrets:set PLASGATE_PRIVATE_KEY
   firebase functions:secrets:set PLASGATE_SECRET
   firebase functions:secrets:set ADMIN_SMS_PHONE
   ```
   When prompted, paste your PlasGate keys. For `ADMIN_SMS_PHONE`, enter your E.164 number (e.g. `855XXXXXXXXX`) to receive an SMS when you create a booking on behalf of a client from the dashboard; enter `0` to disable. Do not commit these values to the repo.

2. **Redeploy functions** so the new secrets are used:
   ```powershell
   cd functions; npm ci; cd ..
   firebase deploy --only functions
   ```

3. **Verify** by creating a test booking from the app (Consultations → book a slot and confirm), or call the `sendTestSms` Cloud Function (requires an authenticated user) with `{ "phone": "855XXXXXXXXX", "message": "Optional text" }` to send a test SMS.

**If SMS is not sent:** In the Consultations dashboard, open an appointment and check **SMS status**. If it shows `failed` with reason `config`, set `PLASGATE_PRIVATE_KEY` and `PLASGATE_SECRET` and redeploy. If it shows `invalid_phone`, ensure the customer's number has at least 8 digits (Cambodia E.164: 855 + 8–9 digits). Check function logs: `firebase functions:log` for `onAppointmentCreated` and `sendPlasGateSms`.

Implementation details: on every new booking, 3 SMS are sent—(1) customer (confirmation), (2) admin (summary to `ADMIN_SMS_PHONE`), (3) Stonechat business line (summary to configured number). Phone numbers are normalized to E.164. Invalid or missing customer phone skips only the customer SMS and sets `smsStatus: "skipped"`. The function retries once on 5xx or network errors. Customer SMS status is written to the appointment document (`smsStatus`, `smsSentAt`, and on failure `smsErrorReason`, `smsErrorBody`, etc.).

## Repository

- **Git remote**: https://github.com/sothyro/stonechat.git  
- **Repo**: [github.com/sothyro/stonechat](https://github.com/sothyro/stonechat)

### First push to GitHub

From the project root:

```bash
git remote set-url origin https://github.com/sothyro/stonechat.git
git remote -v
git add -A
git status
git commit -m "Initial commit: Stonechat Communications"
git push -u origin master
```

If the default branch on GitHub is `main`, use: `git push -u origin master:main` (or rename the local branch to `main` first).

**Check or fix the remote:** From the project root, run:
```bash
git remote -v
```
If `origin` is not `https://github.com/sothyro/stonechat.git`, set it:
```bash
git remote set-url origin https://github.com/sothyro/stonechat.git
git remote -v
```
On Windows you can instead run: `.\scripts\verify-git-remote.ps1`

## Resources

- [Flutter documentation](https://docs.flutter.dev/)
- [Flutter web](https://docs.flutter.dev/platform-integration/web)
