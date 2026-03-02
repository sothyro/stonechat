import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:video_player/video_player.dart';

import '../../config/app_content.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../utils/breakpoints.dart';
import '../../utils/launcher_utils.dart';

/// Fragment IDs for Apps & Store sections (used in /apps#fragment).
const String _sectionStonechat = 'stonechat';
const String _sectionPeriod9 = 'period9';
const String _sectionBooks = 'books';
const String _sectionTalisman = 'talisman';

/// Apps & Store page: Stonechat system, Period 9 Mobile App, Talisman Store.
class AppsScreen extends StatefulWidget {
  const AppsScreen({super.key});

  @override
  State<AppsScreen> createState() => _AppsScreenState();
}

class _AppsScreenState extends State<AppsScreen> {
  final GlobalKey _keyStonechat = GlobalKey();
  final GlobalKey _keyPeriod9 = GlobalKey();
  final GlobalKey _keyBooks = GlobalKey();
  final GlobalKey _keyTalisman = GlobalKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollToSectionIfNeeded();
  }

  void _scrollToSectionIfNeeded() {
    final fragment = GoRouterState.of(context).uri.fragment;
    if (fragment.isEmpty) return;
    final width = MediaQuery.sizeOf(context).width;
    // On mobile, skip scroll-to-section so the hero stays visible; desktop keeps section navigation.
    if (Breakpoints.isMobile(width)) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final key = switch (fragment) {
        _sectionStonechat => _keyStonechat,
        _sectionPeriod9 => _keyPeriod9,
        _sectionBooks => _keyBooks,
        _sectionTalisman => _keyTalisman,
        _ => null,
      };
      if (key?.currentContext != null) {
        Scrollable.ensureVisible(
          key!.currentContext!,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          alignment: 0.1,
        );
      }
    });
  }

  static Widget _buildDescriptionWithHighlight(
    BuildContext context,
    String description,
    String highlightPhrase, {
    TextAlign textAlign = TextAlign.center,
    Color? baseColor,
  }) {
    final bodyStyle = (Theme.of(context).textTheme.bodyLarge?.copyWith(
      color: baseColor ?? AppColors.onSurfaceVariantDark,
      height: 1.5,
    ) ?? TextStyle(fontSize: 16, color: baseColor ?? AppColors.onSurfaceVariantDark, height: 1.5));
    final highlightStyle = highlightStyleForLocale(
      context,
      color: baseColor != null ? AppColors.accentLight : AppColors.accent,
      fontWeight: FontWeight.bold,
      fontSize: (bodyStyle.fontSize ?? 16) * 1.45,
    );
    final span = _textSpanWithHighlight(description, highlightPhrase, bodyStyle, highlightStyle);
    return RichText(text: span, textAlign: textAlign);
  }

  static InlineSpan _textSpanWithHighlight(String text, String highlight, TextStyle base, TextStyle highlightStyle) {
    if (highlight.isEmpty) return TextSpan(text: text, style: base);
    final i = text.toLowerCase().indexOf(highlight.toLowerCase());
    if (i < 0) return TextSpan(text: text, style: base);
    return TextSpan(
      children: [
        if (i > 0) TextSpan(text: text.substring(0, i), style: base),
        TextSpan(text: text.substring(i, i + highlight.length), style: highlightStyle),
        if (i + highlight.length < text.length)
          TextSpan(text: text.substring(i + highlight.length), style: base),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = Breakpoints.isMobile(width);

    return Container(
      width: double.infinity,
      color: AppColors.backgroundDark,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Hero: background image + title + subline + description + Stonechat system card.
          SizedBox(
            height: isNarrow ? 780 : 720,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(
                  child: Image.asset(
                    AppContent.assetContactHero,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox.expand(),
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.backgroundDark.withValues(alpha: 0.72),
                          AppColors.backgroundDark.withValues(alpha: 0.88),
                        ],
                      ),
                    ),
                  ),
                ),
                // Content centered vertically with extra top clearance from the main menu (match Consultations page).
                Align(
                  alignment: const Alignment(0, 0.12),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      isNarrow ? 16 : 24,
                      isNarrow ? 148 : 120,
                      isNarrow ? 16 : 24,
                      isNarrow ? 48 : 56,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          l10n.appsPageTitle,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: AppColors.onPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: isNarrow ? 20 : 24),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 640),
                          child: _buildDescriptionWithHighlight(
                            context,
                            l10n.appsPageDescription,
                            l10n.appsPageDescriptionHighlight,
                          ),
                        ),
                        SizedBox(height: isNarrow ? 32 : 40),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1000),
                          child: _SpotlightSection(
                            icon: LucideIcons.cpu,
                            title: l10n.stonechatSpotlightTitle,
                            description: l10n.stonechatSpotlightDesc,
                            transparent: true,
                            child: _MarketplaceCtaRow(
                              primaryButton: FilledButton.icon(
                                onPressed: () => launchUrlExternal(AppContent.baziSystemUrl),
                                icon: const Icon(LucideIcons.externalLink, size: 20),
                                label: Text(l10n.openStonechatCta),
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.accent,
                                  foregroundColor: AppColors.onAccent,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                ),
                              ),
                              secondaryLabel: '${l10n.bookStorePricePrefix}${l10n.spotlightSubscriptionPrice}${l10n.spotlightPricePerMonth}',
                              secondaryButton: OutlinedButton.icon(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(l10n.marketplaceAddedToCart),
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: AppColors.surfaceElevatedDark,
                                    ),
                                  );
                                },
                                icon: const Icon(LucideIcons.creditCard, size: 18),
                                label: Text(l10n.spotlightSubscribe),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.accent,
                                  side: const BorderSide(color: AppColors.accent),
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                ),
                              ),
                            ),
                            ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Store section: vibrant product showcase below hero.
          Padding(
            padding: EdgeInsets.only(
              top: isNarrow ? 40 : 56,
              bottom: isNarrow ? 48 : 64,
              left: isNarrow ? 16 : 24,
              right: isNarrow ? 16 : 24,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _StoreSectionHeader(
                      heading: l10n.appsFeatureShowcaseHeading,
                      subline: l10n.appsPageSubline,
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 680),
                        child: _buildDescriptionWithHighlight(
                          context,
                          l10n.appsFeatureShowcaseMarketingDesc,
                          l10n.appsFeatureShowcaseMarketingHighlight,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    _MarketplaceCategoryStrip(l10n: l10n),
                    const SizedBox(height: 48),
                    _SectionAnchor(
                      key: _keyStonechat,
                      child: _FeaturedStonechatSection(l10n: l10n),
                    ),
                    const SizedBox(height: 56),
                    _AppFeatureShowcase(
                      features: [
                        (AppContent.assetAppQiMen, l10n.appFeatureQiMen),
                        (AppContent.assetAppBaziKhmer, l10n.appFeatureBaziKhmer),
                        (AppContent.assetAppBaziReport, l10n.appFeatureBaziReport),
                        (AppContent.assetAppBaziAge, l10n.appFeatureBaziAge),
                        (AppContent.assetAppBaziStars, l10n.appFeatureBaziStars),
                        (AppContent.assetAppBaziLife, l10n.appFeatureBaziLife),
                        (AppContent.assetAppAdvancedFeatures, l10n.appFeatureAdvancedFeatures),
                        (AppContent.assetAppDateSelection, l10n.appFeatureDateSelection),
                        (AppContent.assetAppMarriage, l10n.appFeatureMarriage),
                      ],
                    ),
                    const SizedBox(height: 56),
                    _SectionAnchor(
                      key: _keyPeriod9,
                      child: _FeaturedPeriod9Section(l10n: l10n),
                    ),
                    const SizedBox(height: 56),
                    _SectionAnchor(
                      key: _keyBooks,
                      child: _BookStoreSection(l10n: l10n),
                    ),
                    const SizedBox(height: 56),
                    _SectionAnchor(
                      key: _keyTalisman,
                      child: _TalismanStoreSection(l10n: l10n),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Wrapper that holds a [GlobalKey] for scroll-to-section.
class _SectionAnchor extends StatelessWidget {
  const _SectionAnchor({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}

/// Row of primary CTA, optional price label, and secondary (e.g. Subscribe) for marketplace hero.
class _MarketplaceCtaRow extends StatelessWidget {
  const _MarketplaceCtaRow({
    required this.primaryButton,
    this.secondaryLabel,
    this.secondaryButton,
  });

  final Widget primaryButton;
  final String? secondaryLabel;
  final Widget? secondaryButton;

  @override
  Widget build(BuildContext context) {
    final isNarrow = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);
    if (secondaryButton == null) return primaryButton;
    return isNarrow
        ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              primaryButton,
              if (secondaryLabel != null) ...[
                const SizedBox(height: 12),
                Text(
                  secondaryLabel!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.onSurfaceVariantDark,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 12),
              secondaryButton!,
            ],
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              primaryButton,
              if (secondaryLabel != null) ...[
                const SizedBox(width: 16),
                Text(
                  secondaryLabel!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.onSurfaceVariantDark,
                      ),
                ),
                const SizedBox(width: 16),
              ],
              if (secondaryButton != null) secondaryButton!,
            ],
          );
  }
}

/// Store section header with highlight typography.
class _StoreSectionHeader extends StatelessWidget {
  const _StoreSectionHeader({required this.heading, required this.subline});

  final String heading;
  final String subline;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          heading,
          style: highlightStyleForLocale(
            context,
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: AppColors.accent,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          subline,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.onSurfaceVariantDark,
                height: 1.5,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Category pills for marketplace: Digital, Books, Talismans — tap to scroll to section.
class _MarketplaceCategoryStrip extends StatelessWidget {
  const _MarketplaceCategoryStrip({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final isNarrow = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);
    final items = [
      (l10n.marketplaceCategoryDigital, _sectionStonechat),
      (l10n.marketplaceCategoryBooks, _sectionBooks),
      (l10n.marketplaceCategoryTalismans, _sectionTalisman),
    ];
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      runSpacing: 10,
      children: items.map((e) {
        return ActionChip(
          label: Text(e.$1),
          onPressed: () => context.go('/apps#${e.$2}'),
          backgroundColor: AppColors.surfaceElevatedDark,
          side: BorderSide(color: AppColors.borderLight.withValues(alpha: 0.4)),
          labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.onPrimary,
              ),
          padding: EdgeInsets.symmetric(
            horizontal: isNarrow ? 14 : 18,
            vertical: isNarrow ? 8 : 10,
          ),
        );
      }).toList(),
    );
  }
}

/// Featured Stonechat system block: hero video (looping) + CTA.
class _FeaturedStonechatSection extends StatefulWidget {
  const _FeaturedStonechatSection({required this.l10n});

  final AppLocalizations l10n;

  @override
  State<_FeaturedStonechatSection> createState() => _FeaturedStonechatSectionState();
}

class _FeaturedStonechatSectionState extends State<_FeaturedStonechatSection> {
  bool _hovered = false;
  bool _muted = true;
  VideoPlayerController? _videoController;
  bool _videoReady = false;
  void Function()? _loopListener;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _initVideo();
    });
  }

  Future<void> _initVideo() async {
    try {
      final VideoPlayerController controller = VideoPlayerController.asset(
        AppContent.assetAppPageVideo,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );

      await controller.initialize();
      if (!mounted) {
        controller.dispose();
        return;
      }
      controller.setLooping(true);
      controller.setVolume(_muted ? 0 : 1);
      // Fallback loop: when position reaches end, seek to start and play (reliable on mobile/web where setLooping can fail).
      void listener() {
        final duration = controller.value.duration;
        if (duration.inMilliseconds <= 0) return;
        final pos = controller.value.position.inMilliseconds;
        final end = duration.inMilliseconds - 200;
        if (pos >= end) {
          controller.seekTo(Duration.zero);
          controller.play();
        }
      }
      _loopListener = listener;
      controller.addListener(_loopListener!);
      await controller.play();
      if (!mounted) {
        controller.removeListener(_loopListener!);
        controller.dispose();
        return;
      }
      setState(() {
        _videoController = controller;
        _videoReady = true;
      });
      // On mobile, first play() can fail to start; trigger play again after build.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _videoController != null && !_videoController!.value.isPlaying) {
          _videoController!.play();
        }
      });
    } catch (e) {
      // Silently handle errors - fallback to image will be shown
      if (mounted) {
        setState(() {
          _videoReady = false;
        });
      }
    }
  }

  void _toggleMute() {
    if (_videoController == null) return;
    setState(() {
      _muted = !_muted;
      _videoController!.setVolume(_muted ? 0 : 1);
    });
  }

  @override
  void dispose() {
    final c = _videoController;
    if (c != null && _loopListener != null) {
      c.removeListener(_loopListener!);
    }
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isNarrow = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _hovered
                ? AppColors.borderLight.withValues(alpha: 0.6)
                : AppColors.borderDark.withValues(alpha: 0.8),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 24,
              offset: const Offset(0, 8),
              spreadRadius: -4,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: -2,
            ),
            if (_hovered)
              BoxShadow(
                color: AppColors.accentGlow.withValues(alpha: 0.12),
                blurRadius: 28,
                offset: const Offset(0, 6),
                spreadRadius: 0,
              ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevatedDark,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 1,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: _videoReady &&
                              _videoController != null &&
                              _videoController!.value.isInitialized
                          ? FittedBox(
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: _videoController!.value.size.width,
                                height: _videoController!.value.size.height,
                                child: VideoPlayer(_videoController!),
                              ),
                            )
                          : Image.asset(
                              AppContent.assetAcademy,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (_, __, ___) => Center(
                                child: Icon(
                                  LucideIcons.cpu,
                                  size: 64,
                                  color: AppColors.accent.withValues(alpha: 0.6),
                                ),
                              ),
                            ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Material(
                      color: Colors.black.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(24),
                      child: InkWell(
                        onTap: _toggleMute,
                        borderRadius: BorderRadius.circular(24),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Icon(
                            _muted ? LucideIcons.volumeX : LucideIcons.volume2,
                            size: 24,
                            color: AppColors.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 28,
                    left: 28,
                    right: 28,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.l10n.stonechatSpotlightTitle,
                          style: highlightStyleForLocale(
                            context,
                            fontSize: isNarrow ? 30 : 38,
                            fontWeight: FontWeight.bold,
                            color: AppColors.accentLight,
                          ).copyWith(shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.7),
                                blurRadius: 12,
                                offset: const Offset(0, 2),
                              ),
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.4),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        _AppsScreenState._buildDescriptionWithHighlight(
                          context,
                          widget.l10n.stonechatSpotlightTagline,
                          widget.l10n.stonechatSpotlightTaglineHighlight,
                          baseColor: AppColors.onPrimary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Period 9 section with prominent download buttons.
class _FeaturedPeriod9Section extends StatelessWidget {
  const _FeaturedPeriod9Section({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = Breakpoints.isMobile(width);
    final padding = isNarrow ? 20.0 : 32.0;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surfaceElevatedDark,
            AppColors.surfaceElevatedDark.withValues(alpha: 0.95),
            AppColors.backgroundDark.withValues(alpha: 0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.3), width: 1),
        boxShadow: [
          ...AppShadows.card,
          BoxShadow(
            color: AppColors.accentGlow.withValues(alpha: 0.08),
            blurRadius: 24,
            spreadRadius: 0,
          ),
        ],
      ),
      child: isNarrow
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      l10n.period9SpotlightTitle,
                      style: highlightStyleForLocale(
                        context,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.accent,
                      ),
                    ),
                    const SizedBox(width: 10),
                    _FreeBadge(l10n: l10n),
                  ],
                ),
                const SizedBox(height: 6),
                _AppsScreenState._buildDescriptionWithHighlight(
                  context,
                  l10n.period9SpotlightTagline,
                  l10n.period9SpotlightTaglineHighlight,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.period9SpotlightDesc,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.onSurfaceVariantDark,
                        height: 1.5,
                        fontSize: 15,
                      ),
                ),
                const SizedBox(height: 20),
                _Period9Screenshots(),
                const SizedBox(height: 24),
                _DownloadButtonsRow(l10n: l10n),
                const SizedBox(height: 12),
                Text(
                  l10n.period9PremiumLabel,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariantDark,
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: _Period9Screenshots(),
                ),
                const SizedBox(width: 40),
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text(
                            l10n.period9SpotlightTitle,
                            style: highlightStyleForLocale(
                              context,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accent,
                            ),
                          ),
                          const SizedBox(width: 12),
                          _FreeBadge(l10n: l10n),
                        ],
                      ),
                      const SizedBox(height: 6),
                      _AppsScreenState._buildDescriptionWithHighlight(
                        context,
                        l10n.period9SpotlightTagline,
                        l10n.period9SpotlightTaglineHighlight,
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.period9SpotlightDesc,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.onSurfaceVariantDark,
                              height: 1.5,
                            ),
                      ),
                      const SizedBox(height: 28),
                      _DownloadButtonsRow(l10n: l10n),
                      const SizedBox(height: 12),
                      Text(
                        l10n.period9PremiumLabel,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.onSurfaceVariantDark,
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

/// Small "Free" badge for marketplace pricing.
class _FreeBadge extends StatelessWidget {
  const _FreeBadge({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.5)),
      ),
      child: Text(
        l10n.period9PriceFree,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.accent,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _DownloadButtonsRow extends StatelessWidget {
  const _DownloadButtonsRow({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final isNarrow = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);

    return isNarrow
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 56,
                child: _ProminentStoreButton(
                  label: l10n.downloadOnAppStore,
                  icon: Icons.apple,
                  url: AppContent.period9AppStoreUrl,
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 56,
                child: _ProminentStoreButton(
                  label: l10n.getItOnGooglePlay,
                  icon: Icons.play_circle_filled,
                  url: AppContent.period9PlayStoreUrl,
                ),
              ),
            ],
          )
        : IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: _ProminentStoreButton(
                      label: l10n.downloadOnAppStore,
                      icon: Icons.apple,
                      url: AppContent.period9AppStoreUrl,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: _ProminentStoreButton(
                      label: l10n.getItOnGooglePlay,
                      icon: Icons.play_circle_filled,
                      url: AppContent.period9PlayStoreUrl,
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}

class _ProminentStoreButton extends StatelessWidget {
  const _ProminentStoreButton({
    required this.label,
    required this.icon,
    required this.url,
  });

  final String label;
  final IconData icon;
  final String? url;

  @override
  Widget build(BuildContext context) {
    final enabled = url != null && url!.isNotEmpty;

    return FilledButton.icon(
      onPressed: enabled ? () => launchUrlExternal(url!) : null,
      icon: Icon(icon, size: 28, color: enabled ? AppColors.onAccent : AppColors.onSurfaceVariantDark),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: enabled ? AppColors.onAccent : AppColors.onSurfaceVariantDark,
        ),
      ),
      style: FilledButton.styleFrom(
        backgroundColor: enabled ? AppColors.accent : AppColors.surfaceElevatedDark,
        foregroundColor: AppColors.onAccent,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: enabled ? 3 : 0,
        shadowColor: AppColors.accentGlow.withValues(alpha: 0.45),
      ),
    );
  }
}

/// Book Store section: creative heading, marketing copy, two featured books with Add to Cart.
class _BookStoreSection extends StatelessWidget {
  const _BookStoreSection({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = Breakpoints.isMobile(width);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.bookStoreSectionHeading,
          style: highlightStyleForLocale(
            context,
            fontSize: isNarrow ? 28 : 34,
            fontWeight: FontWeight.bold,
            color: AppColors.accent,
          ),
        ),
        const SizedBox(height: 8),
        _AppsScreenState._buildDescriptionWithHighlight(
          context,
          l10n.bookStoreSectionTagline,
          l10n.bookStoreSectionTaglineHighlight,
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 16),
        _AppsScreenState._buildDescriptionWithHighlight(
          context,
          l10n.bookStoreSectionMarketing,
          l10n.bookStoreSectionMarketingHighlight,
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 32),
        isNarrow
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _BookStoreCard(
                    l10n: l10n,
                    asset: AppContent.assetBook1,
                    title: l10n.bookStoreBook1Title,
                    subtitle: l10n.bookStoreBook1Subtitle,
                    price: l10n.bookStoreBook1Price,
                    showBestseller: true,
                  ),
                  const SizedBox(height: 24),
                  _BookStoreCard(
                    l10n: l10n,
                    asset: AppContent.assetBook2,
                    title: l10n.bookStoreBook2Title,
                    subtitle: l10n.bookStoreBook2Subtitle,
                    price: l10n.bookStoreBook2Price,
                    showBestseller: false,
                  ),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _BookStoreCard(
                      l10n: l10n,
                      asset: AppContent.assetBook1,
                      title: l10n.bookStoreBook1Title,
                      subtitle: l10n.bookStoreBook1Subtitle,
                      price: l10n.bookStoreBook1Price,
                      showBestseller: true,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _BookStoreCard(
                      l10n: l10n,
                      asset: AppContent.assetBook2,
                      title: l10n.bookStoreBook2Title,
                      subtitle: l10n.bookStoreBook2Subtitle,
                      price: l10n.bookStoreBook2Price,
                      showBestseller: false,
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}

/// Single book card with cover, title, price, and Add to Cart.
class _BookStoreCard extends StatefulWidget {
  const _BookStoreCard({
    required this.l10n,
    required this.asset,
    required this.title,
    required this.subtitle,
    required this.price,
    this.showBestseller = false,
  });

  final AppLocalizations l10n;
  final String asset;
  final String title;
  final String subtitle;
  final String price;
  final bool showBestseller;

  @override
  State<_BookStoreCard> createState() => _BookStoreCardState();
}

class _BookStoreCardState extends State<_BookStoreCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isNarrow = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);
    final prefix = widget.l10n.bookStorePricePrefix;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.all(isNarrow ? 16 : 20),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevatedDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _hovered
                ? AppColors.accent.withValues(alpha: 0.5)
                : AppColors.borderDark,
            width: _hovered ? 2 : 1,
          ),
          boxShadow: _hovered ? AppShadows.cardHover : AppShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: 3 / 4,
                    child: Image.asset(
                      widget.asset,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.borderDark,
                        child: Icon(
                          LucideIcons.bookOpen,
                          size: 48,
                          color: AppColors.onSurfaceVariantDark.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ),
                ),
                if (widget.showBestseller)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        widget.l10n.bookStoreBestsellerBadge,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.onAccent,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: isNarrow ? 14 : 18),
            Text(
              widget.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              widget.subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariantDark,
                    height: 1.4,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$prefix${widget.price}',
                  style: highlightStyleForLocale(
                    context,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accent,
                  ),
                ),
                FilledButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(widget.l10n.bookStoreAddedToCart),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: AppColors.surfaceElevatedDark,
                        action: SnackBarAction(
                          label: widget.l10n.buttonOk,
                          textColor: AppColors.accent,
                          onPressed: () {},
                        ),
                      ),
                    );
                  },
                  icon: const Icon(LucideIcons.shoppingCart, size: 18),
                  label: Text(widget.l10n.bookStoreAddToCart),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.onAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Talisman Store as a product section with highlight title.
