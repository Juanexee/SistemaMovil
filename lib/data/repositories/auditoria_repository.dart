// =========================================================
// auditoria_repository.dart
// Lee los logs del sistema desde MongoDB via la API
// Cubre RF-MOV-AUD-01 y RF-MOV-AUD-02
// =========================================================
import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/auditoria_model.dart';

class AuditoriaRepository {
  final ApiClient _client;

  AuditoriaRepository(this._client);

  // Obtiene los logs con filtros opcionales (RF-MOV-AUD-02)
  // filtros puede tener: fechaInicio, fechaFin, tipoEvento, modulo, usuario
  Future<List<LogAuditoriaModel>> getLogs({
    Map<String, String>? filtros,
  }) async {
    final json = await _client.get(
      ApiConstants.auditoriaLogs,
      queryParameters: filtros,
    );
    List logsList = [];
    if (json is List) {
      logsList = json;
    } else if (json is Map<String, dynamic> && json['logs'] is List) {
      logsList = json['logs'];
    } else {
      throw Exception('Se esperaba una lista de logs');
    }
    return logsList
        .map((e) => LogAuditoriaModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // Registra manualmente un evento de auditoria
  Future<void> registrarEvento(Map<String, dynamic> evento) async {
    await _client.post(ApiConstants.auditoriaRegistrar, body: evento);
  }
}
