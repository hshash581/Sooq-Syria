import '../../domain/entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class VerifyOtp {
  final AuthRepository repository;
  VerifyOtp(this.repository);

  Future<UserEntity> call(String verificationId, String smsCode) {
    return repository.verifyOtp(verificationId, smsCode);
  }
}
