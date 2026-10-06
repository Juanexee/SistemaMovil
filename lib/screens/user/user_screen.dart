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
                    // --- Campo de Búsqueda ---
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: 'Buscar por nombre, usuario o rol...',
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                          prefixIcon: Icon(Icons.search, color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // --- Botón Nuevo Usuario ---
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF322018), // Café oscuro
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {},
                        icon: const Icon(Icons.add, color: Colors.white, size: 18),
                        label: const Text(
                          'Nuevo Usuario',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // --- Tarjetas de Resumen (Métricas) ---
                    Row(
                      children: [
                        // Card Usuarios activos
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF322018),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Usuarios activos', style: TextStyle(color: Colors.white70, fontSize: 11)),
                                SizedBox(height: 4),
                                Text('8', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                                SizedBox(height: 4),
                                Text('Personal registrado', style: TextStyle(color: Colors.white54, fontSize: 10)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Card Gerentes / Admins
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Gerentes / Admins', style: TextStyle(color: Colors.black54, fontSize: 11)),
                                SizedBox(height: 4),
                                Text('2', style: TextStyle(color: Colors.black87, fontSize: 22, fontWeight: FontWeight.bold)),
                                SizedBox(height: 4),
                                Text('Acceso administrativo', style: TextStyle(color: Colors.black38, fontSize: 10)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Card Meseros / Salón
                    FractionallySizedBox(
                      widthFactor: 0.48,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Meseros / Salón', style: TextStyle(color: Colors.black54, fontSize: 11)),
                            SizedBox(height: 4),
                            Text('6', style: TextStyle(color: Colors.black87, fontSize: 22, fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            Text('Roles operativos', style: TextStyle(color: Colors.black38, fontSize: 10)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),