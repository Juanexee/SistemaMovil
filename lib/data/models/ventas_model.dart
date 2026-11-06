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
    double parseNum(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString()) ?? 0.0;
    }

    int parseInt(dynamic val) {
      if (val == null) return 0;
      if (val is int) return val;
      return int.tryParse(val.toString()) ?? 0;
    }

    // Mapeo exhaustivo de ID / Número de Factura
    final idVenta = parseInt(
      json['id'] ??
      json['ventaID'] ??
      json['ventaId'] ??
      json['facturaID'] ??
      json['facturaId'] ??
      json['numeroFactura'] ??
      json['nroFactura'] ??
      json['numero'] ??
      json['_id'],
    );

    // Mapeo de Mesa
    final mesaId = parseInt(
      json['mesaId'] ??
      json['mesaID'] ??
      json['idMesa'] ??
      json['numeroMesa'],
    );

    // Mapeo de Total
    final total = parseNum(
      json['total'] ??
      json['totalVenta'] ??
      json['montoTotal'] ??
      json['totalGeneral'] ??
      json['monto'],
    );

    // Mapeo de Estado
    final rawEstado = (json['estado'] ??
        json['estadoVenta'] ??
        json['estadoFactura'] ??
        json['status'] ??
        'Pagada').toString();

    // Mapeo de Método de Pago
    final rawPago = json['metodoPago'] ??
        json['formaPago'] ??
        json['tipoPago'] ??
        json['metodoPagoNombre'] ??
        json['metodo'] ??
        json['pago'];

    // Mapeo de Fecha
    final rawFecha = json['fecha'] ??
        json['fechaVenta'] ??
        json['fechaRegistro'] ??
        json['fechaHora'] ??
        json['createdAt'] ??
        json['fechaCreacion'];

    return VentaModel(
      id: idVenta,
      mesaId: mesaId,
      total: total,
      estado: rawEstado.isNotEmpty ? rawEstado : 'Pagada',
      metodoPago: rawPago?.toString(),
      fecha: rawFecha?.toString(),
    );
  }
}

// Un item dentro de una venta
class DetalleVentaRequest {
  final int platilloId;
  final int cantidad;
  final double precioUnitario;
  final double subtotal;

  DetalleVentaRequest({
    required this.platilloId,
    required this.cantidad,
    required this.precioUnitario,
    double? subtotal,
  }) : subtotal = subtotal ?? (precioUnitario * cantidad);

  Map<String, dynamic> toJson() => {
    'platilloId':     platilloId,
    'platilloID':     platilloId,
    'idPlatillo':     platilloId,
    'cantidad':       cantidad,
    'precioUnitario': precioUnitario,
    'subtotal':       subtotal,
  };
}

// Para registrar una venta nueva
class RegistrarVentaRequest {
  final int mesaId;
  final String tipoPedido;
  final List<DetalleVentaRequest> detalles;

  RegistrarVentaRequest({
    required this.mesaId,
    this.tipoPedido = 'En mesa',
    required this.detalles,
  });

  Map<String, dynamic> toJson() {
    final list = detalles.map((d) => d.toJson()).toList();
    return {
      'mesaId':       mesaId,
      'mesaID':       mesaId,
      'idMesa':       mesaId,
      'tipoPedido':   tipoPedido,
      'TipoPedido':   tipoPedido,
      'detalles':     list,
      'detalleVenta': list,
      'DetalleVenta': list,
      'detallesVenta': list,
    };
  }
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
