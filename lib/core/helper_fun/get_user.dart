import 'dart:convert';

import 'package:fruit_hub/constants.dart';
import 'package:fruit_hub/core/services/shared_preferences_singleton.dart';
import 'package:fruit_hub/features/auth/data/models/user_model.dart';
import 'package:fruit_hub/features/auth/domain/entites/user_entity.dart';

UserEntity getUser() {
  var jsonString = Prefs.getString(kUserData);
  var UserEntity = UserModel.fromJson(jsonDecode(jsonString));
  return UserEntity;
}
