import 'dart:io';

import '../../../../core/services/firebase_service.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final FirebaseService _firebaseService = FirebaseService();

  ProfileRepositoryImpl({required this.remoteDataSource});

  String get _userId => _firebaseService.auth.currentUser?.uid ?? '';

  @override
  Future<UserEntity> getProfile() async {
    try {
      final model = await remoteDataSource.getProfile(_userId);
      return UserEntity.fromModel(model);
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
  Future<void> deleteAccount() async {
    try {
      await remoteDataSource.deleteAccount(_userId);
    } catch (e) {
      rethrow;
    }
  }
}
