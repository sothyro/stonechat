import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_theme.dart';

/// Legacy route `/consultations/dashboard` redirects to the unified admin hub.
class ConsultationsDashboardRedirectScreen extends StatefulWidget {
  const ConsultationsDashboardRedirectScreen({super.key});

  @override
  State<ConsultationsDashboardRedirectScreen> createState() =>
      _ConsultationsDashboardRedirectScreenState();
}

class _ConsultationsDashboardRedirectScreenState extends State<ConsultationsDashboardRedirectScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.go('/admin?tab=appointments');
    });
  }

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.backgroundDark,
      child: Center(
        child: CircularProgressIndicator(color: AppColors.accent),
      ),
    );
  }
}
