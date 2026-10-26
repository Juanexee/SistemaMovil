import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/di/injection.dart';
import '../../../services/platillo_service.dart';
import '../../../services/categoria_service.dart';
import '../../../services/order_cart_manager.dart';
import '../order/order_card_screen.dart';

class MenuCatalogScreen extends StatefulWidget {
  const MenuCatalogScreen({super.key});

  @override
  State<MenuCatalogScreen> createState() => _MenuCatalogScreenState();
}

class _MenuCatalogScreenState extends State<MenuCatalogScreen> {
  int _selectedCategoryIndex = 0;
  bool _isLoading = false;
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';

  final List<String> _categories = [
    'Todas',
    'Platos Fuertes',
    'Entradas',
    'Bebidas',
    'Postres',
  ];

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() {
      setState(() => _searchQuery = _searchCtrl.text.toLowerCase().trim());
    });
    _cargarMenu();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
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
            _categories.add('Todas');
            for (final c in categorias) {
              if (c.activo) _categories.add(c.nombre);
            }
          }
          if (platillos.isNotEmpty) {
            _dishes.clear();
            for (final p in platillos) {
              _dishes.add({
                'id': p.id.toString(),
                'title': p.nombre,
                'description': p.descripcion.isNotEmpty
                    ? p.descripcion
                    : 'Delicioso platillo tradicional',
                'price': 'C\$ ${p.precio.toStringAsFixed(2)}',
                'rawPrice': p.precio.toString(),
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

  // Lista con datos de fallback si la API no está disponible
  final List<Map<String, String>> _dishes = [
    {
      'id': '1',
      'title': 'Carne Asada Especial',
      'description': 'Incluye yuca, chicharrón, ensalada y gallo pinto',
      'price': 'C\$ 240.00',
      'rawPrice': '240.0',
      'image': 'assets/images/Carne Asada.jpg',
      'imageUrl': '',
      'categoria': 'Platos Fuertes',
    },
    {
      'id': '2',
      'title': 'Vigorón Tradicional',
      'description': 'Yuca suave, chicharrón y ensalada de repollo fresca',
      'price': 'C\$ 180.00',
      'rawPrice': '180.0',
      'image': 'assets/images/Vigoron Tradicional.jpg',
      'imageUrl': '',
      'categoria': 'Entradas',
    },
    {
      'id': '3',
      'title': 'Pollo a la Plancha',
      'description': 'Pechuga marinada con vegetales salteados del día',
      'price': 'C\$ 195.00',
      'rawPrice': '195.0',
      'image': 'assets/images/pollo a la plancha.jpg',
      'imageUrl': '',
      'categoria': 'Platos Fuertes',
    },
  ];

  List<Map<String, String>> get _filteredDishes {
    return _dishes.where((dish) {
      if (_selectedCategoryIndex > 0 &&
          _selectedCategoryIndex < _categories.length) {
        final catSeleccionada =
            _categories[_selectedCategoryIndex].toLowerCase();
        final dishCat = (dish['categoria'] ?? '').toLowerCase();
        if (dishCat.isNotEmpty &&
            !dishCat.contains(catSeleccionada) &&
            !catSeleccionada.contains(dishCat)) {
          return false;
        }
      }

      if (_searchQuery.isNotEmpty) {
        final title = (dish['title'] ?? '').toLowerCase();
        final desc = (dish['description'] ?? '').toLowerCase();
        if (!title.contains(_searchQuery) && !desc.contains(_searchQuery)) {
          return false;
        }
      }

      return true;
    }).toList();
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
    return ListenableBuilder(
      listenable: OrderCartManager(),
      builder: (context, _) {
        final count = OrderCartManager().totalCount;
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
                const SizedBox(width: 6),
                const Text(
                  'En línea',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(width: 16),
                // Botón de Comanda / Carrito con Badge
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OrderCartScreen()),
                    );
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F0EE),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: const Icon(
                          Icons.shopping_cart_outlined,
                          color: Color(0xFF2E221E),
                          size: 22,
                        ),
                      ),
                      if (count > 0)
                        Positioned(
                          right: -2,
                          top: -2,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.redAccent,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 18,
                              minHeight: 18,
                            ),
                            child: Center(
                              child: Text(
                                '$count',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
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
        controller: _searchCtrl,
        decoration: InputDecoration(
          hintText: 'Buscar platillos, bebidas e ingredientes...',
          hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () => _searchCtrl.clear(),
                )
              : null,
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
                    color: isSelected
                        ? const Color(0xFF2E221E)
                        : Colors.grey.shade300,
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
    final list = _filteredDishes;
    final catNombre = _selectedCategoryIndex < _categories.length
        ? _categories[_selectedCategoryIndex]
        : 'General';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'SELECCIÓN / $catNombre',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        Text(
          '${list.length} productos',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  // 6. Tarjetas de Platillos
  Widget _buildDishList() {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    final dishes = _filteredDishes;

    if (dishes.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Icon(Icons.restaurant_menu, size: 48, color: Colors.grey.shade400),
              const SizedBox(height: 10),
              Text(
                'No se encontraron platillos',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: dishes.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final dish = dishes[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12.0),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
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
              // Botón de más para agregar a la orden
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F0EE),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.add,
                      color: Color(0xFF2E221E), size: 20),
                  onPressed: () {
                    final title = dish['title'] ?? 'Platillo';
                    final rawPrice = dish['rawPrice'] ?? '0';
                    final price = double.tryParse(rawPrice) ??
                        double.tryParse((dish['price'] ?? '')
                            .replaceAll(RegExp(r'[^0-9.]'), '')) ??
                        0.0;
                    final id = int.tryParse(dish['id'] ?? '0');

                    OrderCartManager().addItem(
                      id: id,
                      title: title,
                      price: price,
                    );

                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(Icons.check_circle,
                                color: Colors.greenAccent, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '$title agregado a la comanda',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        backgroundColor: const Color(0xFF38231C),
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                        action: SnackBarAction(
                          label: 'Ver orden',
                          textColor: Colors.amberAccent,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const OrderCartScreen()),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Construye la imagen del platillo admitiendo Base64, URL absoluta, URL relativa y fallbacks locales acordes al platillo
  Widget _buildDishImage(Map<String, String> dish) {
    final imageUrl = (dish['imageUrl'] ?? '').trim();
    const double size = 70;

    // 1. Imagen en formato Base64 (común en APIs que devuelven strings en base64)
    if (imageUrl.startsWith('data:image') ||
        (!imageUrl.startsWith('http') &&
            imageUrl.length > 80 &&
            !imageUrl.contains('/'))) {
      try {
        final base64String =
            imageUrl.contains(',') ? imageUrl.split(',').last : imageUrl;
        final bytes = base64Decode(base64String);
        return Image.memory(
          bytes,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (ctx, err, st) => _fallbackAssetImage(dish, size),
        );
      } catch (_) {}
    }

    // 2. URL Absoluta (http o https)
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
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
        errorBuilder: (ctx, err, st) => _fallbackAssetImage(dish, size),
      );
    }

    // 3. URL Relativa devuelta por la API (ejemplo: /uploads/platillos/1.jpg)
    if (imageUrl.contains('/') && !imageUrl.startsWith('http')) {
      final fullUrl =
          '${ApiConstants.baseUrl}${imageUrl.startsWith('/') ? '' : '/'}$imageUrl';
      return Image.network(
        fullUrl,
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
        errorBuilder: (ctx, err, st) => _fallbackAssetImage(dish, size),
      );
    }

    // 4. Si la API no tiene imagen o falló la carga, usamos el asset local acorde al platillo
    return _fallbackAssetImage(dish, size);
  }

  // Mapeo inteligente al asset local según el nombre del platillo
  Widget _fallbackAssetImage(Map<String, String> dish, double size) {
    final title = (dish['title'] ?? '').toLowerCase();

    String assetPath = 'assets/images/Carne Asada.jpg';
    if (title.contains('vigor') ||
        title.contains('chicharr') ||
        title.contains('yuca')) {
      assetPath = 'assets/images/Vigoron Tradicional.jpg';
    } else if (title.contains('pollo') ||
        title.contains('pechuga') ||
        title.contains('alita') ||
        title.contains('plancha')) {
      assetPath = 'assets/images/pollo a la plancha.jpg';
    } else if (title.contains('carne') ||
        title.contains('asada') ||
        title.contains('res') ||
        title.contains('lomo')) {
      assetPath = 'assets/images/Carne Asada.jpg';
    } else {
      // Para platillos no emparejados (ej. bebidas, postres), un icono elegante
      return _imagePlaceholder(size);
    }

    return Image.asset(
      assetPath,
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