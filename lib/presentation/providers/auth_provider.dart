// =========================================================
// auth_provider.dart
// Gestiona el estado de autenticación (Login, Logout y Roles)
// =========================================================
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../data/models/auth_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  AuthProvider(this._authService);

  bool _isLoading = false;
  String _errorMessage = '';
  LoginResponse? _loginResponse; // Almacena la respuesta exitosa del login

  // Getters para que la pantalla pueda leer el estado
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  LoginResponse? get loginResponse => _loginResponse;

  // Método para iniciar sesión
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners(); // Avisa a la pantalla que está cargando

    try {
      // El servicio retorna un LoginResponse (que incluye token, nombre y rol)
      _loginResponse = await _authService.login(email, password);

      _isLoading = false;
      notifyListeners();
      return true; // Login exitoso
    } catch (e) {
      _errorMessage = 'Credenciales incorrectas o error de red: $e';
      _isLoading = false;
      notifyListeners();
      return false; // Falló el login
    }
  }

  // Método para cerrar sesión
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await _authService.logout();
    _loginResponse = null; // Limpiamos los datos del usuario

    _isLoading = false;
    notifyListeners();
  }

  // Método para verificar si ya está logueado al abrir la app
  Future<bool> checkLoginStatus() async {
    return await _authService.isLoggedIn();
  }
}
