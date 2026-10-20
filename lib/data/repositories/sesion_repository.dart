// =========================================================
// sesion_repository.dart
// Control de sesiones de mesas: abrir, cambiar, pedidos
// =========================================================
import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/sesion_model.dart';

class SesionRepository {
  final ApiClient _client;

  SesionRepository(this._client);

  // Abre la sesion de una mesa (empieza la atencion)
  Future<dynamic> abrir(int mesaId) async {
    return await _client.post(ApiConstants.sesionAbrir(mesaId));
  }

  // Mueve la orden de una mesa a otra
  Future<void> cambiarMesa(CambiarMesaRequest request) async {
    await _client.post(ApiConstants.sesionCambiarMesa, body: request.toJson());
  }

  // Acepta un lote de pedidos para preparacion en cocina
  Future<void> aceptarLote(AceptarLoteRequest request) async {
    await _client.post(ApiConstants.sesionAceptarLote, body: request.toJson());
  }

  // Confirma la entrega de platillos a la mesa
  Future<void> entregarPedidos(Map<String, dynamic> datos) async {
    await _client.post(ApiConstants.sesionEntregarPedidos, body: datos);
  }
}
