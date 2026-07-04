import 'dart:io';

import '../../../auth/domain/entities/user_entity.dart';
import '../repositories/profile_repository.dart';

class UpdateProfile {
  final ProfileRepository repository;
  UpdateProfile(this.repository);

  Future<UserEntity> call(UserEntity user, {File? profileImage}) {
    return repository.updateProfile(user, profileImage: profileImage);
  }
}
