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

import '../inventory/invenroty_screen.dart';
import '../reports/sales_history_screen.dart';
import '../setting/setting_screen.dart';
import '../login/login_screen.dart';
import '../audit/audit_screen.dart';
import '../user/user_screen.dart';

class _NavTabConfig {
  final IconData icon;
  final String label;
  final Widget screen;

  const _NavTabConfig({
    required this.icon,
    required this.label,
    required this.screen,
  });
}

class ManagerScreen extends StatefulWidget {
  final String? role;
  const ManagerScreen({super.key, this.role});

  @override
  State<ManagerScreen> createState() => _ManagerScreenState();
}

class _ManagerScreenState extends State<ManagerScreen> {
  int _currentIndex = 0;
  String _resolvedRole = '';

  @override
  void initState() {
    super.initState();
    _resolvedRole = (widget.role ?? '').trim().toLowerCase();
    _cargarRolSiFalta();
  }

  Future<void> _cargarRolSiFalta() async {
    if (_resolvedRole.isNotEmpty) return;
    try {
      final stored = await sl<AuthService>().getUserRole();
      if (mounted && stored != null && stored.trim().isNotEmpty) {
        setState(() {
          _resolvedRole = stored.trim().toLowerCase();
        });
      }
    } catch (_) {}
  }

  // Construye las pestañas según el perfil y permisos definidos para cada rol:
  // - Administrador (rolID 1): Acceso Total (Inicio/Auditoría/Métricas, Inventario, Reportes, Usuarios, Ajustes)
  // - Gerente (rolID 1004): Módulo Analítico y BI (Inicio/KPIs/Auditoría/Métricas MongoDB, Reportes, Inventario, Ajustes)
  // - Supervisor (rolID 1005): Módulo de Monitoreo (Inventario/Alertas de stock crítico y Consulta de Facturación/Ventas)
  List<_NavTabConfig> _tabsForRole(String roleLower) {
    if (roleLower.contains('super')) {
      return const [
        _NavTabConfig(
          icon: Icons.inventory_2,
          label: 'Inventario',
          screen: InventoryScreen(),
        ),
        _NavTabConfig(
          icon: Icons.bar_chart,
          label: 'Ventas',
          screen: SalesHistoryScreen(),
        ),
      ];
    }

    if (roleLower.contains('gerente')) {
      return const [
        _NavTabConfig(
          icon: Icons.analytics_outlined,
          label: 'BI & Auditoría',
          screen: AuditLogsScreen(),
        ),
        _NavTabConfig(
          icon: Icons.bar_chart,
          label: 'Ventas',
          screen: SalesHistoryScreen(),
        ),
        _NavTabConfig(
          icon: Icons.inventory_2,
          label: 'Inventario',
          screen: InventoryScreen(),
        ),
        _NavTabConfig(
          icon: Icons.settings,
          label: 'Ajustes',
          screen: SettingsScreen(),
        ),
      ];
    }

    // Por defecto: Administrador (Acceso Total)
    return const [
      _NavTabConfig(
        icon: Icons.home,
        label: 'Inicio',
        screen: AuditLogsScreen(),
      ),
      _NavTabConfig(
        icon: Icons.inventory_2,
        label: 'Inventario',
        screen: InventoryScreen(),
      ),
      _NavTabConfig(
        icon: Icons.bar_chart,
        label: 'Reportes',
        screen: SalesHistoryScreen(),
      ),
      _NavTabConfig(
        icon: Icons.people_outline,
        label: 'Usuarios',
        screen: UserManagementScreen(),
      ),
      _NavTabConfig(
        icon: Icons.settings,
        label: 'Ajustes',
        screen: SettingsScreen(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final authRole = context.watch<AuthProvider>().loginResponse?.role ?? '';
    final effectiveRole = _resolvedRole.isNotEmpty
        ? _resolvedRole
        : authRole.toLowerCase();

    final tabs = _tabsForRole(effectiveRole);
    final safeIndex = _currentIndex.clamp(0, tabs.length - 1);

    return Scaffold(
      body: IndexedStack(
        index: safeIndex,
        children: tabs.map((t) => t.screen).toList(),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        color: const Color(0xFF2E221E),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (int i = 0; i < tabs.length; i++)
              _buildNavItem(tabs[i].icon, tabs[i].label, i, safeIndex),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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

  Widget _buildNavItem(
      IconData icon, String label, int index, int activeIndex) {
    bool isActive = activeIndex == index;

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
