// =========================================================
// auth_model.dart
// Modelos para el login: lo que mando y lo que recibo
// =========================================================

// Lo que mando al servidor para iniciar sesion
class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  // Convierto el objeto a Map para mandarlo como JSON en el POST
  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
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
      token:     json['token']     ?? '',
      userName:  json['userName']  ?? '',
      role:      json['role']      ?? '',
      expiresAt: json['expiresAt'],
    );
  }
}
