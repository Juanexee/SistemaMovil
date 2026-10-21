// =========================================================
// rol_service.dart
// =========================================================
import '../data/repositories/rol_repository.dart';
import '../data/models/rol_model.dart';

class RolService {
  final RolRepository _repository;

  RolService(this._repository);

  Future<List<RolModel>> getRoles()           async => await _repository.leer();
  Future<void> crear(RolModel rol)            async => await _repository.crear(rol);
  Future<void> actualizar(RolModel rol)       async => await _repository.actualizar(rol);
  Future<void> desactivar(int id)             async => await _repository.desactivar(id);
}
