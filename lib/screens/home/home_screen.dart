import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'widgets/hero_section.dart';
import 'widgets/services_section.dart';
import 'widgets/events_section.dart';
import 'widgets/academies_section.dart';
import 'widgets/consultations_section.dart';
import 'widgets/story_section.dart';
import 'widgets/testimonials_section.dart';
import 'widgets/cta_section.dart';

/// Placeholder heights so scroll extent is correct before below-the-fold sections build.
const double _placeholderServices = 720;
const double _placeholderEvents = 520;
const double _placeholderAcademies = 820;
const double _placeholderConsultations = 520;
const double _placeholderStory = 580;
const double _placeholderTestimonials = 480;
const double _placeholderCta = 360;

/// Number of below-the-fold sections (Services, Events, Academies, …, CTA).
const int _kBelowFoldSectionCount = 7;

/// Builds all sections immediately after first frame to minimize perceived startup delay.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _visibleSectionCount = _kBelowFoldSectionCount;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (kDebugMode || kProfileMode) {
        debugPrint('STARTUP[home_first_frame]: ${DateTime.now().toIso8601String()}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const RepaintBoundary(child: HeroSection()),
        RepaintBoundary(
          child: _visibleSectionCount > 0
              ? const ServicesSection()
              : const SizedBox(height: _placeholderServices),
        ),
        RepaintBoundary(
          child: _visibleSectionCount > 1
              ? const EventsSection()
              : const SizedBox(height: _placeholderEvents),
        ),
        RepaintBoundary(
          child: _visibleSectionCount > 2
              ? const AcademiesSection()
              : const SizedBox(height: _placeholderAcademies),
        ),
        RepaintBoundary(
          child: _visibleSectionCount > 3
              ? const ConsultationsSection()
              : const SizedBox(height: _placeholderConsultations),
        ),
        RepaintBoundary(
          child: _visibleSectionCount > 4
              ? const StorySection()
              : const SizedBox(height: _placeholderStory),
        ),
        RepaintBoundary(
          child: _visibleSectionCount > 5
              ? const TestimonialsSection()
              : const SizedBox(height: _placeholderTestimonials),
        ),
        RepaintBoundary(
          child: _visibleSectionCount > 6
              ? const CtaSection()
              : const SizedBox(height: _placeholderCta),
        ),
      ],
    );
  }
}
