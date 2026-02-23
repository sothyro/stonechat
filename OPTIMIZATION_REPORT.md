# Project optimization report

Inspection date: Feb 2025. This document summarizes findings and recommendations.

---

## Already in good shape

- **Router**: Created once (`??=`), `refreshListenable` only triggers redirects—no unnecessary rebuilds.
- **Theme**: `AppTheme._themeCache` in `app.dart` caches theme per locale.
- **Connectivity**: `ConnectivityService` uses a 5s cache to avoid excessive checks.
- **Preloading**: Critical path loads only logo + hero image; video loads in hero; rest loads in background. Sensible for first paint.
- **Lists**: `ListView.builder` / `GridView.builder` used where appropriate (e.g. `forecast_popup`, `events_section`, `apps_screen`).
- **RepaintBoundary**: Used on hero and key sections to isolate repaints.
- **Error logging**: Non-blocking (scheduleMicrotask), Firebase Analytics only when Firebase is initialized.

---

## Applied optimizations

1. **Unused validators removed**  
   In `lib/utils/validators.dart`, the following were never referenced and have been removed to reduce code size and noise:
   - `Validators.required`
   - `Validators.dateNotPast`
   - `Validators.timeSlot`
   - `Validators.password`
   - `Validators.url`  
   Contact and consultations screens only use `name`, `email`, `phone`, and `message`.

2. **Sentry DSN**  
   A comment was added in `main.dart` recommending use of an environment variable or `--dart-define` for the Sentry DSN so it can differ per environment and is not hardcoded.

---

## Recommendations (optional)

### 1. Sentry DSN from environment

- **Current**: DSN is hardcoded in `main.dart`.
- **Recommendation**: Use `String.fromEnvironment('SENTRY_DSN', defaultValue: '')` and pass via `--dart-define=SENTRY_DSN=...` in CI/production builds. Leave empty for local/dev if desired.

### 2. Unused theme code

- **Current**: `AppTheme.light()` in `lib/theme/app_theme.dart` is never used; the app always uses dark theme.
- **Recommendation**: Remove `AppTheme.light()` and the light `ThemeData` if you do not plan to support light mode; otherwise keep for future use.

### 3. Large files (maintainability)

These files are 700+ lines and could be split into smaller widgets or modules for easier maintenance (no runtime impact):

| File | Lines |
|------|-------|
| `lib/screens/consultations/consultations_screen.dart` | ~1640 |
| `lib/widgets/forecast_popup.dart` | ~1181 |
| `lib/screens/apps/apps_screen.dart` | ~1048 |
| `lib/screens/consultations/consultations_dashboard_screen.dart` | ~902 |
| `lib/screens/consultations/dashboard_calendar.dart` | ~786 |
| `lib/screens/home/widgets/events_section.dart` | ~731 |
| `lib/screens/home/widgets/testimonials_section.dart` | ~716 |

Consider extracting sub-widgets (e.g. step widgets, cards, dialogs) into separate files.

### 4. Linter rules

- **Current**: Using `package:flutter_lints/flutter.yaml` only.
- **Recommendation**: Consider enabling `prefer_const_constructors` and `prefer_const_declarations` if not already in the Flutter lint set, to catch unnecessary non-const allocations.

### 5. Assets

- Preloader loads many images in the background; all are referenced by screens. No unused asset references found.
- For future: if you add many more images, consider lazy-loading per route (e.g. only preload assets for the current route) to reduce memory and initial work.

---

## Summary

| Category | Status |
|----------|--------|
| Unused code (validators) | Cleaned |
| Sentry DSN | Comment added; env usage recommended |
| Theme (light) | Optional removal |
| Large files | Optional refactor |
| Performance patterns | Already solid |

No critical performance issues were found. The main gains are from removing dead validator code and optional structural improvements (splitting large files, DSN from env, unused theme).
