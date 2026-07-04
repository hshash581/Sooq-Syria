import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:sooq_syria/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> signInWithPhone(String phoneNumber);
  Future<UserEntity> verifyOtp(String verificationId, String smsCode);
  Future<UserEntity> signUp(UserEntity user, {File? profileImage});
  Future<UserEntity> getCurrentUser();
  Future<void> signOut();
  Future<UserEntity> updateProfile(UserEntity user, {File? profileImage});
  Stream<User?> get authStateChanges;
  Future<bool> isLoggedIn();
  Future<void> updateFcmToken(String token);
}
