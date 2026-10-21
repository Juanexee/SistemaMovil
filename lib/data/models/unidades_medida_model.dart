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
