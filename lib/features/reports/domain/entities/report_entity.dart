import 'package:equatable/equatable.dart';
import '../../data/models/report_model.dart';

class ReportEntity extends Equatable {
  final String id;
  final String reporterId;
  final String adId;
  final String reason;
  final String description;
  final String status;
  final DateTime createdAt;

  ReportEntity({
    required this.id,
    required this.reporterId,
    required this.adId,
    required this.reason,
    this.description = '',
    this.status = 'pending',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  ReportEntity copyWith({
    String? id,
    String? reporterId,
    String? adId,
    String? reason,
    String? description,
    String? status,
    DateTime? createdAt,
  }) {
    return ReportEntity(
      id: id ?? this.id,
      reporterId: reporterId ?? this.reporterId,
      adId: adId ?? this.adId,
      reason: reason ?? this.reason,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory ReportEntity.fromModel(ReportModel model) {
    return ReportEntity(
      id: model.id,
      reporterId: model.reporterId,
      adId: model.adId,
      reason: model.reason,
      description: model.description,
      status: model.status,
      createdAt: model.createdAt,
    );
  }

  ReportModel toModel() {
    return ReportModel(
      id: id,
      reporterId: reporterId,
      adId: adId,
      reason: reason,
      description: description,
      status: status,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [id, adId, reason];
}
