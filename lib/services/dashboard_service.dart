// =========================================================
// dashboard_service.dart
// Logica para el dashboard gerencial â€” RF-MOV-DSH-01/02
// =========================================================
import '../data/repositories/dashboard_repository.dart';
import '../data/models/dashboard_model.dart';

class DashboardService {
  final DashboardRepository _repository;

  DashboardService(this._repository);

  // KPIs del negocio (ventas, ticket promedio, margen)
  Future<KpisModel> getKpis() async {
    return await _repository.getKpis();
  }

  // Datos de tendencias para los graficos
  Future<List<TendenciaModel>> getTendencias() async {
    return await _repository.getTendencias();
  }
}
