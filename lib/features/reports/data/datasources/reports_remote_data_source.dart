import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/config/firebase_config.dart';
import '../../../../core/services/firebase_service.dart';
import '../../data/models/report_model.dart';

class ReportsRemoteDataSource {
  final FirebaseService _firebaseService = FirebaseService();

  Future<ReportModel> createReport(ReportModel report) async {
    try {
      final docRef = _firebaseService.firestore
          .collection(FirebaseConfig.reportsCollection)
          .doc(report.id);

      await docRef.set(report.toJson());
      return report;
    } on FirebaseException catch (e) {
      throw Exception('Failed to create report: ${e.message}');
    }
  }

  Future<List<ReportModel>> getReports() async {
    try {
      final snapshot = await _firebaseService.firestore
          .collection(FirebaseConfig.reportsCollection)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ReportModel.fromJson(doc.data(), doc.id))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get reports: ${e.message}');
    }
  }

  Future<List<ReportModel>> getReportsByAd(String adId) async {
    try {
      final snapshot = await _firebaseService.firestore
          .collection(FirebaseConfig.reportsCollection)
          .where('adId', isEqualTo: adId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ReportModel.fromJson(doc.data(), doc.id))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get reports for ad: ${e.message}');
    }
  }

  Future<void> updateReportStatus(String reportId, String status) async {
    try {
      await _firebaseService.firestore
          .collection(FirebaseConfig.reportsCollection)
          .doc(reportId)
          .update({'status': status});
    } on FirebaseException catch (e) {
      throw Exception('Failed to update report status: ${e.message}');
    }
  }
}