class _TalismanStoreSection extends StatelessWidget {
  const _TalismanStoreSection({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.talismanStoreSpotlightTitle,
          style: highlightStyleForLocale(
            context,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.accent,
          ),
        ),
        const SizedBox(height: 6),
        _AppsScreenState._buildDescriptionWithHighlight(
          context,
          l10n.talismanStoreSpotlightTagline,
          l10n.talismanStoreSpotlightTaglineHighlight,
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 8),
        Text(
          l10n.talismanStoreSpotlightDesc,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.onSurfaceVariantDark,
                height: 1.5,
              ),
        ),
        const SizedBox(height: 28),
        _TalismanGrid(l10n: l10n),
      ],
    );
  }
}

/// App spotlight style: icon, title, description, and CTA area.
class _SpotlightSection extends StatelessWidget {
  const _SpotlightSection({
    required this.icon,
    required this.title,
    required this.description,
    required this.child,
    this.transparent = false,
  });

  final IconData icon;
  final String title;
  final String description;
  final Widget child;
  final bool transparent;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = Breakpoints.isMobile(width);

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: transparent
            ? AppColors.surfaceElevatedDark.withValues(alpha: 0.72)
            : AppColors.surfaceElevatedDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: transparent
              ? AppColors.borderLight.withValues(alpha: 0.25)
              : AppColors.borderDark,
          width: transparent ? 1.5 : 1,
        ),
        boxShadow: transparent
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 2),
                ),
                BoxShadow(
                  color: AppColors.accentGlow.withValues(alpha: 0.06),
                  blurRadius: 20,
                  spreadRadius: 0,
                  offset: Offset.zero,
                ),
              ]
            : AppShadows.card,
      ),
      child: isNarrow
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIcon(context),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.onSurfaceVariantDark,
                        height: 1.5,
                      ),
                ),
                const SizedBox(height: 24),
                child,
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIcon(context),
                const SizedBox(width: 28),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        description,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.onSurfaceVariantDark,
                              height: 1.5,
                            ),
                      ),
                      const SizedBox(height: 24),
                      child,
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.4)),
      ),
      child: Icon(icon, size: 48, color: AppColors.accent),
    );
  }
}

