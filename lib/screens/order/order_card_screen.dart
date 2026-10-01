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
      home: const OrderCartScreen(),
    );
  }
}

class OrderCartScreen extends StatefulWidget {
  const OrderCartScreen({Key? key}) : super(key: key);

  @override
  State<OrderCartScreen> createState() => _OrderCartScreenState();
}

class _OrderCartScreenState extends State<OrderCartScreen> {
  int _currentBottomIndex = 2; // 2 corresponde a Órdenes / Comanda (activo)


  final List<Map<String, dynamic>> _cartItems = [
    {
      'title': 'Carne Asada Especial',
      'note': 'Sin cebolla, término medio',
      'pricePerUnit': 240.0,
      'quantity': 1,
    },
    {
      'title': 'Tacos de Pollo',
      'note': 'Con guacamole y crema',
      'pricePerUnit': 320.0,
      'quantity': 2,
    },
    {
      'title': 'Limonada Natural',
      'note': 'Sin azúcar',
      'pricePerUnit': 90.0,
      'quantity': 2,
    },
  ];

  double get _subtotal {
    return _cartItems.fold(
        0.0, (sum, item) => sum + (item['pricePerUnit'] * item['quantity']));
  }

  double get _tax => _subtotal * 0.15; // IVA estimado 15%
  double get _totalGeneral => _subtotal + _tax;

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
              const SizedBox(height: 12),
              _buildOfflineBanner(),
              const SizedBox(height: 16),
              _buildTableHeaderSection(),
              const SizedBox(height: 16),
              _buildCartItemList(),
              const SizedBox(height: 16),
              _buildFinancialSummaryCard(),
              const SizedBox(height: 20),
              _buildSubmitButton(),
              const SizedBox(height: 30),
            ],
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
              'Online',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(width: 12),
            const Icon(
              Icons.notifications_none_rounded,
              color: Color(0xFF2E221E),
              size: 26,
            ),
          ],
        ),
      ],
    );
  }

  // 2. Banner superior de estado Offline-First
  Widget _buildOfflineBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFEBF5EE),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: const Color(0xFFD4EDDA)),
      ),
      child: Row(
        children: const [
          Icon(Icons.cloud_done_rounded, color: Color(0xFF28A745), size: 18),
          SizedBox(width: 8),
          Text(
            'Conectado a la API. Todo sincronizado',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF155724),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  
  Widget _buildTableHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'RESUMEN DE COMANDA',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Mesa 04',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E221E),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F0EE),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2E221E),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        'CR',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Atiende: Carlos R.',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E221E),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  
  Widget _buildCartItemList() {
    return ListView.builder(
      itemCount: _cartItems.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final item = _cartItems[index];
        final double itemTotal = item['pricePerUnit'] * item['quantity'];

        return Container(
          margin: const EdgeInsets.only(bottom: 12.0),
          padding: const EdgeInsets.all(14.0),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item['title'],
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E221E),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded,
                        color: Colors.grey, size: 20),
                    onPressed: () {
                      setState(() {
                        _cartItems.removeAt(index);
                      });
                    },
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                item['note'],
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove, size: 16),
                          color: const Color(0xFF2E221E),
                          onPressed: () {
                            setState(() {
                              if (item['quantity'] > 1) {
                                item['quantity']--;
                              }
                            });
                          },
                          constraints: const BoxConstraints(
                              minWidth: 32, minHeight: 32),
                          padding: EdgeInsets.zero,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            '${item['quantity']}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E221E),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add, size: 16),
                          color: const Color(0xFF2E221E),
                          onPressed: () {
                            setState(() {
                              item['quantity']++;
                            });
                          },
                          constraints: const BoxConstraints(
                              minWidth: 32, minHeight: 32),
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'C\$ ${itemTotal.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E221E),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // 5. Tarjeta de Resumen Financiero
  Widget _buildFinancialSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Subtotal',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              Text(
                'C\$ ${_subtotal.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2E221E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'IVA estimado 15%',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              Text(
                'C\$ ${_tax.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2E221E),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Divider(height: 1, color: Colors.black12),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total general',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E221E),
                ),
              ),
              Text(
                'C\$ ${_totalGeneral.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E221E),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 6. Botón principal de acción inferior
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2E221E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0,
        ),
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.send_rounded, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text(
              'Enviar comanda a cocina',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 7. Barra de navegación inferior
  Widget _buildBottomNavigationBar() {
    return Container(
      height: 68,
      decoration: const BoxDecoration(
        color: Color(0xFF231B18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_outlined, 'Inicio', 0),
          _buildNavItem(Icons.grid_view_rounded, 'Catálogo', 1),
          _buildNavItem(Icons.receipt_long_outlined, 'Órdenes', 2),
          _buildNavItem(Icons.settings_outlined, 'Ajustes', 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isActive = _currentBottomIndex == index;
    final color = isActive ? Colors.white : Colors.white54;

    return InkWell(
      onTap: () {
        setState(() {
          _currentBottomIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: 22,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}