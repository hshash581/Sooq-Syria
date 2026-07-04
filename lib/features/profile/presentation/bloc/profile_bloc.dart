import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../domain/repositories/profile_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository;

  ProfileBloc({required ProfileRepository profileRepository})
      : _profileRepository = profileRepository,
        super(const ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<DeleteAccount>(_onDeleteAccount);
    on<Logout>(_onLogout);
  }

  Future<void> _onLoadProfile(
      LoadProfile event, Emitter<ProfileState> emit) async {
    emit(const ProfileLoading());
    try {
      final user = await _profileRepository.getProfile();
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
      UpdateProfile event, Emitter<ProfileState> emit) async {
    emit(const ProfileLoading());
    try {
      final user = await _profileRepository.updateProfile(
        event.user,
        profileImage: event.image,
      );
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onDeleteAccount(
      DeleteAccount event, Emitter<ProfileState> emit) async {
    emit(const ProfileLoading());
    try {
      await _profileRepository.deleteAccount();
      emit(const ProfileDeleted());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onLogout(
      Logout event, Emitter<ProfileState> emit) async {
    emit(const ProfileLoading());
    try {
      await _profileRepository.deleteAccount();
      emit(const ProfileDeleted());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
