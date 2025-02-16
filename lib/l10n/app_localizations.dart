import 'package:escooter/core/locale/providers/data/locale_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:escooter/core/configs/constants/app_localization_constants.dart';

final appLocalizationsProvider = Provider<AppLocalizations>((ref) {
  final locale = ref.watch(localeProvider);
  return AppLocalizations(locale);
});

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    AppLocalizationConstants.en: {
      // Authentication
      AppLocalizationConstants.phoneNumber: 'Phone Number',
      AppLocalizationConstants.enterOTP: 'Enter OTP',
      AppLocalizationConstants.verifyOTP: 'Verify OTP',

      // Scooter Related
      AppLocalizationConstants.findNearby: 'Find Nearby Scooters',
      AppLocalizationConstants.scanQR: 'Scan QR Code',
      AppLocalizationConstants.startRide: 'Start Ride',
      AppLocalizationConstants.endRide: 'End Ride',
      AppLocalizationConstants.pauseRide: 'Pause Ride',
      AppLocalizationConstants.resumeRide: 'Resume Ride',

      // Wallet
      AppLocalizationConstants.wallet: 'Wallet',
      AppLocalizationConstants.addMoney: 'Add Money',
      AppLocalizationConstants.transactions: 'Transactions',

      // Profile
      AppLocalizationConstants.profile: 'Profile',
      AppLocalizationConstants.editProfile: 'Edit Profile',
      AppLocalizationConstants.settings: 'Settings',
      AppLocalizationConstants.language: 'Language',

      // Ride Status
      AppLocalizationConstants.searching: 'Searching for Scooters',
      AppLocalizationConstants.rideInProgress: 'Ride in Progress',
      AppLocalizationConstants.timeElapsed: 'Time Elapsed',
      AppLocalizationConstants.distance: 'Distance',
      AppLocalizationConstants.cost: 'Cost',

      //Others
      AppLocalizationConstants.english: 'English',
      AppLocalizationConstants.arabic: 'Arabic',
      AppLocalizationConstants.guest: 'Guest',
      AppLocalizationConstants.account: 'Account',
      AppLocalizationConstants.logout: 'Logout',
      AppLocalizationConstants.gender: 'Gender',

      //Settings
      AppLocalizationConstants.appearance: 'Appearance',
      AppLocalizationConstants.darkMode: 'Dark Mode',
      AppLocalizationConstants.lightMode: 'Light Mode',
      AppLocalizationConstants.langAndRegion: 'Language and Region',
      AppLocalizationConstants.notifications: 'Notifications',
      AppLocalizationConstants.pushNotifications: 'Push Notifications',
      AppLocalizationConstants.emailNotifications: 'Email Notifications',
      AppLocalizationConstants.about: 'About',
      AppLocalizationConstants.appVersion: 'App Version',
      AppLocalizationConstants.privacyPolicy: 'Privacy Policy',
      AppLocalizationConstants.termsOfService: 'Terms of Service',

      // OTP Screen
      AppLocalizationConstants.otpSentTo: 'OTP sent to',
      AppLocalizationConstants.resendIn: 'Resend in',
      AppLocalizationConstants.seconds: 'seconds',
      AppLocalizationConstants.resendOtp: 'Resend OTP',
      AppLocalizationConstants.verifyOtp: 'Verify OTP',
      AppLocalizationConstants.paymentMethods: 'Payment Methods',
      AppLocalizationConstants.seeAll: 'See All',
      AppLocalizationConstants.addNewPaymentMethod: 'Add New Payment Method',

      // Drawer
      AppLocalizationConstants.helpAndSupport: 'Help & Support',

      // Ride Related
      AppLocalizationConstants.rideEnded: 'Ride Ended',
      AppLocalizationConstants.rideEndedSuccessfully:
          'Your ride has been ended successfully.',
      AppLocalizationConstants.failedToEndRide: 'Failed to end ride',
      AppLocalizationConstants.batteryLevel: 'Battery Level',
      AppLocalizationConstants.lastStation: 'Last Station',
      AppLocalizationConstants.scooterStatus: 'Status',
      AppLocalizationConstants.ok: 'OK',
      AppLocalizationConstants.error: 'Error',
    },
    AppLocalizationConstants.ar: {
      // Authentication
      AppLocalizationConstants.phoneNumber: 'رقم الهاتف',
      AppLocalizationConstants.enterOTP: 'أدخل رمز التحقق',
      AppLocalizationConstants.verifyOTP: 'تحقق من الرمز',

      // Scooter Related
      AppLocalizationConstants.findNearby: 'ابحث عن سكوتر قريب',
      AppLocalizationConstants.scanQR: 'مسح رمز QR',
      AppLocalizationConstants.startRide: 'ابدأ الرحلة',
      AppLocalizationConstants.endRide: 'إنهاء الرحلة',
      AppLocalizationConstants.pauseRide: 'إيقاف مؤقت',
      AppLocalizationConstants.resumeRide: 'استئناف الرحلة',

      // Wallet
      AppLocalizationConstants.wallet: 'المحفظة',
      AppLocalizationConstants.addMoney: 'إضافة رصيد',
      AppLocalizationConstants.transactions: 'المعاملات',

      // Profile
      AppLocalizationConstants.profile: 'الملف الشخصي',
      AppLocalizationConstants.editProfile: 'تعديل الملف',
      AppLocalizationConstants.settings: 'الإعدادات',
      AppLocalizationConstants.language: 'اللغة',

      // Ride Status
      AppLocalizationConstants.searching: 'البحث عن سكوتر',
      AppLocalizationConstants.rideInProgress: 'رحلة جارية',
      AppLocalizationConstants.timeElapsed: 'الوقت المنقضي',
      AppLocalizationConstants.distance: 'المسافة',
      AppLocalizationConstants.cost: 'التكلفة',

      //Others
      AppLocalizationConstants.english: 'الإنجليزية',
      AppLocalizationConstants.arabic: 'العربية',
      AppLocalizationConstants.guest: 'زائر',
      AppLocalizationConstants.account: 'الحساب',
      AppLocalizationConstants.logout: 'تسجيل الخروج',
      AppLocalizationConstants.gender: 'الجنس',

      //Settings
      AppLocalizationConstants.appearance: 'المظهر',
      AppLocalizationConstants.darkMode: 'الوضع الداكن',
      AppLocalizationConstants.lightMode: 'الوضع الفاتح',
      AppLocalizationConstants.langAndRegion: 'اللغة والمنطقة',
      AppLocalizationConstants.notifications: 'الإشعارات',
      AppLocalizationConstants.pushNotifications: 'إشعارات الدفع',
      AppLocalizationConstants.emailNotifications: 'إشعارات البريد الإلكتروني',
      AppLocalizationConstants.about: 'حول',
      AppLocalizationConstants.appVersion: 'إصدار التطبيق',
      AppLocalizationConstants.privacyPolicy: 'سياسة الخصوصية',
      AppLocalizationConstants.termsOfService: 'شروط الخدمة',

      // OTP Sreen
      AppLocalizationConstants.otpSentTo: 'تم إرسال رمز التحقق إلى',
      AppLocalizationConstants.resendOtp: 'إعادة إرسال رمز التحقق',
      AppLocalizationConstants.verifyOtp: 'تحقق من الرمز',
      AppLocalizationConstants.seconds: 'ثواني',
      AppLocalizationConstants.resendIn: 'إعادة إرسال في',
      AppLocalizationConstants.paymentMethods: 'طرق الدفع',
      AppLocalizationConstants.seeAll: 'عرض الكل',
      AppLocalizationConstants.addNewPaymentMethod: 'إضافة طريقة دفع جديدة',

      // Drawer
      AppLocalizationConstants.helpAndSupport: 'المساعدة والدعم',

      // Ride Related
      AppLocalizationConstants.rideEnded: 'انتهت الرحلة',
      AppLocalizationConstants.rideEndedSuccessfully: 'تم إنهاء رحلتك بنجاح',
      AppLocalizationConstants.failedToEndRide: 'فشل في إنهاء الرحلة',
      AppLocalizationConstants.batteryLevel: 'مستوى البطارية',
      AppLocalizationConstants.lastStation: 'المحطة الأخيرة',
      AppLocalizationConstants.scooterStatus: 'الحالة',
      AppLocalizationConstants.ok: 'موافق',
      AppLocalizationConstants.error: 'خطأ',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
