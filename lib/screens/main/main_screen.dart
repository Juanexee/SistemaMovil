import 'package:flutter/material.dart';

// Importamos las pantallas que vamos a usar en la navegación
// Subimos un nivel '../' porque ahora estamos dentro de la carpeta 'main'
import '../audit/audit_screen.dart';
import '../inventory/invenroty_screen.dart'; // (Nota: tiene un error de tipeo en el nombre del archivo)
import '../reports/sales_history_screen.dart';
import '../setting/setting_screen.dart';

/// [MainScreen] es la pantalla principal que actúa como contenedor.
/// Es un StatefulWidget porque necesitamos recordar qué pestaña está seleccionada
/// y redibujar la pantalla cuando el usuario cambie de opción.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // 1. Definimos una variable para guardar el índice de la pantalla actual.
  int _currentIndex = 0;

  // 2. Creamos una lista con todas las pantallas que vamos a mostrar.
  final List<Widget> _screens = [
    // Índice 0: Inicio (Vinculado a AuditLogsScreen)
    const AuditLogsScreen(),
    
    // Índice 1: Inventario (Vinculado a InventoryScreen)
    const InventoryScreen(),
    
    // Índice 2: Reportes (Historial de Ventas)
    const SalesHistoryScreen(),
    
    // Índice 3: Ajustes
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 3. Usamos un IndexedStack para mantener vivas las pantallas
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      // 4. Barra de navegación principal compartida
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        color: const Color(0xFF2E221E), // Color de fondo (Café oscuro)
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home_outlined, 'Inicio', 0),
            _buildNavItem(Icons.inventory_2_outlined, 'Inventario', 1),
            _buildNavItem(Icons.show_chart, 'Reportes', 2),
            _buildNavItem(Icons.settings_outlined, 'Ajustes', 3),
          ],
        ),
      ),
    );
  }

  /// Método auxiliar para construir cada botón de la barra inferior.
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
