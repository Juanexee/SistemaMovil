import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/ventas_provider.dart';
import '../../providers/inventario_provider.dart';
import '../../providers/pedidos_provider.dart';
import '../../../services/order_cart_manager.dart';

import '../inventory/invenroty_screen.dart';
import '../reports/sales_history_screen.dart';
import '../setting/setting_screen.dart';
import '../login/login_screen.dart';
import '../audit/audit_screen.dart';
import '../user/user_screen.dart';

class ManagerScreen extends StatefulWidget {
  const ManagerScreen({super.key});

  @override
  State<ManagerScreen> createState() => _ManagerScreenState();
}

class _ManagerScreenState extends State<ManagerScreen> {
  // Empezamos en 0: Inicio (auditoría)
  int _currentIndex = 0;

  // Pantallas del gerente: 0=Inicio, 1=Inventario, 2=Reportes, 3=Usuarios, 4=Ajustes
  final List<Widget> _screens = [
    const AuditLogsScreen(),         // 0 - Inicio
    const InventoryScreen(),          // 1 - Inventario
    const SalesHistoryScreen(),       // 2 - Reportes
    const UserManagementScreen(),     // 3 - Usuarios (¡nuevo!)
    const SettingsScreen(),           // 4 - Ajustes
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        color: const Color(0xFF2E221E),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, 'Inicio', 0),
            _buildNavItem(Icons.inventory_2, 'Inventario', 1),
            _buildNavItem(Icons.bar_chart, 'Reportes', 2),
            _buildNavItem(Icons.people_outline, 'Usuarios', 3),
            _buildNavItem(Icons.settings, 'Ajustes', 4),
            // Botón de cerrar sesión
            InkWell(
              onTap: () async {
                final authProv = Provider.of<AuthProvider>(context, listen: false);
                final userProv = Provider.of<UserProvider>(context, listen: false);
                final ventasProv = Provider.of<VentasProvider>(context, listen: false);
                final invProv = Provider.of<InventarioProvider>(context, listen: false);
                final pedidosProv = Provider.of<PedidosProvider>(context, listen: false);

                await authProv.logout();
                userProv.clear();
                ventasProv.clear();
                invProv.clear();
                pedidosProv.clear();
                OrderCartManager().clearAll();

                if (!context.mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.logout, color: Colors.redAccent, size: 24),
                    SizedBox(height: 4),
                    Text(
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

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isActive = _currentIndex == index;

    return InkWell(
      onTap: () {
        setState(() => _currentIndex = index);
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
