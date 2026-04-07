import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../services/admin_hub_service.dart';
import '../../services/appointment_booking_service.dart' show isFirebaseEnabled;
import '../../theme/app_theme.dart';
import '../../utils/breakpoints.dart';
import '../../widgets/glass_container.dart';
import 'announcement_admin_tab.dart';
import 'appointments_admin_tab.dart';

/// Max content width for Subscribers / Contacts on wide layouts (matches [AnnouncementAdminTab]).
const double _kAdminHubListSectionMaxWidth = 640;

enum AdminHubSection { subscribers, appointments, contacts, announcement }

AdminHubSection adminHubSectionFromQuery(String? tab) {
  switch (tab) {
    case 'subscribers':
      return AdminHubSection.subscribers;
    case 'contacts':
      return AdminHubSection.contacts;
    case 'announcement':
      return AdminHubSection.announcement;
    case 'appointments':
    default:
      return AdminHubSection.appointments;
  }
}

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key, this.initialSection});

  final AdminHubSection? initialSection;

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  late AdminHubSection _section;

  final _loginEmail = TextEditingController();
  final _loginPassword = TextEditingController();
  bool _loginLoading = false;
  bool _obscurePassword = true;
  String? _loginError;

  List<EmailSubscriberRecord> _subscribers = [];
  List<ContactSubmissionRecord> _contacts = [];
  bool _loadingSubscribers = false;
  bool _loadingContacts = false;
  String? _subscribersError;
  String? _contactsError;
  String _subscriberQuery = '';
  String _contactQuery = '';

  @override
  void initState() {
    super.initState();
    _section = widget.initialSection ?? AdminHubSection.appointments;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (context.read<AuthProvider>().isLoggedIn) _loadLists();
    });
  }

  @override
  void dispose() {
    _loginEmail.dispose();
    _loginPassword.dispose();
    super.dispose();
  }

  Future<void> _loadLists() async {
    if (!isFirebaseEnabled) return;
    setState(() {
      _loadingSubscribers = true;
      _loadingContacts = true;
      _subscribersError = null;
      _contactsError = null;
    });
    try {
      final subs = await listEmailSubscribers(limit: 500);
      if (!mounted) return;
      setState(() {
        _subscribers = subs;
        _loadingSubscribers = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _subscribersError = e.toString();
        _loadingSubscribers = false;
      });
    }
    try {
      final c = await listContactSubmissions(limit: 300);
      if (!mounted) return;
      setState(() {
        _contacts = c;
        _loadingContacts = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _contactsError = e.toString();
        _loadingContacts = false;
      });
    }
  }

  Future<void> _submitLogin(AuthProvider auth) async {
    final email = _loginEmail.text.trim();
    final password = _loginPassword.text;
    if (email.isEmpty || password.isEmpty) return;
    setState(() {
      _loginLoading = true;
      _loginError = null;
    });
    try {
      await auth.signIn(email, password);
      if (!mounted) return;
      setState(() => _loginLoading = false);
      await _loadLists();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loginLoading = false;
        _loginError = AppLocalizations.of(context)!.loginError;
      });
    }
  }

  String _fmtDate(String? iso) {
    if (iso == null || iso.isEmpty) return '—';
    final d = DateTime.tryParse(iso);
    if (d == null) return iso;
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }

  String _friendlyError(String? raw) {
    if (raw == null || raw.trim().isEmpty) return '';
    return raw.replaceFirst(RegExp(r'^Exception:\s*'), '').trim();
  }

  PreferredSizeWidget _buildAdminAppBar(BuildContext context, AppLocalizations l10n, AuthProvider auth) {
    return AppBar(
      backgroundColor: AppColors.surfaceElevatedDark,
      foregroundColor: AppColors.onPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(LucideIcons.arrowLeft),
        onPressed: () => context.go('/'),
        tooltip: l10n.backToHome,
      ),
      title: Text(l10n.adminHubTitle),
      actions: auth.isLoggedIn
          ? [
              IconButton(
                tooltip: l10n.refresh,
                onPressed: _loadLists,
                icon: const Icon(LucideIcons.refreshCw, color: AppColors.accent),
              ),
              IconButton(
                tooltip: l10n.logoutButton,
                onPressed: () => unawaited(auth.signOut()),
                icon: const Icon(LucideIcons.logOut),
              ),
            ]
          : null,
    );
  }

  Widget _buildLoginBody(BuildContext context, AppLocalizations l10n, AuthProvider auth) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: GlassContainer(
              blurSigma: 14,
              color: AppColors.overlayDark.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.borderLight),
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    LucideIcons.shieldCheck,
                    size: 40,
                    color: AppColors.accent,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.adminLoginTitle,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppColors.onPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.adminLoginSubtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.onSurfaceVariantDark,
                        ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _loginEmail,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: AppColors.onPrimary),
                    decoration: _fieldDeco(l10n.loginEmail),
                    onSubmitted: (_) => _submitLogin(auth),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _loginPassword,
                    obscureText: _obscurePassword,
                    style: const TextStyle(color: AppColors.onPrimary),
                    decoration: _fieldDeco(l10n.loginPassword).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? LucideIcons.eye : LucideIcons.eyeOff,
                          color: AppColors.onSurfaceVariantDark,
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    onSubmitted: (_) => _submitLogin(auth),
                  ),
                  if (_loginError != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _loginError!,
                      style: const TextStyle(color: AppColors.error, fontSize: 13),
                    ),
                  ],
                  const SizedBox(height: 22),
                  FilledButton(
                    onPressed: _loginLoading ? null : () => _submitLogin(auth),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: AppColors.onAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _loginLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.onAccent,
                            ),
                          )
                        : Text(l10n.loginButton),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => context.go('/'),
                    child: Text(
                      l10n.backToHome,
                      style: const TextStyle(color: AppColors.accent),
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

  /// Full-viewport hub: [LayoutBuilder] gives a stable width from real constraints (no marketing shell scroll).
  Widget _buildHubBody(BuildContext context, AppLocalizations l10n, AuthProvider auth) {
    final email = auth.userEmail;
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final useRail = w >= Breakpoints.mobile;
        final railExtended = w >= 1024;

        if (useRail) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              NavigationRail(
                extended: railExtended,
                backgroundColor: AppColors.surfaceElevatedDark,
                selectedIndex: _section.index,
                indicatorColor: AppColors.accent.withValues(alpha: 0.25),
                selectedIconTheme: const IconThemeData(color: AppColors.accent),
                selectedLabelTextStyle: const TextStyle(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                ),
                unselectedIconTheme:
                    IconThemeData(color: AppColors.onPrimary.withValues(alpha: 0.7)),
                unselectedLabelTextStyle:
                    const TextStyle(color: AppColors.onSurfaceVariantDark),
                onDestinationSelected: (i) =>
                    setState(() => _section = AdminHubSection.values[i]),
                labelType: railExtended
                    ? NavigationRailLabelType.none
                    : NavigationRailLabelType.all,
                destinations: [
                  NavigationRailDestination(
                    icon: const Icon(LucideIcons.mail),
                    label: Text(l10n.adminTabSubscribers),
                  ),
                  NavigationRailDestination(
                    icon: const Icon(LucideIcons.calendarDays),
                    label: Text(l10n.adminTabAppointments),
                  ),
                  NavigationRailDestination(
                    icon: const Icon(LucideIcons.inbox),
                    label: Text(l10n.adminTabContacts),
                  ),
                  NavigationRailDestination(
                    icon: const Icon(LucideIcons.megaphone),
                    label: Text(l10n.adminTabAnnouncement),
                  ),
                ],
              ),
              const VerticalDivider(width: 1, thickness: 1, color: AppColors.borderDark),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (email != null && email.isNotEmpty)
                            Text(
                              email,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.onSurfaceVariantDark,
                                  ),
                            ),
                          Text(
                            l10n.adminHubSubtitle,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.onSurfaceVariantDark.withValues(alpha: 0.9),
                                ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: _buildSectionContent(l10n)),
                  ],
                ),
              ),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (email != null && email.isNotEmpty)
                    Text(
                      email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.onSurfaceVariantDark,
                          ),
                    ),
                  Text(
                    l10n.adminHubSubtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceVariantDark.withValues(alpha: 0.9),
                        ),
                  ),
                ],
              ),
            ),
            Expanded(child: _buildSectionContent(l10n)),
            NavigationBar(
              height: 64,
              backgroundColor: AppColors.surfaceElevatedDark,
              indicatorColor: AppColors.accent.withValues(alpha: 0.3),
              selectedIndex: _section.index,
              onDestinationSelected: (i) =>
                  setState(() => _section = AdminHubSection.values[i]),
              destinations: [
                NavigationDestination(
                  icon: const Icon(LucideIcons.mail),
                  label: l10n.adminTabSubscribers,
                ),
                NavigationDestination(
                  icon: const Icon(LucideIcons.calendarDays),
                  label: l10n.adminTabAppointments,
                ),
                NavigationDestination(
                  icon: const Icon(LucideIcons.inbox),
                  label: l10n.adminTabContacts,
                ),
                NavigationDestination(
                  icon: const Icon(LucideIcons.megaphone),
                  label: l10n.adminTabAnnouncement,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: _buildAdminAppBar(context, l10n, auth),
      body: auth.isLoggedIn ? _buildHubBody(context, l10n, auth) : _buildLoginBody(context, l10n, auth),
    );
  }

  InputDecoration _fieldDeco(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.onSurfaceVariantDark),
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

  Widget _buildSectionContent(AppLocalizations l10n) {
    switch (_section) {
      case AdminHubSection.subscribers:
        return _buildSubscribers(l10n);
      case AdminHubSection.appointments:
        return const Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: AppointmentsAdminTab(),
        );
      case AdminHubSection.contacts:
        return _buildContacts(l10n);
      case AdminHubSection.announcement:
        return const Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: AnnouncementAdminTab(),
        );
    }
  }

  Widget _buildSubscribers(AppLocalizations l10n) {
    final q = _subscriberQuery.trim().toLowerCase();
    final filtered = q.isEmpty
        ? _subscribers
        : _subscribers.where((s) => s.email.toLowerCase().contains(q)).toList();
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _kAdminHubListSectionMaxWidth),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                _sectionTopBar(
                  title: l10n.adminSubscribersHeading,
                  count: filtered.length,
                  totalCount: _subscribers.length,
                  onRefresh: _loadLists,
                ),
                const SizedBox(height: 12),
                _searchField(
                  hint: l10n.adminSubscribersSearchHint,
                  onChanged: (v) => setState(() => _subscriberQuery = v),
                ),
                if (_subscribersError != null) ...[
                  const SizedBox(height: 12),
                  _errorBanner(_friendlyError(_subscribersError)),
                ],
                if (_loadingSubscribers)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(child: CircularProgressIndicator(color: AppColors.accent)),
                  )
                else if (filtered.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Text(
                        l10n.adminSubscribersEmpty,
                        style: const TextStyle(color: AppColors.onSurfaceVariantDark),
                      ),
                    ),
                  )
                else ...[
                  const SizedBox(height: 16),
                  ...filtered.map((s) => _subscriberCard(l10n, s)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContacts(AppLocalizations l10n) {
    final q = _contactQuery.trim().toLowerCase();
    final filtered = q.isEmpty
        ? _contacts
        : _contacts.where((c) {
            final hay = '${c.name} ${c.email} ${c.phone} ${c.subjectLabel} ${c.message}'
                .toLowerCase();
            return hay.contains(q);
          }).toList();
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _kAdminHubListSectionMaxWidth),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                _sectionTopBar(
                  title: l10n.adminContactsHeading,
                  count: filtered.length,
                  totalCount: _contacts.length,
                  onRefresh: _loadLists,
                ),
                const SizedBox(height: 12),
                _searchField(
                  hint: 'Search contacts',
                  onChanged: (v) => setState(() => _contactQuery = v),
                ),
                if (_contactsError != null) ...[
                  const SizedBox(height: 12),
                  _errorBanner(_friendlyError(_contactsError)),
                ],
                if (_loadingContacts)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(child: CircularProgressIndicator(color: AppColors.accent)),
                  )
                else if (filtered.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Text(
                        l10n.adminContactsEmpty,
                        style: const TextStyle(color: AppColors.onSurfaceVariantDark),
                      ),
                    ),
                  )
                else ...[
                  const SizedBox(height: 16),
                  ...filtered.map((c) => _contactCard(l10n, c)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTopBar({
    required String title,
    required int count,
    required int totalCount,
    required VoidCallback onRefresh,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                '$count / $totalCount',
                style: const TextStyle(
                  color: AppColors.onSurfaceVariantDark,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: AppLocalizations.of(context)!.refresh,
          onPressed: onRefresh,
          icon: const Icon(LucideIcons.refreshCw, color: AppColors.accent),
        ),
      ],
    );
  }

  Widget _searchField({
    required String hint,
    required ValueChanged<String> onChanged,
  }) {
    return TextField(
      onChanged: onChanged,
      style: const TextStyle(color: AppColors.onPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: AppColors.onSurfaceVariantDark.withValues(alpha: 0.8),
        ),
        prefixIcon: const Icon(LucideIcons.search, color: AppColors.accent),
        filled: true,
        fillColor: AppColors.surfaceElevatedDark,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
        ),
      ),
    );
  }

  Widget _errorBanner(String message) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.7)),
      ),
      child: Text(message, style: const TextStyle(color: AppColors.error)),
    );
  }

  Widget _metaChip(String label, {bool accented = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: accented
            ? AppColors.accent.withValues(alpha: 0.12)
            : AppColors.backgroundDark.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: accented
              ? AppColors.accent.withValues(alpha: 0.45)
              : AppColors.borderDark,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: accented ? AppColors.accent : AppColors.onSurfaceVariantDark,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _serviceColorForSubject(String subjectLabel) {
    final s = subjectLabel.trim().toLowerCase();
    if (s.isEmpty) return AppColors.onSurfaceVariantDark;

    if (s.contains('app development') || s.contains('ការអភិវឌ្ឍកម្មវិធី') || s.contains('应用开发')) {
      return AppColors.serviceAppDevelopment;
    }
    if (s.contains('responsive web') || s.contains('វ៉ែបឆបឧបករណ៍') || s.contains('响应式网站')) {
      return AppColors.serviceResponsiveWeb;
    }
    if (s.contains('ai agent') || s.contains('ភ្នាក់ងារ ai') || s.contains('ai 智能体')) {
      return AppColors.serviceAiAgent;
    }
    if (s.contains('book creation') || s.contains('ការបង្កើតសៀវភៅ') || s.contains('图书创作')) {
      return AppColors.serviceBookCreation;
    }
    if (s.contains('communications training') ||
        s.contains('វគ្គបណ្តុះបណ្តាលការទំនាក់ទំនង') ||
        s.contains('传播培训')) {
      return AppColors.serviceCommunicationsTraining;
    }
    if (s.contains('custom project') || s.contains('គម្រោងផ្ទាល់') || s.contains('定制项目')) {
      return AppColors.serviceCustomProject;
    }
    return AppColors.onSurfaceVariantDark;
  }

  Widget _serviceSubjectChip(String label) {
    final color = _serviceColorForSubject(label);
    final isCustomProject = color == AppColors.serviceCustomProject;
    final chipTextColor = isCustomProject ? AppColors.onPrimary : color;
    final chipBorderColor = isCustomProject
        ? AppColors.onPrimary.withValues(alpha: 0.65)
        : color.withValues(alpha: 0.5);
    final chipBgColor = isCustomProject
        ? AppColors.serviceCustomProject.withValues(alpha: 0.55)
        : color.withValues(alpha: 0.14);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: chipBgColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: chipBorderColor),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: chipTextColor,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _statusPill(String status) {
    final normalized = status.trim().isEmpty ? 'new' : status.trim().toLowerCase();
    final isNew = normalized == 'new';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: (isNew ? AppColors.accent : AppColors.onSurfaceVariantDark)
            .withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: (isNew ? AppColors.accent : AppColors.onSurfaceVariantDark)
              .withValues(alpha: 0.45),
        ),
      ),
      child: Text(
        normalized,
        style: TextStyle(
          color: isNew ? AppColors.accent : AppColors.onSurfaceVariantDark,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _subscriberCard(AppLocalizations l10n, EmailSubscriberRecord s) {
    final status = s.status.trim().isEmpty ? 'active' : s.status;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: AppColors.surfaceElevatedDark,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: () => _showSubscriberDetail(l10n, s),
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    LucideIcons.mail,
                    size: 18,
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.email,
                        style: const TextStyle(
                          color: AppColors.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _metaChip(status, accented: true),
                          _metaChip(
                            '${l10n.adminColSubscribed}: ${_fmtDate(s.createdAtIso)}',
                          ),
                          _metaChip(
                            '${l10n.adminColLastConfirmed}: ${_fmtDate(s.lastConfirmedAtIso)}',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  LucideIcons.chevronRight,
                  color: AppColors.onSurfaceVariantDark.withValues(alpha: 0.7),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _contactCard(AppLocalizations l10n, ContactSubmissionRecord c) {
    final preview = c.message.trim().replaceAll('\n', ' ');
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: AppColors.surfaceElevatedDark,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: () => _showContactDetail(l10n, c),
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              c.name.isEmpty ? c.email : c.name,
                              style: const TextStyle(
                                color: AppColors.onPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          _statusPill(c.status),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          _metaChip(c.email, accented: true),
                          if (c.phone.isNotEmpty) _metaChip(c.phone),
                          if (c.subjectLabel.isNotEmpty) _serviceSubjectChip(c.subjectLabel),
                        ],
                      ),
                      if (preview.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          preview,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.onSurfaceVariantDark,
                            height: 1.35,
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Text(
                        '${l10n.adminColDate}: ${_fmtDate(c.createdAtIso)}',
                        style: const TextStyle(
                          color: AppColors.onSurfaceVariantDark,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  LucideIcons.chevronRight,
                  color: AppColors.onSurfaceVariantDark.withValues(alpha: 0.6),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _copyText(String value) async {
    if (value.trim().isEmpty) return;
    await Clipboard.setData(ClipboardData(text: value));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied: $value')),
    );
  }

  void _showSubscriberDetail(AppLocalizations l10n, EmailSubscriberRecord s) {
    final body = _recordDetailBody(
      title: s.email,
      subtitle: '${l10n.adminColStatus}: ${s.status}',
      lines: [
        '${l10n.adminColSubscribed}: ${_fmtDate(s.createdAtIso)}',
        '${l10n.adminColLastConfirmed}: ${_fmtDate(s.lastConfirmedAtIso)}',
      ],
      primaryActionLabel: l10n.adminColEmail,
      onPrimaryAction: () => _copyText(s.email),
    );
    _showResponsiveDetail(l10n.adminTabSubscribers, body);
  }

  void _showContactDetail(AppLocalizations l10n, ContactSubmissionRecord c) {
    final body = _recordDetailBody(
      title: c.name.isEmpty ? '—' : c.name,
      subtitle: '${l10n.adminColDate}: ${_fmtDate(c.createdAtIso)}',
      lines: [
        '${l10n.adminColEmail}: ${c.email}',
        if (c.phone.isNotEmpty) '${l10n.adminColPhone}: ${c.phone}',
        if (c.subjectLabel.isNotEmpty) '${l10n.adminColSubject}: ${c.subjectLabel}',
        '${l10n.adminColStatus}: ${c.status}',
      ],
      messageTitle: l10n.adminMessageTitle,
      message: c.message,
      primaryActionLabel: l10n.adminColEmail,
      onPrimaryAction: () => _copyText(c.email),
      secondaryActionLabel: c.phone.isNotEmpty ? l10n.adminColPhone : null,
      onSecondaryAction: c.phone.isNotEmpty ? () => _copyText(c.phone) : null,
    );
    _showResponsiveDetail(l10n.adminTabContacts, body);
  }

  Widget _recordDetailBody({
    required String title,
    required String subtitle,
    required List<String> lines,
    String? messageTitle,
    String? message,
    String? primaryActionLabel,
    VoidCallback? onPrimaryAction,
    String? secondaryActionLabel,
    VoidCallback? onSecondaryAction,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 4),
        Text(subtitle, style: const TextStyle(color: AppColors.onSurfaceVariantDark)),
        const SizedBox(height: 14),
        ...lines.map(
          (line) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(line, style: const TextStyle(color: AppColors.onPrimary)),
          ),
        ),
        if (message != null && message.trim().isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(
            messageTitle ?? 'Message',
            style: const TextStyle(
              color: AppColors.accent,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(message, style: const TextStyle(color: AppColors.onPrimary, height: 1.45)),
        ],
        if (onPrimaryAction != null || onSecondaryAction != null) ...[
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (onPrimaryAction != null)
                OutlinedButton.icon(
                  onPressed: onPrimaryAction,
                  icon: const Icon(LucideIcons.copy, size: 16),
                  label: Text('Copy ${primaryActionLabel ?? ''}'.trim()),
                ),
              if (onSecondaryAction != null)
                OutlinedButton.icon(
                  onPressed: onSecondaryAction,
                  icon: const Icon(LucideIcons.copy, size: 16),
                  label: Text('Copy ${secondaryActionLabel ?? ''}'.trim()),
                ),
            ],
          ),
        ],
      ],
    );
  }

  void _showResponsiveDetail(String title, Widget body) {
    final isMobile = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);
    if (isMobile) {
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: AppColors.surfaceElevatedDark,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        ),
        builder: (ctx) => Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.paddingOf(ctx).bottom + 16,
          ),
          child: SingleChildScrollView(child: body),
        ),
      );
      return;
    }
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceElevatedDark,
        title: Text(title, style: const TextStyle(color: AppColors.accent)),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: SingleChildScrollView(child: body),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              AppLocalizations.of(context)!.close,
              style: const TextStyle(color: AppColors.accent),
            ),
          ),
        ],
      ),
    );
  }
}
