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
  /// **'Master'**
  String get charteredPractitioner;

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

  /// No description provided for @stonechatSystem.
  ///
  /// In en, this message translates to:
  /// **'Stonechat System'**
  String get stonechatSystem;

  /// No description provided for @period9MobileApp.
  ///
  /// In en, this message translates to:
  /// **'Period 9 Mobile App'**
  String get period9MobileApp;

  /// No description provided for @talismanStore.
  ///
  /// In en, this message translates to:
  /// **'Talisman Store'**
  String get talismanStore;

  /// No description provided for @appsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Apps & Store'**
  String get appsPageTitle;

  /// No description provided for @appsPageSubline.
  ///
  /// In en, this message translates to:
  /// **'Digital tools, apps, training, and books—all in one place.'**
  String get appsPageSubline;

  /// No description provided for @appsPageDescription.
  ///
  /// In en, this message translates to:
  /// **'We build modern apps and digital solutions. Browse our development services, communication training, and book publishing. Get in touch and we\'ll help you find the right fit.'**
  String get appsPageDescription;

  /// No description provided for @appsPageDescriptionHighlight.
  ///
  /// In en, this message translates to:
  /// **'modern apps'**
  String get appsPageDescriptionHighlight;

  /// No description provided for @appsFeatureShowcaseHeading.
  ///
  /// In en, this message translates to:
  /// **'What we offer'**
  String get appsFeatureShowcaseHeading;

  /// No description provided for @appsFeatureShowcaseMarketingDesc.
  ///
  /// In en, this message translates to:
  /// **'App and website development, communication skills training, and book publishing. We use clear, human language so you stay informed and confident.'**
  String get appsFeatureShowcaseMarketingDesc;

  /// No description provided for @appsFeatureShowcaseMarketingHighlight.
  ///
  /// In en, this message translates to:
  /// **'clear, human language'**
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
  /// **'Talismans'**
  String get marketplaceCategoryTalismans;

  /// No description provided for @stonechatSpotlightTitle.
  ///
  /// In en, this message translates to:
  /// **'App & website development'**
  String get stonechatSpotlightTitle;

  /// No description provided for @stonechatSpotlightDesc.
  ///
  /// In en, this message translates to:
  /// **'We develop modern, beautiful, affordable apps for Web, Desktop, macOS, iOS, and Android. Clean architectures, elegant interfaces—high-quality products without breaking the bank.'**
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
  /// **'Period 9 Mobile App'**
  String get period9SpotlightTitle;

  /// No description provided for @period9SpotlightDesc.
  ///
  /// In en, this message translates to:
  /// **'Carry Period 9 Feng Shui and timing insights in your pocket. Available on iOS and Android.'**
  String get period9SpotlightDesc;

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
  /// **'Talisman Store'**
  String get talismanStoreSpotlightTitle;

  /// No description provided for @talismanStoreSpotlightDesc.
  ///
  /// In en, this message translates to:
  /// **'Curated talismans and remedies. Add to cart and we\'ll contact you to complete your order.'**
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
  /// **'Protection Talisman'**
  String get talismanProduct1Title;

  /// No description provided for @talismanProduct2Title.
  ///
  /// In en, this message translates to:
  /// **'Wealth Charm'**
  String get talismanProduct2Title;

  /// No description provided for @talismanProduct3Title.
  ///
  /// In en, this message translates to:
  /// **'Health Amulet'**
  String get talismanProduct3Title;

  /// No description provided for @talismanProduct4Title.
  ///
  /// In en, this message translates to:
  /// **'Love & Harmony'**
  String get talismanProduct4Title;

  /// No description provided for @talismanProduct5Title.
  ///
  /// In en, this message translates to:
  /// **'Career Success'**
  String get talismanProduct5Title;

  /// No description provided for @talismanProduct6Title.
  ///
  /// In en, this message translates to:
  /// **'Peace & Calm'**
  String get talismanProduct6Title;

  /// No description provided for @talismanProduct7Title.
  ///
  /// In en, this message translates to:
  /// **'Travel Protection'**
  String get talismanProduct7Title;

  /// No description provided for @talismanProduct8Title.
  ///
  /// In en, this message translates to:
  /// **'Home Blessing'**
  String get talismanProduct8Title;

  /// No description provided for @talismanProduct9Title.
  ///
  /// In en, this message translates to:
  /// **'Wisdom Pendant'**
  String get talismanProduct9Title;

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
  /// **'Apps in your pocket.'**
  String get period9SpotlightTagline;

  /// No description provided for @period9SpotlightTaglineHighlight.
  ///
  /// In en, this message translates to:
  /// **'pocket'**
  String get period9SpotlightTaglineHighlight;

  /// No description provided for @talismanStoreSpotlightTagline.
  ///
  /// In en, this message translates to:
  /// **'Wear your protection.'**
  String get talismanStoreSpotlightTagline;

  /// No description provided for @talismanStoreSpotlightTaglineHighlight.
  ///
  /// In en, this message translates to:
  /// **'protection'**
  String get talismanStoreSpotlightTaglineHighlight;

  /// No description provided for @bookStoreSectionHeading.
  ///
  /// In en, this message translates to:
  /// **'Book publishing & authoring'**
  String get bookStoreSectionHeading;

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
  /// **'We support authors and organizations from concept development to writing, editing, book design (layout and cover), and final publishing. Everything you need to go from idea to published book, smoothly and efficiently.'**
  String get bookStoreSectionMarketing;

  /// No description provided for @bookStoreSectionMarketingHighlight.
  ///
  /// In en, this message translates to:
  /// **'idea to published book'**
  String get bookStoreSectionMarketingHighlight;

  /// No description provided for @bookStoreBook1Title.
  ///
  /// In en, this message translates to:
  /// **'Period 9 Feng Shui — Volume 1'**
  String get bookStoreBook1Title;

  /// No description provided for @bookStoreBook1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Foundations & Flying Stars'**
  String get bookStoreBook1Subtitle;

  /// No description provided for @bookStoreBook1Price.
  ///
  /// In en, this message translates to:
  /// **'24.99'**
  String get bookStoreBook1Price;

  /// No description provided for @bookStoreBook2Title.
  ///
  /// In en, this message translates to:
  /// **'Period 9 Feng Shui — Volume 2'**
  String get bookStoreBook2Title;

  /// No description provided for @bookStoreBook2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Advanced Applications'**
  String get bookStoreBook2Subtitle;

  /// No description provided for @bookStoreBook2Price.
  ///
  /// In en, this message translates to:
  /// **'24.99'**
  String get bookStoreBook2Price;

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
  /// **'News & Events'**
  String get newsAndEvents;

  /// No description provided for @mediaAndPosts.
  ///
  /// In en, this message translates to:
  /// **'Media & Posts'**
  String get mediaAndPosts;

  /// No description provided for @mediaPostsFacebookTitle.
  ///
  /// In en, this message translates to:
  /// **'Posts & updates'**
  String get mediaPostsFacebookTitle;

  /// No description provided for @mediaPostsFacebookBody.
  ///
  /// In en, this message translates to:
  /// **'Our latest posts, event updates and news are on our Facebook page. Follow us for updates.'**
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
  /// **'Our story'**
  String get journey;

  /// No description provided for @ourMethod.
  ///
  /// In en, this message translates to:
  /// **'What we do'**
  String get ourMethod;

  /// No description provided for @events.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get events;

  /// No description provided for @eventsCalendar.
  ///
  /// In en, this message translates to:
  /// **'Events Calendar'**
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
  /// **'Quality apps. Without breaking the bank.'**
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
  /// **'. Without breaking the bank.'**
  String get heroHeadline1Suffix;

  /// No description provided for @heroHeadline2Prefix.
  ///
  /// In en, this message translates to:
  /// **'Modern, beautiful, affordable apps for '**
  String get heroHeadline2Prefix;

  /// No description provided for @heroHeadline2Highlight.
  ///
  /// In en, this message translates to:
  /// **'Web, Desktop, iOS & Android.'**
  String get heroHeadline2Highlight;

  /// No description provided for @heroSubline.
  ///
  /// In en, this message translates to:
  /// **'Apps & digital solutions studio'**
  String get heroSubline;

  /// No description provided for @exploreAllEvents.
  ///
  /// In en, this message translates to:
  /// **'Explore All Events'**
  String get exploreAllEvents;

  /// No description provided for @comingUpNext.
  ///
  /// In en, this message translates to:
  /// **'Coming Up Next'**
  String get comingUpNext;

  /// No description provided for @allUpcomingEvents.
  ///
  /// In en, this message translates to:
  /// **'All Upcoming Events'**
  String get allUpcomingEvents;

  /// No description provided for @limitedSeats.
  ///
  /// In en, this message translates to:
  /// **'Limited seats'**
  String get limitedSeats;

  /// No description provided for @viewEvent.
  ///
  /// In en, this message translates to:
  /// **'View Event'**
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

  /// No description provided for @finalCtaBody.
  ///
  /// In en, this message translates to:
  /// **'Send a message, give us a call, or visit our website. We\'ll get back to you in a clear, friendly way.'**
  String get finalCtaBody;

  /// No description provided for @notSureWhereToStart.
  ///
  /// In en, this message translates to:
  /// **'Not sure where to start?'**
  String get notSureWhereToStart;

  /// No description provided for @notSureBody.
  ///
  /// In en, this message translates to:
  /// **'We\'re here to help. Tell us what you need—an app, a website, training, or a book—and we\'ll guide you in clear, human terms. No technical runaround.'**
  String get notSureBody;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @sectionExperienceHeading.
  ///
  /// In en, this message translates to:
  /// **'Clean architectures. Elegant interfaces. Low cost.'**
  String get sectionExperienceHeading;

  /// No description provided for @sectionExperienceHeadingPrefix.
  ///
  /// In en, this message translates to:
  /// **'Clean architectures. Elegant '**
  String get sectionExperienceHeadingPrefix;

  /// No description provided for @sectionExperienceHeadingHighlight.
  ///
  /// In en, this message translates to:
  /// **'interfaces. Low cost.'**
  String get sectionExperienceHeadingHighlight;

  /// No description provided for @sectionKnowledgeHeading.
  ///
  /// In en, this message translates to:
  /// **'We deliver quality without the high price.'**
  String get sectionKnowledgeHeading;

  /// No description provided for @sectionKnowledgeBody.
  ///
  /// In en, this message translates to:
  /// **'We build modern, beautiful, affordable apps for Web, Desktop, macOS, iOS, and Android. Clean, solid-standard architectures with user-friendly interfaces so individuals and businesses get high-quality products without breaking the bank.'**
  String get sectionKnowledgeBody;

  /// No description provided for @sectionKnowledgeBody2.
  ///
  /// In en, this message translates to:
  /// **'We support Khmer, English, and Chinese—and we can add more languages. Fast turnaround so you don\'t wait for months; we prioritize speed without sacrificing quality.'**
  String get sectionKnowledgeBody2;

  /// No description provided for @sectionKnowledgeStat.
  ///
  /// In en, this message translates to:
  /// **'3+ languages'**
  String get sectionKnowledgeStat;

  /// No description provided for @sectionMapHeading.
  ///
  /// In en, this message translates to:
  /// **'You don\'t need jargon. You need a partner.'**
  String get sectionMapHeading;

  /// No description provided for @sectionMapIntro.
  ///
  /// In en, this message translates to:
  /// **'We communicate in a clear, human tone so non-technical clients feel comfortable, informed, and confident. Tell us your idea—we\'ll help you get there.'**
  String get sectionMapIntro;

  /// No description provided for @sectionStoryHeading.
  ///
  /// In en, this message translates to:
  /// **'Who we are.'**
  String get sectionStoryHeading;

  /// No description provided for @sectionStoryPara1.
  ///
  /// In en, this message translates to:
  /// **'Stonechat Communications is a handy apps and digital solutions studio. We develop modern, beautiful, affordable applications for Web, Desktop, macOS, iOS, and Android.'**
  String get sectionStoryPara1;

  /// No description provided for @sectionStoryPara2.
  ///
  /// In en, this message translates to:
  /// **'We focus on clean, solid-standard app architectures with elegant, user-friendly interfaces at a low cost. We support Khmer, English, and Chinese and are flexible to add more languages.'**
  String get sectionStoryPara2;

  /// No description provided for @sectionStoryPara3.
  ///
  /// In en, this message translates to:
  /// **'We value fast turnaround and clear communication. In every interaction we use a human tone so you feel comfortable and confident throughout the process.'**
  String get sectionStoryPara3;

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
  /// **'Training'**
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
  /// **'More courses and schedules will be announced here. Contact us for early access or custom group sessions.'**
  String get academyMoreCoursesNote;

  /// No description provided for @consult1Category.
  ///
  /// In en, this message translates to:
  /// **'App & website development'**
  String get consult1Category;

  /// No description provided for @consult1Method.
  ///
  /// In en, this message translates to:
  /// **'Development'**
  String get consult1Method;

  /// No description provided for @consult1Question.
  ///
  /// In en, this message translates to:
  /// **'Need a modern app or website?'**
  String get consult1Question;

  /// No description provided for @consult1Desc.
  ///
  /// In en, this message translates to:
  /// **'We build for Web, Desktop, macOS, iOS, and Android. Clean architectures, elegant interfaces, affordable pricing. Get in touch and we\'ll find the right solution for you.'**
  String get consult1Desc;

  /// No description provided for @consult2Category.
  ///
  /// In en, this message translates to:
  /// **'Communication training'**
  String get consult2Category;

  /// No description provided for @consult2Method.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get consult2Method;

  /// No description provided for @consult2Question.
  ///
  /// In en, this message translates to:
  /// **'Want to sharpen your communication skills?'**
  String get consult2Question;

  /// No description provided for @consult2Desc.
  ///
  /// In en, this message translates to:
  /// **'We offer The Art of Human-Centered Communication for general skills and The Art of AI-Enhanced Communication for working effectively with AI tools. Clear, practical training.'**
  String get consult2Desc;

  /// No description provided for @consult3Category.
  ///
  /// In en, this message translates to:
  /// **'Book publishing & authoring'**
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
  /// **'From concept to finished book—writing, editing, design (layout and cover), and publishing. We support authors and organizations every step of the way. Everything in one place.'**
  String get consult3Desc;

  /// No description provided for @consult4Category.
  ///
  /// In en, this message translates to:
  /// **'Custom project'**
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
  /// **'We\'re flexible. Whether it\'s a blend of development, training, or publishing—or something new—tell us your idea and we\'ll help you get there in clear, human terms.'**
  String get consult4Desc;

  /// No description provided for @consult5Category.
  ///
  /// In en, this message translates to:
  /// **'Training workshops'**
  String get consult5Category;

  /// No description provided for @consult5Method.
  ///
  /// In en, this message translates to:
  /// **'Workshops'**
  String get consult5Method;

  /// No description provided for @consult5Question.
  ///
  /// In en, this message translates to:
  /// **'Team or group training?'**
  String get consult5Question;

  /// No description provided for @consult5Desc.
  ///
  /// In en, this message translates to:
  /// **'We run workshops on communication skills and AI-enhanced communication. We can tailor sessions for your organization and schedule. Fast turnaround.'**
  String get consult5Desc;

  /// No description provided for @consult6Category.
  ///
  /// In en, this message translates to:
  /// **'Books & resources'**
  String get consult6Category;

  /// No description provided for @consult6Method.
  ///
  /// In en, this message translates to:
  /// **'Resources'**
  String get consult6Method;

  /// No description provided for @consult6Question.
  ///
  /// In en, this message translates to:
  /// **'Books and resources from Stonechat.'**
  String get consult6Question;

  /// No description provided for @consult6Desc.
  ///
  /// In en, this message translates to:
  /// **'Our’ publishing and authoring services help you go from idea to finished book. We also offer training materials and resources. Get in touch for more.'**
  String get consult6Desc;

  /// No description provided for @stickyCtaText.
  ///
  /// In en, this message translates to:
  /// **'Get in touch'**
  String get stickyCtaText;

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

  /// No description provided for @eventsCalendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Workshops & events'**
  String get eventsCalendarTitle;

  /// No description provided for @eventsHeroHeadline.
  ///
  /// In en, this message translates to:
  /// **'Workshops and events'**
  String get eventsHeroHeadline;

  /// No description provided for @eventsHeroSubline.
  ///
  /// In en, this message translates to:
  /// **'Training, launches, and community. Clear and practical.'**
  String get eventsHeroSubline;

  /// No description provided for @eventsSubline.
  ///
  /// In en, this message translates to:
  /// **'Where learning meets doing.'**
  String get eventsSubline;

  /// No description provided for @eventsDescription.
  ///
  /// In en, this message translates to:
  /// **'Join our workshops on communication skills, app demos, or publishing. We keep things clear and practical. Khmer, English, and Chinese supported.'**
  String get eventsDescription;

  /// No description provided for @eventsDescriptionHighlight.
  ///
  /// In en, this message translates to:
  /// **'communication skills, app demos, or publishing'**
  String get eventsDescriptionHighlight;

  /// No description provided for @eventsWhyAttendTitle.
  ///
  /// In en, this message translates to:
  /// **'Why join our events'**
  String get eventsWhyAttendTitle;

  /// No description provided for @eventsWhyAttendLead.
  ///
  /// In en, this message translates to:
  /// **'Hands-on training in human-centered and AI-enhanced communication. App and publishing insights. A friendly, no-jargon environment.'**
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
  /// **'Upcoming Events'**
  String get eventsUpcomingHeadline;

  /// No description provided for @eventsUpcomingSubline.
  ///
  /// In en, this message translates to:
  /// **'Choose your event and secure your seat. We can\'t wait to see you there.'**
  String get eventsUpcomingSubline;

  /// No description provided for @secureYourSeat.
  ///
  /// In en, this message translates to:
  /// **'Book your seat'**
  String get secureYourSeat;

  /// No description provided for @searchEvent.
  ///
  /// In en, this message translates to:
  /// **'Search event…'**
  String get searchEvent;

  /// No description provided for @registerForEvent.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerForEvent;

  /// No description provided for @eventColumn.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get eventColumn;

  /// No description provided for @eventRegTitle.
  ///
  /// In en, this message translates to:
  /// **'Event Registration'**
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
  /// **'We will confirm your seat by email or phone. See you at the event!'**
  String get eventRegSuccessNote;

  /// No description provided for @noEventsMatch.
  ///
  /// In en, this message translates to:
  /// **'No events match your search.'**
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
  /// **'A handy apps and digital solutions studio.'**
  String get aboutHeroHeadline;

  /// No description provided for @aboutBullet1.
  ///
  /// In en, this message translates to:
  /// **'Modern, beautiful, affordable apps for Web, Desktop, macOS, iOS & Android.'**
  String get aboutBullet1;

  /// No description provided for @aboutBullet2.
  ///
  /// In en, this message translates to:
  /// **'Clean architectures. Elegant interfaces. Without breaking the bank.'**
  String get aboutBullet2;

  /// No description provided for @aboutBullet3.
  ///
  /// In en, this message translates to:
  /// **'Khmer, English, Chinese—and we can add more languages. Fast turnaround.'**
  String get aboutBullet3;

  /// No description provided for @aboutBullet4.
  ///
  /// In en, this message translates to:
  /// **'Clear, human communication so you feel comfortable and confident.'**
  String get aboutBullet4;

  /// No description provided for @journeyPageHeadline.
  ///
  /// In en, this message translates to:
  /// **'Our story'**
  String get journeyPageHeadline;

  /// No description provided for @journeyHeroSubline.
  ///
  /// In en, this message translates to:
  /// **'A handy apps and digital solutions studio. Modern, beautiful, affordable.'**
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
  /// **'We develop apps and digital solutions, offer communication training, and support book publishing. Discover more below.'**
  String get journeyHeroSpotlightDesc;

  /// No description provided for @journeyHeroSpotlightCta.
  ///
  /// In en, this message translates to:
  /// **'Read the story'**
  String get journeyHeroSpotlightCta;

  /// No description provided for @journeyStory1.
  ///
  /// In en, this message translates to:
  /// **'Stonechat Communications is a handy apps and digital solutions studio. We develop modern, beautiful, affordable applications for Web, Desktop, macOS, iOS, and Android.'**
  String get journeyStory1;

  /// No description provided for @journeyStory2.
  ///
  /// In en, this message translates to:
  /// **'We focus on clean, solid-standard architectures and elegant, user-friendly interfaces at a low cost—so individuals and businesses can get high-quality products without breaking the bank. We support Khmer, English, and Chinese, and we\'re flexible to add more languages.'**
  String get journeyStory2;

  /// No description provided for @journeyStory3.
  ///
  /// In en, this message translates to:
  /// **'We value fast turnaround so our clients don\'t get stuck waiting for months; we prioritize speed without sacrificing quality. In every interaction we use a clear, human tone so non-technical clients feel comfortable, informed, and confident.'**
  String get journeyStory3;

  /// No description provided for @journeyPeriod9Title.
  ///
  /// In en, this message translates to:
  /// **'Communication training'**
  String get journeyPeriod9Title;

  /// No description provided for @journeyPeriod9Body.
  ///
  /// In en, this message translates to:
  /// **'We provide communication skills training: The Art of Human-Centered Communication for general skills, and The Art of AI-Enhanced Communication for communicating effectively with and through AI tools. Clear, practical, no jargon.'**
  String get journeyPeriod9Body;

  /// No description provided for @journeyPhoenixTitle.
  ///
  /// In en, this message translates to:
  /// **'Book publishing & authoring'**
  String get journeyPhoenixTitle;

  /// No description provided for @journeyPhoenixBody.
  ///
  /// In en, this message translates to:
  /// **'We\'re also experts in book publishing and authoring. We support authors and organizations from concept development to writing, editing, book design (layout and cover), and final publishing. Everything in one place—from idea to finished book, smoothly and efficiently.'**
  String get journeyPhoenixBody;

  /// No description provided for @methodPageHeadline.
  ///
  /// In en, this message translates to:
  /// **'What we do'**
  String get methodPageHeadline;

  /// No description provided for @methodIntro.
  ///
  /// In en, this message translates to:
  /// **'We offer three main areas: app and website development, communication skills training, and book publishing. Below is how we work and what you can expect. We keep our language clear and human so you stay informed.'**
  String get methodIntro;

  /// No description provided for @methodBaZiTitle.
  ///
  /// In en, this message translates to:
  /// **'App & website development'**
  String get methodBaZiTitle;

  /// No description provided for @methodBaZiBody.
  ///
  /// In en, this message translates to:
  /// **'We develop modern, beautiful, affordable apps for Web, Desktop, macOS, iOS, and Android. We focus on clean, solid-standard architectures and elegant, user-friendly interfaces at a low cost so individuals and businesses get high-quality products without breaking the bank.'**
  String get methodBaZiBody;

  /// No description provided for @methodQimenTitle.
  ///
  /// In en, this message translates to:
  /// **'Communication training'**
  String get methodQimenTitle;

  /// No description provided for @methodQimenBody.
  ///
  /// In en, this message translates to:
  /// **'We offer two main courses: The Art of Human-Centered Communication for general communication skills, and The Art of AI-Enhanced Communication for communicating effectively with and through AI tools. We use clear, human language—no jargon—so you feel comfortable and confident.'**
  String get methodQimenBody;

  /// No description provided for @methodIChingTitle.
  ///
  /// In en, this message translates to:
  /// **'Book publishing & authoring'**
  String get methodIChingTitle;

  /// No description provided for @methodIChingBody.
  ///
  /// In en, this message translates to:
  /// **'We support authors and organizations from concept development to writing, editing, book design (layout and cover), and final publishing. Everything in one place so you can go from idea to finished, published book smoothly and efficiently.'**
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
  /// **'Whether you need an app, a website, training, or help publishing a book—we\'re here. We use clear, human language so you feel comfortable and informed. Choose a topic, leave your message, and we\'ll get back to you shortly.'**
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
  /// **'Stonechat - The Rise of Phoenix 2026'**
  String get event1Title;

  /// No description provided for @event1Description.
  ///
  /// In en, this message translates to:
  /// **'The Master Revelation.'**
  String get event1Description;

  /// No description provided for @event1Location.
  ///
  /// In en, this message translates to:
  /// **'Phnom Penh'**
  String get event1Location;

  /// No description provided for @event2Title.
  ///
  /// In en, this message translates to:
  /// **'Feng Shui & Astrology 2026'**
  String get event2Title;

  /// No description provided for @event2Description.
  ///
  /// In en, this message translates to:
  /// **'The Singapore Edition of Feng Shui & Astrology 2026 live event.'**
  String get event2Description;

  /// No description provided for @event2Location.
  ///
  /// In en, this message translates to:
  /// **'Resorts World Sentosa, Singapore'**
  String get event2Location;

  /// No description provided for @event3Title.
  ///
  /// In en, this message translates to:
  /// **'Crimson Horse QiMen'**
  String get event3Title;

  /// No description provided for @event3Description.
  ///
  /// In en, this message translates to:
  /// **'The Art of War In The Year of the Fire Horse'**
  String get event3Description;

  /// No description provided for @event3Location.
  ///
  /// In en, this message translates to:
  /// **'Resorts World Singapore'**
  String get event3Location;

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
  /// **'Navigate'**
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
  /// **'Event Registration: '**
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
