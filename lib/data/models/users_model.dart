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

// =========================================================
// mesas_model.dart
// =========================================================
class MesaModel {
  final int id;
  final int numero;
  final int capacidad;
  final String estado; // 'Libre', 'Ocupada', 'Reservada'

  MesaModel({
    required this.id,
    required this.numero,
    required this.capacidad,
    required this.estado,
  });

  factory MesaModel.fromJson(Map<String, dynamic> json) {
    return MesaModel(
      id:        json['id']        ?? 0,
      numero:    json['numero']    ?? 0,
      capacidad: json['capacidad'] ?? 0,
      estado:    json['estado']    ?? 'Libre',
    );
  }

  Map<String, dynamic> toJson() => {
    'numero':    numero,
    'capacidad': capacidad,
    'estado':    estado,
  };
}

// =========================================================
// proveedores_model.dart
// =========================================================
class ProveedorModel {
  final int id;
  final String nombre;
  final String telefono;
  final String email;

  ProveedorModel({
    required this.id,
    required this.nombre,
    required this.telefono,
    required this.email,
  });

  factory ProveedorModel.fromJson(Map<String, dynamic> json) {
    return ProveedorModel(
      id:       json['id']       ?? 0,
      nombre:   json['nombre']   ?? '',
      telefono: json['telefono'] ?? '',
      email:    json['email']    ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'nombre':   nombre,
    'telefono': telefono,
    'email':    email,
  };
}

// =========================================================
// unidades_medida_model.dart
// =========================================================
class UnidadMedidaModel {
  final int id;
  final String nombre;
  final String abreviatura;

  UnidadMedidaModel({
    required this.id,
    required this.nombre,
    required this.abreviatura,
  });

  factory UnidadMedidaModel.fromJson(Map<String, dynamic> json) {
    return UnidadMedidaModel(
      id:           json['id']           ?? 0,
      nombre:       json['nombre']       ?? '',
      abreviatura:  json['abreviatura']  ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'nombre':      nombre,
    'abreviatura': abreviatura,
  };
}

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
