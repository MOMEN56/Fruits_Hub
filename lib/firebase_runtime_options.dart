// ignore_for_file: type=lint

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:fruit_hub/core/config/app_environment.dart';

class RuntimeFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'Firebase is not configured for linux in this project.',
        );
      default:
        throw UnsupportedError(
          'Firebase options are not supported for this platform.',
        );
    }
  }

  static FirebaseOptions get web => FirebaseOptions(
    apiKey: AppEnvironment.requireValue(
      'FIREBASE_WEB_API_KEY',
      AppEnvironment.firebaseWebApiKey,
    ),
    appId: AppEnvironment.requireValue(
      'FIREBASE_WEB_APP_ID',
      AppEnvironment.firebaseWebAppId,
    ),
    messagingSenderId: AppEnvironment.requireValue(
      'FIREBASE_WEB_MESSAGING_SENDER_ID',
      AppEnvironment.firebaseWebMessagingSenderId,
    ),
    projectId: AppEnvironment.requireValue(
      'FIREBASE_PROJECT_ID',
      AppEnvironment.firebaseProjectId,
    ),
    authDomain: AppEnvironment.requireValue(
      'FIREBASE_WEB_AUTH_DOMAIN',
      AppEnvironment.firebaseWebAuthDomain,
    ),
    storageBucket: AppEnvironment.requireValue(
      'FIREBASE_STORAGE_BUCKET',
      AppEnvironment.firebaseStorageBucket,
    ),
    measurementId: AppEnvironment.requireValue(
      'FIREBASE_WEB_MEASUREMENT_ID',
      AppEnvironment.firebaseWebMeasurementId,
    ),
  );

  static FirebaseOptions get android => FirebaseOptions(
    apiKey: AppEnvironment.requireValue(
      'FIREBASE_ANDROID_API_KEY',
      AppEnvironment.firebaseAndroidApiKey,
    ),
    appId: AppEnvironment.requireValue(
      'FIREBASE_ANDROID_APP_ID',
      AppEnvironment.firebaseAndroidAppId,
    ),
    messagingSenderId: AppEnvironment.requireValue(
      'FIREBASE_ANDROID_MESSAGING_SENDER_ID',
      AppEnvironment.firebaseAndroidMessagingSenderId,
    ),
    projectId: AppEnvironment.requireValue(
      'FIREBASE_PROJECT_ID',
      AppEnvironment.firebaseProjectId,
    ),
    storageBucket: AppEnvironment.requireValue(
      'FIREBASE_STORAGE_BUCKET',
      AppEnvironment.firebaseStorageBucket,
    ),
  );

  static FirebaseOptions get ios => FirebaseOptions(
    apiKey: AppEnvironment.requireValue(
      'FIREBASE_IOS_API_KEY',
      AppEnvironment.firebaseIosApiKey,
    ),
    appId: AppEnvironment.requireValue(
      'FIREBASE_IOS_APP_ID',
      AppEnvironment.firebaseIosAppId,
    ),
    messagingSenderId: AppEnvironment.requireValue(
      'FIREBASE_IOS_MESSAGING_SENDER_ID',
      AppEnvironment.firebaseIosMessagingSenderId,
    ),
    projectId: AppEnvironment.requireValue(
      'FIREBASE_PROJECT_ID',
      AppEnvironment.firebaseProjectId,
    ),
    storageBucket: AppEnvironment.requireValue(
      'FIREBASE_STORAGE_BUCKET',
      AppEnvironment.firebaseStorageBucket,
    ),
    iosBundleId: AppEnvironment.requireValue(
      'FIREBASE_IOS_BUNDLE_ID',
      AppEnvironment.firebaseIosBundleId,
    ),
  );

  static FirebaseOptions get macos => FirebaseOptions(
    apiKey: AppEnvironment.requireValue(
      'FIREBASE_IOS_API_KEY',
      AppEnvironment.firebaseIosApiKey,
    ),
    appId: AppEnvironment.requireValue(
      'FIREBASE_IOS_APP_ID',
      AppEnvironment.firebaseIosAppId,
    ),
    messagingSenderId: AppEnvironment.requireValue(
      'FIREBASE_IOS_MESSAGING_SENDER_ID',
      AppEnvironment.firebaseIosMessagingSenderId,
    ),
    projectId: AppEnvironment.requireValue(
      'FIREBASE_PROJECT_ID',
      AppEnvironment.firebaseProjectId,
    ),
    storageBucket: AppEnvironment.requireValue(
      'FIREBASE_STORAGE_BUCKET',
      AppEnvironment.firebaseStorageBucket,
    ),
    iosBundleId: AppEnvironment.requireValue(
      'FIREBASE_IOS_BUNDLE_ID',
      AppEnvironment.firebaseIosBundleId,
    ),
  );

  static FirebaseOptions get windows => FirebaseOptions(
    apiKey: AppEnvironment.requireValue(
      'FIREBASE_WINDOWS_API_KEY',
      AppEnvironment.firebaseWindowsApiKey,
    ),
    appId: AppEnvironment.requireValue(
      'FIREBASE_WINDOWS_APP_ID',
      AppEnvironment.firebaseWindowsAppId,
    ),
    messagingSenderId: AppEnvironment.requireValue(
      'FIREBASE_WINDOWS_MESSAGING_SENDER_ID',
      AppEnvironment.firebaseWindowsMessagingSenderId,
    ),
    projectId: AppEnvironment.requireValue(
      'FIREBASE_PROJECT_ID',
      AppEnvironment.firebaseProjectId,
    ),
    authDomain: AppEnvironment.requireValue(
      'FIREBASE_WEB_AUTH_DOMAIN',
      AppEnvironment.firebaseWebAuthDomain,
    ),
    storageBucket: AppEnvironment.requireValue(
      'FIREBASE_STORAGE_BUCKET',
      AppEnvironment.firebaseStorageBucket,
    ),
    measurementId: AppEnvironment.requireValue(
      'FIREBASE_WINDOWS_MEASUREMENT_ID',
      AppEnvironment.firebaseWindowsMeasurementId,
    ),
  );
}
