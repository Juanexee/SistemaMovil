// =========================================================
// ventas_service.dart
// Logica de ventas y filtrado avanzado â€” RF-MOV-MON-03/BUS-02
// =========================================================
import '../data/repositories/ventas_repository.dart';
import '../data/models/ventas_model.dart';

class VentasService {
  final VentasRepository _repository;

  VentasService(this._repository);

  Future<void> registrar(RegistrarVentaRequest venta)     async => await _repository.registrar(venta);
  Future<VentaModel> porId(int id)                        async => await _repository.porId(id);
  Future<List<VentaModel>> getVentas()                    async => await _repository.leer();
  Future<dynamic> getPedidos()                            async => await _repository.pedidos();
  Future<void> cobrar(int id)                             async => await _repository.cobrar(id);
  Future<VentaModel> ventaActivaMesa(int mesaId)          async => await _repository.activaMesa(mesaId);

  Future<void> actualizarEstadoGrupo(ActualizarEstadoGrupoRequest req) async {
    await _repository.actualizarEstadoGrupo(req);
  }

  // Filtrado avanzado de facturas â€” RF-MOV-BUS-02 y RF-MOV-MON-03
  Future<List<VentaModel>> filtrar({
    String? fechaInicio,
    String? fechaFin,
    String? monto,
    String? metodoPago,
    String? estado,
    String? pagina,
  }) async {
    final filtros = <String, String>{};
    if (fechaInicio != null) filtros['fechaInicio'] = fechaInicio;
    if (fechaFin    != null) filtros['fechaFin']    = fechaFin;
    if (monto       != null) filtros['monto']       = monto;
    if (metodoPago  != null) filtros['metodoPago']  = metodoPago;
    if (estado      != null) filtros['estado']      = estado;
    if (pagina      != null) filtros['pagina']      = pagina;

    return await _repository.filtrar(filtros: filtros.isNotEmpty ? filtros : null);
  }
}
