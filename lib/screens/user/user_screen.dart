import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestión de Usuarios',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF7F5F0), // Fondo beige claro
        fontFamily: 'Roboto',
      ),
      home: const UserManagementScreen(),
    );
  }
}

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Encabezado Superior (Logo y Notificación) ---
                    Row(
                      children: [
                        // Imagen de Mimi como avatar
                        const CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.transparent,
                          backgroundImage: AssetImage('assets/images/mimi2.png'),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'El Rancho La Mimí',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C1E18),
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'En línea',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.notifications_none, color: Colors.black54),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // --- Título de Sección ---
                    Text(
                      'SEGURIDAD Y ACCESO',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Gestión de Usuarios',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C1E18),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Administra los roles, permisos y accesos del personal',
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 16),