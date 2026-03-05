import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

import '../../../config/app_content.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/breakpoints.dart';
import '../../../widgets/profile_dialog.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  VideoPlayerController? _controller;
  bool _videoReady = false;
  bool _videoError = false;
  void Function()? _loopListener;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _initVideo();
    });
  }

  Future<void> _initVideo() async {
    if (!mounted) return;
    try {
      // Use .asset() on all platforms; video_player_web resolves assets correctly.
      final VideoPlayerController c = VideoPlayerController.asset(
        AppContent.assetHeroVideo,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );

      await c.initialize();
      if (!mounted) {
        c.dispose();
        return;
      }
      c.setLooping(true);
      c.setVolume(0);
      // Fallback loop: when position reaches end, seek to start and play (reliable on web where setLooping can fail).
      void listener() {
        final duration = c.value.duration;
        if (!c.value.isPlaying || duration.inMilliseconds <= 0) return;
        final pos = c.value.position.inMilliseconds;
        final end = duration.inMilliseconds - 200;
        if (pos >= end) {
          c.seekTo(Duration.zero);
          c.play();
        }
      }
      _loopListener = listener;
      c.addListener(_loopListener!);
      await c.play();
      if (!mounted) {
        c.removeListener(_loopListener!);
        c.dispose();
        return;
      }
      setState(() {
        _controller = c;
        _videoReady = true;
      });
    } catch (_) {
      if (mounted) setState(() => _videoError = true);
    }
  }

  @override
  void dispose() {
    final c = _controller;
    if (c != null && _loopListener != null) {
      c.removeListener(_loopListener!);
    }
    _controller?.dispose();
    super.dispose();
  }

  List<Widget> _heroHeadlinesAndSubline(
    BuildContext context,
    AppLocalizations l10n,
    TextAlign textAlign,
    double width,
  ) {
    final isMobile = width < Breakpoints.mobile;
    // Base: white bold sans-serif (section-title style)
    final baseFontSize = width < 600 ? 22.0 : (width < 900 ? 28.0 : 34.0);
    // Highlight: teal cursive (Condiment/Dangrek) — larger and more prominent
    final highlightFontSize = width < 600 ? 30.0 : (width < 900 ? 42.0 : 52.0);
    final lineHeight = isMobile ? 1.28 : 1.15;
    const double overlineToTitle = 12;
    const double titleLineGap = 6;
    const double titleToRule = 20;
    const double ruleToSubline = 16;

    final locale = Localizations.localeOf(context);
    final isKhmer = locale.languageCode == 'km';
    final homeLabel = isKhmer ? l10n.home : l10n.home.toUpperCase();

    final baseStyle = (Theme.of(context).textTheme.headlineMedium ?? const TextStyle()).copyWith(
      color: AppColors.onPrimary,
      fontWeight: FontWeight.w700,
      fontSize: baseFontSize,
      height: lineHeight,
      letterSpacing: -0.3,
    );
    final highlightStyle = highlightStyleForLocale(
      context,
      color: AppColors.accentLight,
      fontWeight: FontWeight.w700,
      fontSize: highlightFontSize,
      height: lineHeight,
    );

    return [
      // Overline: section-style label (matches section headers)
      Text(
        homeLabel,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.accent,
              fontWeight: FontWeight.w600,
              fontSize: 11,
              letterSpacing: isKhmer ? 0 : 3.2,
              height: 1.2,
            ),
      ),
      SizedBox(height: overlineToTitle),
      // Line 1: one short highlight ("Quality apps") + rest in white
      Semantics(
        header: true,
        child: RichText(
          textAlign: textAlign,
          softWrap: true,
          text: TextSpan(
            style: baseStyle,
            children: [
              TextSpan(text: l10n.heroHeadline1Prefix),
              if (l10n.heroHeadline1Highlight.isNotEmpty)
                TextSpan(
                  text: l10n.heroHeadline1Highlight,
                  style: highlightStyle,
                ),
              TextSpan(text: l10n.heroHeadline1Suffix),
            ],
          ),
        ),
      ),
      SizedBox(height: titleLineGap),
      // Line 2: all base text (no highlight when heroHeadline2Highlight is empty)
      RichText(
        textAlign: textAlign,
        softWrap: true,
        text: TextSpan(
          style: baseStyle,
          children: [
            TextSpan(text: l10n.heroHeadline2Prefix),
            if (l10n.heroHeadline2Highlight.isNotEmpty)
              TextSpan(
                text: l10n.heroHeadline2Highlight,
                style: highlightStyle,
              ),
          ],
        ),
      ),
      SizedBox(height: titleToRule),
      // Accent line (section-title style)
      Align(
        alignment: textAlign == TextAlign.center ? Alignment.center : Alignment.centerLeft,
        child: Container(
          width: 48,
          height: 3,
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
      SizedBox(height: ruleToSubline),
      Text(
        l10n.heroSubline,
        textAlign: textAlign,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: AppColors.onPrimary.withValues(alpha: 0.88),
          height: 1.45,
          fontSize: width < 600 ? 15 : (width < 900 ? 17 : 19),
          fontWeight: FontWeight.w500,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = Breakpoints.isMobile(width);
    final minHeight = Breakpoints.isSmall(width)
        ? 480.0
        : (Breakpoints.isDesktop(width) ? 1000.0 : 500.0);
    final height = width > 0 ? (width * 9 / 16).clamp(minHeight, 1600.0) : 1000.0;
    final horizontalPadding = isMobile ? 16.0 : 32.0;
    final verticalPadding = isMobile ? 32.0 : 48.0;
    final topInset = isMobile ? (MediaQuery.paddingOf(context).top + 12 + 64) : 0.0;
    final contentAlignment = isMobile ? const Alignment(0, 1.0) : const Alignment(-0.38, 0.42);
    final crossAlign = isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    final textAlign = isMobile ? TextAlign.center : TextAlign.left;

    return RepaintBoundary(
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1) Gradient background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.backgroundDark,
                    AppColors.surfaceDark,
                    AppColors.primary.withValues(alpha: 0.95),
                  ],
                ),
              ),
            ),
            // 2) Static hero image while video loads (or on error)
            if (!_videoReady || _videoError)
              Positioned.fill(
                child: Image.asset(
                  AppContent.assetHeroBackground,
                  fit: BoxFit.cover,
                ),
              ),
            // 3) Video when ready
            if (_videoReady && _controller != null && _controller!.value.isInitialized)
              Positioned.fill(
                child: FittedBox(
                  // Use cover so the video stays fixed and doesn’t appear to “slide”
                  // as the layout changes; this keeps it behaving like a full-bleed background.
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller!.value.size.width,
                    height: _controller!.value.size.height,
                    child: VideoPlayer(_controller!),
                  ),
                ),
              ),
            // 4) Overlay for text contrast
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.45),
                    AppColors.primary.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
            // 5) Content
            Padding(
              padding: EdgeInsets.only(
                left: horizontalPadding,
                right: horizontalPadding,
                top: topInset + verticalPadding,
                bottom: isMobile ? 16.0 : verticalPadding,
              ),
              child: Align(
                alignment: contentAlignment,
                child: isMobile
                    ? SizedBox(
                        width: double.infinity,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 900),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: crossAlign,
                            children: [
                              const SizedBox(height: 80),
                              Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 20,
                              runSpacing: 14,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: AppShadows.accentButton,
                                  ),
                                  child: FilledButton(
                                    onPressed: () => context.push('/consultations'),
                                    style: FilledButton.styleFrom(
                                      backgroundColor: AppColors.accent,
                                      foregroundColor: AppColors.onAccent,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: width < 600 ? 24 : 32,
                                        vertical: width < 600 ? 14 : 18,
                                      ),
                                      elevation: 0,
                                    ),
                                    child: Text(
                                      l10n.bookConsultation,
                                      style: TextStyle(
                                        fontSize: width < 600 ? 15 : 17,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                OutlinedButton(
                                  onPressed: () => showProfileDialog(context),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.onPrimary,
                                    side: const BorderSide(color: AppColors.onPrimary),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: width < 600 ? 24 : 32,
                                      vertical: width < 600 ? 14 : 18,
                                    ),
                                  ),
                                  child: Text(
                                    l10n.heroStonechatCaption,
                                    style: TextStyle(
                                      fontSize: width < 600 ? 15 : 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            ..._heroHeadlinesAndSubline(context, l10n, textAlign, width),
                          ],
                        ),
                      ),
                    )
                    : ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 900),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: crossAlign,
                          children: [
                            ..._heroHeadlinesAndSubline(context, l10n, textAlign, width),
                            const SizedBox(height: 36),
                            Wrap(
                              alignment: WrapAlignment.start,
                              spacing: 20,
                              runSpacing: 14,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: AppShadows.accentButton,
                                  ),
                                  child: FilledButton(
                                    onPressed: () => context.push('/consultations'),
                                    style: FilledButton.styleFrom(
                                      backgroundColor: AppColors.accent,
                                      foregroundColor: AppColors.onAccent,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: width < 600 ? 24 : 32,
                                        vertical: width < 600 ? 14 : 18,
                                      ),
                                      elevation: 0,
                                    ),
                                    child: Text(
                                      l10n.bookConsultation,
                                      style: TextStyle(
                                        fontSize: width < 600 ? 15 : 17,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                OutlinedButton(
                                  onPressed: () => showProfileDialog(context),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.onPrimary,
                                    side: const BorderSide(color: AppColors.onPrimary),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: width < 600 ? 24 : 32,
                                      vertical: width < 600 ? 14 : 18,
                                    ),
                                  ),
                                  child: Text(
                                    l10n.heroStonechatCaption,
                                    style: TextStyle(
                                      fontSize: width < 600 ? 15 : 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
