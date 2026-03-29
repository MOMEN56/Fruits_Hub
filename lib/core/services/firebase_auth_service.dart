import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fruit_hub/core/errors/exceptions.dart';
import 'package:fruit_hub/generated/l10n.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  Future<User?> restoreSessionUser({
    Duration timeout = const Duration(seconds: 3),
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      return currentUser;
    }

    try {
      final restoredUser = await FirebaseAuth.instance.authStateChanges().first
          .timeout(timeout);
      if (restoredUser != null) {
        return restoredUser;
      }
    } catch (_) {}

    await Future<void>.delayed(const Duration(milliseconds: 250));
    return FirebaseAuth.instance.currentUser;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();

    try {
      await GoogleSignIn().signOut();
    } catch (_) {}

    try {
      await FacebookAuth.instance.logOut();
    } catch (_) {}
  }

  Future deleteUser() async {
    await FirebaseAuth.instance.currentUser!.delete();
  }

  Future<User> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      log(
        'Exception in FirebaseAuthService.createUserWithEmailAndPassword: ${e.toString()} and code is ${e.code}',
      );
      if (e.code == 'weak-password') {
        throw CustomException(message: S.current.weakPassword);
      } else if (e.code == 'email-already-in-use') {
        throw CustomException(message: S.current.emailAlreadyInUse);
      } else if (e.code == 'network-request-failed') {
        throw CustomException(message: S.current.checkInternetConnection);
      } else {
        throw CustomException(message: S.current.genericTryAgain);
      }
    } catch (e) {
      log(
        'Exception in FirebaseAuthService.createUserWithEmailAndPassword: ${e.toString()}',
      );

      throw CustomException(message: S.current.genericTryAgain);
    }
  }

  Future<User> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      log(
        'Exception in FirebaseAuthService.signInWithEmailAndPassword: ${e.toString()} and code is ${e.code}',
      );
      if (e.code == 'user-not-found') {
        throw CustomException(message: S.current.invalidCredentials);
      } else if (e.code == 'wrong-password') {
        throw CustomException(message: S.current.invalidCredentials);
      } else if (e.code == 'network-request-failed') {
        throw CustomException(message: S.current.checkInternetConnection);
      } else {
        throw CustomException(message: S.current.genericTryAgain);
      }
    } catch (e) {
      log(
        'Exception in FirebaseAuthService.signInWithEmailAndPassword: ${e.toString()}',
      );

      throw CustomException(message: S.current.genericTryAgain);
    }
  }

  Future<User> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return (await FirebaseAuth.instance.signInWithCredential(credential)).user!;
  }

  Future<User> signinWithFacebook() async {
    final loginResult = await FacebookAuth.instance.login(
      permissions: ['email', 'public_profile'],
    );

    if (loginResult.status != LoginStatus.success) {
      throw CustomException(message: S.current.genericTryAgain);
    }

    final OAuthCredential facebookCredential = FacebookAuthProvider.credential(
      loginResult.accessToken!.tokenString,
    );

    try {
      final credential = await FirebaseAuth.instance.signInWithCredential(
        facebookCredential,
      );
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      log(
        'Exception in FirebaseAuthService.signinWithFacebook: ${e.code} ${e.message}',
      );

      if (e.code == 'account-exists-with-different-credential') {
        final email = e.email ?? await _getFacebookEmail();
        if (email == null) {
          throw CustomException(message: S.current.genericTryAgain);
        }

        // جيب الـ providers المرتبطة بالـ email ده
        final methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(
          email,
        );

        if (methods.contains('google.com')) {
          // سجل دخول بـ Google الأول
          final googleUser = await GoogleSignIn().signIn();
          final googleAuth = await googleUser?.authentication;
          final googleCredential = GoogleAuthProvider.credential(
            accessToken: googleAuth?.accessToken,
            idToken: googleAuth?.idToken,
          );
          final userCredential = await FirebaseAuth.instance
              .signInWithCredential(googleCredential);

          // ربط Facebook بالحساب
          await userCredential.user?.linkWithCredential(facebookCredential);
          return userCredential.user!;
        } else if (methods.contains('password')) {
          // الحساب بـ Email/Password — مش ممكن نعمل link تلقائي
          // نعرض للمستخدم رسالة واضحة
          throw CustomException(
            message:
                'هذا البريد مسجل بكلمة مرور. سجّل دخول بالبريد الإلكتروني أولاً.',
          );
        }
      }
      throw CustomException(message: S.current.genericTryAgain);
    } catch (e) {
      log('Exception in FirebaseAuthService.signinWithFacebook: $e');
      throw CustomException(message: S.current.genericTryAgain);
    }
  }

  bool isLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  Future<String?> _getFacebookEmail() async {
    try {
      final data = await FacebookAuth.instance.getUserData(fields: 'email');
      return data['email'] as String?;
    } catch (error) {
      log('Failed to retrieve Facebook email: $error');
      return null;
    }
  }
}
