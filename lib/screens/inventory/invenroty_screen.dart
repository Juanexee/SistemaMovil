import 'package:flutter/material.dart';
 
class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});
 
  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}
 
class _InventoryScreenState extends State<InventoryScreen> {
  // Controlador del buscador, como vimos en la clase
  TextEditingController search_ctrl = TextEditingController();
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF8F9FA,
      ), // Un gris super clarito para el fondo
      // BARRA INFERIOR CUSTOMIZADA (El BottomNavigationBar normal daba muchos problemas de color)
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        color: const Color(0xFF2E221E), // Cafe oscuro
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home_outlined, 'Inicio', false),
            _buildNavItem(
              Icons.inventory_2_outlined,
              'Inventario',
              true,
            ), // Este esta activo
            _buildNavItem(Icons.show_chart, 'Reportes', false),
            _buildNavItem(Icons.settings_outlined, 'Ajustes', false),
          ],
        ),
      ),
 
      // CUERPO DE LA PANTALLA
      // Uso SingleChildScrollView para que haga scroll en Y y no de error de pixeles
      body: SafeArea(
        child: SingleChildScrollView(
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
    // Estado online
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
    const Icon(Icons.notifications_none, color: Colors.black87),
  ],
),
 
                const SizedBox(height: 30),
 
                // TITULOS
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
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.grid_view_rounded,
                        color: Colors.black87,
                        size: 20,
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
                      prefixIcon: Icon(Icons.search, color: Colors.black38),
                      suffixIcon: Icon(
                        Icons.qr_code_scanner,
                        color: Colors.black38,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
 
                const SizedBox(height: 25),
 
                // TARJETAS DE RESUMEN
                // Uso el expanded para que no de overflow
                Row(
                  children: [
                    // Tarjeta oscura (Valor total)
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        height:
                            180, // Le di un alto fijo para que se alinee con las otras dos
                        decoration: BoxDecoration(
                          color: const Color(0xFF38231c),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween, // Para que el de arriba quede arriba y el de abajo abajo
                          children: [
                            const Text(
                              "Valor total del stock",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            const Text(
                              '\$15,240',
                              style: TextStyle(
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
                                    '8.4% este mes',
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
                    // Columna con las dos tarjetas claras
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          // Tarjeta de rotacion
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tasa de rotación',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  '4.5x',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Ritmo saludable',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Tarjeta de total de items
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total de ítems',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  '128',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'En 6 categorías',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
                      'RESUMEN DEL CATÁLOGO',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '5 ítems',
                      style: TextStyle(color: Colors.grey[500], fontSize: 13),
                    ),
                  ],
                ),
 
                const SizedBox(height: 15),
                const Text(
                  'Todo el inventario',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 15),
 
                // LISTA DE INVENTARIO
                // use un Column igual que en la de reportes para evitar el error de layout
                Column(
                  children: [
                    _buildInventoryRow(
                      'TO',
                      'Tomates',
                      'Producto fresco',
                      '12 kg',
                      true,
                    ),
                    _buildInventoryRow(
                      'LI',
                      'Limones',
                      'Producto fresco',
                      '3.2 kg',
                      false,
                    ),
                    _buildInventoryRow(
                      'CT',
                      'Tortillas de maíz',
                      'Productos secos',
                      '240 unids',
                      true,
                    ),
                    _buildInventoryRow(
                      'QC',
                      'Queso Oaxaca',
                      'Lácteos y fríos',
                      '8.5 kg',
                      true,
                    ),
                    _buildInventoryRow(
                      'JS',
                      'Jarabe de agave',
                      'Bar y bebidas',
                      '2.1 L',
                      false,
                    ),
                  ],
                ),
 
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
 
  // Constructor de las celdas de la lista de inventario
  Widget _buildInventoryRow(
    String initals,
    String name,
    String category,
    String amount,
    bool isHealthy,
  ) {
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
              color: const Color(0xFFF8F9FA), // Gris claro
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                initals,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
 
          // Textos del medio
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  category,
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ],
            ),
          ),
 
          // Montos y estado
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  // Si esta sano es verde, si no es rosado/rojo claro
                  color: isHealthy ? Colors.green.shade50 : Colors.red.shade50,
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
 
  // Botones de navegacion de abajo (reutilizado)
  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: isActive ? Colors.white : Colors.grey[500], size: 24),
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
    );
  }
}