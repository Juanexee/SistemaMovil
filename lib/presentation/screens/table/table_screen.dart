import 'package:flutter/material.dart';
import '../../../core/di/injection.dart';
import '../../../services/mesas_service.dart';
import '../../../services/sesion_service.dart';
import '../../../services/auth_service.dart';
import '../../../services/order_cart_manager.dart';
import '../../../data/models/mesas_model.dart';
import '../order/order_card_screen.dart';

class TableManagementScreen extends StatefulWidget {
  // onTableTap recibe el mapa completo de la mesa seleccionada
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
          _tables.clear();
          for (final m in lista) {
            final isLibre = m.estado.toLowerCase() == 'disponible' ||
                m.estado.toLowerCase() == 'libre';
            final isOcupada = m.estado.toLowerCase() == 'ocupada';
            final status =
                isLibre ? 'Libre' : (isOcupada ? 'Ocupada' : m.estado);

            final tableMap = <String, dynamic>{
              'id': m.id,
              'numero': m.numero,
              'name': 'Mesa ${m.numero.toString().padLeft(2, '0')}',
              'status': status,
              'capacidad': m.capacidad,
              'detail': 'Capacidad: ${m.capacidad} personas',
              'waiterInitials': meseroIniciales,
              'waiterName': meseroActual,
              'type': status,
            };
            _tables.add(tableMap);
          }
          if (OrderCartManager().activeMesa == null && _tables.isNotEmpty) {
            OrderCartManager().setActiveMesa(_tables.first, notify: false);
          }
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Datos de mesas (se actualizan desde la API o fallback si no hay conexión)
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

  List<Map<String, dynamic>> get _filteredTables {
    if (_selectedFilterIndex == 0) return _tables;
    String selectedFilterText = _filters[_selectedFilterIndex];
    return _tables
        .where((table) => table['type'] == selectedFilterText)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
  }

  // 1. Top Bar superior
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

  // 2. Cabecera de Control Operativo
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
          'Toca cualquier mesa para ver su información y gestionar comanda',
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
      ],
    );
  }

  // 3. Tarjetas de resumen superior (KPIs dinámicos)
  Widget _buildKpiCards() {
    final totalMesas = _tables.length;
    final libres = _tables.where((t) => t['status'] == 'Libre').length;
    final enOperacion = totalMesas - libres;

    return Row(
      children: [
        // Tarjeta Oscura
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
        // Tarjeta Clara
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

  // 4. Filtros rápidos deslizables
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

  // 5. Título de sección de listado
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

  // 6. Cuadrícula de tarjetas de mesas
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
        childAspectRatio: 0.92,
      ),
      itemBuilder: (context, index) {
        final table = _filteredTables[index];
        final status = (table['status'] as String?) ?? 'Libre';

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
          detailIcon = Icons.access_time_rounded;
        } else {
          statusColor = Colors.blue;
          badgeBgColor = const Color(0xFFE3F2FD);
          detailIcon = Icons.payments_outlined;
        }

        return GestureDetector(
          // Al tocar cualquier mesa, SIEMPRE se muestra la información de ESA mesa
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
                        children: [
                          Icon(detailIcon, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              table['detail'] ?? 'Detalles de la mesa',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
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

  // BottomSheet con el detalle completo de la mesa seleccionada
  void _showTableDetail(
    BuildContext context,
    Map<String, dynamic> table,
    Color statusColor,
    Color badgeBgColor,
  ) {
    final status = table['status'] as String? ?? 'Libre';
    final tableName = table['name'] as String? ?? 'Mesa';
    final capacidad = table['capacidad']?.toString() ?? '4';
    final waiterName = table['waiterName'] as String? ?? 'Carlos Rivera';
    final detail = table['detail'] as String? ?? '';

    String actionText = 'Ver comanda';
    if (status == 'Libre') {
      actionText = 'Tomar orden / Asignar mesa';
    } else if (status == 'Por cobrar') {
      actionText = 'Ver cuenta y cobrar';
    }

    String statusDescription = '';
    if (status == 'Libre') {
      statusDescription =
          'Esta mesa está libre y lista para recibir clientes y tomar comanda.';
    } else if (status == 'Ocupada') {
      statusDescription =
          'Esta mesa tiene clientes atendidos y una comanda activa en servicio.';
    } else {
      statusDescription =
          'Los comensales de esta mesa han solicitado la cuenta para pago.';
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
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

            // Nombre de la mesa y badge de estado
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
                          'Capacidad para $capacidad comensales',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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

            // Descripción del estado
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 18, color: statusColor),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      statusDescription,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Detalle de la mesa y mesero
            _detailRow(
              Icons.format_list_bulleted_rounded,
              'Detalle de la mesa',
              detail.isNotEmpty ? detail : 'Sin consumo registrado',
            ),
            const SizedBox(height: 12),
            _detailRow(
              Icons.person_pin_rounded,
              'Mesero a cargo',
              waiterName,
            ),
            const Divider(height: 28),

            // Botón de acción principal
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
                  navigator.pop(); // Cierra el modal de detalle

                  OrderCartManager().setActiveMesa(table);

                  final mesaId = table['id'] is int
                      ? table['id'] as int
                      : (int.tryParse(table['id']?.toString() ?? '') ?? 0);

                  // Si la mesa está libre, solicitamos al servidor abrir sesión
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
                        builder: (context) => OrderCartScreen(mesa: table),
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
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        icon: const Icon(Icons.payments_outlined, size: 16),
                        label: const Text('Por cobrar',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold)),
                        onPressed: () async {
                          Navigator.pop(context);
                          final mesaId = table['id'] is int
                              ? table['id'] as int
                              : (int.tryParse(table['id']?.toString() ?? '') ??
                                  0);
                          final numMesa = table['numero'] is int
                              ? table['numero'] as int
                              : (int.tryParse(
                                      table['numero']?.toString() ?? '') ??
                                  1);
                          final cap = table['capacidad'] is int
                              ? table['capacidad'] as int
                              : (int.tryParse(
                                      table['capacidad']?.toString() ?? '') ??
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
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      icon: const Icon(Icons.check_circle_outline, size: 16),
                      label: const Text('Liberar mesa',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold)),
                      onPressed: () async {
                        Navigator.pop(context);
                        final mesaId = table['id'] is int
                            ? table['id'] as int
                            : (int.tryParse(table['id']?.toString() ?? '') ??
                                0);
                        final numMesa = table['numero'] is int
                            ? table['numero'] as int
                            : (int.tryParse(
                                    table['numero']?.toString() ?? '') ??
                                1);
                        final cap = table['capacidad'] is int
                            ? table['capacidad'] as int
                            : (int.tryParse(
                                    table['capacidad']?.toString() ?? '') ??
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
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(fontSize: 11, color: Colors.grey)),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2E221E),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
