// =========================================================
// secure_storage_service.dart
// Guarda el token JWT de forma segura en el dispositivo.
// Usa flutter_secure_storage que en Android usa KeyStore
// y en iOS usa Keychain. Mucho mas seguro que SharedPrefs.
// Cumple con RNF-MOV-SEG-02 del TDR.
// =========================================================
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  // Instancia del almacenamiento seguro del dispositivo
  final _storage = const FlutterSecureStorage();

  // Nombres de las claves donde guardo cada dato
  // Los pongo como constantes para no equivocarme al escribirlos
  static const String _keyToken    = 'jwt_token';
  static const String _keyRole     = 'user_role';
  static const String _keyUserName = 'user_name';
  static const String _keyUserId   = 'user_id';

  // -------------------------------------------------------
  // TOKEN JWT
  // -------------------------------------------------------

  // Guarda el token que nos da la API al hacer login
  Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  // Lee el token guardado â€” puede ser null si no hay sesion activa
  Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  // Borra el token al cerrar sesion
  Future<void> deleteToken() async {
    await _storage.delete(key: _keyToken);
  }

  // -------------------------------------------------------
  // ROL DEL USUARIO (RBAC â€” RF-MOV-AUT-03)
  // Guardo el rol para controlar a que pantallas puede entrar
  // -------------------------------------------------------

  Future<void> saveRole(String role) async {
    await _storage.write(key: _keyRole, value: role);
  }

  Future<String?> getRole() async {
    return await _storage.read(key: _keyRole);
  }

  // -------------------------------------------------------
  // DATOS DEL USUARIO
  // -------------------------------------------------------

  Future<void> saveUserName(String name) async {
    await _storage.write(key: _keyUserName, value: name);
  }

  Future<String?> getUserName() async {
    return await _storage.read(key: _keyUserName);
  }

  Future<void> saveUserId(String id) async {
    await _storage.write(key: _keyUserId, value: id);
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: _keyUserId);
  }

  // -------------------------------------------------------
  // VERIFICAR SESION
  // -------------------------------------------------------

  // Devuelve true si hay token guardado (= usuario logueado)
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // -------------------------------------------------------
  // CERRAR SESION â€” Borra todo lo guardado
  // Cumple con RNF-MOV-SEG-03: destruye el estado al expirar
  // -------------------------------------------------------
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
