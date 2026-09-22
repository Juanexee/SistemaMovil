import 'package:flutter/material.dart';

class AuditLogsScreen extends StatefulWidget {
  const AuditLogsScreen({super.key});

  @override
  State<AuditLogsScreen> createState() => _AuditLogsScreenState();
}

class _AuditLogsScreenState extends State<AuditLogsScreen> {
  // Controlador para el buscador
  TextEditingController search_ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Fondo gris claro
      // BARRA INFERIOR (Reutilizada de las pantallas anteriores)
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        color: const Color(0xFF2E221E), // Cafe oscuro
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
          ClipRRect(
  borderRadius: BorderRadius.circular(14),
  child: Image.asset(
    'assets/images/mimi2.jpg',
    width: 55,
    height: 55,
    fit: BoxFit.cover,
  ),
),
          ],
        ),
      ),

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
                    Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E221E),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'EL',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                    const Icon(Icons.notifications_none, color: Colors.black87),
                  ],
                ),

                const SizedBox(height: 30),

                // TITULOS DE SECCION
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'TRAZABILIDAD Y CONTROL',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.shield_outlined,
                          color: Colors.green[600],
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Seguro',
                          style: TextStyle(
                            color: Colors.green[600],
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                const Text(
                  'Registros de auditoría',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 5),
                Text(
                  'Cada acción, claramente contabilizada',
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
                      hintText: 'Buscar eventos o usuarios...',
                      hintStyle: TextStyle(color: Colors.black38),
                      prefixIcon: Icon(Icons.search, color: Colors.black38),
                      suffixIcon: Icon(
                        Icons.fingerprint,
                        color: Colors.black38,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // FILTROS
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('Usuario', Icons.person_outline),
                      const SizedBox(width: 10),
                      _buildFilterChip('Fecha', Icons.calendar_today_outlined),
                      const SizedBox(width: 10),
                      _buildFilterChip('Tipo de evento', Icons.filter_list),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // TARJETAS DE RESUMEN
                Row(
                  children: [
                    // Tarjeta oscura
                    Expanded(
                      flex: 5,
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
                              "Eventos de hoy",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              '42',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 36,
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
                                Text(
                                  '8.4% vs ayer',
                                  style: TextStyle(
                                    color: Colors.grey[300],
                                    fontSize: 12,
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
                    // Tarjeta clara
                    Expanded(
                      flex: 4,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        // Eliminamos el height: 145 para que la tarjeta se expanda según el texto
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment
                              .center, // Centramos por si queda espacio
                          children: [
                            Text(
                              'Alertas críticas',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              '02',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                Icon(
                                  Icons.warning_amber_rounded,
                                  color: Colors.grey[500],
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  // Envolvemos este texto en Expanded por precaución para evitar overflow horizontal
                                  child: Text(
                                    'Requiere revisión',
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 11,
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
                  ],
                ),

                const SizedBox(height: 30),

                // HEADER DE LA LISTA
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'ACTIVIDAD EN VIVO',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '5 registros',
                      style: TextStyle(color: Colors.grey[500], fontSize: 13),
                    ),
                  ],
                ),

                const SizedBox(height: 15),
                const Text(
                  'Eventos recientes',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 15),

                // LISTA DE LOGS
                Column(
                  children: [
                    _buildLogItem(
                      icon: Icons.warning_amber_rounded,
                      iconColor: Colors.red[400]!,
                      title: 'Orden Anulada',
                      subtitle: 'Orden #1045 - \$86.40',
                      userInitials: 'MG',
                      userName: 'Maria González',
                      time: 'Hoy, 12:42 PM',
                      isAlert: true,
                    ),
                    _buildLogItem(
                      icon: Icons.check_circle_outline,
                      iconColor: Colors.green[400]!,
                      title: 'Caja Registradora Abierta',
                      subtitle: 'Caja 01 - Turno iniciado',
                      userInitials: 'CR',
                      userName: 'Carlos Rivera',
                      time: 'Hoy, 11:18 AM',
                      isAlert: false,
                    ),
                    _buildLogItem(
                      icon: Icons.check_circle_outline,
                      iconColor: Colors.green[400]!,
                      title: 'Inventario Ajustado',
                      subtitle: 'Tomates - -4 unids',
                      userInitials: 'SM',
                      userName: 'Sofia Martínez',
                      time: 'Hoy, 10:08 AM',
                      isAlert: false,
                    ),
                    _buildLogItem(
                      icon: Icons.check_circle_outline,
                      iconColor: Colors.green[400]!,
                      title: 'Descuento Aplicado',
                      subtitle: 'Orden #1043 - 15% descuento',
                      userInitials: 'CR',
                      userName: 'Carlos Rivera',
                      time: 'Ayer, 8:36 PM',
                      isAlert: false,
                    ),
                    _buildLogItem(
                      icon: Icons.warning_amber_rounded,
                      iconColor: Colors.red[400]!,
                      title: 'Orden Anulada',
                      subtitle: 'Orden #1042 - Aprobado por manager',
                      userInitials: 'JL',
                      userName: 'Jorge López',
                      time: 'Ayer, 7:09 PM',
                      isAlert: true,
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

  // Los filtros con icono que vimos en la maqueta
  Widget _buildFilterChip(String label, IconData startIcon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(startIcon, size: 14, color: Colors.black54),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
          const SizedBox(width: 6),
          const Icon(
            Icons.keyboard_arrow_down,
            size: 16,
            color: Colors.black54,
          ),
        ],
      ),
    );
  }

  // Fila para los logs de auditoria
  Widget _buildLogItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String userInitials,
    required String userName,
    required String time,
    required bool isAlert, // Para controlar el colorcito de la izquierda
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Borde indicador
          Container(
            width: 4,
            height:
                100, // Alto fijo para asegurar que la linea lateral se dibuje completa
            decoration: BoxDecoration(
              color: isAlert ? Colors.red[300] : Colors.green[300],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  // Primera fila (Icono, Tituo y Flecha)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(icon, color: iconColor, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              subtitle,
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey[400],
                        size: 20,
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // Segunda fila (Usuario y Hora)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              userInitials,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            userName,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 12,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            time,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

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