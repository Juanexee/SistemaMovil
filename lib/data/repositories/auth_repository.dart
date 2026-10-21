// =========================================================
// auth_repository.dart
// Maneja el inicio de sesion y guarda el token JWT
// Cubre RF-MOV-AUT-01 y RF-MOV-AUT-02
// =========================================================
import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/auth_model.dart';
import '../../services/secure_storage_service.dart';

class AuthRepository {
  final ApiClient _client;
  final SecureStorageService _storage;

  AuthRepository(this._client, this._storage);

  // Manda las credenciales al servidor y guarda el token si el login es exitoso
  Future<LoginResponse> login(LoginRequest request) async {
    // POST al endpoint de login con email y password
    final json = await _client.post(
      ApiConstants.login,
      body: request.toJson(),
    );

    // Convierto la respuesta a mi modelo
    final loginResponse = LoginResponse.fromJson(json as Map<String, dynamic>);

    // Guardo el token y datos del usuario de forma segura en el dispositivo
    // Esto cumple con RNF-MOV-SEG-02 del TDR
    await _storage.saveToken(loginResponse.token);
    await _storage.saveRole(loginResponse.role);
    await _storage.saveUserName(loginResponse.userName);

    return loginResponse;
  }

  // Cierra la sesion borrando todos los datos guardados
  Future<void> logout() async {
    await _storage.clearAll();
  }
}
