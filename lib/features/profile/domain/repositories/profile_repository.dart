import 'dart:io';

import '../../../auth/domain/entities/user_entity.dart';

abstract class ProfileRepository {
  Future<UserEntity> getProfile();
  Future<UserEntity> updateProfile(UserEntity user, {File? profileImage});
  Future<void> deleteAccount();
}
