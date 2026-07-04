import '../../domain/entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignInWithPhone {
  final AuthRepository repository;
  SignInWithPhone(this.repository);

  Future<UserEntity> call(String phoneNumber) {
    return repository.signInWithPhone(phoneNumber);
  }
}
