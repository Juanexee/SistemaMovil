// =========================================================
// unidades_medida_repository.dart
// =========================================================
import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/unidades_medida_model.dart';

class UnidadesMedidaRepository {
  final ApiClient _client;

  UnidadesMedidaRepository(this._client);

  Future<List<UnidadMedidaModel>> leer() async {
    final json = await _client.get(ApiConstants.unidadesMedidaLeer);
    if (json is! List) throw Exception('Se esperaba lista de unidades');
    return json.map((e) => UnidadMedidaModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> insertar(UnidadMedidaModel unidad) async {
    await _client.post(ApiConstants.unidadesMedidaInsertar, body: unidad.toJson());
  }
}
