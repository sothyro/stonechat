# Translation Investigation: English Texts to Translate into Khmer and Chinese

This document lists all English texts that need to be translated into Khmer (km) and Chinese (zh). It is organized by source: ARB keys still in English, hardcoded UI strings, and config/content.

---

## 1. ARB files: keys still in English or missing in km/zh

### 1.1 Keys that may be missing or English in `app_km.arb` / `app_zh.arb`

The template is `app_en.arb`. If a key exists in `app_en.arb` but is missing in `app_km.arb` or `app_zh.arb`, the app falls back to English for that locale. The generated `app_localizations_km.dart` and `app_localizations_zh.dart` showed these still returning English in some locales:

| Key | English (from app_en.arb) | Notes |
|-----|---------------------------|--------|
| `marketplaceCategoryDigital` | Digital | Translate for km, zh |
| `marketplaceCategoryBooks` | Books | Translate for km, zh |
| `marketplaceCategoryTalismans` | Talismans | Translate for km, zh |
| `masterElfSubscribe` | Subscribe | Translate for km, zh |
| `masterElfSubscriptionPrice` | 9.99 | May keep as-is (number) |
| `masterElfPricePerMonth` | / month | Translate for km, zh |
| `period9PriceFree` | Free | Translate for km, zh |
| `period9PremiumLabel` | Premium subscription available | Translate for km, zh |
| `marketplaceAddedToCart` | Added to cart. We'll contact you to complete your order. | Translate for km, zh |

Verify in `app_km.arb` and `app_zh.arb` that every key from `app_en.arb` exists and has a proper translation (not the English copy).

### 1.2 Keys with English values in Khmer/Chinese ARB

These keys exist in `app_km.arb` or `app_zh.arb` but still have English values:

**In `app_km.arb`:**
- `appTitle`: "Master Elf Feng Shui" (brand may stay; confirm)
- `event2Location`: "Resorts World Sentosa, Singapore"
- `event3Title`: "Crimson Horse QiMen"
- `event3Location`: "Resorts World Singapore"

**In `app_zh.arb`:**
- `appTitle`: "Master Elf Feng Shui" (brand may stay)
- `event2Location`: "Resorts World Sentosa, Singapore"
- `event3Location`: "Resorts World Singapore"

Translate the event locations and event title for Khmer; translate event locations for Chinese if desired (or keep as proper nouns).

---

## 2. Hardcoded English strings in code (not using l10n)

These strings are displayed to users but do not go through `AppLocalizations`. They should be moved to ARB and wired to l10n.

### 2.1 App & shell

| File | String | Usage |
|------|--------|--------|
| `lib/app.dart` | `'Master Elf Feng Shui'` | MaterialApp `title` |
| `lib/widgets/app_header.dart` | `'Navigation'` | Semantics `label` |
| `lib/widgets/app_shell.dart` | `'Main content'` | Semantics `label` |
| `lib/widgets/app_shell.dart` | `'Footer'` | Semantics `label` |
| `lib/widgets/app_drawer.dart` | `'Navigate'` | _SectionLabel |
| `lib/widgets/app_drawer.dart` | `'Get in touch'` | _SectionLabel |

### 2.2 Buttons, tooltips, SnackBars

| File | String | Usage |
|------|--------|--------|
| `lib/screens/apps/apps_screen.dart` | `'OK'` | SnackBarAction label |
| `lib/screens/apps/apps_screen.dart` | `'Add'` | Button label (narrow layout) |
| `lib/widgets/profile_dialog.dart` | `'Close'` | IconButton tooltip |
| `lib/widgets/error_display.dart` | `'Retry'` | Fallback when l10n.retry is null |
| `lib/widgets/sticky_cta_bar.dart` | `'Dismiss'` | Tooltip |
| `lib/widgets/app_header.dart` | `'Menu'` | Tooltip |

### 2.3 Consultations

| File | String | Usage |
|------|--------|--------|
| `lib/screens/consultations/consultations_screen.dart` | `'Please select a service'` | Validation message |
| `lib/screens/consultations/consultations_screen.dart` | `'No slots available for this date.'` | Empty state text |

### 2.4 Footer & contact

| File | String | Usage |
|------|--------|--------|
| `lib/widgets/app_footer.dart` | `'Powered by Stonechat Communications'` | Footer credit |
| `lib/widgets/app_footer.dart` | `'Academy'` | _LinkItem label (if not using l10n) |
| `lib/widgets/app_footer.dart` | `'WhatsApp'`, `'Facebook'`, `'Instagram'`, `'TikTok'`, `'Telegram'` | IconButton tooltips |
| `lib/screens/contact/contact_screen.dart` | `'WhatsApp'`, `'Email'`, `'Telegram'` | Tooltips |

### 2.5 About & other UI

| File | String | Usage |
|------|--------|--------|
| `lib/screens/about/about_screen.dart` | `'Logo ${i + 1}'` | Placeholder text for logo |

### 2.6 Loading / hero preloader

| File | Strings | Usage |
|------|--------|--------|
| `lib/utils/hero_video_preloader.dart` | `'Loading your experience…'`, `'Optimising view…'`, `'Almost there…'`, `'Just a moment…'` | Loading messages |

### 2.7 Event registration (email)

| File | Strings | Usage |
|------|--------|--------|
| `lib/screens/events/events_screen.dart` | Email body template: `'Event: ...\nDate: ...\nLocation: ...\n\nRegistrant:\nName: ...\nEmail: ...\nPhone: ...'` | mailto body labels |
| `lib/screens/events/events_screen.dart` | `'Event Registration: '` | mailto subject prefix |

