import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:video_player/video_player.dart';

import '../../config/app_content.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../utils/breakpoints.dart';
import '../../widgets/section_header.dart';
import '../../utils/launcher_utils.dart';

/// Fragment IDs for Book page sections (used in /book#fragment).
const String _sectionStonechat = 'stonechat';
const String _sectionPeriod9 = 'period9';
const String _sectionBooks = 'books';

/// Book page: Stonechat, books, clinic app—no Caishen section.
class BookScreen extends StatefulWidget {
  const BookScreen({super.key});

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  final GlobalKey _keyStonechat = GlobalKey();
  final GlobalKey _keyPeriod9 = GlobalKey();
  final GlobalKey _keyBooks = GlobalKey();

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
      color: baseColor != null ? AppColors.serviceBookCreationLight : AppColors.serviceBookCreation,
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

    // Page copy is intentionally focused on publications & book services only.
    const heroOverline = 'Publications & Book Services';
    const heroTitle = 'From first idea to finished book';
    const heroSubtitle =
        'Turn your expertise into a beautiful, professionally published book. '
        'Stonechat guides you from brainstorming and writing to design, printing, and launch.';

    return Container(
      width: double.infinity,
      color: AppColors.backgroundDark,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Hero: background image + title + subline + description + CTA (height matches Apps).
          SizedBox(
            height: isNarrow ? 560 : 520,
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
                    padding: EdgeInsets.fromLTRB(isNarrow ? 16 : 24, isNarrow ? 148 : 120, isNarrow ? 16 : 24, isNarrow ? 40 : 48),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SectionHeader(
                          overline: heroOverline,
                          title: heroTitle,
                          isNarrow: isNarrow,
                        ),
                        SizedBox(height: isNarrow ? 20 : 24),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 640),
                          child: Text(
                            heroSubtitle,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: AppColors.onPrimary.withValues(alpha: 0.9),
                                  height: 1.6,
                                ),
                          ),
                        ),
                        SizedBox(height: isNarrow ? 32 : 40),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1000),
                          child: _HeroCtaRow(isNarrow: isNarrow),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Main content: services overview, process, pricing, and book catalogue.
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
                    const _BookServicesOverviewSection(),
                    SizedBox(height: isNarrow ? 40 : 56),
                    const _BookProcessSection(),
                    SizedBox(height: isNarrow ? 40 : 56),
                    const _BookPricingSection(),
                    SizedBox(height: isNarrow ? 40 : 56),
                    _PersuasionBooksSection(l10n: l10n),
                    SizedBox(height: isNarrow ? 40 : 56),
                    _SectionAnchor(
                      key: _keyBooks,
                      child: _BookStoreSection(l10n: l10n),
                    ),
                    SizedBox(height: isNarrow ? 24 : 32),
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

/// Hero CTA row for Publications page: primary “Start your book” + secondary contact action.
class _HeroCtaRow extends StatelessWidget {
  const _HeroCtaRow({required this.isNarrow});

  final bool isNarrow;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final primary = FilledButton.icon(
      onPressed: () => context.go('/consultations'),
      icon: const Icon(LucideIcons.bookOpenCheck, size: 20),
      label: const Text('Start your book project'),
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.serviceBookCreation,
        foregroundColor: AppColors.onAccent,
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
        textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
    );

    final secondary = OutlinedButton.icon(
      onPressed: () => context.go('/contact'),
      icon: const Icon(LucideIcons.messageCircle, size: 18),
      label: Text(l10n.contactUs),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.onPrimary,
        side: const BorderSide(color: AppColors.borderLight, width: 1.3),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
      ),
    );

    if (isNarrow) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          primary,
          const SizedBox(height: 12),
          Center(child: secondary),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        primary,
        const SizedBox(width: 18),
        secondary,
      ],
    );
  }
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

