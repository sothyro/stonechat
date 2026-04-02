import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../providers/locale_provider.dart';
import '../config/app_content.dart';
import '../utils/breakpoints.dart';
import 'glass_container.dart';
import 'logo_with_shape_shadow.dart';
import 'media_posts_popup.dart';

/// Menu bar colors: cyan/teal accent for frame, link text (glass fill uses [AppColors.overlayDark]).
class _MenuColors {
  _MenuColors._();
  static const Color barBorder = Color(0xFF00A9B8); // cyan/teal, matches AppColors.accent
  static const Color linkText = Color(0xFFF0F0F0);
}

/// Menu bar corner radius (desktop and mobile).
const double _kMenuBarRadius = 22.0;
const double _kStartupFriendlyBlurSigma = 8.0;

/// Header outer vertical padding used by [AppHeader].
const double kAppHeaderOuterVerticalPadding = 16.0;

/// Internal stack height used by desktop/mobile headers.
const double kAppHeaderStackHeight = 240.0;

/// Height reported by [AppHeader.preferredSize]. Use with [AppShell] top padding (12)
/// and [MediaQuery.padding] so page content clears the overlay header.
const double kAppHeaderPreferredHeight =
    (kAppHeaderOuterVerticalPadding * 2) + kAppHeaderStackHeight;

/// Max tappable area for the overlay header in [AppShell].
/// Keeps only the visible menu zone interactive and lets content underneath
/// receive taps below this line.
const double kAppHeaderHitTestHeight = 140.0;

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader({super.key, this.onOpenDrawer});

  final VoidCallback? onOpenDrawer;

  @override
  Size get preferredSize => const Size.fromHeight(kAppHeaderPreferredHeight);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeNotifier = context.watch<LocaleNotifier>();
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = Breakpoints.isMobile(width);
    return Semantics(
      container: true,
      label: l10n.semanticsNavigation,
      // No [Container] color: transparent — that adds a [ColoredBox] that hit-tests
      // opaque across the full header band and triggers deep hit tests during web resize
      // before inner children finish layout ("never been laid out").
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: kAppHeaderOuterVerticalPadding,
          horizontal: 24,
        ),
        child: isMobile
            ? _MobileHeader(
                l10n: l10n,
                onOpenDrawer: onOpenDrawer,
                localeNotifier: localeNotifier,
              )
            : _DesktopHeader(l10n: l10n, localeNotifier: localeNotifier),
        ),
    );
  }
}

/// Standard left inset for logo: matches bar horizontal padding (used for both mobile and desktop).
const double _kLogoLeftInsetDesktop = 28.0;

class _MobileHeader extends StatelessWidget {
  const _MobileHeader({
    required this.l10n,
    this.onOpenDrawer,
    required this.localeNotifier,
  });

  final AppLocalizations l10n;
  final VoidCallback? onOpenDrawer;
  final LocaleNotifier localeNotifier;

  /// Match desktop: bar 72, stack 240, logo 154×184.
  static void _mobileDimensions(void Function(double barHeight, double logoHeight, double logoSlotWidth, double stackHeight) fn) {
    fn(72, 154, 184, 240);
  }

