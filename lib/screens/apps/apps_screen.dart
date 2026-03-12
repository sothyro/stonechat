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
    Color? highlightColor,
  }) {
    final bodyStyle = (Theme.of(context).textTheme.bodyLarge?.copyWith(
      color: baseColor ?? AppColors.onSurfaceVariantDark,
      height: 1.5,
    ) ?? TextStyle(fontSize: 16, color: baseColor ?? AppColors.onSurfaceVariantDark, height: 1.5));
    final effectiveHighlight = highlightColor ?? (baseColor != null ? AppColors.serviceAppDevelopmentLight : AppColors.serviceAppDevelopment);
    final highlightStyle = highlightStyleForLocale(
      context,
      color: effectiveHighlight,
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
                    _FeaturedMobileAppsSection(l10n: l10n),
                    SizedBox(height: isNarrow ? 40 : 56),
                    _SectionAnchor(
                      key: _keyStonechat,
                      child: _FeaturedStonechatSection(l10n: l10n),
                    ),
                    SizedBox(height: isNarrow ? 40 : 56),
                    const _ModernSectionDivider(),
                    SizedBox(height: isNarrow ? 40 : 56),
                    _MasterElfFengShuiSection(l10n: l10n),
                    SizedBox(height: isNarrow ? 40 : 56),
                    const _ModernSectionDivider(),
                    SizedBox(height: isNarrow ? 40 : 56),
                    _SectionAnchor(
                      key: _keyPeriod9,
                      child: _FeaturedPeriod9Section(l10n: l10n),
                    ),
                    SizedBox(height: isNarrow ? 40 : 56),
                    _N22BusinessSuiteSection(l10n: l10n),
                    SizedBox(height: isNarrow ? 40 : 56),
                    const _AppPricingSection(),
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

/// Modern section divider: gradient line with subtle accent glow.
class _ModernSectionDivider extends StatelessWidget {
  const _ModernSectionDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        height: 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.transparent,
              AppColors.serviceAppDevelopment.withValues(alpha: 0.15),
              AppColors.serviceAppDevelopment.withValues(alpha: 0.4),
              AppColors.serviceAppDevelopment.withValues(alpha: 0.15),
              Colors.transparent,
            ],
            stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
          ),
        ),
      ),
    );
  }
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
        backgroundColor: AppColors.serviceAppDevelopment,
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
        side: const BorderSide(color: AppColors.serviceAppDevelopment, width: 1.3),
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
            color: _hovered ? AppColors.serviceAppDevelopment.withValues(alpha: 0.5) : AppColors.borderDark,
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
                color: AppColors.serviceAppDevelopment.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.serviceAppDevelopment.withValues(alpha: 0.6)),
              ),
              child: Icon(widget.icon, size: 26, color: AppColors.serviceAppDevelopment),
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
                    color: AppColors.serviceAppDevelopmentLight,
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
        border: Border.all(color: AppColors.serviceAppDevelopment.withValues(alpha: 0.28)),
        boxShadow: [
          ...AppShadows.card,
          BoxShadow(
            color: AppColors.serviceAppDevelopment.withValues(alpha: 0.09),
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
              color: AppColors.serviceAppDevelopment,
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
        color: AppColors.serviceAppDevelopment,
        boxShadow: [BoxShadow(color: AppColors.serviceAppDevelopment.withValues(alpha: 0.35), blurRadius: 14, spreadRadius: 0)],
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
              if (!isLast) Expanded(child: Container(margin: const EdgeInsets.symmetric(horizontal: 6), height: 1.4, color: AppColors.serviceAppDevelopment.withValues(alpha: 0.4))),
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
                child: Icon(icon, size: 20, color: AppColors.serviceAppDevelopmentLight),
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
                  gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.serviceAppDevelopment.withValues(alpha: 0.5), AppColors.serviceAppDevelopment.withValues(alpha: 0.1)]),
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
                    child: Icon(icon, size: 20, color: AppColors.serviceAppDevelopmentLight),
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
    const appPlans = [
      ('Mini App / MVP', 'Simple apps with core features. Ideal for booking forms, catalogs, internal tools.', '', '700–1,200', ' USD', [
        '3–5 screens',
        'No backend or simple Firebase',
        'Android only',
        'Delivered in 2–4 weeks',
      ], false),
      ('Standard Business App', 'Our most popular for clinics, SMEs, and small POS systems.', '', '1,500–2,500', ' USD', [
        '8–15 screens',
        'Firebase backend, auth, CRUD',
        'Simple reports',
        'Android (iOS + web add +30–50%)',
      ], true),
      ('Advanced App', 'Complex logic, multi-role, integrations, dashboards.', '', '3,000–6,000+', ' USD', [
        'Large clinic or multi-branch POS',
        'Delivery or marketplace apps',
        'Custom backend and admin',
        'Quote case-by-case',
      ], false),
    ];
    const webPlans = [
      ('Landing Page', 'One-page site for Facebook sellers. Professional look in 3–5 days.', '', '100–130', ' USD', [
        'Single page',
        'Contact form',
        'Mobile-friendly',
      ], false),
      ('Starter Web', 'Micro businesses: salon, small shop, teacher.', '', '180–220', ' USD', [
        '1–3 pages',
        'Template design',
        'Basic contact form',
      ], false),
      ('Basic Business', 'SMEs, clinics, training centers.', '', '250–350', ' USD', [
        '5–8 pages',
        'Custom layout from template',
        'Simple blog/news, 1 language',
      ], false),
      ('Pro Business', 'Schools, NGOs, larger SMEs.', '', '400–600', ' USD', [
        'Up to ~12 pages',
        'Bilingual Khmer/English',
        'Booking form or product listing',
      ], false),
      ('Small E-commerce', 'Online shops, small brands.', '', '700–1,000', ' USD', [
        '20–80 products',
        'Cart, checkout, payment',
        'Basic admin to manage products',
      ], false),
    ];
    const maintenancePlans = [
      ('Web hosting', 'Keep your site secure and updated.', '', '10–50', ' USD/mo', [
        'Basic: 10–20 — hosting, security, 2–4 edits',
        'Pro: 30–50 — content updates, backups, priority support',
      ], false),
      ('App support', 'Bug fixes, tweaks, and new features.', '', '50–150', ' USD/mo', [
        'Basic: 50–80 — fixes, minor UI, monitoring',
        'Growth: 100–150 — new features, analytics, performance',
      ], false),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Transparent pricing, tailored to your scope',
          style: highlightStyleForLocale(context, fontSize: isNarrow ? 24 : 30, fontWeight: FontWeight.bold, color: AppColors.serviceAppDevelopment),
        ),
        const SizedBox(height: 10),
        Text(
          'Local pricing for Cambodia. Every project starts with a scoping call — we adjust scope and deliverables to match your goals. Use USD; approximate KHR available for marketing.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariantDark, height: 1.6),
        ),
        const SizedBox(height: 32),
        _buildSectionTitle(context, 'App development'),
        const SizedBox(height: 18),
        _buildPlanGrid(context, isNarrow, appPlans, l10n),
        const SizedBox(height: 40),
        _buildSectionTitle(context, 'Websites & landing pages'),
        const SizedBox(height: 18),
        _buildPlanGrid(context, isNarrow, webPlans, l10n),
        const SizedBox(height: 40),
        _buildSectionTitle(context, 'Maintenance & support'),
        const SizedBox(height: 18),
        _buildPlanGrid(context, isNarrow, maintenancePlans, l10n),
        const SizedBox(height: 24),
        Text(
          'Exact investment is confirmed after a scoping call.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariantDark.withValues(alpha: 0.9), fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.serviceAppDevelopment,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
    );
  }

  Widget _buildPlanGrid(BuildContext context, bool isNarrow, List<(String, String, String, String, String, List<String>, bool)> plans, AppLocalizations l10n) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final useColumn = isNarrow || constraints.maxWidth < 900;
        final cards = [
          for (final p in plans)
            _AppPricingCard(name: p.$1, strapline: p.$2, pricePrefix: p.$3, price: p.$4, priceSuffix: p.$5, bullets: p.$6, highlighted: p.$7, l10n: l10n),
        ];
        if (useColumn) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [for (var i = 0; i < cards.length; i++) ...[if (i > 0) const SizedBox(height: 18), cards[i]]],
          );
        }
        if (plans.length > 4) {
          // 5 cards: 3 + 2
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [for (var i = 0; i < 3; i++) ...[if (i > 0) const SizedBox(width: 18), Expanded(child: cards[i])]],
                ),
              ),
              const SizedBox(height: 18),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: cards[3]),
                    const SizedBox(width: 18),
                    Expanded(child: cards[4]),
                  ],
                ),
              ),
            ],
          );
        }
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [for (var i = 0; i < cards.length; i++) ...[if (i > 0) const SizedBox(width: 18), Expanded(child: cards[i])]],
          ),
        );
      },
    );
  }
}

