import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel extends Equatable {
  final String id;
  final String reporterId;
  final String adId;
  final String reason;
  final String description;
  final String status;
  final DateTime createdAt;

  ReportModel({
    required this.id,
    required this.reporterId,
    required this.adId,
    required this.reason,
    this.description = '',
    this.status = 'pending',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ReportModel.fromJson(Map<String, dynamic> json, String id) {
    return ReportModel(
      id: id,
      reporterId: json['reporterId'] as String? ?? '',
      adId: json['adId'] as String? ?? '',
      reason: json['reason'] as String? ?? '',
      description: json['description'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reporterId': reporterId,
      'adId': adId,
      'reason': reason,
      'description': description,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  ReportModel copyWith({
    String? id,
    String? reporterId,
    String? adId,
    String? reason,
    String? description,
    String? status,
    DateTime? createdAt,
  }) {
    return ReportModel(
      id: id ?? this.id,
      reporterId: reporterId ?? this.reporterId,
      adId: adId ?? this.adId,
      reason: reason ?? this.reason,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, adId, reason];
}
