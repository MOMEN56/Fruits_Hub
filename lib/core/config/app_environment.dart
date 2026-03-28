import 'dart:developer';

abstract final class AppEnvironment {
  static const String _dartDefineHint =
      'Pass it with --dart-define or --dart-define-from-file=dart_defines.json.';

  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabaseAnonKey =
      String.fromEnvironment('SUPABASE_ANON_KEY');

  static const String paymobApiKey = String.fromEnvironment('PAYMOB_API_KEY');
  static const String paymobIframeId =
      String.fromEnvironment('PAYMOB_IFRAME_ID');
  static const String paymobIntegrationCardId =
      String.fromEnvironment('PAYMOB_INTEGRATION_CARD_ID');
  static const String paymobIntegrationMobileWalletId = String.fromEnvironment(
    'PAYMOB_INTEGRATION_MOBILE_WALLET_ID',
  );

  static const String firebaseProjectId =
      String.fromEnvironment('FIREBASE_PROJECT_ID');
  static const String firebaseStorageBucket =
      String.fromEnvironment('FIREBASE_STORAGE_BUCKET');
  static const String firebaseWebApiKey =
      String.fromEnvironment('FIREBASE_WEB_API_KEY');
  static const String firebaseWebAppId =
      String.fromEnvironment('FIREBASE_WEB_APP_ID');
  static const String firebaseWebMessagingSenderId = String.fromEnvironment(
    'FIREBASE_WEB_MESSAGING_SENDER_ID',
  );
  static const String firebaseWebAuthDomain =
      String.fromEnvironment('FIREBASE_WEB_AUTH_DOMAIN');
  static const String firebaseWebMeasurementId = String.fromEnvironment(
    'FIREBASE_WEB_MEASUREMENT_ID',
  );
  static const String firebaseAndroidApiKey =
      String.fromEnvironment('FIREBASE_ANDROID_API_KEY');
  static const String firebaseAndroidAppId =
      String.fromEnvironment('FIREBASE_ANDROID_APP_ID');
  static const String firebaseAndroidMessagingSenderId = String.fromEnvironment(
    'FIREBASE_ANDROID_MESSAGING_SENDER_ID',
  );
  static const String firebaseIosApiKey =
      String.fromEnvironment('FIREBASE_IOS_API_KEY');
  static const String firebaseIosAppId =
      String.fromEnvironment('FIREBASE_IOS_APP_ID');
  static const String firebaseIosMessagingSenderId = String.fromEnvironment(
    'FIREBASE_IOS_MESSAGING_SENDER_ID',
  );
  static const String firebaseIosBundleId =
      String.fromEnvironment('FIREBASE_IOS_BUNDLE_ID');
  static const String firebaseWindowsApiKey =
      String.fromEnvironment('FIREBASE_WINDOWS_API_KEY');
  static const String firebaseWindowsAppId =
      String.fromEnvironment('FIREBASE_WINDOWS_APP_ID');
  static const String firebaseWindowsMessagingSenderId =
      String.fromEnvironment('FIREBASE_WINDOWS_MESSAGING_SENDER_ID');
  static const String firebaseWindowsMeasurementId = String.fromEnvironment(
    'FIREBASE_WINDOWS_MEASUREMENT_ID',
  );

  static String requireValue(String key, String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      throw StateError('Missing $key. $_dartDefineHint');
    }
    return normalized;
  }

  static List<String> missingValues(Iterable<MapEntry<String, String>> values) {
    return values
        .where((entry) => entry.value.trim().isEmpty)
        .map((entry) => entry.key)
        .toList(growable: false);
  }

  static void logMissingOptionalConfiguration(
    String featureName,
    List<String> missingKeys,
  ) {
    log(
      '[Config] Skipping $featureName setup. Missing: ${missingKeys.join(', ')}. $_dartDefineHint',
    );
  }
}
