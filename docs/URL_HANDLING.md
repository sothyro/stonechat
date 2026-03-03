# URL handling and deep links

## Root-cause analysis: why URLs failed after refresh or cache clearing

### 1. Initial location ignored the browser URL

**Cause:** The app’s `GoRouter` was created with a fixed `initialLocation: '/'`. When the user opened a direct link (e.g. `https://site.com/events`) or refreshed on a deep link, the following happened:

- The browser kept the correct URL (e.g. `/events`).
- Flutter (and the router) started later. When `createAppRouter()` ran, it always used `initialLocation: '/'`.
- The router therefore started in the “home” state. On web, that could overwrite the address bar to `/` or leave the bar at `/events` while the app showed the home screen, depending on timing and implementation.

So the **root cause** of “wrong or blank page after refresh / reopen / cache clear” was: **the router never used the browser’s current URL as the initial route**. It always started at `/`, so deep links and refreshes did not restore the intended screen.

### 2. Trailing slashes made paths “unknown”

**Cause:** Valid paths were matched against a fixed set (e.g. `/events`, `/book`). Paths with a trailing slash (e.g. `/events/`) were not in that set, so the redirect logic treated them as unknown and sent the user to `/not-found`. Shared or bookmarked URLs with a trailing slash could therefore land on the 404 page.

### 3. Server and redirect config (already correct)

The app already had:

- Path-based URLs via `usePathUrlStrategy()` in `main.dart`.
- SPA fallback so that `/events`, `/book`, etc. serve `index.html` (e.g. `.htaccess`, `_redirects`).

So **direct hits and refreshes were not failing because of server config**; they were failing because the **client-side router did not initialize from the current URL** and did not normalize paths.

### 4. Why “paste link” always showed the main screen (timing)

Even after setting `initialLocation: getInitialRouterLocation()` in the router, the router is created **only when `StonechatApp` first builds**—i.e. **after** `HeroVideoBootstrap` finishes (loading screen). So the sequence was: user opens `https://site.com/events` → main runs → loading screen shows → **router is created later** and calls `getInitialRouterLocation()`. By then, `Uri.base` can differ (e.g. engine or timing), or the value was never used correctly. The **fix** is to read the browser URL **once in `main()` right after startup** and pass that value into the app so the router always receives the URL that was in the address bar when the page loaded.

---

## Implemented fix (routing / state layer)

1. **Initial location captured at startup (web)**  
   The browser URL is read **in `main()` immediately after `usePathUrlStrategy()` and `ensureInitialized()`**, then passed into `HeroVideoBootstrap` → `StonechatApp` → `createAppRouter(initialLocation: …)`. We do not read `Uri.base` when the router is created (after the loading screen), because by then the URL can have changed or the engine may report a different path. Capturing at startup ensures:
   - Direct link to `/events` or `/book` opens the correct screen.
   - Refresh on any valid URL keeps that URL and screen.
   - Paste/open of a copied link shows the intended page instead of the home screen.
   - Cache clear and reopen with a saved URL still loads the correct page.

2. **Path normalization**  
   A single `normalizePath()` helper:
   - Leaves `/` as is.
   - Removes a trailing slash from other paths (e.g. `/events/` → `/events`).
   - Used both when computing the initial location and in the redirect callback.

3. **Redirect logic**  
   - **Trailing slash:** If the current path has a trailing slash, the redirect returns the canonical path (no trailing slash), preserving query and fragment. So `/events/` and `/events?foo=1` both resolve to the same route and a clean URL.
   - **Unknown paths:** Unchanged: unknown paths still redirect to `/not-found`.
   - **Auth:** Unchanged: `/consultations/dashboard` still redirects to `/consultations` when the user is not logged in.

4. **SPA redirect file**  
   `web/_redirects` was normalized to the usual SPA rule: `/* /index.html 200`, so all routes are served `index.html` and the client router can handle them.

---

## Developer note: URL-handling behavior and constraints

### Current behavior

- **Web:** The initial route is the **URL captured in `main()` at startup** (path + query + fragment), passed through to the router. Direct links, bookmarks, paste, and shared links open the correct screen. The router is created later (after the loading screen) but receives this captured location so it never “forgets” the intended route.
- **Path format:** Paths are normalized: no trailing slash except for `/`. So `/events` and `/events/` are equivalent; the app redirects `/events/` to `/events`.
- **Unknown paths:** Any path not in the known set (see `_knownPaths` in `app_router.dart`) redirects to `/not-found` (404 inside the app shell).
- **Query and fragment:** Query parameters and hash fragments are preserved when normalizing (e.g. `/events?month=3` and `#section`).

### Adding or changing routes

1. **Register the path**  
   Add the new path to `_knownPaths` in `lib/router/app_router.dart` (e.g. `'/my-page'`). If you don’t, the redirect will send that path to `/not-found`.

2. **Add the route**  
   Add a matching `GoRoute` (or nested route) under the same `ShellRoute` so the path is actually handled.

3. **Server / hosting**  
   Ensure your host still serves `index.html` for the new path (your existing SPA rule `/* → index.html` usually covers this).

### Constraints

- **Subpath deployment:** If the app is deployed under a subpath (e.g. `https://site.com/app/`), the **base href** must be set (e.g. in `web/index.html` via `$FLUTTER_BASE_HREF`). The current code assumes the app is at the root or that `Uri.base` already reflects the base (as with Flutter’s default build). If you deploy under a subpath and see wrong or blank routes, you may need to strip the base path from `Uri.base.path` before passing it to the router (e.g. in `getInitialRouterLocation()`).
- **Auth and redirect:** `/consultations/dashboard` redirects to `/consultations` when the user is not logged in. That happens in the same redirect callback; keep that in mind if you add more auth-only routes.
- **Tests:** Router/URL behavior is covered by `test/router_url_test.dart`: unit tests for `normalizePath()` always run; widget tests for redirect and not-found are skipped in CI (full-app layout overflows in the test viewport). Verify deep link and refresh behavior manually on web (open `/events`, refresh; open `/events/` and confirm redirect to `/events`; open `/unknown` and confirm 404). Run: `flutter test test/router_url_test.dart`.

### Quick reference

| Scenario              | Behavior                                                                 |
|-----------------------|--------------------------------------------------------------------------|
| Open `/events`        | Events screen; URL stays `/events`.                                      |
| Open `/events/`       | Redirect to `/events`; Events screen.                                    |
| Refresh on `/events`  | Router starts at `/events`; Events screen.                                |
| Cache clear, reopen `/book` | Router starts at `/book`; Book screen.                              |
| Open `/unknown`       | Redirect to `/not-found`; 404 screen.                                   |
