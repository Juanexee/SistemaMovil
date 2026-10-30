// =========================================================
// injection.dart
// Registro de TODAS las dependencias con GetIt
// Orden: lo mas basico primero, luego lo que depende de eso
// =========================================================
import 'package:get_it/get_it.dart';

// Core
import '../network/api_client.dart';

// Services basicos (sin dependencia de repos)
import '../../services/secure_storage_service.dart';

// Repositories
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/dashboard_repository.dart';
import '../../data/repositories/inventario_repository.dart';
import '../../data/repositories/auditoria_repository.dart';
import '../../data/repositories/metrics_repository.dart';
import '../../data/repositories/categoria_repository.dart';
import '../../data/repositories/compras_repository.dart';
import '../../data/repositories/insumos_repository.dart';
import '../../data/repositories/mesas_repository.dart';
import '../../data/repositories/platillo_repository.dart';
import '../../data/repositories/proveedores_repository.dart';
import '../../data/repositories/recetas_repository.dart';
import '../../data/repositories/rol_repository.dart';
import '../../data/repositories/sesion_repository.dart';
import '../../data/repositories/unidades_medida_repository.dart';
import '../../data/repositories/ventas_repository.dart';
import '../../data/repositories/users_repository.dart';

// Services
import '../../services/auth_service.dart';
import '../../services/dashboard_service.dart';
import '../../services/inventario_service.dart';
import '../../services/auditoria_service.dart';
import '../../services/metrics_service.dart';
import '../../services/categoria_service.dart';
import '../../services/compras_service.dart';
import '../../services/insumos_service.dart';
import '../../services/mesas_service.dart';
import '../../services/platillo_service.dart';
import '../../services/proveedores_service.dart';
import '../../services/recetas_service.dart';
import '../../services/rol_service.dart';
import '../../services/sesion_service.dart';
import '../../services/unidades_medida_service.dart';
import '../../services/ventas_service.dart';
import '../../services/user_service.dart';

// Providers
import '../../presentation/providers/user_provider.dart';
import '../../presentation/providers/auth_provider.dart';
import '../../presentation/providers/ventas_provider.dart';
import '../../presentation/providers/pedidos_provider.dart';
import '../../presentation/providers/inventario_provider.dart';
import '../../presentation/providers/metrics_provider.dart';

// Instancia global del Service Locator
// Uso: sl<UserService>() desde cualquier parte del codigo
final sl = GetIt.instance;

