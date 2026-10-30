// =========================================================
// metrics_model.dart
// Modelos para consultar las métricas de rendimiento de la API
// y el uso de memoria/CPU almacenadas en MongoDB:
// - /api/Metrics/api-usage (apiUsageLogs)
// - /api/Metrics/memory    (memoryMetrics)
// - /api/Metrics/summary   (resumen consolidado)
// =========================================================

double _parseDouble(dynamic val) {
  if (val == null) return 0.0;
  if (val is num) return val.toDouble();
  final clean = val.toString().replaceAll(RegExp(r'[^0-9.-]'), '');
  return double.tryParse(clean) ?? 0.0;
}

int _parseInt(dynamic val) {
  if (val == null) return 0;
  if (val is int) return val;
  if (val is num) return val.toInt();
  final clean = val.toString().replaceAll(RegExp(r'[^0-9-]'), '');
  return int.tryParse(clean) ?? 0;
}

// Registro de uso y tiempo de respuesta de la API (apiUsageLogs)
class ApiUsageLogModel {
  final String id;
  final String endpoint;
  final String method;
  final int statusCode;
  final double responseTimeMs;
  final String timestamp;
  final String? usuario;
  final String? clientIp;

  ApiUsageLogModel({
    required this.id,
    required this.endpoint,
    required this.method,
    required this.statusCode,
    required this.responseTimeMs,
    required this.timestamp,
    this.usuario,
    this.clientIp,
  });

  factory ApiUsageLogModel.fromJson(Map<String, dynamic> json) {
    return ApiUsageLogModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      endpoint: (json['endpoint'] ??
              json['path'] ??
              json['requestPath'] ??
              json['ruta'] ??
              json['url'] ??
              '/')
          .toString(),
      method: (json['method'] ??
              json['httpMethod'] ??
              json['metodo'] ??
              json['verb'] ??
              'GET')
          .toString()
          .toUpperCase(),
      statusCode: _parseInt(
        json['statusCode'] ??
            json['codigoEstado'] ??
            json['status'] ??
            json['httpStatusCode'] ??
            200,
      ),
      responseTimeMs: _parseDouble(
        json['responseTimeMs'] ??
            json['durationMs'] ??
            json['elapsedMs'] ??
            json['tiempoRespuestaMs'] ??
            json['tiempoMs'] ??
            json['responseTime'] ??
            json['duration'] ??
            json['elapsedMilliseconds'],
      ),
      timestamp: (json['timestamp'] ??
              json['fechaHora'] ??
              json['fecha'] ??
              json['createdAt'] ??
              json['date'] ??
              '')
          .toString(),
      usuario: (json['usuario'] ??
              json['userName'] ??
              json['nombreUsuario'] ??
              json['user'] ??
              json['userId'])
          ?.toString(),
      clientIp: (json['clientIp'] ?? json['ip'] ?? json['ipAddress'])?.toString(),
    );
  }
}

// Métrica de memoria y CPU del servidor desde MongoDB (memoryMetrics)
class MemoryMetricModel {
  final String id;
  final double workingSetMb;
  final double privateMemoryMb;
  final double gcTotalMemoryMb;
  final double cpuUsagePercent;
  final int threadCount;
  final String timestamp;

  MemoryMetricModel({
    required this.id,
    required this.workingSetMb,
    required this.privateMemoryMb,
    required this.gcTotalMemoryMb,
    required this.cpuUsagePercent,
    required this.threadCount,
    required this.timestamp,
  });

  factory MemoryMetricModel.fromJson(Map<String, dynamic> json) {
    // Algunos backends reportan bytes en lugar de MB; si el valor supera 100,000 lo convertimos a MB
    double normalizeMb(dynamic raw) {
      final val = _parseDouble(raw);
      if (val > 1048576) {
        return val / (1024 * 1024);
      }
      return val;
    }

    final workingSet = normalizeMb(
      json['workingSetMb'] ??
          json['workingSetMB'] ??
          json['memoryUsedMb'] ??
          json['usedMemoryMb'] ??
          json['memoriaUsadaMb'] ??
          json['workingSet'] ??
          json['ramMb'] ??
          json['memoryMb'] ??
          json['memoriaMb'] ??
          json['processMemoryMb'],
    );

    final privateMem = normalizeMb(
      json['privateMemoryMb'] ??
          json['privateMemoryMB'] ??
          json['memoriaPrivadaMb'] ??
          json['privateBytes'] ??
          json['privateMemory'],
    );

    final gcMem = normalizeMb(
      json['gcTotalMemoryMb'] ??
          json['gcMemoryMb'] ??
          json['managedMemoryMb'] ??
          json['heapSizeMb'] ??
          json['gcTotalMemory'] ??
          json['memoriaGcMb'],
    );

    return MemoryMetricModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      workingSetMb: workingSet > 0 ? workingSet : (privateMem > 0 ? privateMem : gcMem),
      privateMemoryMb: privateMem,
      gcTotalMemoryMb: gcMem,
      cpuUsagePercent: _parseDouble(
        json['cpuUsagePercent'] ??
            json['cpuPercent'] ??
            json['cpuUsage'] ??
            json['porcentajeCpu'] ??
            json['cpu'],
      ),
      threadCount: _parseInt(
        json['threadCount'] ?? json['threads'] ?? json['numeroHilos'] ?? json['hilos'],
      ),
      timestamp: (json['timestamp'] ??
              json['fechaHora'] ??
              json['fecha'] ??
              json['createdAt'] ??
              json['recordedAt'] ??
              '')
          .toString(),
    );
  }
}

