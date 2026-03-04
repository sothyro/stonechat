import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../config/app_content.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/breakpoints.dart';
import '../../../widgets/section_header.dart';

class ConsultationsSection extends StatelessWidget {
  const ConsultationsSection({super.key});

  static const double _cardGap = 24.0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = Breakpoints.isMobile(width);
    // Service IDs must match Consultations page: bazi, fengshui, dateselection, qimeniching, maosan, publications
    const serviceIds = ['bazi', 'fengshui', 'dateselection', 'qimeniching', 'maosan', 'publications'];
    // Map each consultation card to one of the six core services and its brand colour.
    const accentColors = <Color>[
      AppColors.serviceAppDevelopment,
      AppColors.serviceResponsiveWeb,
      AppColors.serviceAiAgent,
      AppColors.serviceBookCreation,
      AppColors.serviceCommunicationsTraining,
      AppColors.serviceCustomProject,
    ];
    final blocks = [
      _ConsultBlock(
        category: l10n.consult1Category,
        method: l10n.consult1Method,
        question: l10n.consult1Question,
        description: l10n.consult1Desc,
        icon: LucideIcons.smartphone,
        serviceId: serviceIds[0],
        accentColor: accentColors[0],
        onGetConsultation: () => context.push('/consultations?service=${serviceIds[0]}'),
      ),
      _ConsultBlock(
        category: l10n.consult2Category,
        method: l10n.consult2Method,
        question: l10n.consult2Question,
        description: l10n.consult2Desc,
        icon: LucideIcons.messageCircle,
        serviceId: serviceIds[1],
        accentColor: accentColors[4],
        onGetConsultation: () => context.push('/consultations?service=${serviceIds[1]}'),
      ),
      _ConsultBlock(
        category: l10n.consult3Category,
        method: l10n.consult3Method,
        question: l10n.consult3Question,
        description: l10n.consult3Desc,
        icon: LucideIcons.bookOpen,
        serviceId: serviceIds[2],
        accentColor: accentColors[3],
        onGetConsultation: () => context.push('/consultations?service=${serviceIds[2]}'),
      ),
      _ConsultBlock(
        category: l10n.consult4Category,
        method: l10n.consult4Method,
        question: l10n.consult4Question,
        description: l10n.consult4Desc,
        icon: LucideIcons.layers,
        serviceId: serviceIds[3],
        accentColor: accentColors[5],
        onGetConsultation: () => context.push('/consultations?service=${serviceIds[3]}'),
      ),
      _ConsultBlock(
        category: l10n.consult5Category,
        method: l10n.consult5Method,
        question: l10n.consult5Question,
        description: l10n.consult5Desc,
        icon: LucideIcons.globe,
        serviceId: serviceIds[4],
        accentColor: accentColors[1],
        onGetConsultation: () => context.push('/consultations?service=${serviceIds[4]}'),
      ),
      _ConsultBlock(
        category: l10n.consult6Category,
        method: l10n.consult6Method,
        question: l10n.consult6Question,
        description: l10n.consult6Desc,
        icon: LucideIcons.cpu,
        serviceId: serviceIds[5],
        accentColor: accentColors[2],
        onGetConsultation: () => context.push('/consultations?service=${serviceIds[5]}'),
      ),
    ];

    // Stack must have a non-positioned child so it gets finite size inside
    // SingleChildScrollView (unbounded height). Background/overlay use
    // Positioned.fill; content is the sizing child.
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: Image.asset(
            AppContent.assetBackgroundDirection,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: AppColors.surfaceDark,
              child: const Center(
                child: Icon(Icons.broken_image_outlined, size: 48, color: AppColors.onPrimary),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            color: AppColors.overlayDark.withValues(alpha: 0.58),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: isMobile ? 40 : 56,
            horizontal: isMobile ? 16 : 24,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SectionHeader(
                    overline: l10n.sectionMapOverline,
                    title: l10n.sectionMapHeading,
                    isNarrow: isMobile,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l10n.sectionMapIntro,
                    style: textStyleWithLocale(
                      context,
                      isHeading: false,
                      fontSize: width < 600 ? 15 : 17,
                      height: 1.6,
                      color: AppColors.onPrimary.withValues(alpha: 0.92),
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 44),
                  if (isMobile) ...[
                    ...blocks.map((b) => Padding(
                          padding: const EdgeInsets.only(bottom: _cardGap),
                          child: b,
                        )),
                  ] else
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Row 1: App Development – Responsive Web
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: blocks[0]), // App Development
                            const SizedBox(width: _cardGap),
                            Expanded(child: blocks[4]), // Responsive Web
                          ],
                        ),
                        const SizedBox(height: _cardGap),
                        // Row 2: Book Creation Suite – Communications Training
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: blocks[2]), // Book Creation Suite
                            const SizedBox(width: _cardGap),
                            Expanded(child: blocks[1]), // Communications Training
                          ],
                        ),
                        const SizedBox(height: _cardGap),
                        // Row 3: AI Agent – Custom Project
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: blocks[5]), // AI Agent
                            const SizedBox(width: _cardGap),
                            Expanded(child: blocks[3]), // Custom Project
                          ],
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ConsultBlock extends StatefulWidget {
  const _ConsultBlock({
    required this.category,
    required this.method,
    required this.question,
    required this.description,
    required this.icon,
    required this.serviceId,
    required this.accentColor,
    required this.onGetConsultation,
  });

  final String category;
  final String method;
  final String question;
  final String description;
  final IconData icon;
  final String serviceId;
  final Color accentColor;
  final VoidCallback onGetConsultation;

  @override
  State<_ConsultBlock> createState() => _ConsultBlockState();
}

class _ConsultBlockState extends State<_ConsultBlock> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final accent = widget.accentColor;
    final shadow = _isHovered ? AppShadows.cardHover : AppShadows.card;
    final borderColor = _isHovered ? accent.withValues(alpha: 0.8) : AppColors.borderDark;
    final scale = _isHovered ? 1.02 : 1.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onGetConsultation,
            borderRadius: BorderRadius.circular(12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOut,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevatedDark.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor, width: 1),
                boxShadow: shadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: accent.withValues(alpha: 0.5),
                            width: 1,
                          ),
                        ),
                        child: Icon(widget.icon, size: 28, color: accent),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.category,
                              style: textStyleWithLocale(
                                context,
                                isHeading: true,
                                color: accent,
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                height: 1.25,
                                letterSpacing: 0.3,
                              ),
                            ),
                            if (widget.method != widget.category) ...[
                              const SizedBox(height: 4),
                              Text(
                                widget.method,
                                style: textStyleWithLocale(
                                  context,
                                  isHeading: false,
                                  color: AppColors.onPrimary.withValues(alpha: 0.7),
                                  fontSize: 13,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.question,
                    style: textStyleWithLocale(
                      context,
                      isHeading: false,
                      fontStyle: FontStyle.italic,
                      color: AppColors.onPrimary.withValues(alpha: 0.95),
                      fontSize: 15,
                      height: 1.45,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 1,
                    margin: const EdgeInsets.only(left: 0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          accent.withValues(alpha: 0.0),
                          accent.withValues(alpha: 0.7),
                          accent.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    widget.description,
                    style: textStyleWithLocale(
                      context,
                      isHeading: false,
                      color: AppColors.onPrimary.withValues(alpha: 0.9),
                      fontSize: 14,
                      height: 1.55,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: widget.onGetConsultation,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.onPrimary,
                        side: BorderSide(color: accent, width: 1.6),
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        l10n.getConsultation,
                        style: textStyleWithLocale(
                          context,
                          isHeading: false,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
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
