import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/di/injection.dart';
import '../../../services/auth_service.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/ventas_provider.dart';
import '../../providers/inventario_provider.dart';
import '../../providers/pedidos_provider.dart';
import '../../providers/metrics_provider.dart';
import '../../../services/order_cart_manager.dart';

import '../table/table_screen.dart';
import '../menu/menu_catalog_screen.dart';
import '../order/order_card_screen.dart';
import '../login/login_screen.dart';

class WaiterScreen extends StatefulWidget {
  const WaiterScreen({super.key});

  @override
  State<WaiterScreen> createState() => _WaiterScreenState();
}

class _WaiterScreenState extends State<WaiterScreen> {
  int _currentIndex = 0;
  String _resolvedUser = '';

  @override
  void initState() {
    super.initState();
    _cargarUsuario();
  }

  Future<void> _cargarUsuario() async {
    try {
      final stored = await sl<AuthService>().getUserName();
      if (mounted && stored != null && stored.trim().isNotEmpty) {
        setState(() {
          _resolvedUser = stored.trim();
        });
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final authResp = context.watch<AuthProvider>().loginResponse;
    final effectiveUser = (authResp?.userName.isNotEmpty == true)
        ? authResp!.userName
        : (_resolvedUser.isNotEmpty ? _resolvedUser : 'Mesero');

    final List<Widget> screens = [
      TableManagementScreen(
        onTableTap: (mesa) async {
          OrderCartManager().setActiveMesa(mesa);
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OrderCartScreen(mesa: mesa)),
          );
        },
      ),
      const MenuCatalogScreen(),
      const OrderCartScreen(),
    ];

    return Scaffold(
      body: Column(
        children: [
          // Barra superior indicando el rol y permisos del Mesero
          Container(
            width: double.infinity,
            color: const Color(0xFF2E221E),
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 6,
              bottom: 8,
              left: 16,
              right: 16,
            ),
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF427A59),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'MESERO',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Módulo Operativo de Salón (Mesas, Catálogo y Comandas) • $effectiveUser',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: screens,
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        color: const Color(0xFF2E221E),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.table_restaurant, 'Mesas', 0),
            _buildNavItem(Icons.menu_book, 'Catálogo', 1),
            _buildNavItem(Icons.receipt_long_rounded, 'Comanda', 2),
            // Botón de cerrar sesión
            InkWell(
              onTap: () async {
                final authProv =
                    Provider.of<AuthProvider>(context, listen: false);
                final userProv =
                    Provider.of<UserProvider>(context, listen: false);
                final ventasProv =
                    Provider.of<VentasProvider>(context, listen: false);
                final invProv =
                    Provider.of<InventarioProvider>(context, listen: false);
                final pedidosProv =
                    Provider.of<PedidosProvider>(context, listen: false);
                final metricsProv =
                    Provider.of<MetricsProvider>(context, listen: false);

                await authProv.logout();
                userProv.clear();
                ventasProv.clear();
                invProv.clear();
                pedidosProv.clear();
                metricsProv.clear();

                if (!context.mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.logout,
                      color: Colors.redAccent,
                      size: 24,
                    ),
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
