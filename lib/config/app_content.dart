/// Central content and contact from INFORMATION_NEEDED.md.
/// Update here when client provides final copy.
class AppContent {
  AppContent._();

  // §1 Brand
  static const String companyName = 'Stonechat Communications';
  static const String shortName = 'Stonechat';
  static const String legalEntity = 'Stonechat Communications';

  // §3 Contact
  static const String phonePrimary = '012 222 211';
  static const String phoneSecondary = '090 222 211';
  static const String email = 'contact@stonechat.vip';
  static const String websiteUrl = 'https://www.stonechat.vip';
  /// WhatsApp: country code + number no spaces (e.g. 85512222211 for Cambodia 12 222 211)
  static const String whatsAppNumber = '85512222211';
  static const String addressLine = '#23-25, Street V07, Victory City, Steung Meanchey';

  // Office 1 (Cambodia / Phnom Penh)
  static const String office1Label = 'Cambodia Office';
  static const String office1Company = companyName;
  static const String office1Address = '#23-25, Street V07, Victory City, Steung Mean Chey, Phnom Penh, Cambodia, 12000';
  static const String office1Phone = '+855-12 222211';
  static const String office1PhoneSecondary = '+855 90 222 211';

  // §4 Social
  static const String facebookUrl = 'https://www.facebook.com/stonechat';
  static const String? instagramUrl = null;
  static const String tiktokUrl = 'https://www.tiktok.com/@stonechat';
  static const String? youtubeUrl = null;
  static const String telegramUrl = 'https://t.me/stonechat';
  static const String? linkedInUrl = null;

  /// Telegram group for Media & Posts dialog (same as telegramUrl)
  static const String telegramGroupUrl = 'https://t.me/stonechat';

  /// Training / Academy link
  static const String academyExploreUrl = 'https://www.stonechat.vip/academy';

  /// Apps & digital solutions
  static const String baziSystemUrl = 'https://www.stonechat.vip/apps';

  /// Clinic App – replace with real store URLs when available
  static const String? period9AppStoreUrl = null;
  static const String? period9PlayStoreUrl = null;

  /// Appointment booking API: POST booking details; backend sends SMS confirmation via Unimatrix.
  /// Leave empty to use demo mode (success UI only, no HTTP call).
  static const String appointmentBookingApiUrl = '';

  // Asset paths (§1, §2, §8, §9 – use images from assets folder)
  /// Logo for header; favicon can use same.
  static const String assetLogo = 'assets/icons/logo_with_name.png';
  static const String assetFavicon = 'assets/icons/logo_png_big.png';
  /// Hero section: fallback image and video.
  static const String assetHeroBackground = 'assets/images/hero_background.jpg';
  static const String assetHeroVideo = 'assets/videos/mainhero.mp4';
  /// Consultations/Feng Shui section background.
  static const String assetBackgroundDirection = 'assets/images/hero_background.jpg';
  /// Apps page: Stonechat system section video.
  static const String assetAppPageVideo = 'assets/videos/hero.mp4';
  /// Events section cards and main banner.
  static const String assetEventCard = 'assets/images/students.jpg';
  static const String assetEventMain = 'assets/images/students.jpg';
  /// Communications Training: AI-Enhanced event card.
  static const String assetEventAEnhanced = 'assets/images/Students2.jpg';
  /// Contact page hero background.
  static const String assetContactHero = 'assets/images/hero_background.jpg';
  /// Journey page hero background.
  static const String assetJourneyHero = 'assets/images/training_presentation.jpg';
  /// Story section image (portrait).
  static const String assetStoryBackground = 'assets/images/female_assistant2.jpg';
  /// Testimonials: single image for all testimonial cards (main page and events).
  static const String assetTestimonial = 'assets/images/testimonials/testimonials.jpg';
  /// Fallbacks when no per-testimonial image (now same as [assetTestimonial]).
  static const String assetTestimonialProfile = 'assets/images/testimonials/testimonials.jpg';
  static const String assetTestimonialParticipant = 'assets/images/testimonials/testimonials.jpg';
  /// Academy / training card image.
  static const String assetAcademy = 'assets/images/training_image.jpg';
  /// Consultation / appointments page (Smart Move cards).
  static const String assetConsultation = 'assets/images/female_assistant.jpg';
  /// Academy cards on main page (using logo/icon).
  static const String assetBaziHarmony = 'assets/icons/mainicon.png';
  static const String assetAcademyQiMen = 'assets/icons/mainicon.png';
  /// Feng Shui card image on main page.
  static const String assetAcademyFengShui = 'assets/images/hero_background.jpg';

  /// Home page services section (6 cards). Service order: App Development (Red), Responsive Web (Yellow), AI Agent (Teal), Book Creation Suite (Green), Communications Training (Purple), Custom Project (Black). Colors in AppColors.service*.
  static const String assetServiceAiAgent = 'assets/images/placeholders/Ai_agent.jpg';
  static const String assetServiceAppDevelopment = 'assets/images/placeholders/app_development.jpg';
  static const String assetServiceBookCreation = 'assets/images/placeholders/book_creation_suite.jpg';
  static const String assetServiceCommunicationsTraining = 'assets/images/placeholders/communications_training.jpg';
  static const String assetServiceCustomProject = 'assets/images/placeholders/custom_project.jpg';
  static const String assetServiceResponsiveWeb = 'assets/images/placeholders/responsive_web.jpg';

