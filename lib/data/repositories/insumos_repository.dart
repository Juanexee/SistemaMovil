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
    dynamic json;
    try {
      json = await _client.get(ApiConstants.insumosLeer);
    } catch (_) {
      json = await _client.get('/Insumos/Leer');
    }

    List<dynamic> list = [];
    if (json is List) {
      list = json;
    } else if (json is Map<String, dynamic>) {
      if (json['data'] is List) {
        list = json['data'] as List;
      } else if (json['insumos'] is List) {
        list = json['insumos'] as List;
      } else if (json['items'] is List) {
        list = json['items'] as List;
      }
    } else {
      throw Exception('Se esperaba lista de insumos');
    }

    return list
        .map((e) => InsumoModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> insertar(InsumoModel insumo) async {
    await _client.post(ApiConstants.insumosInsertar, body: insumo.toJson());
  }
}
