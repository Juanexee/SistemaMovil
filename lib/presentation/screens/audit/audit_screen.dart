import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/di/injection.dart';
import '../../../services/auditoria_service.dart';
import '../../../services/dashboard_service.dart';
import '../../../data/models/auditoria_model.dart';
import '../../../data/models/dashboard_model.dart';
import '../../../data/models/metrics_model.dart';
import '../../providers/metrics_provider.dart';
import '../../widgets/pagination_controls.dart';

class AuditLogsScreen extends StatefulWidget {
  const AuditLogsScreen({super.key});

  @override
  State<AuditLogsScreen> createState() => _AuditLogsScreenState();
}

class _AuditLogsScreenState extends State<AuditLogsScreen> {
  // Controlador para el buscador
  final TextEditingController search_ctrl = TextEditingController();
  String _searchQuery = '';
  String _selectedTipoEvento = 'Todos';
  int _currentPage = 1;
  static const int _itemsPerPage = 15;

  // 0 = Auditoría, 1 = Métricas de API y Memoria (MongoDB)
  int _activeTab = 0;
  // Sub-pestaña dentro de Métricas: 0 = Uso de API (api-usage), 1 = Memoria y CPU (memory)
  int _metricsSubTab = 0;

  bool _isLoading = false;
  List<LogAuditoriaModel> _logs = [];
  KpisModel? _kpis;