class _AppPricingCard extends StatefulWidget {
  const _AppPricingCard({
    required this.name,
    required this.strapline,
    required this.pricePrefix,
    required this.price,
    this.priceSuffix = ' USD',
    required this.bullets,
    this.highlighted = false,
    required this.l10n,
  });

  final String name;
  final String strapline;
  final String pricePrefix;
  final String price;
  final String priceSuffix;
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
    final accentColor = widget.highlighted ? AppColors.serviceAppDevelopment : AppColors.serviceAppDevelopmentLight;
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
                Text(widget.priceSuffix, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariantDark)),
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
                  const Icon(LucideIcons.check, size: 16, color: AppColors.serviceAppDevelopmentLight),
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

/// Featured Stonechat system block: two wider images (period9_1, period9_2) + CTA.
class _FeaturedStonechatSection extends StatefulWidget {
  const _FeaturedStonechatSection({required this.l10n});

  final AppLocalizations l10n;

  @override
  State<_FeaturedStonechatSection> createState() => _FeaturedStonechatSectionState();
}

class _FeaturedStonechatSectionState extends State<_FeaturedStonechatSection> {
  bool _hovered = false;

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
                ? AppColors.serviceAppDevelopment.withValues(alpha: 0.6)
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
                color: AppColors.serviceAppDevelopment.withValues(alpha: 0.12),
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
                  _StonechatWiderImages(),
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
                            color: AppColors.serviceAppDevelopmentLight,
                          ).copyWith(
                            shadows: [
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
                          textAlign: TextAlign.left,
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

/// Two wider (landscape 16:9) images: period9_1.JPG, period9_2.JPG.
class _StonechatWiderImages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isNarrow = width < Breakpoints.mobile;
        final padding = isNarrow ? 12.0 : 24.0;
        final gap = isNarrow ? 12.0 : 16.0;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(padding),
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
          child: isNarrow
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _WiderImageCard(asset: AppContent.assetPeriod9_1),
                    SizedBox(height: gap),
                    _WiderImageCard(asset: AppContent.assetPeriod9_2),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: _WiderImageCard(asset: AppContent.assetPeriod9_1)),
                    SizedBox(width: gap),
                    Expanded(child: _WiderImageCard(asset: AppContent.assetPeriod9_2)),
                  ],
                ),
        );
      },
    );
  }
}

