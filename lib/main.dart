// =========================================================
// main.dart
// Punto de entrada de la aplicación, inicializa dotenv,
// las dependencias de GetIt y el MultiProvider global.
// =========================================================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Importamos la configuración de GetIt
import 'core/di/injection.dart';

// Importamos todos tus Providers creados
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/user_provider.dart';
import 'presentation/providers/ventas_provider.dart';
import 'presentation/providers/inventario_provider.dart';
import 'presentation/providers/pedidos_provider.dart';

// Importamos la pantalla inicial (Login)
import 'presentation/screens/login/login_screen.dart';

Future<void> main() async {
  // Aseguramos que los componentes de Flutter estén inicializados
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Cargamos el archivo .env para leer la URL de Azure
  await dotenv.load(fileName: ".env");

  // 2. Inicializamos las dependencias con GetIt (nuestros niveles del 1 al 5)
  setupDependencies();

  // 3. Arrancamos la aplicación
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 4. MultiProvider inyecta los estados a lo largo de toda la app usando GetIt (sl())
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => sl<AuthProvider>()),
        ChangeNotifierProvider(create: (_) => sl<UserProvider>()),
        ChangeNotifierProvider(create: (_) => sl<VentasProvider>()),
        ChangeNotifierProvider(create: (_) => sl<InventarioProvider>()),
        ChangeNotifierProvider(create: (_) => sl<PedidosProvider>()),
      ],
      child: MaterialApp(
        title: 'El Rancho La Mimí',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF38231c)),
          useMaterial3: true,
        ),
        // La vista inicial que arranca la app
        home: const LoginScreen(),
      ),
    );
  }
}
