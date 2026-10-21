// =========================================================
// auditoria_service.dart
// Logica para logs y auditoria â€” RF-MOV-AUD-01/02
// =========================================================
import '../data/repositories/auditoria_repository.dart';
import '../data/models/auditoria_model.dart';

class AuditoriaService {
  final AuditoriaRepository _repository;

  AuditoriaService(this._repository);

  // Obtiene todos los logs (sin filtros)
  Future<List<LogAuditoriaModel>> getLogs() async {
    return await _repository.getLogs();
  }

  // Filtra logs por fecha, evento, modulo o usuario â€” RF-MOV-AUD-02
  Future<List<LogAuditoriaModel>> filtrarLogs({
    String? fechaInicio,
    String? fechaFin,
    String? tipoEvento,
    String? modulo,
    String? usuario,
  }) async {
    // Solo agrego al mapa los filtros que no son nulos
    final filtros = <String, String>{};
    if (fechaInicio != null) filtros['fechaInicio'] = fechaInicio;
    if (fechaFin    != null) filtros['fechaFin']    = fechaFin;
    if (tipoEvento  != null) filtros['tipoEvento']  = tipoEvento;
    if (modulo      != null) filtros['modulo']      = modulo;
    if (usuario     != null) filtros['usuario']     = usuario;

    return await _repository.getLogs(filtros: filtros.isNotEmpty ? filtros : null);
  }
}
