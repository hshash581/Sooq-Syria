import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../domain/repositories/ads_repository.dart';
import 'create_ad_event.dart';
import 'create_ad_state.dart';

class CreateAdBloc extends Bloc<CreateAdEvent, CreateAdState> {
  final AdsRepository _adsRepository;

  CreateAdBloc({required AdsRepository adsRepository})
      : _adsRepository = adsRepository,
        super(const CreateAdInitial()) {
    on<CreateAd>(_onCreateAd);
    on<UpdateAd>(_onUpdateAd);
    on<ResetCreateAd>(_onResetCreateAd);
  }

  Future<void> _onCreateAd(
      CreateAd event, Emitter<CreateAdState> emit) async {
    emit(const CreateAdLoading());
    try {
      final ad = await _adsRepository.createAd(event.ad, event.images);
      emit(CreateAdSuccess(ad));
    } catch (e) {
      emit(CreateAdError(e.toString()));
    }
  }

  Future<void> _onUpdateAd(
      UpdateAd event, Emitter<CreateAdState> emit) async {
    emit(const CreateAdLoading());
    try {
      final ad = await _adsRepository.updateAd(
        event.ad,
        newImages: event.newImages,
        deletedImages: event.deletedImages,
      );
      emit(CreateAdSuccess(ad));
    } catch (e) {
      emit(CreateAdError(e.toString()));
    }
  }

  void _onResetCreateAd(
      ResetCreateAd event, Emitter<CreateAdState> emit) {
    emit(const CreateAdInitial());
  }
}
