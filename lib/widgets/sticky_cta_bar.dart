import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import 'glass_container.dart';
import 'staff_login_dialog.dart';
import 'subscribe_dialog.dart';

/// Floating vertical bar on the right side for Subscribe + Staff login / Hub.
class StickyCtaBar extends StatefulWidget {
  const StickyCtaBar({super.key});

  @override
  State<StickyCtaBar> createState() => _StickyCtaBarState();
}

class _StickyCtaBarState extends State<StickyCtaBar> {
  bool _dismissed = false;

  void _openSubscribe() {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const SubscribeDialog(),
    );
  }

  void _onStaffTap(AuthProvider auth) {
    if (auth.isLoggedIn) {
      context.go('/admin');
      return;
    }
    showStaffLoginDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_dismissed) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;
    final auth = context.watch<AuthProvider>();

    final textStyle = Theme.of(context).textTheme.titleSmall?.copyWith(
          color: AppColors.onAccent,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        );

    const radius = BorderRadius.only(
      topLeft: Radius.circular(12),
      bottomLeft: Radius.circular(12),
    );
    return GlassContainer(
      blurSigma: 10,
      color: AppColors.accent.withValues(alpha: 0.9),
      borderRadius: radius,
      border: const Border(
        left: BorderSide(color: AppColors.borderLight, width: 1.5),
        top: BorderSide(color: AppColors.borderLight, width: 1.5),
        bottom: BorderSide(color: AppColors.borderLight, width: 1.5),
      ),
      boxShadow: AppShadows.stickyCta,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      child: IntrinsicWidth(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 480),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(LucideIcons.x, color: AppColors.onAccent, size: 18),
                  onPressed: () => setState(() => _dismissed = true),
                  tooltip: l10n.dismiss,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                  style: IconButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                const SizedBox(height: 8),
                _VerticalCta(
                  icon: LucideIcons.mail,
                  label: l10n.stickyCtaText,
                  textStyle: textStyle,
                  onTap: _openSubscribe,
                ),
                const SizedBox(height: 8),
                Divider(color: AppColors.onAccent.withValues(alpha: 0.35), height: 24, thickness: 1),
                _VerticalCta(
                  icon: auth.isLoggedIn ? LucideIcons.layoutDashboard : LucideIcons.logIn,
                  label: auth.isLoggedIn ? l10n.stickyDashboardCta : l10n.stickyLoginCta,
                  textStyle: textStyle,
                  onTap: () => _onStaffTap(auth),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _VerticalCta extends StatelessWidget {
  const _VerticalCta({
    required this.icon,
    required this.label,
    required this.textStyle,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final TextStyle? textStyle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.onAccent, size: 22),
            const SizedBox(height: 12),
            RotatedBox(
              quarterTurns: 3,
              child: Text(
                label,
                style: textStyle,
                textAlign: TextAlign.center,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
