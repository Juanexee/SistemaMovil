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
    return ResumenInventarioModel.fromJson(json as Map<String, dynamic>);
  }

  // Insumos que alcanzaron o superaron el stock minimo â€” para notificaciones
  Future<List<AlertaStockModel>> getAlertas() async {
    final json = await _client.get(ApiConstants.inventarioAlertas);
    if (json is! List) throw Exception('Se esperaba una lista de alertas');
    return json
        .map((e) => AlertaStockModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
