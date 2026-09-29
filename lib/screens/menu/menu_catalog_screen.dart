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
    return const Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: Center(
        child: Text('Estructura base lista'),
      ),
    );
  }
}