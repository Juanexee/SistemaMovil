// =========================================================
// recetas_model.dart
// =========================================================

// Un insumo dentro de una receta con su cantidad
class RecetaInsumoModel {
  final int insumoId;
  final String? nombreInsumo;
  final double cantidad;
  final String? unidadMedida;

  RecetaInsumoModel({
    required this.insumoId,
    this.nombreInsumo,
    required this.cantidad,
    this.unidadMedida,
  });

  factory RecetaInsumoModel.fromJson(Map<String, dynamic> json) {
    return RecetaInsumoModel(
      insumoId:     json['insumoId']    ?? 0,
      nombreInsumo: json['nombreInsumo'],
      cantidad:     (json['cantidad']   ?? 0).toDouble(),
      unidadMedida: json['unidadMedida'],
    );
  }

  Map<String, dynamic> toJson() => {
    'insumoId': insumoId,
    'cantidad': cantidad,
  };
}

// La receta completa de un platillo
class RecetaModel {
  final int platilloId;
  final String? nombrePlatillo;
  final List<RecetaInsumoModel> insumos;

  RecetaModel({
    required this.platilloId,
    this.nombrePlatillo,
    required this.insumos,
  });

  factory RecetaModel.fromJson(Map<String, dynamic> json) {
    final insumosJson = json['insumos'] as List? ?? [];
    return RecetaModel(
      platilloId:     json['platilloId']     ?? 0,
      nombrePlatillo: json['nombrePlatillo'],
      insumos: insumosJson
          .map((i) => RecetaInsumoModel.fromJson(i as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'platilloId': platilloId,
    'insumos':    insumos.map((i) => i.toJson()).toList(),
  };
}
