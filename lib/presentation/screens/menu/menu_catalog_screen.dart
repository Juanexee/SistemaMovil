import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/di/injection.dart';
import '../../../core/utils/number_formatter.dart';
import '../../../services/platillo_service.dart';
import '../../../services/categoria_service.dart';
import '../../../services/mesas_service.dart';
import '../../../services/order_cart_manager.dart';
import '../../../data/models/platillo_model.dart';
import '../../../data/models/categoria_model.dart';
import '../order/order_card_screen.dart';

class MenuCatalogScreen extends StatefulWidget {
  final Map<String, dynamic>? initialMesa;
  const MenuCatalogScreen({super.key, this.initialMesa});

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
    if (widget.initialMesa != null) {
      OrderCartManager().setActiveMesa(widget.initialMesa, notify: false);
    }
    _searchCtrl.addListener(() {
      setState(() => _searchQuery = _searchCtrl.text.toLowerCase().trim());
    });
    _cargarMenu();
    _sincronizarMesas();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _sincronizarMesas() async {
    try {
      final lista = await sl<MesasService>().getMesas();
      if (lista.isNotEmpty) {
        final mapped = lista.map((m) {
          final isLibre = m.estado.toLowerCase() == 'disponible' ||
              m.estado.toLowerCase() == 'libre';
          final isOcupada = m.estado.toLowerCase() == 'ocupada';
          final status = isLibre ? 'Libre' : (isOcupada ? 'Ocupada' : m.estado);
          final count = OrderCartManager().countForMesa(m.id);
          final sub = OrderCartManager().subtotalForMesa(m.id);

          return <String, dynamic>{
            'id': m.id,
            'numero': m.numero,
            'name': 'Mesa ${m.numero.toString().padLeft(2, '0')}',
            'status': count > 0 ? 'Ocupada' : status,
            'capacidad': m.capacidad,
            'detail': count > 0
                ? '$count platillo${count == 1 ? '' : 's'} • ${NumberFormatter.currency(sub)}'
                : 'Capacidad: ${m.capacidad} personas',
            'waiterInitials': 'MR',
            'waiterName': 'Mesero',
            'type': count > 0 ? 'Ocupada' : status,
          };
        }).toList();
        OrderCartManager().setAvailableTables(mapped, notify: true);
      }
    } catch (_) {}
  }

