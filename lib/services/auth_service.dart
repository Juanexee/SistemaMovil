// =========================================================
// auth_service.dart
// Logica de autenticacion y control de roles (RBAC)
// Cubre RF-MOV-AUT-01, RF-MOV-AUT-02, RF-MOV-AUT-03
// =========================================================
import '../data/repositories/auth_repository.dart';
import '../data/models/auth_model.dart';
import '../services/secure_storage_service.dart';

class AuthService {
  final AuthRepository _authRepository;
  final SecureStorageService _storage;

  AuthService(this._authRepository, this._storage);

  // Inicia sesion: manda las credenciales y guarda el token
  Future<LoginResponse> login(String usuario, String password) async {
    final request = LoginRequest(usuario: usuario, password: password);
    return await _authRepository.login(request);
  }

  // Cierra sesion: borra el token y todos los datos guardados
  Future<void> logout() async {
    await _authRepository.logout();
  }

  // Verifica si el usuario ya inicio sesion (hay token guardado)
  Future<bool> isLoggedIn() async {
    return await _storage.isLoggedIn();
  }

  // Obtiene el rol del usuario guardado â€” para RBAC (RF-MOV-AUT-03)
  // Con esto controlo que pantallas puede ver cada usuario
  Future<String?> getUserRole() async {
    return await _storage.getRole();
  }

  // Verifica si el usuario tiene un rol especifico
  // Ejemplo: if (await authService.hasRole('Gerente')) { ... }
  Future<bool> hasRole(String role) async {
    final userRole = await _storage.getRole();
    return userRole == role;
  }

  // Verifica si el usuario tiene alguno de los roles permitidos
  // Ejemplo: hasAnyRole(['Gerente', 'Administrador'])
  Future<bool> hasAnyRole(List<String> roles) async {
    final userRole = await _storage.getRole();
    return roles.contains(userRole);
  }

  Future<String?> getUserName() async {
    return await _storage.getUserName();
  }
}
