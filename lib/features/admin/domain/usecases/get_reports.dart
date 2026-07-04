import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../reports/domain/entities/report_entity.dart';
import '../repositories/admin_repository.dart';

class GetReports {
  final AdminRepository repository;
  GetReports(this.repository);

  Future<List<ReportEntity>> call({DocumentSnapshot? lastDoc}) {
    return repository.getReports(lastDoc: lastDoc);
  }
}
