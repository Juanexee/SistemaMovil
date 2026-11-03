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
    final rawId = json['unidadMedidaID'] ??
        json['unidadMedidaId'] ??
        json['UnidadMedidaID'] ??
        json['id'] ??
        json['Id'] ??
        0;
    return UnidadMedidaModel(
      id: rawId is int ? rawId : (int.tryParse(rawId.toString()) ?? 0),
      nombre: (json['nombre'] ??
              json['Nombre'] ??
              json['nombreUnidad'] ??
              '')
          .toString(),
      abreviatura: (json['abreviatura'] ??
              json['Abreviatura'] ??
              json['simbolo'] ??
              '')
          .toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'abreviatura': abreviatura,
      };
}
