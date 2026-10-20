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

