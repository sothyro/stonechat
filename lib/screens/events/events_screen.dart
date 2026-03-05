import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/app_content.dart';
import '../../config/events_data.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../utils/breakpoints.dart';
import '../../widgets/glass_container.dart';
import '../../widgets/section_header.dart';
import '../home/widgets/testimonials_section.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  String _searchQuery = '';

  List<EventItem> get _filteredEvents {
    final l10n = AppLocalizations.of(context)!;
    final events = getLocalizedEvents(l10n);
    if (_searchQuery.trim().isEmpty) return events;
    final q = _searchQuery.trim().toLowerCase();
    return events.where((e) {
      return e.title.toLowerCase().contains(q) ||
          e.date.toLowerCase().contains(q) ||
          e.location.toLowerCase().contains(q) ||
          e.description.toLowerCase().contains(q);
    }).toList();
  }

  void _openRegistration(EventItem event) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) => _EventRegistrationDialog(event: event),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = Breakpoints.isMobile(width);
    final filtered = _filteredEvents;

    return Container(
      width: double.infinity,
      color: AppColors.backgroundDark,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _EventsHero(
            searchQuery: _searchQuery,
            onSearchChanged: (v) => setState(() => _searchQuery = v),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isNarrow ? 16 : 32,
              vertical: isNarrow ? 32 : 40,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.eventsUpcomingHeadline,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.onPrimary,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.eventsUpcomingSubline,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.onSurfaceVariantDark,
                            height: 1.5,
                          ),
                    ),
                    const SizedBox(height: 20),
                    if (filtered.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Text(
                            l10n.noEventsMatch,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: AppColors.onSurfaceVariantDark,
                                ),
                          ),
                        ),
                      )
                    else if (isNarrow)
                      Column(
                        children: filtered.asMap().entries.map((entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: _EventCard(
                            event: entry.value,
                            onRegister: () => _openRegistration(entry.value),
                            useMainImage: entry.key == 0,
                          ),
                        )).toList(),
                      )
                    else
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final crossCount = Breakpoints.isNarrow(constraints.maxWidth) ? 1 : 2;
                          final list = filtered;
                          if (crossCount == 1) {
                            return Column(
                              children: list.asMap().entries.map((entry) => Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: _EventCard(
                                  event: entry.value,
                                  onRegister: () => _openRegistration(entry.value),
                                  useMainImage: entry.key == 0,
                                ),
                              )).toList(),
                            );
                          }
                          final rows = <Widget>[];
                          for (var i = 0; i < list.length; i += 2) {
                            final rowChildren = <Widget>[
                              Expanded(child: _EventCard(
                                event: list[i],
                                onRegister: () => _openRegistration(list[i]),
                                useMainImage: i == 0,
                              )),
                            ];
                            if (i + 1 < list.length) {
                              rowChildren.add(const SizedBox(width: 20));
                              rowChildren.add(Expanded(child: _EventCard(
                                event: list[i + 1],
                                onRegister: () => _openRegistration(list[i + 1]),
                                useMainImage: i + 1 == 0,
                              )));
                            } else {
                              rowChildren.add(const SizedBox(width: 20));
                              rowChildren.add(const Expanded(child: SizedBox()));
                            }
                            rows.add(Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: IntrinsicHeight(
                                child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: rowChildren),
                              ),
                            ));
                          }
                          return Column(children: rows);
                        },
                      ),
                    SizedBox(height: isNarrow ? 40 : 56),
                    // Courses section (former Academy content)
                    _buildCoursesSectionHeadline(context, l10n.courses),
                    const SizedBox(height: 12),
                    Text(
                      l10n.academyMoreCoursesNote,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.onSurfaceVariantDark,
                            height: 1.5,
                          ),
                    ),
                    const SizedBox(height: 40),
                    ..._buildCoursesCards(context, l10n, isNarrow),
                    const SizedBox(height: 56),
                    _buildCoursesMethodologySection(context, l10n),
                    const SizedBox(height: 48),
                    const TestimonialsSection(),
                    const SizedBox(height: 48),
                    _buildCoursesMarketingCta(context, l10n, isNarrow),
                    const SizedBox(height: 48),
                    _EventsWhyAttendSection(l10n: l10n),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildCoursesSectionHeadline(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.w600,
          ),
    );
  }

  static List<Widget> _buildCoursesCards(BuildContext context, AppLocalizations l10n, bool isNarrow) {
    final onExplore = () => context.push('/consultations');
    // Six services: App Development (Red), Responsive Web (Yellow), AI Agent (Teal), Book Creation (Green), Communications Training (Purple), Custom Project (Black).
    const gap = SizedBox(height: 24);
    const gapW = SizedBox(width: 24);
    final cards = [
      _CoursesDisciplineCard(
        imageAsset: AppContent.assetServiceAppDevelopment,
        icon: LucideIcons.smartphone,
        title: l10n.serviceAppDevelopment,
        description: l10n.eventCourseAppDevelopmentDesc,
        about: l10n.eventCourseAppDevelopmentAbout,
        topics: l10n.eventCourseAppDevelopmentTopics,
        onExplore: onExplore,
        accentColor: AppColors.serviceAppDevelopment,
        imageAlignment: Alignment.center,
      ),
      _CoursesDisciplineCard(
        imageAsset: AppContent.assetServiceResponsiveWeb,
        icon: LucideIcons.globe,
        title: l10n.serviceResponsiveWeb,
        description: l10n.eventCourseResponsiveWebDesc,
        about: l10n.eventCourseResponsiveWebAbout,
        topics: l10n.eventCourseResponsiveWebTopics,
        onExplore: onExplore,
        accentColor: AppColors.serviceResponsiveWeb,
        imageAlignment: Alignment.center,
      ),
      _CoursesDisciplineCard(
        imageAsset: AppContent.assetServiceAiAgent,
        icon: LucideIcons.cpu,
        title: l10n.serviceAiAgent,
        description: l10n.eventCourseAiAgentDesc,
        about: l10n.eventCourseAiAgentAbout,
        topics: l10n.eventCourseAiAgentTopics,
        onExplore: onExplore,
        accentColor: AppColors.serviceAiAgent,
        imageAlignment: Alignment.center,
      ),
      _CoursesDisciplineCard(
        imageAsset: AppContent.assetServiceBookCreation,
        icon: LucideIcons.bookOpen,
        title: l10n.serviceBookCreation,
        description: l10n.eventCourseBookCreationDesc,
        about: l10n.eventCourseBookCreationAbout,
        topics: l10n.eventCourseBookCreationTopics,
        onExplore: onExplore,
        accentColor: AppColors.serviceBookCreation,
        imageAlignment: Alignment.center,
      ),
      _CoursesDisciplineCard(
        imageAsset: AppContent.assetServiceCommunicationsTraining,
        icon: LucideIcons.messageCircle,
        title: l10n.serviceCommunicationsTraining,
        description: l10n.eventCourseCommunicationsTrainingDesc,
        about: l10n.eventCourseCommunicationsTrainingAbout,
        topics: l10n.eventCourseCommunicationsTrainingTopics,
        onExplore: onExplore,
        accentColor: AppColors.serviceCommunicationsTraining,
        imageAlignment: Alignment.center,
      ),
      _CoursesDisciplineCard(
        imageAsset: AppContent.assetServiceCustomProject,
        icon: LucideIcons.layers,
        title: l10n.serviceCustomProject,
        description: l10n.eventCourseCustomProjectDesc,
        about: l10n.eventCourseCustomProjectAbout,
        topics: l10n.eventCourseCustomProjectTopics,
        onExplore: onExplore,
        accentColor: AppColors.serviceCustomProject,
        imageAlignment: Alignment.center,
      ),
    ];
    if (isNarrow) {
      return [
        cards[0], gap, cards[1], gap, cards[2], gap,
        cards[3], gap, cards[4], gap, cards[5],
      ];
    }
    return [
      IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: cards[0]),
            gapW,
            Expanded(child: cards[1]),
            gapW,
            Expanded(child: cards[2]),
          ],
        ),
      ),
      gap,
      IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: cards[3]),
            gapW,
            Expanded(child: cards[4]),
            gapW,
            Expanded(child: cards[5]),
          ],
        ),
      ),
    ];
  }

  static Widget _buildCoursesMethodologySection(BuildContext context, AppLocalizations l10n) {
    final isNarrow = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isNarrow ? 24 : 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surfaceElevatedDark,
            AppColors.surfaceElevatedDark.withValues(alpha: 0.95),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.35), width: 1),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            overline: l10n.sectionKnowledgeOverline,
            title: l10n.sectionKnowledgeHeading,
            isNarrow: isNarrow,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.sectionKnowledgeBody,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.onSurfaceVariantDark,
                  height: 1.55,
                ),
          ),
          const SizedBox(height: 20),
          // Audience tiles: who our trainings are for.
          const SizedBox(height: 8),
          if (isNarrow)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _TrainingAudienceCard(
                  icon: LucideIcons.building2,
                  title: 'Government & Ministry teams',
                  description:
                      'Support for policy, communications and technical units that need clear, practical training without heavy jargon.',
                ),
                const SizedBox(height: 12),
                _TrainingAudienceCard(
                  icon: LucideIcons.briefcase,
                  title: 'Businesses & Startups',
                  description:
                      'Trainings to help founders and teams present ideas, write for customers and use AI tools in daily work.',
                ),
                const SizedBox(height: 12),
                _TrainingAudienceCard(
                  icon: LucideIcons.users,
                  title: 'NGOs & Training Centers',
                  description:
                      'Programs designed for NGOs, universities and training centers that need practical skills and local examples.',
                ),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Expanded(
                  child: _TrainingAudienceCard(
                    icon: LucideIcons.building2,
                    title: 'Government & Ministry teams',
                    description:
                        'Support for policy, communications and technical units that need clear, practical training without heavy jargon.',
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _TrainingAudienceCard(
                    icon: LucideIcons.briefcase,
                    title: 'Businesses & Startups',
                    description:
                        'Trainings to help founders and teams present ideas, write for customers and use AI tools in daily work.',
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _TrainingAudienceCard(
                    icon: LucideIcons.users,
                    title: 'NGOs & Training Centers',
                    description:
                        'Programs designed for NGOs, universities and training centers that need practical skills and local examples.',
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  static Widget _buildCoursesMarketingCta(BuildContext context, AppLocalizations l10n, bool isNarrow) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isNarrow ? 24 : 32),
      decoration: BoxDecoration(
        color: AppColors.backgroundDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderDark, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.notSureWhereToStart,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.notSureBody,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.onSurfaceVariantDark,
                  height: 1.55,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isNarrow ? 20 : 24),
          if (isNarrow)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: AppShadows.accentButton,
                  ),
                  child: FilledButton.icon(
                    onPressed: () => context.push('/consultations'),
                    icon: const Icon(LucideIcons.calendarCheck, size: 20),
                    label: Text(l10n.bookConsultation),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: AppColors.onAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => context.push('/contact'),
                  icon: const Icon(LucideIcons.messageCircle, size: 20),
                  label: Text(l10n.contactUs),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.accent,
                    side: const BorderSide(color: AppColors.accent),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  ),
                ),
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: AppShadows.accentButton,
                  ),
                  child: FilledButton.icon(
                    onPressed: () => context.push('/consultations'),
                    icon: const Icon(LucideIcons.calendarCheck, size: 20),
                    label: Text(l10n.bookConsultation),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: AppColors.onAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  onPressed: () => context.push('/contact'),
                  icon: const Icon(LucideIcons.messageCircle, size: 20),
                  label: Text(l10n.contactUs),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.accent,
                    side: const BorderSide(color: AppColors.accent),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  static Widget _buildDescriptionWithHighlight(
    BuildContext context,
    String description,
    String highlightPhrase, {
    TextAlign textAlign = TextAlign.left,
  }) {
    final bodyStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
      color: AppColors.onSurfaceVariantDark,
      height: 1.5,
    ) ?? const TextStyle(fontSize: 16, color: AppColors.onSurfaceVariantDark, height: 1.5);
    final highlightStyle = highlightStyleForLocale(
      context,
      color: AppColors.accent,
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
}

class _TrainingAudienceCard extends StatelessWidget {
  const _TrainingAudienceCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.serviceCommunicationsTraining.withValues(alpha: 0.6),
          width: 1,
        ),
        color: AppColors.backgroundDark.withValues(alpha: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.serviceCommunicationsTraining.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: AppColors.serviceCommunicationsTraining),
              ),
              const SizedBox(width: 10),
              Expanded(
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
          const SizedBox(height: 8),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceVariantDark,
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }
}

