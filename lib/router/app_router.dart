// URL handling: On web, the router's initial location is taken from the browser
// (Uri.base) so direct links and refresh open the correct screen. Paths are
// normalized (no trailing slash). See docs/URL_HANDLING.md for full details and
// constraints (e.g. subpath deployment, adding new routes).

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../theme/app_theme.dart';
import '../utils/breakpoints.dart';
import '../widgets/app_shell.dart';
import '../screens/home/home_screen.dart';
import '../screens/events/events_screen.dart';
import '../screens/contact/contact_screen.dart';
import '../screens/consultations/consultations_screen.dart';
import '../screens/consultations/consultations_dashboard_screen.dart';
import '../screens/journey/journey_screen.dart';
import '../screens/apps/apps_screen.dart';
import '../screens/book/book_screen.dart';
import '../providers/auth_provider.dart';
import '../l10n/app_localizations.dart';

final GlobalKey<NavigatorState> _rootNavKey = GlobalKey<NavigatorState>();

const Set<String> _knownPaths = {
  '/',
  '/journey',
  '/events',
  '/apps',
  '/book',
  '/contact',
  '/consultations',
  '/consultations/dashboard',
  '/not-found',
};

/// Normalizes a path for matching: no trailing slash (except for '/').
/// Exposed for testing and reuse.
String normalizePath(String path) {
  if (path.isEmpty || path == '/') return '/';
  return path.endsWith('/') ? path.substring(0, path.length - 1) : path;
}

/// Returns the initial location for the router. On web, uses the browser's
/// current URL so direct links and refresh open the correct screen.
String getInitialRouterLocation() {
  if (kIsWeb) {
    final uri = Uri.base;
    final path = normalizePath(uri.path);
    final query = uri.hasQuery ? '?${uri.query}' : '';
    final fragment = uri.fragment.isNotEmpty ? '#${uri.fragment}' : '';
    return path + query + fragment;
  }
  return '/';
}

/// Creates the app router once. Pass [refreshListenable] (e.g. LocaleNotifier)
/// so route/redirect logic can react to changes without recreating the router.
/// Pass [initialLocation] when the app captured the browser URL at startup (web
/// direct link / refresh); avoids reading Uri.base later when it may have changed.
GoRouter createAppRouter({
  Listenable? refreshListenable,
  String? initialLocation,
}) {
  return GoRouter(
    navigatorKey: _rootNavKey,
    initialLocation: initialLocation ?? getInitialRouterLocation(),
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      final path = state.uri.path;
      final normalized = normalizePath(path);

      // Redirect trailing-slash URLs to canonical form (e.g. /events/ -> /events).
      if (path != normalized) {
        final q = state.uri.query.isEmpty ? '' : '?${state.uri.query}';
        final f = state.uri.fragment.isEmpty ? '' : '#${state.uri.fragment}';
        return normalized + q + f;
      }

      if (normalized.isEmpty || _knownPaths.contains(normalized)) {
        if (normalized == '/consultations/dashboard') {
          final auth = context.read<AuthProvider>();
          if (!auth.isLoggedIn) return '/consultations';
        }
        return null;
      }
      return '/not-found';
    },
    routes: [
      ShellRoute(
        builder: (_, __, child) => AppShell(child: child),
        routes: [
          GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
          GoRoute(path: '/journey', builder: (_, __) => const JourneyScreen()),
          GoRoute(path: '/events', builder: (_, __) => const EventsScreen()),
          GoRoute(path: '/apps', builder: (_, __) => const AppsScreen()),
          GoRoute(path: '/book', builder: (_, __) => const BookScreen()),
          GoRoute(path: '/contact', builder: (_, __) => const ContactScreen()),
          GoRoute(
            path: '/consultations',
            builder: (_, state) => AppointmentsScreen(
              initialServiceId: state.uri.queryParameters['service'],
            ),
          ),
          GoRoute(path: '/consultations/dashboard', builder: (_, __) => const AppointmentsDashboardScreen()),
          GoRoute(path: '/not-found', builder: (_, __) => const _NotFoundScreen()),
        ],
      ),
    ],
  );
}

/// Shown when the route is not found (404). Rendered inside the shell (header + footer).
class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = Breakpoints.isMobile(width);
    final paddingV = isMobile ? 48.0 : 80.0;
    final paddingH = isMobile ? 16.0 : 24.0;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: paddingV, horizontal: paddingH),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.pageNotFoundTitle,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.pageNotFoundMessage,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.onPrimary.withValues(alpha: 0.85),
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () => context.go('/'),
              icon: const Icon(Icons.home_outlined),
              label: Text(l10n.backToHome),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.onAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