  @override
  void initState() {
    super.initState();
    search_ctrl.addListener(() {
      setState(() {
        _searchQuery = search_ctrl.text.toLowerCase().trim();
        _currentPage = 1;
      });
    });
    _cargarDatos();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<MetricsProvider>(context, listen: false).loadMetrics();
      }
    });
  }

  @override
  void dispose() {
    search_ctrl.dispose();
    super.dispose();
  }

  List<LogAuditoriaModel> get _filteredLogs {
    return _logs.where((l) {
      if (_selectedTipoEvento != 'Todos') {
        if (!l.tipoEvento
            .toLowerCase()
            .contains(_selectedTipoEvento.toLowerCase())) {
          return false;
        }
      }
      if (_searchQuery.isNotEmpty) {
        return l.descripcion.toLowerCase().contains(_searchQuery) ||
            l.tipoEvento.toLowerCase().contains(_searchQuery) ||
            l.usuarioResponsable.toLowerCase().contains(_searchQuery) ||
            l.modulo.toLowerCase().contains(_searchQuery);
      }
      return true;
    }).toList();
  }

  Future<void> _cargarDatos() async {
    setState(() => _isLoading = true);
    try {
      final audService = sl<AuditoriaService>();
      final dashService = sl<DashboardService>();

      final results = await Future.wait([
        audService.getLogs().catchError((_) => <LogAuditoriaModel>[]),
        dashService.getKpis().catchError(
          (_) =>
              KpisModel(ventasDelDia: 0, ticketPromedio: 0, margenAcumulado: 0),
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

  String _formatTimestamp(String raw) {
    if (raw.isEmpty) return 'Reciente';
    try {
      final dt = DateTime.parse(raw).toLocal();
      final dd = dt.day.toString().padLeft(2, '0');
      final mm = dt.month.toString().padLeft(2, '0');
      final hh = dt.hour.toString().padLeft(2, '0');
      final min = dt.minute.toString().padLeft(2, '0');
      final sec = dt.second.toString().padLeft(2, '0');
      return '$dd/$mm/${dt.year} $hh:$min:$sec';
    } catch (_) {
      return raw.length > 19 ? raw.substring(0, 19) : raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
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
                    InkWell(
                      onTap: () {
                        if (_activeTab == 0) {
                          _cargarDatos();
                        } else {
                          Provider.of<MetricsProvider>(context, listen: false)
                              .loadMetrics();
                        }
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(Icons.refresh, color: Colors.black87, size: 22),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // SELECTOR DE VISTA: AUDITORÍA VS MÉTRICAS (MONGODB)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() {
                            _activeTab = 0;
                            _currentPage = 1;
                          }),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: _activeTab == 0
                                  ? const Color(0xFF38231c)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.verified_user_outlined,
                                  size: 16,
                                  color: _activeTab == 0
                                      ? Colors.white
                                      : Colors.black54,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Auditoría',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: _activeTab == 0
                                        ? Colors.white
                                        : Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _activeTab = 1;
                              _currentPage = 1;
                            });
                            final mp = Provider.of<MetricsProvider>(
                              context,
                              listen: false,
                            );
                            if (mp.summary == null &&
                                mp.apiUsageLogs.isEmpty &&
                                mp.memoryMetrics.isEmpty &&
                                !mp.isLoading) {
                              mp.loadMetrics();
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: _activeTab == 1
                                  ? const Color(0xFF38231c)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.speed_rounded,
                                  size: 16,
                                  color: _activeTab == 1
                                      ? Colors.white
                                      : Colors.black54,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Métricas API & RAM',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: _activeTab == 1
                                        ? Colors.white
                                        : Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                if (_activeTab == 0)
                  _buildAuditoriaSection()
                else
                  _buildMetricsSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // SECCIÓN 1: REGISTROS DE AUDITORÍA
  // =========================================================
  Widget _buildAuditoriaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        _buildSearchBox('Buscar eventos o usuarios...', Icons.fingerprint),

        const SizedBox(height: 15),

        // FILTROS INTERACTIVOS
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterChip(
                label: 'Usuario',
                startIcon: Icons.person_outline,
                isActive: false,
                onTap: () {
                  search_ctrl.text = 'admin';
                },
              ),
              const SizedBox(width: 10),
              _buildFilterChip(
                label: 'Actualizar',
                startIcon: Icons.refresh,
                isActive: false,
                onTap: _cargarDatos,
              ),
              const SizedBox(width: 10),
              _buildFilterChip(
                label: _selectedTipoEvento == 'Todos'
                    ? 'Tipo de evento'
                    : 'Evento: $_selectedTipoEvento',
                startIcon: Icons.filter_list,
                isActive: _selectedTipoEvento != 'Todos',
                onTap: () {
                  const tipos = [
                    'Todos',
                    'LOGIN',
                    'VENTA',
                    'ANULACION',
                    'ERROR',
                  ];
                  final nextIdx =
                      (tipos.indexOf(_selectedTipoEvento) + 1) % tipos.length;
                  setState(() {
                    _selectedTipoEvento = tipos[nextIdx];
                    _currentPage = 1;
                  });
                },
              ),
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
                      'C\$ ${_kpis != null ? _kpis!.ventasDelDia.toStringAsFixed(2) : "0.00"}',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 22,
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
                            'Ticket: C\$ ${_kpis != null ? _kpis!.ticketPromedio.toStringAsFixed(2) : "0.00"}',
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
              '${_filteredLogs.length} registros',
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
        else if (_filteredLogs.isEmpty)
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
                  _searchQuery.isNotEmpty
                      ? 'No se encontraron eventos con "$_searchQuery"'
                      : 'No hay eventos de auditoría registrados',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          )
        else ...[
          Builder(
            builder: (context) {
              final logs = _filteredLogs;
              final totalPages = (logs.length / _itemsPerPage).ceil();
              final safePage =
                  _currentPage.clamp(1, totalPages > 0 ? totalPages : 1);
              final startIndex = (safePage - 1) * _itemsPerPage;
              final endIndex =
                  (startIndex + _itemsPerPage).clamp(0, logs.length);
              final pagedItems = logs.sublist(startIndex, endIndex);

              return Column(
                children: [
                  ...pagedItems.map((log) {
                    final isWarn =
                        log.tipoEvento.toUpperCase() == 'ANULACION' ||
                            log.tipoEvento.toUpperCase() == 'ERROR';
                    final initial = log.usuarioResponsable.isNotEmpty
                        ? log.usuarioResponsable.substring(0, 1).toUpperCase()
                        : 'S';
                    return _buildLogItem(
                      icon: isWarn
                          ? Icons.warning_amber_rounded
                          : Icons.check_circle_outline,
                      iconColor:
                          isWarn ? Colors.red[400]! : Colors.green[400]!,
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
                  }),
                  if (totalPages > 1)
                    PaginationControls(
                      currentPage: safePage,
                      totalPages: totalPages,
                      totalItems: logs.length,
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

        const SizedBox(height: 20),
      ],
    );
  }

  // =========================================================
  // SECCIÓN 2: MÉTRICAS DE RENDIMIENTO API Y MEMORIA (MONGODB)
  // Consume:
  // - GET /api/Metrics/summary
  // - GET /api/Metrics/api-usage
  // - GET /api/Metrics/memory
  // =========================================================
  Widget _buildMetricsSection() {
    return Consumer<MetricsProvider>(
      builder: (context, metricsProvider, _) {
        final summary = metricsProvider.summary;
        final allApiLogs = metricsProvider.apiUsageLogs;
        final allMemLogs = metricsProvider.memoryMetrics;

        final filteredApiLogs = _searchQuery.isEmpty
            ? allApiLogs
            : allApiLogs.where((l) {
                return l.endpoint.toLowerCase().contains(_searchQuery) ||
                    l.method.toLowerCase().contains(_searchQuery) ||
                    l.statusCode.toString().contains(_searchQuery) ||
                    (l.usuario?.toLowerCase().contains(_searchQuery) ?? false);
              }).toList();

        final filteredMemLogs = _searchQuery.isEmpty
            ? allMemLogs
            : allMemLogs.where((m) {
                return m.timestamp.toLowerCase().contains(_searchQuery) ||
                    m.workingSetMb.toStringAsFixed(1).contains(_searchQuery);
              }).toList();

        final avgMs = summary?.averageResponseTimeMs ?? 0.0;
        final totalReqs = summary?.totalRequests ?? allApiLogs.length;
        final errRate = summary?.errorRatePercent ?? 0.0;
        final currentRam = summary?.currentMemoryMb ??
            (allMemLogs.isNotEmpty ? allMemLogs.first.workingSetMb : 0.0);
        final currentCpu = summary?.currentCpuPercent ??
            (allMemLogs.isNotEmpty ? allMemLogs.first.cpuUsagePercent : 0.0);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ENCABEZADO
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'TELEMETRÍA MONGODB • /api/Metrics',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    letterSpacing: 1.1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: () => metricsProvider.loadMetrics(),
                  borderRadius: BorderRadius.circular(8),
                  child: Row(
                    children: [
                      Icon(Icons.sync, color: Colors.brown[700], size: 15),
                      const SizedBox(width: 4),
                      Text(
                        'Sincronizar',
                        style: TextStyle(
                          color: Colors.brown[700],
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            const Text(
              'Métricas de Servidor',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 4),
            Text(
              'Tiempos de respuesta de la API y consumo de memoria/CPU en MongoDB',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),

            const SizedBox(height: 20),

            // BUSCADOR DE MÉTRICAS
            _buildSearchBox(
              _metricsSubTab == 0
                  ? 'Buscar por endpoint, método (GET/POST) o código...'
                  : 'Buscar registros de memoria por fecha o MB...',
              Icons.analytics_outlined,
            ),

            const SizedBox(height: 20),

            if (metricsProvider.isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(36.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else ...[
              if (metricsProvider.errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.amber.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline,
                            color: Colors.amber.shade900, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            metricsProvider.errorMessage,
                            style: TextStyle(
                              color: Colors.amber.shade900,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // TARJETAS DE RESUMEN CONSOLIDADO (/api/Metrics/summary)
              Row(
                children: [
                  // Tarjeta oscura: Rendimiento API
                  Expanded(
                    flex: 5,
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFF38231c),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Latencia Media API',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                              Icon(Icons.bolt, color: Colors.amberAccent, size: 18),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${avgMs.toStringAsFixed(1)} ms',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '$totalReqs peticiones • ${errRate.toStringAsFixed(1)}% error',
                            style: TextStyle(
                              color: Colors.grey[300],
                              fontSize: 11,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Tarjeta clara: Memoria y CPU
                  Expanded(
                    flex: 5,
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Memoria / CPU',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                              Icon(Icons.memory,
                                  color: Colors.brown[600], size: 18),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${currentRam.toStringAsFixed(1)} MB',
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'CPU: ${currentCpu.toStringAsFixed(1)}% • ${allMemLogs.length} muestras',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 11,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              // SELECTOR DE COLECCIÓN MONGODB: apiUsageLogs vs memoryMetrics
              Row(
                children: [
                  Expanded(
                    child: _buildSubTabButton(
                      index: 0,
                      icon: Icons.swap_vert_circle_outlined,
                      label: 'Uso de API (${filteredApiLogs.length})',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildSubTabButton(
                      index: 1,
                      icon: Icons.developer_board_outlined,
                      label: 'Memoria y CPU (${filteredMemLogs.length})',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              if (_metricsSubTab == 0)
                _buildApiUsageList(filteredApiLogs)
              else
                _buildMemoryMetricsList(filteredMemLogs),
            ],
          ],
        );
      },
    );
  }

  Widget _buildSubTabButton({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _metricsSubTab == index;
    return GestureDetector(
      onTap: () => setState(() {
        _metricsSubTab = index;
        _currentPage = 1;
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2E221E) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isSelected ? const Color(0xFF2E221E) : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : const Color(0xFF2E221E),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : const Color(0xFF2E221E),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Lista paginada para /api/Metrics/api-usage
  Widget _buildApiUsageList(List<ApiUsageLogModel> logs) {
    if (logs.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(Icons.cloud_off_outlined, size: 40, color: Colors.grey[400]),
            const SizedBox(height: 10),
            Text(
              'No hay registros de uso de API disponibles',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
      );
    }

    final totalPages = (logs.length / _itemsPerPage).ceil();
    final safePage = _currentPage.clamp(1, totalPages > 0 ? totalPages : 1);
    final startIndex = (safePage - 1) * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage).clamp(0, logs.length);
    final pagedItems = logs.sublist(startIndex, endIndex);

    return Column(
      children: [
        ...pagedItems.map(_buildApiUsageCard),
        if (totalPages > 1)
          PaginationControls(
            currentPage: safePage,
            totalPages: totalPages,
            totalItems: logs.length,
            itemsPerPage: _itemsPerPage,
            onPageChanged: (newPage) {
              setState(() => _currentPage = newPage);
            },
          ),
      ],
    );
  }

  Widget _buildApiUsageCard(ApiUsageLogModel item) {
    final isError = item.statusCode >= 400;
    final isSlow = item.responseTimeMs > 800;

    Color methodColor;
    switch (item.method) {
      case 'POST':
        methodColor = Colors.blue.shade700;
        break;
      case 'PUT':
      case 'PATCH':
        methodColor = Colors.orange.shade800;
        break;
      case 'DELETE':
        methodColor = Colors.red.shade700;
        break;
      default:
        methodColor = Colors.green.shade700;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: methodColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              item.method,
              style: TextStyle(
                color: methodColor,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.endpoint,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Color(0xFF2E221E),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTimestamp(item.timestamp),
                  style: TextStyle(color: Colors.grey[500], fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${item.responseTimeMs.toStringAsFixed(1)} ms',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: isSlow ? Colors.orange.shade800 : Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isError ? Colors.red.shade50 : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'HTTP ${item.statusCode}',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color:
                        isError ? Colors.red.shade700 : Colors.green.shade700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Lista paginada para /api/Metrics/memory
  Widget _buildMemoryMetricsList(List<MemoryMetricModel> metrics) {
    if (metrics.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(Icons.memory_outlined, size: 40, color: Colors.grey[400]),
            const SizedBox(height: 10),
            Text(
              'No hay registros de memoria/CPU disponibles',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
      );
    }

    final totalPages = (metrics.length / _itemsPerPage).ceil();
    final safePage = _currentPage.clamp(1, totalPages > 0 ? totalPages : 1);
    final startIndex = (safePage - 1) * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage).clamp(0, metrics.length);
    final pagedItems = metrics.sublist(startIndex, endIndex);

    return Column(
      children: [
        ...pagedItems.map(_buildMemoryCard),
        if (totalPages > 1)
          PaginationControls(
            currentPage: safePage,
            totalPages: totalPages,
            totalItems: metrics.length,
            itemsPerPage: _itemsPerPage,
            onPageChanged: (newPage) {
              setState(() => _currentPage = newPage);
            },
          ),
      ],
    );
  }

  Widget _buildMemoryCard(MemoryMetricModel m) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF5EBE6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.memory_rounded,
              color: Color(0xFF8A6D5C),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'RAM: ${m.workingSetMb.toStringAsFixed(1)} MB',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF2E221E),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'GC: ${m.gcTotalMemoryMb.toStringAsFixed(1)} MB • Privada: ${m.privateMemoryMb.toStringAsFixed(1)} MB',
                  style: TextStyle(color: Colors.grey[600], fontSize: 11),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatTimestamp(m.timestamp),
                  style: TextStyle(color: Colors.grey[500], fontSize: 11),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFEBF5EE),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'CPU ${m.cpuUsagePercent.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    color: Color(0xFF427A59),
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
              if (m.threadCount > 0) ...[
                const SizedBox(height: 4),
                Text(
                  '${m.threadCount} hilos',
                  style: TextStyle(color: Colors.grey[500], fontSize: 11),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBox(String hint, IconData suffixIcon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextFormField(
        controller: search_ctrl,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black38, fontSize: 13),
          prefixIcon: const Icon(Icons.search, color: Colors.black38),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.black38),
                  onPressed: () => search_ctrl.clear(),
                )
              : Icon(suffixIcon, color: Colors.black38),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  // Los filtros con icono que vimos en la maqueta
  Widget _buildFilterChip({
    required String label,
    required IconData startIcon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF38231c) : Colors.white,
          border: Border.all(
            color: isActive ? const Color(0xFF38231c) : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              startIcon,
              size: 14,
              color: isActive ? Colors.white : Colors.black54,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: isActive ? Colors.white : Colors.black87,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            const SizedBox(width: 6),
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

  // Fila para los logs de auditoria
  Widget _buildLogItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String userInitials,
    required String userName,
    required String time,
    required bool isAlert,
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
            height: 100,
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