void _showPeriod9FullImage(BuildContext context, String asset) {
  showDialog<void>(
    context: context,
    barrierColor: Colors.black87,
    barrierDismissible: true,
    builder: (context) => Dialog.fullscreen(
      backgroundColor: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            behavior: HitTestBehavior.opaque,
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Center(
                child: Image.asset(
                  asset,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Icon(
                    LucideIcons.imageOff,
                    size: 48,
                    color: AppColors.onSurfaceVariantDark.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: IconButton.filled(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Colors.white),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black54,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

/// Two Period 9 app screenshots. Desktop: stacked with divider. Mobile: side-by-side, compact.
class _Period9Screenshots extends StatelessWidget {
  const _Period9Screenshots();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = width < Breakpoints.mobile;

        if (isMobile) {
          final imageHeight = (width * 0.52).clamp(160.0, 220.0);
          final gap = 12.0;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: _Period9Screenshot(
                  asset: AppContent.assetPeriod9_1,
                  height: imageHeight,
                  onTap: () => _showPeriod9FullImage(context, AppContent.assetPeriod9_1),
                ),
              ),
              SizedBox(width: gap),
              Expanded(
                child: _Period9Screenshot(
                  asset: AppContent.assetPeriod9_2,
                  height: imageHeight,
                  onTap: () => _showPeriod9FullImage(context, AppContent.assetPeriod9_2),
                ),
              ),
            ],
          );
        }

        final imageHeight = (width * 0.5).clamp(280.0, 420.0);
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Period9Screenshot(asset: AppContent.assetPeriod9_1, height: imageHeight),
            const SizedBox(height: 20),
            Divider(height: 1, color: AppColors.borderDark, indent: 0, endIndent: 0),
            const SizedBox(height: 20),
            _Period9Screenshot(asset: AppContent.assetPeriod9_2, height: imageHeight),
          ],
        );
      },
    );
  }
}

