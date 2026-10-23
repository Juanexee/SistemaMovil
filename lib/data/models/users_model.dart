// =========================================================
// users_model.dart
// Modelo de usuario con fromJson y toJson
// =========================================================
class UserModel {
  final int id;
  final String name;
  final String email;
  final String role;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id:    json['usuarioID']     ?? json['id'] ?? 0,
      name:  json['nombre']        ?? json['nombreUsuario'] ?? json['name'] ?? '',
      email: json['nombreUsuario'] ?? json['email'] ?? '',
      role:  json['rolNombre']     ?? (json['rolID'] != null ? 'Rol ${json['rolID']}' : '') ?? json['role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'name':  name,
    'email': email,
    'role':  role,
  };

  @override
  String toString() => 'UserModel(id: $id, name: $name, email: $email, role: $role)';
}