  Future<void> _cargarMenu() async {
    setState(() => _isLoading = true);
    try {
      final platillosFuture = sl<PlatilloService>().getPlatillos();
      final categoriasFuture = sl<CategoriaService>().getCategorias();
      final results = await Future.wait([platillosFuture, categoriasFuture]);

      final platillos = results[0] as List<PlatilloModel>;
      final categorias = results[1] as List<CategoriaModel>;

      final Map<int, String> catMap = {
        for (final c in categorias) c.id: c.nombre,
      };

      if (mounted) {
        setState(() {
          if (categorias.isNotEmpty) {
            _categories.clear();
            _categories.add('Todas');
            for (final c in categorias) {
              if (c.activo && !_categories.contains(c.nombre)) {
                _categories.add(c.nombre);
              }
            }
          }
          if (platillos.isNotEmpty) {
            _dishes.clear();
            for (final p in platillos) {
              if (!p.disponible) continue;
              final resolvedCat = (p.categoriaNombre != null &&
                      p.categoriaNombre!.trim().isNotEmpty)
                  ? p.categoriaNombre!.trim()
                  : (catMap[p.categoriaId] ?? '');
              _dishes.add({
                'id': p.id.toString(),
                'title': p.nombre,
                'description': p.descripcion.isNotEmpty
                    ? p.descripcion
                    : 'Delicioso platillo tradicional',
                'price': NumberFormatter.currency(p.precio),
                'rawPrice': p.precio.toString(),
                'imageUrl': p.imagenUrl ?? '',
                'image': 'assets/images/Carne Asada.jpg',
                'categoria': resolvedCat,
              });
            }
          }
          if (_selectedCategoryIndex >= _categories.length) {
            _selectedCategoryIndex = 0;
          }
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

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
            _categories[_selectedCategoryIndex].toLowerCase().trim();
        final dishCat = (dish['categoria'] ?? '').toLowerCase().trim();
        if (dishCat.isEmpty ||
            (!dishCat.contains(catSeleccionada) &&
                !catSeleccionada.contains(dishCat))) {
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
              const SizedBox(height: 16),
              _buildActiveMesaBanner(),
              const SizedBox(height: 16),
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
        final canPop = Navigator.canPop(context);
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (canPop) ...[
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 4),
                ],
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
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderCartScreen(
                          mesa: OrderCartManager().activeMesa,
                        ),
                      ),
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

  // Banner informativo de la mesa activa actual
  Widget _buildActiveMesaBanner() {
    return ListenableBuilder(
      listenable: OrderCartManager(),
      builder: (context, _) {
        final activeMesa = OrderCartManager().activeMesa;
        final mesaName = activeMesa?['name'] ?? 'Mesa 01';
        final mesaId = OrderCartManager.resolveMesaKey(activeMesa);
        final count = OrderCartManager().countForMesa(mesaId);
        final sub = OrderCartManager().subtotalForMesa(mesaId);

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F0EE),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.brown.shade200),
          ),
          child: Row(
            children: [
              const Icon(Icons.table_restaurant_rounded,
                  color: Color(0xFF38231C), size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mesa seleccionada: $mesaName',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Color(0xFF2E221E),
                      ),
                    ),
                    Text(
                      count > 0
                          ? '$count platillo${count == 1 ? '' : 's'} en esta mesa • ${NumberFormatter.currency(sub)}'
                          : 'Toca + en cualquier platillo para elegir la mesa destino',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.brown.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrderCartScreen(mesa: activeMesa),
                    ),
                  );
                },
                icon: const Icon(Icons.receipt_long,
                    size: 16, color: Color(0xFF38231C)),
                label: const Text(
                  'Ver mesa',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF38231C),
                  ),
                ),
              ),
            ],
          ),
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
          'Toca el botón + para elegir a qué mesa enviar el platillo',
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
              Icon(Icons.restaurant_menu,
                  size: 48, color: Colors.grey.shade400),
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
              // Botón + que abre el modal preguntando a qué mesa va dirigido el platillo
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF38231C),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.white, size: 20),
                  onPressed: () => _mostrarModalSeleccionMesa(context, dish),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Modal que pregunta a qué mesa va dirigido el platillo, cantidad y nota especial
  void _mostrarModalSeleccionMesa(
      BuildContext parentContext, Map<String, String> dish) {
    final title = dish['title'] ?? 'Platillo';
    final rawPrice = dish['rawPrice'] ?? '0';
    final price = double.tryParse(rawPrice) ??
        double.tryParse(
            (dish['price'] ?? '').replaceAll(RegExp(r'[^0-9.]'), '')) ??
        0.0;
    final dishId = int.tryParse(dish['id'] ?? '0');

    final tables = OrderCartManager().availableTables;
    Map<String, dynamic> selectedMesa = OrderCartManager().activeMesa ??
        (tables.isNotEmpty
            ? tables.first
            : {
                'id': 1,
                'numero': 1,
                'name': 'Mesa 01',
                'status': 'Libre',
                'capacidad': 4,
              });
    int selectedMesaId = OrderCartManager.resolveMesaKey(selectedMesa);
    int quantity = 1;
    final noteCtrl = TextEditingController();

    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalCtx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final totalItem = price * quantity;
            final mesaNombre = selectedMesa['name'] ?? 'Mesa 01';

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Barra superior del modal
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Encabezado del platillo
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: _buildDishImage(dish),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'AGREGAR A COMANDA',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  title,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2E221E),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${NumberFormatter.currency(price)} c/u',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFa67c52),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const Divider(height: 28),

                      // Pregunta principal: Selección de mesa
                      const Text(
                        '¿A qué mesa va dirigido este platillo?',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E221E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Selecciona la mesa donde se registrará en su comanda:',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 12),

                      // Cuadrícula de mesas
                      GridView.builder(
                        itemCount: tables.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 1.45,
                        ),
                        itemBuilder: (ctx, i) {
                          final t = tables[i];
                          final tId = OrderCartManager.resolveMesaKey(t);
                          final isSelected = tId == selectedMesaId;
                          final dishCount =
                              OrderCartManager().countForMesa(tId);
                          final status =
                              dishCount > 0 ? 'Ocupada' : (t['status'] ?? 'Libre');

                          return InkWell(
                            onTap: () {
                              setModalState(() {
                                selectedMesa = t;
                                selectedMesaId = tId;
                              });
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF38231C)
                                    : const Color(0xFFF8F9FA),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF38231C)
                                      : Colors.grey.shade300,
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.table_restaurant_rounded,
                                        size: 15,
                                        color: isSelected
                                            ? Colors.white
                                            : const Color(0xFF2E221E),
                                      ),
                                      const SizedBox(width: 4),
                                      Flexible(
                                        child: Text(
                                          t['name'] ?? 'Mesa $tId',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: isSelected
                                                ? Colors.white
                                                : const Color(0xFF2E221E),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    dishCount > 0
                                        ? '$dishCount platillo${dishCount == 1 ? '' : 's'}'
                                        : status.toString(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: isSelected
                                          ? Colors.amberAccent
                                          : (dishCount > 0
                                              ? Colors.orange.shade800
                                              : Colors.green.shade700),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      // Selector de cantidad + Nota opcional
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Cantidad de porciones:',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2E221E),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F9FA),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove, size: 18),
                                  onPressed: quantity > 1
                                      ? () => setModalState(() => quantity--)
                                      : null,
                                  constraints: const BoxConstraints(
                                      minWidth: 36, minHeight: 36),
                                  padding: EdgeInsets.zero,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Text(
                                    '$quantity',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2E221E),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add, size: 18),
                                  onPressed: () =>
                                      setModalState(() => quantity++),
                                  constraints: const BoxConstraints(
                                      minWidth: 36, minHeight: 36),
                                  padding: EdgeInsets.zero,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      TextField(
                        controller: noteCtrl,
                        decoration: InputDecoration(
                          hintText:
                              'Nota opcional (ej. sin cebolla, término medio)...',
                          hintStyle:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                          prefixIcon: const Icon(Icons.edit_note_rounded,
                              color: Colors.grey),
                          filled: true,
                          fillColor: const Color(0xFFF8F9FA),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Botón confirmar envío a la mesa seleccionada
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF38231C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          icon: const Icon(Icons.add_task_rounded,
                              color: Colors.white, size: 20),
                          label: Text(
                            'Agregar a $mesaNombre • ${NumberFormatter.currency(totalItem)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            final notaTexto = noteCtrl.text.trim();
                            Navigator.pop(modalCtx);

                            OrderCartManager().addItem(
                              id: dishId,
                              title: title,
                              price: price,
                              quantity: quantity,
                              note: notaTexto,
                              mesaId: selectedMesaId,
                              mesa: selectedMesa,
                            );

                            ScaffoldMessenger.of(parentContext)
                                .clearSnackBars();
                            ScaffoldMessenger.of(parentContext).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    const Icon(Icons.check_circle,
                                        color: Colors.greenAccent, size: 18),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        '${quantity}x $title agregado a $mesaNombre',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                backgroundColor: const Color(0xFF38231C),
                                behavior: SnackBarBehavior.floating,
                                duration: const Duration(seconds: 3),
                                action: SnackBarAction(
                                  label: 'Ver mesa',
                                  textColor: Colors.amberAccent,
                                  onPressed: () {
                                    if (!parentContext.mounted) return;
                                    Navigator.of(parentContext).push(
                                      MaterialPageRoute(
                                        builder: (_) => OrderCartScreen(
                                          mesa: selectedMesa,
                                        ),
                                      ),
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
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Construye la imagen del platillo
  Widget _buildDishImage(Map<String, String> dish) {
    final imageUrl = (dish['imageUrl'] ?? '').trim();
    const double size = 70;

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

    return _fallbackAssetImage(dish, size);
  }

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
