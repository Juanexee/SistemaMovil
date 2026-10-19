// =========================================================
// api_constants.dart
// Aqui estan TODAS las URLs y rutas de mi API .NET
// Solo cambio baseUrl para pasar de local a Azure
// =========================================================
class ApiConstants {
  // URL base â€” API desplegada en Azure
  static const String baseUrl = 'https://pos320261015135238-eqcwenbwb7a4hgbr.centralus-01.azurewebsites.net';
  // Emulador Android local:
  // static const String baseUrl = 'http://10.0.2.2:5121';
  // Dispositivo fisico en misma red WiFi:
  // static const String baseUrl = 'http://192.168.1.X:5150';

  // -------------------------------------------------------
  // AUTH â€” RF-MOV-AUT-01 y RF-MOV-AUT-02
  // -------------------------------------------------------
  static const String login = '/api/Auth/login';

  // -------------------------------------------------------
  // DASHBOARD â€” RF-MOV-DSH-01 y RF-MOV-DSH-02
  // -------------------------------------------------------
  static const String dashboardKpis       = '/api/Dashboard/kpis';
  static const String dashboardTendencias = '/api/Dashboard/tendencias';

  // -------------------------------------------------------
  // INVENTARIO MOVIL â€” RF-MOV-MON-01 y RF-MOV-MON-02
  // -------------------------------------------------------
  static const String inventarioResumen = '/api/InventarioMovil/resumen';
  static const String inventarioAlertas = '/api/InventarioMovil/alertas';

  // -------------------------------------------------------
  // AUDITORIA â€” RF-MOV-AUD-01 y RF-MOV-AUD-02
  // -------------------------------------------------------
  static const String auditoriaLogs      = '/api/Auditoria/logs';
  static const String auditoriaRegistrar = '/api/Auditoria/registrar';

  // -------------------------------------------------------
  // CATEGORIA
  // Las rutas con ID las hago como funcion, no constante
  // -------------------------------------------------------
  static const String categoriaLeer     = '/Categoria/Leer';
  static const String categoriaInsertar = '/Categoria/Insertar';
  static String categoriaEliminar(int id)  => '/Categoria/Eliminar/$id';
  static String categoriaActivar(int id)   => '/Categoria/Activar/$id';
  static String categoriaActualizar(int id)=> '/Categoria/Actualizar/$id';

  // -------------------------------------------------------
  // COMPRAS
  // -------------------------------------------------------
  static const String compras = '/api/Compras';

  // -------------------------------------------------------
  // INSUMOS
  // -------------------------------------------------------
  static const String insumosLeer     = '/api/Insumos/Leer';
  static const String insumosInsertar = '/api/Insumos/Insertar';

  // -------------------------------------------------------
  // MESAS
  // -------------------------------------------------------
  static const String mesasLeer     = '/api/Mesas/Leer';
  static const String mesasInsertar = '/api/Mesas/Insertar';
  static String mesasActualizar(int id) => '/api/Mesas/Actualizar/$id';
  static String mesasEliminar(int id)   => '/api/Mesas/Eliminar/$id';

  // -------------------------------------------------------
  // PLATILLO
  // -------------------------------------------------------
  static const String platilloInsertar = '/Platillo/Insertar';
  static const String platilloLeer     = '/Platillo/Leer';
  static String platilloActualizar(int id)      => '/Platillo/$id/Actualizar';
  static String platilloDisponibilidad(int id)  => '/Platillo/$id/Disponibilidad';
  static String platilloPorId(int id)           => '/Platillo/$id';

  // -------------------------------------------------------
  // PROVEEDORES
  // -------------------------------------------------------
  static const String proveedores = '/api/Proveedores';

  // -------------------------------------------------------
  // RECETAS
  // -------------------------------------------------------
  static String recetasLeer(int platilloId)      => '/api/Recetas/$platilloId';
  static String recetasActualizar(int platilloId) => '/api/Recetas/$platilloId';

  // -------------------------------------------------------
  // ROL â€” RF-MOV-AUT-03 (RBAC)
  // -------------------------------------------------------
  static const String rolCrear      = '/Rol/Crear';
  static const String rolLeer       = '/Rol/Leer';
  static const String rolActualizar = '/Rol/Actualizar';
  static String rolDesactivar(int id) => '/Rol/$id/Desactivar';

  // -------------------------------------------------------
  // SESION â€” Control de mesas y pedidos
  // -------------------------------------------------------
  static String sesionAbrir(int mesaId)  => '/api/Sesion/Abrir/$mesaId';
  static const String sesionCambiarMesa  = '/api/Sesion/cambiar-mesa';
  static const String sesionAceptarLote  = '/api/Sesion/aceptar-lote';
  static const String sesionEntregarPedidos = '/api/Sesion/entregar-pedidos';

  // -------------------------------------------------------
  // UNIDADES DE MEDIDA
  // -------------------------------------------------------
  static const String unidadesMedidaLeer     = '/api/UnidadesMedida/Leer';
  static const String unidadesMedidaInsertar = '/api/UnidadesMedida/Insertar';

  // -------------------------------------------------------
  // USUARIO
  // -------------------------------------------------------
  static const String usuarioCrear = '/Usuario/Crear';
  static const String usuarioLeer  = '/Usuario/Leer';
  static String usuarioActualizar(int id) => '/Usuario/$id/Actualizar usuario';
  static String usuarioEliminar(int id)   => '/Usuario/$id/Eliminar';

  // -------------------------------------------------------
  // VENTAS â€” RF-MOV-MON-03 y RF-MOV-BUS-02
  // -------------------------------------------------------
  static const String ventasRegistrar           = '/api/Ventas/registrar';
  static String ventasPorId(int id)             => '/api/Ventas/$id';
  static const String ventas                    = '/api/Ventas';
  static const String ventasPedidos             = '/api/Ventas/pedidos';
  static const String ventasActualizarEstadoGrupo = '/api/Ventas/actualizar-estado-grupo';
  static String ventasCobrar(int id)            => '/api/Ventas/$id/cobrar';
  static String ventasActivaMesa(int mesaId)    => '/api/Ventas/activa/mesa/$mesaId';
  static const String ventasFiltrar             = '/api/Ventas/filtrar';
}
