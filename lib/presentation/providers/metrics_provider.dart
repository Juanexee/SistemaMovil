// =========================================================
// metrics_provider.dart
// Gestiona el estado de las métricas de rendimiento de la API
// y el monitoreo de memoria/CPU del servidor (MongoDB)
// =========================================================
import 'package:flutter/material.dart';
import '../../services/metrics_service.dart';
import '../../data/models/metrics_model.dart';

class MetricsProvider extends ChangeNotifier {
  final MetricsService _metricsService;

  MetricsProvider(this._metricsService);

  bool _isLoading = false;
  String _errorMessage = '';
  MetricsSummaryModel? _summary;
  List<ApiUsageLogModel> _apiUsageLogs = [];
  List<MemoryMetricModel> _memoryMetrics = [];

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  MetricsSummaryModel? get summary => _summary;
  List<ApiUsageLogModel> get apiUsageLogs => _apiUsageLogs;
  List<MemoryMetricModel> get memoryMetrics => _memoryMetrics;

  // Carga los 3 endpoints de Metrics en paralelo
  Future<void> loadMetrics() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    bool anySuccess = false;
    String lastError = '';

    final results = await Future.wait([
      _metricsService.getSummary().then<MetricsSummaryModel?>((v) {
        anySuccess = true;
        return v;
      }).catchError((e) {
        lastError = e.toString();
        return null;
      }),
      _metricsService.getApiUsage().then<List<ApiUsageLogModel>>((v) {
        anySuccess = true;
        return v;
      }).catchError((e) {
        lastError = e.toString();
        return <ApiUsageLogModel>[];
      }),
      _metricsService.getMemoryMetrics().then<List<MemoryMetricModel>>((v) {
        anySuccess = true;
        return v;
      }).catchError((e) {
        lastError = e.toString();
        return <MemoryMetricModel>[];
      }),
    ]);

    final fetchedSummary = results[0] as MetricsSummaryModel?;
    _apiUsageLogs = results[1] as List<ApiUsageLogModel>;
    _memoryMetrics = results[2] as List<MemoryMetricModel>;

    // Si /api/Metrics/summary viene vacío o con ceros pero tenemos las listas,
    // consolidamos los indicadores para asegurar datos precisos en la vista
    if (fetchedSummary != null &&
        (fetchedSummary.totalRequests > 0 ||
            fetchedSummary.currentMemoryMb > 0)) {
      _summary = fetchedSummary;
    } else if (_apiUsageLogs.isNotEmpty || _memoryMetrics.isNotEmpty) {
      final totalReq = fetchedSummary != null && fetchedSummary.totalRequests > 0
          ? fetchedSummary.totalRequests
          : _apiUsageLogs.length;
      final avgMs = _apiUsageLogs.isNotEmpty
          ? _apiUsageLogs.fold<double>(
                  0.0, (s, l) => s + l.responseTimeMs) /
              _apiUsageLogs.length
          : (fetchedSummary?.averageResponseTimeMs ?? 0.0);
      final maxMs = _apiUsageLogs.isNotEmpty
          ? _apiUsageLogs
              .map((l) => l.responseTimeMs)
              .reduce((a, b) => a > b ? a : b)
          : (fetchedSummary?.maxResponseTimeMs ?? 0.0);
      final minMs = _apiUsageLogs.isNotEmpty
          ? _apiUsageLogs
              .map((l) => l.responseTimeMs)
              .reduce((a, b) => a < b ? a : b)
          : (fetchedSummary?.minResponseTimeMs ?? 0.0);
      final errors = _apiUsageLogs.where((l) => l.statusCode >= 400).length;
      final errRate = totalReq > 0 ? (errors / totalReq) * 100 : 0.0;
      final latestMem =
          _memoryMetrics.isNotEmpty ? _memoryMetrics.first : fetchedSummary?.latestMemory;

      _summary = MetricsSummaryModel(
        totalRequests: totalReq,
        averageResponseTimeMs: avgMs,
        maxResponseTimeMs: maxMs,
        minResponseTimeMs: minMs,
        errorCount: errors,
        errorRatePercent: errRate,
        currentMemoryMb: latestMem?.workingSetMb ?? 0.0,
        currentCpuPercent: latestMem?.cpuUsagePercent ?? 0.0,
        latestMemory: latestMem,
      );
    } else {
      _summary = fetchedSummary;
    }

    if (!anySuccess && lastError.isNotEmpty) {
      _errorMessage =
          'No se pudieron obtener las métricas del servidor: ${lastError.replaceFirst("Exception: ", "")}';
    }

    _isLoading = false;
    notifyListeners();
  }

  void clear() {
    _summary = null;
    _apiUsageLogs = [];
    _memoryMetrics = [];
    _errorMessage = '';
    _isLoading = false;
    notifyListeners();
  }
}

