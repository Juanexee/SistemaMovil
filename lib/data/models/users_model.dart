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

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? role,
    int? rolId,
    String? password,
    bool? activo,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      rolId: rolId ?? this.rolId,
      password: password ?? this.password,
      activo: activo ?? this.activo,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final rawRolId =
        json['rolID'] ?? json['rolId'] ?? json['idRol'] ?? json['RolID'];
    final int? parsedRolId = rawRolId is int
        ? rawRolId
        : (rawRolId != null ? int.tryParse(rawRolId.toString()) : null);

    final act = json['activo'] ??
        json['Activo'] ??
        json['estado'] ??
        json['Estado'] ??
        json['status'] ??
        json['isActivo'];

    bool parsedActivo = true;
    if (act != null) {
      if (act is bool) {
        parsedActivo = act;
      } else if (act is num) {
        parsedActivo = act != 0;
      } else {
        final s = act.toString().trim().toLowerCase();
        parsedActivo =
            s == 'true' || s == '1' || s == 'activo' || s == 'active' || s == 'si';
      }
    }

    String? roleFromId(int? id) {
      switch (id) {
        case 1:
          return 'Administrador';
        case 2:
        case 3:
          return 'Mesero';
        case 4:
          return 'Cajero';
        case 1004:
          return 'Gerente';
        case 1005:
          return 'Supervisor';
        default:
          return id != null ? 'Rol $id' : null;
      }
    }

    final rawRole = json['rolNombre'] ??
        json['nombreRol'] ??
        json['role'] ??
        json['RolNombre'] ??
        roleFromId(parsedRolId) ??
        '';

    final rawId = json['usuarioID'] ??
        json['usuarioId'] ??
        json['UsuarioID'] ??
        json['id'] ??
        json['Id'] ??
        0;
    final parsedId = rawId is int
        ? rawId
        : (int.tryParse(rawId.toString()) ?? 0);

    return UserModel(
      id: parsedId,
      name: (json['nombre'] ??
              json['nombreCompleto'] ??
              json['NombreCompleto'] ??
              json['Nombre'] ??
              json['name'] ??
              '')
          .toString(),
      email: (json['nombreUsuario'] ??
              json['NombreUsuario'] ??
              json['email'] ??
              json['usuario'] ??
              '')
          .toString(),
      role: rawRole.toString(),
      rolId: parsedRolId,
      activo: parsedActivo,
    );
  }

  Map<String, dynamic> toJson() => {
        if (id > 0) 'id': id,
        if (id > 0) 'usuarioID': id,
        'nombre': name,
        'nombreCompleto': name,
        'nombreUsuario': email,
        'usuario': email,
        if (password != null && password!.isNotEmpty) 'clave': password,
        if (password != null && password!.isNotEmpty) 'password': password,
        if (rolId != null) 'rolId': rolId,
        if (rolId != null) 'rolID': rolId,
        if (rolId != null) 'idRol': rolId,
        'rolNombre': role,
        'activo': activo,
        'isActivo': activo,
        'name': name,
        'email': email,
        'role': role,
      };

  Map<String, dynamic> toUpdateJson() => {
        if (id > 0) 'id': id,
        if (id > 0) 'usuarioID': id,
        'nombre': name,
        'nombreCompleto': name,
        'nombreUsuario': email,
        'usuario': email,
        if (rolId != null) 'rolId': rolId,
        if (rolId != null) 'rolID': rolId,
        if (rolId != null) 'idRol': rolId,
        'rolNombre': role,
        'activo': activo,
        'isActivo': activo,
        'name': name,
        'email': email,
        'role': role,
      };

  @override
  String toString() =>
      'UserModel(id: $id, name: $name, email: $email, role: $role, rolId: $rolId, activo: $activo)';
}