### 2.8 Story section (phrase matching)

| File | Strings | Usage |
|------|--------|--------|
| `lib/screens/home/widgets/story_section.dart` | `'Story'`, `'Chinese Metaphysics'`, etc. | Highlight phrase lists; some are for matching only (e.g. 'Story') and may stay for EN; ensure KM/ZH use localized headings so highlights match. |

### 2.9 Testimonials section

| File | Strings | Usage |
|------|--------|--------|
| `lib/screens/home/widgets/testimonials_section.dart` | `'Real '`, `'Insights.\n'`, `'Outcomes.'` | Hardcoded in RichText when building “Real Insights. Real Outcomes.” — should use l10n.sectionTestimonialsHeading and split/highlight by locale. |
| `lib/screens/home/widgets/testimonials_section.dart` | Testimonial names, locations, quotes (e.g. `'Panha Leakhena'`, `'Phnom Penh'`, `'Thank you Master, for sharing...'`) | Currently hardcoded; consider moving to l10n or a localized content source for full translation. |

### 2.10 Academy

| File | String | Usage |
|------|--------|--------|
| `lib/screens/academy/academy_screen.dart` | `'Real Change'` | Hardcoded highlight phrase for heading; in KM/ZH the heading is localized but the phrase to highlight should match the localized text. |

---

## 3. Config and content files (English-only or need localization)

### 3.1 `lib/config/app_content.dart`

All of these are user-visible and currently English-only:

| Constant | Current value (English) |
|----------|--------------------------|
| `companyName` | Master Elf Feng Shui |
| `shortName` | Master Elf |
| `legalEntity` | Master Elf Feng Shui Co., Ltd. |
| `addressLine` | #23-25, Street V07, Victory City, Steung Meanchey |
| `office1Label` | Cambodia Office |
| `office1Address` | #23-25, Street V07, Victory City, Steung Mean Chey, Phnom Penh, Cambodia, 12000 |

Phone numbers and URLs can stay as-is. Labels and address lines should be translatable (e.g. via l10n or locale-aware getters).

### 3.2 `lib/screens/legal/legal_content.dart`

The **body** text of Terms, Disclaimer, and Privacy is in English only (`_termsBody`, `_disclaimerBody`, `_privacyBody`). Titles use l10n (termsOfService, disclaimer, privacyPolicy).

- **Terms of Service**: full body (~paragraphs 1–9).
- **Disclaimer**: full body (General Disclaimer, No Guarantee of Outcomes, etc.).
- **Privacy Policy**: full body.

To support Khmer and Chinese, either:
- Add locale-aware methods that return localized body text (e.g. from ARB or separate legal_km/legal_zh content), or
- Add very long ARB strings (or reference external localized HTML/text).

### 3.3 `lib/config/zodiac_forecast_content.dart`

- **English**: `_contentEn` — full set of predictions/warnings in English.
- **Khmer**: `_contentKm` — already localized.
- **Chinese**: `_contentZh` — already localized.

No action for zodiac content except to ensure `_contentEn` is the source for any new keys if you move these to ARB.

### 3.4 `lib/widgets/forecast_popup.dart`

- Zodiac **animal names** in English (e.g. `englishName: 'Rat'`, `'Ox'`, `'Tiger'`) and many **star/term translations** (e.g. `englishTranslation: 'Clear Moon'`, `'Heavenly Kitchen'`) are used for display. These are already paired with Khmer and Chinese in `_StarInfo` / zodiac data. Ensure the UI shows the correct language based on locale (e.g. use `khmerName` or `chineseName` when locale is km/zh, and `englishName`/`englishTranslation` for en).

---

## 4. Summary checklist

- [ ] **ARB**: Ensure every key in `app_en.arb` exists in `app_km.arb` and `app_zh.arb` with proper translations (no leftover English in km/zh).
- [ ] **ARB**: Replace English values in km/zh for event locations and event titles where appropriate.
- [ ] **Hardcoded UI**: Add l10n keys for app title, semantics labels, “Navigate”, “Get in touch”, “OK”, “Add”, “Close”, “Retry”, “Dismiss”, “Menu”, “Please select a service”, “No slots available for this date.”, footer “Powered by…”, “Academy”, social tooltips, “Logo N”, loading messages, event registration email labels/subject, and testimonial heading split (“Real”, “Insights.”, “Outcomes.”).
- [ ] **Config**: Make `AppContent` labels and address line locale-aware (l10n or similar).
- [ ] **Legal**: Add localized body text for Terms, Disclaimer, and Privacy for km and zh.
- [ ] **Testimonials**: Optionally move names/locations/quotes to l10n or localized content for full translation.
- [ ] **Forecast popup**: Confirm locale is used to choose animal name and star translation (Khmer/Chinese vs English).

---

## 5. Recommended next steps

1. Run a key diff: list all keys in `app_en.arb` and ensure each exists in `app_km.arb` and `app_zh.arb`.
2. Add missing ARB keys for the hardcoded strings in Section 2, then replace those strings with `AppLocalizations.of(context)!.keyName`.
3. Introduce locale-aware accessors for `AppContent` (e.g. `AppContent.companyName(context)` that reads from l10n or a map by locale).
4. Add legal body content for km and zh (separate files or ARB) and use them in `LegalContent.body(context, page)` based on locale.
5. Optionally localize testimonial content and event registration email template per locale.
