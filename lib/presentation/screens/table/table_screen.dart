import 'package:flutter/material.dart';
import '../../../core/di/injection.dart';
import '../../../services/mesas_service.dart';

class TableManagementScreen extends StatefulWidget {
  // onTableTap recibe el mapa completo de la mesa seleccionada
  final void Function(Map<String, dynamic> mesa)? onTableTap;
  const TableManagementScreen({Key? key, this.onTableTap}) : super(key: key);

  @override
  State<TableManagementScreen> createState() => _TableManagementScreenState();
}

class _TableManagementScreenState extends State<TableManagementScreen> {
  int _selectedFilterIndex = 0;
  int _currentBottomIndex = 1; // 1 corresponde a "Catálogo" (activo)

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
      if (lista.isNotEmpty && mounted) {
        setState(() {
          _tables.clear();
          for (final m in lista) {
            final isLibre = m.estado.toLowerCase() == 'disponible' ||
                m.estado.toLowerCase() == 'libre';
            _tables.add({
              'name': 'Mesa 0${m.numero}',
              'status': isLibre ? 'Libre' : m.estado,
              'detail': 'Capacidad: ${m.capacidad} personas',
              'waiterInitials': 'MR',
              'waiterName': 'Mimi Restaurante',
              'type': isLibre ? 'Libre' : m.estado,
            });
          }
          _isLoading = false;
        });
      } else if (mounted) {
        setState(() => _isLoading = false);
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Datos de ejemplo para las mesas (fallback si no hay red)
  final List<Map<String, dynamic>> _tables = [
    {
      'name': 'Mesa 02',
      'status': 'Ocupada',
      'detail': 'Comanda activa - Hace 25 min',
      'waiterInitials': 'AL',
      'waiterName': 'Ana López',
      'type': 'Ocupada',
    },
    {
      'name': 'Mesa 01',
      'status': 'Libre',
      'detail': 'Lista para recibir clientes',
      'waiterInitials': 'CR',
      'waiterName': 'Carlos Rivera',
      'type': 'Libre',
    },
    {
      'name': 'Mesa 04',
      'status': 'Ocupada',
      'detail': 'Comanda activa - Hace 12 min',
      'waiterInitials': 'MR',
      'waiterName': 'María Ruiz',
      'type': 'Ocupada',
    },
    {
      'name': 'Mesa 03',
      'status': 'Por cobrar',
      'detail': 'Total C\$ 348.00',
      'waiterInitials': 'CR',
      'waiterName': 'Carlos Rivera',
      'type': 'Por cobrar',
    },
    {
      'name': 'Mesa 05',
      'status': 'Libre',
      'detail': 'Lista para recibir clientes',
      'waiterInitials': 'CR',
      'waiterName': 'Carlos Rivera',
      'type': 'Libre',
    },
    {
      'name': 'Mesa VIP 06',
      'status': 'Ocupada',
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

  // 1. Top Bar superior (Ajustado con la imagen mimi2.png)
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
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: Color(0xFF2E221E),
                size: 22,
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
          'Selecciona una mesa para tomar o revisar comanda',
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
      ],
    );
  }

  // 3. Tarjetas de resumen superior (KPIs)
  Widget _buildKpiCards() {
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
                  children: const [
                    Text(
                      '6',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '/ 12',
                      style: TextStyle(fontSize: 14, color: Colors.white60),
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
                  children: const [
                    Text(
                      '6',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(width: 6),
                    Text(
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

  // 4. Filtros rápidos deslizables (Chips horizontales)
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

  // 6. Cuadrícula de tarjetas de mesas (Grid de 2 columnas)
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
        final status = table['status'] as String;

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
          onTap: () {
            if (widget.onTableTap != null) {
              // Pasamos la mesa completa al callback (por ej. para abrir la comanda)
              widget.onTableTap!(table);
            } else {
              // Si no hay callback externo, mostramos el detalle aquí mismo
              _showTableDetail(context, table, statusColor, badgeBgColor);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
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
                              table['detail'],
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
                                    table['waiterInitials'],
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
                                  table['waiterName'],
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
                            Icons.more_vert_rounded,
                            color: Colors.grey,
                            size: 18,
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

  // BottomSheet con el detalle de la mesa seleccionada
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
                Text(
                  table['name'] as String,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E221E),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: badgeBgColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    table['status'] as String,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Detalle de la mesa
            _detailRow(Icons.info_outline, 'Detalle',
                table['detail'] as String),
            const SizedBox(height: 12),
            _detailRow(
              Icons.person_outline,
              'Mesero asignado',
              table['waiterName'] as String,
            ),
            const Divider(height: 32),

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
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  (table['status'] == 'Libre')
                      ? 'Asignar mesa'
                      : 'Ver comanda',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
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
                  style: const TextStyle(
                      fontSize: 11, color: Colors.grey)),
              const SizedBox(height: 2),
              Text(value,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E221E))),
            ],
          ),
        ),
      ],
    );
  }
}
