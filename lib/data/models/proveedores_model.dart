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
