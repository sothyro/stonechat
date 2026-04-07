import 'dart:async';

import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/app_content.dart';

// ---------------------------------------------------------------------------
// Critical path: logo + hero image only. Video loads in the hero section
// after the app is visible (standard practice; avoids web asset URL issues).
// ---------------------------------------------------------------------------

/// Critical for first paint: logo (header) and hero background (fallback/static).
List<String> get _criticalImageAssets => [
  AppContent.assetLogo,
  AppContent.assetHeroBackground,
];

/// Images for home below-the-fold and other pages; loaded in background after app is visible.
List<String> get _restImageAssets => [
  AppContent.assetBackgroundDirection,
  AppContent.assetEventCard,
  AppContent.assetEventMain,
  AppContent.assetStoryBackground,
  AppContent.assetTestimonial,
  AppContent.assetAcademy,
  AppContent.assetBaziHarmony,
  AppContent.assetAcademyQiMen,
  AppContent.assetAppsHero,
  AppContent.assetAppQiMen,
  AppContent.assetAppBaziLife,
  AppContent.assetAppBaziReport,
  AppContent.assetAppBaziAge,
  AppContent.assetAppBaziStars,
  AppContent.assetAppBaziKhmer,
  AppContent.assetAppBaziPage2,
  AppContent.assetAppDateSelection,
  AppContent.assetAppMarriage,
  AppContent.assetAppBusinessPartner,
  AppContent.assetAppAdvancedFeatures,
  AppContent.assetPeriod9_1,
  AppContent.assetPeriod9_2,
];

/// Preloads the critical path (logo + hero image) and reports progress 0.0 → 1.0.
/// Remaining assets/fonts load in the background after the first paint.
class AppAssetPreloader {
  AppAssetPreloader._();

  /// Critical path: logo + hero image + primary UI fonts. Hero video loads in the hero section.
  static Future<void> preloadAll(void Function(double progress) onProgress) async {
    onProgress(0.0);

    final critical = _criticalImageAssets;
    final fontSlots = 1;
    final totalSlots = critical.length + fontSlots;
    if (totalSlots == 0) {
      onProgress(1.0);
      unawaited(_backgroundPreload());
      return;
    }

    await _loadImageList(critical, (completed, total) {
      if (total <= 0) return;
      onProgress(completed / totalSlots);
    });
    await _loadMainFonts();
    onProgress(1.0);

    // Background: rest images and extended font resolution (no blocking)
    unawaited(_backgroundPreload());
  }

  static Future<void> _backgroundPreload() async {
    _triggerOtherLocaleFontsInBackground();
    await _loadImageList(_restImageAssets, (_, __) {});
    await GoogleFonts.pendingFonts().timeout(
      const Duration(seconds: 30),
      onTimeout: () => <void>[],
    );
  }

  static Future<void> _loadImageList(
    List<String> paths,
    void Function(int completed, int total) onProgress,
  ) async {
    final total = paths.length;
    if (total == 0) {
      onProgress(0, 0);
      return;
    }
    var completed = 0;
    await Future.wait(
      paths.map((path) async {
        try {
          await rootBundle.load(path);
        } catch (_) {}
        completed++;
        onProgress(completed, total);
      }),
    );
  }

  static Future<void> _loadMainFonts() async {
    GoogleFonts.exo2(fontSize: 14);
    GoogleFonts.condiment(fontSize: 14);
    await GoogleFonts.pendingFonts().timeout(
      const Duration(milliseconds: 1500),
      onTimeout: () => <void>[],
    );
  }

  static void _triggerOtherLocaleFontsInBackground() {
    GoogleFonts.dangrek(fontSize: 14);
    GoogleFonts.siemreap(fontSize: 14);
    GoogleFonts.notoSansSc(fontSize: 14);
  }
}