/// Category pills for marketplace: Digital, Books, Book Store — tap to scroll to section.
class _MarketplaceCategoryStrip extends StatelessWidget {
  const _MarketplaceCategoryStrip({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final isNarrow = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);
    final items = [
      (l10n.marketplaceCategoryDigital, _sectionStonechat),
      (l10n.marketplaceCategoryBooks, _sectionBooks),
    ];
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      runSpacing: 10,
      children: items.map((e) {
        return ActionChip(
          label: Text(e.$1),
          onPressed: () => context.go('/book#${e.$2}'),
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
                color: AppColors.serviceBookCreation.withValues(alpha: 0.12),
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
                                  color: AppColors.serviceBookCreation.withValues(alpha: 0.6),
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
                            color: AppColors.serviceBookCreationLight,
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
                        _BookScreenState._buildDescriptionWithHighlight(
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

/// Services overview section: three core offerings for authors.
class _BookServicesOverviewSection extends StatelessWidget {
  const _BookServicesOverviewSection();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = Breakpoints.isMobile(width);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SectionHeader(
          overline: 'Book services',
          title: 'Everything you need to publish with confidence',
          isNarrow: false,
        ),
        const SizedBox(height: 18),
        Text(
          'Whether you are starting with a rough idea, a draft manuscript, or a finished book that needs design and printing, '
          'Stonechat offers an end-to-end publication service tailored to busy leaders and experts.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.onSurfaceVariantDark,
                height: 1.6,
              ),
        ),
        const SizedBox(height: 28),
        LayoutBuilder(
          builder: (context, constraints) {
            final useColumn = isNarrow || constraints.maxWidth < 820;
            final children = [
              _ServiceCard(
                icon: LucideIcons.brain,
                title: 'Book strategy & structure',
                body:
                    'Clarify your core message, define who the book is for, and shape your ideas into a clear chapter outline. '
                    'We help you decide what belongs in the book and what can stay out, so writing becomes faster and more focused.',
                highlight: 'Ideal for leaders and experts who know what they want to say but are not sure how to organise it.',
              ),
              _ServiceCard(
                icon: LucideIcons.fileText,
                title: 'Writing, editing & translation',
                body:
                    'Through interviews, co-writing and careful editing, we turn your knowledge into polished, publication-ready chapters. '
                    'Our editorial team writes in your voice in both English and Khmer, then refines every page for accuracy and flow.',
                highlight: 'You stay the author and decision-maker; we do the heavy lifting on the page from first draft to final proof.',
              ),
              _ServiceCard(
                icon: LucideIcons.layoutDashboard,
                title: 'Design, layout & publishing',
                body:
                    'We create a professional cover, design clean interior pages, and prepare all print and digital files your printer needs. '
                    'Our team coordinates specifications, quotations and test prints so your finished books look world-class on every shelf.',
                highlight: 'One partner from design concept to printed books in your hands, ready for launch.',
              ),
            ];

            if (useColumn) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < children.length; i++) ...[
                    if (i > 0) const SizedBox(height: 18),
                    children[i],
                  ],
                ],
              );
            }

            // Desktop: keep all cards the same height by wrapping row in IntrinsicHeight.
            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < children.length; i++) ...[
                    if (i > 0) const SizedBox(width: 18),
                    Expanded(child: children[i]),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ServiceCard extends StatefulWidget {
  const _ServiceCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.highlight,
  });

  final IconData icon;
  final String title;
  final String body;
  final String highlight;

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevatedDark,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: _hovered ? AppColors.serviceBookCreation.withValues(alpha: 0.5) : AppColors.borderDark,
            width: _hovered ? 2 : 1,
          ),
          boxShadow: _hovered ? AppShadows.cardHover : AppShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.serviceBookCreation.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.serviceBookCreation.withValues(alpha: 0.6)),
              ),
              child: Icon(widget.icon, size: 26, color: AppColors.serviceBookCreation),
            ),
            const SizedBox(height: 14),
            Text(
              widget.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.body,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurfaceVariantDark,
                    height: 1.55,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.highlight,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.serviceBookCreationLight,
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Process section: communicates the end-to-end book journey in clear steps.
class _BookProcessSection extends StatelessWidget {
  const _BookProcessSection();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = Breakpoints.isMobile(width);

    final steps = [
      (
        LucideIcons.lightbulb,
        '1. Discovery & brainstorming',
        'We explore your story, goals, audience, and timeline, then shape them into a clear book concept and working outline.'
      ),
      (
        LucideIcons.fileText,
        '2. Writing & editorial',
        'Through interviews, draft reviews, and editorial passes, we co-create chapters that sound like you and read like a pro.'
      ),
      (
        LucideIcons.layoutTemplate,
        '3. Design & production',
        'We design the cover, lay out the pages, prepare print and digital files, and manage printers to agreed quality standards.'
      ),
      (
        LucideIcons.rocket,
        '4. Launch & beyond',
        'You receive finished books and launch materials; we can also support events, media, and social content to amplify impact.'
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surfaceElevatedDark.withValues(alpha: 0.96),
            AppColors.backgroundDark,
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.28)),
        boxShadow: [
          ...AppShadows.card,
          BoxShadow(
            color: AppColors.serviceBookCreation.withValues(alpha: 0.09),
            blurRadius: 28,
            spreadRadius: 0,
          ),
        ],
      ),
      padding: EdgeInsets.all(isNarrow ? 18 : 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'How your book comes to life',
            style: highlightStyleForLocale(
              context,
              fontSize: isNarrow ? 24 : 30,
              fontWeight: FontWeight.bold,
              color: AppColors.serviceBookCreation,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'A single, guided process from first conversation to printed books in your hands.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceVariantDark,
                  height: 1.6,
                ),
          ),
          const SizedBox(height: 22),
          LayoutBuilder(
            builder: (context, constraints) {
              final useColumn = isNarrow || constraints.maxWidth < 900;
              if (useColumn) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = 0; i < steps.length; i++) ...[
                      if (i > 0) const SizedBox(height: 14),
                      _BookProcessStep(
                        icon: steps[i].$1,
                        title: steps[i].$2,
                        body: steps[i].$3,
                        index: i + 1,
                        isLast: i == steps.length - 1,
                      ),
                    ],
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < steps.length; i++) ...[
                    if (i > 0) const SizedBox(width: 18),
                    Expanded(
                      child: _BookProcessStep(
                        icon: steps[i].$1,
                        title: steps[i].$2,
                        body: steps[i].$3,
                        index: i + 1,
                        isLast: i == steps.length - 1,
                        horizontal: true,
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _BookProcessStep extends StatelessWidget {
  const _BookProcessStep({
    required this.icon,
    required this.title,
    required this.body,
    required this.index,
    required this.isLast,
    this.horizontal = false,
  });

  final IconData icon;
  final String title;
  final String body;
  final int index;
  final bool isLast;
  final bool horizontal;

  @override
  Widget build(BuildContext context) {
    final dot = Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.serviceBookCreation,
        boxShadow: [
          BoxShadow(
            color: AppColors.serviceBookCreation.withValues(alpha: 0.35),
            blurRadius: 14,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Center(
        child: Text(
          '$index',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.onAccent,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
    );

    if (horizontal) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              dot,
              if (!isLast)
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    height: 1.4,
                    color: AppColors.borderLight.withValues(alpha: 0.4),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevatedDark.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderDark),
                ),
                child: Icon(icon, size: 20, color: AppColors.serviceBookCreationLight),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppColors.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      body,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.onSurfaceVariantDark,
                            height: 1.55,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            dot,
            if (!isLast)
              Container(
                width: 2,
                height: 52,
                margin: const EdgeInsets.only(top: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.serviceBookCreation.withValues(alpha: 0.5),
                      AppColors.borderLight.withValues(alpha: 0.1),
                    ],
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevatedDark.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderDark),
                    ),
                    child: Icon(icon, size: 20, color: AppColors.serviceBookCreationLight),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppColors.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                body,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurfaceVariantDark,
                      height: 1.55,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Pricing section: three clear packages with persuasive positioning.
class _BookPricingSection extends StatelessWidget {
  const _BookPricingSection();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = Breakpoints.isMobile(width);

    const plans = [
      (
        'Author Starter',
        'Ideal if you already have a draft or detailed notes.',
        'From',
        '1,500',
        [
          'Book concept and chapter outline workshop',
          'Editorial review of manuscript (up to 40,000 words)',
          'Line editing and proofreading',
          'Simple interior layout and print-ready files',
        ],
        false,
      ),
      (
        'Signature Book',
        'Our most popular end-to-end package for leaders and experts.',
        'From',
        '3,500',
        [
          'Strategy, positioning and full chapter outline',
          'Ghostwriting or co-writing based on interviews',
          'Professional editing, proofreading and fact-checking',
          'Custom cover design and premium interior layout',
          'Print coordination (recommended specs and quotations)',
        ],
        true,
      ),
      (
        'Launch & Legacy',
        'For books that anchor your brand, organisation or campaign.',
        'From',
        '5,500',
        [
          'Everything in Signature Book',
          'Launch event and media talking points pack',
          'Social media launch kit (posts, visuals, captions)',
          'Press-ready PDF and digital book formats (e.g. PDF/ePub)',
          'Optional translation and bilingual editions',
        ],
        false,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Transparent packages, customised to your book',
          style: highlightStyleForLocale(
            context,
            fontSize: isNarrow ? 24 : 30,
            fontWeight: FontWeight.bold,
            color: AppColors.serviceBookCreation,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Every project begins with a conversation. These packages give you a clear starting point — we then tailor scope, timelines '
          'and print quantities to match your goals and budget.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurfaceVariantDark,
                height: 1.6,
              ),
        ),
        const SizedBox(height: 26),
        LayoutBuilder(
          builder: (context, constraints) {
            final useColumn = isNarrow || constraints.maxWidth < 900;
            final cards = [
              for (final p in plans)
                _PricingCard(
                  name: p.$1,
                  strapline: p.$2,
                  pricePrefix: p.$3,
                  price: p.$4,
                  bullets: p.$5,
                  highlighted: p.$6,
                ),
            ];

            if (useColumn) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < cards.length; i++) ...[
                    if (i > 0) const SizedBox(height: 18),
                    cards[i],
                  ],
                ],
              );
            }

            // Desktop: ensure pricing cards share the same height.
            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < cards.length; i++) ...[
                    if (i > 0) const SizedBox(width: 18),
                    Expanded(child: cards[i]),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _PricingCard extends StatefulWidget {
  const _PricingCard({
    required this.name,
    required this.strapline,
    required this.pricePrefix,
    required this.price,
    required this.bullets,
    this.highlighted = false,
  });

  final String name;
  final String strapline;
  final String pricePrefix;
  final String price;
  final List<String> bullets;
  final bool highlighted;

  @override
  State<_PricingCard> createState() => _PricingCardState();
}

class _PricingCardState extends State<_PricingCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isNarrow = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);

    final accentColor = widget.highlighted ? AppColors.serviceBookCreation : AppColors.serviceBookCreationLight;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: EdgeInsets.all(isNarrow ? 18 : 22),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevatedDark.withValues(alpha: widget.highlighted ? 0.96 : 0.9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _hovered ? accentColor : AppColors.borderDark,
            width: widget.highlighted || _hovered ? 2 : 1,
          ),
          boxShadow: widget.highlighted || _hovered ? AppShadows.cardHover : AppShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            // Header region (badge + name + strapline) with fixed height so
            // prices and bullet lists align across all three cards.
            SizedBox(
              height: isNarrow ? 120 : 110,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // First row: badge (if any) + plan name on the same line.
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.highlighted)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: accentColor.withValues(alpha: 0.7)),
                          ),
                          child: Text(
                            'Most popular',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: accentColor,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                      if (widget.highlighted) const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          widget.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppColors.onPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: Text(
                      widget.strapline,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.onSurfaceVariantDark,
                            height: 1.5,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  widget.pricePrefix,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariantDark,
                      ),
                ),
                const SizedBox(width: 4),
                Text(
                  widget.price,
                  style: highlightStyleForLocale(
                    context,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  l10n.spotlightPricePerMonth,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariantDark,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Exact investment is confirmed after a scoping call.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariantDark.withValues(alpha: 0.9),
                    fontStyle: FontStyle.italic,
                  ),
            ),
            const SizedBox(height: 14),
            for (final bullet in widget.bullets) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(LucideIcons.check, size: 16, color: AppColors.serviceBookCreationLight),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      bullet,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.onSurfaceVariantDark,
                            height: 1.5,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
            ],
            const Spacer(),
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: () => context.go('/consultations'),
              icon: const Icon(LucideIcons.calendarClock, size: 18),
              label: Text('Book a project call'),
              style: FilledButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: AppColors.onAccent,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Two persuasion book cards placed below the video section.
class _PersuasionBooksSection extends StatelessWidget {
  const _PersuasionBooksSection({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = Breakpoints.isMobile(width);
    return isNarrow
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _BookStoreCard(
                l10n: l10n,
                asset: AppContent.assetBookPersuasionEngBig,
                title: l10n.bookStoreBook3Title,
                subtitle: l10n.bookStoreBook3Subtitle,
                price: l10n.bookStoreBook3Price,
                showBestseller: false,
              ),
              const SizedBox(height: 24),
              _BookStoreCard(
                l10n: l10n,
                asset: AppContent.assetBookPersuasionKhmer,
                title: l10n.bookStoreBook4Title,
                subtitle: l10n.bookStoreBook4Subtitle,
                price: l10n.bookStoreBook4Price,
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
                  asset: AppContent.assetBookPersuasionEngBig,
                  title: l10n.bookStoreBook3Title,
                  subtitle: l10n.bookStoreBook3Subtitle,
                  price: l10n.bookStoreBook3Price,
                  showBestseller: false,
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _BookStoreCard(
                  l10n: l10n,
                  asset: AppContent.assetBookPersuasionKhmer,
                  title: l10n.bookStoreBook4Title,
                  subtitle: l10n.bookStoreBook4Subtitle,
                  price: l10n.bookStoreBook4Price,
                  showBestseller: false,
                ),
              ),
            ],
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
        SectionHeader(
          overline: l10n.bookStoreSectionOverline,
          title: l10n.bookStoreSectionHeading,
          subline: l10n.bookStoreSectionTagline,
          isNarrow: isNarrow,
        ),
        const SizedBox(height: 16),
        _BookScreenState._buildDescriptionWithHighlight(
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
                ? AppColors.serviceBookCreation.withValues(alpha: 0.5)
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
                        color: AppColors.serviceBookCreation,
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
                    color: AppColors.serviceBookCreation,
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
                          textColor: AppColors.serviceBookCreation,
                          onPressed: () {},
                        ),
                      ),
                    );
                  },
                  icon: const Icon(LucideIcons.shoppingCart, size: 18),
                  label: Text(widget.l10n.bookStoreAddToCart),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.serviceBookCreation,
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

/// Book Store section at the bottom: Featuring the Caishen Clinic Management System.
class _TalismanStoreSection extends StatelessWidget {
  const _TalismanStoreSection({required this.l10n});

  final AppLocalizations l10n;

  static List<(String, String)> _caishenFeatures(AppLocalizations l10n) {
    return [
      (AppContent.assetCaishenClinic1, l10n.caishenClinicFeature1Title),
      (AppContent.assetCaishenClinic2, l10n.caishenClinicFeature2Title),
      (AppContent.assetCaishenClinic3, l10n.caishenClinicFeature3Title),
      (AppContent.assetCaishenClinic4, l10n.caishenClinicFeature4Title),
      (AppContent.assetCaishenClinic5, l10n.caishenClinicFeature5Title),
      (AppContent.assetCaishenClinic6, l10n.caishenClinicFeature6Title),
      (AppContent.assetCaishenClinic7, l10n.caishenClinicFeature7Title),
      (AppContent.assetCaishenClinic8, l10n.caishenClinicFeature8Title),
      (AppContent.assetCaishenClinic9, l10n.caishenClinicFeature9Title),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isNarrow = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.caishenClinicSectionHeading,
          style: highlightStyleForLocale(
            context,
            fontSize: isNarrow ? 24 : 30,
            fontWeight: FontWeight.bold,
            color: AppColors.serviceBookCreation,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 14),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: _BookScreenState._buildDescriptionWithHighlight(
            context,
            l10n.caishenClinicSectionTagline,
            l10n.caishenClinicSectionTaglineHighlight,
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: _BookScreenState._buildDescriptionWithHighlight(
            context,
            l10n.caishenClinicSectionBody,
            l10n.caishenClinicSectionBodyHighlight,
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(height: 28),
        _AppFeatureShowcase(features: _caishenFeatures(l10n)),
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
                  color: AppColors.serviceBookCreation.withValues(alpha: 0.06),
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
        color: AppColors.serviceBookCreation.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.4)),
      ),
      child: Icon(icon, size: 48, color: AppColors.serviceBookCreation),
    );
  }
}

