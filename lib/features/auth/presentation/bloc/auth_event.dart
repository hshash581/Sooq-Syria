import 'dart:io';

import 'package:equatable/equatable.dart';

import '../../domain/entities/user_entity.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckAuthStatus extends AuthEvent {
  const CheckAuthStatus();
}

class SignInWithPhone extends AuthEvent {
  final String phoneNumber;

  const SignInWithPhone(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

class VerifyOtp extends AuthEvent {
  final String verificationId;
  final String smsCode;

  const VerifyOtp(this.verificationId, this.smsCode);

  @override
  List<Object?> get props => [verificationId, smsCode];
}

class SignUp extends AuthEvent {
  final UserEntity user;
  final File? image;

  const SignUp(this.user, {this.image});

  @override
  List<Object?> get props => [user, image];
}

class UpdateProfile extends AuthEvent {
  final UserEntity user;
  final File? image;

  const UpdateProfile(this.user, {this.image});

  @override
  List<Object?> get props => [user, image];
}

class SignOut extends AuthEvent {
  const SignOut();
}

class UpdateFcmToken extends AuthEvent {
  final String token;

  const UpdateFcmToken(this.token);

  @override
  List<Object?> get props => [token];
}
