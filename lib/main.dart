import 'package:flutter/material.dart';

import 'screens/login/login_screen.dart';

void main() {
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
        // Usamos el color café principal como base para el tema
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF38231c)),
        useMaterial3: true,
      ),

      home: const LoginScreen(),
    );
  }
}
