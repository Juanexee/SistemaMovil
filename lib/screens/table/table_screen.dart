import 'package:flutter/material.dart';

void main() {
  runApp(const ElRanchoLaMimiApp());
}

class ElRanchoLaMimiApp extends StatelessWidget {
  const ElRanchoLaMimiApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'El Rancho La Mimi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        fontFamily: 'Roboto',
      ),
      home: const TableManagementScreen(),
    );
  }
}
class TableManagementScreen extends StatefulWidget {
  const TableManagementScreen({Key? key}) : super(key: key);

  @override
  State<TableManagementScreen> createState() => _TableManagementScreenState();
}

class _TableManagementScreenState extends State<TableManagementScreen> {
  int _selectedFilterIndex = 0;
  int _currentBottomIndex = 1; // 1 corresponde a "Catálogo" (activo)

  final List<String> _filters = ['Todas', 'Libre', 'Ocupada', 'Por cobrar'];

  // Datos de ejemplo para las mesas
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
    return _tables.where((table) => table['type'] == selectedFilterText).toList();
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
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
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
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
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
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                    Icon(Icons.people_outline_rounded, color: Colors.white70, size: 20),
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
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white60,
                      ),
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
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    Icon(Icons.check_circle_outline_rounded, color: Colors.green, size: 20),
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