class _WiderImageCard extends StatelessWidget {
  const _WiderImageCard({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showFullImageDialog(context, asset),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
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
            height: double.infinity,
            errorBuilder: (_, __, ___) => Center(
              child: Icon(
                LucideIcons.image,
                size: 40,
                color: AppColors.serviceAppDevelopment.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Master Elf Feng Shui App – featured web app with languages and features showcase.
class _MasterElfFengShuiSection extends StatelessWidget {
  const _MasterElfFengShuiSection({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = Breakpoints.isMobile(width);

    return Container(
      padding: EdgeInsets.all(isNarrow ? 20 : 36),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surfaceElevatedDark,
            AppColors.surfaceElevatedDark.withValues(alpha: 0.92),
            AppColors.backgroundDark.withValues(alpha: 0.4),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.serviceResponsiveWeb.withValues(alpha: 0.4),
          width: 2,
        ),
        boxShadow: [
          ...AppShadows.card,
          BoxShadow(
            color: AppColors.serviceResponsiveWeb.withValues(alpha: 0.15),
            blurRadius: 32,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          SectionHeader(
            overline: l10n.masterElfSectionOverline,
            title: l10n.masterElfSectionTitle,
            subline: null,
            isNarrow: isNarrow,
          ),
          const SizedBox(height: 16),
          _AppsScreenState._buildDescriptionWithHighlight(
            context,
            l10n.masterElfSectionTagline,
            l10n.masterElfSectionTaglineHighlight,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          // Persuasive hero block
          Container(
            padding: EdgeInsets.all(isNarrow ? 20 : 28),
            decoration: BoxDecoration(
              color: AppColors.serviceResponsiveWeb.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.serviceResponsiveWeb.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                _AppsScreenState._buildDescriptionWithHighlight(
                  context,
                  l10n.masterElfHeroHeadline,
                  l10n.masterElfHeroHeadlineHighlight,
                  textAlign: TextAlign.center,
                  baseColor: AppColors.onPrimary,
                  highlightColor: AppColors.serviceResponsiveWeb,
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.masterElfValueProp,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.onSurfaceVariantDark,
                        height: 1.6,
                        fontSize: isNarrow ? 15 : 17,
                      ),
                ),
                SizedBox(height: isNarrow ? 20 : 24),
                _MasterElfCtaRow(isNarrow: isNarrow),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text(
            l10n.masterElfLanguagesLabel,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.serviceResponsiveWeb,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
          ),
          const SizedBox(height: 16),
          _MasterElfLanguagesRow(isNarrow: isNarrow),
          const SizedBox(height: 32),
          Text(
            l10n.masterElfFeaturesHeading,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.serviceResponsiveWeb,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
          ),
          const SizedBox(height: 16),
          _MasterElfFeaturesGrid(isNarrow: isNarrow, l10n: l10n),
        ],
      ),
    );
  }
}

/// CTA row: Explore the app + Request a demo.
class _MasterElfCtaRow extends StatelessWidget {
  const _MasterElfCtaRow({required this.isNarrow});

  final bool isNarrow;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primary = FilledButton.icon(
      onPressed: () => context.go('/contact'),
      icon: const Icon(LucideIcons.sparkles, size: 20),
      label: Text(l10n.masterElfCtaPrimary),
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.serviceResponsiveWeb,
        foregroundColor: AppColors.onAccent,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
    final secondary = OutlinedButton.icon(
      onPressed: () => context.go('/contact'),
      icon: const Icon(LucideIcons.playCircle, size: 18),
      label: Text(l10n.masterElfCtaSecondary),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.serviceResponsiveWeb,
        side: const BorderSide(color: AppColors.serviceResponsiveWeb),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
      ),
    );
    if (isNarrow) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [primary, const SizedBox(height: 12), secondary],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [primary, const SizedBox(width: 16), secondary],
    );
  }
}

/// Three language cards: Khmer, English, Chinese.
class _MasterElfLanguagesRow extends StatelessWidget {
  const _MasterElfLanguagesRow({required this.isNarrow});

  final bool isNarrow;

  @override
  Widget build(BuildContext context) {
    final languages = [
      (AppContent.assetMasterKhmer, AppLocalizations.of(context)!.masterElfLanguageKhmer),
      (AppContent.assetMasterEnglish, AppLocalizations.of(context)!.masterElfLanguageEnglish),
      (AppContent.assetMasterChinese, AppLocalizations.of(context)!.masterElfLanguageChinese),
    ];
    return isNarrow
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < languages.length; i++) ...[
                if (i > 0) const SizedBox(height: 12),
                _MasterElfLanguageCard(asset: languages[i].$1, label: languages[i].$2),
              ],
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < languages.length; i++) ...[
                if (i > 0) const SizedBox(width: 20),
                Expanded(
                  child: _MasterElfLanguageCard(asset: languages[i].$1, label: languages[i].$2),
                ),
              ],
            ],
          );
  }
}

class _MasterElfLanguageCard extends StatefulWidget {
  const _MasterElfLanguageCard({required this.asset, required this.label});

