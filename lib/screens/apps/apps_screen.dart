import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:video_player/video_player.dart';

import '../../config/app_content.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../utils/breakpoints.dart';
import '../../widgets/section_header.dart';
import '../../widgets/subscribe_dialog.dart';
import '../../utils/launcher_utils.dart';

/// Fragment IDs for Apps page sections (used in /apps#fragment).
const String _sectionStonechat = 'stonechat';
const String _sectionPeriod9 = 'period9';

/// Apps page: app development services, process, pricing, and product showcases.
class AppsScreen extends StatefulWidget {
  const AppsScreen({super.key});

  @override
  State<AppsScreen> createState() => _AppsScreenState();
}

class _AppsScreenState extends State<AppsScreen> {
  final GlobalKey _keyStonechat = GlobalKey();
  final GlobalKey _keyPeriod9 = GlobalKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollToSectionIfNeeded();
  }

  void _scrollToSectionIfNeeded() {
    final fragment = GoRouterState.of(context).uri.fragment;
    if (fragment.isEmpty) return;
    final width = MediaQuery.sizeOf(context).width;
    if (Breakpoints.isMobile(width)) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final key = switch (fragment) {
        _sectionStonechat => _keyStonechat,
        _sectionPeriod9 => _keyPeriod9,
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
          // Hero: apps-focused headline and CTA.
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
                Align(
                  alignment: const Alignment(0, 0.12),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      isNarrow ? 16 : 24,
                      isNarrow ? 148 : 120,
                      isNarrow ? 16 : 24,
                      isNarrow ? 40 : 48,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SectionHeader(
                          overline: 'App Development',
                          title: 'From idea to App Store and Play Store',
                          isNarrow: false,
                        ),
                        SizedBox(height: isNarrow ? 20 : 24),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 640),
                          child: Text(
                            'Turn your vision into a polished mobile or web app. Stonechat guides you from concept and design through development, testing, and submission to the App Store and Google Play.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: AppColors.onPrimary.withValues(alpha: 0.9),
                                  height: 1.6,
                                ),
                          ),
                        ),
                        SizedBox(height: isNarrow ? 32 : 40),
                        _AppsHeroCtaRow(isNarrow: isNarrow),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Main content: services, process, pricing, then product showcases.
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
                    const _AppServicesOverviewSection(),
                    SizedBox(height: isNarrow ? 40 : 56),
                    const _AppProcessSection(),
                    SizedBox(height: isNarrow ? 40 : 56),
                    const _AppPricingSection(),
                    SizedBox(height: isNarrow ? 40 : 56),
                    _SectionAnchor(
                      key: _keyStonechat,
                      child: _FeaturedStonechatSection(l10n: l10n),
                    ),
                    SizedBox(height: isNarrow ? 40 : 56),
                    _SectionAnchor(
                      key: _keyPeriod9,
                      child: _FeaturedPeriod9Section(l10n: l10n),
                    ),
                    SizedBox(height: isNarrow ? 40 : 56),
                    _FeaturedMobileAppsSection(l10n: l10n),
                    SizedBox(height: isNarrow ? 40 : 56),
                    _ClinicManagementSection(l10n: l10n),
                    SizedBox(height: isNarrow ? 40 : 56),
                    _SubscriptionContainer(l10n: l10n),
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

/// Hero CTA row for Apps page.
class _AppsHeroCtaRow extends StatelessWidget {
  const _AppsHeroCtaRow({required this.isNarrow});

  final bool isNarrow;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primary = FilledButton.icon(
      onPressed: () => context.go('/consultations'),
      icon: const Icon(LucideIcons.smartphone, size: 20),
      label: const Text('Start your app project'),
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.onAccent,
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
        textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
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
        children: [primary, const SizedBox(height: 12), Center(child: secondary)],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [primary, const SizedBox(width: 18), secondary],
    );
  }
}

