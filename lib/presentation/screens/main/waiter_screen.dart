import 'package:flutter/material.dart';

import '../table/table_screen.dart';
import '../menu/menu_catalog_screen.dart';
import '../order/order_card_screen.dart';
import '../login/login_screen.dart';

class WaiterScreen extends StatefulWidget {
  const WaiterScreen({Key? key}) : super(key: key);

  @override
  State<WaiterScreen> createState() => _WaiterScreenState();
}

class _WaiterScreenState extends State<WaiterScreen> {
  // Índice para saber qué pestaña está activa (0 = Mesas, 1 = Catálogo)
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Lista con las vistas específicas para el Mesero, se inicializa aquí para poder pasar el context
    final List<Widget> screens = [
      TableManagementScreen(
        onTableTap: () {
          // Navegamos hacia la pantalla de Comanda por encima de la barra de navegación
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const OrderCartScreen()),
          );
        },
      ),
      const MenuCatalogScreen(),
    ];

    return Scaffold(
      // Igual que con el Gerente, usamos IndexedStack para no perder el progreso en las pantallas
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      // Barra de navegación en la parte inferior de la pantalla con estilo oscuro (café)
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        color: const Color(0xFF2E221E), // Color de fondo (Café oscuro)
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.table_restaurant, 'Mesas', 0),
            _buildNavItem(Icons.menu_book, 'Catálogo', 1),
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
