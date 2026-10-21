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

// =========================================================
// mesas_repository.dart
// CRUD completo de mesas del restaurante
// =========================================================
import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/mesas_model.dart';

class MesasRepository {
  final ApiClient _client;

  MesasRepository(this._client);

  Future<List<MesaModel>> leer() async {
    final json = await _client.get(ApiConstants.mesasLeer);
    if (json is! List) throw Exception('Se esperaba lista de mesas');
    return json.map((e) => MesaModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> insertar(MesaModel mesa) async {
    await _client.post(ApiConstants.mesasInsertar, body: mesa.toJson());
  }

  Future<void> actualizar(int id, MesaModel mesa) async {
    await _client.put(ApiConstants.mesasActualizar(id), body: mesa.toJson());
  }

  Future<void> eliminar(int id) async {
    await _client.delete(ApiConstants.mesasEliminar(id));
  }
}

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

// =========================================================
// unidades_medida_repository.dart
// =========================================================
import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/unidades_medida_model.dart';

class UnidadesMedidaRepository {
  final ApiClient _client;

  UnidadesMedidaRepository(this._client);

  Future<List<UnidadMedidaModel>> leer() async {
    final json = await _client.get(ApiConstants.unidadesMedidaLeer);
    if (json is! List) throw Exception('Se esperaba lista de unidades');
    return json.map((e) => UnidadMedidaModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> insertar(UnidadMedidaModel unidad) async {
    await _client.post(ApiConstants.unidadesMedidaInsertar, body: unidad.toJson());
  }
}

// =========================================================
// ventas_repository.dart
// Registro y consulta de ventas/facturas
// Cubre RF-MOV-MON-03 y RF-MOV-BUS-02
// =========================================================
import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/ventas_model.dart';

class VentasRepository {
  final ApiClient _client;

  VentasRepository(this._client);

  // Registra una venta nueva con sus detalles
  Future<void> registrar(RegistrarVentaRequest venta) async {
    await _client.post(ApiConstants.ventasRegistrar, body: venta.toJson());
  }

  // Busca una venta especifica por su ID
  Future<VentaModel> porId(int id) async {
    final json = await _client.get(ApiConstants.ventasPorId(id));
    return VentaModel.fromJson(json as Map<String, dynamic>);
  }

  // Lista todas las ventas
  Future<List<VentaModel>> leer() async {
    final json = await _client.get(ApiConstants.ventas);
    if (json is! List) throw Exception('Se esperaba lista de ventas');
    return json.map((e) => VentaModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  // Pedidos pendientes para la cocina
  Future<dynamic> pedidos() async {
    return await _client.get(ApiConstants.ventasPedidos);
  }

  // Actualiza el estado de un grupo de pedidos (Pendiente -> En Preparacion -> Listo)
  Future<void> actualizarEstadoGrupo(ActualizarEstadoGrupoRequest request) async {
    await _client.patch(
      ApiConstants.ventasActualizarEstadoGrupo,
      body: request.toJson(),
    );
  }

  // Cobra/cierra una venta
  Future<void> cobrar(int id) async {
    await _client.put(ApiConstants.ventasCobrar(id));
  }

  // Obtiene la venta activa de una mesa especifica
  Future<VentaModel> activaMesa(int mesaId) async {
    final json = await _client.get(ApiConstants.ventasActivaMesa(mesaId));
    return VentaModel.fromJson(json as Map<String, dynamic>);
  }

  // Filtra ventas con parametros avanzados â€” RF-MOV-BUS-02
  // filtros puede incluir: fechaInicio, fechaFin, monto, metodoPago, estado, pagina
  Future<List<VentaModel>> filtrar({Map<String, String>? filtros}) async {
    final json = await _client.get(
      ApiConstants.ventasFiltrar,
      queryParameters: filtros,
    );
    if (json is! List) throw Exception('Se esperaba lista filtrada de ventas');
    return json.map((e) => VentaModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
