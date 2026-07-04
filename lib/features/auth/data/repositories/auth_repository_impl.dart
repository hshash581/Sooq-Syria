import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/services/firebase_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final FirebaseService _firebaseService = FirebaseService();

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<User?> get authStateChanges => _firebaseService.auth.authStateChanges();

  @override
  Future<UserEntity> signInWithPhone(String phoneNumber) async {
    try {
      final verificationId = await remoteDataSource.signInWithPhone(phoneNumber);
      return UserEntity(id: verificationId, phoneNumber: phoneNumber, fullName: '');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserEntity> verifyOtp(String verificationId, String smsCode) async {
    try {
      final model = await remoteDataSource.verifyOtp(verificationId, smsCode);
      return UserEntity.fromModel(model);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserEntity> signUp(UserEntity user, {File? profileImage}) async {
    try {
      final model = user.toModel();
      final result = await remoteDataSource.signUp(model, profileImage);
      return UserEntity.fromModel(result);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserEntity> getCurrentUser() async {
    try {
      final model = await remoteDataSource.getCurrentUser();
      if (model == null) throw Exception('User not found');
      return UserEntity.fromModel(model);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await remoteDataSource.signOut();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserEntity> updateProfile(UserEntity user, {File? profileImage}) async {
    try {
      final model = user.toModel();
      final result = await remoteDataSource.updateProfile(model, profileImage);
      return UserEntity.fromModel(result);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      return _firebaseService.auth.currentUser != null;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> updateFcmToken(String token) async {
    try {
      await remoteDataSource.updateFcmToken(token);
    } catch (e) {
      rethrow;
    }
  }
}
