import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/breakpoints.dart';

/// Reusable section title block: overline label, main headline, accent line, optional subline.
/// Matches the services section style for consistency across all pages.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.overline,
    required this.title,
    this.subline,
    this.isNarrow,
    this.maxSublineWidth = 560,
  });

  /// Small uppercase label above the title (e.g. "SERVICES").
  final String overline;
  /// Main section headline.
  final String title;
  /// Optional supporting line below the accent bar.
  final String? subline;
  /// If true, uses tighter spacing. When null, derived from MediaQuery.
  final bool? isNarrow;
  /// Max width of the subline text. Defaults to 560.
  final double maxSublineWidth;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final narrow = isNarrow ?? Breakpoints.isMobile(width);
    final locale = Localizations.localeOf(context);
    final isKhmer = locale.languageCode == 'km';
    final displayOverline = isKhmer ? overline : overline.toUpperCase();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (overline.isNotEmpty) ...[
          Text(
            displayOverline,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  letterSpacing: isKhmer ? 0 : 3.2,
                  height: 1.2,
                ),
          ),
          SizedBox(height: narrow ? 12 : 16),
        ],
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.w700,
            fontSize: Breakpoints.isMobile(width) ? 28 : (width < 900 ? 36 : 44),
            height: 1.15,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: narrow ? 16 : 24),
        Container(
          width: 48,
          height: 3,
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        if (subline != null && subline!.isNotEmpty) ...[
          SizedBox(height: narrow ? 16 : 24),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxSublineWidth),
            child: Text(
              subline!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.onSurfaceVariantDark,
                fontSize: Breakpoints.isMobile(width) ? 16 : 18,
                height: 1.5,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
