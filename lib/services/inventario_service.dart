// =========================================================
// inventario_service.dart
// Logica para monitoreo de inventario â€” RF-MOV-MON-01/02
// =========================================================
import '../data/repositories/inventario_repository.dart';
import '../data/models/inventario_model.dart';

class InventarioService {
  final InventarioRepository _repository;

  InventarioService(this._repository);

  Future<ResumenInventarioModel> getResumen() async {
    return await _repository.getResumen();
  }

  Future<List<AlertaStockModel>> getAlertas() async {
    return await _repository.getAlertas();
  }

  // Cuantos insumos estan en nivel critico (util para badge/notificacion)
  Future<int> contarAlertas() async {
    final alertas = await _repository.getAlertas();
    return alertas.length;
  }
}
