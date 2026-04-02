import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_km.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('km'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Stonechat Communications'**
  String get appTitle;

  /// No description provided for @skipToContent.
  ///
  /// In en, this message translates to:
  /// **'Skip to content'**
  String get skipToContent;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @learning.
  ///
  /// In en, this message translates to:
  /// **'Learning'**
  String get learning;

  /// No description provided for @charteredPractitioner.
  ///
  /// In en, this message translates to:
  /// **'Learning & Practice'**
  String get charteredPractitioner;

  /// No description provided for @training.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get training;

  /// No description provided for @courses.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get courses;

  /// No description provided for @ourStory.
  ///
  /// In en, this message translates to:
  /// **'Our Story'**
  String get ourStory;

  /// No description provided for @onTheNews.
  ///
  /// In en, this message translates to:
  /// **'On the news'**
  String get onTheNews;

  /// No description provided for @publications.
  ///
  /// In en, this message translates to:
  /// **'Publications'**
  String get publications;

  /// No description provided for @resources.
  ///
  /// In en, this message translates to:
  /// **'Resources'**
  String get resources;

  /// No description provided for @appsAndStore.
  ///
  /// In en, this message translates to:
  /// **'Apps & Store'**
  String get appsAndStore;

  /// No description provided for @appsNav.
  ///
  /// In en, this message translates to:
  /// **'Apps'**
  String get appsNav;

  /// No description provided for @bookNav.
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get bookNav;

  /// No description provided for @stonechatSystem.
  ///
  /// In en, this message translates to:
  /// **'Apps & Digital'**
  String get stonechatSystem;

  /// No description provided for @period9MobileApp.
  ///
  /// In en, this message translates to:
  /// **'Clinic App'**
  String get period9MobileApp;

  /// No description provided for @talismanStore.
  ///
  /// In en, this message translates to:
  /// **'Book Store'**
  String get talismanStore;

  /// No description provided for @appsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Apps & Store'**
  String get appsPageTitle;

  /// No description provided for @appsPageOverline.
  ///
  /// In en, this message translates to:
  /// **'Apps'**
  String get appsPageOverline;

  /// No description provided for @appsPageSubline.
  ///
  /// In en, this message translates to:
  /// **'App Development, Responsive Web, AI Agent, Book Creation, Communications Training, and Custom Project—all in one place.'**
  String get appsPageSubline;

  /// No description provided for @appsPageDescription.
  ///
  /// In en, this message translates to:
  /// **'Stonechat offers six core services: App Development, Responsive Web, AI Agent, Book Creation Suite, Communications Training, and Custom Project. Find the right fit and get in touch.'**
  String get appsPageDescription;

  /// No description provided for @appsPageDescriptionHighlight.
  ///
  /// In en, this message translates to:
  /// **'six core services'**
  String get appsPageDescriptionHighlight;

  /// No description provided for @appsFeatureShowcaseHeading.
  ///
  /// In en, this message translates to:
  /// **'What we offer'**
  String get appsFeatureShowcaseHeading;

  /// No description provided for @appsFeatureShowcaseOverline.
  ///
  /// In en, this message translates to:
  /// **'Marketplace'**
  String get appsFeatureShowcaseOverline;

  /// No description provided for @appsFeatureShowcaseMarketingDesc.
  ///
  /// In en, this message translates to:
  /// **'Our six services—App Development, Responsive Web, AI Agent, Book Creation, Communications Training, and Custom Project—keep everything clear and intuitive. One partner for your goals.'**
  String get appsFeatureShowcaseMarketingDesc;

  /// No description provided for @appsFeatureShowcaseMarketingHighlight.
  ///
  /// In en, this message translates to:
  /// **'six services'**
  String get appsFeatureShowcaseMarketingHighlight;

  /// No description provided for @marketplaceCategoryDigital.
  ///
  /// In en, this message translates to:
  /// **'Digital'**
  String get marketplaceCategoryDigital;

  /// No description provided for @marketplaceCategoryBooks.
  ///
  /// In en, this message translates to:
  /// **'Books'**
  String get marketplaceCategoryBooks;

  /// No description provided for @marketplaceCategoryTalismans.
  ///
  /// In en, this message translates to:
  /// **'Book Store'**
  String get marketplaceCategoryTalismans;

  /// No description provided for @stonechatSpotlightTitle.
  ///
  /// In en, this message translates to:
  /// **'App Development & Responsive Web'**
  String get stonechatSpotlightTitle;

  /// No description provided for @stonechatSpotlightDesc.
  ///
  /// In en, this message translates to:
  /// **'We build modern apps for Web, Desktop, iOS, and Android and design responsive websites. Clean code, clear interfaces—quality without breaking the bank.'**
  String get stonechatSpotlightDesc;

  /// No description provided for @openStonechatCta.
  ///
  /// In en, this message translates to:
  /// **'Get a quote'**
  String get openStonechatCta;

  /// No description provided for @spotlightSubscribe.
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get spotlightSubscribe;

  /// No description provided for @spotlightSubscriptionPrice.
  ///
  /// In en, this message translates to:
  /// **'9.99'**
  String get spotlightSubscriptionPrice;

  /// No description provided for @spotlightPricePerMonth.
  ///
  /// In en, this message translates to:
  /// **'/ month'**
  String get spotlightPricePerMonth;

  /// No description provided for @period9PriceFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get period9PriceFree;

  /// No description provided for @period9PremiumLabel.
  ///
  /// In en, this message translates to:
  /// **'Premium subscription available'**
  String get period9PremiumLabel;

  /// No description provided for @period9SpotlightTitle.
  ///
  /// In en, this message translates to:
  /// **'Caishen Clinic App'**
  String get period9SpotlightTitle;

  /// No description provided for @period9SpotlightDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage appointments, patients, and records on the go. Built for clinics and small practices. Available on iOS and Android.'**
  String get period9SpotlightDesc;

  /// No description provided for @period9FeatureAppointments.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get period9FeatureAppointments;

  /// No description provided for @period9FeaturePatients.
  ///
  /// In en, this message translates to:
  /// **'Patients'**
  String get period9FeaturePatients;

  /// No description provided for @period9FeatureRecords.
  ///
  /// In en, this message translates to:
  /// **'Records'**
  String get period9FeatureRecords;

  /// No description provided for @period9Platforms.
  ///
  /// In en, this message translates to:
  /// **'iOS & Android'**
  String get period9Platforms;

  /// No description provided for @downloadOnAppStore.
  ///
  /// In en, this message translates to:
  /// **'Download on the App Store'**
  String get downloadOnAppStore;

  /// No description provided for @getItOnGooglePlay.
  ///
  /// In en, this message translates to:
  /// **'Get it on Google Play'**
  String get getItOnGooglePlay;

  /// No description provided for @talismanStoreSpotlightTitle.
  ///
  /// In en, this message translates to:
  /// **'Book Store'**
  String get talismanStoreSpotlightTitle;

  /// No description provided for @talismanStoreSpotlightDesc.
  ///
  /// In en, this message translates to:
  /// **'Curated books on communication, leadership, and professional development. Add to cart and we\'ll contact you to complete your order.'**
  String get talismanStoreSpotlightDesc;

  /// No description provided for @marketplaceAddedToCart.
  ///
  /// In en, this message translates to:
  /// **'Added to cart. We\'ll contact you to complete your order.'**
  String get marketplaceAddedToCart;

  /// No description provided for @talismanProductPrice.
  ///
  /// In en, this message translates to:
  /// **'29.99'**
  String get talismanProductPrice;

  /// No description provided for @talismanProduct1Title.
  ///
  /// In en, this message translates to:
  /// **'Chapter 1 - Branding & Communication Strategy'**
  String get talismanProduct1Title;

  /// No description provided for @talismanProduct2Title.
  ///
  /// In en, this message translates to:
  /// **'Chapter 2 - Digital Communications Platform Design'**
  String get talismanProduct2Title;

  /// No description provided for @talismanProduct3Title.
  ///
  /// In en, this message translates to:
  /// **'Chapter 3 - Engaging Your Audiences Online'**
  String get talismanProduct3Title;

  /// No description provided for @talismanProduct4Title.
  ///
  /// In en, this message translates to:
  /// **'Chapter 4 - Speech Writing & Presentations'**
  String get talismanProduct4Title;

  /// No description provided for @talismanProduct5Title.
  ///
  /// In en, this message translates to:
  /// **'Chapter 5 - Liaising With The Media'**
  String get talismanProduct5Title;

  /// No description provided for @talismanProduct6Title.
  ///
  /// In en, this message translates to:
  /// **'Chapter 6 - Effective Communications'**
  String get talismanProduct6Title;

  /// No description provided for @talismanProduct7Title.
  ///
  /// In en, this message translates to:
  /// **'Chapter 7 - Embracing Soft Power'**
  String get talismanProduct7Title;

  /// No description provided for @talismanProduct8Title.
  ///
  /// In en, this message translates to:
  /// **'Chapter 8 - Crisis Management & Communications'**
  String get talismanProduct8Title;

  /// No description provided for @talismanProduct9Title.
  ///
  /// In en, this message translates to:
  /// **'Chapter 9 - Communications for Organisational Change'**
  String get talismanProduct9Title;

  /// No description provided for @caishenClinicSectionHeading.
  ///
  /// In en, this message translates to:
  /// **'Featuring the Caishen Clinic Management System'**
  String get caishenClinicSectionHeading;

  /// No description provided for @caishenClinicSectionTagline.
  ///
  /// In en, this message translates to:
  /// **'One platform to run your clinic. Appointments, patients, and records—all in one place.'**
  String get caishenClinicSectionTagline;

  /// No description provided for @caishenClinicSectionTaglineHighlight.
  ///
  /// In en, this message translates to:
  /// **'all in one place'**
  String get caishenClinicSectionTaglineHighlight;

  /// No description provided for @caishenClinicSectionBody.
  ///
  /// In en, this message translates to:
  /// **'Built for modern practices. Streamline scheduling, secure patient data, and grow your practice with a system that scales with you.'**
  String get caishenClinicSectionBody;

  /// No description provided for @caishenClinicSectionBodyHighlight.
  ///
  /// In en, this message translates to:
  /// **'scales with you'**
  String get caishenClinicSectionBodyHighlight;

  /// No description provided for @caishenClinicFeature1Title.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get caishenClinicFeature1Title;

  /// No description provided for @caishenClinicFeature2Title.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get caishenClinicFeature2Title;

  /// No description provided for @caishenClinicFeature3Title.
  ///
  /// In en, this message translates to:
  /// **'Patient records'**
  String get caishenClinicFeature3Title;

  /// No description provided for @caishenClinicFeature4Title.
  ///
  /// In en, this message translates to:
  /// **'Scheduling'**
  String get caishenClinicFeature4Title;

  /// No description provided for @caishenClinicFeature5Title.
  ///
  /// In en, this message translates to:
  /// **'Clinical workflow'**
  String get caishenClinicFeature5Title;

  /// No description provided for @caishenClinicFeature6Title.
  ///
  /// In en, this message translates to:
  /// **'Reports & analytics'**
  String get caishenClinicFeature6Title;

  /// No description provided for @caishenClinicFeature7Title.
  ///
  /// In en, this message translates to:
  /// **'Billing & payments'**
  String get caishenClinicFeature7Title;

  /// No description provided for @caishenClinicFeature8Title.
  ///
  /// In en, this message translates to:
  /// **'Staff & roles'**
  String get caishenClinicFeature8Title;

  /// No description provided for @caishenClinicFeature9Title.
  ///
  /// In en, this message translates to:
  /// **'Settings & integration'**
  String get caishenClinicFeature9Title;

  /// No description provided for @featuredAppsSectionOverline.
  ///
  /// In en, this message translates to:
  /// **'Featured Mobile Apps'**
  String get featuredAppsSectionOverline;

  /// No description provided for @featuredAppsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'From idea to finished app. In one place.'**
  String get featuredAppsSectionTitle;

  /// No description provided for @featuredAppsSectionSubline.
  ///
  /// In en, this message translates to:
  /// **'From Feng Shui to Khmer AI—discover what we\'ve shipped.'**
  String get featuredAppsSectionSubline;

  /// No description provided for @featuredAppsSectionBody.
  ///
  /// In en, this message translates to:
  /// **'Stonechat builds and publishes mobile apps for iOS and Android. Period 9 Feng Shui Guide and Stonechat Khmer AI are available on the App Store and Google Play.'**
  String get featuredAppsSectionBody;

  /// No description provided for @masterElfSectionOverline.
  ///
  /// In en, this message translates to:
  /// **'Featured Web App'**
  String get masterElfSectionOverline;

  /// No description provided for @masterElfSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Master Elf Feng Shui App'**
  String get masterElfSectionTitle;

  /// No description provided for @masterElfSectionTagline.
  ///
  /// In en, this message translates to:
  /// **'The most beautiful and intuitive web app for the Master Elf Feng Shui company.'**
  String get masterElfSectionTagline;

  /// No description provided for @masterElfSectionTaglineHighlight.
  ///
  /// In en, this message translates to:
  /// **'beautiful and intuitive'**
  String get masterElfSectionTaglineHighlight;

  /// No description provided for @masterElfHeroHeadline.
  ///
  /// In en, this message translates to:
  /// **'Transform your Feng Shui practice. One app, three languages, endless possibilities.'**
  String get masterElfHeroHeadline;

  /// No description provided for @masterElfHeroHeadlineHighlight.
  ///
  /// In en, this message translates to:
  /// **'Transform'**
  String get masterElfHeroHeadlineHighlight;

  /// No description provided for @masterElfValueProp.
  ///
  /// In en, this message translates to:
  /// **'Book consultations, share your story, manage subscriptions, and connect with clients—all in one place. Built for practitioners who demand excellence.'**
  String get masterElfValueProp;

  /// No description provided for @masterElfCtaPrimary.
  ///
  /// In en, this message translates to:
  /// **'Explore the app'**
  String get masterElfCtaPrimary;

  /// No description provided for @masterElfCtaSecondary.
  ///
  /// In en, this message translates to:
  /// **'Request a demo'**
  String get masterElfCtaSecondary;

  /// No description provided for @masterElfLanguagesLabel.
  ///
  /// In en, this message translates to:
  /// **'Available in 3 languages'**
  String get masterElfLanguagesLabel;

  /// No description provided for @masterElfLanguageKhmer.
  ///
  /// In en, this message translates to:
  /// **'Khmer'**
  String get masterElfLanguageKhmer;

  /// No description provided for @masterElfLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get masterElfLanguageEnglish;

  /// No description provided for @masterElfLanguageChinese.
  ///
  /// In en, this message translates to:
  /// **'Chinese'**
  String get masterElfLanguageChinese;

  /// No description provided for @masterElfFeatureBooking.
  ///
  /// In en, this message translates to:
  /// **'Booking'**
  String get masterElfFeatureBooking;

  /// No description provided for @masterElfFeatureBookingDesc.
  ///
  /// In en, this message translates to:
  /// **'Let clients book consultations in seconds. Smart scheduling, reminders, and seamless confirmations.'**
  String get masterElfFeatureBookingDesc;

  /// No description provided for @masterElfFeatureStory.
  ///
  /// In en, this message translates to:
  /// **'Story'**
  String get masterElfFeatureStory;

  /// No description provided for @masterElfFeatureStoryDesc.
  ///
  /// In en, this message translates to:
  /// **'Share your journey and expertise. Build trust and reach new audiences with your story.'**
  String get masterElfFeatureStoryDesc;

  /// No description provided for @masterElfFeatureSubscriptions.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions & Purchase'**
  String get masterElfFeatureSubscriptions;

  /// No description provided for @masterElfFeatureSubscriptionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Recurring revenue made simple. Subscriptions and one-time purchases in one integrated store.'**
  String get masterElfFeatureSubscriptionsDesc;

  /// No description provided for @masterElfFeatureContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get masterElfFeatureContact;

  /// No description provided for @masterElfFeatureContactDesc.
  ///
  /// In en, this message translates to:
  /// **'Stay connected. Direct messaging and contact forms that keep you in touch with your community.'**
  String get masterElfFeatureContactDesc;

  /// No description provided for @masterElfFeaturesHeading.
  ///
  /// In en, this message translates to:
  /// **'Everything you need to grow'**
  String get masterElfFeaturesHeading;

  /// No description provided for @n22SectionOverline.
  ///
  /// In en, this message translates to:
  /// **'Operations Platform'**
  String get n22SectionOverline;

  /// No description provided for @n22SectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Caishen Clinic Business Suite'**
  String get n22SectionTitle;

  /// No description provided for @n22SectionTagline.
  ///
  /// In en, this message translates to:
  /// **'Run your business from anywhere. Dashboard, POS, calendar, and reports—desktop and mobile in one system.'**
  String get n22SectionTagline;

  /// No description provided for @n22SectionTaglineHighlight.
  ///
  /// In en, this message translates to:
  /// **'from anywhere'**
  String get n22SectionTaglineHighlight;

  /// No description provided for @n22HeroHeadline.
  ///
  /// In en, this message translates to:
  /// **'One platform. Every device. Real-time control.'**
  String get n22HeroHeadline;

  /// No description provided for @n22HeroHeadlineHighlight.
  ///
  /// In en, this message translates to:
  /// **'Real-time control'**
  String get n22HeroHeadlineHighlight;

  /// No description provided for @n22ValueProp.
  ///
  /// In en, this message translates to:
  /// **'Manage operations, process sales, schedule appointments, and track performance—all in sync. Built for teams that move fast.'**
  String get n22ValueProp;

  /// No description provided for @n22CtaPrimary.
  ///
  /// In en, this message translates to:
  /// **'See it in action'**
  String get n22CtaPrimary;

  /// No description provided for @n22CtaSecondary.
  ///
  /// In en, this message translates to:
  /// **'Get a demo'**
  String get n22CtaSecondary;

  /// No description provided for @n22DesktopLabel.
  ///
  /// In en, this message translates to:
  /// **'Desktop experience'**
  String get n22DesktopLabel;

  /// No description provided for @n22MobileLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobile experience'**
  String get n22MobileLabel;

  /// No description provided for @n22FeatureDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get n22FeatureDashboard;

  /// No description provided for @n22FeatureDashboardDesc.
  ///
  /// In en, this message translates to:
  /// **'At-a-glance overview. KPIs, charts, and alerts in one view.'**
  String get n22FeatureDashboardDesc;

  /// No description provided for @n22FeatureCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get n22FeatureCalendar;

  /// No description provided for @n22FeatureCalendarDesc.
  ///
  /// In en, this message translates to:
  /// **'Schedule and sync across devices. Never miss an appointment.'**
  String get n22FeatureCalendarDesc;

  /// No description provided for @n22FeaturePos.
  ///
  /// In en, this message translates to:
  /// **'Point of Sale'**
  String get n22FeaturePos;

  /// No description provided for @n22FeaturePosDesc.
  ///
  /// In en, this message translates to:
  /// **'Process transactions fast. Desktop and mobile POS ready.'**
  String get n22FeaturePosDesc;

  /// No description provided for @n22FeatureReports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get n22FeatureReports;

  /// No description provided for @n22FeatureReportsDesc.
  ///
  /// In en, this message translates to:
  /// **'Insights that drive decisions. Export and share anytime.'**
  String get n22FeatureReportsDesc;

  /// No description provided for @n22FeatureLogin.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get n22FeatureLogin;

  /// No description provided for @n22FeatureLoginDesc.
  ///
  /// In en, this message translates to:
  /// **'Secure access. Role-based permissions for your team.'**
  String get n22FeatureLoginDesc;

  /// No description provided for @n22FeatureProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get n22FeatureProfile;

  /// No description provided for @n22FeatureProfileDesc.
  ///
  /// In en, this message translates to:
  /// **'Your profile, your way. Manage settings and preferences.'**
  String get n22FeatureProfileDesc;

  /// No description provided for @featuredApp1Title.
  ///
  /// In en, this message translates to:
  /// **'Period 9 Feng Shui Guide'**
  String get featuredApp1Title;

  /// No description provided for @featuredApp1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Feng Shui for 2024–2043. iOS & Android.'**
  String get featuredApp1Subtitle;

  /// No description provided for @featuredApp2Title.
  ///
  /// In en, this message translates to:
  /// **'Stonechat Khmer AI'**
  String get featuredApp2Title;

  /// No description provided for @featuredApp2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'AI-powered Khmer language & communication.'**
  String get featuredApp2Subtitle;

  /// No description provided for @stonechatSpotlightTagline.
  ///
  /// In en, this message translates to:
  /// **'Quality without the high price.'**
  String get stonechatSpotlightTagline;

  /// No description provided for @stonechatSpotlightTaglineHighlight.
  ///
  /// In en, this message translates to:
  /// **'Quality'**
  String get stonechatSpotlightTaglineHighlight;

  /// No description provided for @period9SpotlightTagline.
  ///
  /// In en, this message translates to:
  /// **'Your clinic in your pocket.'**
  String get period9SpotlightTagline;

  /// No description provided for @period9SpotlightTaglineHighlight.
  ///
  /// In en, this message translates to:
  /// **'pocket'**
  String get period9SpotlightTaglineHighlight;

  /// No description provided for @talismanStoreSpotlightTagline.
  ///
  /// In en, this message translates to:
  /// **'Knowledge that fits your shelf.'**
  String get talismanStoreSpotlightTagline;

  /// No description provided for @talismanStoreSpotlightTaglineHighlight.
  ///
  /// In en, this message translates to:
  /// **'shelf'**
  String get talismanStoreSpotlightTaglineHighlight;

  /// No description provided for @bookStoreSectionHeading.
  ///
  /// In en, this message translates to:
  /// **'Book Creation Suite'**
  String get bookStoreSectionHeading;

  /// No description provided for @bookStoreSectionOverline.
  ///
  /// In en, this message translates to:
  /// **'Book Store'**
  String get bookStoreSectionOverline;

  /// No description provided for @bookStoreSectionTagline.
  ///
  /// In en, this message translates to:
  /// **'From idea to finished book. In one place.'**
  String get bookStoreSectionTagline;

  /// No description provided for @bookStoreSectionTaglineHighlight.
  ///
  /// In en, this message translates to:
  /// **'one place'**
  String get bookStoreSectionTaglineHighlight;

  /// No description provided for @bookStoreSectionMarketing.
  ///
  /// In en, this message translates to:
  /// **'Book Creation Suite is one of our six core services. We support authors and organizations from concept to writing, editing, design, and publishing. Everything you need to go from idea to published book.'**
  String get bookStoreSectionMarketing;

  /// No description provided for @bookStoreSectionMarketingHighlight.
  ///
  /// In en, this message translates to:
  /// **'Book Creation Suite'**
  String get bookStoreSectionMarketingHighlight;

  /// No description provided for @bookStoreBook1Title.
  ///
  /// In en, this message translates to:
  /// **'From Idea to Finished Book'**
  String get bookStoreBook1Title;

  /// No description provided for @bookStoreBook1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Writing, editing & publishing'**
  String get bookStoreBook1Subtitle;

  /// No description provided for @bookStoreBook1Price.
  ///
  /// In en, this message translates to:
  /// **'24.99'**
  String get bookStoreBook1Price;

  /// No description provided for @bookStoreBook2Title.
  ///
  /// In en, this message translates to:
  /// **'Clear Communication at Work'**
  String get bookStoreBook2Title;

  /// No description provided for @bookStoreBook2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Practical skills for teams'**
  String get bookStoreBook2Subtitle;

  /// No description provided for @bookStoreBook2Price.
  ///
  /// In en, this message translates to:
  /// **'24.99'**
  String get bookStoreBook2Price;

  /// No description provided for @bookStoreBook3Title.
  ///
  /// In en, this message translates to:
  /// **'The Art of Persuasion (English)'**
  String get bookStoreBook3Title;

  /// No description provided for @bookStoreBook3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Persuasion & influence'**
  String get bookStoreBook3Subtitle;

  /// No description provided for @bookStoreBook3Price.
  ///
  /// In en, this message translates to:
  /// **'24.99'**
  String get bookStoreBook3Price;

  /// No description provided for @bookStoreBook4Title.
  ///
  /// In en, this message translates to:
  /// **'The Art of Persuasion (Khmer)'**
  String get bookStoreBook4Title;

  /// No description provided for @bookStoreBook4Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Persuasion & influence'**
  String get bookStoreBook4Subtitle;

  /// No description provided for @bookStoreBook4Price.
  ///
  /// In en, this message translates to:
  /// **'24.99'**
  String get bookStoreBook4Price;

  /// No description provided for @bookStorePricePrefix.
  ///
  /// In en, this message translates to:
  /// **'\$'**
  String get bookStorePricePrefix;

  /// No description provided for @bookStoreAddToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get bookStoreAddToCart;

  /// No description provided for @bookStoreAddedToCart.
  ///
  /// In en, this message translates to:
  /// **'Added to cart. We\'ll contact you to complete your order.'**
  String get bookStoreAddedToCart;

  /// No description provided for @bookStoreBestsellerBadge.
  ///
  /// In en, this message translates to:
  /// **'Bestseller'**
  String get bookStoreBestsellerBadge;

  /// No description provided for @bookStoreNav.
  ///
  /// In en, this message translates to:
  /// **'Book Store'**
  String get bookStoreNav;

  /// No description provided for @appFeatureQiMen.
  ///
  /// In en, this message translates to:
  /// **'Qi Men Dunjia'**
  String get appFeatureQiMen;

  /// No description provided for @appFeatureBaziLife.
  ///
  /// In en, this message translates to:
  /// **'BaZi Life'**
  String get appFeatureBaziLife;

  /// No description provided for @appFeatureBaziReport.
  ///
  /// In en, this message translates to:
  /// **'BaZi Report'**
  String get appFeatureBaziReport;

  /// No description provided for @appFeatureBaziAge.
  ///
  /// In en, this message translates to:
  /// **'BaZi Age'**
  String get appFeatureBaziAge;

  /// No description provided for @appFeatureBaziStars.
  ///
  /// In en, this message translates to:
  /// **'BaZi Stars'**
  String get appFeatureBaziStars;

  /// No description provided for @appFeatureBaziKhmer.
  ///
  /// In en, this message translates to:
  /// **'BaZi Khmer'**
  String get appFeatureBaziKhmer;

  /// No description provided for @appFeatureBaziChart.
  ///
  /// In en, this message translates to:
  /// **'BaZi Chart'**
  String get appFeatureBaziChart;

  /// No description provided for @appFeatureDateSelection.
  ///
  /// In en, this message translates to:
  /// **'Date Selection'**
  String get appFeatureDateSelection;

  /// No description provided for @appFeatureMarriage.
  ///
  /// In en, this message translates to:
  /// **'Marriage'**
  String get appFeatureMarriage;

  /// No description provided for @appFeatureBusinessPartner.
  ///
  /// In en, this message translates to:
  /// **'Business Partner'**
  String get appFeatureBusinessPartner;

  /// No description provided for @appFeatureAdvancedFeatures.
  ///
  /// In en, this message translates to:
  /// **'Advanced Features'**
  String get appFeatureAdvancedFeatures;

  /// No description provided for @newsAndEvents.
  ///
  /// In en, this message translates to:
  /// **'News & Trainings'**
  String get newsAndEvents;

  /// No description provided for @mediaAndPosts.
  ///
  /// In en, this message translates to:
  /// **'News & Media'**
  String get mediaAndPosts;

  /// No description provided for @mediaPostsFacebookTitle.
  ///
  /// In en, this message translates to:
  /// **'Posts & updates'**
  String get mediaPostsFacebookTitle;

  /// No description provided for @mediaPostsFacebookBody.
  ///
  /// In en, this message translates to:
  /// **'Our latest posts, training updates and news are on our Facebook page. Follow us for updates.'**
  String get mediaPostsFacebookBody;

  /// No description provided for @mediaPostsFacebookLink.
  ///
  /// In en, this message translates to:
  /// **'facebook.com/stonechat.vip'**
  String get mediaPostsFacebookLink;

  /// No description provided for @mediaPostsTelegramTitle.
  ///
  /// In en, this message translates to:
  /// **'Telegram Group'**
  String get mediaPostsTelegramTitle;

  /// No description provided for @mediaPostsTelegramBody.
  ///
  /// In en, this message translates to:
  /// **'Join our community on Telegram for discussions and updates.'**
  String get mediaPostsTelegramBody;

  /// No description provided for @mediaPostsTelegramLink.
  ///
  /// In en, this message translates to:
  /// **'t.me/hongchhayheng'**
  String get mediaPostsTelegramLink;

  /// No description provided for @mediaPostsCoverageTitle.
  ///
  /// In en, this message translates to:
  /// **'Media coverage'**
  String get mediaPostsCoverageTitle;

  /// No description provided for @mediaPostsCoverageBody.
  ///
  /// In en, this message translates to:
  /// **'Sample links to articles and features (to be updated):'**
  String get mediaPostsCoverageBody;

  /// No description provided for @consultations.
  ///
  /// In en, this message translates to:
  /// **'Consultations'**
  String get consultations;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contactUs;

  /// No description provided for @bookConsultation.
  ///
  /// In en, this message translates to:
  /// **'Book Consultation'**
  String get bookConsultation;

  /// No description provided for @aboutStonechat.
  ///
  /// In en, this message translates to:
  /// **'About Stonechat'**
  String get aboutStonechat;

  /// No description provided for @heroStonechatCaption.
  ///
  /// In en, this message translates to:
  /// **'Stonechat'**
  String get heroStonechatCaption;

  /// No description provided for @journey.
  ///
  /// In en, this message translates to:
  /// **'Our Story'**
  String get journey;

  /// No description provided for @ourMethod.
  ///
  /// In en, this message translates to:
  /// **'What we do'**
  String get ourMethod;

  /// No description provided for @events.
  ///
  /// In en, this message translates to:
  /// **'Trainings'**
  String get events;

  /// No description provided for @eventsCalendar.
  ///
  /// In en, this message translates to:
  /// **'Training Calendar'**
  String get eventsCalendar;

  /// No description provided for @blog.
  ///
  /// In en, this message translates to:
  /// **'Blog'**
  String get blog;

  /// No description provided for @media.
  ///
  /// In en, this message translates to:
  /// **'Media'**
  String get media;

  /// No description provided for @quickLinks.
  ///
  /// In en, this message translates to:
  /// **'Quick Links'**
  String get quickLinks;

  /// No description provided for @chatWithUs.
  ///
  /// In en, this message translates to:
  /// **'Chat with us!'**
  String get chatWithUs;

  /// No description provided for @ourSocialMedia.
  ///
  /// In en, this message translates to:
  /// **'Our Social\'s Media'**
  String get ourSocialMedia;

  /// No description provided for @copyright.
  ///
  /// In en, this message translates to:
  /// **'Copyright © {year} {company}. All rights reserved.'**
  String copyright(int year, String company);

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @disclaimer.
  ///
  /// In en, this message translates to:
  /// **'Disclaimer'**
  String get disclaimer;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @backToTop.
  ///
  /// In en, this message translates to:
  /// **'Back to top'**
  String get backToTop;

  /// No description provided for @pageNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get pageNotFoundTitle;

  /// No description provided for @pageNotFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'The page you\'re looking for doesn\'t exist or has been moved.'**
  String get pageNotFoundMessage;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @heroHeadline1.
  ///
  /// In en, this message translates to:
  /// **'Quality apps & training. Affordable.'**
  String get heroHeadline1;

  /// No description provided for @heroHeadline1Prefix.
  ///
  /// In en, this message translates to:
  /// **''**
  String get heroHeadline1Prefix;

  /// No description provided for @heroHeadline1Highlight.
  ///
  /// In en, this message translates to:
  /// **'Quality apps'**
  String get heroHeadline1Highlight;

  /// No description provided for @heroHeadline1Suffix.
  ///
  /// In en, this message translates to:
  /// **' & training.'**
  String get heroHeadline1Suffix;

  /// No description provided for @heroHeadline2Prefix.
  ///
  /// In en, this message translates to:
  /// **'Web, desktop, iOS & Android. '**
  String get heroHeadline2Prefix;

  /// No description provided for @heroHeadline2Highlight.
  ///
  /// In en, this message translates to:
  /// **'Affordable.'**
  String get heroHeadline2Highlight;

  /// No description provided for @heroSubline.
  ///
  /// In en, this message translates to:
  /// **'We build Apps, design Books & provide Trainings.'**
  String get heroSubline;

  /// No description provided for @exploreAllEvents.
  ///
  /// In en, this message translates to:
  /// **'Explore All Trainings'**
  String get exploreAllEvents;

  /// No description provided for @comingUpNext.
  ///
  /// In en, this message translates to:
  /// **'Coming Up Next'**
  String get comingUpNext;

  /// No description provided for @allUpcomingEvents.
  ///
  /// In en, this message translates to:
  /// **'All Upcoming Trainings'**
  String get allUpcomingEvents;

  /// No description provided for @limitedSeats.
  ///
  /// In en, this message translates to:
  /// **'Limited seats'**
  String get limitedSeats;

  /// No description provided for @viewEvent.
  ///
  /// In en, this message translates to:
  /// **'View Training'**
  String get viewEvent;

  /// No description provided for @exploreCourses.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get exploreCourses;

  /// No description provided for @getConsultation.
  ///
  /// In en, this message translates to:
  /// **'Get Consultation'**
  String get getConsultation;

  /// No description provided for @finalCtaHeading.
  ///
  /// In en, this message translates to:
  /// **'Ready to get started?'**
  String get finalCtaHeading;

  /// No description provided for @finalCtaOverline.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get finalCtaOverline;

  /// No description provided for @finalCtaBody.
  ///
  /// In en, this message translates to:
  /// **'Tell us which service you need—App Development, Responsive Web, AI Agent, Book Creation, Communications Training, or a Custom Project. We\'ll reply in clear terms.'**
  String get finalCtaBody;

  /// No description provided for @notSureWhereToStart.
  ///
  /// In en, this message translates to:
  /// **'Not sure where to start?'**
  String get notSureWhereToStart;

  /// No description provided for @notSureBody.
  ///
  /// In en, this message translates to:
  /// **'We offer six core services: App Development, Responsive Web, AI Agent, Book Creation Suite, Communications Training, and Custom Project. Tell us your goal and we\'ll point you to the right one.'**
  String get notSureBody;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @sectionExperienceHeading.
  ///
  /// In en, this message translates to:
  /// **'Hands-on trainings. Clear skills. Real impact.'**
  String get sectionExperienceHeading;

  /// No description provided for @sectionExperienceHeadingPrefix.
  ///
  /// In en, this message translates to:
  /// **'Hands-on trainings. '**
  String get sectionExperienceHeadingPrefix;

  /// No description provided for @sectionExperienceHeadingHighlight.
  ///
  /// In en, this message translates to:
  /// **'Clear skills. Real impact.'**
  String get sectionExperienceHeadingHighlight;

  /// No description provided for @sectionExperienceOverline.
  ///
  /// In en, this message translates to:
  /// **'Trainings'**
  String get sectionExperienceOverline;

  /// No description provided for @sectionServicesHeading.
  ///
  /// In en, this message translates to:
  /// **'What we offer'**
  String get sectionServicesHeading;

  /// No description provided for @sectionServicesOverline.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get sectionServicesOverline;

  /// No description provided for @sectionServicesSubline.
  ///
  /// In en, this message translates to:
  /// **'App Development, Responsive Web, AI Agent, Book Creation Suite, Communications Training, and Custom Project—one partner for all.'**
  String get sectionServicesSubline;

  /// No description provided for @serviceAiAgent.
  ///
  /// In en, this message translates to:
  /// **'AI Agent'**
  String get serviceAiAgent;

  /// No description provided for @serviceAiAgentDesc.
  ///
  /// In en, this message translates to:
  /// **'Smart automation and AI-powered solutions for your workflows.'**
  String get serviceAiAgentDesc;

  /// No description provided for @serviceAppDevelopment.
  ///
  /// In en, this message translates to:
  /// **'App Development'**
  String get serviceAppDevelopment;

  /// No description provided for @serviceAppDevelopmentDesc.
  ///
  /// In en, this message translates to:
  /// **'Modern apps for Web, Desktop, iOS and Android.'**
  String get serviceAppDevelopmentDesc;

  /// No description provided for @serviceBookCreation.
  ///
  /// In en, this message translates to:
  /// **'Book Creation Suite'**
  String get serviceBookCreation;

  /// No description provided for @serviceBookCreationDesc.
  ///
  /// In en, this message translates to:
  /// **'From idea to published book—writing, design, and publishing.'**
  String get serviceBookCreationDesc;

  /// No description provided for @serviceCommunicationsTraining.
  ///
  /// In en, this message translates to:
  /// **'Communications Training'**
  String get serviceCommunicationsTraining;

  /// No description provided for @serviceCommunicationsTrainingDesc.
  ///
  /// In en, this message translates to:
  /// **'Trainings that build clear, practical skills.'**
  String get serviceCommunicationsTrainingDesc;

  /// No description provided for @serviceCustomProject.
  ///
  /// In en, this message translates to:
  /// **'Custom Project'**
  String get serviceCustomProject;

  /// No description provided for @serviceCustomProjectDesc.
  ///
  /// In en, this message translates to:
  /// **'Tailored solutions for your unique needs and goals.'**
  String get serviceCustomProjectDesc;

  /// No description provided for @serviceResponsiveWeb.
  ///
  /// In en, this message translates to:
  /// **'Responsive Web'**
  String get serviceResponsiveWeb;

  /// No description provided for @serviceResponsiveWebDesc.
  ///
  /// In en, this message translates to:
  /// **'Beautiful, fast websites that work on every device.'**
  String get serviceResponsiveWebDesc;

  /// No description provided for @serviceLearnMore.
  ///
  /// In en, this message translates to:
  /// **'Learn more'**
  String get serviceLearnMore;

  /// No description provided for @sectionKnowledgeHeading.
  ///
  /// In en, this message translates to:
  /// **'Training that fits your goals.'**
  String get sectionKnowledgeHeading;

  /// No description provided for @sectionKnowledgeOverline.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get sectionKnowledgeOverline;

  /// No description provided for @sectionKnowledgeBody.
  ///
  /// In en, this message translates to:
  /// **'Communications Training is one of our six core services. We run human-centered and AI-enhanced trainings so you build clear, practical skills—no jargon. Custom sessions for your team or organization.'**
  String get sectionKnowledgeBody;

  /// No description provided for @sectionKnowledgeBody2.
  ///
  /// In en, this message translates to:
  /// **'We support Khmer, English, and Chinese. Fast turnaround so you get results without long waits.'**
  String get sectionKnowledgeBody2;

  /// No description provided for @sectionKnowledgeStat.
  ///
  /// In en, this message translates to:
  /// **'3+ languages'**
  String get sectionKnowledgeStat;

  /// No description provided for @sectionMapHeading.
  ///
  /// In en, this message translates to:
  /// **'Book a consultation—we\'ll match you to the right service.'**
  String get sectionMapHeading;

  /// No description provided for @sectionMapOverline.
  ///
  /// In en, this message translates to:
  /// **'Book a consultation'**
  String get sectionMapOverline;

  /// No description provided for @sectionMapIntro.
  ///
  /// In en, this message translates to:
  /// **'Pick a service below, book a slot. We\'ll discuss your needs and plan next steps—plain language, no jargon.'**
  String get sectionMapIntro;

  /// No description provided for @sectionStoryHeading.
  ///
  /// In en, this message translates to:
  /// **'Who we are.'**
  String get sectionStoryHeading;

  /// No description provided for @sectionStoryOverline.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get sectionStoryOverline;

  /// No description provided for @sectionStoryPara1.
  ///
  /// In en, this message translates to:
  /// **'Stonechat Communications delivers six core services: App Development, Responsive Web, AI Agent, Book Creation Suite, Communications Training, and Custom Project. One partner for apps, websites, books, and training.'**
  String get sectionStoryPara1;

  /// No description provided for @sectionStoryPara2.
  ///
  /// In en, this message translates to:
  /// **'We work in Khmer, English, and Chinese and focus on fast turnaround and clear communication. Whether you need an app, a site, a book, or training—we keep it intuitive.'**
  String get sectionStoryPara2;

  /// No description provided for @sectionStoryPara3.
  ///
  /// In en, this message translates to:
  /// **'Tell us your goal. We\'ll match you to the right service and next steps—in plain language.'**
  String get sectionStoryPara3;

  /// No description provided for @sectionStoryPara1Short.
  ///
  /// In en, this message translates to:
  /// **'Six services: App Development, Responsive Web, AI Agent, Book Creation, Communications Training, Custom Project.'**
  String get sectionStoryPara1Short;

  /// No description provided for @sectionStoryPara2Short.
  ///
  /// In en, this message translates to:
  /// **'Khmer, English & Chinese. Fast turnaround. Clear and intuitive.'**
  String get sectionStoryPara2Short;

  /// No description provided for @sectionStoryPara3Short.
  ///
  /// In en, this message translates to:
  /// **'Tell us your goal—we\'ll point you to the right service.'**
  String get sectionStoryPara3Short;

  /// No description provided for @sectionStoryCtaButton.
  ///
  /// In en, this message translates to:
  /// **'Our story'**
  String get sectionStoryCtaButton;

  /// No description provided for @sectionTestimonialsHeading.
  ///
  /// In en, this message translates to:
  /// **'Real Insights. Real Outcomes.'**
  String get sectionTestimonialsHeading;

  /// No description provided for @sectionTestimonialsOverline.
  ///
  /// In en, this message translates to:
  /// **'Testimonials'**
  String get sectionTestimonialsOverline;

  /// No description provided for @sectionTestimonialsSub1.
  ///
  /// In en, this message translates to:
  /// **'They didn\'t just join the event. They witnessed the real strategy.'**
  String get sectionTestimonialsSub1;

  /// No description provided for @sectionTestimonialsSub2.
  ///
  /// In en, this message translates to:
  /// **'From business leaders to individuals.'**
  String get sectionTestimonialsSub2;

  /// No description provided for @featuredIn.
  ///
  /// In en, this message translates to:
  /// **'Featured in'**
  String get featuredIn;

  /// No description provided for @watch.
  ///
  /// In en, this message translates to:
  /// **'Watch'**
  String get watch;

  /// No description provided for @academyQiMen.
  ///
  /// In en, this message translates to:
  /// **'The Art of Human-Centered Communication™'**
  String get academyQiMen;

  /// No description provided for @academyQiMenDesc.
  ///
  /// In en, this message translates to:
  /// **'Build strong general communication skills. Clear, practical training.'**
  String get academyQiMenDesc;

  /// No description provided for @academyBaZi.
  ///
  /// In en, this message translates to:
  /// **'The Art of AI-Enhanced Communication™'**
  String get academyBaZi;

  /// No description provided for @academyBaZiDesc.
  ///
  /// In en, this message translates to:
  /// **'Communicate effectively with and through AI tools. Get the most from AI.'**
  String get academyBaZiDesc;

  /// No description provided for @academyFengShui.
  ///
  /// In en, this message translates to:
  /// **'Custom training'**
  String get academyFengShui;

  /// No description provided for @academyFengShuiDesc.
  ///
  /// In en, this message translates to:
  /// **'Tailored workshops for your team or organization. We adapt to your needs.'**
  String get academyFengShuiDesc;

  /// No description provided for @academyPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Academy'**
  String get academyPageTitle;

  /// No description provided for @academyQiMenAbout.
  ///
  /// In en, this message translates to:
  /// **'Ancient strategy system based on time and space. Used for decision-making, date selection, and situational advantage.'**
  String get academyQiMenAbout;

  /// No description provided for @academyBaZiAbout.
  ///
  /// In en, this message translates to:
  /// **'Your birth chart in Eight Characters. Reveals strengths, life cycles, and hidden potential for career and relationships.'**
  String get academyBaZiAbout;

  /// No description provided for @academyFengShuiAbout.
  ///
  /// In en, this message translates to:
  /// **'The art of environmental energy. Learn to assess and align spaces for wellbeing and success.'**
  String get academyFengShuiAbout;

  /// No description provided for @academyQiMenTopics.
  ///
  /// In en, this message translates to:
  /// **'Nine Palaces • Strategic timing • Business & personal decisions'**
  String get academyQiMenTopics;

  /// No description provided for @academyBaZiTopics.
  ///
  /// In en, this message translates to:
  /// **'Four Pillars • Five Elements • Life potential & cycles'**
  String get academyBaZiTopics;

  /// No description provided for @academyFengShuiTopics.
  ///
  /// In en, this message translates to:
  /// **'Qi flow • Form & Compass • Space alignment'**
  String get academyFengShuiTopics;

  /// No description provided for @academyDateSelection.
  ///
  /// In en, this message translates to:
  /// **'Date Selection™'**
  String get academyDateSelection;

  /// No description provided for @academyDateSelectionDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose auspicious timing for key life and business events.'**
  String get academyDateSelectionDesc;

  /// No description provided for @academyDateSelectionAbout.
  ///
  /// In en, this message translates to:
  /// **'Select favourable dates and hours using almanac, BaZi and Qimen. Apply to weddings, openings, travel and major decisions.'**
  String get academyDateSelectionAbout;

  /// No description provided for @academyDateSelectionTopics.
  ///
  /// In en, this message translates to:
  /// **'Tung Shu • Auspicious hours • Events & milestones'**
  String get academyDateSelectionTopics;

  /// No description provided for @academyIChing.
  ///
  /// In en, this message translates to:
  /// **'I Ching™'**
  String get academyIChing;

  /// No description provided for @academyIChingDesc.
  ///
  /// In en, this message translates to:
  /// **'Ancient wisdom of the Book of Changes for clarity and direction.'**
  String get academyIChingDesc;

  /// No description provided for @academyIChingAbout.
  ///
  /// In en, this message translates to:
  /// **'The 64 hexagrams offer insight into change and outcome. Learn to consult the I Ching for decisions, strategy and personal guidance.'**
  String get academyIChingAbout;

  /// No description provided for @academyIChingTopics.
  ///
  /// In en, this message translates to:
  /// **'64 Hexagrams • Divination • Change & strategy'**
  String get academyIChingTopics;

  /// No description provided for @academyMaoShan.
  ///
  /// In en, this message translates to:
  /// **'Mao Shan™'**
  String get academyMaoShan;

  /// No description provided for @academyMaoShanDesc.
  ///
  /// In en, this message translates to:
  /// **'Taoist tradition of ritual and practice for transformation.'**
  String get academyMaoShanDesc;

  /// No description provided for @academyMaoShanAbout.
  ///
  /// In en, this message translates to:
  /// **'Mao Shan (Mount Mao) methods and rituals within Chinese metaphysics. Understand foundations and applications for spiritual and practical use.'**
  String get academyMaoShanAbout;

  /// No description provided for @academyMaoShanTopics.
  ///
  /// In en, this message translates to:
  /// **'Rituals • Tradition • Practice & application'**
  String get academyMaoShanTopics;

  /// No description provided for @academyMoreCoursesNote.
  ///
  /// In en, this message translates to:
  /// **'Trainings across our six services. Contact us for schedules or custom group sessions.'**
  String get academyMoreCoursesNote;

  /// No description provided for @eventCourseAppDevelopmentDesc.
  ///
  /// In en, this message translates to:
  /// **'Hands-on sessions on building apps for Web, Desktop, iOS & Android.'**
  String get eventCourseAppDevelopmentDesc;

  /// No description provided for @eventCourseAppDevelopmentAbout.
  ///
  /// In en, this message translates to:
  /// **'Join trainings and demos on modern app development. Clean architecture, clear interfaces, and practical tips. Suitable for teams and individuals exploring our App Development service.'**
  String get eventCourseAppDevelopmentAbout;

  /// No description provided for @eventCourseAppDevelopmentTopics.
  ///
  /// In en, this message translates to:
  /// **'Cross-platform • Clean code • UI/UX • Demos & Q&A'**
  String get eventCourseAppDevelopmentTopics;

  /// No description provided for @eventCourseResponsiveWebDesc.
  ///
  /// In en, this message translates to:
  /// **'Learn to design and deliver websites that work on every device.'**
  String get eventCourseResponsiveWebDesc;

  /// No description provided for @eventCourseResponsiveWebAbout.
  ///
  /// In en, this message translates to:
  /// **'Trainings on responsive design, performance, and deployment. See live demos and get guidance on your Responsive Web projects. From concept to launch.'**
  String get eventCourseResponsiveWebAbout;

  /// No description provided for @eventCourseResponsiveWebTopics.
  ///
  /// In en, this message translates to:
  /// **'Responsive layout • Performance • Accessibility • Real projects'**
  String get eventCourseResponsiveWebTopics;

  /// No description provided for @eventCourseAiAgentDesc.
  ///
  /// In en, this message translates to:
  /// **'Smart automation and AI-powered solutions—see them in action.'**
  String get eventCourseAiAgentDesc;

  /// No description provided for @eventCourseAiAgentAbout.
  ///
  /// In en, this message translates to:
  /// **'Demos and sessions on AI agents and workflow automation. Understand how our AI Agent service can fit your needs. No heavy jargon—clear, practical insights.'**
  String get eventCourseAiAgentAbout;

  /// No description provided for @eventCourseAiAgentTopics.
  ///
  /// In en, this message translates to:
  /// **'Automation • AI tools • Use cases • Integration'**
  String get eventCourseAiAgentTopics;

  /// No description provided for @eventCourseBookCreationDesc.
  ///
  /// In en, this message translates to:
  /// **'From idea to published book. Writing, design, and publishing trainings.'**
  String get eventCourseBookCreationDesc;

  /// No description provided for @eventCourseBookCreationAbout.
  ///
  /// In en, this message translates to:
  /// **'Sessions on the full book-creation journey: concept, writing, editing, design, and publishing. Part of our Book Creation Suite. For authors and organizations.'**
  String get eventCourseBookCreationAbout;

  /// No description provided for @eventCourseBookCreationTopics.
  ///
  /// In en, this message translates to:
  /// **'Writing • Editing • Design • Publishing pipeline'**
  String get eventCourseBookCreationTopics;

  /// No description provided for @eventCourseCommunicationsTrainingDesc.
  ///
  /// In en, this message translates to:
  /// **'Human-centered and AI-enhanced communication skills. Clear, practical.'**
  String get eventCourseCommunicationsTrainingDesc;

  /// No description provided for @eventCourseCommunicationsTrainingAbout.
  ///
  /// In en, this message translates to:
  /// **'Our Communications Training in action. Trainings on clear speaking, writing, and using AI to communicate better. Human-centered and AI-enhanced. Khmer, English, Chinese.'**
  String get eventCourseCommunicationsTrainingAbout;

  /// No description provided for @eventCourseCommunicationsTrainingTopics.
  ///
  /// In en, this message translates to:
  /// **'Clear messaging • AI tools • Team skills • Practice sessions'**
  String get eventCourseCommunicationsTrainingTopics;

  /// No description provided for @eventCourseCustomProjectDesc.
  ///
  /// In en, this message translates to:
  /// **'Tailored solutions: mix and match our services for your goals.'**
  String get eventCourseCustomProjectDesc;

  /// No description provided for @eventCourseCustomProjectAbout.
  ///
  /// In en, this message translates to:
  /// **'Sessions and consultations on custom projects that combine App Development, Web, AI, Books, or Training. We help you scope and plan. One partner, flexible delivery.'**
  String get eventCourseCustomProjectAbout;

  /// No description provided for @eventCourseCustomProjectTopics.
  ///
  /// In en, this message translates to:
  /// **'Scoping • Planning • Multi-service • Your goals'**
  String get eventCourseCustomProjectTopics;

  /// No description provided for @consult1Category.
  ///
  /// In en, this message translates to:
  /// **'App Development'**
  String get consult1Category;

  /// No description provided for @consult1Method.
  ///
  /// In en, this message translates to:
  /// **'Development'**
  String get consult1Method;

  /// No description provided for @consult1Question.
  ///
  /// In en, this message translates to:
  /// **'Need a modern app?'**
  String get consult1Question;

  /// No description provided for @consult1Desc.
  ///
  /// In en, this message translates to:
  /// **'We build apps for Web, Desktop, iOS, and Android. Clean architectures, clear interfaces, affordable. One of our six core services.'**
  String get consult1Desc;

  /// No description provided for @consult2Category.
  ///
  /// In en, this message translates to:
  /// **'Communications Training'**
  String get consult2Category;

  /// No description provided for @consult2Method.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get consult2Method;

  /// No description provided for @consult2Question.
  ///
  /// In en, this message translates to:
  /// **'Want to sharpen communication skills?'**
  String get consult2Question;

  /// No description provided for @consult2Desc.
  ///
  /// In en, this message translates to:
  /// **'Communications Training is a core service. Human-centered and AI-enhanced workshops. Clear, practical skills for you or your team.'**
  String get consult2Desc;

  /// No description provided for @consult3Category.
  ///
  /// In en, this message translates to:
  /// **'Book Creation Suite'**
  String get consult3Category;

  /// No description provided for @consult3Method.
  ///
  /// In en, this message translates to:
  /// **'Publishing'**
  String get consult3Method;

  /// No description provided for @consult3Question.
  ///
  /// In en, this message translates to:
  /// **'Ready to publish your book?'**
  String get consult3Question;

  /// No description provided for @consult3Desc.
  ///
  /// In en, this message translates to:
  /// **'From idea to finished book—writing, editing, design, and publishing. Book Creation Suite covers it. We support authors and organizations every step.'**
  String get consult3Desc;

  /// No description provided for @consult4Category.
  ///
  /// In en, this message translates to:
  /// **'Custom Project'**
  String get consult4Category;

  /// No description provided for @consult4Method.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get consult4Method;

  /// No description provided for @consult4Question.
  ///
  /// In en, this message translates to:
  /// **'Something else in mind?'**
  String get consult4Question;

  /// No description provided for @consult4Desc.
  ///
  /// In en, this message translates to:
  /// **'Custom Project is for goals that mix our services or need a tailored plan. Tell us your idea and we\'ll match you to the right solution.'**
  String get consult4Desc;

  /// No description provided for @consult5Category.
  ///
  /// In en, this message translates to:
  /// **'Responsive Web'**
  String get consult5Category;

  /// No description provided for @consult5Method.
  ///
  /// In en, this message translates to:
  /// **'Web'**
  String get consult5Method;

  /// No description provided for @consult5Question.
  ///
  /// In en, this message translates to:
  /// **'Need a website?'**
  String get consult5Question;

  /// No description provided for @consult5Desc.
  ///
  /// In en, this message translates to:
  /// **'Responsive Web: beautiful, fast sites that work on every device. One of our six services. Get in touch for a quote.'**
  String get consult5Desc;

  /// No description provided for @consult6Category.
  ///
  /// In en, this message translates to:
  /// **'AI Agent'**
  String get consult6Category;

  /// No description provided for @consult6Method.
  ///
  /// In en, this message translates to:
  /// **'AI'**
  String get consult6Method;

  /// No description provided for @consult6Question.
  ///
  /// In en, this message translates to:
  /// **'Interested in AI automation?'**
  String get consult6Question;

  /// No description provided for @consult6Desc.
  ///
  /// In en, this message translates to:
  /// **'AI Agent covers smart automation and AI-powered solutions. One of our six core services. We\'ll help you find the right fit.'**
  String get consult6Desc;

  /// No description provided for @stickyCtaText.
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get stickyCtaText;

  /// No description provided for @stickyLoginCta.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get stickyLoginCta;

  /// No description provided for @stickyDashboardCta.
  ///
  /// In en, this message translates to:
  /// **'Hub'**
  String get stickyDashboardCta;

  /// No description provided for @adminLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Staff sign in'**
  String get adminLoginTitle;

  /// No description provided for @adminLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to manage subscribers, appointments, and contact messages.'**
  String get adminLoginSubtitle;

  /// No description provided for @adminHubTitle.
  ///
  /// In en, this message translates to:
  /// **'Operations hub'**
  String get adminHubTitle;

  /// No description provided for @adminHubSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Everything you need to run Stonechat day to day.'**
  String get adminHubSubtitle;

  /// No description provided for @adminTabSubscribers.
  ///
  /// In en, this message translates to:
  /// **'Subscribers'**
  String get adminTabSubscribers;

  /// No description provided for @adminTabAppointments.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get adminTabAppointments;

  /// No description provided for @adminTabContacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get adminTabContacts;

  /// No description provided for @adminSubscribersHeading.
  ///
  /// In en, this message translates to:
  /// **'Newsletter subscribers'**
  String get adminSubscribersHeading;

  /// No description provided for @adminSubscribersSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Filter by email…'**
  String get adminSubscribersSearchHint;

  /// No description provided for @adminSubscribersEmpty.
  ///
  /// In en, this message translates to:
  /// **'No subscribers yet.'**
  String get adminSubscribersEmpty;

  /// No description provided for @adminContactsHeading.
  ///
  /// In en, this message translates to:
  /// **'Contact form'**
  String get adminContactsHeading;

  /// No description provided for @adminContactsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No messages yet.'**
  String get adminContactsEmpty;

  /// No description provided for @adminColEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get adminColEmail;

  /// No description provided for @adminColStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get adminColStatus;

  /// No description provided for @adminColSubscribed.
  ///
  /// In en, this message translates to:
  /// **'Subscribed'**
  String get adminColSubscribed;

  /// No description provided for @adminColLastConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Last confirmed'**
  String get adminColLastConfirmed;

  /// No description provided for @adminColName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get adminColName;

  /// No description provided for @adminColSubject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get adminColSubject;

  /// No description provided for @adminColDate.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get adminColDate;

  /// No description provided for @adminColPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get adminColPhone;

  /// No description provided for @adminViewDetails.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get adminViewDetails;

  /// No description provided for @adminMessageTitle.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get adminMessageTitle;

  /// No description provided for @adminLoadError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Try refresh.'**
  String get adminLoadError;

  /// No description provided for @popupTitle1.
  ///
  /// In en, this message translates to:
  /// **'Stonechat'**
  String get popupTitle1;

  /// No description provided for @popupTitle2.
  ///
  /// In en, this message translates to:
  /// **'News & updates'**
  String get popupTitle2;

  /// No description provided for @popupDescription.
  ///
  /// In en, this message translates to:
  /// **'Stay in the loop.'**
  String get popupDescription;

  /// No description provided for @readFullArticles.
  ///
  /// In en, this message translates to:
  /// **'Read more'**
  String get readFullArticles;

  /// No description provided for @popupFormPrompt.
  ///
  /// In en, this message translates to:
  /// **'Enter your details below and we\'ll notify you when we have updates.'**
  String get popupFormPrompt;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @subscribeEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Your email'**
  String get subscribeEmailHint;

  /// No description provided for @subscribeButton.
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get subscribeButton;

  /// No description provided for @subscribeJoinTelegram.
  ///
  /// In en, this message translates to:
  /// **'Join us on Telegram'**
  String get subscribeJoinTelegram;

  /// No description provided for @subscribeSuccess.
  ///
  /// In en, this message translates to:
  /// **'Thanks! We\'ll be in touch.'**
  String get subscribeSuccess;

  /// No description provided for @subscribeOr.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get subscribeOr;

  /// No description provided for @eventsCalendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Trainings'**
  String get eventsCalendarTitle;

  /// No description provided for @eventsHeroHeadline.
  ///
  /// In en, this message translates to:
  /// **'Trainings'**
  String get eventsHeroHeadline;

  /// No description provided for @eventsHeroOverline.
  ///
  /// In en, this message translates to:
  /// **'Trainings'**
  String get eventsHeroOverline;

  /// No description provided for @eventsHeroSubline.
  ///
  /// In en, this message translates to:
  /// **'Communications Training and more. Clear and practical.'**
  String get eventsHeroSubline;

  /// No description provided for @eventsSubline.
  ///
  /// In en, this message translates to:
  /// **'Where learning meets doing.'**
  String get eventsSubline;

  /// No description provided for @eventsDescription.
  ///
  /// In en, this message translates to:
  /// **'Our trainings support Communications Training and our other services—app demos, book launches, and sessions. Clear and practical. Khmer, English, and Chinese supported.'**
  String get eventsDescription;

  /// No description provided for @eventsDescriptionHighlight.
  ///
  /// In en, this message translates to:
  /// **'Communications Training'**
  String get eventsDescriptionHighlight;

  /// No description provided for @eventsWhyAttendTitle.
  ///
  /// In en, this message translates to:
  /// **'Why join our trainings'**
  String get eventsWhyAttendTitle;

  /// No description provided for @eventsWhyAttendLead.
  ///
  /// In en, this message translates to:
  /// **'Hands-on Communications Training: human-centered and AI-enhanced. Plus app and Book Creation insights. A friendly, no-jargon environment.'**
  String get eventsWhyAttendLead;

  /// No description provided for @eventsWhyAttend1.
  ///
  /// In en, this message translates to:
  /// **'Learn in plain language—no technical runaround. We make sure you feel comfortable and confident.'**
  String get eventsWhyAttend1;

  /// No description provided for @eventsWhyAttend2.
  ///
  /// In en, this message translates to:
  /// **'Meet others who care about clear communication and quality apps.'**
  String get eventsWhyAttend2;

  /// No description provided for @eventsWhyAttend3.
  ///
  /// In en, this message translates to:
  /// **'Limited seats. Secure your spot and get the most from the session.'**
  String get eventsWhyAttend3;

  /// No description provided for @eventsUpcomingHeadline.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Trainings'**
  String get eventsUpcomingHeadline;

  /// No description provided for @eventsUpcomingSubline.
  ///
  /// In en, this message translates to:
  /// **'Choose your training and secure your seat. We can\'t wait to see you there.'**
  String get eventsUpcomingSubline;

  /// No description provided for @secureYourSeat.
  ///
  /// In en, this message translates to:
  /// **'Book your seat'**
  String get secureYourSeat;

  /// No description provided for @searchEvent.
  ///
  /// In en, this message translates to:
  /// **'Search training…'**
  String get searchEvent;

  /// No description provided for @registerForEvent.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerForEvent;

  /// No description provided for @eventColumn.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get eventColumn;

  /// No description provided for @eventRegTitle.
  ///
  /// In en, this message translates to:
  /// **'Training Registration'**
  String get eventRegTitle;

  /// No description provided for @eventRegFor.
  ///
  /// In en, this message translates to:
  /// **'Registering for'**
  String get eventRegFor;

  /// No description provided for @eventRegName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get eventRegName;

  /// No description provided for @eventRegEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get eventRegEmail;

  /// No description provided for @eventRegPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get eventRegPhone;

  /// No description provided for @eventRegSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit registration'**
  String get eventRegSubmit;

  /// No description provided for @eventRegSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration received'**
  String get eventRegSuccess;

  /// No description provided for @eventRegSuccessNote.
  ///
  /// In en, this message translates to:
  /// **'We will confirm your seat by email or phone. See you at the training!'**
  String get eventRegSuccessNote;

  /// No description provided for @noEventsMatch.
  ///
  /// In en, this message translates to:
  /// **'No trainings match your search.'**
  String get noEventsMatch;

  /// No description provided for @dateColumn.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateColumn;

  /// No description provided for @locationColumn.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationColumn;

  /// No description provided for @aboutPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Stonechat Communications | About us'**
  String get aboutPageTitle;

  /// No description provided for @aboutBreadcrumb.
  ///
  /// In en, this message translates to:
  /// **'About Stonechat.'**
  String get aboutBreadcrumb;

  /// No description provided for @aboutHeroHeadline.
  ///
  /// In en, this message translates to:
  /// **'Your partner for six core services: apps, web, AI, books, training & custom projects.'**
  String get aboutHeroHeadline;

  /// No description provided for @aboutBullet1.
  ///
  /// In en, this message translates to:
  /// **'App Development & Responsive Web—modern apps and websites for every device.'**
  String get aboutBullet1;

  /// No description provided for @aboutBullet2.
  ///
  /// In en, this message translates to:
  /// **'AI Agent—smart automation and AI-powered solutions.'**
  String get aboutBullet2;

  /// No description provided for @aboutBullet3.
  ///
  /// In en, this message translates to:
  /// **'Book Creation Suite—from idea to published book. Communications Training—clear, practical workshops.'**
  String get aboutBullet3;

  /// No description provided for @aboutBullet4.
  ///
  /// In en, this message translates to:
  /// **'Custom Project—tailored solutions. Clear communication, fast turnaround. Khmer, English & Chinese.'**
  String get aboutBullet4;

  /// No description provided for @journeyPageHeadline.
  ///
  /// In en, this message translates to:
  /// **'Our story'**
  String get journeyPageHeadline;

  /// No description provided for @journeyHeroSubline.
  ///
  /// In en, this message translates to:
  /// **'Six services, one partner: App Development, Responsive Web, AI Agent, Book Creation, Communications Training, Custom Project.'**
  String get journeyHeroSubline;

  /// No description provided for @journeySectionTheStory.
  ///
  /// In en, this message translates to:
  /// **'The story'**
  String get journeySectionTheStory;

  /// No description provided for @journeyHeroSpotlightTitle.
  ///
  /// In en, this message translates to:
  /// **'Who we are'**
  String get journeyHeroSpotlightTitle;

  /// No description provided for @journeyHeroSpotlightDesc.
  ///
  /// In en, this message translates to:
  /// **'We deliver App Development, Responsive Web, AI Agent, Book Creation Suite, Communications Training, and Custom Project. Discover more below.'**
  String get journeyHeroSpotlightDesc;

  /// No description provided for @journeyHeroSpotlightCta.
  ///
  /// In en, this message translates to:
  /// **'Read the story'**
  String get journeyHeroSpotlightCta;

  /// No description provided for @journeyStory1.
  ///
  /// In en, this message translates to:
  /// **'Stonechat Communications delivers six core services: App Development, Responsive Web, AI Agent, Book Creation Suite, Communications Training, and Custom Project. We build modern apps and websites, design books, and run clear, practical training.'**
  String get journeyStory1;

  /// No description provided for @journeyStory2.
  ///
  /// In en, this message translates to:
  /// **'We focus on clean architectures and clear interfaces at a fair cost. We support Khmer, English, and Chinese and are flexible to add more languages. Every service is designed to be intuitive.'**
  String get journeyStory2;

  /// No description provided for @journeyStory3.
  ///
  /// In en, this message translates to:
  /// **'We value fast turnaround and a clear, human tone—so you stay informed and confident. Tell us your goal and we\'ll match you to the right service.'**
  String get journeyStory3;

  /// No description provided for @journeyPeriod9Title.
  ///
  /// In en, this message translates to:
  /// **'Communications Training'**
  String get journeyPeriod9Title;

  /// No description provided for @journeyPeriod9Body.
  ///
  /// In en, this message translates to:
  /// **'Communications Training is one of our six services. Human-centered and AI-enhanced workshops. Clear, practical skills—no jargon.'**
  String get journeyPeriod9Body;

  /// No description provided for @journeyPhoenixTitle.
  ///
  /// In en, this message translates to:
  /// **'Book Creation Suite'**
  String get journeyPhoenixTitle;

  /// No description provided for @journeyPhoenixBody.
  ///
  /// In en, this message translates to:
  /// **'Book Creation Suite: from idea to finished book. We support authors and organizations with writing, editing, design, and publishing. Everything in one place.'**
  String get journeyPhoenixBody;

  /// No description provided for @methodPageHeadline.
  ///
  /// In en, this message translates to:
  /// **'What we do'**
  String get methodPageHeadline;

  /// No description provided for @methodIntro.
  ///
  /// In en, this message translates to:
  /// **'We offer six core services: App Development, Responsive Web, AI Agent, Book Creation Suite, Communications Training, and Custom Project. Below is how we work and what you can expect. Clear and intuitive.'**
  String get methodIntro;

  /// No description provided for @methodBaZiTitle.
  ///
  /// In en, this message translates to:
  /// **'App Development & Responsive Web'**
  String get methodBaZiTitle;

  /// No description provided for @methodBaZiBody.
  ///
  /// In en, this message translates to:
  /// **'We build modern apps for Web, Desktop, iOS, and Android and design responsive websites. Clean code, clear interfaces, quality at a fair price.'**
  String get methodBaZiBody;

  /// No description provided for @methodQimenTitle.
  ///
  /// In en, this message translates to:
  /// **'Communications Training'**
  String get methodQimenTitle;

  /// No description provided for @methodQimenBody.
  ///
  /// In en, this message translates to:
  /// **'Communications Training: human-centered and AI-enhanced workshops. Clear, practical skills so you and your team communicate with confidence. No jargon.'**
  String get methodQimenBody;

  /// No description provided for @methodIChingTitle.
  ///
  /// In en, this message translates to:
  /// **'Book Creation Suite'**
  String get methodIChingTitle;

  /// No description provided for @methodIChingBody.
  ///
  /// In en, this message translates to:
  /// **'From idea to published book—writing, editing, design, and publishing. We support authors and organizations every step of the way.'**
  String get methodIChingBody;

  /// No description provided for @methodDateSelectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Fast turnaround'**
  String get methodDateSelectionTitle;

  /// No description provided for @methodDateSelectionBody.
  ///
  /// In en, this message translates to:
  /// **'We value speed without sacrificing quality. We don\'t keep you waiting for months; we prioritize a fast turnaround so you get your website, app, training, or book moving in good time.'**
  String get methodDateSelectionBody;

  /// No description provided for @methodFengShuiTitle.
  ///
  /// In en, this message translates to:
  /// **'Languages we support'**
  String get methodFengShuiTitle;

  /// No description provided for @methodFengShuiBody.
  ///
  /// In en, this message translates to:
  /// **'Our products and services support Khmer, English, and Chinese. We\'re flexible enough to add more languages upon request so you can reach the audience you need.'**
  String get methodFengShuiBody;

  /// No description provided for @methodMaoShanTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear, human communication'**
  String get methodMaoShanTitle;

  /// No description provided for @methodMaoShanBody.
  ///
  /// In en, this message translates to:
  /// **'In every interaction we communicate in a clear, human tone rather than using overly technical jargon. Our goal is to make sure non-technical clients feel comfortable, informed, and confident throughout the process.'**
  String get methodMaoShanBody;

  /// No description provided for @appointmentIntro.
  ///
  /// In en, this message translates to:
  /// **'Choose your consultation type, pick a time, and receive an SMS confirmation to your phone.'**
  String get appointmentIntro;

  /// No description provided for @stepChooseService.
  ///
  /// In en, this message translates to:
  /// **'Selection'**
  String get stepChooseService;

  /// No description provided for @stepDateAndTime.
  ///
  /// In en, this message translates to:
  /// **'Date & time'**
  String get stepDateAndTime;

  /// No description provided for @stepYourDetails.
  ///
  /// In en, this message translates to:
  /// **'Your details'**
  String get stepYourDetails;

  /// No description provided for @stepConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get stepConfirm;

  /// No description provided for @stepGuideChooseService.
  ///
  /// In en, this message translates to:
  /// **'Pick the consultation type and how you\'d like to meet.'**
  String get stepGuideChooseService;

  /// No description provided for @stepGuideDateAndTime.
  ///
  /// In en, this message translates to:
  /// **'Choose a date and time that work for you.'**
  String get stepGuideDateAndTime;

  /// No description provided for @stepGuideYourDetails.
  ///
  /// In en, this message translates to:
  /// **'Share your name and phone so we can confirm your booking.'**
  String get stepGuideYourDetails;

  /// No description provided for @stepGuideConfirm.
  ///
  /// In en, this message translates to:
  /// **'Review your booking and confirm to receive an SMS.'**
  String get stepGuideConfirm;

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get yourName;

  /// No description provided for @yourPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get yourPhone;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send your confirmation via SMS'**
  String get phoneHint;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// No description provided for @selectTime.
  ///
  /// In en, this message translates to:
  /// **'Preferred time'**
  String get selectTime;

  /// No description provided for @confirmAndBook.
  ///
  /// In en, this message translates to:
  /// **'Confirm & book'**
  String get confirmAndBook;

  /// No description provided for @bookingSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking confirmed'**
  String get bookingSuccessTitle;

  /// No description provided for @bookingSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your consultation has been reserved.'**
  String get bookingSuccessMessage;

  /// No description provided for @smsConfirmationNote.
  ///
  /// In en, this message translates to:
  /// **'An SMS confirmation has been sent to your phone.'**
  String get smsConfirmationNote;

  /// No description provided for @smsPoweredByPlasGate.
  ///
  /// In en, this message translates to:
  /// **'SMS confirmation sent via PlasGate.'**
  String get smsPoweredByPlasGate;

  /// No description provided for @smsStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'SMS status'**
  String get smsStatusLabel;

  /// No description provided for @sessionDurationNote.
  ///
  /// In en, this message translates to:
  /// **'Each session is 2 hours with a 1-hour break between sessions.'**
  String get sessionDurationNote;

  /// No description provided for @sessionType.
  ///
  /// In en, this message translates to:
  /// **'Session type'**
  String get sessionType;

  /// No description provided for @sessionTypeOnline.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get sessionTypeOnline;

  /// No description provided for @sessionTypeVisit.
  ///
  /// In en, this message translates to:
  /// **'Visit'**
  String get sessionTypeVisit;

  /// No description provided for @bookAnother.
  ///
  /// In en, this message translates to:
  /// **'Book another'**
  String get bookAnother;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @viewYourBookings.
  ///
  /// In en, this message translates to:
  /// **'View your bookings'**
  String get viewYourBookings;

  /// No description provided for @viewYourBookingsIntro.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number to see your upcoming and past bookings.'**
  String get viewYourBookingsIntro;

  /// No description provided for @findMyBookings.
  ///
  /// In en, this message translates to:
  /// **'Find my bookings'**
  String get findMyBookings;

  /// No description provided for @bookingReference.
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get bookingReference;

  /// No description provided for @noBookingsFound.
  ///
  /// In en, this message translates to:
  /// **'No bookings found for this number.'**
  String get noBookingsFound;

  /// No description provided for @cancelBookingButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel booking'**
  String get cancelBookingButton;

  /// No description provided for @cancelBookingConfirm.
  ///
  /// In en, this message translates to:
  /// **'Cancel this booking?'**
  String get cancelBookingConfirm;

  /// No description provided for @bookingCancelled.
  ///
  /// In en, this message translates to:
  /// **'Booking cancelled.'**
  String get bookingCancelled;

  /// No description provided for @loadingSlots.
  ///
  /// In en, this message translates to:
  /// **'Loading available times…'**
  String get loadingSlots;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @statusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get statusConfirmed;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// No description provided for @markAsCompleted.
  ///
  /// In en, this message translates to:
  /// **'Mark completed'**
  String get markAsCompleted;

  /// No description provided for @customTime.
  ///
  /// In en, this message translates to:
  /// **'Custom time…'**
  String get customTime;

  /// No description provided for @editTime.
  ///
  /// In en, this message translates to:
  /// **'Edit time'**
  String get editTime;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @smartMoveHeading.
  ///
  /// In en, this message translates to:
  /// **'Let\'s build something great.'**
  String get smartMoveHeading;

  /// No description provided for @smartMoveIntro.
  ///
  /// In en, this message translates to:
  /// **'We deliver clean, solid-standard app architectures with elegant, user-friendly interfaces at a low cost. Individuals and businesses get high-quality products without breaking the bank. Fast turnaround, clear communication—so you\'re never left in the dark. We explain things in plain language so you stay informed and confident.'**
  String get smartMoveIntro;

  /// No description provided for @smartMoveCard1Title.
  ///
  /// In en, this message translates to:
  /// **'Web, Desktop, iOS & Android'**
  String get smartMoveCard1Title;

  /// No description provided for @smartMoveCard1Desc.
  ///
  /// In en, this message translates to:
  /// **'Modern apps built on clean architectures. We cover the platforms you need.'**
  String get smartMoveCard1Desc;

  /// No description provided for @smartMoveCard2Title.
  ///
  /// In en, this message translates to:
  /// **'Elegant, user-friendly interfaces'**
  String get smartMoveCard2Title;

  /// No description provided for @smartMoveCard2Desc.
  ///
  /// In en, this message translates to:
  /// **'Beautiful design that works. No clutter, no confusion.'**
  String get smartMoveCard2Desc;

  /// No description provided for @smartMoveCard3Title.
  ///
  /// In en, this message translates to:
  /// **'Affordable pricing'**
  String get smartMoveCard3Title;

  /// No description provided for @smartMoveCard3Desc.
  ///
  /// In en, this message translates to:
  /// **'High-quality products without the high price. We keep costs reasonable.'**
  String get smartMoveCard3Desc;

  /// No description provided for @smartMoveCard4Title.
  ///
  /// In en, this message translates to:
  /// **'Fast turnaround'**
  String get smartMoveCard4Title;

  /// No description provided for @smartMoveCard4Desc.
  ///
  /// In en, this message translates to:
  /// **'We don\'t keep you waiting for months. Speed without sacrificing quality.'**
  String get smartMoveCard4Desc;

  /// No description provided for @smartMoveCard5Title.
  ///
  /// In en, this message translates to:
  /// **'Clear, human communication'**
  String get smartMoveCard5Title;

  /// No description provided for @smartMoveCard5Desc.
  ///
  /// In en, this message translates to:
  /// **'We use plain language so non-technical clients feel comfortable and confident.'**
  String get smartMoveCard5Desc;

  /// No description provided for @smartMoveCard6Title.
  ///
  /// In en, this message translates to:
  /// **'Khmer, English, Chinese'**
  String get smartMoveCard6Title;

  /// No description provided for @smartMoveCard6Desc.
  ///
  /// In en, this message translates to:
  /// **'We support three main languages and can add more on request.'**
  String get smartMoveCard6Desc;

  /// No description provided for @contactLetsConnect.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Connect!'**
  String get contactLetsConnect;

  /// No description provided for @contactIntro.
  ///
  /// In en, this message translates to:
  /// **'Whether you need an app, a website, training, or help publishing a book—we\'re here. We use clear, human language. Choose a topic, leave your message, and we\'ll get back to you shortly. We usually reply within 1 business day.'**
  String get contactIntro;

  /// No description provided for @contactFormName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get contactFormName;

  /// No description provided for @contactFormEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get contactFormEmail;

  /// No description provided for @contactFormPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get contactFormPhone;

  /// No description provided for @contactFormSubject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get contactFormSubject;

  /// No description provided for @contactFormMessage.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get contactFormMessage;

  /// No description provided for @contactSending.
  ///
  /// In en, this message translates to:
  /// **'Sending…'**
  String get contactSending;

  /// No description provided for @contactSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Thank you!'**
  String get contactSuccessTitle;

  /// No description provided for @contactSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your message has been sent successfully. Our team will get back to you soon.'**
  String get contactSuccess;

  /// No description provided for @contactErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t send your message'**
  String get contactErrorTitle;

  /// No description provided for @contactError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again or email us directly.'**
  String get contactError;

  /// No description provided for @contactSubjectDestiny.
  ///
  /// In en, this message translates to:
  /// **'App or website development'**
  String get contactSubjectDestiny;

  /// No description provided for @contactSubjectBusiness.
  ///
  /// In en, this message translates to:
  /// **'Communication training'**
  String get contactSubjectBusiness;

  /// No description provided for @contactSubjectFengShui.
  ///
  /// In en, this message translates to:
  /// **'Book publishing'**
  String get contactSubjectFengShui;

  /// No description provided for @contactSubjectDateSelection.
  ///
  /// In en, this message translates to:
  /// **'General enquiry'**
  String get contactSubjectDateSelection;

  /// No description provided for @contactSubjectUnsure.
  ///
  /// In en, this message translates to:
  /// **'Not sure—recommend something for me'**
  String get contactSubjectUnsure;

  /// No description provided for @forecastAuspiciousStars.
  ///
  /// In en, this message translates to:
  /// **'Auspicious Stars'**
  String get forecastAuspiciousStars;

  /// No description provided for @forecastInauspiciousStars.
  ///
  /// In en, this message translates to:
  /// **'Inauspicious Stars'**
  String get forecastInauspiciousStars;

  /// No description provided for @zodiacRat.
  ///
  /// In en, this message translates to:
  /// **'Rat'**
  String get zodiacRat;

  /// No description provided for @zodiacOx.
  ///
  /// In en, this message translates to:
  /// **'Ox'**
  String get zodiacOx;

  /// No description provided for @zodiacTiger.
  ///
  /// In en, this message translates to:
  /// **'Tiger'**
  String get zodiacTiger;

  /// No description provided for @zodiacRabbit.
  ///
  /// In en, this message translates to:
  /// **'Rabbit'**
  String get zodiacRabbit;

  /// No description provided for @zodiacDragon.
  ///
  /// In en, this message translates to:
  /// **'Dragon'**
  String get zodiacDragon;

  /// No description provided for @zodiacSnake.
  ///
  /// In en, this message translates to:
  /// **'Snake'**
  String get zodiacSnake;

  /// No description provided for @zodiacHorse.
  ///
  /// In en, this message translates to:
  /// **'Horse'**
  String get zodiacHorse;

  /// No description provided for @zodiacGoat.
  ///
  /// In en, this message translates to:
  /// **'Goat'**
  String get zodiacGoat;

  /// No description provided for @zodiacMonkey.
  ///
  /// In en, this message translates to:
  /// **'Monkey'**
  String get zodiacMonkey;

  /// No description provided for @zodiacRooster.
  ///
  /// In en, this message translates to:
  /// **'Rooster'**
  String get zodiacRooster;

  /// No description provided for @zodiacDog.
  ///
  /// In en, this message translates to:
  /// **'Dog'**
  String get zodiacDog;

  /// No description provided for @zodiacPig.
  ///
  /// In en, this message translates to:
  /// **'Pig'**
  String get zodiacPig;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loading;

  /// No description provided for @academiesAppsWebAiTitle.
  ///
  /// In en, this message translates to:
  /// **'Apps, Web & AI that work together.'**
  String get academiesAppsWebAiTitle;

  /// No description provided for @academiesBody1.
  ///
  /// In en, this message translates to:
  /// **'We combine three core services—App Development, Responsive Web, and AI Agent—so your app, website, and automation work as one system.'**
  String get academiesBody1;

  /// No description provided for @academiesBody2.
  ///
  /// In en, this message translates to:
  /// **'From idea to interface, we help you choose the right mix, then design, build, and launch with one partner and one clear process.'**
  String get academiesBody2;

  /// No description provided for @eventsAudienceIntro.
  ///
  /// In en, this message translates to:
  /// **'Our trainings are designed for different types of clients. See where you fit below.'**
  String get eventsAudienceIntro;

  /// No description provided for @eventsAudienceGovernmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Government & Ministry teams'**
  String get eventsAudienceGovernmentTitle;

  /// No description provided for @eventsAudienceGovernmentDesc.
  ///
  /// In en, this message translates to:
  /// **'Support for policy, communications and technical units that need clear, practical training without heavy jargon.'**
  String get eventsAudienceGovernmentDesc;

  /// No description provided for @eventsAudienceBusinessTitle.
  ///
  /// In en, this message translates to:
  /// **'Businesses & Startups'**
  String get eventsAudienceBusinessTitle;

  /// No description provided for @eventsAudienceBusinessDesc.
  ///
  /// In en, this message translates to:
  /// **'Trainings to help founders and teams present ideas, write for customers and use AI tools in daily work.'**
  String get eventsAudienceBusinessDesc;

  /// No description provided for @eventsAudienceNgoTitle.
  ///
  /// In en, this message translates to:
  /// **'NGOs & Training Centers'**
  String get eventsAudienceNgoTitle;

  /// No description provided for @eventsAudienceNgoDesc.
  ///
  /// In en, this message translates to:
  /// **'Programs designed for NGOs, universities and training centers that need practical skills and local examples.'**
  String get eventsAudienceNgoDesc;

  /// No description provided for @sectionStoryHighlight1.
  ///
  /// In en, this message translates to:
  /// **'partner'**
  String get sectionStoryHighlight1;

  /// No description provided for @sectionStoryHighlight2.
  ///
  /// In en, this message translates to:
  /// **'Khmer, English, and Chinese'**
  String get sectionStoryHighlight2;

  /// No description provided for @sectionStoryHighlight3.
  ///
  /// In en, this message translates to:
  /// **'Tell us your goal'**
  String get sectionStoryHighlight3;

  /// No description provided for @testimonial1Quote.
  ///
  /// In en, this message translates to:
  /// **'Stonechat turned our policy messages into clear stories that citizens understand in both Khmer and English.'**
  String get testimonial1Quote;

  /// No description provided for @testimonial1Name.
  ///
  /// In en, this message translates to:
  /// **'Panha Leakhena – Senate of Cambodia'**
  String get testimonial1Name;

  /// No description provided for @testimonial1Location.
  ///
  /// In en, this message translates to:
  /// **'Phnom Penh'**
  String get testimonial1Location;

  /// No description provided for @testimonial2Quote.
  ///
  /// In en, this message translates to:
  /// **'The workshop gave our team simple structures for speeches, reports and social media that fit our daily work.'**
  String get testimonial2Quote;

  /// No description provided for @testimonial2Name.
  ///
  /// In en, this message translates to:
  /// **'Moon Pichnil – Palimentary of Cambodia'**
  String get testimonial2Name;

  /// No description provided for @testimonial2Location.
  ///
  /// In en, this message translates to:
  /// **'Preah Sihanouk'**
  String get testimonial2Location;

  /// No description provided for @testimonial3Quote.
  ///
  /// In en, this message translates to:
  /// **'Our young professionals now speak and write with more confidence after Stonechat\'s practical, human‑centered coaching.'**
  String get testimonial3Quote;

  /// No description provided for @testimonial3Name.
  ///
  /// In en, this message translates to:
  /// **'Sereyrath Aumrith – PC Asia'**
  String get testimonial3Name;

  /// No description provided for @testimonial3Location.
  ///
  /// In en, this message translates to:
  /// **'International'**
  String get testimonial3Location;

  /// No description provided for @testimonial4Quote.
  ///
  /// In en, this message translates to:
  /// **'Stonechat built a simple clinic app our front‑desk can use easily. Daily work at N.22 Beauty Klinik is faster now.'**
  String get testimonial4Quote;

  /// No description provided for @testimonial4Name.
  ///
  /// In en, this message translates to:
  /// **'Sieng Vanna – N.22 Beauty Klinik'**
  String get testimonial4Name;

  /// No description provided for @testimonial4Location.
  ///
  /// In en, this message translates to:
  /// **'Kandal'**
  String get testimonial4Location;

  /// No description provided for @testimonial5Quote.
  ///
  /// In en, this message translates to:
  /// **'They helped us turn ideas into clear lesson plans, slides and tools for our students, on time and not too technical.'**
  String get testimonial5Quote;

  /// No description provided for @testimonial5Name.
  ///
  /// In en, this message translates to:
  /// **'Phum Thida – Master Elf'**
  String get testimonial5Name;

  /// No description provided for @testimonial5Location.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get testimonial5Location;

  /// No description provided for @testimonial6Quote.
  ///
  /// In en, this message translates to:
  /// **'Stonechat supported DAAD in Cambodia with bilingual copy and materials that feel natural for local and international audiences.'**
  String get testimonial6Quote;

  /// No description provided for @testimonial6Name.
  ///
  /// In en, this message translates to:
  /// **'Zeii Tey – DAAD in Cambodia'**
  String get testimonial6Name;

  /// No description provided for @testimonial6Location.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get testimonial6Location;

  /// No description provided for @testimonial7Quote.
  ///
  /// In en, this message translates to:
  /// **'Our students became more willing to present after a gentle workshop that used both Cambodian English and Khmer.'**
  String get testimonial7Quote;

  /// No description provided for @testimonial7Name.
  ///
  /// In en, this message translates to:
  /// **'Ya Nara – Royal University of Agriculture'**
  String get testimonial7Name;

  /// No description provided for @testimonial7Location.
  ///
  /// In en, this message translates to:
  /// **'Takhmao, Cambodia'**
  String get testimonial7Location;

  /// No description provided for @testimonial8Quote.
  ///
  /// In en, this message translates to:
  /// **'Their Communications Training showed us how to make long documents shorter and clearer with simple templates.'**
  String get testimonial8Quote;

  /// No description provided for @testimonial8Name.
  ///
  /// In en, this message translates to:
  /// **'Phart Sanit – Senate of Cambodia'**
  String get testimonial8Name;

  /// No description provided for @testimonial8Location.
  ///
  /// In en, this message translates to:
  /// **'Siem Reap, Cambodia'**
  String get testimonial8Location;

  /// No description provided for @testimonial9Quote.
  ///
  /// In en, this message translates to:
  /// **'For our public forum, Stonechat prepared talking points and slides that felt professional and close to local people.'**
  String get testimonial9Quote;

  /// No description provided for @testimonial9Name.
  ///
  /// In en, this message translates to:
  /// **'Ah Pich – Palimentary of Cambodia'**
  String get testimonial9Name;

  /// No description provided for @testimonial9Location.
  ///
  /// In en, this message translates to:
  /// **'Poipet, Cambodia'**
  String get testimonial9Location;

  /// No description provided for @testimonial10Quote.
  ///
  /// In en, this message translates to:
  /// **'They turned technical findings into short stories with clear visuals and many real Cambodian examples.'**
  String get testimonial10Quote;

  /// No description provided for @testimonial10Name.
  ///
  /// In en, this message translates to:
  /// **'Sreylin Khan – PC Asia'**
  String get testimonial10Name;

  /// No description provided for @testimonial10Location.
  ///
  /// In en, this message translates to:
  /// **'Siem Reap, Cambodia'**
  String get testimonial10Location;

  /// No description provided for @testimonial11Quote.
  ///
  /// In en, this message translates to:
  /// **'Stonechat guided our content, booking flow and SMS, so our clinic app and website now feel modern but still simple.'**
  String get testimonial11Quote;

  /// No description provided for @testimonial11Name.
  ///
  /// In en, this message translates to:
  /// **'Juary Mith – N.22 Beauty Klinik'**
  String get testimonial11Name;

  /// No description provided for @testimonial11Location.
  ///
  /// In en, this message translates to:
  /// **'Phnom Penh, Cambodia'**
  String get testimonial11Location;

  /// No description provided for @testimonial12Quote.
  ///
  /// In en, this message translates to:
  /// **'They explain AI and digital tools in plain words, so even non‑technical colleagues can use them in real work.'**
  String get testimonial12Quote;

  /// No description provided for @testimonial12Name.
  ///
  /// In en, this message translates to:
  /// **'Veth Raksmey – Master Elf'**
  String get testimonial12Name;

  /// No description provided for @testimonial12Location.
  ///
  /// In en, this message translates to:
  /// **'Phnom Penh, Cambodia'**
  String get testimonial12Location;

  /// No description provided for @testimonial13Quote.
  ///
  /// In en, this message translates to:
  /// **'Stonechat helped us draft friendly but accurate emails, posters and scripts for our scholarship communication.'**
  String get testimonial13Quote;

  /// No description provided for @testimonial13Name.
  ///
  /// In en, this message translates to:
  /// **'Taa – DAAD in Cambodia'**
  String get testimonial13Name;

  /// No description provided for @testimonial13Location.
  ///
  /// In en, this message translates to:
  /// **'Phnom Penh, Cambodia'**
  String get testimonial13Location;

  /// No description provided for @testimonial14Quote.
  ///
  /// In en, this message translates to:
  /// **'They designed a special session that connects communication, apps and books with practical, local case studies.'**
  String get testimonial14Quote;

  /// No description provided for @testimonial14Name.
  ///
  /// In en, this message translates to:
  /// **'Da Na – Royal University of Agriculture'**
  String get testimonial14Name;

  /// No description provided for @testimonial14Location.
  ///
  /// In en, this message translates to:
  /// **'Phnom Penh, Cambodia'**
  String get testimonial14Location;

  /// No description provided for @testimonial15Quote.
  ///
  /// In en, this message translates to:
  /// **'From day one they listened, then suggested the right mix of app, website and training instead of pushing everything.'**
  String get testimonial15Quote;

  /// No description provided for @testimonial15Name.
  ///
  /// In en, this message translates to:
  /// **'Mo Ly – Senate of Cambodia'**
  String get testimonial15Name;

  /// No description provided for @testimonial15Location.
  ///
  /// In en, this message translates to:
  /// **'Phnom Penh, Cambodia'**
  String get testimonial15Location;

  /// No description provided for @testimonial16Quote.
  ///
  /// In en, this message translates to:
  /// **'We saw clearly how AI can support, not replace, the human voice through live examples from our public sector reality.'**
  String get testimonial16Quote;

  /// No description provided for @testimonial16Name.
  ///
  /// In en, this message translates to:
  /// **'Mey In – Palimentary of Cambodia'**
  String get testimonial16Name;

  /// No description provided for @testimonial16Location.
  ///
  /// In en, this message translates to:
  /// **'Siem Reap, Cambodia'**
  String get testimonial16Location;

  /// No description provided for @testimonial17Quote.
  ///
  /// In en, this message translates to:
  /// **'Stonechat responds fast and delivers materials early, with explanations that make it easy for our team to adjust.'**
  String get testimonial17Quote;

  /// No description provided for @testimonial17Name.
  ///
  /// In en, this message translates to:
  /// **'Chantrea Smile – PC Asia'**
  String get testimonial17Name;

  /// No description provided for @testimonial17Location.
  ///
  /// In en, this message translates to:
  /// **'Tbong khmoum, Cambodia'**
  String get testimonial17Location;

  /// No description provided for @testimonial18Quote.
  ///
  /// In en, this message translates to:
  /// **'Our online presence is now more professional, and our team can maintain the app and website by ourselves.'**
  String get testimonial18Quote;

  /// No description provided for @testimonial18Name.
  ///
  /// In en, this message translates to:
  /// **'Suon Mardy – N.22 Beauty Klinik'**
  String get testimonial18Name;

  /// No description provided for @testimonial18Location.
  ///
  /// In en, this message translates to:
  /// **'Phnom Penh, Cambodia'**
  String get testimonial18Location;

  /// No description provided for @forecastYearBingWu.
  ///
  /// In en, this message translates to:
  /// **'2026 Bing Wu, Year of Fire Horse'**
  String get forecastYearBingWu;

  /// No description provided for @forecastYearSubtitle.
  ///
  /// In en, this message translates to:
  /// **'2026: New Beginnings & Transformation'**
  String get forecastYearSubtitle;

  /// No description provided for @logoPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Logo {number}'**
  String logoPlaceholder(int number);

  /// No description provided for @sampleArticle1.
  ///
  /// In en, this message translates to:
  /// **'Sample article 1'**
  String get sampleArticle1;

  /// No description provided for @sampleArticle2.
  ///
  /// In en, this message translates to:
  /// **'Sample article 2'**
  String get sampleArticle2;

  /// No description provided for @sampleFeature.
  ///
  /// In en, this message translates to:
  /// **'Sample feature'**
  String get sampleFeature;

  /// No description provided for @event1Title.
  ///
  /// In en, this message translates to:
  /// **'Communications Training: Human-Centered Skills'**
  String get event1Title;

  /// No description provided for @event1Date.
  ///
  /// In en, this message translates to:
  /// **'31 Jan 2026'**
  String get event1Date;

  /// No description provided for @event1Description.
  ///
  /// In en, this message translates to:
  /// **'Build listening, clarity, and empathy so everyday communication feels natural and confident. Core session of our Communications Training service. Clear, practical, no jargon.'**
  String get event1Description;

  /// No description provided for @event1Location.
  ///
  /// In en, this message translates to:
  /// **'Phnom Penh & Online (Zoom)'**
  String get event1Location;

  /// No description provided for @event2Title.
  ///
  /// In en, this message translates to:
  /// **'Communications Training: AI-Enhanced Skills'**
  String get event2Title;

  /// No description provided for @event2Date.
  ///
  /// In en, this message translates to:
  /// **'31 Jan 2026'**
  String get event2Date;

  /// No description provided for @event2Description.
  ///
  /// In en, this message translates to:
  /// **'Use AI tools to plan, draft, and refine emails, posts, and scripts—without losing your voice. Part of our AI Agent and Communications Training offerings. Hands-on and practical.'**
  String get event2Description;

  /// No description provided for @event2Location.
  ///
  /// In en, this message translates to:
  /// **'Online (Zoom)'**
  String get event2Location;

  /// No description provided for @event3Title.
  ///
  /// In en, this message translates to:
  /// **'Book Creation Suite: From Idea to Manuscript'**
  String get event3Title;

  /// No description provided for @event3Date.
  ///
  /// In en, this message translates to:
  /// **'1 – 2 Feb 2026'**
  String get event3Date;

  /// No description provided for @event3Description.
  ///
  /// In en, this message translates to:
  /// **'Training on the full journey from concept to manuscript: structure, writing, and editing. For authors and teams. One of our Book Creation Suite trainings.'**
  String get event3Description;

  /// No description provided for @event3Location.
  ///
  /// In en, this message translates to:
  /// **'In-house or on-site (by arrangement)'**
  String get event3Location;

  /// No description provided for @event4Title.
  ///
  /// In en, this message translates to:
  /// **'App Development & Responsive Web: Intro Training'**
  String get event4Title;

  /// No description provided for @event4Date.
  ///
  /// In en, this message translates to:
  /// **'15 Feb 2026'**
  String get event4Date;

  /// No description provided for @event4Description.
  ///
  /// In en, this message translates to:
  /// **'See how we build apps and responsive sites. Demos, Q&A, and a hands-on intro to modern development. For teams exploring our App Development or Responsive Web services.'**
  String get event4Description;

  /// No description provided for @event4Location.
  ///
  /// In en, this message translates to:
  /// **'Phnom Penh & Online (Zoom)'**
  String get event4Location;

  /// No description provided for @loginSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Staff / Admin Login'**
  String get loginSectionTitle;

  /// No description provided for @loginSectionIntro.
  ///
  /// In en, this message translates to:
  /// **'Log in to access the appointment dashboard and manage bookings.'**
  String get loginSectionIntro;

  /// No description provided for @loginEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get loginEmail;

  /// No description provided for @loginPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPassword;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get loginButton;

  /// No description provided for @logoutButton.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logoutButton;

  /// No description provided for @goToDashboard.
  ///
  /// In en, this message translates to:
  /// **'Go to Dashboard'**
  String get goToDashboard;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Appointment Dashboard'**
  String get dashboardTitle;

  /// No description provided for @dashboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View and manage all bookings'**
  String get dashboardSubtitle;

  /// No description provided for @dashboardStatsTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get dashboardStatsTotal;

  /// No description provided for @dashboardStatsPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get dashboardStatsPending;

  /// No description provided for @dashboardStatsConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get dashboardStatsConfirmed;

  /// No description provided for @dashboardStatsCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get dashboardStatsCancelled;

  /// No description provided for @dashboardStatsCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get dashboardStatsCompleted;

  /// No description provided for @filterByStatus.
  ///
  /// In en, this message translates to:
  /// **'Filter by status'**
  String get filterByStatus;

  /// No description provided for @statusColumn.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusColumn;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @appointmentName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get appointmentName;

  /// No description provided for @appointmentPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get appointmentPhone;

  /// No description provided for @confirmAppointment.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmAppointment;

  /// No description provided for @reschedule.
  ///
  /// In en, this message translates to:
  /// **'Reschedule'**
  String get reschedule;

  /// No description provided for @noAppointments.
  ///
  /// In en, this message translates to:
  /// **'No appointments found.'**
  String get noAppointments;

  /// No description provided for @loadingAppointments.
  ///
  /// In en, this message translates to:
  /// **'Loading appointments…'**
  String get loadingAppointments;

  /// No description provided for @errorLoadingAppointments.
  ///
  /// In en, this message translates to:
  /// **'Failed to load appointments.'**
  String get errorLoadingAppointments;

  /// No description provided for @statusUpdated.
  ///
  /// In en, this message translates to:
  /// **'Status updated.'**
  String get statusUpdated;

  /// No description provided for @errorUpdatingStatus.
  ///
  /// In en, this message translates to:
  /// **'Failed to update status.'**
  String get errorUpdatingStatus;

  /// No description provided for @loginError.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password.'**
  String get loginError;

  /// No description provided for @loginRequired.
  ///
  /// In en, this message translates to:
  /// **'Please log in to access the dashboard.'**
  String get loginRequired;

  /// No description provided for @calendarView.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendarView;

  /// No description provided for @listView.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get listView;

  /// No description provided for @createBooking.
  ///
  /// In en, this message translates to:
  /// **'Create booking'**
  String get createBooking;

  /// No description provided for @createBookingFor.
  ///
  /// In en, this message translates to:
  /// **'Create booking for client'**
  String get createBookingFor;

  /// No description provided for @selectDateAndTime.
  ///
  /// In en, this message translates to:
  /// **'Select date & time'**
  String get selectDateAndTime;

  /// No description provided for @bookingCreated.
  ///
  /// In en, this message translates to:
  /// **'Booking created successfully.'**
  String get bookingCreated;

  /// No description provided for @errorCreatingBooking.
  ///
  /// In en, this message translates to:
  /// **'Failed to create booking.'**
  String get errorCreatingBooking;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @availableSlots.
  ///
  /// In en, this message translates to:
  /// **'Available slots'**
  String get availableSlots;

  /// No description provided for @addBooking.
  ///
  /// In en, this message translates to:
  /// **'Add booking'**
  String get addBooking;

  /// No description provided for @pleaseEnterNameAndPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter name and phone.'**
  String get pleaseEnterNameAndPhone;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @noteHint.
  ///
  /// In en, this message translates to:
  /// **'Optional notes about this booking…'**
  String get noteHint;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network connection failed. Please check your internet connection.'**
  String get errorNetwork;

  /// No description provided for @errorNetworkTitle.
  ///
  /// In en, this message translates to:
  /// **'Connection Error'**
  String get errorNetworkTitle;

  /// No description provided for @errorTimeout.
  ///
  /// In en, this message translates to:
  /// **'Request timed out. Please check your connection and try again.'**
  String get errorTimeout;

  /// No description provided for @errorServerUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Service temporarily unavailable. Please try again.'**
  String get errorServerUnavailable;

  /// No description provided for @errorServerError.
  ///
  /// In en, this message translates to:
  /// **'Server error occurred. Please try again later.'**
  String get errorServerError;

  /// No description provided for @errorDatabaseError.
  ///
  /// In en, this message translates to:
  /// **'Database error occurred. Please try again.'**
  String get errorDatabaseError;

  /// No description provided for @errorAuthFailed.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed. Please try again.'**
  String get errorAuthFailed;

  /// No description provided for @errorAuthTitle.
  ///
  /// In en, this message translates to:
  /// **'Authentication Error'**
  String get errorAuthTitle;

  /// No description provided for @errorUserNotFound.
  ///
  /// In en, this message translates to:
  /// **'No account found with this email.'**
  String get errorUserNotFound;

  /// No description provided for @errorWrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password. Please try again.'**
  String get errorWrongPassword;

  /// No description provided for @errorEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered.'**
  String get errorEmailInUse;

  /// No description provided for @errorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address.'**
  String get errorInvalidEmail;

  /// No description provided for @errorTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please wait a moment and try again.'**
  String get errorTooManyRequests;

  /// No description provided for @errorPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to perform this action.'**
  String get errorPermissionDenied;

  /// No description provided for @errorPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Permission Denied'**
  String get errorPermissionTitle;

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'The requested resource was not found.'**
  String get errorNotFound;

  /// No description provided for @errorNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Not Found'**
  String get errorNotFoundTitle;

  /// No description provided for @errorInvalidInput.
  ///
  /// In en, this message translates to:
  /// **'Invalid input. Please check your information.'**
  String get errorInvalidInput;

  /// No description provided for @errorValidationTitle.
  ///
  /// In en, this message translates to:
  /// **'Validation Error'**
  String get errorValidationTitle;

  /// No description provided for @errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get errorUnknown;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorTitle;

  /// No description provided for @errorRateLimitTitle.
  ///
  /// In en, this message translates to:
  /// **'Too Many Requests'**
  String get errorRateLimitTitle;

  /// No description provided for @validationEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get validationEmailRequired;

  /// No description provided for @validationEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get validationEmailInvalid;

  /// No description provided for @validationPhoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get validationPhoneRequired;

  /// No description provided for @validationPhoneTooShort.
  ///
  /// In en, this message translates to:
  /// **'Phone number is too short'**
  String get validationPhoneTooShort;

  /// No description provided for @validationPhoneTooLong.
  ///
  /// In en, this message translates to:
  /// **'Phone number is too long'**
  String get validationPhoneTooLong;

  /// No description provided for @validationPhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get validationPhoneInvalid;

  /// No description provided for @validationNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get validationNameRequired;

  /// No description provided for @validationNameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get validationNameTooShort;

  /// No description provided for @validationNameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Name is too long'**
  String get validationNameTooLong;

  /// No description provided for @validationMessageRequired.
  ///
  /// In en, this message translates to:
  /// **'Message is required'**
  String get validationMessageRequired;

  /// No description provided for @validationMessageTooShort.
  ///
  /// In en, this message translates to:
  /// **'Message must be at least 10 characters'**
  String get validationMessageTooShort;

  /// No description provided for @validationMessageTooLong.
  ///
  /// In en, this message translates to:
  /// **'Message is too long (maximum 2000 characters)'**
  String get validationMessageTooLong;

  /// No description provided for @validationRequired.
  ///
  /// In en, this message translates to:
  /// **'{field} is required'**
  String validationRequired(String field);

  /// No description provided for @validationDateRequired.
  ///
  /// In en, this message translates to:
  /// **'Date is required'**
  String get validationDateRequired;

  /// No description provided for @validationDateNotPast.
  ///
  /// In en, this message translates to:
  /// **'Please select a date in the future'**
  String get validationDateNotPast;

  /// No description provided for @validationTimeRequired.
  ///
  /// In en, this message translates to:
  /// **'Time slot is required'**
  String get validationTimeRequired;

  /// No description provided for @validationTimeInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please select a valid time slot'**
  String get validationTimeInvalid;

  /// No description provided for @validationFormErrors.
  ///
  /// In en, this message translates to:
  /// **'Please fix the errors below'**
  String get validationFormErrors;

  /// No description provided for @validationPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get validationPasswordRequired;

  /// No description provided for @validationPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get validationPasswordTooShort;

  /// No description provided for @validationPasswordTooLong.
  ///
  /// In en, this message translates to:
  /// **'Password is too long (maximum 128 characters)'**
  String get validationPasswordTooLong;

  /// No description provided for @validationPasswordNoUpperCase.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one uppercase letter'**
  String get validationPasswordNoUpperCase;

  /// No description provided for @validationPasswordNoLowerCase.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one lowercase letter'**
  String get validationPasswordNoLowerCase;

  /// No description provided for @validationPasswordNoNumber.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one number'**
  String get validationPasswordNoNumber;

  /// No description provided for @validationUrlRequired.
  ///
  /// In en, this message translates to:
  /// **'URL is required'**
  String get validationUrlRequired;

  /// No description provided for @validationUrlInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid URL (must start with http:// or https://)'**
  String get validationUrlInvalid;

  /// No description provided for @semanticsNavigation.
  ///
  /// In en, this message translates to:
  /// **'Navigation'**
  String get semanticsNavigation;

  /// No description provided for @semanticsMainContent.
  ///
  /// In en, this message translates to:
  /// **'Main content'**
  String get semanticsMainContent;

  /// No description provided for @semanticsFooter.
  ///
  /// In en, this message translates to:
  /// **'Footer'**
  String get semanticsFooter;

  /// No description provided for @drawerNavigate.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get drawerNavigate;

  /// No description provided for @drawerGetInTouch.
  ///
  /// In en, this message translates to:
  /// **'Get in touch'**
  String get drawerGetInTouch;

  /// No description provided for @buttonOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get buttonOk;

  /// No description provided for @buttonAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get buttonAdd;

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @validationPleaseSelectService.
  ///
  /// In en, this message translates to:
  /// **'Please select a service'**
  String get validationPleaseSelectService;

  /// No description provided for @noSlotsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No slots available for this date.'**
  String get noSlotsAvailable;

  /// No description provided for @poweredBy.
  ///
  /// In en, this message translates to:
  /// **'Powered by Stonechat Communications'**
  String get poweredBy;

  /// No description provided for @tooltipWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get tooltipWhatsApp;

  /// No description provided for @tooltipFacebook.
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get tooltipFacebook;

  /// No description provided for @tooltipInstagram.
  ///
  /// In en, this message translates to:
  /// **'Instagram'**
  String get tooltipInstagram;

  /// No description provided for @tooltipTikTok.
  ///
  /// In en, this message translates to:
  /// **'TikTok'**
  String get tooltipTikTok;

  /// No description provided for @tooltipTelegram.
  ///
  /// In en, this message translates to:
  /// **'Telegram'**
  String get tooltipTelegram;

  /// No description provided for @tooltipEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get tooltipEmail;

  /// No description provided for @loadingExperience.
  ///
  /// In en, this message translates to:
  /// **'Loading your experience…'**
  String get loadingExperience;

  /// No description provided for @loadingOptimising.
  ///
  /// In en, this message translates to:
  /// **'Optimising view…'**
  String get loadingOptimising;

  /// No description provided for @loadingAlmostThere.
  ///
  /// In en, this message translates to:
  /// **'Almost there…'**
  String get loadingAlmostThere;

  /// No description provided for @loadingJustAMoment.
  ///
  /// In en, this message translates to:
  /// **'Just a moment…'**
  String get loadingJustAMoment;

  /// No description provided for @eventRegEmailSubjectPrefix.
  ///
  /// In en, this message translates to:
  /// **'Training Registration: '**
  String get eventRegEmailSubjectPrefix;

  /// No description provided for @eventRegEmailBodyRegistrant.
  ///
  /// In en, this message translates to:
  /// **'Registrant'**
  String get eventRegEmailBodyRegistrant;

  /// No description provided for @sectionTestimonialsPart1.
  ///
  /// In en, this message translates to:
  /// **'Real '**
  String get sectionTestimonialsPart1;

  /// No description provided for @sectionTestimonialsPart2.
  ///
  /// In en, this message translates to:
  /// **'Insights.\n'**
  String get sectionTestimonialsPart2;

  /// No description provided for @sectionTestimonialsPart3.
  ///
  /// In en, this message translates to:
  /// **'Real '**
  String get sectionTestimonialsPart3;

  /// No description provided for @sectionTestimonialsPart4.
  ///
  /// In en, this message translates to:
  /// **'Outcomes.'**
  String get sectionTestimonialsPart4;

  /// No description provided for @priceFromLabel.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get priceFromLabel;

  /// No description provided for @pricingSuffixUsd.
  ///
  /// In en, this message translates to:
  /// **' USD'**
  String get pricingSuffixUsd;

  /// No description provided for @pricingSuffixUsdPerMonth.
  ///
  /// In en, this message translates to:
  /// **' USD/mo'**
  String get pricingSuffixUsdPerMonth;

  /// No description provided for @projectBookCallCta.
  ///
  /// In en, this message translates to:
  /// **'Book a project call'**
  String get projectBookCallCta;

  /// No description provided for @projectPricingScopingNote.
  ///
  /// In en, this message translates to:
  /// **'Exact investment is confirmed after a scoping call.'**
  String get projectPricingScopingNote;

  /// No description provided for @marketplaceMostPopularBadge.
  ///
  /// In en, this message translates to:
  /// **'Most popular'**
  String get marketplaceMostPopularBadge;

  /// No description provided for @bookPageHeroOverline.
  ///
  /// In en, this message translates to:
  /// **'Publications & Book Services'**
  String get bookPageHeroOverline;

  /// No description provided for @bookPageHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'From first idea to finished book'**
  String get bookPageHeroTitle;

  /// No description provided for @bookPageHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Turn your expertise into a beautiful, professionally published book. Stonechat guides you from brainstorming and writing to design, printing, and launch.'**
  String get bookPageHeroSubtitle;

  /// No description provided for @bookStartProjectCta.
  ///
  /// In en, this message translates to:
  /// **'Start your book project'**
  String get bookStartProjectCta;

  /// No description provided for @bookServicesOverline.
  ///
  /// In en, this message translates to:
  /// **'Book services'**
  String get bookServicesOverline;

  /// No description provided for @bookServicesTitle.
  ///
  /// In en, this message translates to:
  /// **'Everything you need to publish with confidence'**
  String get bookServicesTitle;

  /// No description provided for @bookServicesIntro.
  ///
  /// In en, this message translates to:
  /// **'Whether you are starting with a rough idea, a draft manuscript, or a finished book that needs design and printing, Stonechat offers an end-to-end publication service tailored to busy leaders and experts.'**
  String get bookServicesIntro;

  /// No description provided for @bookSvc1Title.
  ///
  /// In en, this message translates to:
  /// **'Book strategy & structure'**
  String get bookSvc1Title;

  /// No description provided for @bookSvc1Body.
  ///
  /// In en, this message translates to:
  /// **'Clarify your core message, define who the book is for, and shape your ideas into a clear chapter outline. We help you decide what belongs in the book and what can stay out, so writing becomes faster and more focused.'**
  String get bookSvc1Body;

  /// No description provided for @bookSvc1Highlight.
  ///
  /// In en, this message translates to:
  /// **'Ideal for leaders and experts who know what they want to say but are not sure how to organise it.'**
  String get bookSvc1Highlight;

  /// No description provided for @bookSvc2Title.
  ///
  /// In en, this message translates to:
  /// **'Writing, editing & translation'**
  String get bookSvc2Title;

  /// No description provided for @bookSvc2Body.
  ///
  /// In en, this message translates to:
  /// **'Through interviews, co-writing and careful editing, we turn your knowledge into polished, publication-ready chapters. Our editorial team writes in your voice in both English and Khmer, then refines every page for accuracy and flow.'**
  String get bookSvc2Body;

  /// No description provided for @bookSvc2Highlight.
  ///
  /// In en, this message translates to:
  /// **'You stay the author and decision-maker; we do the heavy lifting on the page from first draft to final proof.'**
  String get bookSvc2Highlight;

  /// No description provided for @bookSvc3Title.
  ///
  /// In en, this message translates to:
  /// **'Design, layout & publishing'**
  String get bookSvc3Title;

  /// No description provided for @bookSvc3Body.
  ///
  /// In en, this message translates to:
  /// **'We create a professional cover, design clean interior pages, and prepare all print and digital files your printer needs. Our team coordinates specifications, quotations and test prints so your finished books look world-class on every shelf.'**
  String get bookSvc3Body;

  /// No description provided for @bookSvc3Highlight.
  ///
  /// In en, this message translates to:
  /// **'One partner from design concept to printed books in your hands, ready for launch.'**
  String get bookSvc3Highlight;

  /// No description provided for @bookProcessTitle.
  ///
  /// In en, this message translates to:
  /// **'How your book comes to life'**
  String get bookProcessTitle;

  /// No description provided for @bookProcessSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A single, guided process from first conversation to printed books in your hands.'**
  String get bookProcessSubtitle;

  /// No description provided for @bookProcessStep1Title.
  ///
  /// In en, this message translates to:
  /// **'1. Discovery & brainstorming'**
  String get bookProcessStep1Title;

  /// No description provided for @bookProcessStep1Body.
  ///
  /// In en, this message translates to:
  /// **'We explore your story, goals, audience, and timeline, then shape them into a clear book concept and working outline.'**
  String get bookProcessStep1Body;

  /// No description provided for @bookProcessStep2Title.
  ///
  /// In en, this message translates to:
  /// **'2. Writing & editorial'**
  String get bookProcessStep2Title;

  /// No description provided for @bookProcessStep2Body.
  ///
  /// In en, this message translates to:
  /// **'Through interviews, draft reviews, and editorial passes, we co-create chapters that sound like you and read like a pro.'**
  String get bookProcessStep2Body;

  /// No description provided for @bookProcessStep3Title.
  ///
  /// In en, this message translates to:
  /// **'3. Design & production'**
  String get bookProcessStep3Title;

  /// No description provided for @bookProcessStep3Body.
  ///
  /// In en, this message translates to:
  /// **'We design the cover, lay out the pages, prepare print and digital files, and manage printers to agreed quality standards.'**
  String get bookProcessStep3Body;

  /// No description provided for @bookProcessStep4Title.
  ///
  /// In en, this message translates to:
  /// **'4. Launch & beyond'**
  String get bookProcessStep4Title;

  /// No description provided for @bookProcessStep4Body.
  ///
  /// In en, this message translates to:
  /// **'You receive finished books and launch materials; we can also support events, media, and social content to amplify impact.'**
  String get bookProcessStep4Body;

  /// No description provided for @bookPricingHeading.
  ///
  /// In en, this message translates to:
  /// **'Transparent packages, customised to your book'**
  String get bookPricingHeading;

  /// No description provided for @bookPricingIntro.
  ///
  /// In en, this message translates to:
  /// **'Every project begins with a conversation. These packages give you a clear starting point — we then tailor scope, timelines and print quantities to match your goals and budget.'**
  String get bookPricingIntro;

  /// No description provided for @bookPlanAuthorStarterName.
  ///
  /// In en, this message translates to:
  /// **'Author Starter'**
  String get bookPlanAuthorStarterName;

  /// No description provided for @bookPlanAuthorStarterStrapline.
  ///
  /// In en, this message translates to:
  /// **'Ideal if you already have a draft or detailed notes.'**
  String get bookPlanAuthorStarterStrapline;

  /// No description provided for @bookPlanAuthorStarterBullet1.
  ///
  /// In en, this message translates to:
  /// **'Book concept and chapter outline workshop'**
  String get bookPlanAuthorStarterBullet1;

  /// No description provided for @bookPlanAuthorStarterBullet2.
  ///
  /// In en, this message translates to:
  /// **'Editorial review of manuscript (up to 40,000 words)'**
  String get bookPlanAuthorStarterBullet2;

  /// No description provided for @bookPlanAuthorStarterBullet3.
  ///
  /// In en, this message translates to:
  /// **'Line editing and proofreading'**
  String get bookPlanAuthorStarterBullet3;

  /// No description provided for @bookPlanAuthorStarterBullet4.
  ///
  /// In en, this message translates to:
  /// **'Simple interior layout and print-ready files'**
  String get bookPlanAuthorStarterBullet4;

  /// No description provided for @bookPlanSignatureName.
  ///
  /// In en, this message translates to:
  /// **'Signature Book'**
  String get bookPlanSignatureName;

  /// No description provided for @bookPlanSignatureStrapline.
  ///
  /// In en, this message translates to:
  /// **'Our most popular end-to-end package for leaders and experts.'**
  String get bookPlanSignatureStrapline;

  /// No description provided for @bookPlanSignatureBullet1.
  ///
  /// In en, this message translates to:
  /// **'Strategy, positioning and full chapter outline'**
  String get bookPlanSignatureBullet1;

  /// No description provided for @bookPlanSignatureBullet2.
  ///
  /// In en, this message translates to:
  /// **'Ghostwriting or co-writing based on interviews'**
  String get bookPlanSignatureBullet2;

  /// No description provided for @bookPlanSignatureBullet3.
  ///
  /// In en, this message translates to:
  /// **'Professional editing, proofreading and fact-checking'**
  String get bookPlanSignatureBullet3;

  /// No description provided for @bookPlanSignatureBullet4.
  ///
  /// In en, this message translates to:
  /// **'Custom cover design and premium interior layout'**
  String get bookPlanSignatureBullet4;

  /// No description provided for @bookPlanSignatureBullet5.
  ///
  /// In en, this message translates to:
  /// **'Print coordination (recommended specs and quotations)'**
  String get bookPlanSignatureBullet5;

  /// No description provided for @bookPlanLaunchLegacyName.
  ///
  /// In en, this message translates to:
  /// **'Launch & Legacy'**
  String get bookPlanLaunchLegacyName;

  /// No description provided for @bookPlanLaunchLegacyStrapline.
  ///
  /// In en, this message translates to:
  /// **'For books that anchor your brand, organisation or campaign.'**
  String get bookPlanLaunchLegacyStrapline;

  /// No description provided for @bookPlanLaunchLegacyBullet1.
  ///
  /// In en, this message translates to:
  /// **'Everything in Signature Book'**
  String get bookPlanLaunchLegacyBullet1;

  /// No description provided for @bookPlanLaunchLegacyBullet2.
  ///
  /// In en, this message translates to:
  /// **'Launch event and media talking points pack'**
  String get bookPlanLaunchLegacyBullet2;

  /// No description provided for @bookPlanLaunchLegacyBullet3.
  ///
  /// In en, this message translates to:
  /// **'Social media launch kit (posts, visuals, captions)'**
  String get bookPlanLaunchLegacyBullet3;

  /// No description provided for @bookPlanLaunchLegacyBullet4.
  ///
  /// In en, this message translates to:
  /// **'Press-ready PDF and digital book formats (e.g. PDF/ePub)'**
  String get bookPlanLaunchLegacyBullet4;

  /// No description provided for @bookPlanLaunchLegacyBullet5.
  ///
  /// In en, this message translates to:
  /// **'Optional translation and bilingual editions'**
  String get bookPlanLaunchLegacyBullet5;

  /// No description provided for @appsPageDevHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'From idea to App Store and Play Store'**
  String get appsPageDevHeroTitle;

  /// No description provided for @appsPageDevHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Turn your vision into a polished mobile or web app. Stonechat guides you from concept and design through development, testing, and submission to the App Store and Google Play.'**
  String get appsPageDevHeroSubtitle;

  /// No description provided for @appsStartProjectCta.
  ///
  /// In en, this message translates to:
  /// **'Start your app project'**
  String get appsStartProjectCta;

  /// No description provided for @appsServicesOverline.
  ///
  /// In en, this message translates to:
  /// **'App services'**
  String get appsServicesOverline;

  /// No description provided for @appsServicesTitle.
  ///
  /// In en, this message translates to:
  /// **'Everything you need to ship a great app'**
  String get appsServicesTitle;

  /// No description provided for @appsServicesIntro.
  ///
  /// In en, this message translates to:
  /// **'Whether you need a simple MVP or a full-featured product, Stonechat delivers end-to-end app development. We work with startups, enterprises, and organisations who want to move fast without cutting corners.'**
  String get appsServicesIntro;

  /// No description provided for @appSvc1Title.
  ///
  /// In en, this message translates to:
  /// **'Strategy & discovery'**
  String get appSvc1Title;

  /// No description provided for @appSvc1Body.
  ///
  /// In en, this message translates to:
  /// **'We clarify your app idea, define core features, and map user flows. Together we decide what to build first so you launch faster and stay within budget.'**
  String get appSvc1Body;

  /// No description provided for @appSvc1Highlight.
  ///
  /// In en, this message translates to:
  /// **'Ideal when you have a vision but need a clear roadmap to execute it.'**
  String get appSvc1Highlight;

  /// No description provided for @appSvc2Title.
  ///
  /// In en, this message translates to:
  /// **'Design & development'**
  String get appSvc2Title;

  /// No description provided for @appSvc2Body.
  ///
  /// In en, this message translates to:
  /// **'Our team designs intuitive interfaces and builds native or cross-platform apps for iOS, Android, and web. We use modern stacks and follow best practices for performance and security.'**
  String get appSvc2Body;

  /// No description provided for @appSvc2Highlight.
  ///
  /// In en, this message translates to:
  /// **'You get a production-ready app that feels fast and looks professional.'**
  String get appSvc2Highlight;

  /// No description provided for @appSvc3Title.
  ///
  /// In en, this message translates to:
  /// **'Testing & store submission'**
  String get appSvc3Title;

  /// No description provided for @appSvc3Body.
  ///
  /// In en, this message translates to:
  /// **'We test on real devices, fix bugs, and handle App Store and Google Play submission. From screenshots and descriptions to compliance checks, we get your app live.'**
  String get appSvc3Body;

  /// No description provided for @appSvc3Highlight.
  ///
  /// In en, this message translates to:
  /// **'One partner from final build to published app in both stores.'**
  String get appSvc3Highlight;

  /// No description provided for @appProcessTitle.
  ///
  /// In en, this message translates to:
  /// **'How your app gets built and published'**
  String get appProcessTitle;

  /// No description provided for @appProcessSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A single, guided process from first conversation to live apps on the App Store and Google Play.'**
  String get appProcessSubtitle;

  /// No description provided for @appProcessStep1Title.
  ///
  /// In en, this message translates to:
  /// **'1. Discovery & concept'**
  String get appProcessStep1Title;

  /// No description provided for @appProcessStep1Body.
  ///
  /// In en, this message translates to:
  /// **'We explore your goals, users, and constraints, then define a clear scope and feature set for your first release.'**
  String get appProcessStep1Body;

  /// No description provided for @appProcessStep2Title.
  ///
  /// In en, this message translates to:
  /// **'2. Design & prototyping'**
  String get appProcessStep2Title;

  /// No description provided for @appProcessStep2Body.
  ///
  /// In en, this message translates to:
  /// **'We create wireframes and high-fidelity designs, test flows with you, and finalise the look and feel before development.'**
  String get appProcessStep2Body;

  /// No description provided for @appProcessStep3Title.
  ///
  /// In en, this message translates to:
  /// **'3. Development & testing'**
  String get appProcessStep3Title;

  /// No description provided for @appProcessStep3Body.
  ///
  /// In en, this message translates to:
  /// **'We build the app, run automated and manual tests, and iterate until it meets your quality bar and performance targets.'**
  String get appProcessStep3Body;

  /// No description provided for @appProcessStep4Title.
  ///
  /// In en, this message translates to:
  /// **'4. Store submission & launch'**
  String get appProcessStep4Title;

  /// No description provided for @appProcessStep4Body.
  ///
  /// In en, this message translates to:
  /// **'We prepare store assets, submit to App Store and Google Play, and support you through review until your app goes live.'**
  String get appProcessStep4Body;

  /// No description provided for @appsPricingHeading.
  ///
  /// In en, this message translates to:
  /// **'Transparent pricing, tailored to your scope'**
  String get appsPricingHeading;

  /// No description provided for @appsPricingIntro.
  ///
  /// In en, this message translates to:
  /// **'Local pricing for Cambodia. Every project starts with a scoping call — we adjust scope and deliverables to match your goals. Use USD; approximate KHR available for marketing.'**
  String get appsPricingIntro;

  /// No description provided for @appsPricingSectionApps.
  ///
  /// In en, this message translates to:
  /// **'App development'**
  String get appsPricingSectionApps;

  /// No description provided for @appsPricingSectionWebsites.
  ///
  /// In en, this message translates to:
  /// **'Websites & landing pages'**
  String get appsPricingSectionWebsites;

  /// No description provided for @appsPricingSectionMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance & support'**
  String get appsPricingSectionMaintenance;

  /// No description provided for @appPlanMiniName.
  ///
  /// In en, this message translates to:
  /// **'Mini App / MVP'**
  String get appPlanMiniName;

  /// No description provided for @appPlanMiniStrapline.
  ///
  /// In en, this message translates to:
  /// **'Simple apps with core features. Ideal for booking forms, catalogs, internal tools.'**
  String get appPlanMiniStrapline;

  /// No description provided for @appPlanMiniBullet1.
  ///
  /// In en, this message translates to:
  /// **'3–5 screens'**
  String get appPlanMiniBullet1;

  /// No description provided for @appPlanMiniBullet2.
  ///
  /// In en, this message translates to:
  /// **'No backend or simple Firebase'**
  String get appPlanMiniBullet2;

  /// No description provided for @appPlanMiniBullet3.
  ///
  /// In en, this message translates to:
  /// **'Android only'**
  String get appPlanMiniBullet3;

  /// No description provided for @appPlanMiniBullet4.
  ///
  /// In en, this message translates to:
  /// **'Delivered in 2–4 weeks'**
  String get appPlanMiniBullet4;

  /// No description provided for @appPlanStandardName.
  ///
  /// In en, this message translates to:
  /// **'Standard Business App'**
  String get appPlanStandardName;

  /// No description provided for @appPlanStandardStrapline.
  ///
  /// In en, this message translates to:
  /// **'Our most popular for clinics, SMEs, and small POS systems.'**
  String get appPlanStandardStrapline;

  /// No description provided for @appPlanStandardBullet1.
  ///
  /// In en, this message translates to:
  /// **'8–15 screens'**
  String get appPlanStandardBullet1;

  /// No description provided for @appPlanStandardBullet2.
  ///
  /// In en, this message translates to:
  /// **'Firebase backend, auth, CRUD'**
  String get appPlanStandardBullet2;

  /// No description provided for @appPlanStandardBullet3.
  ///
  /// In en, this message translates to:
  /// **'Simple reports'**
  String get appPlanStandardBullet3;

  /// No description provided for @appPlanStandardBullet4.
  ///
  /// In en, this message translates to:
  /// **'Android (iOS + web add +30–50%)'**
  String get appPlanStandardBullet4;

  /// No description provided for @appPlanAdvancedName.
  ///
  /// In en, this message translates to:
  /// **'Advanced App'**
  String get appPlanAdvancedName;

  /// No description provided for @appPlanAdvancedStrapline.
  ///
  /// In en, this message translates to:
  /// **'Complex logic, multi-role, integrations, dashboards.'**
  String get appPlanAdvancedStrapline;

  /// No description provided for @appPlanAdvancedBullet1.
  ///
  /// In en, this message translates to:
  /// **'Large clinic or multi-branch POS'**
  String get appPlanAdvancedBullet1;

  /// No description provided for @appPlanAdvancedBullet2.
  ///
  /// In en, this message translates to:
  /// **'Delivery or marketplace apps'**
  String get appPlanAdvancedBullet2;

  /// No description provided for @appPlanAdvancedBullet3.
  ///
  /// In en, this message translates to:
  /// **'Custom backend and admin'**
  String get appPlanAdvancedBullet3;

  /// No description provided for @appPlanAdvancedBullet4.
  ///
  /// In en, this message translates to:
  /// **'Quote case-by-case'**
  String get appPlanAdvancedBullet4;

  /// No description provided for @appPlanLandingName.
  ///
  /// In en, this message translates to:
  /// **'Landing Page'**
  String get appPlanLandingName;

  /// No description provided for @appPlanLandingStrapline.
  ///
  /// In en, this message translates to:
  /// **'One-page site for Facebook sellers. Professional look in 3–5 days.'**
  String get appPlanLandingStrapline;

  /// No description provided for @appPlanLandingBullet1.
  ///
  /// In en, this message translates to:
  /// **'Single page'**
  String get appPlanLandingBullet1;

  /// No description provided for @appPlanLandingBullet2.
  ///
  /// In en, this message translates to:
  /// **'Contact form'**
  String get appPlanLandingBullet2;

  /// No description provided for @appPlanLandingBullet3.
  ///
  /// In en, this message translates to:
  /// **'Mobile-friendly'**
  String get appPlanLandingBullet3;

  /// No description provided for @appPlanStarterWebName.
  ///
  /// In en, this message translates to:
  /// **'Starter Web'**
  String get appPlanStarterWebName;

  /// No description provided for @appPlanStarterWebStrapline.
  ///
  /// In en, this message translates to:
  /// **'Micro businesses: salon, small shop, teacher.'**
  String get appPlanStarterWebStrapline;

  /// No description provided for @appPlanStarterWebBullet1.
  ///
  /// In en, this message translates to:
  /// **'1–3 pages'**
  String get appPlanStarterWebBullet1;

  /// No description provided for @appPlanStarterWebBullet2.
  ///
  /// In en, this message translates to:
  /// **'Template design'**
  String get appPlanStarterWebBullet2;

  /// No description provided for @appPlanStarterWebBullet3.
  ///
  /// In en, this message translates to:
  /// **'Basic contact form'**
  String get appPlanStarterWebBullet3;

  /// No description provided for @appPlanBasicBizName.
  ///
  /// In en, this message translates to:
  /// **'Basic Business'**
  String get appPlanBasicBizName;

  /// No description provided for @appPlanBasicBizStrapline.
  ///
  /// In en, this message translates to:
  /// **'SMEs, clinics, training centers.'**
  String get appPlanBasicBizStrapline;

  /// No description provided for @appPlanBasicBizBullet1.
  ///
  /// In en, this message translates to:
  /// **'5–8 pages'**
  String get appPlanBasicBizBullet1;

  /// No description provided for @appPlanBasicBizBullet2.
  ///
  /// In en, this message translates to:
  /// **'Custom layout from template'**
  String get appPlanBasicBizBullet2;

  /// No description provided for @appPlanBasicBizBullet3.
  ///
  /// In en, this message translates to:
  /// **'Simple blog/news, 1 language'**
  String get appPlanBasicBizBullet3;

  /// No description provided for @appPlanProBizName.
  ///
  /// In en, this message translates to:
  /// **'Pro Business'**
  String get appPlanProBizName;

  /// No description provided for @appPlanProBizStrapline.
  ///
  /// In en, this message translates to:
  /// **'Schools, NGOs, larger SMEs.'**
  String get appPlanProBizStrapline;

  /// No description provided for @appPlanProBizBullet1.
  ///
  /// In en, this message translates to:
  /// **'Up to ~12 pages'**
  String get appPlanProBizBullet1;

  /// No description provided for @appPlanProBizBullet2.
  ///
  /// In en, this message translates to:
  /// **'Bilingual Khmer/English'**
  String get appPlanProBizBullet2;

  /// No description provided for @appPlanProBizBullet3.
  ///
  /// In en, this message translates to:
  /// **'Booking form or product listing'**
  String get appPlanProBizBullet3;

  /// No description provided for @appPlanEcomName.
  ///
  /// In en, this message translates to:
  /// **'Small E-commerce'**
  String get appPlanEcomName;

  /// No description provided for @appPlanEcomStrapline.
  ///
  /// In en, this message translates to:
  /// **'Online shops, small brands.'**
  String get appPlanEcomStrapline;

  /// No description provided for @appPlanEcomBullet1.
  ///
  /// In en, this message translates to:
  /// **'20–80 products'**
  String get appPlanEcomBullet1;

  /// No description provided for @appPlanEcomBullet2.
  ///
  /// In en, this message translates to:
  /// **'Cart, checkout, payment'**
  String get appPlanEcomBullet2;

  /// No description provided for @appPlanEcomBullet3.
  ///
  /// In en, this message translates to:
  /// **'Basic admin to manage products'**
  String get appPlanEcomBullet3;

  /// No description provided for @appPlanHostingName.
  ///
  /// In en, this message translates to:
  /// **'Web hosting'**
  String get appPlanHostingName;

  /// No description provided for @appPlanHostingStrapline.
  ///
  /// In en, this message translates to:
  /// **'Keep your site secure and updated.'**
  String get appPlanHostingStrapline;

  /// No description provided for @appPlanHostingBullet1.
  ///
  /// In en, this message translates to:
  /// **'Basic: 10–20 — hosting, security, 2–4 edits'**
  String get appPlanHostingBullet1;

  /// No description provided for @appPlanHostingBullet2.
  ///
  /// In en, this message translates to:
  /// **'Pro: 30–50 — content updates, backups, priority support'**
  String get appPlanHostingBullet2;

  /// No description provided for @appPlanSupportName.
  ///
  /// In en, this message translates to:
  /// **'App support'**
  String get appPlanSupportName;

  /// No description provided for @appPlanSupportStrapline.
  ///
  /// In en, this message translates to:
  /// **'Bug fixes, tweaks, and new features.'**
  String get appPlanSupportStrapline;

  /// No description provided for @appPlanSupportBullet1.
  ///
  /// In en, this message translates to:
  /// **'Basic: 50–80 — fixes, minor UI, monitoring'**
  String get appPlanSupportBullet1;

  /// No description provided for @appPlanSupportBullet2.
  ///
  /// In en, this message translates to:
  /// **'Growth: 100–150 — new features, analytics, performance'**
  String get appPlanSupportBullet2;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'km', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'km':
      return AppLocalizationsKm();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