class _EventsHero extends StatefulWidget {
  const _EventsHero({
    required this.searchQuery,
    required this.onSearchChanged,
  });

  final String searchQuery;
  final ValueChanged<String> onSearchChanged;

  @override
  State<_EventsHero> createState() => _EventsHeroState();
}

class _EventsHeroState extends State<_EventsHero> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery);
  }

  @override
  void didUpdateWidget(_EventsHero oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery && _searchController.text != widget.searchQuery) {
      _searchController.text = widget.searchQuery;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = Breakpoints.isMobile(width);

    return SizedBox(
      height: isNarrow ? 640 : 520,
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
                  SectionHeader(
                    overline: l10n.eventsHeroOverline,
                    title: l10n.eventsHeroHeadline,
                    subline: l10n.eventsHeroSubline,
                    isNarrow: isNarrow,
                  ),
                  SizedBox(height: isNarrow ? 16 : 20),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 640),
                    child: _EventsScreenState._buildDescriptionWithHighlight(
                      context,
                      l10n.eventsDescription,
                      l10n.eventsDescriptionHighlight,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: isNarrow ? 24 : 32),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    child: TextField(
                      controller: _searchController,
                      onChanged: widget.onSearchChanged,
                      decoration: InputDecoration(
                        hintText: l10n.searchEvent,
                        hintStyle: TextStyle(color: AppColors.onSurfaceVariantDark.withValues(alpha: 0.8)),
                        prefixIcon: Icon(LucideIcons.search, size: 22, color: AppColors.onSurfaceVariantDark),
                        filled: true,
                        fillColor: AppColors.surfaceElevatedDark.withValues(alpha: 0.85),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.borderDark.withValues(alpha: 0.8)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.borderLight, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      ),
                      style: const TextStyle(color: AppColors.onPrimary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Marketing-style "Why attend" section: headline, lead paragraph, and three value bullets.
class _EventsWhyAttendSection extends StatelessWidget {
  const _EventsWhyAttendSection({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final isNarrow = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.eventsWhyAttendTitle,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.onPrimary,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
        ),
        SizedBox(height: isNarrow ? 14 : 18),
        Text(
          l10n.eventsWhyAttendLead,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.onSurfaceVariantDark,
                height: 1.6,
              ),
        ),
        SizedBox(height: isNarrow ? 20 : 28),
        _WhyAttendBullet(
          icon: LucideIcons.sparkles,
          text: l10n.eventsWhyAttend1,
        ),
        SizedBox(height: isNarrow ? 12 : 16),
        _WhyAttendBullet(
          icon: LucideIcons.users,
          text: l10n.eventsWhyAttend2,
        ),
        SizedBox(height: isNarrow ? 12 : 16),
        _WhyAttendBullet(
          icon: LucideIcons.calendarCheck,
          text: l10n.eventsWhyAttend3,
        ),
      ],
    );
  }
}

