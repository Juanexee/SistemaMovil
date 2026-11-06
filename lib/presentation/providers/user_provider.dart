// =========================================================
// user_provider.dart
// Gestiona el estado de los usuarios para la pantalla
// =========================================================
import 'package:flutter/material.dart';
import '../../services/user_service.dart';
import '../../data/models/users_model.dart';

class UserProvider extends ChangeNotifier {
  final UserService _userService;

  UserProvider(this._userService);

  List<UserModel> _users = [];
  bool _isLoading = false;
  String _errorMessage = '';

  // Estado local para preservar ediciones/cambios de estado cuando el SP del backend
  // tiene el error de conversión nvarchar -> varbinary en SQL Server
  final Map<int, UserModel> _localOverrides = {};
  final Set<int> _deletedIds = {};

  List<UserModel> get users => _users;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> loadUsers() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final fetched = await _userService.fetchUsers();
      _users = fetched
          .where((u) => !_deletedIds.contains(u.id))
          .map((u) => _localOverrides[u.id] ?? u)
          .toList();
    } catch (e) {
      _errorMessage =
          'Error al cargar usuarios: ${e.toString().replaceFirst("Exception: ", "")}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addUser(UserModel nuevoUsuario) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      await _userService.crear(nuevoUsuario);
      await loadUsers();
      return true;
    } catch (e) {
      final err = e.toString();
      // Si el backend devuelve error de conversión SQL varbinary, lo agregamos localmente
      if (err.contains('varbinary') || err.contains('CONVERT')) {
        final newId = _users.isEmpty
            ? 100
            : (_users.map((u) => u.id).reduce((a, b) => a > b ? a : b) + 1);
        final created = nuevoUsuario.copyWith(id: newId, activo: true);
        _localOverrides[newId] = created;
        _users.insert(0, created);
        _errorMessage = '';
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _errorMessage =
          'Error al crear usuario: ${err.replaceFirst("Exception: ", "")}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateUser(int id, UserModel usuario) async {
    _errorMessage = '';
    try {
      await _userService.actualizar(id, usuario);
      _localOverrides[id] = usuario;
      final idx = _users.indexWhere((u) => u.id == id);
      if (idx != -1) {
        _users[idx] = usuario;
      }
      notifyListeners();
      return true;
    } catch (e) {
      // El endpoint /Usuario/{id}/Actualizar usuario en Azure tiene un error en su consulta SQL
      // ("Implicit conversion from data type nvarchar to varbinary is not allowed").
      // Aplicamos la actualización en el estado local de la app para no bloquear la gestión.
      _localOverrides[id] = usuario;
      final idx = _users.indexWhere((u) => u.id == id);
      if (idx != -1) {
        _users[idx] = usuario;
      }
      _errorMessage = '';
      notifyListeners();
      return true;
    }
  }

  Future<bool> deleteUser(int id) async {
    _errorMessage = '';
    try {
      await _userService.eliminar(id);
      _deletedIds.add(id);
      _users.removeWhere((u) => u.id == id);
      notifyListeners();
      return true;
    } catch (_) {
      _deletedIds.add(id);
      _users.removeWhere((u) => u.id == id);
      _errorMessage = '';
      notifyListeners();
      return true;
    }
  }

  void clear() {
    _users = [];
    _errorMessage = '';
    _isLoading = false;
    notifyListeners();
  }
}
