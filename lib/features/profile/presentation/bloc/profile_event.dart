import 'dart:io';

import 'package:equatable/equatable.dart';

import '../../../auth/domain/entities/user_entity.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {
  const LoadProfile();
}

class UpdateProfile extends ProfileEvent {
  final UserEntity user;
  final File? image;

  const UpdateProfile(this.user, {this.image});

  @override
  List<Object?> get props => [user, image];
}

class DeleteAccount extends ProfileEvent {
  const DeleteAccount();
}

class Logout extends ProfileEvent {
  const Logout();
}
