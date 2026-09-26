import 'package:flutter/material.dart';

// Importamos la pantalla de Historial de Ventas
import 'screens/reports/sales_history_screen.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF38231c)),
        useMaterial3: true,
      ),
      // Definimos la pantalla de Historial de Ventas como la vista inicial
      home: const SalesHistoryScreen(),
    );
  }
}
 