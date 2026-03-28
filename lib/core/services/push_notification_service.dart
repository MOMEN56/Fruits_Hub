import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fruit_hub/core/services/current_user_service.dart';
import 'package:fruit_hub/core/utils/backend_endpoints.dart';
import 'package:fruit_hub/firebase_runtime_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: RuntimeFirebaseOptions.currentPlatform);
}

class PushNotificationService {
  PushNotificationService({
    FirebaseMessaging? firebaseMessaging,
    SupabaseClient? supabaseClient,
    CurrentUserService? currentUserService,
  }) : _firebaseMessaging = firebaseMessaging ?? FirebaseMessaging.instance,
       _supabaseClient = supabaseClient ?? Supabase.instance.client,
       _currentUserService = currentUserService ?? CurrentUserService();

  final FirebaseMessaging _firebaseMessaging;
  final SupabaseClient _supabaseClient;
  final CurrentUserService _currentUserService;

  bool _isInitialized = false;
  String? _lastHandledMessageKey;
  Future<void> Function(RemoteMessage message)? _onNotificationTap;
  StreamSubscription<String>? _tokenRefreshSubscription;
  StreamSubscription<RemoteMessage>? _openAppSubscription;
  String? _pendingTokenForSync;

  static void configureBackgroundHandler() {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  Future<void> initialize({
    required Future<void> Function(RemoteMessage message) onNotificationTap,
  }) async {
    _onNotificationTap = onNotificationTap;
    if (_isInitialized) {
      return;
    }
    _isInitialized = true;

    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await registerCurrentUserDevice();

    _tokenRefreshSubscription = _firebaseMessaging.onTokenRefresh.listen((
      token,
    ) {
      unawaited(_upsertDeviceToken(token));
    });

    _openAppSubscription = FirebaseMessaging.onMessageOpenedApp.listen(
      _handleNotificationTap,
    );

    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      await _handleNotificationTap(initialMessage);
    }
  }

  Future<void> registerCurrentUserDevice() async {
    try {
      final token = await _firebaseMessaging.getToken();
      log('[Push] FirebaseMessaging.getToken() => ${token ?? 'null'}');
      if (token == null || token.trim().isEmpty) {
        final pending = _pendingTokenForSync;
        if (pending == null || pending.isEmpty) {
          log('[Push] No FCM token available yet; skipping sync.');
          return;
        }
        log('[Push] Retrying sync with pending token.');
        await _upsertDeviceToken(pending);
        return;
      }
      await _upsertDeviceToken(token);
    } catch (e, stackTrace) {
      log(
        '[Push] registerCurrentUserDevice failed: $e',
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> registerCurrentUserDeviceAfterLogin() async {
    log('[Push] registerCurrentUserDeviceAfterLogin triggered.');
    await registerCurrentUserDevice();
    final pending = _pendingTokenForSync;
    if (pending == null || pending.isEmpty) {
      return;
    }
    log('[Push] Retrying pending token sync after login.');
    await _upsertDeviceToken(pending);
  }

  Future<void> _upsertDeviceToken(String token) async {
    final normalizedToken = token.trim();
    if (normalizedToken.isEmpty) {
      log('[Push] Token is empty after trim; abort upsert.');
      return;
    }
    final userId = _currentUserService.getCurrentUserId();
    log('[Push] Resolved current user id => ${userId ?? 'null'}');
    if (userId == null || userId.isEmpty) {
      _pendingTokenForSync = normalizedToken;
      log('[Push] User id unavailable; token saved for retry.');
      return;
    }

    final payload = {
      'user_id': userId,
      'device_token': normalizedToken,
      'platform': Platform.operatingSystem,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    };

    try {
      await _supabaseClient
          .from(BackendEndpoint.userDevices)
          .upsert(payload, onConflict: 'user_id,device_token');
      _pendingTokenForSync = null;
      log(
        '[Push] Token synced to table "${BackendEndpoint.userDevices}" successfully for user: $userId',
      );
    } catch (e, stackTrace) {
      if (_isMissingOnConflictConstraintError(e)) {
        try {
          await _supabaseClient.from(BackendEndpoint.userDevices).insert(payload);
          _pendingTokenForSync = null;
          log(
            '[Push] Upsert conflict-constraint missing. Fallback insert succeeded for user: $userId',
          );
          return;
        } catch (insertError, insertStackTrace) {
          _pendingTokenForSync = normalizedToken;
          log(
            '[Push] Fallback insert failed for table "${BackendEndpoint.userDevices}": $insertError',
            stackTrace: insertStackTrace,
          );
          return;
        }
      }
      _pendingTokenForSync = normalizedToken;
      log(
        '[Push] Token upsert failed for table "${BackendEndpoint.userDevices}": $e',
        stackTrace: stackTrace,
      );
    }
  }

  bool _isMissingOnConflictConstraintError(Object error) {
    final text = error.toString();
    return text.contains('42P10') &&
        text.contains('no unique or exclusion constraint matching the ON CONFLICT specification');
  }

  Future<void> _handleNotificationTap(RemoteMessage message) async {
    final uniqueKey =
        message.messageId ??
        '${message.sentTime?.millisecondsSinceEpoch ?? 0}-${message.data.hashCode}';
    if (_lastHandledMessageKey == uniqueKey) {
      return;
    }
    _lastHandledMessageKey = uniqueKey;
    await _onNotificationTap?.call(message);
  }

  Future<void> dispose() async {
    await _tokenRefreshSubscription?.cancel();
    await _openAppSubscription?.cancel();
  }
}