/// App services overview: three core offerings.
class _AppServicesOverviewSection extends StatelessWidget {
  const _AppServicesOverviewSection();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = Breakpoints.isMobile(width);
    final children = [
      _AppServiceCard(
        icon: LucideIcons.lightbulb,
        title: 'Strategy & discovery',
        body:
            'We clarify your app idea, define core features, and map user flows. '
            'Together we decide what to build first so you launch faster and stay within budget.',
        highlight: 'Ideal when you have a vision but need a clear roadmap to execute it.',
      ),
      _AppServiceCard(
        icon: LucideIcons.terminal,
        title: 'Design & development',
        body:
            'Our team designs intuitive interfaces and builds native or cross-platform apps '
            'for iOS, Android, and web. We use modern stacks and follow best practices for performance and security.',
        highlight: 'You get a production-ready app that feels fast and looks professional.',
      ),
      _AppServiceCard(
        icon: LucideIcons.rocket,
        title: 'Testing & store submission',
        body:
            'We test on real devices, fix bugs, and handle App Store and Google Play submission. '
            'From screenshots and descriptions to compliance checks, we get your app live.',
        highlight: 'One partner from final build to published app in both stores.',
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SectionHeader(
          overline: 'App services',
          title: 'Everything you need to ship a great app',
          isNarrow: false,
        ),
        const SizedBox(height: 18),
        Text(
          'Whether you need a simple MVP or a full-featured product, Stonechat delivers end-to-end app development. '
          'We work with startups, enterprises, and organisations who want to move fast without cutting corners.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.onSurfaceVariantDark,
                height: 1.6,
              ),
        ),
        const SizedBox(height: 28),
        LayoutBuilder(
          builder: (context, constraints) {
            final useColumn = isNarrow || constraints.maxWidth < 820;
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

class _AppServiceCard extends StatefulWidget {
  const _AppServiceCard({
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
  State<_AppServiceCard> createState() => _AppServiceCardState();
}

class _AppServiceCardState extends State<_AppServiceCard> {
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
            color: _hovered ? AppColors.accent.withValues(alpha: 0.5) : AppColors.borderDark,
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
                color: AppColors.accent.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.accent.withValues(alpha: 0.6)),
              ),
              child: Icon(widget.icon, size: 26, color: AppColors.accent),
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
                    color: AppColors.accentLight,
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// App process: brainstorm to App Store and Play Store.
class _AppProcessSection extends StatelessWidget {
  const _AppProcessSection();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = Breakpoints.isMobile(width);
    final steps = [
      (LucideIcons.lightbulb, '1. Discovery & concept', 'We explore your goals, users, and constraints, then define a clear scope and feature set for your first release.'),
      (LucideIcons.layoutDashboard, '2. Design & prototyping', 'We create wireframes and high-fidelity designs, test flows with you, and finalise the look and feel before development.'),
      (LucideIcons.terminal, '3. Development & testing', 'We build the app, run automated and manual tests, and iterate until it meets your quality bar and performance targets.'),
      (LucideIcons.smartphone, '4. Store submission & launch', 'We prepare store assets, submit to App Store and Google Play, and support you through review until your app goes live.'),
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
            color: AppColors.accentGlow.withValues(alpha: 0.09),
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
            'How your app gets built and published',
            style: highlightStyleForLocale(
              context,
              fontSize: isNarrow ? 24 : 30,
              fontWeight: FontWeight.bold,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'A single, guided process from first conversation to live apps on the App Store and Google Play.',
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
                      _AppProcessStep(icon: steps[i].$1, title: steps[i].$2, body: steps[i].$3, index: i + 1, isLast: i == steps.length - 1),
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
                      child: _AppProcessStep(icon: steps[i].$1, title: steps[i].$2, body: steps[i].$3, index: i + 1, isLast: i == steps.length - 1, horizontal: true),
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

class _AppProcessStep extends StatelessWidget {
  const _AppProcessStep({
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
        color: AppColors.accent,
        boxShadow: [BoxShadow(color: AppColors.accentGlow.withValues(alpha: 0.35), blurRadius: 14, spreadRadius: 0)],
      ),
      child: Center(
        child: Text('$index', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.onAccent, fontWeight: FontWeight.w700)),
      ),
    );
    if (horizontal) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              dot,
              if (!isLast) Expanded(child: Container(margin: const EdgeInsets.symmetric(horizontal: 6), height: 1.4, color: AppColors.borderLight.withValues(alpha: 0.4))),
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
                child: Icon(icon, size: 20, color: AppColors.accentLight),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.onPrimary, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Text(body, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariantDark, height: 1.55)),
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
                  gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.accent.withValues(alpha: 0.5), AppColors.borderLight.withValues(alpha: 0.1)]),
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
                    decoration: BoxDecoration(color: AppColors.surfaceElevatedDark.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderDark)),
                    child: Icon(icon, size: 20, color: AppColors.accentLight),
                  ),
                  const SizedBox(width: 10),
                  Flexible(child: Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.onPrimary, fontWeight: FontWeight.w600))),
                ],
              ),
              const SizedBox(height: 6),
              Text(body, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariantDark, height: 1.55)),
            ],
          ),
        ),
      ],
    );
  }
}

