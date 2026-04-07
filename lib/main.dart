import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'app.dart';
import 'firebase_options.dart';
import 'router/app_router.dart';
import 'services/connectivity_service.dart';
import 'services/error_logging_service.dart';
import 'utils/app_asset_preloader.dart';
import 'utils/hero_video_preloader.dart';

void main() async {
  final startupWatch = Stopwatch()..start();
  // Use path-based URLs (e.g. /consultations) so direct links open the correct page.
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  _traceStartup(startupWatch, 'binding_ready');
  // Firebase must be ready before [AuthProvider] is constructed (see [AuthProvider] constructor),
  // otherwise email/password sign-in uses [NoOpAuthService] permanently and always fails.
  try {
    await _initFirebase().timeout(const Duration(seconds: 4));
    _traceStartup(startupWatch, 'firebase_ready');
  } catch (_) {
    _traceStartup(startupWatch, 'firebase_failed');
  }
  // Capture initial URL immediately so direct links / paste / refresh show the right screen.
  // Reading here avoids the URL being lost or overwritten during async init or loading screen.
  final initialLocation = getInitialRouterLocation();
  runApp(HeroVideoBootstrap(initialLocation: initialLocation));
  _traceStartup(startupWatch, 'run_app');
  unawaited(_initializeServicesInBackground(startupWatch));
}

/// Initialize Firebase only when options are configured (not placeholder).
Future<void> _initFirebase() async {
  try {
    if (Firebase.apps.isNotEmpty) return;
    final options = DefaultFirebaseOptions.currentPlatform;
    if (options.projectId.isEmpty || options.projectId == 'your-project-id') {
      return;
    }
    await Firebase.initializeApp(options: options);
  } catch (_) {
    // Run without Firebase (demo mode for booking)
  }
}

Future<void> _initializeServicesInBackground(Stopwatch startupWatch) async {
  await _guardedInit(
    'error_logging',
    () => ErrorLoggingService.initialize().timeout(const Duration(seconds: 3)),
    startupWatch,
  );
  await _guardedInit(
    'connectivity',
    () async => ConnectivityService.initialize(),
    startupWatch,
  );
}

Future<void> _guardedInit(
  String name,
  Future<void> Function() task,
  Stopwatch startupWatch,
) async {
  try {
    await task();
    _traceStartup(startupWatch, '${name}_ready');
  } catch (_) {
    _traceStartup(startupWatch, '${name}_failed');
  }
}

void _traceStartup(Stopwatch watch, String stage) {
  if (kDebugMode || kProfileMode) {
    debugPrint('STARTUP[$stage]: ${watch.elapsedMilliseconds}ms');
  }
}

/// Shows a loading screen with 0–100% progress until critical startup assets (images + primary fonts) are ready.
/// Hero video loads later in the hero section.
class HeroVideoBootstrap extends StatefulWidget {
  const HeroVideoBootstrap({super.key, required this.initialLocation});

  /// Initial route (e.g. from browser URL on web). Ensures direct links open the correct page.
  final String initialLocation;

  @override
  State<HeroVideoBootstrap> createState() => _HeroVideoBootstrapState();
}

class _HeroVideoBootstrapState extends State<HeroVideoBootstrap> {
  double _progress = 0.0;
  bool _transitioning = false;
  bool _revealed = false;
  Timer? _revealTimer;

  static const Duration _preloadRevealTimeout = Duration(seconds: 25);

  @override
  void initState() {
    super.initState();
    _revealTimer = Timer(_preloadRevealTimeout, _revealIfNeeded);
    AppAssetPreloader.preloadAll((progress) {
      if (!mounted) return;
      setState(() => _progress = progress);
      if ((kDebugMode || kProfileMode) && progress >= 1.0) {
        debugPrint('STARTUP[preload_complete]');
      }
      if (progress >= 1.0) {
        _revealIfNeeded();
      }
    }).catchError((_) {
      _revealIfNeeded();
    });
  }

  void _revealIfNeeded() {
    if (!mounted || _revealed) return;
    _revealed = true;
    _revealTimer?.cancel();
    setState(() => _transitioning = true);
  }

  @override
  void dispose() {
    _revealTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_transitioning) {
      return HeroLoadingScreen(progress: _progress);
    }
    return StonechatApp(initialLocation: widget.initialLocation);
  }
}
