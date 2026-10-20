// =========================================================
// categoria_service.dart
// =========================================================
import '../data/repositories/categoria_repository.dart';
import '../data/models/categoria_model.dart';

class CategoriaService {
  final CategoriaRepository _repository;

  CategoriaService(this._repository);

  Future<List<CategoriaModel>> getCategorias() async => await _repository.leer();
  Future<void> insertar(CategoriaModel c)          async => await _repository.insertar(c);
  Future<void> eliminar(int id)                    async => await _repository.eliminar(id);
  Future<void> activar(int id)                     async => await _repository.activar(id);
  Future<void> actualizar(int id, CategoriaModel c)async => await _repository.actualizar(id, c);
}