/// App pricing section.
class _AppPricingSection extends StatelessWidget {
  const _AppPricingSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isNarrow = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);
    const plans = [
      ('MVP Launch', 'Ideal for a simple app with core features only.', 'From', '3,500', [
        'Discovery workshop and feature scope',
        'UI/UX design (up to 8 screens)',
        'Cross-platform development (Flutter)',
        'Basic testing and bug fixes',
      ], false),
      ('Full Product', 'Our most popular package for complete apps.', 'From', '8,500', [
        'Strategy, design system and full UX',
        'Native or cross-platform development',
        'Backend and API integration',
        'QA, performance tuning and store prep',
        'App Store and Play Store submission',
      ], true),
      ('Enterprise', 'For complex apps with custom integrations.', 'From', '15,000', [
        'Everything in Full Product',
        'Custom backend and admin dashboard',
        'Third-party integrations (payments, auth)',
        'Ongoing support and maintenance',
        'Dedicated project manager',
      ], false),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Transparent pricing, tailored to your scope',
          style: highlightStyleForLocale(context, fontSize: isNarrow ? 24 : 30, fontWeight: FontWeight.bold, color: AppColors.accent),
        ),
        const SizedBox(height: 10),
        Text(
          'Every project starts with a scoping call. These packages give you a clear starting point — we then adjust scope, timeline and deliverables to match your goals.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariantDark, height: 1.6),
        ),
        const SizedBox(height: 26),
        LayoutBuilder(
          builder: (context, constraints) {
            final useColumn = isNarrow || constraints.maxWidth < 900;
            final cards = [
              for (final p in plans)
                _AppPricingCard(name: p.$1, strapline: p.$2, pricePrefix: p.$3, price: p.$4, bullets: p.$5, highlighted: p.$6, l10n: l10n),
            ];
            if (useColumn) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [for (var i = 0; i < cards.length; i++) ...[if (i > 0) const SizedBox(height: 18), cards[i]]],
              );
            }
            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [for (var i = 0; i < cards.length; i++) ...[if (i > 0) const SizedBox(width: 18), Expanded(child: cards[i])]],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _AppPricingCard extends StatefulWidget {
  const _AppPricingCard({
    required this.name,
    required this.strapline,
    required this.pricePrefix,
    required this.price,
    required this.bullets,
    this.highlighted = false,
    required this.l10n,
  });

  final String name;
  final String strapline;
  final String pricePrefix;
  final String price;
  final List<String> bullets;
  final bool highlighted;
  final AppLocalizations l10n;

  @override
  State<_AppPricingCard> createState() => _AppPricingCardState();
}

