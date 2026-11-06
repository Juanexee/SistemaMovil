// =========================================================
// inventario_repository.dart
// Monitoreo del inventario y alertas de stock critico
// Cubre RF-MOV-MON-01 y RF-MOV-MON-02
// =========================================================
import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/inventario_model.dart';

class InventarioRepository {
  final ApiClient _client;

  InventarioRepository(this._client);

  // Estado global del inventario (existencias, valoracion, tasa de alerta)
  Future<ResumenInventarioModel> getResumen() async {
    final json = await _client.get(ApiConstants.inventarioResumen);
    if (json is Map<String, dynamic>) {
      return ResumenInventarioModel.fromJson(json);
    }
    throw Exception('Respuesta inválida de resumen de inventario');
  }

  // Insumos que alcanzaron o superaron el stock minimo — para notificaciones
  Future<List<AlertaStockModel>> getAlertas() async {
    final json = await _client.get(ApiConstants.inventarioAlertas);
    List<dynamic> list = [];
    if (json is List) {
      list = json;
    } else if (json is Map<String, dynamic>) {
      if (json['alertas'] is List) {
        list = json['alertas'] as List;
      } else if (json['data'] is List) {
        list = json['data'] as List;
      } else if (json['items'] is List) {
        list = json['items'] as List;
      } else if (json['insumos'] is List) {
        list = json['insumos'] as List;
      }
    } else {
      throw Exception('Se esperaba una lista de alertas');
    }
    return list
        .map((e) => AlertaStockModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
