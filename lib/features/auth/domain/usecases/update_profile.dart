import 'dart:io';

import '../../domain/entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class UpdateProfile {
  final AuthRepository repository;
  UpdateProfile(this.repository);

  Future<UserEntity> call(UserEntity user, {File? profileImage}) {
    return repository.updateProfile(user, profileImage: profileImage);
  }
}
