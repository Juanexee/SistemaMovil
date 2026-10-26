import 'package:flutter/material.dart';
import '../../../core/di/injection.dart';
import '../../../services/auditoria_service.dart';
import '../../../services/dashboard_service.dart';
import '../../../data/models/auditoria_model.dart';
import '../../../data/models/dashboard_model.dart';

class AuditLogsScreen extends StatefulWidget {
  const AuditLogsScreen({super.key});

  @override
  State<AuditLogsScreen> createState() => _AuditLogsScreenState();
}

class _AuditLogsScreenState extends State<AuditLogsScreen> {
  // Controlador para el buscador
  TextEditingController search_ctrl = TextEditingController();

  bool _isLoading = false;
  List<LogAuditoriaModel> _logs = [];
  KpisModel? _kpis;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    setState(() => _isLoading = true);
    try {
      final audService = sl<AuditoriaService>();
      final dashService = sl<DashboardService>();

      final results = await Future.wait([
        audService.getLogs().catchError((_) => <LogAuditoriaModel>[]),
        dashService.getKpis().catchError(
          (_) => KpisModel(ventasDelDia: 0, ticketPromedio: 0, margenAcumulado: 0),
        ),
      ]);

      if (mounted) {
        setState(() {
          _logs = results[0] as List<LogAuditoriaModel>;
          _kpis = results[1] as KpisModel;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Fondo gris claro

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TOP BAR (Modificado para incluir el logo)
                Row(
                  children: [
                    // --- AQUÍ ESTÁ EL CAMBIO ---
                    // Contenedor que antes tenía 'EL', ahora tiene la imagen
                    Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: const Color(
                          0xFF2E221E,
                        ), // Mantenemos el fondo oscuro
                        borderRadius: BorderRadius.circular(8),
                      ),
                      // Usamos ClipRRect para redondear las esquinas de la imagen si fuera necesario
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/images/mimi2.png', // <--- Ruta a tu imagen
                          fit: BoxFit.cover, // Para que llene el cuadrado
                        ),
                      ),
                    ),
                    // -----------------------------
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
                              "Eventos cargados",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '${_logs.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                const Icon(
                                  Icons.sync,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'Conectado a la API',
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
                    Expanded(
                      flex: 4,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Ventas de hoy',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '\$${_kpis != null ? _kpis!.ventasDelDia.toStringAsFixed(2) : "0.00"}',
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                Icon(
                                  Icons.monetization_on_outlined,
                                  color: Colors.green[600],
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    'Ticket: \$${_kpis != null ? _kpis!.ticketPromedio.toStringAsFixed(2) : "0.00"}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
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
                      '${_logs.length} registros',
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
                if (_isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(30.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (_logs.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.inbox_outlined, size: 40, color: Colors.grey[400]),
                        const SizedBox(height: 10),
                        Text(
                          'No hay eventos de auditoría registrados',
                          style: TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                      ],
                    ),
                  )
                else
                  Column(
                    children: _logs.map((log) {
                      final isWarn = log.tipoEvento.toUpperCase() == 'ANULACION' ||
                          log.tipoEvento.toUpperCase() == 'ERROR';
                      final initial = log.usuarioResponsable.isNotEmpty
                          ? log.usuarioResponsable.substring(0, 1).toUpperCase()
                          : 'S';
                      return _buildLogItem(
                        icon: isWarn
                            ? Icons.warning_amber_rounded
                            : Icons.check_circle_outline,
                        iconColor: isWarn ? Colors.red[400]! : Colors.green[400]!,
                        title: log.descripcion.isNotEmpty
                            ? log.descripcion
                            : 'Evento: ${log.tipoEvento}',
                        subtitle: '${log.modulo} • ${log.fecha}',
                        userInitials: initial,
                        userName: log.usuarioResponsable.isNotEmpty
                            ? log.usuarioResponsable
                            : 'Sistema',
                        time: log.fecha.length > 10
                            ? log.fecha.substring(0, 10)
                            : log.fecha,
                        isAlert: isWarn,
                      );
                    }).toList(),
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
}