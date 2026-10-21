// =========================================================
// user_service.dart
// Logica de gestion de usuarios del sistema
// =========================================================
import '../data/repositories/users_repository.dart';
import '../data/models/users_model.dart';

class UserService {
  final UsersRepository _usersRepository;

  UserService(this._usersRepository);

  Future<List<UserModel>> fetchUsers()                    async => await _usersRepository.getUsers();
  Future<void> crear(UserModel usuario)                   async => await _usersRepository.crear(usuario);
  Future<void> actualizar(int id, UserModel usuario)      async => await _usersRepository.actualizar(id, usuario);
  Future<void> eliminar(int id)                           async => await _usersRepository.eliminar(id);
}
