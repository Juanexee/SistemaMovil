// =========================================================
// recetas_repository.dart
// =========================================================
import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/recetas_model.dart';

class RecetasRepository {
  final ApiClient _client;

  RecetasRepository(this._client);

  Future<RecetaModel> leer(int platilloId) async {
    final json = await _client.get(ApiConstants.recetasLeer(platilloId));
    return RecetaModel.fromJson(json as Map<String, dynamic>);
  }

  Future<void> actualizar(int platilloId, RecetaModel receta) async {
    await _client.put(
      ApiConstants.recetasActualizar(platilloId),
      body: receta.toJson(),
    );
  }
}
