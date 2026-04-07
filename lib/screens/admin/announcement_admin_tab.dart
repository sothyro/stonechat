import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../l10n/app_localizations.dart';
import '../../services/appointment_booking_service.dart' show isFirebaseEnabled;
import '../../services/error_service.dart';
import '../../services/site_announcement_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/site_announcement_dialog.dart';

/// Max width for the announcement editor on wide layouts (centered column).
const double _kAnnouncementSectionMaxWidth = 640;

/// SnackBar content on dark red / teal backgrounds (theme onSurface stays dark otherwise).
const TextStyle _kSnackOnError = TextStyle(color: AppColors.onPrimary);
const TextStyle _kSnackOnAccent = TextStyle(color: AppColors.onAccent);

/// Site announcement editor for Operations Hub (requires auth on parent).
class AnnouncementAdminTab extends StatefulWidget {
  const AnnouncementAdminTab({super.key});

  @override
  State<AnnouncementAdminTab> createState() => _AnnouncementAdminTabState();
}

class _AnnouncementAdminTabState extends State<AnnouncementAdminTab> {
  final _title = TextEditingController();
  final _body = TextEditingController();
  final _ctaLabel = TextEditingController();
  final _ctaUrl = TextEditingController();

  bool _enabled = false;
  DateTime? _startsAt;
  DateTime? _endsAt;
  int _revision = 0;
  bool _loading = false;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    _ctaLabel.dispose();
    _ctaUrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    if (!isFirebaseEnabled) {
      setState(() => _error = AppLocalizations.of(context)!.adminLoadError);
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final s = await fetchSiteAnnouncementAdmin();
      if (!mounted) return;
      setState(() {
        _enabled = s.enabled;
        _title.text = s.title;
        _body.text = s.body;
        _ctaLabel.text = s.ctaLabel;
        _ctaUrl.text = s.ctaUrl;
        _startsAt = s.startsAt;
        _endsAt = s.endsAt;
        _revision = s.revision;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      final msg = AppError.fromException(
        e,
        l10n: AppLocalizations.of(context)!,
        logError: false,
      ).userMessage;
      setState(() {
        _error = msg;
        _loading = false;
      });
    }
  }

  String _fmtLocal(DateTime? d) {
    if (d == null) return '';
    final x = d.toLocal();
    final mon = x.month.toString().padLeft(2, '0');
    final day = x.day.toString().padLeft(2, '0');
    final h = x.hour.toString().padLeft(2, '0');
    final m = x.minute.toString().padLeft(2, '0');
    return '${x.year}-$mon-$day $h:$m';
  }

  Future<void> _pickStartsAt() async {
    final now = DateTime.now();
    final initial = (_startsAt ?? now).toLocal();
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime(initial.year, initial.month, initial.day),
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (d == null || !mounted) return;
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: initial.hour, minute: initial.minute),
    );
    if (t == null || !mounted) return;
    setState(() {
      _startsAt = DateTime(d.year, d.month, d.day, t.hour, t.minute);
    });
  }

  Future<void> _pickEndsAt() async {
    final now = DateTime.now();
    final initial = (_endsAt ?? now).toLocal();
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime(initial.year, initial.month, initial.day),
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 6),
    );
    if (d == null || !mounted) return;
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: initial.hour, minute: initial.minute),
    );
    if (t == null || !mounted) return;
    setState(() {
      _endsAt = DateTime(d.year, d.month, d.day, t.hour, t.minute);
    });
  }

  SiteAnnouncementAdminSettings _collectForm() {
    return SiteAnnouncementAdminSettings(
      enabled: _enabled,
      title: _title.text,
      body: _body.text,
      ctaLabel: _ctaLabel.text,
      ctaUrl: _ctaUrl.text,
      startsAt: _startsAt,
      endsAt: _endsAt,
      revision: _revision,
      updatedAt: null,
    );
  }

  bool _ctaValid() {
    final l = _ctaLabel.text.trim();
    final u = _ctaUrl.text.trim();
    if (l.isEmpty && u.isEmpty) return true;
    return l.isNotEmpty && u.isNotEmpty;
  }

  Future<void> _preview() async {
    final l10n = AppLocalizations.of(context)!;
    final draft = _collectForm();
    final title = draft.title.trim();
    final body = draft.body.trim();
    if (title.isEmpty && body.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.adminAnnouncementPreviewNeedContent, style: _kSnackOnError),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    if (!_ctaValid()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.adminAnnouncementCtaPairHint, style: _kSnackOnError),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    await showSiteAnnouncementPreview(context, draft.toPreviewPayload());
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_ctaValid()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.adminAnnouncementCtaPairHint, style: _kSnackOnError),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    final start = _startsAt;
    final end = _endsAt;
    if (start != null && end != null && start.toUtc().isAfter(end.toUtc())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.adminAnnouncementInvalidSchedule, style: _kSnackOnError),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      final nextRev = await saveSiteAnnouncementAdmin(_collectForm());
      if (!mounted) return;
      setState(() => _revision = nextRev);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.adminAnnouncementSaveSuccess, style: _kSnackOnAccent),
          backgroundColor: AppColors.accent,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      final msg = AppError.fromException(
        e,
        l10n: AppLocalizations.of(context)!,
        logError: false,
      ).userMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg, style: _kSnackOnError),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(48),
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
      );
    }

    if (_error != null && !isFirebaseEnabled) {
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _kAnnouncementSectionMaxWidth),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              _error!,
              style: const TextStyle(color: AppColors.error),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    InputDecoration deco(String label, {String? hint}) {
      return InputDecoration(
        labelText: label,
        hintText: hint,
        counterText: '',
        labelStyle: const TextStyle(color: AppColors.onSurfaceVariantDark),
        hintStyle: TextStyle(color: AppColors.onSurfaceVariantDark.withValues(alpha: 0.7)),
        filled: true,
        fillColor: AppColors.surfaceElevatedDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _kAnnouncementSectionMaxWidth),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
          Text(
            l10n.adminAnnouncementTitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.adminAnnouncementSubtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceVariantDark,
                ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(
              _error!,
              style: const TextStyle(color: AppColors.error, fontSize: 13),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            l10n.adminAnnouncementRevision(_revision),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceVariantDark,
                ),
          ),
          const SizedBox(height: 20),
          SwitchListTile(
            value: _enabled,
            onChanged: (v) => setState(() => _enabled = v),
            title: Text(l10n.adminAnnouncementEnabled, style: const TextStyle(color: AppColors.onPrimary)),
            activeThumbColor: AppColors.accent,
            tileColor: AppColors.surfaceElevatedDark,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _title,
            style: const TextStyle(color: AppColors.onPrimary),
            decoration: deco(l10n.adminAnnouncementFieldTitle),
            maxLength: 200,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _body,
            style: const TextStyle(color: AppColors.onPrimary),
            decoration: deco(
              l10n.adminAnnouncementFieldBody,
              hint: l10n.adminAnnouncementFieldBodyHint,
            ),
            maxLines: 8,
            maxLength: 5000,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _ctaLabel,
            style: const TextStyle(color: AppColors.onPrimary),
            decoration: deco(l10n.adminAnnouncementCtaLabel),
            maxLength: 80,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _ctaUrl,
            style: const TextStyle(color: AppColors.onPrimary),
            decoration: deco(l10n.adminAnnouncementCtaUrl),
            keyboardType: TextInputType.url,
            maxLength: 2000,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.adminAnnouncementCtaPairHint,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceVariantDark,
                ),
          ),
          const SizedBox(height: 24),
          _ScheduleRow(
            label: l10n.adminAnnouncementStartsAt,
            value: _startsAt == null ? l10n.adminAnnouncementNotScheduled : _fmtLocal(_startsAt),
            onPick: _pickStartsAt,
            onClear: () => setState(() => _startsAt = null),
            clearLabel: l10n.adminAnnouncementClearSchedule,
            pickLabel: l10n.adminAnnouncementPickDate,
          ),
          const SizedBox(height: 12),
          _ScheduleRow(
            label: l10n.adminAnnouncementEndsAt,
            value: _endsAt == null ? l10n.adminAnnouncementNoEnd : _fmtLocal(_endsAt),
            onPick: _pickEndsAt,
            onClear: () => setState(() => _endsAt = null),
            clearLabel: l10n.adminAnnouncementClearSchedule,
            pickLabel: l10n.adminAnnouncementPickDate,
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              FilledButton.icon(
                onPressed: _saving ? null : _save,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.onAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
                icon: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onAccent),
                      )
                    : const Icon(LucideIcons.check, size: 18),
                label: Text(l10n.adminAnnouncementSave),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: _saving ? null : _preview,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.accent,
                  side: const BorderSide(color: AppColors.accent),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                icon: const Icon(LucideIcons.eye, size: 18),
                label: Text(l10n.adminAnnouncementPreview),
              ),
            ],
          ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScheduleRow extends StatelessWidget {
  const _ScheduleRow({
    required this.label,
    required this.value,
    required this.onPick,
    required this.onClear,
    required this.clearLabel,
    required this.pickLabel,
  });

  final String label;
  final String value;
  final VoidCallback onPick;
  final VoidCallback onClear;
  final String clearLabel;
  final String pickLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onPrimary),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              TextButton.icon(
                onPressed: onPick,
                icon: const Icon(LucideIcons.calendarClock, size: 18, color: AppColors.accent),
                label: Text(pickLabel, style: const TextStyle(color: AppColors.accent)),
              ),
              TextButton.icon(
                onPressed: onClear,
                icon: Icon(LucideIcons.x, size: 18, color: AppColors.onPrimary.withValues(alpha: 0.8)),
                label: Text(clearLabel, style: TextStyle(color: AppColors.onPrimary.withValues(alpha: 0.85))),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
