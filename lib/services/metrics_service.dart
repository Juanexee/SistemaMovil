// =========================================================
// metrics_service.dart
// Servicio para consultar las métricas de rendimiento de la API
// y uso de memoria/CPU desde MongoDB
// =========================================================
import '../data/repositories/metrics_repository.dart';
import '../data/models/metrics_model.dart';

class MetricsService {
  final MetricsRepository _repository;

  MetricsService(this._repository);

  Future<List<ApiUsageLogModel>> getApiUsage({
    Map<String, String>? filtros,
  }) async {
    return await _repository.getApiUsage(queryParameters: filtros);
  }

  Future<List<MemoryMetricModel>> getMemoryMetrics({
    Map<String, String>? filtros,
  }) async {
    return await _repository.getMemoryMetrics(queryParameters: filtros);
  }

  Future<MetricsSummaryModel> getSummary() async {
    return await _repository.getSummary();
  }
}

