// =========================================================
// auth_model.dart
// Modelos para el login: lo que mando y lo que recibo
// =========================================================
import 'dart:convert';

// Lo que mando al servidor para iniciar sesion
class LoginRequest {
  final String usuario;
  final String password;

  LoginRequest({
    String? usuario,
    String? email,
    required this.password,
  }) : usuario = usuario ?? email ?? '';

  Map<String, dynamic> toJson() => {
        'nombreUsuario': usuario,
        'NombreUsuario': usuario,
        'usuario': usuario,
        'email': usuario,
        'password': password,
        'Password': password,
      };
}

// Lo que me regresa el servidor despues de un login exitoso
class LoginResponse {
  final String token; // El JWT que uso en todas las peticiones
  final String userName; // Nombre del usuario que inicio sesion
  final String role; // Su rol: Gerente, Administrador, Supervisor, Mesero
  final String? expiresAt; // Cuando expira el token (puede venir o no)

  LoginResponse({
    required this.token,
    required this.userName,
    required this.role,
    this.expiresAt,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final rawToken = (json['token'] ?? json['Token'] ?? '').toString().trim();

    // Extraemos claims del JWT en caso de que el rol o usuario venga codificado dentro del token
    Map<String, dynamic> jwtClaims = {};
    if (rawToken.contains('.')) {
      try {
        final parts = rawToken.split('.');
        if (parts.length >= 2) {
          final normalized = base64Url.normalize(parts[1]);
          final payloadStr = utf8.decode(base64Url.decode(normalized));
          final decoded = jsonDecode(payloadStr);
          if (decoded is Map<String, dynamic>) {
            jwtClaims = decoded;
          }
        }
      } catch (_) {}
    }

    // Mapeo exhaustivo de rol desde JSON o desde los claims del JWT
    final rawRole = json['role'] ??
        json['Role'] ??
        json['rol'] ??
        json['Rol'] ??
        json['rolNombre'] ??
        json['RolNombre'] ??
        json['nombreRol'] ??
        json['rolID'] ??
        json['rolId'] ??
        json['idRol'] ??
        jwtClaims['role'] ??
        jwtClaims['Role'] ??
        jwtClaims['rol'] ??
        jwtClaims['rolId'] ??
        jwtClaims['rolID'] ??
        jwtClaims[
            'http://schemas.microsoft.com/ws/2008/06/identity/claims/role'] ??
        '';

    // Mapeo exhaustivo de nombre de usuario desde JSON o JWT
    final rawUser = json['userName'] ??
        json['UserName'] ??
        json['nombreUsuario'] ??
        json['NombreUsuario'] ??
        json['nombre'] ??
        json['Nombre'] ??
        jwtClaims['unique_name'] ??
        jwtClaims['name'] ??
        jwtClaims[
            'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name'] ??
        jwtClaims['sub'] ??
        '';

    return LoginResponse(
      token: rawToken,
      userName: rawUser.toString(),
      role: rawRole.toString(),
      expiresAt: (json['expiresAt'] ?? json['ExpiresAt'])?.toString(),
    );
  }
}
