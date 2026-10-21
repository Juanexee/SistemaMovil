// =========================================================
// categoria_repository.dart
// CRUD completo de categorias
// =========================================================
import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/categoria_model.dart';

class CategoriaRepository {
  final ApiClient _client;

  CategoriaRepository(this._client);

  Future<List<CategoriaModel>> leer() async {
    final json = await _client.get(ApiConstants.categoriaLeer);
    if (json is! List) throw Exception('Se esperaba lista de categorias');
    return json.map((e) => CategoriaModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> insertar(CategoriaModel categoria) async {
    await _client.post(ApiConstants.categoriaInsertar, body: categoria.toJson());
  }

  Future<void> eliminar(int id) async {
    await _client.delete(ApiConstants.categoriaEliminar(id));
  }

  Future<void> activar(int id) async {
    await _client.put(ApiConstants.categoriaActivar(id));
  }

  Future<void> actualizar(int id, CategoriaModel categoria) async {
    await _client.put(ApiConstants.categoriaActualizar(id), body: categoria.toJson());
  }
}
