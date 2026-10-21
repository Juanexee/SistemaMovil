// =========================================================
// proveedores_repository.dart
// =========================================================
import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/proveedores_model.dart';

class ProveedoresRepository {
  final ApiClient _client;

  ProveedoresRepository(this._client);

  Future<List<ProveedorModel>> leer() async {
    final json = await _client.get(ApiConstants.proveedores);
    if (json is! List) throw Exception('Se esperaba lista de proveedores');
    return json.map((e) => ProveedorModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> insertar(ProveedorModel proveedor) async {
    await _client.post(ApiConstants.proveedores, body: proveedor.toJson());
  }
}
