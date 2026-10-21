// =========================================================
// ventas_model.dart
// =========================================================

// Una venta/factura registrada en el sistema
class VentaModel {
  final int id;
  final int mesaId;
  final double total;
  final String estado;
  final String? metodoPago;
  final String? fecha;

  VentaModel({
    required this.id,
    required this.mesaId,
    required this.total,
    required this.estado,
    this.metodoPago,
    this.fecha,
  });

  factory VentaModel.fromJson(Map<String, dynamic> json) {
    return VentaModel(
      id:         json['id']         ?? 0,
      mesaId:     json['mesaId']     ?? 0,
      total:      (json['total']     ?? 0).toDouble(),
      estado:     json['estado']     ?? '',
      metodoPago: json['metodoPago'],
      fecha:      json['fecha'],
    );
  }
}

// Un item dentro de una venta
class DetalleVentaRequest {
  final int platilloId;
  final int cantidad;
  final double precioUnitario;

  DetalleVentaRequest({
    required this.platilloId,
    required this.cantidad,
    required this.precioUnitario,
  });

  Map<String, dynamic> toJson() => {
    'platilloId':     platilloId,
    'cantidad':       cantidad,
    'precioUnitario': precioUnitario,
  };
}

// Para registrar una venta nueva
class RegistrarVentaRequest {
  final int mesaId;
  final List<DetalleVentaRequest> detalles;

  RegistrarVentaRequest({required this.mesaId, required this.detalles});

  Map<String, dynamic> toJson() => {
    'mesaId':   mesaId,
    'detalles': detalles.map((d) => d.toJson()).toList(),
  };
}

// Para actualizar el estado de un grupo de pedidos (Ej: Pendiente â†’ En Preparacion)
class ActualizarEstadoGrupoRequest {
  final List<int> pedidoIds;
  final String nuevoEstado;

  ActualizarEstadoGrupoRequest({
    required this.pedidoIds,
    required this.nuevoEstado,
  });

  Map<String, dynamic> toJson() => {
    'pedidoIds':   pedidoIds,
    'nuevoEstado': nuevoEstado,
  };
}
