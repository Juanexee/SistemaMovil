// =========================================================
// user_provider.dart
// Gestiona el estado de los usuarios para la pantalla
// =========================================================
import 'package:flutter/material.dart';
import '../../services/user_service.dart';
import '../../data/models/users_model.dart';

class UserProvider extends ChangeNotifier {
  // El Provider depende directamente de la capa de Servicios (UserService)
  final UserService _userService;

  UserProvider(this._userService);

  // Variables de estado
  List<UserModel> _users = [];
  bool _isLoading = false;
  String _errorMessage = '';

  // Getters para que la pantalla pueda leer los datos de forma segura
  List<UserModel> get users => _users;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Método para cargar los usuarios llamando al servicio
  Future<void> loadUsers() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners(); // Avisa a la UI que empezó a cargar

    try {
      // Pide los datos al servicio que a su vez pasa por el repositorio y la API
      _users = await _userService.fetchUsers();
    } catch (e) {
      _errorMessage = 'Error al cargar usuarios: $e';
    } finally {
      _isLoading = false;
      notifyListeners(); // Avisa a la UI que terminó y renderiza los datos
    }
  }

  // Método para crear un usuario y refrescar la lista
  Future<bool> addUser(UserModel nuevoUsuario) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      await _userService.crear(nuevoUsuario);
      await loadUsers(); // Recarga la lista para mostrar el nuevo usuario
      return true;
    } catch (e) {
      _errorMessage = 'Error al crear usuario: ${e.toString().replaceFirst("Exception: ", "")}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Limpia los datos almacenados al cerrar sesión o cambiar de usuario
  void clear() {
    _users = [];
    _errorMessage = '';
    _isLoading = false;
    notifyListeners();
  }
}

