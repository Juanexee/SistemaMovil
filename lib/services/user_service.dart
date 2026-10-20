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

