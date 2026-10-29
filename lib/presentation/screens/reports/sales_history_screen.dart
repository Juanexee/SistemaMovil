import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../presentation/providers/ventas_provider.dart';
import '../../../data/models/ventas_model.dart';
import '../../widgets/pagination_controls.dart';

class SalesHistoryScreen extends StatefulWidget {
  const SalesHistoryScreen({super.key});

  @override
  State<SalesHistoryScreen> createState() => _SalesHistoryScreenState();
}

class _SalesHistoryScreenState extends State<SalesHistoryScreen> {
  final TextEditingController search_ctrl = TextEditingController();
  String _searchQuery = '';
  String _selectedEstado = 'Todos';
  String _selectedRango = 'Todos'; // 'Todos', 'Hoy', 'Últimos 7 días'
  double? _minMonto;
  int _currentPage = 1;
  static const int _itemsPerPage = 15;

  @override
  void initState() {
    super.initState();
    // Cargamos las ventas al abrir la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VentasProvider>(context, listen: false).loadVentas();
    });
    search_ctrl.addListener(() {
      setState(() {
        _searchQuery = search_ctrl.text.toLowerCase();
        _currentPage = 1;
      });
    });
  }

  @override
  void dispose() {
    search_ctrl.dispose();
    super.dispose();
  }

  // Filtra las ventas por ID, estado, rango de fechas y monto
  List<VentaModel> _filteredVentas(List<VentaModel> all) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);

    return all.where((v) {
      if (_searchQuery.isNotEmpty) {
        final matchSearch = '#${v.id}'.contains(_searchQuery) ||
            v.estado.toLowerCase().contains(_searchQuery) ||
            (v.metodoPago?.toLowerCase().contains(_searchQuery) ?? false);
        if (!matchSearch) return false;
      }

      if (_selectedEstado != 'Todos') {
        if (!v.estado.toLowerCase().contains(_selectedEstado.toLowerCase())) {
          return false;
        }
      }

      if (_minMonto != null && v.total < _minMonto!) {
        return false;
      }

      if (_selectedRango != 'Todos' && v.fecha != null && v.fecha!.isNotEmpty) {
        try {
          final dt = DateTime.parse(v.fecha!).toLocal();
          final dtDate = DateTime(dt.year, dt.month, dt.day);
          if (_selectedRango == 'Hoy' && dtDate != todayStart) {
            return false;
          } else if (_selectedRango == 'Últimos 7 días' &&
              todayStart.difference(dtDate).inDays > 7) {
            return false;
          }
        } catch (_) {}
      }

      return true;
    }).toList();
  }

  // Formatea fecha comparando por día calendario real
  String _formatFecha(String? fecha) {
    if (fecha == null || fecha.isEmpty) return 'Sin fecha';
    try {
      final dt = DateTime.parse(fecha).toLocal();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final dtDay = DateTime(dt.year, dt.month, dt.day);
      final diffDays = today.difference(dtDay).inDays;
      final hh = dt.hour.toString().padLeft(2, '0');
      final mm = dt.minute.toString().padLeft(2, '0');

      if (diffDays == 0) return 'Hoy, $hh:$mm';
      if (diffDays == 1) return 'Ayer, $hh:$mm';
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return fecha;
    }
  }

  // Icono según método de pago
  IconData _iconForPago(String? metodo) {
    if (metodo == null) return Icons.receipt_outlined;
    final m = metodo.toLowerCase();
    if (m.contains('tarjeta') || m.contains('card')) return Icons.credit_card;
    if (m.contains('efectivo') || m.contains('cash')) return Icons.attach_money;
    return Icons.receipt_outlined;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Consumer<VentasProvider>(
          builder: (context, provider, _) {
            final all = provider.ventas;
            final filtered = _filteredVentas(all);

            // Totales para el resumen (excluyendo ventas canceladas)
            final totalHoy = all
                .where((v) => !v.estado.toLowerCase().contains('cancel'))
                .fold<double>(0, (sum, v) => sum + v.total);
            final countHoy = all.length;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TOP BAR
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/images/mimi2.png',
                            width: 35,
                            height: 35,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'El Rancho\nLa Mimi',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          'En línea',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                        const SizedBox(width: 15),
                        const Icon(Icons.notifications_none,
                            color: Colors.black87),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // TÍTULOS
                    const Text(
                      'RESUMEN FINANCIERO',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Historial de Ventas',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        // Botón de actualizar
                        InkWell(
                          onTap: () {
                            setState(() {
                              _selectedEstado = 'Todos';
                              _selectedRango = 'Todos';
                              _minMonto = null;
                              _currentPage = 1;
                            });
                            provider.loadVentas();
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.refresh,
                              color: Colors.black87,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Aquí puedes ver un resumen de todas las ventas realizadas en tu negocio.',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),

                    const SizedBox(height: 25),

                    // BUSCADOR
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: TextFormField(
                        controller: search_ctrl,
                        decoration: const InputDecoration(
                          hintText: 'Buscar facturas...',
                          hintStyle: TextStyle(color: Colors.black38),
                          prefixIcon:
                              Icon(Icons.search, color: Colors.black38),
                          suffixIcon: Icon(
                            Icons.description_outlined,
                            color: Colors.black38,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // FILTROS INTERACTIVOS
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip(
                            label: _selectedRango == 'Todos'
                                ? 'Rango de fechas'
                                : 'Fecha: $_selectedRango',
                            isActive: _selectedRango != 'Todos',
                            onTap: () {
                              const opciones = [
                                'Todos',
                                'Hoy',
                                'Últimos 7 días',
                              ];
                              final nextIdx =
                                  (opciones.indexOf(_selectedRango) + 1) %
                                      opciones.length;
                              setState(() {
                                _selectedRango = opciones[nextIdx];
                                _currentPage = 1;
                              });
                            },
                          ),
                          const SizedBox(width: 10),
                          _buildFilterChip(
                            label: _minMonto == null
                                ? 'Monto'
                                : 'Monto ≥ C\$ ${_minMonto!.toInt()}',
                            isActive: _minMonto != null,
                            onTap: () {
                              const opciones = <double?>[null, 100, 300, 500];
                              final nextIdx =
                                  (opciones.indexOf(_minMonto) + 1) %
                                      opciones.length;
                              setState(() {
                                _minMonto = opciones[nextIdx];
                                _currentPage = 1;
                              });
                            },
                          ),
                          const SizedBox(width: 10),
                          _buildFilterChip(
                            label: _selectedEstado == 'Todos'
                                ? 'Estado'
                                : 'Estado: $_selectedEstado',
                            isActive: _selectedEstado != 'Todos',
                            onTap: () {
                              const estados = [
                                'Todos',
                                'Pagada',
                                'Pendiente',
                                'Cancelada',
                              ];
                              final nextIdx =
                                  (estados.indexOf(_selectedEstado) + 1) %
                                      estados.length;
                              setState(() {
                                _selectedEstado = estados[nextIdx];
                                _currentPage = 1;
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // INDICADOR DE CARGA
                    if (provider.isLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(30.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else ...[
                      // AVISO INFORMATIVO DE PERMISOS / ERROR
                      if (provider.errorMessage.isNotEmpty &&
                          provider.ventas.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF8E1),
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: const Color(0xFFFFD54F)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.info_outline,
                                  color: Color(0xFFE65100),
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    provider.errorMessage,
                                    style: const TextStyle(
                                      color: Color(0xFF5D4037),
                                      fontSize: 12,
                                      height: 1.3,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      // TARJETAS DE RESUMEN
                      Row(
                        children: [
                          // Tarjeta oscura – ventas totales
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: const Color(0xFF38231c),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Total de ventas',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'C\$ ${totalHoy.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.trending_up,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                          '$countHoy transacciones registradas',
                                          style: TextStyle(
                                            color: Colors.grey[300],
                                            fontSize: 12,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          // Tarjeta clara – transacciones
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border:
                                    Border.all(color: Colors.grey.shade200),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Transacciones',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '$countHoy',
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    '${filtered.length} coinciden con la búsqueda',
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // HEADER DE LA LISTA
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Expanded(
                            child: Text(
                              'HISTORIAL DE TRANSACCIONES',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                                letterSpacing: 1.1,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Total: C\$ ${filtered.where((v) => !v.estado.toLowerCase().contains('cancel')).fold<double>(0, (s, v) => s + v.total).toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),
                      const Text(
                        'Facturas Recientes',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 15),

                      // LISTA DE VENTAS
                      if (filtered.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Text(
                              'No se encontraron ventas',
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                          ),
                        )
                      else ...[
                        Builder(
                          builder: (context) {
                            final totalPages =
                                (filtered.length / _itemsPerPage).ceil();
                            final safePage = _currentPage.clamp(
                                1, totalPages > 0 ? totalPages : 1);
                            final startIndex =
                                (safePage - 1) * _itemsPerPage;
                            final endIndex = (startIndex + _itemsPerPage)
                                .clamp(0, filtered.length);
                            final pagedItems =
                                filtered.sublist(startIndex, endIndex);

                            return Column(
                              children: [
                                ...pagedItems.map((v) => _buildInvoiceRow(v)),
                                if (totalPages > 1)
                                  PaginationControls(
                                    currentPage: safePage,
                                    totalPages: totalPages,
                                    totalItems: filtered.length,
                                    itemsPerPage: _itemsPerPage,
                                    onPageChanged: (newPage) {
                                      setState(() => _currentPage = newPage);
                                    },
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
                    ],

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF38231c) : Colors.white,
          border: Border.all(
            color: isActive ? const Color(0xFF38231c) : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: isActive ? Colors.white : Colors.black87,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            const SizedBox(width: 5),
            Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: isActive ? Colors.white : Colors.black54,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceRow(VentaModel venta) {
    final icon = _iconForPago(venta.metodoPago);
    final fecha = _formatFecha(venta.fecha);
    final metodo = venta.metodoPago ?? 'Sin método';
    final estadoColor = _estadoColor(venta.estado);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Icono circular
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFFF5EBE6),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF8A6D5C), size: 20),
          ),
          const SizedBox(width: 15),

          // Textos del medio
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '#${venta.id}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  fecha,
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
                const SizedBox(height: 2),
                Text(
                  metodo,
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ],
            ),
          ),

          // Monto y estado
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'C\$ ${venta.total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: estadoColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  venta.estado,
                  style: TextStyle(
                    color: estadoColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _estadoColor(String estado) {
    final e = estado.toLowerCase();
    if (e.contains('pagad') ||
        e.contains('cobrad') ||
        e.contains('completad')) {
      return Colors.green;
    }
    if (e.contains('pendiente') || e.contains('activ')) {
      return Colors.orange;
    }
    if (e.contains('cancel')) return Colors.red;
    return Colors.grey;
  }
}
