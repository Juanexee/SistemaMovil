// =========================================================
// users_model.dart
// Modelo de usuario con fromJson y toJson
// =========================================================
class UserModel {
  final int id;
  final String name;
  final String email;
  final String role;
  final int? rolId;
  final String? password;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.rolId,
    this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final rId = json['rolID'] ?? json['rolId'] ?? json['idRol'];
    return UserModel(
      id:       json['usuarioID']     ?? json['id'] ?? 0,
      name:     json['nombre']        ?? json['nombreCompleto'] ?? json['name'] ?? '',
      email:    json['nombreUsuario'] ?? json['email'] ?? json['usuario'] ?? '',
      role:     json['rolNombre']     ?? json['nombreRol'] ?? (rId != null ? 'Rol $rId' : '') ?? json['role'] ?? '',
      rolId:    rId is int ? rId : (rId != null ? int.tryParse(rId.toString()) : null),
    );
  }

  Map<String, dynamic> toJson() => {
    if (id > 0) 'usuarioID': id,
    'nombre':          name,
    'nombreUsuario':   email,
    'usuario':         email,
    if (password != null && password!.isNotEmpty) 'clave': password,
    if (password != null && password!.isNotEmpty) 'password': password,
    if (rolId != null) 'rolID': rolId,
    if (rolId != null) 'rolId': rolId,
    'rolNombre':       role,
    // Compatibilidad con contratos genéricos
    'name':            name,
    'email':           email,
    'role':            role,
  };

  @override
  String toString() => 'UserModel(id: $id, name: $name, email: $email, role: $role, rolId: $rolId)';
}
