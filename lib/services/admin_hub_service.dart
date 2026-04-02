import 'package:cloud_functions/cloud_functions.dart';

import 'appointment_booking_service.dart' show isFirebaseEnabled;

/// One row from `email_subscriptions` (admin list).
class EmailSubscriberRecord {
  const EmailSubscriberRecord({
    required this.id,
    required this.email,
    required this.status,
    this.createdAtIso,
    this.lastConfirmedAtIso,
  });

  final String id;
  final String email;
  final String status;
  final String? createdAtIso;
  final String? lastConfirmedAtIso;

  factory EmailSubscriberRecord.fromMap(String id, Map<String, dynamic> m) {
    return EmailSubscriberRecord(
      id: id,
      email: m['email'] as String? ?? '',
      status: m['status'] as String? ?? '',
      createdAtIso: m['createdAt'] as String?,
      lastConfirmedAtIso: m['lastConfirmedAt'] as String?,
    );
  }
}

/// One row from `contact_submissions` (admin list).
class ContactSubmissionRecord {
  const ContactSubmissionRecord({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.subjectLabel,
    required this.message,
    required this.status,
    this.createdAtIso,
  });

  final String id;
  final String name;
  final String email;
  final String phone;
  final String subjectLabel;
  final String message;
  final String status;
  final String? createdAtIso;

  factory ContactSubmissionRecord.fromMap(String id, Map<String, dynamic> m) {
    return ContactSubmissionRecord(
      id: id,
      name: m['name'] as String? ?? '',
      email: m['email'] as String? ?? '',
      phone: m['phone'] as String? ?? '',
      subjectLabel: m['subjectLabel'] as String? ?? '',
      message: m['message'] as String? ?? '',
      status: m['status'] as String? ?? 'new',
      createdAtIso: m['createdAt'] as String?,
    );
  }
}

Future<List<EmailSubscriberRecord>> listEmailSubscribers({int limit = 500}) async {
  if (!isFirebaseEnabled) return [];
  try {
    final result = await FirebaseFunctions.instance
        .httpsCallable('listEmailSubscribers')
        .call(<String, dynamic>{'limit': limit});
    final data = result.data as Map<String, dynamic>?;
    final list = data?['subscribers'] as List<dynamic>?;
    if (list == null) return [];
    return list.asMap().entries.map((e) {
      final m = Map<String, dynamic>.from(e.value as Map);
      final id = m['id'] as String? ?? '${e.key}';
      return EmailSubscriberRecord.fromMap(id, m);
    }).toList();
  } on FirebaseFunctionsException catch (e) {
    final msg = (e.message != null && e.message!.isNotEmpty) ? e.message! : e.code;
    throw Exception(msg);
  }
}

Future<List<ContactSubmissionRecord>> listContactSubmissions({int limit = 200}) async {
  if (!isFirebaseEnabled) return [];
  try {
    final result = await FirebaseFunctions.instance
        .httpsCallable('listContactSubmissions')
        .call(<String, dynamic>{'limit': limit});
    final data = result.data as Map<String, dynamic>?;
    final list = data?['submissions'] as List<dynamic>?;
    if (list == null) return [];
    return list.asMap().entries.map((e) {
      final m = Map<String, dynamic>.from(e.value as Map);
      final id = m['id'] as String? ?? '${e.key}';
      return ContactSubmissionRecord.fromMap(id, m);
    }).toList();
  } on FirebaseFunctionsException catch (e) {
    final msg = (e.message != null && e.message!.isNotEmpty) ? e.message! : e.code;
    throw Exception(msg);
  }
}
