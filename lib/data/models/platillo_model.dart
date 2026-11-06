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
    final rawImg = json['imagenBase64'] ??
        json['imagenUrl'] ??
        json['imagen'] ??
        json['foto'] ??
        json['fotoUrl'] ??
        json['urlImagen'] ??
        json['rutaImagen'] ??
        json['imageUrl'] ??
        json['image'] ??
        json['imagenPath'] ??
        json['archivoImagen'];

    return PlatilloModel(
      id:              json['platilloID']      ?? json['id']              ?? json['idPlatillo'] ?? 0,
      nombre:          json['nombre']          ?? json['nombrePlatillo']  ?? '',
      descripcion:     json['descripcion']     ?? '',
      precio:          (json['precio']         ?? 0).toDouble(),
      categoriaId:     json['categoriaID']     ?? json['categoriaId']     ?? json['idCategoria'] ?? 0,
      categoriaNombre: json['nombreCategoria'] ?? json['categoriaNombre'] ?? json['categoria'],
      disponible:      json['disponible']      ?? json['activo']          ?? true,
      imagenUrl:       rawImg != null && rawImg.toString().trim().isNotEmpty
          ? rawImg.toString().trim()
          : null,
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
