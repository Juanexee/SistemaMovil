// =========================================================
// dashboard_repository.dart
// Obtiene KPIs y tendencias para el dashboard gerencial
// Cubre RF-MOV-DSH-01 y RF-MOV-DSH-02
// =========================================================
import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/dashboard_model.dart';

class DashboardRepository {
  final ApiClient _client;

  DashboardRepository(this._client);

  // KPIs: ventas del dia, ticket promedio, margen acumulado
  Future<KpisModel> getKpis() async {
    final json = await _client.get(ApiConstants.dashboardKpis);
    return KpisModel.fromJson(json as Map<String, dynamic>);
  }

  // Tendencias de ventas para los graficos comparativos
  Future<List<TendenciaModel>> getTendencias() async {
    final json = await _client.get(ApiConstants.dashboardTendencias);
    if (json is! List) throw Exception('Se esperaba una lista de tendencias');
    return json
        .map((e) => TendenciaModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