class _AppPricingCardState extends State<_AppPricingCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isNarrow = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);
    final accentColor = widget.highlighted ? AppColors.accent : AppColors.accentLight;
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
          border: Border.all(color: _hovered ? accentColor : AppColors.borderDark, width: widget.highlighted || _hovered ? 2 : 1),
          boxShadow: widget.highlighted || _hovered ? AppShadows.cardHover : AppShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: isNarrow ? 120 : 110,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
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
                          child: Text('Most popular', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: accentColor, fontWeight: FontWeight.w700)),
                        ),
                      if (widget.highlighted) const SizedBox(width: 8),
                      Flexible(child: Text(widget.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.onPrimary, fontWeight: FontWeight.w600))),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: Text(
                      widget.strapline,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariantDark, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(widget.pricePrefix, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariantDark)),
                const SizedBox(width: 4),
                Text(widget.price, style: highlightStyleForLocale(context, fontSize: 26, fontWeight: FontWeight.bold, color: accentColor)),
                const SizedBox(width: 4),
                Text(' USD', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariantDark)),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Exact investment is confirmed after a scoping call.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariantDark.withValues(alpha: 0.9), fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 14),
            for (final bullet in widget.bullets) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(LucideIcons.check, size: 16, color: AppColors.accentLight),
                  const SizedBox(width: 8),
                  Expanded(child: Text(bullet, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariantDark, height: 1.5))),
                ],
              ),
              const SizedBox(height: 6),
            ],
            const Spacer(),
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: () => context.go('/consultations'),
              icon: const Icon(LucideIcons.calendarClock, size: 18),
              label: const Text('Book a project call'),
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

