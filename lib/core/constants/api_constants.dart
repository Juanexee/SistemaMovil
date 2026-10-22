// =========================================================
// api_constants.dart
// URLs y rutas de la API leídas desde .env
// =========================================================
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  // Lee la URL base dinámicamente desde el archivo .env
  static String get baseUrl =>
      dotenv.env['API_URL'] ??
      'https://pos320261015135238-eqcwenbwb7a4hgbr.centralus-01.azurewebsites.net';

  // -------------------------------------------------------
  // AUTH — RF-MOV-AUT-01 y RF-MOV-AUT-02
  // -------------------------------------------------------
  static const String login = '/api/Auth/login';

  // -------------------------------------------------------
  // DASHBOARD — RF-MOV-DSH-01 y RF-MOV-DSH-02
  // -------------------------------------------------------
  static const String dashboardKpis = '/api/Dashboard/kpis';
  static const String dashboardTendencias = '/api/Dashboard/tendencias';

  // -------------------------------------------------------
  // INVENTARIO MOVIL — RF-MOV-MON-01 y RF-MOV-MON-02
  // -------------------------------------------------------
  static const String inventarioResumen = '/api/InventarioMovil/resumen';
  static const String inventarioAlertas = '/api/InventarioMovil/alertas';

  // -------------------------------------------------------
  // AUDITORIA — RF-MOV-AUD-01 y RF-MOV-AUD-02
  // -------------------------------------------------------
  static const String auditoriaLogs = '/api/Auditoria/logs';
  static const String auditoriaRegistrar = '/api/Auditoria/registrar';

  // -------------------------------------------------------
  // CATEGORIA
  // -------------------------------------------------------
  static const String categoriaLeer = '/Categoria/Leer';
  static const String categoriaInsertar = '/Categoria/Insertar';
  static String categoriaEliminar(int id) => '/Categoria/Eliminar/$id';
  static String categoriaActivar(int id) => '/Categoria/Activar/$id';
  static String categoriaActualizar(int id) => '/Categoria/Actualizar/$id';

  // -------------------------------------------------------
  // COMPRAS & INSUMOS & MESAS
  // -------------------------------------------------------
  static const String compras = '/api/Compras';
  static const String insumosLeer = '/api/Insumos/Leer';
  static const String insumosInsertar = '/api/Insumos/Insertar';
  static const String mesasLeer = '/api/Mesas/Leer';
  static const String mesasInsertar = '/api/Mesas/Insertar';
  static String mesasActualizar(int id) => '/api/Mesas/Actualizar/$id';
  static String mesasEliminar(int id) => '/api/Mesas/Eliminar/$id';

  // -------------------------------------------------------
  // PLATILLO & PROVEEDORES & RECETAS
  // -------------------------------------------------------
  static const String platilloInsertar = '/Platillo/Insertar';
  static const String platilloLeer = '/Platillo/Leer';
  static String platilloActualizar(int id) => '/Platillo/$id/Actualizar';
  static String platilloDisponibilidad(int id) =>
      '/Platillo/$id/Disponibilidad';
  static String platilloPorId(int id) => '/Platillo/$id';
  static const String proveedores = '/api/Proveedores';
  static String recetasLeer(int platilloId) => '/api/Recetas/$platilloId';
  static String recetasActualizar(int platilloId) => '/api/Recetas/$platilloId';

  // -------------------------------------------------------
  // ROL & SESION & UNIDADES
  // -------------------------------------------------------
  static const String rolCrear = '/Rol/Crear';
  static const String rolLeer = '/Rol/Leer';
  static const String rolActualizar = '/Rol/Actualizar';
  static String rolDesactivar(int id) => '/Rol/$id/Desactivar';
  static String sesionAbrir(int mesaId) => '/api/Sesion/Abrir/$mesaId';
  static const String sesionCambiarMesa = '/api/Sesion/cambiar-mesa';
  static const String sesionAceptarLote = '/api/Sesion/aceptar-lote';
  static const String sesionEntregarPedidos = '/api/Sesion/entregar-pedidos';
  static const String unidadesMedidaLeer = '/api/UnidadesMedida/Leer';
  static const String unidadesMedidaInsertar = '/api/UnidadesMedida/Insertar';

  // -------------------------------------------------------
  // USUARIO
  // -------------------------------------------------------
  static const String usuarioCrear = '/Usuario/Crear';
  static const String usuarioLeer = '/Usuario/Leer';
  static String usuarioActualizar(int id) => '/Usuario/$id/Actualizar usuario';
  static String usuarioEliminar(int id) => '/Usuario/$id/Eliminar';

  // -------------------------------------------------------
  // VENTAS
  // -------------------------------------------------------
  static const String ventasRegistrar = '/api/Ventas/registrar';
  static String ventasPorId(int id) => '/api/Ventas/$id';
  static const String ventas = '/api/Ventas';
  static const String ventasPedidos = '/api/Ventas/pedidos';
  static const String ventasActualizarEstadoGrupo =
      '/api/Ventas/actualizar-estado-grupo';
  static String ventasCobrar(int id) => '/api/Ventas/$id/cobrar';
  static String ventasActivaMesa(int mesaId) =>
      '/api/Ventas/activa/mesa/$mesaId';
  static const String ventasFiltrar = '/api/Ventas/filtrar';
}