  @override
  Widget build(BuildContext context) {
    late double barHeight, logoHeight, logoSlotWidth, stackHeight;
    _mobileDimensions((b, l, s, h) {
      barHeight = b;
      logoHeight = l;
      logoSlotWidth = s;
      stackHeight = h;
    });

    return SizedBox(
      height: stackHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: barHeight,
            child: GlassContainer(
              blurSigma: _kStartupFriendlyBlurSigma,
              color: AppColors.overlayDark.withValues(alpha: 0.42),
              borderRadius: BorderRadius.circular(_kMenuBarRadius),
              border: Border.all(color: _MenuColors.barBorder, width: 1.5),
              boxShadow: AppShadows.header,
              padding: const EdgeInsets.only(left: 16, right: 28, top: 10, bottom: 10),
              child: Row(
                children: [
                  SizedBox(width: logoHeight + 10),
                  const SizedBox(width: 4),
                  Text(
                    l10n.menu,
                    style: TextStyle(
                      color: _MenuColors.linkText,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    icon: const Icon(LucideIcons.menu, color: _MenuColors.linkText, size: 24),
                    onPressed: onOpenDrawer ?? () {},
                    tooltip: l10n.menu,
                    style: IconButton.styleFrom(
                      minimumSize: const Size(kMinTouchTargetSize, kMinTouchTargetSize),
                      tapTargetSize: MaterialTapTargetSize.padded,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _ContactUsButton(l10n: l10n),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 28,
            top: barHeight + 8,
            child: _LocaleFlagsRow(notifier: localeNotifier),
          ),
          Positioned(
            left: _kLogoLeftInsetDesktop,
            top: -36,
            height: logoHeight,
            width: logoSlotWidth,
            child: GestureDetector(
              onTap: () => context.go('/'),
              behavior: HitTestBehavior.opaque,
              child: LogoWithShapeShadow(
                assetPath: AppContent.assetLogo,
                height: logoHeight,
                errorBuilder: (_, __, ___) => Text(
                  AppContent.shortName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DesktopHeader extends StatelessWidget {
  const _DesktopHeader({required this.l10n, required this.localeNotifier});

  final AppLocalizations l10n;
  final LocaleNotifier localeNotifier;

  /// Paths per dropdown (by index). Training dropdown: Event Calendar, Our Story; "On the news" is popup.
  static const _dropdownPaths = [
    ['/events', '/journey'],
  ];

  /// Sentinel value for Training dropdown: "On the news" runs a callback instead of navigating.
  static const _kOnTheNewsAction = '__on_the_news__';

  @override
  Widget build(BuildContext context) {
    final current = GoRouterState.of(context).uri.path;
    final pathOnly = current.split('#').first;
    int activeDropdownIndex = -1;
    for (int i = 0; i < _dropdownPaths.length; i++) {
      if (_dropdownPaths[i].any((p) => pathOnly == p || pathOnly.startsWith('$p/'))) {
        activeDropdownIndex = i;
      }
    }
    final width = MediaQuery.sizeOf(context).width;
    final isTablet = width >= Breakpoints.mobile && width < Breakpoints.tablet;
    const logoHeight = 154.0;
    const logoSlotWidth = 184.0;
    const stackHeight = 240.0;
    const barHeight = 72.0;
    final rowChildren = [
      const SizedBox(width: logoSlotWidth),
      const SizedBox(width: 36),
      _NavLink(label: l10n.home, path: '/'),
      _NavDropdown(
        label: l10n.training,
        items: [
          _NavItem(l10n.eventsCalendar, '/events', LucideIcons.calendarDays),
          _NavItem(l10n.ourStory, '/journey', LucideIcons.compass),
          _NavItem(l10n.onTheNews, _kOnTheNewsAction, LucideIcons.fileText),
        ],
        isActive: activeDropdownIndex == 0,
        actionValue: _kOnTheNewsAction,
        onAction: (context) => showMediaPostsPopup(context),
      ),
      _NavLink(label: l10n.appsNav, path: '/apps'),
      _NavLink(label: l10n.publications, path: '/book'),
      _NavLink(label: l10n.consultations, path: '/consultations'),
      if (isTablet) const SizedBox(width: 24) else const Spacer(),
      const SizedBox(width: 20),
      _ContactUsButton(l10n: l10n),
    ];
    final row = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: isTablet ? MainAxisSize.min : MainAxisSize.max,
      children: rowChildren,
    );
    final content = ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: isTablet ? double.infinity : 1280,
        minHeight: 56,
      ),
      child: isTablet
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: row,
            )
          : row,
    );
    return Center(
      child: SizedBox(
        height: stackHeight,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              height: barHeight,
              child: GlassContainer(
                blurSigma: _kStartupFriendlyBlurSigma,
                color: AppColors.overlayDark.withValues(alpha: 0.42),
                borderRadius: BorderRadius.circular(_kMenuBarRadius),
                border: Border.all(color: _MenuColors.barBorder, width: 1.5),
                boxShadow: AppShadows.header,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
                child: content,
              ),
            ),
            Positioned(
              right: 36,
              top: barHeight + 8,
              child: _LocaleFlagsRow(notifier: localeNotifier),
            ),
            Positioned(
              left: _kLogoLeftInsetDesktop,
              top: -36,
              height: logoHeight,
              width: logoSlotWidth,
              child: GestureDetector(
                onTap: () => context.go('/'),
                child: LogoWithShapeShadow(
                  assetPath: AppContent.assetLogo,
                  height: logoHeight,
                  errorBuilder: (_, __, ___) => Text(
                    AppContent.shortName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.bold,
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
}

/// Contact Us button styled like the Hero section's "Book Consultation" button.
class _ContactUsButton extends StatelessWidget {
  const _ContactUsButton({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = Breakpoints.isMobile(width);
    final isNarrow = Breakpoints.isNarrow(width);
    final horizontalPadding = isMobile ? 16.0 : (isNarrow ? 20.0 : 24.0);
    final verticalPadding = isMobile ? 8.0 : (isNarrow ? 10.0 : 12.0);
    final fontSize = isMobile ? 14.0 : (isNarrow ? 14.0 : 15.0);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: AppShadows.accentButton,
      ),
      child: FilledButton(
        onPressed: () => context.push('/contact'),
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.onAccent,
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
          minimumSize: isMobile ? const Size(0, kMinTouchTargetSize) : null,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          l10n.contactUs,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink({required this.label, required this.path});

  final String label;
  final String path;

  @override
  Widget build(BuildContext context) {
    final current = GoRouterState.of(context).uri.path;
    final isActive = current == path;
    final isMobile = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: TextButton(
        onPressed: () => context.go(path),
        style: TextButton.styleFrom(
          foregroundColor: _MenuColors.linkText,
          padding: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: isMobile ? 14 : 6,
          ),
          minimumSize: isMobile ? const Size(kMinTouchTargetSize, kMinTouchTargetSize) : Size.zero,
          tapTargetSize: isMobile ? MaterialTapTargetSize.padded : MaterialTapTargetSize.shrinkWrap,
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered)) {
              return _MenuColors.linkText.withValues(alpha: 0.1);
            }
            return null;
          }),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppColors.accent : _MenuColors.linkText,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                fontSize: 14,
              ),
            ),
            if (isActive)
              Container(
                margin: const EdgeInsets.only(top: 4),
                height: 2,
                width: 24,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.label, this.path, [this.icon]);
  final String label;
  final String path;
  final IconData? icon;
}

class _NavDropdown extends StatelessWidget {
  const _NavDropdown({
    required this.label,
    required this.items,
    required this.isActive,
    this.actionValue,
    this.onAction,
  });

  final String label;
  final List<_NavItem> items;
  /// When true, this dropdown is shown as the active nav item. Only one dropdown
  /// should be active per route so that shared paths (e.g. /events) don't highlight multiple menus.
  final bool isActive;
  /// When the user selects an item with this path, [onAction] is called instead of navigating.
  final String? actionValue;
  final void Function(BuildContext context)? onAction;

  static const _itemHeight = 48.0;

  Future<void> _showDropdown(BuildContext context, RenderBox button) async {
    final uri = GoRouterState.of(context).uri;
    final currentFull = uri.path + (uri.fragment.isNotEmpty ? '#${uri.fragment}' : '');
    final offset = button.localToGlobal(Offset.zero);
    final size = MediaQuery.sizeOf(context);
    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + button.size.height + 6,
        size.width - offset.dx,
        size.height - offset.dy - button.size.height - 6,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: _MenuColors.barBorder, width: 1.5),
      ),
      color: AppColors.overlayDark.withValues(alpha: 0.92),
      elevation: 12,
      items: items
          .map((e) => PopupMenuItem<String>(
                value: e.path,
                height: _itemHeight,
                padding: EdgeInsets.zero,
                child: _DropdownItem(
                  label: e.label,
                  icon: e.icon,
                  isActive: currentFull == e.path || currentFull.startsWith('${e.path}/'),
                ),
              ))
          .toList(),
    );
    if (selected != null && context.mounted) {
      if (actionValue != null && selected == actionValue && onAction != null) {
        onAction!(context);
      } else {
        context.go(selected);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Builder(
        builder: (context) {
          final isMobile = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);
          return InkWell(
            onTap: () {
              final box = context.findRenderObject() as RenderBox?;
              if (box != null) _showDropdown(context, box);
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: isMobile ? 14 : 6,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          color: isActive ? AppColors.accent : _MenuColors.linkText,
                          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        LucideIcons.chevronDown,
                        size: 16,
                        color: isActive ? AppColors.accent : _MenuColors.linkText,
                      ),
                    ],
                  ),
                  if (isActive)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      height: 2,
                      width: 24,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DropdownItem extends StatelessWidget {
  const _DropdownItem({required this.label, this.icon, required this.isActive});

  final String label;
  final IconData? icon;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon!, size: 18, color: isActive ? AppColors.accent : Colors.white70),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: isActive ? AppColors.accent : Colors.white,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          if (isActive) const Icon(LucideIcons.check, size: 16, color: AppColors.accent),
        ],
      ),
    );
  }
}

class _LocaleFlagsRow extends StatelessWidget {
  const _LocaleFlagsRow({required this.notifier});

  final LocaleNotifier notifier;

  static const _locales = [
    ('en', '🇬🇧'),
    ('km', '🇰🇭'),
    ('zh', '🇨🇳'),
  ];

  @override
  Widget build(BuildContext context) {
    final code = notifier.locale.languageCode;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _locales.map((e) {
        final isSelected = code == e.$1;
        return Padding(
          padding: const EdgeInsets.only(left: 6),
          child: InkWell(
            onTap: () => notifier.setLocaleFromCode(e.$1),
            borderRadius: BorderRadius.circular(14),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? AppColors.accent.withValues(alpha: 0.35)
                    : Colors.white.withValues(alpha: 0.10),
                border: Border.all(
                  color: isSelected ? AppColors.accent : Colors.white24,
                  width: isSelected ? 1.6 : 1,
                ),
              ),
              child: Text(
                e.$2,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