  // Apps page showcase
  /// Apps page hero banner.
  static const String assetAppsHero = 'assets/images/hero_background.jpg';
  /// App feature screenshots (using training/students imagery).
  static const String assetAppQiMen = 'assets/images/training_image.jpg';
  static const String assetAppBaziLife = 'assets/images/students.jpg';
  static const String assetAppBaziReport = 'assets/images/training_image.jpg';
  static const String assetAppBaziAge = 'assets/images/students.jpg';
  static const String assetAppBaziStars = 'assets/images/training_image.jpg';
  static const String assetAppBaziKhmer = 'assets/images/students.jpg';
  static const String assetAppBaziPage2 = 'assets/images/training_image.jpg';
  static const String assetAppDateSelection = 'assets/images/students.jpg';
  static const String assetAppMarriage = 'assets/images/training_image.jpg';
  static const String assetAppBusinessPartner = 'assets/images/students.jpg';
  static const String assetAppAdvancedFeatures = 'assets/images/training_image.jpg';
  /// Clinic app screenshots.
  static const String assetPeriod9_1 = 'assets/images/training_image.jpg';
  static const String assetPeriod9_2 = 'assets/images/students.jpg';
  /// Caishen Clinic Management System – 9 feature screenshots.
  static const String assetCaishenClinic1 = 'assets/images/apps/Caishen Clinic (1).jpg';
  static const String assetCaishenClinic2 = 'assets/images/apps/Caishen Clinic (2).jpg';
  static const String assetCaishenClinic3 = 'assets/images/apps/Caishen Clinic (3).jpg';
  static const String assetCaishenClinic4 = 'assets/images/apps/Caishen Clinic (4).jpg';
  static const String assetCaishenClinic5 = 'assets/images/apps/Caishen Clinic (5).jpg';
  static const String assetCaishenClinic6 = 'assets/images/apps/Caishen Clinic (6).jpg';
  static const String assetCaishenClinic7 = 'assets/images/apps/Caishen Clinic (7).jpg';
  static const String assetCaishenClinic8 = 'assets/images/apps/Caishen Clinic (8).jpg';
  static const String assetCaishenClinic9 = 'assets/images/apps/Caishen Clinic (9).jpg';

  /// Featured Mobile Apps cards (Period 9, Stonechat Bazi).
  static const String assetFeaturedApp1 = 'assets/images/apps/iphoneapp.jpg';
  static const String assetFeaturedApp2 = 'assets/images/apps/khmerai.jpg';

  /// Book store.
  static const String assetBook1 = 'assets/stores/books/period9book1.jpg';
  static const String assetBook2 = 'assets/stores/books/period9book2.jpg';

  // Publications (book covers and mockups).
  /// Chapter images for the 9 Book Store cards (The Art of Persuasion).
  static const String assetChapter1 = 'assets/images/publications/Chapter 1 - Branding & Communication Strategy.png';
  static const String assetChapter2 = 'assets/images/publications/Chapter 2 - Digital Communications Platform Design.png';
  static const String assetChapter3 = 'assets/images/publications/Chapter 3 - Engaging Your Audiences Online.png';
  static const String assetChapter4 = 'assets/images/publications/Chapter 4 - Speech Writing & Presentations.png';
  static const String assetChapter5 = 'assets/images/publications/Chapter 5 - Liaising With The Media.png';
  static const String assetChapter6 = 'assets/images/publications/Chapter 6 - Effective Communications.png';
  static const String assetChapter7 = 'assets/images/publications/Chapter 7 - Embracing Soft Power.png';
  static const String assetChapter8 = 'assets/images/publications/Chapter 8 - Crisis Management & Communications.png';
  static const String assetChapter9 = 'assets/images/publications/Chapter 9 - Communications for Organisational Change.png';
  static const String assetBookMockup = 'assets/images/publications/book_mockup.jpg';
  static const String assetBookMockup2 = 'assets/images/publications/book_mockup2.jpg';
  static const String assetBookMockup3 = 'assets/images/publications/book_mockup3.jpg';
  static const String assetBookPersuasionEng = 'assets/images/publications/book_persuasion_eng.jpg';
  static const String assetBookPersuasionEngBig = 'assets/images/publications/book_persuasion_eng_big.jpg';
  static const String assetBookPersuasionKhmer = 'assets/images/publications/book_persuasion_khmer.png';
  static const String assetBookPersuasionBack = 'assets/images/publications/book_persuasion_back.jpg';

  // Store / app icons.
  static const String assetLogoPngBig = 'assets/icons/logo_png_big.png';
  static const String assetAppStoreIcon = 'assets/icons/appstore_icon.png';
  static const String assetGooglePlayIcon = 'assets/icons/googleplay_icon.png';
}
