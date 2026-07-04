import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../domain/repositories/admin_repository.dart';
import 'admin_event.dart';
import 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final AdminRepository _adminRepository;

  AdminBloc({required AdminRepository adminRepository})
      : _adminRepository = adminRepository,
        super(const AdminInitial()) {
    on<LoadDashboard>(_onLoadDashboard);
    on<LoadPendingAds>(_onLoadPendingAds);
    on<ApproveAd>(_onApproveAd);
    on<RejectAd>(_onRejectAd);
    on<BlockUser>(_onBlockUser);
    on<UnblockUser>(_onUnblockUser);
    on<LoadReports>(_onLoadReports);
    on<SendBulkNotification>(_onSendBulkNotification);
    on<LoadStatistics>(_onLoadStatistics);
    on<LoadUsers>(_onLoadUsers);
    on<ManageCategories>(_onManageCategories);
    on<ManageGovernorates>(_onManageGovernorates);
    on<ManageCities>(_onManageCities);
  }

  Future<void> _onLoadDashboard(
      LoadDashboard event, Emitter<AdminState> emit) async {
    emit(const AdminLoading());
    try {
      final statistics = await _adminRepository.getStatistics();
      final pendingAds = await _adminRepository.getPendingAds();
      emit(AdminDashboardLoaded(
        statistics: statistics,
        pendingAdsCount: pendingAds.length,
        usersCount: statistics.totalUsers,
      ));
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  Future<void> _onLoadPendingAds(
      LoadPendingAds event, Emitter<AdminState> emit) async {
    emit(const AdminLoading());
    try {
      final ads = await _adminRepository.getPendingAds();
      emit(AdminPendingAdsLoaded(ads));
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  Future<void> _onApproveAd(
      ApproveAd event, Emitter<AdminState> emit) async {
    try {
      await _adminRepository.approveAd(event.adId);
      if (state is AdminPendingAdsLoaded) {
        final current = state as AdminPendingAdsLoaded;
        final updatedAds =
            current.ads.where((ad) => ad.id != event.adId).toList();
        emit(AdminPendingAdsLoaded(updatedAds));
      } else {
        final ads = await _adminRepository.getPendingAds();
        emit(AdminPendingAdsLoaded(ads));
      }
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  Future<void> _onRejectAd(
      RejectAd event, Emitter<AdminState> emit) async {
    try {
      await _adminRepository.rejectAd(event.adId, reason: event.reason);
      if (state is AdminPendingAdsLoaded) {
        final current = state as AdminPendingAdsLoaded;
        final updatedAds =
            current.ads.where((ad) => ad.id != event.adId).toList();
        emit(AdminPendingAdsLoaded(updatedAds));
      } else {
        final ads = await _adminRepository.getPendingAds();
        emit(AdminPendingAdsLoaded(ads));
      }
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  Future<void> _onBlockUser(
      BlockUser event, Emitter<AdminState> emit) async {
    try {
      await _adminRepository.blockUser(event.userId);
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  Future<void> _onUnblockUser(
      UnblockUser event, Emitter<AdminState> emit) async {
    try {
      await _adminRepository.unblockUser(event.userId);
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  Future<void> _onLoadReports(
      LoadReports event, Emitter<AdminState> emit) async {
    emit(const AdminLoading());
    try {
      final reports = await _adminRepository.getReports();
      emit(AdminReportsLoaded(reports));
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  Future<void> _onSendBulkNotification(
      SendBulkNotification event, Emitter<AdminState> emit) async {
    emit(const AdminLoading());
    try {
      await _adminRepository.sendBulkNotification(
          event.title, event.body);
      emit(const AdminNotificationSent());
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  Future<void> _onLoadStatistics(
      LoadStatistics event, Emitter<AdminState> emit) async {
    emit(const AdminLoading());
    try {
      final statistics = await _adminRepository.getStatistics();
      emit(AdminDashboardLoaded(
        statistics: statistics,
        pendingAdsCount: statistics.pendingAds,
        usersCount: statistics.totalUsers,
      ));
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  Future<void> _onLoadUsers(
      LoadUsers event, Emitter<AdminState> emit) async {
    emit(const AdminLoading());
    try {
      final users = <dynamic>[];
      emit(AdminUsersLoaded(users));
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  Future<void> _onManageCategories(
      ManageCategories event, Emitter<AdminState> emit) async {
    try {
      await _adminRepository.manageCategories(event.data);
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  Future<void> _onManageGovernorates(
      ManageGovernorates event, Emitter<AdminState> emit) async {
    try {
      await _adminRepository.manageGovernorates(event.data);
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  Future<void> _onManageCities(
      ManageCities event, Emitter<AdminState> emit) async {
    try {
      await _adminRepository.manageCities(event.data);
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }
}
