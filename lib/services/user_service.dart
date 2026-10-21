// =========================================================
// compras_service.dart
// =========================================================
import '../data/repositories/compras_repository.dart';
import '../data/models/compras_model.dart';

class ComprasService {
  final ComprasRepository _repository;

  ComprasService(this._repository);

  Future<void> registrarCompra(RegistrarCompraRequest compra) async {
    await _repository.registrar(compra);
  }
}

// =========================================================
// mesas_service.dart
// =========================================================
import '../data/repositories/mesas_repository.dart';
import '../data/models/mesas_model.dart';

class MesasService {
  final MesasRepository _repository;

  MesasService(this._repository);

  Future<List<MesaModel>> getMesas()                         async => await _repository.leer();
  Future<void> insertar(MesaModel mesa)                      async => await _repository.insertar(mesa);
  Future<void> actualizar(int id, MesaModel mesa)            async => await _repository.actualizar(id, mesa);
  Future<void> eliminar(int id)                              async => await _repository.eliminar(id);

  // Solo las mesas libres (para cuando quiero asignar una)
  Future<List<MesaModel>> getMesasLibres() async {
    final todas = await _repository.leer();
    return todas.where((m) => m.estado == 'Libre').toList();
  }
}

// =========================================================
// proveedores_service.dart
// =========================================================
import '../data/repositories/proveedores_repository.dart';
import '../data/models/proveedores_model.dart';

class ProveedoresService {
  final ProveedoresRepository _repository;

  ProveedoresService(this._repository);

  Future<List<ProveedorModel>> getProveedores()    async => await _repository.leer();
  Future<void> insertar(ProveedorModel proveedor)  async => await _repository.insertar(proveedor);
}
// =========================================================
// unidades_medida_service.dart
// =========================================================
import '../data/repositories/unidades_medida_repository.dart';
import '../data/models/unidades_medida_model.dart';

class UnidadesMedidaService {
  final UnidadesMedidaRepository _repository;

  UnidadesMedidaService(this._repository);

  Future<List<UnidadMedidaModel>> getUnidades()    async => await _repository.leer();
  Future<void> insertar(UnidadMedidaModel u)        async => await _repository.insertar(u);
}

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

