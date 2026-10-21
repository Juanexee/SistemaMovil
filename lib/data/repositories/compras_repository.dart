// =========================================================
// compras_repository.dart
// =========================================================
import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/compras_model.dart';

class ComprasRepository {
  final ApiClient _client;

  ComprasRepository(this._client);

  Future<void> registrar(RegistrarCompraRequest compra) async {
    await _client.post(ApiConstants.compras, body: compra.toJson());
  }
}