class _WhyAttendBullet extends StatelessWidget {
  const _WhyAttendBullet({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.accent.withValues(alpha: 0.35),
              width: 1,
            ),
          ),
          child: Icon(icon, size: 20, color: AppColors.accent),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.onSurfaceVariantDark,
                    height: 1.5,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}

class _EventCard extends StatefulWidget {
  const _EventCard({
    required this.event,
    required this.onRegister,
    this.useMainImage = false,
  });

  final EventItem event;
  final VoidCallback onRegister;
  /// When true, uses [AppContent.assetEventMain] (event2026.jpg) for the card image.
  final bool useMainImage;

  @override
  State<_EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<_EventCard> {
  bool _hovered = false;

  Color get _accent => widget.event.accentColor ?? AppColors.accent;

  @override
  Widget build(BuildContext context) {
    final e = widget.event;
    final l10n = AppLocalizations.of(context)!;
    final shadow = _hovered ? AppShadows.eventCardHover : AppShadows.eventCard;
    final borderColor = _hovered
        ? _accent.withValues(alpha: 0.65)
        : AppColors.borderDark;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: AppColors.surfaceElevatedDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: _hovered ? 1.5 : 1),
          boxShadow: shadow,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.asset(
                      e.imageAsset ?? (widget.useMainImage ? AppContent.assetEventMain : AppContent.assetEventCard),
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      errorBuilder: (_, __, ___) => Container(
                        color: _accent.withValues(alpha: 0.15),
                        child: Icon(LucideIcons.calendarDays, size: 48, color: _accent),
                      ),
                    ),
                  ),
                ),
                if (e.limitedSeats)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _accent.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: _accent.withValues(alpha: 0.35),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        l10n.limitedSeats,
                        style: const TextStyle(
                          color: AppColors.onAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    e.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.onPrimary,
                          fontWeight: FontWeight.w600,
                          height: 1.25,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Icon(LucideIcons.calendar, size: 18, color: _accent.withValues(alpha: 0.9)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          e.date,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.onSurfaceVariantDark,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(LucideIcons.mapPin, size: 18, color: _accent.withValues(alpha: 0.8)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          e.location,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.onSurfaceVariantDark,
                                height: 1.35,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    e.description.isNotEmpty ? e.description : ' ',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.onSurfaceVariantDark,
                          height: 1.5,
                        ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 24),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: widget.onRegister,
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: AppShadows.accentButton,
                          border: Border.all(
                            color: AppColors.accentLight.withValues(alpha: 0.4),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(LucideIcons.userPlus, size: 20, color: AppColors.onAccent),
                            const SizedBox(width: 10),
                            Text(
                              l10n.registerForEvent,
                              style: const TextStyle(
                                color: AppColors.onAccent,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
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
          ],
        ),
      ),
    );
  }
}

