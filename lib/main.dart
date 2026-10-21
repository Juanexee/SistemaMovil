import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Importa tu archivo de inyección de dependencias y la pantalla inicial
import 'core/di/injection.dart';
import 'presentation/screens/login/login_screen.dart';

Future<void> main() async {
  // Asegura que los bindings de Flutter estén listos
  WidgetsFlutterBinding.ensureInitialized();

  // Carga las variables de entorno desde el archivo .env raíz
  await dotenv.load(fileName: ".env");

  // Configura e inicializa todas las dependencias con GetIt (Niveles 1 al 5)
  setupDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'El Rancho La Mimi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF38231c)),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
