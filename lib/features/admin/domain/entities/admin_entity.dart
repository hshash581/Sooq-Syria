import 'package:equatable/equatable.dart';
import '../../data/models/admin_model.dart';

class AdminEntity extends Equatable {
  final String id;
  final String userId;
  final String role;
  final List<String> permissions;

  const AdminEntity({
    required this.id,
    required this.userId,
    this.role = 'admin',
    this.permissions = const [],
  });

  AdminEntity copyWith({
    String? id,
    String? userId,
    String? role,
    List<String>? permissions,
  }) {
    return AdminEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      permissions: permissions ?? this.permissions,
    );
  }

  factory AdminEntity.fromModel(AdminModel model) {
    return AdminEntity(
      id: model.id,
      userId: model.userId,
      role: model.role,
      permissions: List<String>.from(model.permissions),
    );
  }

  AdminModel toModel() {
    return AdminModel(
      id: id,
      userId: userId,
      role: role,
      permissions: List<String>.from(permissions),
    );
  }

  @override
  List<Object?> get props => [id, userId, role];
}
