// =========================================================
// rol_repository.dart
// Gestion de roles para el RBAC â€” RF-MOV-AUT-03
// =========================================================
import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/rol_model.dart';

class RolRepository {
  final ApiClient _client;

  RolRepository(this._client);

  Future<List<RolModel>> leer() async {
    final json = await _client.get(ApiConstants.rolLeer);
    if (json is! List) throw Exception('Se esperaba lista de roles');
    return json.map((e) => RolModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> crear(RolModel rol) async {
    await _client.post(ApiConstants.rolCrear, body: rol.toJson());
  }

  Future<void> actualizar(RolModel rol) async {
    await _client.put(ApiConstants.rolActualizar, body: rol.toJson());
  }

  Future<void> desactivar(int id) async {
    await _client.put(ApiConstants.rolDesactivar(id));
  }
}
