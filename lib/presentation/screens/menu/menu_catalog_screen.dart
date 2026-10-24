import 'package:flutter/material.dart';
import '../../../core/di/injection.dart';
import '../../../services/platillo_service.dart';
import '../../../services/categoria_service.dart';

class MenuCatalogScreen extends StatefulWidget {
  const MenuCatalogScreen({Key? key}) : super(key: key);

  @override
  State<MenuCatalogScreen> createState() => _MenuCatalogScreenState();
}

class _MenuCatalogScreenState extends State<MenuCatalogScreen> {
  int _selectedCategoryIndex = 0;
  int _currentBottomIndex = 1; // 1 corresponde a Catálogo (activo)

  bool _isLoading = false;

  final List<String> _categories = [
    'Platos Fuertes',
    'Entradas',
    'Bebidas',
    'Postres'
  ];

  @override
  void initState() {
    super.initState();
    _cargarMenu();
  }

  Future<void> _cargarMenu() async {
    setState(() => _isLoading = true);
    try {
      final platillosFuture = sl<PlatilloService>().getPlatillos();
      final categoriasFuture = sl<CategoriaService>().getCategorias();
      final results = await Future.wait([platillosFuture, categoriasFuture]);

      final platillos = results[0] as List;
      final categorias = results[1] as List;

      if (mounted) {
        setState(() {
          if (categorias.isNotEmpty) {
            _categories.clear();
            for (final c in categorias) {
              if (c.activo) _categories.add(c.nombre);
            }
            if (_categories.isEmpty) {
              _categories.addAll(['Platos Fuertes', 'Entradas', 'Bebidas', 'Postres']);
            }
          }
          if (platillos.isNotEmpty) {
            _dishes.clear();
            for (final p in platillos) {
              // imageUrl: URL/Base64 de la API; image: fallback asset local
              _dishes.add({
                'title': p.nombre,
                'description': p.descripcion.isNotEmpty
                    ? p.descripcion
                    : 'Delicioso platillo tradicional',
                'price': 'C\$ ${p.precio.toStringAsFixed(2)}',
                'imageUrl': p.imagenUrl ?? '',
                'image': 'assets/images/Carne Asada.jpg',
                'categoria': p.categoriaNombre ?? '',
              });
            }
          }
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

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
              const SizedBox(height: 16),
              _buildSearchField(),
              const SizedBox(height: 16),
              _buildCategoryChips(),
              const SizedBox(height: 20),
              _buildSectionSubtitle(),
              const SizedBox(height: 12),
              _buildDishList(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // 1. Top Bar superior
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

  // 2. Cabecera de sección
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

  // 3. Buscador dinámico
  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Buscar platillos, bebidas e ingredientes...',
          hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: IconButton(
            icon: const Icon(Icons.qr_code_scanner_rounded, color: Colors.grey),
            onPressed: () {},
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
        ),
      ),
    );
  }

  // 4. Pestañas de categorías
  Widget _buildCategoryChips() {
    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedCategoryIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategoryIndex = index;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF2E221E) : Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF2E221E) : Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  _categories[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF2E221E),
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // 5. Subtítulo de sección de listado
  Widget _buildSectionSubtitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'SELECCIÓN DEL DÍA / ${_categories[_selectedCategoryIndex]}',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        Text(
          '${_dishes.length} productos',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  // 6. Tarjetas de Platillos con Image.asset
  Widget _buildDishList() {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: CircularProgressIndicator(),
        ),
      );
    }
    return ListView.builder(
      itemCount: _dishes.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final dish = _dishes[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12.0),
          padding: const EdgeInsets.all(12.0),
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
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: _buildDishImage(dish),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dish['title']!,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E221E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dish['description']!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      dish['price']!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E221E),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F0EE),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Color(0xFF2E221E), size: 20),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Construye la imagen del platillo: usa URL de la API si existe, si no usa asset local
  Widget _buildDishImage(Map<String, String> dish) {
    final imageUrl = dish['imageUrl'] ?? '';
    const double size = 70;

    if (imageUrl.isNotEmpty && imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        loadingBuilder: (ctx, child, progress) {
          if (progress == null) return child;
          return Container(
            width: size,
            height: size,
            color: Colors.grey.shade100,
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        },
        errorBuilder: (ctx, err, st) => _imagePlaceholder(size),
      );
    }

    // Fallback: asset local
    return Image.asset(
      dish['image'] ?? 'assets/images/Carne Asada.jpg',
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (ctx, err, st) => _imagePlaceholder(size),
    );
  }

  Widget _imagePlaceholder(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.restaurant, color: Colors.grey, size: 30),
    );
  }
}