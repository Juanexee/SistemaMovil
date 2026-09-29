
import 'package:flutter/material.dart';

class MenuCatalogScreen extends StatefulWidget {
  const MenuCatalogScreen({Key? key}) : super(key: key);

  @override
  State<MenuCatalogScreen> createState() => _MenuCatalogScreenState();
}

class _MenuCatalogScreenState extends State<MenuCatalogScreen> {
  int _selectedCategoryIndex = 0;
  int _currentBottomIndex = 1; // 1 corresponde a Catálogo (activo)

  final List<String> _categories = [
    'Platos Fuertes',
    'Entradas',
    'Bebidas',
    'Postres'
  ];

  // Lista actualizada apuntando a las rutas locales en assets/images/
  final List<Map<String, String>> _dishes = [
    {
      'title': 'Carne Asada Especial',
      'description': 'Incluye yuca, chicharrón, ensalada y gallo pinto',
      'price': 'C\$ 240.00',
      'image': 'assets/images/Carne Asada.jpg',
    },
    {
      'title': 'Vigorón Tradicional',
      'description': 'Yuca suave, chicharrón y ensalada de repollo fresca',
      'price': 'C\$ 180.00',
      'image': 'assets/images/Vigoron Tradicional.jpg',
    },
    {
      'title': 'Pollo a la Plancha',
      'description': 'Pechuga marinada con vegetales salteados del día',
      'price': 'C\$ 195.00',
      'image': 'assets/images/pollo a la plancha.jpg',
    },
  ];

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
            ],
          ),
        ),
      ),
    );
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
                color: const Color(0xFF2E221E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/mimi2.png',
                    width: 42,
                    height: 42,
                    fit: BoxFit.cover,
                  ),
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
            const SizedBox(width: 16),
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

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'TOMA DE COMANDAS',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Catálogo de Platillos',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E221E),
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Selecciona los productos para agregar a la orden de la mesa',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}