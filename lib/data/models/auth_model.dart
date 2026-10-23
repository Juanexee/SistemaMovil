// =========================================================
// auth_model.dart
// Modelos para el login: lo que mando y lo que recibo
// =========================================================

// Lo que mando al servidor para iniciar sesion
class LoginRequest {
  final String usuario;
  final String password;

  LoginRequest({
    String? usuario,
    String? email,
    required this.password,
  }) : usuario = usuario ?? email ?? '';

  // Convierto el objeto a Map para mandarlo como JSON en el POST
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
  final String token;     // El JWT que uso en todas las peticiones
  final String userName;  // Nombre del usuario que inicio sesion
  final String role;      // Su rol: Gerente, Administrador, Supervisor
  final String? expiresAt;// Cuando expira el token (puede venir o no)

  LoginResponse({
    required this.token,
    required this.userName,
    required this.role,
    this.expiresAt,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token:     json['token'] ?? json['Token'] ?? '',
      userName:  json['userName'] ?? json['UserName'] ?? json['nombreUsuario'] ?? json['NombreUsuario'] ?? '',
      role:      json['role'] ?? json['Role'] ?? json['rol'] ?? json['Rol'] ?? '',
      expiresAt: json['expiresAt'] ?? json['ExpiresAt'],
    );
  }
}

