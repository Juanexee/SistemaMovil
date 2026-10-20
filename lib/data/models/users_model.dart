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
