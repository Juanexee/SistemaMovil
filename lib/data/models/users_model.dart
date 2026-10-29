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
  final bool activo;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.rolId,
    this.password,
    this.activo = true,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final rawRolId = json['rolID'] ?? json['rolId'] ?? json['idRol'];
    final int? parsedRolId = rawRolId is int
        ? rawRolId
        : (rawRolId != null ? int.tryParse(rawRolId.toString()) : null);
    final act = json['activo'] ?? json['status'] ?? json['isActivo'] ?? true;

    String? roleFromId(int? id) {
      switch (id) {
        case 1:
          return 'Administrador';
        case 2:
          return 'Mesero';
        case 3:
          return 'Gerente';
        case 4:
          return 'Cajero';
        default:
          return id != null ? 'Rol $id' : null;
      }
    }

    final rawRole = json['rolNombre'] ??
        json['nombreRol'] ??
        json['role'] ??
        roleFromId(parsedRolId) ??
        '';

    return UserModel(
      id:       json['usuarioID']     ?? json['id'] ?? 0,
      name:     json['nombre']        ?? json['nombreCompleto'] ?? json['name'] ?? '',
      email:    json['nombreUsuario'] ?? json['email'] ?? json['usuario'] ?? '',
      role:     rawRole.toString(),
      rolId:    parsedRolId,
      activo:   act is bool ? act : (act.toString().toLowerCase() == 'true' || act == 1),
    );
  }

  Map<String, dynamic> toJson() => {
    if (id > 0) 'id': id,
    if (id > 0) 'usuarioID': id,
    'nombre':          name,
    'nombreCompleto':  name,
    'nombreUsuario':   email,
    'usuario':         email,
    if (password != null && password!.isNotEmpty) 'clave': password,
    if (password != null && password!.isNotEmpty) 'password': password,
    if (rolId != null) 'rolId': rolId,
    if (rolId != null) 'rolID': rolId,
    if (rolId != null) 'idRol': rolId,
    'rolNombre':       role,
    'activo':          activo,
    'isActivo':        activo,
    // Compatibilidad con contratos genéricos
    'name':            name,
    'email':           email,
    'role':            role,
  };

  // Payload específico para actualización (evita enviar strings a campos varbinary de password)
  Map<String, dynamic> toUpdateJson() => {
    if (id > 0) 'id': id,
    if (id > 0) 'usuarioID': id,
    'nombre':          name,
    'nombreCompleto':  name,
    'nombreUsuario':   email,
    'usuario':         email,
    if (rolId != null) 'rolId': rolId,
    if (rolId != null) 'rolID': rolId,
    if (rolId != null) 'idRol': rolId,
    'rolNombre':       role,
    'activo':          activo,
    'isActivo':        activo,
    'name':            name,
    'email':           email,
    'role':            role,
  };

  @override
  String toString() => 'UserModel(id: $id, name: $name, email: $email, role: $role, rolId: $rolId, activo: $activo)';
}
