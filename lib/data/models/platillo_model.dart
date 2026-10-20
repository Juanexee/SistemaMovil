// =========================================================
// platillo_model.dart
// =========================================================
class PlatilloModel {
  final int id;
  final String nombre;
  final String descripcion;
  final double precio;
  final int categoriaId;
  final String? categoriaNombre;
  final bool disponible;
  final String? imagenUrl;

  PlatilloModel({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.categoriaId,
    this.categoriaNombre,
    required this.disponible,
    this.imagenUrl,
  });

  factory PlatilloModel.fromJson(Map<String, dynamic> json) {
    return PlatilloModel(
      id:              json['id']              ?? 0,
      nombre:          json['nombre']          ?? '',
      descripcion:     json['descripcion']     ?? '',
      precio:          (json['precio']         ?? 0).toDouble(),
      categoriaId:     json['categoriaId']     ?? 0,
      categoriaNombre: json['categoriaNombre'],
      disponible:      json['disponible']      ?? true,
      imagenUrl:       json['imagenUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
    'nombre':      nombre,
    'descripcion': descripcion,
    'precio':      precio,
    'categoriaId': categoriaId,
    'disponible':  disponible,
  };
}
