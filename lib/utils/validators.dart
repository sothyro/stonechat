import '../l10n/app_localizations.dart';

/// Validation result with optional error message.
class ValidationResult {
  const ValidationResult({
    required this.isValid,
    this.errorMessage,
  });

  final bool isValid;
  final String? errorMessage;

  static const valid = ValidationResult(isValid: true);
}

/// Form validation utilities with localized error messages.
class Validators {
  Validators._();

  /// Validates email address format.
  static ValidationResult email(String? value, {AppLocalizations? l10n}) {
    if (value == null || value.trim().isEmpty) {
      return ValidationResult(
        isValid: false,
        errorMessage: l10n?.validationEmailRequired ?? 'Email is required',
      );
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return ValidationResult(
        isValid: false,
        errorMessage: l10n?.validationEmailInvalid ?? 'Please enter a valid email address',
      );
    }

    return ValidationResult.valid;
  }

  /// Validates phone number (supports international formats).
  static ValidationResult phone(String? value, {AppLocalizations? l10n}) {
    if (value == null || value.trim().isEmpty) {
      return ValidationResult(
        isValid: false,
        errorMessage: l10n?.validationPhoneRequired ?? 'Phone number is required',
      );
    }

    // Remove all non-digit characters for validation
    final digits = value.replaceAll(RegExp(r'[\s\-\(\)\.\+]'), '');

    // Check minimum length (at least 8 digits for most countries)
    if (digits.length < 8) {
      return ValidationResult(
        isValid: false,
        errorMessage: l10n?.validationPhoneTooShort ?? 'Phone number is too short',
      );
    }

    // Check maximum length (15 digits is E.164 max)
    if (digits.length > 15) {
      return ValidationResult(
        isValid: false,
        errorMessage: l10n?.validationPhoneTooLong ?? 'Phone number is too long',
      );
    }

    // Check if it's all digits
    if (!RegExp(r'^\d+$').hasMatch(digits)) {
      return ValidationResult(
        isValid: false,
        errorMessage: l10n?.validationPhoneInvalid ?? 'Please enter a valid phone number',
      );
    }

    return ValidationResult.valid;
  }

  /// Validates name (non-empty, reasonable length).
  static ValidationResult name(String? value, {AppLocalizations? l10n}) {
    if (value == null || value.trim().isEmpty) {
      return ValidationResult(
        isValid: false,
        errorMessage: l10n?.validationNameRequired ?? 'Name is required',
      );
    }

    final trimmed = value.trim();

    if (trimmed.length < 2) {
      return ValidationResult(
        isValid: false,
        errorMessage: l10n?.validationNameTooShort ?? 'Name must be at least 2 characters',
      );
    }

    if (trimmed.length > 100) {
      return ValidationResult(
        isValid: false,
        errorMessage: l10n?.validationNameTooLong ?? 'Name is too long',
      );
    }

    return ValidationResult.valid;
  }

  /// Validates message/description text.
  static ValidationResult message(String? value, {AppLocalizations? l10n}) {
    if (value == null || value.trim().isEmpty) {
      return ValidationResult(
        isValid: false,
        errorMessage: l10n?.validationMessageRequired ?? 'Message is required',
      );
    }

    final trimmed = value.trim();

    if (trimmed.length < 10) {
      return ValidationResult(
        isValid: false,
        errorMessage: l10n?.validationMessageTooShort ?? 'Message must be at least 10 characters',
      );
    }

    if (trimmed.length > 2000) {
      return ValidationResult(
        isValid: false,
        errorMessage: l10n?.validationMessageTooLong ?? 'Message is too long (maximum 2000 characters)',
      );
    }

    return ValidationResult.valid;
  }
}