void _showPeriod9FullImage(BuildContext context, String asset) {
  _showFullImageDialog(context, asset);
}

void _showFullImageDialog(BuildContext context, String asset, {String? title}) {
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
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (title != null)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    IconButton.filled(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: Colors.white),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black54,
                        foregroundColor: Colors.white,
                      ),
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

/// Two Clinic App screenshots. Desktop: stacked with divider. Mobile: side-by-side, compact.
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
        childAspectRatio: 2 / 3,
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

  static final List<BoxShadow> _chapterCardShadow = [
    BoxShadow(
      color: Colors.black54,
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
    BoxShadow(
      color: Colors.black26,
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static final List<BoxShadow> _chapterCardShadowHover = [
    BoxShadow(
      color: Colors.black54,
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: Colors.black38,
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: AppColors.serviceBookCreation.withValues(alpha: 0.4),
      blurRadius: 24,
      spreadRadius: 0,
      offset: const Offset(0, 4),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => _showFullImageDialog(context, widget.asset, title: widget.title),
        child: AnimatedScale(
        scale: _hovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: AppColors.surfaceElevatedDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovered ? AppColors.serviceBookCreation : AppColors.borderDark,
              width: _hovered ? 3 : 1,
            ),
            boxShadow: _hovered ? _chapterCardShadowHover : _chapterCardShadow,
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
            SizedBox(
              height: 56,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
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
              ),
            ),
          ],
        ),
        ),
      ),
      ),
    );
  }
}

