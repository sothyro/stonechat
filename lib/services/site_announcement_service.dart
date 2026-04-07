import 'package:cloud_functions/cloud_functions.dart';

import 'appointment_booking_service.dart' show isFirebaseEnabled;

/// Active announcement returned to visitors (public callable).
class SiteAnnouncementPayload {
  const SiteAnnouncementPayload({
    required this.title,
    required this.body,
    this.ctaLabel,
    this.ctaUrl,
    required this.revision,
  });

  final String title;
  final String body;
  final String? ctaLabel;
  final String? ctaUrl;
  final int revision;
}

/// Full document fields for Operations Hub (admin callable).
class SiteAnnouncementAdminSettings {
  const SiteAnnouncementAdminSettings({
    required this.enabled,
    required this.title,
    required this.body,
    required this.ctaLabel,
    required this.ctaUrl,
    this.startsAt,
    this.endsAt,
    required this.revision,
    this.updatedAt,
  });

  final bool enabled;
  final String title;
  final String body;
  final String ctaLabel;
  final String ctaUrl;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final int revision;
  final DateTime? updatedAt;

  factory SiteAnnouncementAdminSettings.empty() => const SiteAnnouncementAdminSettings(
        enabled: false,
        title: '',
        body: '',
        ctaLabel: '',
        ctaUrl: '',
        startsAt: null,
        endsAt: null,
        revision: 0,
        updatedAt: null,
      );

  SiteAnnouncementPayload toPreviewPayload() => SiteAnnouncementPayload(
        title: title,
        body: body,
        ctaLabel: ctaLabel.trim().isEmpty ? null : ctaLabel.trim(),
        ctaUrl: ctaUrl.trim().isEmpty ? null : ctaUrl.trim(),
        revision: revision,
      );
}

SiteAnnouncementPayload? _payloadFromMap(Map<String, dynamic>? m) {
  if (m == null) return null;
  final title = m['title'] as String? ?? '';
  final body = m['body'] as String? ?? '';
  if (title.trim().isEmpty && body.trim().isEmpty) return null;
  final rev = m['revision'];
  final revision = rev is int
      ? rev
      : rev is num
          ? rev.toInt()
          : 0;
  final ctaLabel = m['ctaLabel'] as String?;
  final ctaUrl = m['ctaUrl'] as String?;
  return SiteAnnouncementPayload(
    title: title,
    body: body,
    ctaLabel: (ctaLabel != null && ctaLabel.trim().isNotEmpty) ? ctaLabel.trim() : null,
    ctaUrl: (ctaUrl != null && ctaUrl.trim().isNotEmpty) ? ctaUrl.trim() : null,
    revision: revision,
  );
}

/// Public: active announcement only, or null.
Future<SiteAnnouncementPayload?> fetchSiteAnnouncement() async {
  if (!isFirebaseEnabled) return null;
  try {
    final result =
        await FirebaseFunctions.instance.httpsCallable('getSiteAnnouncement').call(<String, dynamic>{});
    final rawRoot = result.data;
    if (rawRoot == null) return null;
    if (rawRoot is! Map) return null;
    final data = Map<String, dynamic>.from(rawRoot);
    final raw = data['announcement'];
    if (raw == null) return null;
    return _payloadFromMap(Map<String, dynamic>.from(raw as Map));
  } on FirebaseFunctionsException {
    rethrow;
  }
}

/// Operations Hub: load editable settings.
Future<SiteAnnouncementAdminSettings> fetchSiteAnnouncementAdmin() async {
  if (!isFirebaseEnabled) {
    return SiteAnnouncementAdminSettings.empty();
  }
  try {
    final result = await FirebaseFunctions.instance
        .httpsCallable('getSiteAnnouncementAdmin')
        .call(<String, dynamic>{});
    final raw = result.data;
    if (raw == null) return SiteAnnouncementAdminSettings.empty();
    if (raw is! Map) return SiteAnnouncementAdminSettings.empty();
    final data = Map<String, dynamic>.from(raw);
    final s = data['settings'];
    if (s is! Map) return SiteAnnouncementAdminSettings.empty();
    final m = Map<String, dynamic>.from(s);
    DateTime? parseIso(String? x) => x == null || x.isEmpty ? null : DateTime.tryParse(x);

    final rev = m['revision'];
    final revision = rev is int
        ? rev
        : rev is num
            ? rev.toInt()
            : 0;

    return SiteAnnouncementAdminSettings(
      enabled: m['enabled'] == true,
      title: m['title'] as String? ?? '',
      body: m['body'] as String? ?? '',
      ctaLabel: m['ctaLabel'] as String? ?? '',
      ctaUrl: m['ctaUrl'] as String? ?? '',
      startsAt: parseIso(m['startsAt'] as String?),
      endsAt: parseIso(m['endsAt'] as String?),
      revision: revision,
      updatedAt: parseIso(m['updatedAt'] as String?),
    );
  } on FirebaseFunctionsException {
    rethrow;
  }
}

/// Save settings; returns new revision from server.
Future<int> saveSiteAnnouncementAdmin(SiteAnnouncementAdminSettings settings) async {
  if (!isFirebaseEnabled) throw Exception('Firebase is not configured.');
  try {
    final result = await FirebaseFunctions.instance.httpsCallable('setSiteAnnouncement').call(<String, dynamic>{
      'enabled': settings.enabled,
      'title': settings.title,
      'body': settings.body,
      'ctaLabel': settings.ctaLabel,
      'ctaUrl': settings.ctaUrl,
      'startsAt': settings.startsAt?.toUtc().toIso8601String(),
      'endsAt': settings.endsAt?.toUtc().toIso8601String(),
    });
    final data = result.data as Map<String, dynamic>?;
    final r = data?['revision'];
    if (r is int) return r;
    if (r is num) return r.toInt();
    throw Exception('Invalid response');
  } on FirebaseFunctionsException {
    rethrow;
  }
}
