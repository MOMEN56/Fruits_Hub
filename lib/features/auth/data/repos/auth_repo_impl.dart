import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:fruit_hub/constants.dart';
import 'package:fruit_hub/core/errors/exceptions.dart';
import 'package:fruit_hub/core/errors/failures.dart';
import 'package:fruit_hub/core/services/data_service.dart';
import 'package:fruit_hub/core/services/firebase_auth_service.dart';
import 'package:fruit_hub/core/services/shared_preferences_singleton.dart';
import 'package:fruit_hub/core/utils/backend_endpoints.dart';
import 'package:fruit_hub/features/auth/data/models/user_model.dart';
import 'package:fruit_hub/features/auth/domain/entites/user_entity.dart';
import 'package:fruit_hub/features/auth/domain/repos/auth_repo.dart';

class AuthRepoImpl extends AuthRepo {
  final FirebaseAuthService firebaseAuthService;
  final DatabaseService databaseServices;

  AuthRepoImpl({
    required this.databaseServices,
    required this.firebaseAuthService,
  });

  @override
  Future<Either<Failure, UserEntity>> createUserWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    User? user;
    try {
      user = await firebaseAuthService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userEntity = UserEntity(name: name, email: email, uId: user.uid);

      await addUserData(user: userEntity);
      await saveUserData(user: userEntity);

      return right(userEntity);
    } catch (e) {
      await deleteUser(user);
      log('Signup error: $e');
      return left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final user = await firebaseAuthService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userEntity = await _handleUserAfterAuth(user);

      return right(userEntity);
    } on CustomException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      log('Signin error: $e');
      return left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signinWithGoogle() async {
    User? user;
    try {
      user = await firebaseAuthService.signInWithGoogle();

      final userEntity = await _handleUserAfterAuth(user);

      return right(userEntity);
    } catch (e) {
      await deleteUser(user);
      log('Google signin error: $e');
      return left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signinWithFacebook() async {
    User? user;
    try {
      user = await firebaseAuthService.signinWithFacebook();

      final userEntity = await _handleUserAfterAuth(user);

      return right(userEntity);
    } catch (e) {
      await deleteUser(user);
      log('Facebook signin error: $e');
      return left(ServerFailure('Something went wrong'));
    }
  }

  @override
  Future addUserData({required UserEntity user}) async {
    await databaseServices.addData(
      path: BackendEndpoint.addUserData,
      data: UserModel.fromEntity(user).toMap(),
    );
  }

  @override
  Future<UserEntity> getUserData({required String uid}) async {
    final rawUserData = await databaseServices.getData(
      path: BackendEndpoint.getUsersData,
      query: {'u_id': uid},
    );
    final userData = _extractUserMap(rawUserData);

    if (userData == null) {
      throw CustomException(message: 'User data not found');
    }

    return UserModel.fromJson(userData);
  }

  Future saveUserData({required UserEntity user}) async {
    final jsonData = jsonEncode(UserModel.fromEntity(user).toMap());
    await Prefs.setString(kUserData, jsonData);
  }

  Future<UserEntity> _handleUserAfterAuth(User user) async {
    final rawUserData = await databaseServices.getData(
      path: BackendEndpoint.getUsersData,
      query: {'u_id': user.uid},
    );
    final userData = _extractUserMap(rawUserData);

    late UserEntity userEntity;

    if (userData == null) {
      userEntity = UserModel.fromFirebaseUser(user);
      await addUserData(user: userEntity);
    } else {
      userEntity = UserModel.fromJson(userData);
    }

    await saveUserData(user: userEntity);
    return userEntity;
  }

  Map<String, dynamic>? _extractUserMap(dynamic rawUserData) {
    if (rawUserData == null) {
      return null;
    }

    if (rawUserData is Map<String, dynamic>) {
      return rawUserData;
    }

    if (rawUserData is Map) {
      return Map<String, dynamic>.from(rawUserData);
    }

    if (rawUserData is List) {
      if (rawUserData.isEmpty) {
        return null;
      }

      final firstItem = rawUserData.first;
      if (firstItem is Map<String, dynamic>) {
        return firstItem;
      }

      if (firstItem is Map) {
        return Map<String, dynamic>.from(firstItem);
      }
    }

    throw CustomException(message: 'Unsupported user data format');
  }

  Future<void> deleteUser(User? user) async {
    if (user != null) {
      await firebaseAuthService.deleteUser();
    }
  }
}

