// =========================================================
// mesas_repository.dart
// CRUD completo de mesas del restaurante
// =========================================================
import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/mesas_model.dart';

class MesasRepository {
  final ApiClient _client;

  MesasRepository(this._client);

  Future<List<MesaModel>> leer() async {
    final json = await _client.get(ApiConstants.mesasLeer);
    if (json is! List) throw Exception('Se esperaba lista de mesas');
    return json.map((e) => MesaModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> insertar(MesaModel mesa) async {
    await _client.post(ApiConstants.mesasInsertar, body: mesa.toJson());
  }

  Future<void> actualizar(int id, MesaModel mesa) async {
    await _client.put(ApiConstants.mesasActualizar(id), body: mesa.toJson());
  }

  Future<void> eliminar(int id) async {
    await _client.delete(ApiConstants.mesasEliminar(id));
  }
}
