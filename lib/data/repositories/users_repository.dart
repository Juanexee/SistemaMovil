// =========================================================
// users_repository.dart
// CRUD de usuarios del sistema
// =========================================================
import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/users_model.dart';

class UsersRepository {
  final ApiClient _client;

  UsersRepository(this._client);

  Future<List<UserModel>> getUsers() async {
    final dynamic json = await _client.get(ApiConstants.usuarioLeer);
    if (json is! List) throw Exception('Se esperaba lista de usuarios');
    return json
        .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> crear(UserModel usuario) async {
    await _client.post(ApiConstants.usuarioCrear, body: usuario.toJson());
  }

  Future<void> actualizar(int id, UserModel usuario) async {
    await _client.put(ApiConstants.usuarioActualizar(id), body: usuario.toJson());
  }

  Future<void> eliminar(int id) async {
    await _client.put(ApiConstants.usuarioEliminar(id));
  }
}
