import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../presentation/providers/inventario_provider.dart';
import '../../../data/models/inventario_model.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  TextEditingController search_ctrl = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Cargamos el inventario al abrir la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<InventarioProvider>(context, listen: false)
          .loadInventarioData();
    });
    search_ctrl.addListener(() {
      setState(() => _searchQuery = search_ctrl.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    search_ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Consumer<InventarioProvider>(
          builder: (context, provider, _) {
            final resumen = provider.resumen;
            final alertas = provider.alertas;

            // Filtramos alertas según búsqueda
            final filteredAlertas = _searchQuery.isEmpty
                ? alertas
                : alertas
                    .where((a) =>
                        a.nombre.toLowerCase().contains(_searchQuery))
                    .toList();

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
                      'CONTROL DE STOCK',
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
                          'Inventario',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        // Botón de actualizar
                        InkWell(
                          onTap: () => provider.loadInventarioData(),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.grey.shade300),
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
                          hintText: 'Buscar ítems, ingredientes...',
                          hintStyle: TextStyle(color: Colors.black38),
                          prefixIcon:
                              Icon(Icons.search, color: Colors.black38),
                          suffixIcon: Icon(
                            Icons.qr_code_scanner,
                            color: Colors.black38,
                          ),
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 15),
                        ),
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
                      // ERROR
                      if (provider.errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.amber.shade200),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline,
                                    size: 16, color: Colors.amber.shade800),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    provider.errorMessage,
                                    style: TextStyle(
                                        color: Colors.amber.shade900, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      // TARJETAS DE RESUMEN
                      Row(
                        children: [
                          // Tarjeta oscura – Valor total
                          Expanded(
                            flex: 5,
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              height: 180,
                              decoration: BoxDecoration(
                                color: const Color(0xFF38231c),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Valor total del stock',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    resumen != null
                                        ? 'C\$ ${resumen.valoracionTotal.toStringAsFixed(0)}'
                                        : 'C\$ —',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
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
                                          resumen != null
                                              ? '${resumen.tasaAlerta.toStringAsFixed(1)}% en alerta'
                                              : 'Sin datos',
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
                          // Tarjeta clara – Total de ítems
                          Expanded(
                            flex: 4,
                            child: Container(
                              width: double.infinity,
                              height: 180,
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border:
                                    Border.all(color: Colors.grey.shade200),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total de ítems',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    resumen != null
                                        ? '${resumen.totalInsumos}'
                                        : '—',
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${alertas.length} en alerta',
                                    style: TextStyle(
                                      color: alertas.isNotEmpty
                                          ? Colors.red[500]
                                          : Colors.grey[500],
                                      fontSize: 11,
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
                        children: [
                          const Text(
                            'ALERTAS DE STOCK BAJO',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${filteredAlertas.length} ítems',
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 13),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),
                      const Text(
                        'Insumos en nivel crítico',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 15),

                      // LISTA DE ALERTAS DE INVENTARIO
                      if (filteredAlertas.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Column(
                              children: [
                                Icon(Icons.check_circle_outline,
                                    color: Colors.green[400], size: 48),
                                const SizedBox(height: 12),
                                Text(
                                  'Todo el stock está en niveles normales',
                                  style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        Column(
                          children: filteredAlertas
                              .map((a) => _buildInventoryRow(a))
                              .toList(),
                        ),
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

  // Fila de alerta de inventario (viene de la API)
  Widget _buildInventoryRow(AlertaStockModel alerta) {
    // Iniciales del nombre del insumo
    final parts = alerta.nombre.trim().split(' ');
    final initials = parts.length >= 2
        ? '${parts[0][0]}${parts[1][0]}'.toUpperCase()
        : alerta.nombre.substring(0, alerta.nombre.length.clamp(0, 2)).toUpperCase();

    final isHealthy = alerta.stockActual >= alerta.stockMinimo;

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
          // Cuadro con las iniciales
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                initials,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),

          // Texto central
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alerta.nombre,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Mínimo: ${alerta.stockMinimo} ${alerta.unidadMedida}',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ],
            ),
          ),

          // Cantidad y estado
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${alerta.stockActual} ${alerta.unidadMedida}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isHealthy
                      ? Colors.green.shade50
                      : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  isHealthy ? 'Sano' : 'Bajo stock',
                  style: TextStyle(
                    color: isHealthy
                        ? Colors.green.shade700
                        : Colors.red.shade700,
                    fontSize: 10,
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
}