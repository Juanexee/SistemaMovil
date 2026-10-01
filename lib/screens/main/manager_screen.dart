import 'package:flutter/material.dart';

import '../inventory/invenroty_screen.dart';
import '../reports/sales_history_screen.dart';
import '../setting/setting_screen.dart';
import '../login/login_screen.dart';

class ManagerScreen extends StatefulWidget {
  const ManagerScreen({Key? key}) : super(key: key);

  @override
  State<ManagerScreen> createState() => _ManagerScreenState();
}

class _ManagerScreenState extends State<ManagerScreen> {
  // Esta variable guarda el número de la pestaña en la que estamos.
  // Empezamos en 0, que es la primera pestaña (Inventario).
  int _currentIndex = 0;

  // Lista de las "sub-pantallas" que verá el gerente.
  // El IndexedStack se encargará de mostrar una de estas dependiendo del _currentIndex.
  final List<Widget> _screens = [
    const InventoryScreen(),
    const SalesHistoryScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // El IndexedStack mantiene el estado de las pantallas.
      // Es decir, si haces algo en "Inventario" y cambias a "Ajustes", 
      // cuando regreses a "Inventario" todo seguirá igual.
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      // Barra de navegación en la parte inferior de la pantalla con estilo oscuro (café)
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        color: const Color(0xFF2E221E), // Color de fondo (Café oscuro)
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.inventory_2, 'Inventario', 0),
            _buildNavItem(Icons.bar_chart, 'Reportes', 1),
            _buildNavItem(Icons.settings, 'Ajustes', 2),
            // Botón de cerrar sesión
            InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.logout,
                      color: Colors.redAccent,
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Salir',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 10,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Método auxiliar para construir cada botón de la barra inferior al estilo de "main_screen.dart"
  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isActive = _currentIndex == index;

    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : Colors.grey[500],
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey[500],
                fontSize: 10,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