class _EventRegistrationDialog extends StatefulWidget {
  const _EventRegistrationDialog({required this.event});

  final EventItem event;

  @override
  State<_EventRegistrationDialog> createState() => _EventRegistrationDialogState();
}

class _EventRegistrationDialogState extends State<_EventRegistrationDialog> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _submitted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    if (name.isEmpty || email.isEmpty) return;

    final l10n = AppLocalizations.of(context)!;
    final body = '${l10n.eventColumn}: ${widget.event.title}\n${l10n.dateColumn}: ${widget.event.date}\n${l10n.locationColumn}: ${widget.event.location}\n\n${l10n.eventRegEmailBodyRegistrant}:\n${l10n.eventRegName}: $name\n${l10n.eventRegEmail}: $email\n${l10n.eventRegPhone}: $phone';
    final uri = Uri.parse(
      'mailto:${AppContent.email}?subject=${Uri.encodeComponent(l10n.eventRegEmailSubjectPrefix + widget.event.title)}&body=${Uri.encodeComponent(body)}',
    );
    if (await canLaunchUrl(uri)) await launchUrl(uri);
    if (mounted) setState(() => _submitted = true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final canSubmit = _nameController.text.trim().isNotEmpty &&
        _emailController.text.trim().isNotEmpty &&
        !_submitted;

    final isMobile = Breakpoints.isMobile(MediaQuery.of(context).size.width);
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 24,
        vertical: isMobile ? 24 : 48,
      ),
      child: GlassContainer(
        blurSigma: 10,
        color: AppColors.overlayDark.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight, width: 1),
        boxShadow: AppShadows.dialog,
        padding: EdgeInsets.zero,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 480, maxHeight: MediaQuery.of(context).size.height * 0.85),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.eventRegTitle,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(LucideIcons.x, size: 22, color: AppColors.onPrimary),
                      onPressed: () => Navigator.of(context).pop(),
                      tooltip: l10n.close,
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: AppColors.borderDark),
              if (_submitted)
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(Icons.check_circle, size: 56, color: AppColors.accent),
                      const SizedBox(height: 20),
                      Text(
                        l10n.eventRegSuccess,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.eventRegSuccessNote,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.onSurfaceVariantDark,
                              height: 1.5,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            foregroundColor: AppColors.onAccent,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(l10n.close),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceElevatedDark.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.borderDark),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.eventRegFor,
                                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                      color: AppColors.onSurfaceVariantDark,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.event.title,
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      color: AppColors.onPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          l10n.eventRegName,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: AppColors.onPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _nameController,
                          onChanged: (_) => setState(() {}),
                          decoration: _inputDecoration(),
                          style: const TextStyle(color: AppColors.onPrimary),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          l10n.eventRegEmail,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: AppColors.onPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (_) => setState(() {}),
                          decoration: _inputDecoration(),
                          style: const TextStyle(color: AppColors.onPrimary),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          l10n.eventRegPhone,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: AppColors.onPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: _inputDecoration(),
                          style: const TextStyle(color: AppColors.onPrimary),
                        ),
                        const SizedBox(height: 28),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: canSubmit ? _submit : null,
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.accent,
                              foregroundColor: AppColors.onAccent,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: Text(l10n.eventRegSubmit),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.backgroundDark,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.borderDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.borderLight, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}