/// Clinic App section with prominent download buttons.
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
                  imageAsset: AppContent.assetAppStoreIcon,
                  url: AppContent.period9AppStoreUrl,
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 56,
                child: _ProminentStoreButton(
                  imageAsset: AppContent.assetGooglePlayIcon,
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
                      imageAsset: AppContent.assetAppStoreIcon,
                      url: AppContent.period9AppStoreUrl,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: _ProminentStoreButton(
                      imageAsset: AppContent.assetGooglePlayIcon,
                      url: AppContent.period9PlayStoreUrl,
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}

class _ProminentStoreButton extends StatefulWidget {
  const _ProminentStoreButton({
    required this.imageAsset,
    required this.url,
  });

  final String imageAsset;
  final String? url;

  @override
  State<_ProminentStoreButton> createState() => _ProminentStoreButtonState();
}

class _ProminentStoreButtonState extends State<_ProminentStoreButton> {
  bool _hovered = false;

  static final List<BoxShadow> _storeButtonShadow = [
    BoxShadow(
      color: Colors.black38,
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: Colors.black26,
      blurRadius: 6,
      offset: const Offset(0, 2),
    ),
  ];

  static final List<BoxShadow> _storeButtonShadowHover = [
    BoxShadow(
      color: Colors.black45,
      blurRadius: 18,
      offset: const Offset(0, 6),
    ),
    BoxShadow(
      color: Colors.black26,
      blurRadius: 8,
      offset: const Offset(0, 3),
    ),
    BoxShadow(
      color: AppColors.accentGlow.withValues(alpha: 0.3),
      blurRadius: 16,
      spreadRadius: -2,
      offset: const Offset(0, 4),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final enabled = widget.url != null && widget.url!.isNotEmpty;
    final showHighlight = enabled && _hovered;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: enabled ? () => launchUrlExternal(widget.url!) : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          height: 56,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: enabled ? AppColors.surfaceElevatedDark : AppColors.surfaceElevatedDark.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: showHighlight ? AppColors.accent : AppColors.borderDark,
              width: showHighlight ? 3 : 1,
            ),
            boxShadow: enabled ? (showHighlight ? _storeButtonShadowHover : _storeButtonShadow) : null,
          ),
          child: Center(
            child: SizedBox(
              width: double.infinity,
              height: 44,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.borderDark.withValues(alpha: 0.5),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Image.asset(
                    widget.imageAsset,
                    fit: BoxFit.contain,
                    opacity: AlwaysStoppedAnimation(enabled ? 1.0 : 0.5),
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.download,
                      size: 28,
                      color: enabled ? AppColors.onPrimary : AppColors.onSurfaceVariantDark,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Featured Mobile Apps: two product cards (Period 9, Stonechat Bazi).
class _FeaturedMobileAppsSection extends StatelessWidget {
  const _FeaturedMobileAppsSection({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = Breakpoints.isMobile(width);
    final stackCards = Breakpoints.isNarrow(width);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        SectionHeader(
          overline: l10n.featuredAppsSectionOverline,
          title: l10n.featuredAppsSectionTitle,
          subline: l10n.featuredAppsSectionSubline,
          isNarrow: isNarrow,
        ),
        const SizedBox(height: 16),
        Text(
          l10n.featuredAppsSectionBody,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.onSurfaceVariantDark,
                height: 1.6,
              ),
        ),
        const SizedBox(height: 32),
        stackCards
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _FeaturedAppCard(
                    l10n: l10n,
                    asset: AppContent.assetFeaturedApp1,
                    title: l10n.featuredApp1Title,
                    subtitle: l10n.featuredApp1Subtitle,
                    price: '24.99',
                    showBestseller: true,
                  ),
                  const SizedBox(height: 24),
                  _FeaturedAppCard(
                    l10n: l10n,
                    asset: AppContent.assetFeaturedApp2,
                    title: l10n.featuredApp2Title,
                    subtitle: l10n.featuredApp2Subtitle,
                    price: '24.99',
                    showBestseller: false,
                  ),
                ],
              )
            : IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: _FeaturedAppCard(
                        l10n: l10n,
                        asset: AppContent.assetFeaturedApp1,
                        title: l10n.featuredApp1Title,
                        subtitle: l10n.featuredApp1Subtitle,
                        price: '24.99',
                        showBestseller: true,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _FeaturedAppCard(
                        l10n: l10n,
                        asset: AppContent.assetFeaturedApp2,
                        title: l10n.featuredApp2Title,
                        subtitle: l10n.featuredApp2Subtitle,
                        price: '24.99',
                        showBestseller: false,
                      ),
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}

class _FeaturedAppCard extends StatefulWidget {
  const _FeaturedAppCard({
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
  State<_FeaturedAppCard> createState() => _FeaturedAppCardState();
}

class _FeaturedAppCardState extends State<_FeaturedAppCard> {
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
            color: _hovered ? AppColors.accent.withValues(alpha: 0.5) : AppColors.borderDark,
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
                          LucideIcons.smartphone,
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
              maxLines: isNarrow ? 2 : 1,
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

/// Clinic Management System: 3x3 feature grid with header.
class _ClinicManagementSection extends StatelessWidget {
  const _ClinicManagementSection({required this.l10n});

  final AppLocalizations l10n;

  static List<(String, String)> _features(AppLocalizations l10n) {
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
          'Clinic Management System',
          style: highlightStyleForLocale(
            context,
            fontSize: isNarrow ? 24 : 30,
            fontWeight: FontWeight.bold,
            color: AppColors.accent,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 14),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: _AppsScreenState._buildDescriptionWithHighlight(
            context,
            l10n.caishenClinicSectionTagline,
            l10n.caishenClinicSectionTaglineHighlight,
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: _AppsScreenState._buildDescriptionWithHighlight(
            context,
            l10n.caishenClinicSectionBody,
            l10n.caishenClinicSectionBodyHighlight,
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(height: 28),
        _AppFeatureShowcase(features: _features(l10n)),
      ],
    );
  }
}

/// Subscription container: App Development & Responsive Web offer with Get a quote and Subscribe CTAs.
class _SubscriptionContainer extends StatelessWidget {
  const _SubscriptionContainer({required this.l10n});

  final AppLocalizations l10n;

  void _openSubscribeDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const SubscribeDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isNarrow = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);

    return Container(
      padding: EdgeInsets.all(isNarrow ? 20 : 28),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.6),
          width: 1.5,
        ),
        boxShadow: [
          ...AppShadows.card,
          BoxShadow(
            color: AppColors.accentGlow.withValues(alpha: 0.12),
            blurRadius: 20,
            spreadRadius: 0,
          ),
        ],
      ),
      child: isNarrow
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildIcon(context),
                SizedBox(height: isNarrow ? 16 : 20),
                _buildContent(context, isNarrow),
                SizedBox(height: isNarrow ? 20 : 24),
                _buildCtaRow(context, isNarrow),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIcon(context),
                SizedBox(width: isNarrow ? 0 : 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildContent(context, isNarrow),
                      SizedBox(height: isNarrow ? 20 : 24),
                      _buildCtaRow(context, isNarrow),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.5)),
      ),
      child: const Icon(
        LucideIcons.cpu,
        size: 28,
        color: AppColors.accent,
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isNarrow) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.stonechatSpotlightTitle,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.onPrimary,
                fontWeight: FontWeight.w700,
                fontSize: isNarrow ? 18 : 24,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.stonechatSpotlightDesc,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurfaceVariantDark,
                height: 1.5,
                fontSize: isNarrow ? 14 : null,
              ),
        ),
      ],
    );
  }

  Widget _buildCtaRow(BuildContext context, bool isNarrow) {
    final buttonStyle = FilledButton.styleFrom(
      backgroundColor: AppColors.accent,
      foregroundColor: AppColors.onAccent,
      padding: EdgeInsets.symmetric(
        horizontal: isNarrow ? 16 : 20,
        vertical: isNarrow ? 12 : 14,
      ),
      minimumSize: Size(isNarrow ? 0 : 44, isNarrow ? 44 : 48),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
    final outlinedStyle = OutlinedButton.styleFrom(
      foregroundColor: AppColors.accent,
      side: const BorderSide(color: AppColors.accent),
      padding: EdgeInsets.symmetric(
        horizontal: isNarrow ? 16 : 20,
        vertical: isNarrow ? 12 : 14,
      ),
      minimumSize: Size(isNarrow ? 0 : 44, isNarrow ? 44 : 48),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
    return Wrap(
      spacing: isNarrow ? 12 : 16,
      runSpacing: isNarrow ? 10 : 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        FilledButton.icon(
          onPressed: () => context.go('/consultations'),
          icon: Icon(LucideIcons.externalLink, size: isNarrow ? 16 : 18),
          label: Text(l10n.openStonechatCta),
          style: buttonStyle,
        ),
        Text(
          '\$${l10n.spotlightSubscriptionPrice}${l10n.spotlightPricePerMonth}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurfaceVariantDark,
              ),
        ),
        OutlinedButton.icon(
          onPressed: () => _openSubscribeDialog(context),
          icon: Icon(LucideIcons.creditCard, size: isNarrow ? 16 : 18),
          label: Text(l10n.spotlightSubscribe),
          style: outlinedStyle,
        ),
      ],
    );
  }
}

/// Product showcase: 3x3 grid of app feature screens with labels.
class _AppFeatureShowcase extends StatelessWidget {
  const _AppFeatureShowcase({required this.features});

  final List<(String, String)> features;

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

  static final List<BoxShadow> _cardShadow = [
    BoxShadow(color: Colors.black54, blurRadius: 16, offset: const Offset(0, 6)),
    BoxShadow(color: Colors.black26, blurRadius: 8, offset: const Offset(0, 2)),
  ];

  static final List<BoxShadow> _cardShadowHover = [
    BoxShadow(color: Colors.black54, blurRadius: 24, offset: const Offset(0, 8)),
    BoxShadow(color: Colors.black38, blurRadius: 12, offset: const Offset(0, 4)),
    BoxShadow(color: AppColors.accentGlow.withValues(alpha: 0.4), blurRadius: 24, spreadRadius: 0, offset: const Offset(0, 4)),
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
                color: _hovered ? AppColors.accent : AppColors.borderDark,
                width: _hovered ? 3 : 1,
              ),
              boxShadow: _hovered ? _cardShadowHover : _cardShadow,
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

