// =========================================================
// insumos_repository.dart
// =========================================================
import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/insumos_model.dart';

class InsumosRepository {
  final ApiClient _client;

  InsumosRepository(this._client);

  Future<List<InsumoModel>> leer() async {
    final json = await _client.get(ApiConstants.insumosLeer);
    if (json is! List) throw Exception('Se esperaba lista de insumos');
    return json.map((e) => InsumoModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> insertar(InsumoModel insumo) async {
    await _client.post(ApiConstants.insumosInsertar, body: insumo.toJson());
  }
}
