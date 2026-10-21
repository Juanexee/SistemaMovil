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
