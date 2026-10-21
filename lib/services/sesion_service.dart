// =========================================================
// sesion_service.dart
// =========================================================
import '../data/repositories/sesion_repository.dart';
import '../data/models/sesion_model.dart';

class SesionService {
  final SesionRepository _repository;

  SesionService(this._repository);

  Future<dynamic> abrirSesion(int mesaId)                  async => await _repository.abrir(mesaId);
  Future<void> cambiarMesa(CambiarMesaRequest req)          async => await _repository.cambiarMesa(req);
  Future<void> aceptarLote(AceptarLoteRequest req)          async => await _repository.aceptarLote(req);
  Future<void> entregarPedidos(Map<String, dynamic> datos)  async => await _repository.entregarPedidos(datos);
}
