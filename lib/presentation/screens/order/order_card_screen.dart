import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/order_cart_manager.dart';
import '../../providers/ventas_provider.dart';
import '../../../data/models/ventas_model.dart';

class OrderCartScreen extends StatefulWidget {
  final Map<String, dynamic>? mesa;
  const OrderCartScreen({super.key, this.mesa});

  @override
  State<OrderCartScreen> createState() => _OrderCartScreenState();
}

class _OrderCartScreenState extends State<OrderCartScreen> {
  final _cartManager = OrderCartManager();
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _cartManager,
      builder: (context, _) {
        final items = _cartManager.items;
        final subtotal = _cartManager.subtotal;
        final tax = subtotal * 0.15; // IVA 15%
        final totalGeneral = subtotal + tax;

        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          body: SafeArea(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopBar(),
                  const SizedBox(height: 12),
                  _buildOfflineBanner(),
                  const SizedBox(height: 16),
                  _buildTableHeaderSection(),
                  const SizedBox(height: 16),
                  _buildCartItemList(items),
                  const SizedBox(height: 16),
                  _buildFinancialSummaryCard(subtotal, tax, totalGeneral),
                  const SizedBox(height: 20),
                  _buildSubmitButton(items),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // 1. Top Bar superior
  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(width: 4),
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

  // 2. Banner superior de estado
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

  // 3. Cabecera con datos de la mesa seleccionada
  Widget _buildTableHeaderSection() {
    final mesaName = widget.mesa?['name'] ?? 'Mesa 01';
    final waiterName = widget.mesa?['waiterName'] ?? 'Carlos Rivera';
    final waiterInitials = widget.mesa?['waiterInitials'] ?? 'CR';
    final status = widget.mesa?['status'] ?? 'Ocupada';

    Color statusColor = Colors.green;
    Color badgeBgColor = const Color(0xFFE8F5E9);
    if (status == 'Ocupada') {
      statusColor = Colors.orange;
      badgeBgColor = const Color(0xFFFFF3E0);
    } else if (status == 'Por cobrar') {
      statusColor = Colors.blue;
      badgeBgColor = const Color(0xFFE3F2FD);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: badgeBgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              mesaName,
              style: const TextStyle(
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
                    child: Center(
                      child: Text(
                        waiterInitials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Atiende: $waiterName',
                    style: const TextStyle(
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

  // 4. Lista de platillos en la orden
  Widget _buildCartItemList(List<Map<String, dynamic>> cartItems) {
    if (cartItems.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(30.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(Icons.remove_shopping_cart_outlined,
                size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              'No hay platillos en la comanda',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
            ),
            const SizedBox(height: 4),
            Text(
              'Selecciona productos en el catálogo con el botón (+)',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: cartItems.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final item = cartItems[index];
        final price = (item['pricePerUnit'] as num).toDouble();
        final quantity = item['quantity'] as int;
        final double itemTotal = price * quantity;

        return Container(
          margin: const EdgeInsets.only(bottom: 12.0),
          padding: const EdgeInsets.all(14.0),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item['title'],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E221E),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded,
                        color: Colors.redAccent, size: 20),
                    onPressed: () {
                      _cartManager.removeItem(index);
                    },
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                item['note'] ?? 'Sin nota especial',
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
                            _cartManager.updateQuantity(index, -1);
                          },
                          constraints: const BoxConstraints(
                              minWidth: 32, minHeight: 32),
                          padding: EdgeInsets.zero,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            '$quantity',
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
                            _cartManager.updateQuantity(index, 1);
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
  Widget _buildFinancialSummaryCard(
      double subtotal, double tax, double totalGeneral) {
    return Container(
      padding: const EdgeInsets.all(16.0),
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
                'C\$ ${subtotal.toStringAsFixed(2)}',
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
                'C\$ ${tax.toStringAsFixed(2)}',
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
                'C\$ ${totalGeneral.toStringAsFixed(2)}',
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
  Widget _buildSubmitButton(List<Map<String, dynamic>> items) {
    final mesaName = widget.mesa?['name'] ?? 'Mesa 01';
    final mesaId = widget.mesa?['id'] is int
        ? widget.mesa!['id'] as int
        : (int.tryParse(widget.mesa?['id']?.toString() ?? '') ?? 1);
    final hasItems = items.isNotEmpty;

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              (hasItems && !_isSubmitting) ? const Color(0xFF2E221E) : Colors.grey.shade400,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0,
        ),
        onPressed: (hasItems && !_isSubmitting)
            ? () async {
                setState(() => _isSubmitting = true);

                final ventasProvider = Provider.of<VentasProvider>(context, listen: false);

                // Construimos los detalles a partir de los ítems del carrito
                final detalles = items.map((item) {
                  final platilloId = item['id'] is int
                      ? item['id'] as int
                      : (int.tryParse(item['id']?.toString() ?? '') ?? 1);
                  final cantidad = (item['quantity'] as int?) ?? 1;
                  final precioUnitario = (item['pricePerUnit'] as num?)?.toDouble() ?? 0.0;

                  return DetalleVentaRequest(
                    platilloId: platilloId,
                    cantidad: cantidad,
                    precioUnitario: precioUnitario,
                  );
                }).toList();

                final request = RegistrarVentaRequest(
                  mesaId: mesaId,
                  detalles: detalles,
                );

                final exito = await ventasProvider.registrarVenta(request);

                if (!mounted) return;
                setState(() => _isSubmitting = false);

                if (exito) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (ctx) => AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      title: Row(
                        children: const [
                          Icon(Icons.check_circle_outline,
                              color: Colors.green, size: 28),
                          SizedBox(width: 8),
                          Text('Comanda enviada'),
                        ],
                      ),
                      content: Text(
                          'La comanda para $mesaName ha sido registrada y enviada a cocina con éxito.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            _cartManager.clear();
                            Navigator.pop(context);
                          },
                          child: const Text('Aceptar',
                              style: TextStyle(
                                  color: Color(0xFF38231C),
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              ventasProvider.errorMessage.isNotEmpty
                                  ? ventasProvider.errorMessage
                                  : 'No se pudo registrar la comanda en el servidor',
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: Colors.redAccent,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              }
            : null,
        child: _isSubmitting
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Row(
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
}