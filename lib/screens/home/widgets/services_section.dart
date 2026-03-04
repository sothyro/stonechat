import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../config/app_content.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/breakpoints.dart';
import '../../../widgets/section_header.dart';

/// Home page services section: 6 service cards with images, placed below the hero.
/// Prominent section with a clear heading and intuitive, beautiful cards.
class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = Breakpoints.isMobile(width);
    final paddingH = isNarrow ? 16.0 : 24.0;
    final paddingV = isNarrow ? 48.0 : 72.0;

    // First row: App Development, Responsive Web, AI Agent. Second row: Book Creation Suite, Communications Training, Custom Project.
    final services = [
      _ServiceItem(
        title: l10n.serviceAppDevelopment,
        description: l10n.serviceAppDevelopmentDesc,
        imageAsset: AppContent.assetServiceAppDevelopment,
        color: AppColors.serviceAppDevelopment,
      ),
      _ServiceItem(
        title: l10n.serviceResponsiveWeb,
        description: l10n.serviceResponsiveWebDesc,
        imageAsset: AppContent.assetServiceResponsiveWeb,
        color: AppColors.serviceResponsiveWeb,
      ),
      _ServiceItem(
        title: l10n.serviceAiAgent,
        description: l10n.serviceAiAgentDesc,
        imageAsset: AppContent.assetServiceAiAgent,
        color: AppColors.serviceAiAgent,
      ),
      _ServiceItem(
        title: l10n.serviceBookCreation,
        description: l10n.serviceBookCreationDesc,
        imageAsset: AppContent.assetServiceBookCreation,
        color: AppColors.serviceBookCreation,
      ),
      _ServiceItem(
        title: l10n.serviceCommunicationsTraining,
        description: l10n.serviceCommunicationsTrainingDesc,
        imageAsset: AppContent.assetServiceCommunicationsTraining,
        color: AppColors.serviceCommunicationsTraining,
      ),
      _ServiceItem(
        title: l10n.serviceCustomProject,
        description: l10n.serviceCustomProjectDesc,
        imageAsset: AppContent.assetServiceCustomProject,
        color: AppColors.serviceCustomProject,
      ),
    ];

    return Container(
      width: double.infinity,
      color: AppColors.surfaceDark,
      padding: EdgeInsets.symmetric(vertical: paddingV, horizontal: paddingH),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RepaintBoundary(
                child: SectionHeader(
                  overline: l10n.sectionServicesOverline,
                  title: l10n.sectionServicesHeading,
                  subline: l10n.sectionServicesSubline,
                  isNarrow: isNarrow,
                ),
              ),
              SizedBox(height: isNarrow ? 32 : 48),
              LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth > 900
                      ? 3
                      : (constraints.maxWidth > 560 ? 2 : 1);
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: isNarrow ? 20 : 28,
                      crossAxisSpacing: isNarrow ? 20 : 28,
                      childAspectRatio: 0.58,
                    ),
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      final item = services[index];
                      return RepaintBoundary(
                        child: _ServiceCard(
                          title: item.title,
                          description: item.description,
                          imageAsset: item.imageAsset,
                          chipColor: item.color,
                          onTap: () => context.push('/consultations'),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServiceItem {
  const _ServiceItem({
    required this.title,
    required this.description,
    required this.imageAsset,
    required this.color,
  });
  final String title;
  final String description;
  final String imageAsset;
  final Color color;
}

/// Single service card: image, title, description, hover state.
class _ServiceCard extends StatefulWidget {
  const _ServiceCard({
    required this.title,
    required this.description,
    required this.imageAsset,
    required this.chipColor,
    required this.onTap,
  });

  final String title;
  final String description;
  final String imageAsset;
  final Color chipColor;
  final VoidCallback onTap;

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _hovered = false;

  /// Whether [chipColor] is dark (use white text on pill).
  bool get _isDarkChip {
    final c = widget.chipColor;
    final luminance = (0.299 * c.red + 0.587 * c.green + 0.114 * c.blue) / 255;
    return luminance < 0.5;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final learnMoreLabel = l10n?.serviceLearnMore ?? 'Learn more';
    final borderColor = _hovered
        ? widget.chipColor
        : AppColors.borderDark;
    final shadow = _hovered ? AppShadows.eventCardHover : AppShadows.eventCard;
    final scale = _hovered ? 1.02 : 1.0;
    final chipBg = widget.chipColor.withValues(alpha: _isDarkChip ? 0.85 : 0.22);
    final chipBorder = widget.chipColor.withValues(alpha: 0.9);
    final chipTextColor = _isDarkChip ? Colors.white : widget.chipColor;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                color: AppColors.surfaceElevatedDark,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor, width: _hovered ? 1.5 : 1),
                boxShadow: shadow,
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    flex: 8,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Positioned.fill(
                            child: Image.asset(
                              widget.imageAsset,
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                            errorBuilder: (_, __, ___) => Container(
                              color: AppColors.accent.withValues(alpha: 0.12),
                              child: Icon(
                                Icons.widgets_rounded,
                                size: 48,
                                color: AppColors.accent.withValues(alpha: 0.6),
                              ),
                            ),
                            ),
                          ),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.15),
                                  Colors.black.withValues(alpha: 0.5),
                                ],
                                stops: const [0.0, 0.5, 1.0],
                              ),
                            ),
                            child: const SizedBox.expand(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: chipBg,
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                color: chipBorder,
                                width: 1.25,
                              ),
                            ),
                            child: Text(
                              widget.title,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: chipTextColor,
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                height: 1.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            widget.description,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.onPrimary.withValues(alpha: 0.9),
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                learnMoreLabel,
                                style: TextStyle(
                                  color: widget.chipColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: 16,
                                color: widget.chipColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
