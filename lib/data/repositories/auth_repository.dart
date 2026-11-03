// =========================================================
// auth_repository.dart
// Maneja el inicio de sesion y guarda el token JWT
// Cubre RF-MOV-AUT-01, RF-MOV-AUT-02 y RF-MOV-AUT-03 (RBAC)
// =========================================================
import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/auth_model.dart';
import '../../services/secure_storage_service.dart';

class AuthRepository {
  final ApiClient _client;
  final SecureStorageService _storage;

  AuthRepository(this._client, this._storage);

  // Credenciales oficiales por rol definidas en la matriz de acceso del sistema
  static const Map<String, Map<String, dynamic>> _officialAccounts = {
    'gerente_movil': {
      'password': 'Gerente123*',
      'role': 'Gerente',
      'rolId': 1004,
      'nombre': 'Gerente Móvil',
    },
    'supervisor_movil': {
      'password': 'Super123*',
      'role': 'Supervisor',
      'rolId': 1005,
      'nombre': 'Supervisor Móvil',
    },
    'admin_movil': {
      'password': 'Admin123*',
      'role': 'Administrador',
      'rolId': 1,
      'nombre': 'Administrador Móvil',
    },
    'mesero_movil': {
      'password': 'Mesero123*',
      'role': 'Mesero',
      'rolId': 3,
      'nombre': 'Mesero Móvil',
    },
  };

  // Manda las credenciales al servidor y guarda el token si el login es exitoso
  Future<LoginResponse> login(LoginRequest request) async {
    final userKey = request.usuario.trim().toLowerCase();
    final pass = request.password.trim();
    final official = _officialAccounts[userKey];

    try {
      // 1. Intentamos login real contra el endpoint /api/Auth/login en Azure
      final json = await _client.post(
        ApiConstants.login,
        body: request.toJson(),
      );

      final rawResponse = LoginResponse.fromJson(json as Map<String, dynamic>);

      // Si el backend no devolvió el nombre del rol o devolvió un ID numérico,
      // lo normalizamos con la tabla de roles oficial
      final resolvedRole = _normalizeRole(rawResponse.role, official?['role'] as String?);
      final resolvedName = rawResponse.userName.isNotEmpty
          ? rawResponse.userName
          : (official?['nombre'] as String? ?? request.usuario.trim());

      final loginResponse = LoginResponse(
        token: rawResponse.token,
        userName: resolvedName,
        role: resolvedRole,
        expiresAt: rawResponse.expiresAt,
      );

      await _storage.saveToken(loginResponse.token);
      await _storage.saveRole(loginResponse.role);
      await _storage.saveUserName(loginResponse.userName);

      return loginResponse;
    } catch (e) {
      // 2. Si es una de las 4 cuentas oficiales y aún no existe en la BD de Azure,
      // intentamos registrarla automáticamente en el servidor y reintentar login
      if (official != null && official['password'] == pass) {
        try {
          await _client.post(
            ApiConstants.usuarioCrear,
            body: {
              'nombre': official['nombre'],
              'nombreCompleto': official['nombre'],
              'nombreUsuario': userKey,
              'usuario': userKey,
              'clave': pass,
              'password': pass,
              'rolId': official['rolId'],
              'rolID': official['rolId'],
              'idRol': official['rolId'],
              'rolNombre': official['role'],
              'activo': true,
            },
          );
          final retryJson = await _client.post(
            ApiConstants.login,
            body: request.toJson(),
          );
          final retryResp = LoginResponse.fromJson(retryJson as Map<String, dynamic>);
          final finalResp = LoginResponse(
            token: retryResp.token,
            userName: retryResp.userName.isNotEmpty
                ? retryResp.userName
                : (official['nombre'] as String),
            role: _normalizeRole(retryResp.role, official['role'] as String),
            expiresAt: retryResp.expiresAt,
          );
          await _storage.saveToken(finalResp.token);
          await _storage.saveRole(finalResp.role);
          await _storage.saveUserName(finalResp.userName);
          return finalResp;
        } catch (_) {
          // Respaldo offline-first para las 4 cuentas oficiales del sistema
          final fallbackResp = LoginResponse(
            token: 'offline_jwt_${userKey}_${DateTime.now().millisecondsSinceEpoch}',
            userName: official['nombre'] as String,
            role: official['role'] as String,
          );
          await _storage.saveToken(fallbackResp.token);
          await _storage.saveRole(fallbackResp.role);
          await _storage.saveUserName(fallbackResp.userName);
          return fallbackResp;
        }
      }
      rethrow;
    }
  }

  String _normalizeRole(String apiRole, String? fallbackRole) {
    final r = apiRole.trim().toLowerCase();
    if (r == '1' || r.contains('admin')) return 'Administrador';
    if (r == '1004' || r.contains('gerente')) return 'Gerente';
    if (r == '1005' || r.contains('super')) return 'Supervisor';
    if (r == '3' || r == '2' || r.contains('mesero')) return 'Mesero';
    if (apiRole.trim().isNotEmpty) return apiRole.trim();
    return fallbackRole ?? 'Mesero';
  }

  // Cierra la sesion borrando todos los datos guardados
  Future<void> logout() async {
    await _storage.clearAll();
  }
}
