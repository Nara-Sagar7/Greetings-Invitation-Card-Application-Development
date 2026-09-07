/// Global constants - PRD Section 06, 09
class AppConstants {
  static const appName = 'Greetings';
  static const appTagline = 'What you see is what they get.';

  // PRD Gates & Limits
  static const maxImageSizeMB = 5;
  static const maxImageSizeBytes = 5 * 1024 * 1024;
  static const compressedImageWidth = 1080; // 1080p WebP
  static const canvasPixelRatio = 2.0; // PRD 05 precision spec
  static const mailTesterGate = 9.0; // 9/10 required
  static const maxFreeEventsPerMonth = 3;
  static const maxFreeCardsPerMonth = 5;

  // Premium pricing placeholders (to be set by billing)
  static const premiumMonthlyPrice = '₹149';
  static const premiumAnnualPrice = '₹999';

  // Offline conflict rule: local wins
  static const offlineLabel = 'Saved — will send when you\'re back online';

  // RSVP options
  static const rsvpYes = 'yes';
  static const rsvpNo = 'no';
  static const rsvpMaybe = 'maybe';

  // Support
  static const supportEmail = 'support@greetings.app';
}
