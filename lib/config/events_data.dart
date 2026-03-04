import 'package:flutter/material.dart';

import 'app_content.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';

/// Shared event model and placeholder list for events.
class EventItem {
  const EventItem({
    required this.title,
    required this.date,
    required this.location,
    required this.description,
    this.limitedSeats = false,
    this.earlyBirdEnds,
    this.accentColor,
    this.imageAsset,
  });

  final String title;
  final String date;
  final String location;
  final String description;
  final bool limitedSeats;
  final String? earlyBirdEnds;
  /// Service accent for card (border, badge, button). When null, uses [AppColors.accent].
  final Color? accentColor;
  /// Optional card image. When null, card uses default (main or generic event image).
  final String? imageAsset;
}

/// Returns localized event list for the given localizations.
/// Each event uses a service accent color for theming.
List<EventItem> getLocalizedEvents(AppLocalizations l10n) {
  return [
    EventItem(
      title: l10n.event1Title,
      date: l10n.event1Date,
      location: l10n.event1Location,
      description: l10n.event1Description,
      limitedSeats: true,
      accentColor: AppColors.serviceCommunicationsTraining,
    ),
    EventItem(
      title: l10n.event2Title,
      date: l10n.event2Date,
      location: l10n.event2Location,
      description: l10n.event2Description,
      accentColor: AppColors.serviceAiAgent,
      imageAsset: AppContent.assetEventAEnhanced,
    ),
    EventItem(
      title: l10n.event3Title,
      date: l10n.event3Date,
      location: l10n.event3Location,
      description: l10n.event3Description,
      accentColor: AppColors.serviceBookCreation,
    ),
    EventItem(
      title: l10n.event4Title,
      date: l10n.event4Date,
      location: l10n.event4Location,
      description: l10n.event4Description,
      limitedSeats: true,
      accentColor: AppColors.serviceAppDevelopment,
    ),
  ];
}
