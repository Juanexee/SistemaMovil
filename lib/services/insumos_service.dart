// =========================================================
// insumos_service.dart
// =========================================================
import '../data/repositories/insumos_repository.dart';
import '../data/models/insumos_model.dart';

class InsumosService {
  final InsumosRepository _repository;

  InsumosService(this._repository);

  Future<List<InsumoModel>> getInsumos() async => await _repository.leer();
  Future<void> insertar(InsumoModel insumo)    async => await _repository.insertar(insumo);

  // Busqueda por texto en el nombre â€” RF-MOV-BUS-01
  Future<List<InsumoModel>> buscar(String texto) async {
    final todos = await _repository.leer();
    return todos
        .where((i) => i.nombre.toLowerCase().contains(texto.toLowerCase()))
        .toList();
  }
}