void setupDependencies() {
  // -------------------------------------------------------
  // NIVEL 1: Servicios sin dependencias (los mas basicos)
  // -------------------------------------------------------

  // Almacenamiento seguro del JWT — RNF-MOV-SEG-02
  sl.registerLazySingleton<SecureStorageService>(() => SecureStorageService());

  // -------------------------------------------------------
  // NIVEL 2: Cliente HTTP (depende de SecureStorageService)
  // -------------------------------------------------------

  // ApiClient necesita el storage para leer el JWT en cada peticion
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(sl<SecureStorageService>()),
  );

  // -------------------------------------------------------
  // NIVEL 3: Repositories (dependen del ApiClient)
  // -------------------------------------------------------

  // AuthRepository es especial: necesita ApiClient Y SecureStorageService
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepository(sl<ApiClient>(), sl<SecureStorageService>()),
  );

  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepository(sl<ApiClient>()),
  );
  sl.registerLazySingleton<InventarioRepository>(
    () => InventarioRepository(sl<ApiClient>()),
  );
  sl.registerLazySingleton<AuditoriaRepository>(
    () => AuditoriaRepository(sl<ApiClient>()),
  );
  sl.registerLazySingleton<MetricsRepository>(
    () => MetricsRepository(sl<ApiClient>()),
  );
  sl.registerLazySingleton<CategoriaRepository>(
    () => CategoriaRepository(sl<ApiClient>()),
  );
  sl.registerLazySingleton<ComprasRepository>(
    () => ComprasRepository(sl<ApiClient>()),
  );
  sl.registerLazySingleton<InsumosRepository>(
    () => InsumosRepository(sl<ApiClient>()),
  );
  sl.registerLazySingleton<MesasRepository>(
    () => MesasRepository(sl<ApiClient>()),
  );
  sl.registerLazySingleton<PlatilloRepository>(
    () => PlatilloRepository(sl<ApiClient>()),
  );
  sl.registerLazySingleton<ProveedoresRepository>(
    () => ProveedoresRepository(sl<ApiClient>()),
  );
  sl.registerLazySingleton<RecetasRepository>(
    () => RecetasRepository(sl<ApiClient>()),
  );
  sl.registerLazySingleton<RolRepository>(() => RolRepository(sl<ApiClient>()));
  sl.registerLazySingleton<SesionRepository>(
    () => SesionRepository(sl<ApiClient>()),
  );
  sl.registerLazySingleton<UnidadesMedidaRepository>(
    () => UnidadesMedidaRepository(sl<ApiClient>()),
  );
  sl.registerLazySingleton<VentasRepository>(
    () => VentasRepository(sl<ApiClient>()),
  );
  sl.registerLazySingleton<UsersRepository>(
    () => UsersRepository(sl<ApiClient>()),
  );

  // -------------------------------------------------------
  // NIVEL 4: Services (dependen de sus Repositories)
  // -------------------------------------------------------

  // AuthService necesita AuthRepository Y SecureStorageService
  sl.registerLazySingleton<AuthService>(
    () => AuthService(sl<AuthRepository>(), sl<SecureStorageService>()),
  );
  sl.registerLazySingleton<DashboardService>(
    () => DashboardService(sl<DashboardRepository>()),
  );
  sl.registerLazySingleton<InventarioService>(
    () => InventarioService(sl<InventarioRepository>()),
  );
  sl.registerLazySingleton<AuditoriaService>(
    () => AuditoriaService(sl<AuditoriaRepository>()),
  );
  sl.registerLazySingleton<MetricsService>(
    () => MetricsService(sl<MetricsRepository>()),
  );
  sl.registerLazySingleton<CategoriaService>(
    () => CategoriaService(sl<CategoriaRepository>()),
  );
  sl.registerLazySingleton<ComprasService>(
    () => ComprasService(sl<ComprasRepository>()),
  );
  sl.registerLazySingleton<InsumosService>(
    () => InsumosService(sl<InsumosRepository>()),
  );
  sl.registerLazySingleton<MesasService>(
    () => MesasService(sl<MesasRepository>()),
  );
  sl.registerLazySingleton<PlatilloService>(
    () => PlatilloService(sl<PlatilloRepository>()),
  );
  sl.registerLazySingleton<ProveedoresService>(
    () => ProveedoresService(sl<ProveedoresRepository>()),
  );
  sl.registerLazySingleton<RecetasService>(
    () => RecetasService(sl<RecetasRepository>()),
  );
  sl.registerLazySingleton<RolService>(() => RolService(sl<RolRepository>()));
  sl.registerLazySingleton<SesionService>(
    () => SesionService(sl<SesionRepository>()),
  );
  sl.registerLazySingleton<UnidadesMedidaService>(
    () => UnidadesMedidaService(sl<UnidadesMedidaRepository>()),
  );
  sl.registerLazySingleton<VentasService>(
    () => VentasService(sl<VentasRepository>()),
  );
  sl.registerLazySingleton<UserService>(
    () => UserService(sl<UsersRepository>()),
  );

  // -------------------------------------------------------
  // NIVEL 5: Providers (dependen de sus Services)
  // -------------------------------------------------------

  // UserProvider necesita el UserService para gestionar el estado de usuarios
  sl.registerFactory<UserProvider>(() => UserProvider(sl<UserService>()));

  sl.registerFactory<AuthProvider>(() => AuthProvider(sl<AuthService>()));

  sl.registerFactory<VentasProvider>(() => VentasProvider(sl<VentasService>()));

  sl.registerFactory<PedidosProvider>(
    () => PedidosProvider(sl<VentasService>()),
  );

  sl.registerFactory<InventarioProvider>(
    () => InventarioProvider(sl<InventarioService>(), sl<InsumosService>()),
  );

  sl.registerFactory<MetricsProvider>(
    () => MetricsProvider(sl<MetricsService>()),
  );
}
