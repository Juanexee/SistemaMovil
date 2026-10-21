// =========================================================
// platillo_service.dart
// =========================================================
import '../data/repositories/platillo_repository.dart';
import '../data/models/platillo_model.dart';

class PlatilloService {
  final PlatilloRepository _repository;

  PlatilloService(this._repository);

  Future<List<PlatilloModel>> getPlatillos()                        async => await _repository.leer();
  Future<PlatilloModel> getPorId(int id)                            async => await _repository.porId(id);
  Future<void> insertar(PlatilloModel p)                            async => await _repository.insertar(p);
  Future<void> actualizar(int id, PlatilloModel p)                  async => await _repository.actualizar(id, p);
  Future<void> actualizarDisponibilidad(int id, bool disponible)    async => await _repository.actualizarDisponibilidad(id, disponible);

  // Busqueda por texto â€” RF-MOV-BUS-01
  Future<List<PlatilloModel>> buscar(String texto) async {
    final todos = await _repository.leer();
    return todos
        .where((p) => p.nombre.toLowerCase().contains(texto.toLowerCase()))
        .toList();
  }

  // Solo los platillos disponibles (para el menu activo)
  Future<List<PlatilloModel>> getDisponibles() async {
    final todos = await _repository.leer();
    return todos.where((p) => p.disponible).toList();
  }
}
