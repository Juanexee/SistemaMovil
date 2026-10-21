// =========================================================
// platillo_repository.dart
// CRUD completo de platillos del menu
// =========================================================
import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/platillo_model.dart';

class PlatilloRepository {
  final ApiClient _client;

  PlatilloRepository(this._client);

  Future<List<PlatilloModel>> leer() async {
    final json = await _client.get(ApiConstants.platilloLeer);
    if (json is! List) throw Exception('Se esperaba lista de platillos');
    return json.map((e) => PlatilloModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<PlatilloModel> porId(int id) async {
    final json = await _client.get(ApiConstants.platilloPorId(id));
    return PlatilloModel.fromJson(json as Map<String, dynamic>);
  }

  Future<void> insertar(PlatilloModel platillo) async {
    await _client.post(ApiConstants.platilloInsertar, body: platillo.toJson());
  }

  Future<void> actualizar(int id, PlatilloModel platillo) async {
    await _client.put(ApiConstants.platilloActualizar(id), body: platillo.toJson());
  }

  Future<void> actualizarDisponibilidad(int id, bool disponible) async {
    await _client.put(
      ApiConstants.platilloDisponibilidad(id),
      body: {'disponible': disponible},
    );
  }
}
