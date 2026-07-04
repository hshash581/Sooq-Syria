import 'dart:io';

import '../../domain/entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignUp {
  final AuthRepository repository;
  SignUp(this.repository);

  Future<UserEntity> call(UserEntity user, {File? profileImage}) {
    return repository.signUp(user, profileImage: profileImage);
  }
}
