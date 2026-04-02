import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';

import 'error_service.dart';

/// Result of subscribing an email.
class SubscriptionResult {
  const SubscriptionResult({
    required this.success,
    this.alreadySubscribed,
    this.error,
  });

  final bool success;
  final bool? alreadySubscribed;
  final AppError? error;
}

bool get _isFirebaseEnabled {
  try {
    return Firebase.apps.isNotEmpty;
  } catch (_) {
    return false;
  }
}

/// Subscribes an email address via the `subscribeEmail` callable.
///
/// Backend responsibility:
/// - validate email
/// - deduplicate / store subscriber
/// - send immediate confirmation email
Future<SubscriptionResult> subscribeEmail({
  required String email,
}) async {
  if (!_isFirebaseEnabled) {
    return SubscriptionResult(
      success: false,
      error: const AppError(
        category: ErrorCategory.server,
        userMessage: 'Subscription is not available. Please try again later.',
        retryable: false,
      ),
    );
  }

  try {
    final trimmed = email.trim();
    final result = await FirebaseFunctions.instance
        .httpsCallable('subscribeEmail')
        .call(<String, dynamic>{'email': trimmed});

    final data = result.data as Map<dynamic, dynamic>?;
    final success = data?['success'] == true;
    final alreadySubscribed = data?['alreadySubscribed'] == true;

    if (!success) {
      return SubscriptionResult(
        success: false,
        alreadySubscribed: alreadySubscribed,
        error: AppError(
          category: ErrorCategory.server,
          userMessage: 'Subscription failed. Please try again.',
          retryable: true,
        ),
      );
    }

    return SubscriptionResult(
      success: true,
      alreadySubscribed: alreadySubscribed,
    );
  } catch (e) {
    return SubscriptionResult(
      success: false,
      error: AppError.fromException(e, logError: false),
    );
  }
}