/// Product grid for Book Store with price and Add to Cart.
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

  static String _chapterAsset(int index) {
    return switch (index) {
      1 => AppContent.assetChapter1,
      2 => AppContent.assetChapter2,
      3 => AppContent.assetChapter3,
      4 => AppContent.assetChapter4,
      5 => AppContent.assetChapter5,
      6 => AppContent.assetChapter6,
      7 => AppContent.assetChapter7,
      8 => AppContent.assetChapter8,
      9 => AppContent.assetChapter9,
      _ => AppContent.assetChapter1,
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
          imageAsset: _chapterAsset(i + 1),
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
    required this.imageAsset,
  });

  final AppLocalizations l10n;
  final String title;
  final String price;
  final String pricePrefix;
  final int index;
  final String imageAsset;

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
            color: _hovered ? AppColors.serviceBookCreation.withValues(alpha: 0.5) : AppColors.borderDark,
            width: _hovered ? 2 : 1,
          ),
          boxShadow: _hovered ? AppShadows.cardHover : AppShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  widget.imageAsset,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
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
                    color: AppColors.serviceBookCreation,
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
                          textColor: AppColors.serviceBookCreation,
                          onPressed: () {},
                        ),
                      ),
                    );
                  },
                  icon: const Icon(LucideIcons.shoppingCart, size: 16),
                  label: Text(isNarrow ? widget.l10n.buttonAdd : widget.l10n.bookStoreAddToCart),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.serviceBookCreation,
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
