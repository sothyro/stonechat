import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../config/app_content.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/breakpoints.dart';
import '../../../widgets/academy_card.dart';
import '../../../widgets/section_header.dart';

/// Dark section with split heading/body and academy cards.
class AcademiesSection extends StatelessWidget {
  const AcademiesSection({super.key});

  static const Color _textLight = Color(0xFFE8E8E8);
  static const Color _textMuted = Color(0xFFB0B0B0);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = Breakpoints.isMobile(width);
    final viewportHeight = MediaQuery.sizeOf(context).height;
    final minSectionHeight = viewportHeight * 0.9;

    final paddingV = isNarrow ? 48.0 : 88.0;
    final paddingH = isNarrow ? 16.0 : 24.0;
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: minSectionHeight),
      padding: EdgeInsets.symmetric(vertical: paddingV, horizontal: paddingH),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF24201A),           // warm dark (top)
            Color(0xFF161210),           // mid
            Color(0xFF0A0808),           // deep dark (bottom)
          ],
          stops: [0.0, 0.45, 1.0],
        ),
      ),
      child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isNarrow) ...[
                  SectionHeader(
                    overline: l10n.stonechatSystem,
                    title: l10n.academiesAppsWebAiTitle,
                    isNarrow: true,
                  ),
                  const SizedBox(height: 24),
                  _buildBody(context, l10n),
                ] else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 32),
                          child: SectionHeader(
                            overline: l10n.stonechatSystem,
                            title: l10n.academiesAppsWebAiTitle,
                            isNarrow: false,
                          ),
                        ),
                      ),
                      Expanded(
                        child: _buildBody(context, l10n),
                      ),
                    ],
                  ),
                const SizedBox(height: 56),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final narrow = Breakpoints.isMobile(constraints.maxWidth);
                    if (narrow) {
                      return Column(
                        children: [
                          AcademyCard(
                            icon: LucideIcons.smartphone,
                            title: l10n.serviceAppDevelopment,
                            description: l10n.serviceAppDevelopmentDesc,
                            imageAsset: AppContent.assetServiceAppDevelopment,
                            onExplore: () => context.push('/apps'),
                          ),
                          const SizedBox(height: 20),
                          AcademyCard(
                            icon: LucideIcons.globe,
                            title: l10n.serviceResponsiveWeb,
                            description: l10n.serviceResponsiveWebDesc,
                            imageAsset: AppContent.assetServiceResponsiveWeb,
                            onExplore: () => context.push('/apps'),
                          ),
                          const SizedBox(height: 20),
                          AcademyCard(
                            icon: LucideIcons.cpu,
                            title: l10n.serviceAiAgent,
                            description: l10n.serviceAiAgentDesc,
                            imageAsset: AppContent.assetServiceAiAgent,
                            onExplore: () => context.push('/apps'),
                          ),
                        ],
                      );
                    }
                    return IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: AcademyCard(
                              icon: LucideIcons.smartphone,
                              title: l10n.serviceAppDevelopment,
                              description: l10n.serviceAppDevelopmentDesc,
                              imageAsset: AppContent.assetServiceAppDevelopment,
                              onExplore: () => context.push('/apps'),
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: AcademyCard(
                              icon: LucideIcons.globe,
                              title: l10n.serviceResponsiveWeb,
                              description: l10n.serviceResponsiveWebDesc,
                              imageAsset: AppContent.assetServiceResponsiveWeb,
                              onExplore: () => context.push('/apps'),
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: AcademyCard(
                              icon: LucideIcons.cpu,
                              title: l10n.serviceAiAgent,
                              description: l10n.serviceAiAgentDesc,
                              imageAsset: AppContent.assetServiceAiAgent,
                              onExplore: () => context.push('/apps'),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations l10n) {
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = Breakpoints.isMobile(width);
    final bodyStyle = textStyleWithLocale(
      context,
      isHeading: false,
      fontSize: isNarrow ? 14 : 15,
      fontWeight: FontWeight.w400,
      color: _textMuted,
    ).copyWith(height: 1.6);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.academiesBody1,
          style: bodyStyle,
        ),
        const SizedBox(height: 10),
        Text(
          l10n.academiesBody2,
          style: bodyStyle,
        ),
      ],
    );
  }
}
