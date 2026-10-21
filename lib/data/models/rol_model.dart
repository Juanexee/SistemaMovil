// =========================================================
// rol_model.dart
// =========================================================
class RolModel {
  final int id;
  final String nombre;
  final bool activo;

  RolModel({required this.id, required this.nombre, required this.activo});

  factory RolModel.fromJson(Map<String, dynamic> json) {
    return RolModel(
      id:     json['id']     ?? 0,
      nombre: json['nombre'] ?? '',
      activo: json['activo'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'nombre': nombre, 'activo': activo};
}