class _Period9Screenshot extends StatelessWidget {
  const _Period9Screenshot({
    required this.asset,
    required this.height,
    this.onTap,
  });

  final String asset;
  final double height;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderDark, width: 1),
        boxShadow: AppShadows.card,
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        asset,
        fit: BoxFit.cover,
        width: double.infinity,
        height: height,
        errorBuilder: (_, __, ___) => SizedBox(
          width: double.infinity,
          height: height,
          child: Center(
            child: Icon(LucideIcons.smartphone, size: 40, color: AppColors.onSurfaceVariantDark.withValues(alpha: 0.5)),
          ),
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: content,
      );
    }
    return content;
  }
}

/// Product showcase: grid of app feature screens with labels.
class _AppFeatureShowcase extends StatelessWidget {
  const _AppFeatureShowcase({required this.features});

  final List<(String asset, String title)> features;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final crossAxisCount = Breakpoints.isMobile(width) ? 2 : (width < Breakpoints.tablet ? 2 : 3);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 3 / 4,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final e = features[index];
        return _AppFeatureCard(asset: e.$1, title: e.$2);
      },
    );
  }
}

class _AppFeatureCard extends StatefulWidget {
  const _AppFeatureCard({required this.asset, required this.title});

  final String asset;
  final String title;

  @override
  State<_AppFeatureCard> createState() => _AppFeatureCardState();
}