  final String asset;
  final String label;

  @override
  State<_MasterElfLanguageCard> createState() => _MasterElfLanguageCardState();
}

class _MasterElfLanguageCardState extends State<_MasterElfLanguageCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevatedDark.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered ? AppColors.serviceResponsiveWeb : AppColors.borderDark,
            width: _hovered ? 2 : 1,
          ),
          boxShadow: _hovered ? AppShadows.cardHover : AppShadows.card,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: Image.asset(
                  widget.asset,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.borderDark,
                    child: Icon(
                      LucideIcons.globe,
                      size: 40,
                      color: AppColors.serviceResponsiveWeb.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Four feature cards: Booking, Story, Subscriptions, Contact.
class _MasterElfFeaturesGrid extends StatelessWidget {
  const _MasterElfFeaturesGrid({required this.isNarrow, required this.l10n});

  final bool isNarrow;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final features = [
      (AppContent.assetMasterBooking, l10n.masterElfFeatureBooking, l10n.masterElfFeatureBookingDesc),
      (AppContent.assetMasterStory, l10n.masterElfFeatureStory, l10n.masterElfFeatureStoryDesc),
      (AppContent.assetMasterAppStore, l10n.masterElfFeatureSubscriptions, l10n.masterElfFeatureSubscriptionsDesc),
      (AppContent.assetMasterContact, l10n.masterElfFeatureContact, l10n.masterElfFeatureContactDesc),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final useColumn = isNarrow || constraints.maxWidth < 800;
        if (useColumn) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _MasterElfFeatureCard(asset: features[0].$1, title: features[0].$2, description: features[0].$3)),
                  const SizedBox(width: 12),
                  Expanded(child: _MasterElfFeatureCard(asset: features[1].$1, title: features[1].$2, description: features[1].$3)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _MasterElfFeatureCard(asset: features[2].$1, title: features[2].$2, description: features[2].$3)),
                  const SizedBox(width: 12),
                  Expanded(child: _MasterElfFeatureCard(asset: features[3].$1, title: features[3].$2, description: features[3].$3)),
                ],
              ),
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < features.length; i++) ...[
              if (i > 0) const SizedBox(width: 16),
              Expanded(
                child: _MasterElfFeatureCard(
                  asset: features[i].$1,
                  title: features[i].$2,
                  description: features[i].$3,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _MasterElfFeatureCard extends StatefulWidget {
  const _MasterElfFeatureCard({
    required this.asset,
    required this.title,
    required this.description,
  });

  final String asset;
  final String title;
  final String description;

  @override
  State<_MasterElfFeatureCard> createState() => _MasterElfFeatureCardState();
}

class _MasterElfFeatureCardState extends State<_MasterElfFeatureCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => _showFullImageDialog(context, widget.asset, title: widget.title),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = constraints.maxWidth;
            final imageHeight = cardWidth * (4 / 3);
            return AnimatedScale(
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
                    color: _hovered ? AppColors.serviceResponsiveWeb : AppColors.borderDark,
                    width: _hovered ? 2 : 1,
                  ),
                  boxShadow: _hovered ? AppShadows.cardHover : AppShadows.card,
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: imageHeight,
                      child: Container(
                        color: AppColors.borderDark.withValues(alpha: 0.3),
                        child: Center(
                          child: Image.asset(
                            widget.asset,
                            fit: BoxFit.contain,
                            width: cardWidth,
                            height: imageHeight,
                            errorBuilder: (_, __, ___) => SizedBox(
                              height: imageHeight,
                              child: Center(
                                child: Icon(
                                  LucideIcons.layoutDashboard,
                                  size: 48,
                                  color: AppColors.serviceResponsiveWeb.withValues(alpha: 0.5),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.title,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  color: AppColors.serviceResponsiveWeb,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.description,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.onSurfaceVariantDark,
                                  height: 1.5,
                                  fontSize: 13,
                                ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// N22 Business Suite – video hero + desktop (landscape) and mobile (portrait) cards.
class _N22BusinessSuiteSection extends StatefulWidget {
  const _N22BusinessSuiteSection({required this.l10n});

  final AppLocalizations l10n;

  @override
  State<_N22BusinessSuiteSection> createState() => _N22BusinessSuiteSectionState();
}

class _N22BusinessSuiteSectionState extends State<_N22BusinessSuiteSection> {
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
      final controller = VideoPlayerController.asset(
        AppContent.assetN22Video,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );
      await controller.initialize();
      if (!mounted) {
        controller.dispose();
        return;
      }
      controller.setLooping(true);
      controller.setVolume(_muted ? 0 : 1);
      void listener() {
        final duration = controller.value.duration;
        if (duration.inMilliseconds <= 0) return;
        final pos = controller.value.position.inMilliseconds;
        if (pos >= duration.inMilliseconds - 200) {
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _videoController != null && !_videoController!.value.isPlaying) {
          _videoController!.play();
        }
      });
    } catch (_) {
      if (mounted) setState(() => _videoReady = false);
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
    if (c != null && _loopListener != null) c.removeListener(_loopListener!);
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isNarrow = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);
    final accent = AppColors.accent;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _hovered ? accent.withValues(alpha: 0.6) : AppColors.borderDark.withValues(alpha: 0.8),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 24,
              offset: const Offset(0, 8),
              spreadRadius: -4,
            ),
            if (_hovered)
              BoxShadow(
                color: accent.withValues(alpha: 0.15),
                blurRadius: 28,
                offset: const Offset(0, 6),
                spreadRadius: 0,
              ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            _N22VideoHero(
              videoController: _videoController,
              videoReady: _videoReady,
              muted: _muted,
              onToggleMute: _toggleMute,
              accent: accent,
            ),
            Padding(
              padding: EdgeInsets.all(isNarrow ? 20 : 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: isNarrow ? 160 : 220),
                  Center(
                    child: _N22CtaRow(isNarrow: isNarrow, accent: accent),
                  ),
                  SizedBox(height: isNarrow ? 48 : 56),
                  Text(
                    widget.l10n.n22DesktopLabel,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: accent,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                  ),
                  const SizedBox(height: 14),
                  _N22DesktopGrid(l10n: widget.l10n),
                  SizedBox(height: isNarrow ? 40 : 48),
                  Text(
                    widget.l10n.n22MobileLabel,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: accent,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                  ),
                  const SizedBox(height: 14),
                  _N22MobileGrid(l10n: widget.l10n),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _N22VideoHero extends StatelessWidget {
  const _N22VideoHero({
    required this.videoController,
    required this.videoReady,
    required this.muted,
    required this.onToggleMute,
    required this.accent,
  });

  final VideoPlayerController? videoController;
  final bool videoReady;
  final bool muted;
  final VoidCallback onToggleMute;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            color: AppColors.surfaceElevatedDark,
            child: videoReady &&
                    videoController != null &&
                    videoController!.value.isInitialized
                ? FittedBox(
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: videoController!.value.size.width,
                      height: videoController!.value.size.height,
                      child: VideoPlayer(videoController!),
                    ),
                  )
                : Icon(
                    LucideIcons.video,
                    size: 64,
                    color: accent.withValues(alpha: 0.5),
                  ),
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: Material(
            color: Colors.black.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(24),
            child: InkWell(
              onTap: onToggleMute,
              borderRadius: BorderRadius.circular(24),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(
                  muted ? LucideIcons.volumeX : LucideIcons.volume2,
                  size: 24,
                  color: AppColors.onPrimary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _N22CtaRow extends StatelessWidget {
  const _N22CtaRow({required this.isNarrow, required this.accent});

  final bool isNarrow;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primary = FilledButton.icon(
      onPressed: () => context.go('/contact'),
      icon: const Icon(LucideIcons.play, size: 18),
      label: Text(l10n.n22CtaPrimary),
      style: FilledButton.styleFrom(
        backgroundColor: accent,
        foregroundColor: AppColors.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
    final secondary = OutlinedButton.icon(
      onPressed: () => context.go('/contact'),
      icon: Icon(LucideIcons.messageSquare, size: 16, color: accent),
      label: Text(l10n.n22CtaSecondary, style: TextStyle(color: accent, fontWeight: FontWeight.w600)),
      style: OutlinedButton.styleFrom(
        foregroundColor: accent,
        side: BorderSide(color: accent, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        backgroundColor: AppColors.surfaceElevatedDark.withValues(alpha: 0.9),
      ),
    );
    if (isNarrow) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [primary, const SizedBox(height: 10), secondary],
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [primary, const SizedBox(width: 14), secondary],
    );
  }
}

/// Desktop landscape cards (16:9).
class _N22DesktopGrid extends StatelessWidget {
  const _N22DesktopGrid({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final items = [
      (AppContent.assetN22DesktopDashboard, l10n.n22FeatureDashboard, l10n.n22FeatureDashboardDesc),
      (AppContent.assetN22DesktopCalendar, l10n.n22FeatureCalendar, l10n.n22FeatureCalendarDesc),
      (AppContent.assetN22DesktopPos, l10n.n22FeaturePos, l10n.n22FeaturePosDesc),
      (AppContent.assetN22DesktopReport, l10n.n22FeatureReports, l10n.n22FeatureReportsDesc),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 900;
        if (isNarrow) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(child: _N22LandscapeCard(asset: items[0].$1, title: items[0].$2, description: items[0].$3)),
                  const SizedBox(width: 12),
                  Expanded(child: _N22LandscapeCard(asset: items[1].$1, title: items[1].$2, description: items[1].$3)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _N22LandscapeCard(asset: items[2].$1, title: items[2].$2, description: items[2].$3)),
                  const SizedBox(width: 12),
                  Expanded(child: _N22LandscapeCard(asset: items[3].$1, title: items[3].$2, description: items[3].$3)),
                ],
              ),
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < items.length; i++) ...[
              if (i > 0) const SizedBox(width: 14),
              Expanded(
                child: _N22LandscapeCard(
                  asset: items[i].$1,
                  title: items[i].$2,
                  description: items[i].$3,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _N22LandscapeCard extends StatefulWidget {
  const _N22LandscapeCard({
    required this.asset,
    required this.title,
    required this.description,
  });

  final String asset;
  final String title;
  final String description;

  @override
  State<_N22LandscapeCard> createState() => _N22LandscapeCardState();
}

class _N22LandscapeCardState extends State<_N22LandscapeCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => _showFullImageDialog(context, widget.asset, title: widget.title),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final imageHeight = w * (9 / 16);
            return AnimatedScale(
              scale: _hovered ? 1.02 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevatedDark,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _hovered ? AppColors.accent : AppColors.borderDark,
                    width: _hovered ? 2 : 1,
                  ),
                  boxShadow: _hovered ? AppShadows.cardHover : AppShadows.card,
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: imageHeight,
                      child: Container(
                        color: AppColors.borderDark.withValues(alpha: 0.3),
                        child: Center(
                          child: Image.asset(
                            widget.asset,
                            fit: BoxFit.contain,
                            width: w,
                            height: imageHeight,
                            errorBuilder: (_, __, ___) => Icon(
                              LucideIcons.monitor,
                              size: 40,
                              color: AppColors.accent.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.title,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.description,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.onSurfaceVariantDark,
                                  height: 1.5,
                                  fontSize: 12,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Mobile portrait cards (3:4).
class _N22MobileGrid extends StatelessWidget {
  const _N22MobileGrid({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final items = [
      (AppContent.assetN22Login, l10n.n22FeatureLogin, l10n.n22FeatureLoginDesc),
      (AppContent.assetN22Dashboard, l10n.n22FeatureDashboard, l10n.n22FeatureDashboardDesc),
      (AppContent.assetN22Pos, l10n.n22FeaturePos, l10n.n22FeaturePosDesc),
      (AppContent.assetN22Profile, l10n.n22FeatureProfile, l10n.n22FeatureProfileDesc),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 700;
        if (isNarrow) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(child: _N22PortraitCard(asset: items[0].$1, title: items[0].$2, description: items[0].$3)),
                  const SizedBox(width: 12),
                  Expanded(child: _N22PortraitCard(asset: items[1].$1, title: items[1].$2, description: items[1].$3)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _N22PortraitCard(asset: items[2].$1, title: items[2].$2, description: items[2].$3)),
                  const SizedBox(width: 12),
                  Expanded(child: _N22PortraitCard(asset: items[3].$1, title: items[3].$2, description: items[3].$3)),
                ],
              ),
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < items.length; i++) ...[
              if (i > 0) const SizedBox(width: 14),
              Expanded(
                child: _N22PortraitCard(
                  asset: items[i].$1,
                  title: items[i].$2,
                  description: items[i].$3,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _N22PortraitCard extends StatefulWidget {
  const _N22PortraitCard({
    required this.asset,
    required this.title,
    required this.description,
  });

  final String asset;
  final String title;
  final String description;

  @override
  State<_N22PortraitCard> createState() => _N22PortraitCardState();
}

class _N22PortraitCardState extends State<_N22PortraitCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => _showFullImageDialog(context, widget.asset, title: widget.title),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final imageHeight = w * (4 / 3);
            return AnimatedScale(
              scale: _hovered ? 1.02 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevatedDark,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _hovered ? AppColors.accent : AppColors.borderDark,
                    width: _hovered ? 2 : 1,
                  ),
                  boxShadow: _hovered ? AppShadows.cardHover : AppShadows.card,
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: imageHeight,
                      child: Container(
                        color: AppColors.borderDark.withValues(alpha: 0.3),
                        child: Center(
                          child: Image.asset(
                            widget.asset,
                            fit: BoxFit.contain,
                            width: w,
                            height: imageHeight,
                            errorBuilder: (_, __, ___) => Icon(
                              LucideIcons.smartphone,
                              size: 40,
                              color: AppColors.accent.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.title,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.description,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.onSurfaceVariantDark,
                                  height: 1.5,
                                  fontSize: 12,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Clinic App section – redesigned for clarity and intuitive flow.
class _FeaturedPeriod9Section extends StatelessWidget {
  const _FeaturedPeriod9Section({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = Breakpoints.isMobile(width);
    final padding = isNarrow ? 20.0 : 32.0;

    final content = _ClinicAppContent(l10n: l10n, isNarrow: isNarrow);

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
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.3), width: 1),
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
                _Period9CaishenImage(),
                const SizedBox(height: 24),
                content,
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: _Period9CaishenImage(),
                ),
                const SizedBox(width: 40),
                Expanded(
                  flex: 3,
                  child: content,
                ),
              ],
            ),
    );
  }
}

/// Content block: title, tagline, features, description, CTAs.
class _ClinicAppContent extends StatelessWidget {
  const _ClinicAppContent({required this.l10n, required this.isNarrow});

  final AppLocalizations l10n;
  final bool isNarrow;

  @override
  Widget build(BuildContext context) {
    final titleSize = isNarrow ? 24.0 : 28.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              l10n.period9SpotlightTitle,
              style: highlightStyleForLocale(
                context,
                fontSize: titleSize,
                fontWeight: FontWeight.bold,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(width: 10),
            _FreeBadge(l10n: l10n),
          ],
        ),
        const SizedBox(height: 8),
        _AppsScreenState._buildDescriptionWithHighlight(
          context,
          l10n.period9SpotlightTagline,
          l10n.period9SpotlightTaglineHighlight,
          textAlign: TextAlign.left,
          highlightColor: AppColors.accent,
        ),
        const SizedBox(height: 16),
        _ClinicFeatureChips(l10n: l10n),
        const SizedBox(height: 12),
        Text(
          l10n.period9SpotlightDesc,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurfaceVariantDark,
                height: 1.5,
                fontSize: isNarrow ? 14 : 15,
              ),
        ),
        const SizedBox(height: 24),
        _DownloadButtonsRow(l10n: l10n),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(
              LucideIcons.smartphone,
              size: 14,
              color: AppColors.onSurfaceVariantDark.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 6),
            Text(
              l10n.period9Platforms,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariantDark.withValues(alpha: 0.8),
                    fontSize: 12,
                  ),
            ),
            const SizedBox(width: 16),
            Text(
              l10n.period9PremiumLabel,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariantDark.withValues(alpha: 0.7),
                    fontStyle: FontStyle.italic,
                    fontSize: 12,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Quick-scan feature chips: Appointments · Patients · Records.
class _ClinicFeatureChips extends StatelessWidget {
  const _ClinicFeatureChips({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final features = [
      (LucideIcons.calendar, l10n.period9FeatureAppointments),
      (LucideIcons.users, l10n.period9FeaturePatients),
      (LucideIcons.fileText, l10n.period9FeatureRecords),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: features.map((e) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(e.$1, size: 16, color: AppColors.accent),
              const SizedBox(width: 6),
              Text(
                e.$2,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        );
      }).toList(),
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
            mainAxisSize: MainAxisSize.min,
            children: [
              _StoreImageLink(
                imageAsset: AppContent.assetAppStoreIcon,
                url: AppContent.period9AppStoreUrl,
              ),
              const SizedBox(height: 12),
              _StoreImageLink(
                imageAsset: AppContent.assetGooglePlayIcon,
                url: AppContent.period9PlayStoreUrl,
              ),
            ],
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _StoreImageLink(
                imageAsset: AppContent.assetAppStoreIcon,
                url: AppContent.period9AppStoreUrl,
              ),
              const SizedBox(width: 16),
              _StoreImageLink(
                imageAsset: AppContent.assetGooglePlayIcon,
                url: AppContent.period9PlayStoreUrl,
              ),
            ],
          );
  }
}

/// Simple image link for store badges (no button styling).
class _StoreImageLink extends StatelessWidget {
  const _StoreImageLink({
    required this.imageAsset,
    required this.url,
  });

  final String imageAsset;
  final String? url;

  @override
  Widget build(BuildContext context) {
    final enabled = url != null && url!.isNotEmpty;

    return GestureDetector(
      onTap: enabled ? () => launchUrlExternal(url!) : null,
      child: Image.asset(
        imageAsset,
        height: 44,
        fit: BoxFit.contain,
        opacity: AlwaysStoppedAnimation(enabled ? 1.0 : 0.5),
        errorBuilder: (_, __, ___) => Icon(
          Icons.download,
          size: 28,
          color: enabled ? AppColors.onPrimary : AppColors.onSurfaceVariantDark,
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
            color: _hovered ? AppColors.serviceAppDevelopment.withValues(alpha: 0.5) : AppColors.borderDark,
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
                        color: AppColors.serviceAppDevelopment,
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
                    color: AppColors.serviceAppDevelopment,
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
                          textColor: AppColors.serviceAppDevelopment,
                          onPressed: () {},
                        ),
                      ),
                    );
                  },
                  icon: const Icon(LucideIcons.shoppingCart, size: 18),
                  label: Text(widget.l10n.bookStoreAddToCart),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.serviceAppDevelopment,
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
          color: AppColors.serviceAppDevelopment.withValues(alpha: 0.6),
          width: 1.5,
        ),
        boxShadow: [
          ...AppShadows.card,
          BoxShadow(
            color: AppColors.serviceAppDevelopment.withValues(alpha: 0.12),
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
        color: AppColors.serviceAppDevelopment.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.serviceAppDevelopment.withValues(alpha: 0.5)),
      ),
      child: const Icon(
        LucideIcons.cpu,
        size: 28,
        color: AppColors.serviceAppDevelopment,
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
      backgroundColor: AppColors.serviceAppDevelopment,
      foregroundColor: AppColors.onAccent,
      padding: EdgeInsets.symmetric(
        horizontal: isNarrow ? 16 : 20,
        vertical: isNarrow ? 12 : 14,
      ),
      minimumSize: Size(isNarrow ? 0 : 44, isNarrow ? 44 : 48),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
    final outlinedStyle = OutlinedButton.styleFrom(
      foregroundColor: AppColors.serviceAppDevelopment,
      side: const BorderSide(color: AppColors.serviceAppDevelopment),
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

/// Single Caishen image – fills its column without increasing container height.
class _Period9CaishenImage extends StatelessWidget {
  const _Period9CaishenImage();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        final hasBoundedHeight = h.isFinite && h > 0;
        final height = hasBoundedHeight ? h : (w * 0.75).clamp(200.0, 360.0);

        return GestureDetector(
          onTap: () => _showFullImageDialog(context, AppContent.assetCaishen, title: AppLocalizations.of(context)!.period9SpotlightTitle),
          child: SizedBox(
            width: w,
            height: height,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderDark, width: 1),
                boxShadow: AppShadows.card,
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                AppContent.assetCaishen,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (_, __, ___) => Center(
                  child: Icon(
                    LucideIcons.smartphone,
                    size: 40,
                    color: AppColors.onSurfaceVariantDark.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
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

