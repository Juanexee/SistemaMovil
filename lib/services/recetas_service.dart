// =========================================================
// recetas_service.dart
// =========================================================
import '../data/repositories/recetas_repository.dart';
import '../data/models/recetas_model.dart';

class RecetasService {
  final RecetasRepository _repository;

  RecetasService(this._repository);

  Future<RecetaModel> getReceta(int platilloId)                       async => await _repository.leer(platilloId);
  Future<void> actualizar(int platilloId, RecetaModel receta)         async => await _repository.actualizar(platilloId, receta);
}
