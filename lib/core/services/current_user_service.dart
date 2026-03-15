import 'dart:convert';

import 'package:fruit_hub/constants.dart';
import 'package:fruit_hub/core/services/shared_preferences_singleton.dart';
import 'package:fruit_hub/features/auth/data/models/user_model.dart';
import 'package:fruit_hub/features/auth/domain/entites/user_entity.dart';

class CurrentUserService {
  UserEntity? getCurrentUser() {
    try {
      final rawUserData = Prefs.getString(kUserData).trim();
      if (rawUserData.isEmpty) {
        return null;
      }
      final decoded = jsonDecode(rawUserData);
      if (decoded is! Map<String, dynamic>) {
        return null;
      }
      return UserModel.fromJson(decoded);
    } catch (_) {
      return null;
    }
  }

  String? getCurrentUserId() {
    final userId = getCurrentUser()?.uId.trim();
    if (userId == null || userId.isEmpty) {
      return null;
    }
    return userId;
  }
}
