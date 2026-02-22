import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fruit_hub/features/auth/domain/entites/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({required super.name, required super.email, required super.uId});
  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      name: user.displayName ?? '',
      email: user.email ?? '',
      uId: user.uid,
    );
  }
  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      uId: map['u_id'] ?? '', // ✅ كان 'uId' والصح 'u_id' زي ما هو في Supabase
    );
  }
  factory UserModel.fromEntity(UserEntity user) {
    return UserModel(name: user.name, email: user.email, uId: user.uId);
  }
  toMap() {
    return {
      'u_id': uId, // ✅ Firebase UID هنا
      'name': name,
      'email': email,
    };
  }
}
