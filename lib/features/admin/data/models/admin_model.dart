import 'package:equatable/equatable.dart';

class AdminModel extends Equatable {
  final String id;
  final String userId;
  final String role;
  final List<String> permissions;

  const AdminModel({
    required this.id,
    required this.userId,
    this.role = 'admin',
    this.permissions = const [],
  });

  factory AdminModel.fromJson(Map<String, dynamic> json, String id) {
    return AdminModel(
      id: id,
      userId: json['userId'] as String? ?? '',
      role: json['role'] as String? ?? 'admin',
      permissions: List<String>.from(json['permissions'] as List<dynamic>? ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'role': role,
      'permissions': permissions,
    };
  }

  AdminModel copyWith({
    String? id,
    String? userId,
    String? role,
    List<String>? permissions,
  }) {
    return AdminModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      permissions: permissions ?? this.permissions,
    );
  }

  @override
  List<Object?> get props => [id, userId, role];
}
