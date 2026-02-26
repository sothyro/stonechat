import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/app_content.dart';
import '../../config/events_data.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../utils/breakpoints.dart';
import '../../widgets/glass_container.dart';

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
    final highlightStyle = GoogleFonts.condiment(
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
      height: isNarrow ? 640 : 600,
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
              padding: EdgeInsets.symmetric(
                horizontal: isNarrow ? 16 : 24,
                vertical: isNarrow ? 48 : 56,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.eventsHeroHeadline,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColors.onPrimary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: isNarrow ? 10 : 14),
                  Text(
                    l10n.eventsHeroSubline,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                    textAlign: TextAlign.center,
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

  @override
  Widget build(BuildContext context) {
    final e = widget.event;
    final l10n = AppLocalizations.of(context)!;
    final shadow = _hovered ? AppShadows.eventCardHover : AppShadows.eventCard;
    final borderColor = _hovered
        ? AppColors.borderLight.withValues(alpha: 0.6)
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
                      widget.useMainImage ? AppContent.assetEventMain : AppContent.assetEventCard,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.accent.withValues(alpha: 0.15),
                        child: Icon(LucideIcons.calendarDays, size: 48, color: AppColors.accent),
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
                        color: AppColors.accent.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accentGlow.withValues(alpha: 0.35),
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
                      Icon(LucideIcons.calendar, size: 18, color: AppColors.onSurfaceVariantDark),
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
                      Icon(LucideIcons.mapPin, size: 18, color: AppColors.onSurfaceVariantDark),
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

    final body = 'Event: ${widget.event.title}\nDate: ${widget.event.date}\nLocation: ${widget.event.location}\n\nRegistrant:\nName: $name\nEmail: $email\nPhone: $phone';
    final uri = Uri.parse(
      'mailto:${AppContent.email}?subject=Event Registration: ${Uri.encodeComponent(widget.event.title)}&body=${Uri.encodeComponent(body)}',
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