// Resumen consolidado de rendimiento de la API y último estado de memoria/CPU (/api/Metrics/summary)
class MetricsSummaryModel {
  final int totalRequests;
  final double averageResponseTimeMs;
  final double maxResponseTimeMs;
  final double minResponseTimeMs;
  final int errorCount;
  final double errorRatePercent;
  final double currentMemoryMb;
  final double currentCpuPercent;
  final MemoryMetricModel? latestMemory;

  MetricsSummaryModel({
    required this.totalRequests,
    required this.averageResponseTimeMs,
    required this.maxResponseTimeMs,
    required this.minResponseTimeMs,
    required this.errorCount,
    required this.errorRatePercent,
    required this.currentMemoryMb,
    required this.currentCpuPercent,
    this.latestMemory,
  });

  factory MetricsSummaryModel.fromJson(Map<String, dynamic> json) {
    // Sub-objetos comunes en resúmenes consolidados
    final apiSection = (json['apiUsage'] ??
        json['api'] ??
        json['apiSummary'] ??
        json['performance'] ??
        json['rendimiento']) as Map<String, dynamic>?;

    final memSection = (json['latestMemory'] ??
        json['memory'] ??
        json['memorySummary'] ??
        json['ultimoEstadoMemoria'] ??
        json['currentMemory'] ??
        json['memoria']) as Map<String, dynamic>?;

    final latestMemModel =
        memSection != null ? MemoryMetricModel.fromJson(memSection) : null;

    final totalReq = _parseInt(
      json['totalRequests'] ??
          json['totalPeticiones'] ??
          json['requestCount'] ??
          json['totalCalls'] ??
          apiSection?['totalRequests'] ??
          apiSection?['totalPeticiones'] ??
          apiSection?['count'],
    );

    final avgMs = _parseDouble(
      json['averageResponseTimeMs'] ??
          json['avgResponseTimeMs'] ??
          json['averageDurationMs'] ??
          json['tiempoPromedioMs'] ??
          json['promedioRespuestaMs'] ??
          json['avgResponseTime'] ??
          apiSection?['averageResponseTimeMs'] ??
          apiSection?['avgResponseTimeMs'] ??
          apiSection?['averageDurationMs'] ??
          apiSection?['tiempoPromedioMs'],
    );

    final maxMs = _parseDouble(
      json['maxResponseTimeMs'] ??
          json['maxDurationMs'] ??
          json['tiempoMaximoMs'] ??
          apiSection?['maxResponseTimeMs'] ??
          apiSection?['maxDurationMs'],
    );

    final minMs = _parseDouble(
      json['minResponseTimeMs'] ??
          json['minDurationMs'] ??
          json['tiempoMinimoMs'] ??
          apiSection?['minResponseTimeMs'] ??
          apiSection?['minDurationMs'],
    );

    final errCount = _parseInt(
      json['errorCount'] ??
          json['failedRequests'] ??
          json['totalErrores'] ??
          json['errores'] ??
          apiSection?['errorCount'] ??
          apiSection?['failedRequests'],
    );

    double errRate = _parseDouble(
      json['errorRatePercent'] ??
          json['errorRate'] ??
          json['tasaError'] ??
          json['porcentajeErrores'] ??
          apiSection?['errorRatePercent'] ??
          apiSection?['errorRate'],
    );
    if (errRate == 0 && totalReq > 0 && errCount > 0) {
      errRate = (errCount / totalReq) * 100;
    }

    double memMb = latestMemModel?.workingSetMb ?? 0.0;
    if (memMb == 0) {
      memMb = _parseDouble(
        json['workingSetMb'] ??
            json['currentMemoryMb'] ??
            json['memoryUsedMb'] ??
            json['memoriaActualMb'] ??
            json['ramMb'] ??
            json['memoryMb'],
      );
      if (memMb > 1048576) {
        memMb = memMb / (1024 * 1024);
      }
    }

    double cpuPct = latestMemModel?.cpuUsagePercent ?? 0.0;
    if (cpuPct == 0) {
      cpuPct = _parseDouble(
        json['cpuUsagePercent'] ??
            json['currentCpuPercent'] ??
            json['cpuPercent'] ??
            json['cpuUsage'] ??
            json['porcentajeCpu'] ??
            json['cpu'],
      );
    }

    return MetricsSummaryModel(
      totalRequests: totalReq,
      averageResponseTimeMs: avgMs,
      maxResponseTimeMs: maxMs,
      minResponseTimeMs: minMs,
      errorCount: errCount,
      errorRatePercent: errRate,
      currentMemoryMb: memMb,
      currentCpuPercent: cpuPct,
      latestMemory: latestMemModel,
    );
  }
}