/// Course discipline card: one of the six services with event/workshop copy and accent color.
class _CoursesDisciplineCard extends StatefulWidget {
  const _CoursesDisciplineCard({
    required this.imageAsset,
    required this.icon,
    required this.title,
    required this.description,
    required this.about,
    required this.topics,
    required this.onExplore,
    this.imageAlignment,
    this.accentColor,
  });

  final String imageAsset;
  final IconData icon;
  final String title;
  final String description;
  final String about;
  final String topics;
  final VoidCallback onExplore;
  final Alignment? imageAlignment;
  /// Service accent color (e.g. AppColors.serviceAppDevelopment). When null, uses AppColors.accent.
  final Color? accentColor;

  @override
  State<_CoursesDisciplineCard> createState() => _CoursesDisciplineCardState();
}

class _CoursesDisciplineCardState extends State<_CoursesDisciplineCard> {
  bool _isHovered = false;

  Color get _accent => widget.accentColor ?? AppColors.accent;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final shadow = _isHovered ? AppShadows.cardHover : AppShadows.card;
    final borderColor =
        _isHovered ? _accent.withValues(alpha: 0.6) : AppColors.borderDark;
    final scale = _isHovered ? 1.02 : 1.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: AppColors.surfaceElevatedDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1),
            boxShadow: shadow,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onExplore,
              borderRadius: BorderRadius.circular(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.asset(
                            widget.imageAsset,
                            fit: BoxFit.cover,
                            alignment: widget.imageAlignment ?? Alignment.topCenter,
                            errorBuilder: (_, __, ___) => Container(
                              color: _accent.withValues(alpha: 0.15),
                              child: Icon(widget.icon, size: 48, color: _accent),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundDark.withValues(alpha: 0.75),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: _accent.withValues(alpha: 0.5)),
                          ),
                          child: Icon(widget.icon, size: 20, color: _accent),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 26,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.title,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.onPrimary,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 36,
                          child: Text(
                            widget.description,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: _accent.withValues(alpha: 0.95),
                                  height: 1.4,
                                  fontSize: 13,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 54,
                          child: Text(
                            widget.about,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  height: 1.5,
                                  color: AppColors.onSurfaceVariantDark,
                                  fontSize: 12,
                                ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 32,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(LucideIcons.sparkles, size: 12, color: _accent),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  widget.topics,
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                        color: AppColors.onSurfaceVariantDark,
                                        height: 1.35,
                                        fontSize: 11,
                                      ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 22,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                l10n.exploreCourses,
                                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                      color: _accent,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              Icon(Icons.arrow_forward, size: 16, color: _accent),
                            ],
                          ),
                        ),
                      ],
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
