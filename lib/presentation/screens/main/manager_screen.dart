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
  String _resolvedUser = '';

  @override
  void initState() {
    super.initState();
    _resolvedRole = (widget.role ?? '').trim().toLowerCase();
    _cargarDatosSesion();
  }

  Future<void> _cargarDatosSesion() async {
    try {
      final authService = sl<AuthService>();
      final storedRole = await authService.getUserRole();
      final storedUser = await authService.getUserName();
      if (!mounted) return;
      setState(() {
        if (_resolvedRole.isEmpty &&
            storedRole != null &&
            storedRole.trim().isNotEmpty) {
          _resolvedRole = storedRole.trim().toLowerCase();
        }
        if (storedUser != null && storedUser.trim().isNotEmpty) {
          _resolvedUser = storedUser.trim();
        }
      });
    } catch (_) {}
  }

  // Construye las pestañas estrictamente según el rol y lo que puede ver en la matriz oficial:
  // 1. Gerente (rolID 1004): Módulo Analítico y BI
  //    -> Dashboards gerenciales, KPIs de ventas, margen de ganancia, ticket promedio,
  //       gráficos de tendencias y consulta de auditoría/métricas en MongoDB.
  // 2. Supervisor (rolID 1005): Módulo de Monitoreo
  //    -> Supervisión de inventario de insumos, alertas de stock mínimo crítico
  //       y consulta de facturación/ventas.
  // 3. Administrador (rolID 1): Acceso Total
  //    -> Control total sobre usuarios, roles, configuraciones generales, inventario y reportes.
  List<_NavTabConfig> _tabsForRole(String roleLower) {
    if (roleLower.contains('super') || roleLower == '1005') {
      return const [
        _NavTabConfig(
          icon: Icons.inventory_2_outlined,
          label: 'Inventario',
          screen: InventoryScreen(),
        ),
        _NavTabConfig(
          icon: Icons.receipt_long_outlined,
          label: 'Facturación',
          screen: SalesHistoryScreen(),
        ),
      ];
    }

    if (roleLower.contains('gerente') || roleLower == '1004') {
      return const [
        _NavTabConfig(
          icon: Icons.analytics_outlined,
          label: 'BI & Auditoría',
          screen: AuditLogsScreen(),
        ),
        _NavTabConfig(
          icon: Icons.trending_up_rounded,
          label: 'KPIs & Ventas',
          screen: SalesHistoryScreen(),
        ),
      ];
    }

    // Por defecto: Administrador (rolID 1) — Acceso Total
    return const [
      _NavTabConfig(
        icon: Icons.dashboard_outlined,
        label: 'BI & Inicio',
        screen: AuditLogsScreen(),
      ),
      _NavTabConfig(
        icon: Icons.inventory_2_outlined,
        label: 'Inventario',
        screen: InventoryScreen(),
      ),
      _NavTabConfig(
        icon: Icons.bar_chart_rounded,
        label: 'Reportes',
        screen: SalesHistoryScreen(),
      ),
      _NavTabConfig(
        icon: Icons.people_outline,
        label: 'Usuarios',
        screen: UserManagementScreen(),
      ),
      _NavTabConfig(
        icon: Icons.settings_outlined,
        label: 'Ajustes',
        screen: SettingsScreen(),
      ),
    ];
  }

  Map<String, String> _roleMeta(String roleLower) {
    if (roleLower.contains('super') || roleLower == '1005') {
      return {
        'title': 'Supervisor',
        'module': 'Módulo de Monitoreo (Inventario y Facturación)',
      };
    }
    if (roleLower.contains('gerente') || roleLower == '1004') {
      return {
        'title': 'Gerente',
        'module': 'Módulo Analítico y BI (KPIs y Auditoría MongoDB)',
      };
    }
    return {
      'title': 'Administrador',
      'module': 'Acceso Total (Usuarios, Roles, Inventario, BI y Ajustes)',
    };
  }

  @override
  Widget build(BuildContext context) {
    final authResp = context.watch<AuthProvider>().loginResponse;
    final authRole = authResp?.role ?? '';
    final effectiveRole = _resolvedRole.isNotEmpty
        ? _resolvedRole
        : authRole.toLowerCase();
    final effectiveUser = (authResp?.userName.isNotEmpty == true)
        ? authResp!.userName
        : (_resolvedUser.isNotEmpty ? _resolvedUser : 'Usuario');

    final tabs = _tabsForRole(effectiveRole);
    final safeIndex = _currentIndex.clamp(0, tabs.length - 1);
    final meta = _roleMeta(effectiveRole);

    return Scaffold(
      body: Column(
        children: [
          // Barra superior con el rol activo y los permisos habilitados
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
                    color: const Color(0xFFa67c52),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    meta['title']!.toUpperCase(),
                    style: const TextStyle(
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
                    '${meta['module']} • $effectiveUser',
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
              index: safeIndex,
              children: tabs.map((t) => t.screen).toList(),
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
