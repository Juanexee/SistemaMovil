// =========================================================
// metrics_repository.dart
// Consulta las métricas de rendimiento de la API y memoria/CPU
// almacenadas en MongoDB:
// - GET /api/Metrics/api-usage
// - GET /api/Metrics/memory
// - GET /api/Metrics/summary
// =========================================================
import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/metrics_model.dart';

class MetricsRepository {
  final ApiClient _client;

  MetricsRepository(this._client);

  // Obtiene los registros recientes de uso y tiempos de respuesta de la API (apiUsageLogs)
  Future<List<ApiUsageLogModel>> getApiUsage({
    Map<String, String>? queryParameters,
  }) async {
    final json = await _client.get(
      ApiConstants.metricsApiUsage,
      queryParameters: queryParameters,
    );

    List<dynamic> list = [];
    if (json is List) {
      list = json;
    } else if (json is Map<String, dynamic>) {
      if (json['apiUsageLogs'] is List) {
        list = json['apiUsageLogs'] as List;
      } else if (json['logs'] is List) {
        list = json['logs'] as List;
      } else if (json['data'] is List) {
        list = json['data'] as List;
      } else if (json['items'] is List) {
        list = json['items'] as List;
      } else if (json['resultado'] is List) {
        list = json['resultado'] as List;
      }
    } else {
      throw Exception('Se esperaba una lista de métricas de uso de API');
    }

    return list
        .whereType<Map<String, dynamic>>()
        .map(ApiUsageLogModel.fromJson)
        .toList();
  }

  // Obtiene las métricas recientes de memoria y CPU del servidor (memoryMetrics)
  Future<List<MemoryMetricModel>> getMemoryMetrics({
    Map<String, String>? queryParameters,
  }) async {
    final json = await _client.get(
      ApiConstants.metricsMemory,
      queryParameters: queryParameters,
    );

    List<dynamic> list = [];
    if (json is List) {
      list = json;
    } else if (json is Map<String, dynamic>) {
      if (json['memoryMetrics'] is List) {
        list = json['memoryMetrics'] as List;
      } else if (json['metrics'] is List) {
        list = json['metrics'] as List;
      } else if (json['data'] is List) {
        list = json['data'] as List;
      } else if (json['items'] is List) {
        list = json['items'] as List;
      } else if (json['resultado'] is List) {
        list = json['resultado'] as List;
      }
    } else {
      throw Exception('Se esperaba una lista de métricas de memoria');
    }

    return list
        .whereType<Map<String, dynamic>>()
        .map(MemoryMetricModel.fromJson)
        .toList();
  }

  // Obtiene un resumen consolidado de rendimiento de la API y el último estado de memoria/CPU
  Future<MetricsSummaryModel> getSummary() async {
    final json = await _client.get(ApiConstants.metricsSummary);
    if (json is Map<String, dynamic>) {
      final data = json['data'] is Map<String, dynamic>
          ? json['data'] as Map<String, dynamic>
          : json;
      return MetricsSummaryModel.fromJson(data);
    }
    throw Exception('Se esperaba un objeto de resumen de métricas');
  }
}

