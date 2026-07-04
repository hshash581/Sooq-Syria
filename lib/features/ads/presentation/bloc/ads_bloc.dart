import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/ad_entity.dart';
import '../../domain/repositories/ads_repository.dart';
import 'ads_event.dart';
import 'ads_state.dart';

class AdsBloc extends Bloc<AdsEvent, AdsState> {
  final AdsRepository _adsRepository;
  DocumentSnapshot? _lastDoc;
  String? _currentFilter;
  bool _isLoadingMore = false;

  AdsBloc({required AdsRepository adsRepository})
      : _adsRepository = adsRepository,
        super(const AdsInitial()) {
    on<LoadAds>(_onLoadAds);
    on<LoadAdsByUser>(_onLoadAdsByUser);
    on<LoadAdsByCategory>(_onLoadAdsByCategory);
    on<LoadLatestAds>(_onLoadLatestAds);
    on<LoadFeaturedAds>(_onLoadFeaturedAds);
    on<LoadMostViewedAds>(_onLoadMostViewedAds);
    on<LoadMoreAds>(_onLoadMoreAds);
    on<RefreshAds>(_onRefreshAds);
    on<DeleteAd>(_onDeleteAd);
    on<ToggleAdStatus>(_onToggleAdStatus);
    on<RenewAd>(_onRenewAd);
  }

  Future<void> _onLoadAds(
      LoadAds event, Emitter<AdsState> emit) async {
    emit(const AdsLoading());
    _currentFilter = 'all';
    _lastDoc = null;
    try {
      final ads = await _adsRepository.getLatestAds();
      _lastDoc = ads.isNotEmpty ? null : null;
      emit(AdsLoaded(ads: ads, hasMore: ads.length >= 20));
    } catch (e) {
      emit(AdsError(e.toString()));
    }
  }

  Future<void> _onLoadAdsByUser(
      LoadAdsByUser event, Emitter<AdsState> emit) async {
    emit(const AdsLoading());
    _currentFilter = 'user_${event.userId}';
    _lastDoc = null;
    try {
      final ads = await _adsRepository.getAdsByUser(event.userId);
      emit(AdsLoaded(ads: ads, hasMore: false));
    } catch (e) {
      emit(AdsError(e.toString()));
    }
  }

  Future<void> _onLoadAdsByCategory(
      LoadAdsByCategory event, Emitter<AdsState> emit) async {
    emit(const AdsLoading());
    _currentFilter = 'category_${event.categoryId}';
    _lastDoc = null;
    try {
      final ads =
          await _adsRepository.getAdsByCategory(event.categoryId);
      emit(AdsLoaded(ads: ads, hasMore: ads.length >= 20));
    } catch (e) {
      emit(AdsError(e.toString()));
    }
  }

  Future<void> _onLoadLatestAds(
      LoadLatestAds event, Emitter<AdsState> emit) async {
    emit(const AdsLoading());
    _currentFilter = 'latest';
    _lastDoc = null;
    try {
      final ads = await _adsRepository.getLatestAds();
      emit(AdsLoaded(ads: ads, hasMore: ads.length >= 20));
    } catch (e) {
      emit(AdsError(e.toString()));
    }
  }

  Future<void> _onLoadFeaturedAds(
      LoadFeaturedAds event, Emitter<AdsState> emit) async {
    emit(const AdsLoading());
    _currentFilter = 'featured';
    try {
      final ads = await _adsRepository.getFeaturedAds();
      emit(AdsLoaded(ads: ads, hasMore: false));
    } catch (e) {
      emit(AdsError(e.toString()));
    }
  }

  Future<void> _onLoadMostViewedAds(
      LoadMostViewedAds event, Emitter<AdsState> emit) async {
    emit(const AdsLoading());
    _currentFilter = 'most_viewed';
    _lastDoc = null;
    try {
      final ads = await _adsRepository.getMostViewedAds();
      emit(AdsLoaded(ads: ads, hasMore: ads.length >= 20));
    } catch (e) {
      emit(AdsError(e.toString()));
    }
  }

  Future<void> _onLoadMoreAds(
      LoadMoreAds event, Emitter<AdsState> emit) async {
    if (_isLoadingMore) return;
    if (state is! AdsLoaded) return;
    final currentState = state as AdsLoaded;
    if (!currentState.hasMore) return;

    _isLoadingMore = true;
    try {
      List<AdEntity> moreAds;
      switch (_currentFilter) {
        case 'category_':
          break;
        default:
          moreAds = await _adsRepository.getLatestAds(lastDoc: _lastDoc);
      }

      if (_currentFilter != null && _currentFilter!.startsWith('category_')) {
        final categoryId = _currentFilter!.substring(9);
        moreAds =
            await _adsRepository.getAdsByCategory(categoryId, lastDoc: _lastDoc);
      } else {
        moreAds = await _adsRepository.getLatestAds(lastDoc: _lastDoc);
      }

      final allAds = [...currentState.ads, ...moreAds];
      emit(AdsLoaded(ads: allAds, hasMore: moreAds.length >= 20));
    } catch (e) {
      emit(AdsError(e.toString()));
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> _onRefreshAds(
      RefreshAds event, Emitter<AdsState> emit) async {
    _lastDoc = null;
    emit(const AdsLoading());
    try {
      final ads = await _adsRepository.getLatestAds();
      emit(AdsLoaded(ads: ads, hasMore: ads.length >= 20));
    } catch (e) {
      emit(AdsError(e.toString()));
    }
  }

  Future<void> _onDeleteAd(
      DeleteAd event, Emitter<AdsState> emit) async {
    try {
      await _adsRepository.deleteAd(event.adId);
      if (state is AdsLoaded) {
        final currentState = state as AdsLoaded;
        final updatedAds =
            currentState.ads.where((ad) => ad.id != event.adId).toList();
        emit(AdsLoaded(ads: updatedAds, hasMore: currentState.hasMore));
      }
    } catch (e) {
      emit(AdsError(e.toString()));
    }
  }

  Future<void> _onToggleAdStatus(
      ToggleAdStatus event, Emitter<AdsState> emit) async {
    try {
      final updatedAd = await _adsRepository.toggleAdStatus(event.adId);
      if (state is AdsLoaded) {
        final currentState = state as AdsLoaded;
        final updatedAds = currentState.ads.map((ad) {
          return ad.id == event.adId ? updatedAd : ad;
        }).toList();
        emit(AdsLoaded(ads: updatedAds, hasMore: currentState.hasMore));
      }
    } catch (e) {
      emit(AdsError(e.toString()));
    }
  }

  Future<void> _onRenewAd(
      RenewAd event, Emitter<AdsState> emit) async {
    try {
      final renewedAd = await _adsRepository.renewAd(event.adId);
      if (state is AdsLoaded) {
        final currentState = state as AdsLoaded;
        final updatedAds = currentState.ads.map((ad) {
          return ad.id == event.adId ? renewedAd : ad;
        }).toList();
        emit(AdsLoaded(ads: updatedAds, hasMore: currentState.hasMore));
      }
    } catch (e) {
      emit(AdsError(e.toString()));
    }
  }
}
