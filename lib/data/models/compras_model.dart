// =========================================================
// compras_model.dart
// =========================================================

// Un detalle dentro de una compra (insumo + cantidad + precio)
class DetalleCompraModel {
  final int insumoId;
  final double cantidad;
  final double precioUnitario;

  DetalleCompraModel({
    required this.insumoId,
    required this.cantidad,
    required this.precioUnitario,
  });

  Map<String, dynamic> toJson() => {
    'insumoId':       insumoId,
    'cantidad':       cantidad,
    'precioUnitario': precioUnitario,
  };
}

// Lo que mando al registrar una compra
class RegistrarCompraRequest {
  final int proveedorId;
  final List<DetalleCompraModel> detalles;

  RegistrarCompraRequest({
    required this.proveedorId,
    required this.detalles,
  });

  Map<String, dynamic> toJson() => {
    'proveedorId': proveedorId,
    'detalles':    detalles.map((d) => d.toJson()).toList(),
  };
}