class _AppFeatureCardState extends State<_AppFeatureCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: AppColors.surfaceElevatedDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered ? AppColors.borderLight.withValues(alpha: 0.5) : AppColors.borderDark,
            width: _hovered ? 1.5 : 1,
          ),
          boxShadow: _hovered ? AppShadows.cardHover : AppShadows.card,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.asset(
                widget.asset,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Center(
                  child: Icon(LucideIcons.image, size: 48, color: AppColors.onSurfaceVariantDark.withValues(alpha: 0.5)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Text(
                widget.title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Product grid for Talisman Store with price and Add to Cart.
class _TalismanGrid extends StatelessWidget {
  const _TalismanGrid({required this.l10n});

  final AppLocalizations l10n;

  static String _talismanTitle(AppLocalizations l10n, int index) {
    return switch (index) {
      1 => l10n.talismanProduct1Title,
      2 => l10n.talismanProduct2Title,
      3 => l10n.talismanProduct3Title,
      4 => l10n.talismanProduct4Title,
      5 => l10n.talismanProduct5Title,
      6 => l10n.talismanProduct6Title,
      7 => l10n.talismanProduct7Title,
      8 => l10n.talismanProduct8Title,
      9 => l10n.talismanProduct9Title,
      _ => l10n.talismanProduct1Title,
    };
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final crossAxisCount = Breakpoints.isMobile(width) ? 2 : 3;
    final price = l10n.talismanProductPrice;
    final prefix = l10n.bookStorePricePrefix;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      childAspectRatio: 1 / 1.42,
      children: List.generate(
        9,
        (i) => _TalismanProductCard(
          l10n: l10n,
          title: _talismanTitle(l10n, i + 1),
          price: price,
          pricePrefix: prefix,
          index: i + 1,
        ),
      ),
    );
  }
}

class _TalismanProductCard extends StatefulWidget {
  const _TalismanProductCard({
    required this.l10n,
    required this.title,
    required this.price,
    required this.pricePrefix,
    required this.index,
  });

  final AppLocalizations l10n;
  final String title;
  final String price;
  final String pricePrefix;
  final int index;

  @override
  State<_TalismanProductCard> createState() => _TalismanProductCardState();
}

class _TalismanProductCardState extends State<_TalismanProductCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isNarrow = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(isNarrow ? 12 : 16),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevatedDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _hovered ? AppColors.accent.withValues(alpha: 0.5) : AppColors.borderDark,
            width: _hovered ? 2 : 1,
          ),
          boxShadow: _hovered ? AppShadows.cardHover : AppShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(
                    LucideIcons.sparkles,
                    size: 40,
                    color: AppColors.accent.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ),
            SizedBox(height: isNarrow ? 10 : 12),
            Text(
              widget.title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${widget.pricePrefix}${widget.price}',
                  style: highlightStyleForLocale(
                    context,
                    fontSize: isNarrow ? 18 : 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accent,
                  ),
                ),
                FilledButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(widget.l10n.marketplaceAddedToCart),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: AppColors.surfaceElevatedDark,
                        action: SnackBarAction(
                          label: widget.l10n.buttonOk,
                          textColor: AppColors.accent,
                          onPressed: () {},
                        ),
                      ),
                    );
                  },
                  icon: const Icon(LucideIcons.shoppingCart, size: 16),
                  label: Text(isNarrow ? widget.l10n.buttonAdd : widget.l10n.bookStoreAddToCart),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.onAccent,
                    padding: EdgeInsets.symmetric(
                      horizontal: isNarrow ? 10 : 14,
                      vertical: isNarrow ? 8 : 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
