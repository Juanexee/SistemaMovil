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

