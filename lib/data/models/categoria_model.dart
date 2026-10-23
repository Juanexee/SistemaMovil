// =========================================================
// categoria_model.dart
// =========================================================
class CategoriaModel {
  final int id;
  final String nombre;
  final bool activo;

  CategoriaModel({required this.id, required this.nombre, required this.activo});

  factory CategoriaModel.fromJson(Map<String, dynamic> json) {
    return CategoriaModel(
      id:     json['categoriaID'] ?? json['id'] ?? 0,
      nombre: json['nombre']      ?? '',
      activo: json['activo']      ?? true,
    );
  }

  // Para insertar o actualizar, mando estos datos al servidor
  Map<String, dynamic> toJson() => {'nombre': nombre, 'activo': activo};
}
