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
                    // --- Filtros / Chips ---
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildFilterChip('Todos', isSelected: true),
                        _buildFilterChip('Gerente', icon: Icons.person_outline, hasDropdown: true),
                        _buildFilterChip('Administrador', icon: Icons.verified_outlined, hasDropdown: true),
                        _buildFilterChip('Mesero / Salón', icon: Icons.person_outline, hasDropdown: true),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // --- Sección Equipo de Trabajo ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PERSONAL REGISTRADO',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                            const Text(
                              'Equipo de trabajo',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2C1E18),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '4 cuentas',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // --- Lista de Usuarios ---
                    _buildUserCard(
                      initials: 'CR',
                      name: 'Carlos Rivera',
                      email: 'carlos.rivera@mimi.pos',
                      role: 'Gerente',
                      tagColor: const Color(0xFFF7EBE1),
                      tagTextColor: const Color(0xFFB57049),
                      sideAccentColor: const Color(0xFFDCA887),
                    ),
                    _buildUserCard(
                      initials: 'MG',
                      name: 'María González',
                      email: 'maria.gonzalez@mimi.pos',
                      role: 'Administrador',
                      tagColor: const Color(0xFFEFEFEF),
                      tagTextColor: const Color(0xFF666666),
                      sideAccentColor: const Color(0xFFCCCCCC),
                    ),
                    _buildUserCard(
                      initials: 'AT',
                      name: 'Ana Torres',
                      email: 'ana.torres@mimi.pos',
                      role: 'Mesero / Salón',
                      tagColor: const Color(0xFFEBF5EE),
                      tagTextColor: const Color(0xFF427A59),
                      sideAccentColor: const Color(0xFFA2C7B3),
                    ),
                    _buildUserCard(
                      initials: 'LM',
                      name: 'Luis Mendoza',
                      email: 'luis.mendoza@mimi.pos',
                      role: 'Mesero / Salón',
                      tagColor: const Color(0xFFEBF5EE),
                      tagTextColor: const Color(0xFF427A59),
                      sideAccentColor: const Color(0xFFA2C7B3),
                    ),
                  ],
                ),
              ),
            ),

            // --- Barra de Navegación Inferior (Custom) ---
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF322018), // Fondo oscuro
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(Icons.home_outlined, 'Inicio', false),
                  _buildNavItem(Icons.widgets_outlined, 'Inventario', false),
                  _buildNavItem(Icons.show_chart, 'Reportes', false),
                  _buildNavItem(Icons.people_outline, 'Usuarios', true),
                  _buildNavItem(Icons.settings_outlined, 'Ajustes', false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
                    