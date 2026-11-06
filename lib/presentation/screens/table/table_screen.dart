import 'package:flutter/material.dart';
import '../../../core/di/injection.dart';
import '../../../core/utils/number_formatter.dart';
import '../../../services/mesas_service.dart';
import '../../../services/sesion_service.dart';
import '../../../services/auth_service.dart';
import '../../../services/order_cart_manager.dart';
import '../../../data/models/mesas_model.dart';
import '../menu/menu_catalog_screen.dart';
import '../order/order_card_screen.dart';

class TableManagementScreen extends StatefulWidget {
  final Future<void> Function(Map<String, dynamic> mesa)? onTableTap;
  const TableManagementScreen({super.key, this.onTableTap});

  @override
  State<TableManagementScreen> createState() => _TableManagementScreenState();
}

class _TableManagementScreenState extends State<TableManagementScreen> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['Todas', 'Libre', 'Ocupada', 'Por cobrar'];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    OrderCartManager().setAvailableTables(_tables, notify: false);
    _cargarMesas();
  }

  Future<void> _cargarMesas() async {
    setState(() => _isLoading = true);
    try {
      final lista = await sl<MesasService>().getMesas();
      String meseroActual = 'El Rancho La Mimi';
      String meseroIniciales = 'MR';

      try {
        final authUser = await sl<AuthService>().getUserName();
        if (authUser != null && authUser.trim().isNotEmpty) {
          meseroActual = authUser.trim();
          final partes = meseroActual.split(' ');
          meseroIniciales = partes.length >= 2
              ? '${partes[0][0]}${partes[1][0]}'.toUpperCase()
              : meseroActual
                  .substring(0, meseroActual.length.clamp(0, 2))
                  .toUpperCase();
        }
      } catch (_) {}

      if (mounted) {
        setState(() {
          if (lista.isNotEmpty) {
            _tables.clear();
            for (final m in lista) {
              final isLibre = m.estado.toLowerCase() == 'disponible' ||
                  m.estado.toLowerCase() == 'libre';
              final isOcupada = m.estado.toLowerCase() == 'ocupada';
              final baseStatus =
                  isLibre ? 'Libre' : (isOcupada ? 'Ocupada' : m.estado);

              final dishCount = OrderCartManager().countForMesa(m.id);
              final dishSub = OrderCartManager().subtotalForMesa(m.id);
              final effectiveStatus = dishCount > 0 ? 'Ocupada' : baseStatus;

              final tableMap = <String, dynamic>{
                'id': m.id,
                'numero': m.numero,
                'name': 'Mesa ${m.numero.toString().padLeft(2, '0')}',
                'status': effectiveStatus,
                'capacidad': m.capacidad,
                'detail': dishCount > 0
                    ? '$dishCount platillo${dishCount == 1 ? '' : 's'} • C\$ ${dishSub.toStringAsFixed(2)}'
                    : 'Capacidad: ${m.capacidad} personas',
                'waiterInitials': meseroIniciales,
                'waiterName': meseroActual,
                'type': effectiveStatus,
              };
              _tables.add(tableMap);
            }
          }
          OrderCartManager().setAvailableTables(_tables, notify: true);
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        OrderCartManager().setAvailableTables(_tables, notify: false);
        setState(() => _isLoading = false);
      }
    }
  }

  final List<Map<String, dynamic>> _tables = [
    {
      'id': 1,
      'numero': 1,
      'name': 'Mesa 01',
      'status': 'Libre',
      'capacidad': 4,
      'detail': 'Lista para recibir clientes',
      'waiterInitials': 'CR',
      'waiterName': 'Carlos Rivera',
      'type': 'Libre',
    },
    {
      'id': 2,
      'numero': 2,
      'name': 'Mesa 02',
      'status': 'Ocupada',
      'capacidad': 4,
      'detail': 'Comanda activa - Hace 25 min',
      'waiterInitials': 'AL',
      'waiterName': 'Ana López',
      'type': 'Ocupada',
    },
    {
      'id': 3,
      'numero': 3,
      'name': 'Mesa 03',
      'status': 'Por cobrar',
      'capacidad': 2,
      'detail': 'Total C\$ 348.00',
      'waiterInitials': 'CR',
      'waiterName': 'Carlos Rivera',
      'type': 'Por cobrar',
    },
    {
      'id': 4,
      'numero': 4,
      'name': 'Mesa 04',
      'status': 'Ocupada',
      'capacidad': 6,
      'detail': 'Comanda activa - Hace 12 min',
      'waiterInitials': 'MR',
      'waiterName': 'María Ruiz',
      'type': 'Ocupada',
    },
    {
      'id': 5,
      'numero': 5,
      'name': 'Mesa 05',
      'status': 'Libre',
      'capacidad': 4,
      'detail': 'Lista para recibir clientes',
      'waiterInitials': 'CR',
      'waiterName': 'Carlos Rivera',
      'type': 'Libre',
    },
    {
      'id': 6,
      'numero': 6,
      'name': 'Mesa VIP 06',
      'status': 'Ocupada',
      'capacidad': 8,
      'detail': 'Comanda activa - Hace 42 min',
      'waiterInitials': 'AL',
      'waiterName': 'Ana López',
      'type': 'Ocupada',
    },
  ];

  String _effectiveStatus(Map<String, dynamic> table) {
    final mesaId = OrderCartManager.resolveMesaKey(table);
    final dishCount = OrderCartManager().countForMesa(mesaId);
    final rawStatus = (table['status'] as String?) ?? 'Libre';
    if (dishCount > 0 && rawStatus == 'Libre') {
      return 'Ocupada';
    }
    return rawStatus;
  }

  List<Map<String, dynamic>> get _filteredTables {
    if (_selectedFilterIndex == 0) return _tables;
    final selectedFilterText = _filters[_selectedFilterIndex];
    return _tables
        .where((table) => _effectiveStatus(table) == selectedFilterText)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: OrderCartManager(),
      builder: (context, _) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopBar(),
                  const SizedBox(height: 20),
                  _buildHeaderSection(),
                  const SizedBox(height: 16),
                  _buildKpiCards(),
                  const SizedBox(height: 16),
                  _buildFilterChips(),
                  const SizedBox(height: 20),
                  _buildSectionTitle(),
                  const SizedBox(height: 12),
                  _buildTableGrid(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/mimi2.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'El Rancho\nLa Mimi',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E221E),
                height: 1.1,
              ),
            ),
          ],
        ),
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
            const SizedBox(width: 6),
            const Text(
              'En línea',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(width: 16),
            InkWell(
              onTap: _cargarMesas,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: const Icon(
                  Icons.refresh_rounded,
                  color: Color(0xFF2E221E),
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'CONTROL OPERATIVO',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Gestión de Mesas',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E221E),
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Toca cualquier mesa para ver sus platillos y gestionar su comanda',
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildKpiCards() {
    final totalMesas = _tables.length;
    final libres =
        _tables.where((t) => _effectiveStatus(t) == 'Libre').length;
    final enOperacion = totalMesas - libres;

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color(0xFF38231C),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Mesas en operación',
                      style: TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                    Icon(
                      Icons.people_outline_rounded,
                      color: Colors.white70,
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '$enOperacion',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '/ $totalMesas',
                      style:
                          const TextStyle(fontSize: 14, color: Colors.white60),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Disponibles',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Icon(
                      Icons.check_circle_outline_rounded,
                      color: Colors.green,
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '$libres',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'libres',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedFilterIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilterIndex = index;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF2E221E) : Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF2E221E)
                        : Colors.grey.shade300,
                  ),
                ),
                child: Row(
                  children: [
                    if (index > 0) ...[
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index == 1
                              ? Colors.green
                              : index == 2
                                  ? Colors.orange
                                  : Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      _filters[index],
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF2E221E),
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Mesas del salón',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E221E),
          ),
        ),
        Text(
          '${_filteredTables.length} mesas',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildTableGrid() {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: CircularProgressIndicator(),
        ),
      );
    }
    return GridView.builder(
      itemCount: _filteredTables.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        childAspectRatio: 0.90,
      ),
      itemBuilder: (context, index) {
        final table = _filteredTables[index];
        final mesaId = OrderCartManager.resolveMesaKey(table);
        final dishCount = OrderCartManager().countForMesa(mesaId);
        final dishSub = OrderCartManager().subtotalForMesa(mesaId);
        final dishes = OrderCartManager().itemsForMesa(mesaId);
        final status = _effectiveStatus(table);

        Color statusColor;
        Color badgeBgColor;
        IconData detailIcon;

        if (status == 'Libre') {
          statusColor = Colors.green;
          badgeBgColor = const Color(0xFFE8F5E9);
          detailIcon = Icons.restaurant_menu_rounded;
        } else if (status == 'Ocupada') {
          statusColor = Colors.orange;
          badgeBgColor = const Color(0xFFFFF3E0);
          detailIcon =
              dishCount > 0 ? Icons.fastfood_rounded : Icons.access_time_rounded;
        } else {
          statusColor = Colors.blue;
          badgeBgColor = const Color(0xFFE3F2FD);
          detailIcon = Icons.payments_outlined;
        }

        final String detailText = dishCount > 0
            ? '$dishCount platillo${dishCount == 1 ? '' : 's'} (${NumberFormatter.currency(dishSub)}): ${dishes.map((d) => "${d['quantity']}x ${d['title']}").join(", ")}'
            : (table['detail'] ?? 'Capacidad: ${table['capacidad'] ?? 4} personas');

        return GestureDetector(
          onTap: () {
            OrderCartManager().setActiveMesa(table);
            _showTableDetail(context, table, statusColor, badgeBgColor);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: statusColor, width: 4.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              table['name'],
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E221E),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: badgeBgColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: statusColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Icon(detailIcon,
                                size: 14,
                                color: dishCount > 0
                                    ? const Color(0xFF38231C)
                                    : Colors.grey),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              detailText,
                              style: TextStyle(
                                fontSize: 11,
                                color: dishCount > 0
                                    ? const Color(0xFF2E221E)
                                    : Colors.grey,
                                fontWeight: dishCount > 0
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 16, color: Colors.black12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 22,
                                height: 22,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF2E221E),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    table['waiterInitials'] ?? 'MR',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              SizedBox(
                                width: 65,
                                child: Text(
                                  table['waiterName'] ?? 'Mesero',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF2E221E),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.grey,
                            size: 14,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // BottomSheet con el detalle completo y platillos de la mesa seleccionada
  void _showTableDetail(
    BuildContext context,
    Map<String, dynamic> table,
    Color statusColor,
    Color badgeBgColor,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ListenableBuilder(
        listenable: OrderCartManager(),
        builder: (modalCtx, _) {
          final mesaId = OrderCartManager.resolveMesaKey(table);
          final mesaDishes = OrderCartManager().itemsForMesa(mesaId);
          final mesaSubtotal = OrderCartManager().subtotalForMesa(mesaId);
          final status = _effectiveStatus(table);
          final tableName = table['name'] as String? ?? 'Mesa';
          final capacidad = table['capacidad']?.toString() ?? '4';
          final waiterName = table['waiterName'] as String? ?? 'Carlos Rivera';

          String actionText = 'Ver comanda completa';
          if (status == 'Libre' && mesaDishes.isEmpty) {
            actionText = 'Tomar orden / Abrir comanda';
          } else if (status == 'Por cobrar') {
            actionText = 'Ver cuenta y cobrar';
          }

          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Nombre de la mesa y estado
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F0EE),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.table_restaurant_rounded,
                              color: Color(0xFF2E221E),
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tableName,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2E221E),
                                ),
                              ),
                              Text(
                                'Capacidad para $capacidad comensales • Atiende: $waiterName',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: badgeBgColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Sección de platillos agregados a esta mesa
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'PLATILLOS EN ESTA MESA',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          letterSpacing: 1.0,
                        ),
                      ),
                      if (mesaDishes.isNotEmpty)
                        Text(
                          'Subtotal: ${NumberFormatter.currency(mesaSubtotal)}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF38231C),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  if (mesaDishes.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.restaurant_menu,
                              size: 20, color: Colors.grey.shade500),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Aún no se han agregado platillos a $tableName.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      constraints: const BoxConstraints(maxHeight: 220),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(12),
                        itemCount: mesaDishes.length,
                        separatorBuilder: (_, __) =>
                            const Divider(height: 14, color: Colors.black12),
                        itemBuilder: (ctx, i) {
                          final d = mesaDishes[i];
                          final qty = (d['quantity'] as int?) ?? 1;
                          final price =
                              (d['pricePerUnit'] as num?)?.toDouble() ?? 0.0;
                          final totalLine = qty * price;
                          final sent = d['sent'] == true;
                          final note = (d['note'] as String?) ?? 'Estándar';

                          return Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF38231C),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${qty}x',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      d['title']?.toString() ?? 'Platillo',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2E221E),
                                      ),
                                    ),
                                    Text(
                                      sent
                                          ? 'En cocina • $note'
                                          : 'Por enviar • $note',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: sent
                                            ? Colors.green.shade700
                                            : Colors.orange.shade800,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                NumberFormatter.currency(totalLine),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2E221E),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                  const SizedBox(height: 18),

                  // Botón rápido para agregar platillos desde el catálogo a esta mesa
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF38231C),
                        side: const BorderSide(color: Color(0xFF38231C)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.add_shopping_cart_rounded,
                          size: 18),
                      label: Text(
                        'Agregar platillo a $tableName',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(modalCtx);
                        OrderCartManager().setActiveMesa(table);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                MenuCatalogScreen(initialMesa: table),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Botón de acción principal (Ver comanda)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF38231C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () async {
                        final navigator = Navigator.of(context);
                        navigator.pop();

                        OrderCartManager().setActiveMesa(table);

                        if (status == 'Libre' && mesaId > 0) {
                          try {
                            await sl<SesionService>().abrirSesion(mesaId);
                          } catch (_) {}
                        }

                        if (widget.onTableTap != null) {
                          await widget.onTableTap!(table);
                        } else {
                          await navigator.push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  OrderCartScreen(mesa: table),
                            ),
                          );
                        }
                        if (mounted) {
                          setState(() {});
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.receipt_long_rounded,
                              color: Colors.white, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            actionText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Acciones de cambio de estado de la mesa (Liberar / Por cobrar)
                  if (status != 'Libre') ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        if (status == 'Ocupada')
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.blue.shade700,
                                side: BorderSide(color: Colors.blue.shade300),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                              icon: const Icon(Icons.payments_outlined,
                                  size: 16),
                              label: const Text('Por cobrar',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold)),
                              onPressed: () async {
                                Navigator.pop(modalCtx);
                                final numMesa = table['numero'] is int
                                    ? table['numero'] as int
                                    : (int.tryParse(
                                            table['numero']?.toString() ??
                                                '') ??
                                        1);
                                final cap = table['capacidad'] is int
                                    ? table['capacidad'] as int
                                    : (int.tryParse(
                                            table['capacidad']?.toString() ??
                                                '') ??
                                        4);

                                try {
                                  await sl<MesasService>().actualizar(
                                    mesaId,
                                    MesaModel(
                                        id: mesaId,
                                        numero: numMesa,
                                        capacidad: cap,
                                        estado: 'Por cobrar'),
                                  );
                                } catch (_) {}
                                if (mounted) {
                                  setState(() {
                                    table['status'] = 'Por cobrar';
                                    table['type'] = 'Por cobrar';
                                  });
                                }
                              },
                            ),
                          ),
                        if (status == 'Ocupada') const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.green.shade700,
                              side: BorderSide(color: Colors.green.shade300),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                            ),
                            icon: const Icon(Icons.check_circle_outline,
                                size: 16),
                            label: const Text('Liberar mesa',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold)),
                            onPressed: () async {
                              Navigator.pop(modalCtx);
                              final numMesa = table['numero'] is int
                                  ? table['numero'] as int
                                  : (int.tryParse(
                                          table['numero']?.toString() ?? '') ??
                                      1);
                              final cap = table['capacidad'] is int
                                  ? table['capacidad'] as int
                                  : (int.tryParse(
                                          table['capacidad']?.toString() ??
                                              '') ??
                                      4);

                              try {
                                await sl<MesasService>().actualizar(
                                  mesaId,
                                  MesaModel(
                                      id: mesaId,
                                      numero: numMesa,
                                      capacidad: cap,
                                      estado: 'Libre'),
                                );
                              } catch (_) {}
                              OrderCartManager().clear(mesaId: mesaId);
                              if (mounted) {
                                setState(() {
                                  table['status'] = 'Libre';
                                  table['type'] = 'Libre';
                                  table['detail'] = 'Capacidad: $cap personas';
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
