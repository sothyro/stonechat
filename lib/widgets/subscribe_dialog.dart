import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../config/app_content.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../utils/breakpoints.dart';
import '../utils/launcher_utils.dart';
import 'glass_container.dart';
import '../services/subscription_service.dart';
import '../services/error_service.dart' show ErrorCategory;

/// Subscribe dialog: email sign-up and optional "Join on Telegram" CTA.
/// Replaces the previous zodiac/forecast CTA dialog for an intuitive subscribe flow.
class SubscribeDialog extends StatefulWidget {
  const SubscribeDialog({super.key});

  @override
  State<SubscribeDialog> createState() => _SubscribeDialogState();
}

class _SubscribeDialogState extends State<SubscribeDialog> {
  final _emailController = TextEditingController();
  final _emailFocus = FocusNode();
  bool _submitted = false;
  bool _submitting = false;
  String? _errorText;

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  bool get _isValidEmail {
    final email = _emailController.text.trim();
    if (email.isEmpty) return false;
    final pattern = RegExp(r'^[\w\-\.]+@([\w-]+\.)+[\w-]{2,}$');
    return pattern.hasMatch(email);
  }

  Future<void> _onSubscribe() async {
    if (_submitting) return;
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _errorText = null);
      _emailFocus.requestFocus();
      return;
    }
    if (!_isValidEmail) {
      setState(() => _errorText = AppLocalizations.of(context)!.validationEmailInvalid);
      _emailFocus.requestFocus();
      return;
    }
    setState(() {
      _errorText = null;
      _submitting = true;
    });

    try {
      final l10n = AppLocalizations.of(context)!;
      final result = await subscribeEmail(email: email);
      if (!mounted) return;

      setState(() => _submitting = false);
      if (result.success) {
        setState(() => _submitted = true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.subscribeSuccess),
            backgroundColor: AppColors.accent,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.of(context).pop();
        return;
      }

      final err = result.error;
      final errText = err?.category == ErrorCategory.validation
          ? err?.userMessage
          : null;
      if (errText != null) {
        setState(() => _errorText = errText);
        _emailFocus.requestFocus();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(err?.userMessage ?? l10n.contactError),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.contactError),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _onJoinTelegram() {
    launchUrlExternal(AppContent.telegramGroupUrl);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isMobile = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);
    final padding = MediaQuery.paddingOf(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 24,
        vertical: 24 + padding.top,
      ),
      child: GlassContainer(
        blurSigma: 12,
        color: AppColors.overlayDark.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight, width: 1.2),
        boxShadow: AppShadows.dialog,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Close button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: kMinTouchTargetSize, height: kMinTouchTargetSize),
                      IconButton(
                        icon: const Icon(LucideIcons.x, size: 22, color: AppColors.onPrimary),
                        onPressed: () => Navigator.of(context).pop(),
                        tooltip: l10n.close,
                        style: IconButton.styleFrom(
                          padding: const EdgeInsets.all(4),
                          minimumSize: const Size(kMinTouchTargetSize, kMinTouchTargetSize),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Brand + title
                  Text(
                    l10n.popupTitle1,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.popupTitle2,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.popupDescription,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.onPrimary.withValues(alpha: 0.85),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l10n.popupFormPrompt,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.onPrimary.withValues(alpha: 0.75),
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Email field
                  TextField(
                    controller: _emailController,
                    focusNode: _emailFocus,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) {
                      _onSubscribe();
                    },
                    onChanged: (_) => setState(() => _errorText = null),
                    decoration: InputDecoration(
                      hintText: l10n.subscribeEmailHint,
                      errorText: _errorText,
                      filled: true,
                      fillColor: AppColors.surfaceElevatedDark,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.borderDark),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.borderDark),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.error),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    style: TextStyle(
                      color: AppColors.onPrimary,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Subscribe button
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: AppShadows.accentButton,
                    ),
                    child: FilledButton(
                      onPressed: (_submitted || _submitting)
                          ? null
                          : () {
                              _onSubscribe();
                            },
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: AppColors.onAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        l10n.subscribeButton,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Divider with "or"
                  Row(
                    children: [
                      Expanded(child: Divider(color: AppColors.borderDark)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          l10n.subscribeOr,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.onPrimary.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: AppColors.borderDark)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Join Telegram
                  OutlinedButton.icon(
                    onPressed: _onJoinTelegram,
                    icon: const Icon(LucideIcons.send, size: 18, color: AppColors.accent),
                    label: Text(l10n.subscribeJoinTelegram),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.accent,
                      side: const BorderSide(color: AppColors.accent),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
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
