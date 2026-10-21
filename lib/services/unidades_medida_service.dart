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
