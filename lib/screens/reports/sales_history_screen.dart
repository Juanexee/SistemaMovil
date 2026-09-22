import 'package:flutter/material.dart';

// Lo deje como StatefulWidget por si despues le metemos filtro al buscador
class SalesHistoryScreen extends StatefulWidget {
  const SalesHistoryScreen({super.key});

  @override
  State<SalesHistoryScreen> createState() => _SalesHistoryScreenState();
}

class _SalesHistoryScreenState extends State<SalesHistoryScreen> {
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
            _buildNavItem(Icons.inventory_2_outlined, 'Inventario', false),
            _buildNavItem(
              Icons.show_chart,
              'Reportes',
              true,
            ), // Este esta activo
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
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.tune,
                        color: Colors.black87,
                        size: 20,
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
                      prefixIcon: Icon(Icons.search, color: Colors.black38),
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

                // FILTROS (Row con scroll horizontal por si agregamos mas)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('Rango de fechas'),
                      const SizedBox(width: 10),
                      _buildFilterChip('Monto'),
                      const SizedBox(width: 10),
                      _buildFilterChip('Estado'),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // TARJETAS DE RESUMEN
                Row(
                  children: [
                    // Tarjeta oscura
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
                              "Ventas de Hoy",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              '\$1,284.60',
                              style: TextStyle(
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
                                  // <-- Esto evita que el texto rompa el diseño
                                  child: Text(
                                    '12.5% vs sem. pasada',
                                    style: TextStyle(
                                      color: Colors.grey[300],
                                      fontSize: 12,
                                    ),
                                    overflow: TextOverflow
                                        .ellipsis, // Agrega "..." si la pantalla es muy pequeña
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    // Tarjeta clara
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Transacciones de Hoy',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              '24',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              '8 pagadas esta hora',
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
                  children: [
                    const Text(
                      'HISTORIAL DE TRANSACCIONES',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Total: \$609.20',
                      style: TextStyle(color: Colors.grey[500], fontSize: 13),
                    ),
                  ],
                ),

                const SizedBox(height: 15),
                const Text(
                  'Facturas Recientes',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 15),

                // LISTA DE FACTURAS
                // use un Column porque el ListView me daba un error raro de tamaño infinito
                Column(
                  children: [
                    _buildInvoiceRow(
                      '#1045',
                      'Hoy, 12:42 PM',
                      'Efectivo',
                      '\$86.40',
                      Icons.mail_outline,
                    ),
                    _buildInvoiceRow(
                      '#1044',
                      'Hoy, 11:18 AM',
                      'Tarjeta de crédito',
                      '\$142.80',
                      Icons.inbox_outlined,
                    ),
                    _buildInvoiceRow(
                      '#1043',
                      'Ayer, 8:36 PM',
                      'Tarjeta de crédito',
                      '\$64.25',
                      Icons.mail_outline,
                    ),
                    _buildInvoiceRow(
                      '#1042',
                      'Ayer, 7:09 PM',
                      'Efectivo',
                      '\$218.60',
                      Icons.inbox_outlined,
                    ),
                    _buildInvoiceRow(
                      '#1041',
                      '18 Mar, 6:24 PM',
                      'Tarjeta de crédito',
                      '\$97.15',
                      Icons.mail_outline,
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

  // Metodo para no repetir tanto codigo en los filtros (me di cuenta tarde xd)
  Widget _buildFilterChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
          const SizedBox(width: 5),
          const Icon(
            Icons.keyboard_arrow_down,
            size: 16,
            color: Colors.black54,
          ),
        ],
      ),
    );
  }

  // Constructor de las celdas de la lista
  Widget _buildInvoiceRow(
    String id,
    String date,
    String payMethod,
    String amount,
    IconData icon,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12), // Espacio entre cada tarjeta
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
              color: Color(0xFFF5EBE6), // Colorcito cafe claro
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
                  id,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
                const SizedBox(height: 2),
                Text(
                  payMethod,
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ],
            ),
          ),

          // Montos y boton
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    'Vista detallada',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(Icons.chevron_right, color: Colors.grey[600], size: 16),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Botones de navegacion de abajo
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
