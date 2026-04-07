import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import '../services/site_announcement_service.dart';
import '../theme/app_theme.dart';
import '../utils/breakpoints.dart';
import 'glass_container.dart';

const String _kDismissedRevisionPrefsKey = 'site_announcement_dismissed_revision';

/// Fetch public announcement and show dialog or bottom sheet if needed.
Future<void> fetchAndMaybeShowSiteAnnouncement(BuildContext context) async {
  try {
    final payload = await fetchSiteAnnouncement();
    if (!context.mounted || payload == null) return;
    final prefs = await SharedPreferences.getInstance();
    final dismissed = prefs.getInt(_kDismissedRevisionPrefsKey);
    if (dismissed != null && payload.revision <= dismissed) return;
    if (!context.mounted) return;
    await showSiteAnnouncementPresentation(context, payload: payload, persistDismissal: true);
  } catch (_) {
    // Visitors: never block the shell on announcement errors.
  }
}

/// Preview from Operations Hub (does not touch dismissal prefs).
Future<void> showSiteAnnouncementPreview(
  BuildContext context,
  SiteAnnouncementPayload payload,
) {
  return showSiteAnnouncementPresentation(context, payload: payload, persistDismissal: false);
}

Future<void> showSiteAnnouncementPresentation(
  BuildContext context, {
  required SiteAnnouncementPayload payload,
  required bool persistDismissal,
}) async {
  final width = MediaQuery.sizeOf(context).width;
  final useSheet = Breakpoints.isMobile(width);

  Future<void> persistIfNeeded() async {
    if (!persistDismissal) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kDismissedRevisionPrefsKey, payload.revision);
  }

  if (useSheet) {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (ctx) {
        final bottomInset = MediaQuery.paddingOf(ctx).bottom;
        return Padding(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 16 + bottomInset),
          child: SafeArea(
            top: false,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: GlassContainer(
                blurSigma: 14,
                color: AppColors.overlayDark.withValues(alpha: 0.97),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.85)),
                child: SiteAnnouncementPanel(
                  payload: payload,
                  onClose: () => Navigator.of(ctx).pop(),
                  showDragHint: true,
                ),
              ),
            ),
          ),
        );
      },
    );
    await persistIfNeeded();
    return;
  }

  await showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: GlassContainer(
          blurSigma: 14,
          color: AppColors.overlayDark.withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.borderLight, width: 1.2),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: SiteAnnouncementPanel(
              payload: payload,
              onClose: () => Navigator.of(ctx).pop(),
            ),
          ),
        ),
      );
    },
  );
  await persistIfNeeded();
}

class SiteAnnouncementPanel extends StatelessWidget {
  const SiteAnnouncementPanel({
    super.key,
    required this.payload,
    required this.onClose,
    this.showDragHint = false,
  });

  final SiteAnnouncementPayload payload;
  final VoidCallback onClose;
  final bool showDragHint;

  Future<void> _openCta(BuildContext context) async {
    final url = payload.ctaUrl;
    if (url == null || url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final titleStyle = Theme.of(context).textTheme.titleLarge?.copyWith(
          color: AppColors.onPrimary,
          fontWeight: FontWeight.w700,
          height: 1.2,
        );
    final bodyStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: AppColors.onSurfaceVariantDark,
          height: 1.55,
        );

    final paragraphs = payload.body
        .split(RegExp(r'\n\s*\n'))
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDragHint) ...[
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.onSurfaceVariantDark.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(LucideIcons.sparkles, color: AppColors.accent, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.siteAnnouncementDialogLabel,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: AppColors.accent,
                            letterSpacing: 0.06 * 12,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    if (payload.title.trim().isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(payload.title.trim(), style: titleStyle),
                    ],
                  ],
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: Icon(LucideIcons.x, color: AppColors.onPrimary.withValues(alpha: 0.75)),
                onPressed: onClose,
                tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
              ),
            ],
          ),
          if (paragraphs.isNotEmpty) ...[
            const SizedBox(height: 18),
            ...paragraphs.expand((p) => [
                  Text(p, style: bodyStyle),
                  const SizedBox(height: 12),
                ]),
          ],
          if (payload.ctaUrl != null &&
              payload.ctaUrl!.isNotEmpty &&
              payload.ctaLabel != null &&
              payload.ctaLabel!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => _openCta(context),
                icon: const Icon(LucideIcons.externalLink, size: 18, color: AppColors.accent),
                label: Text(
                  payload.ctaLabel!,
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 8),
          FilledButton(
            onPressed: onClose,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: AppColors.onAccent,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(l10n.siteAnnouncementGotIt),
          ),
        ],
      ),
    );
  }
}
