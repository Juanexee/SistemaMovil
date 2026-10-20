// =========================================================
// insumos_model.dart
// =========================================================
class InsumoModel {
  final int id;
  final String nombre;
  final double stock;
  final double stockMinimo;
  final int unidadMedidaId;
  final String? unidadMedidaNombre;
  final double precioUnitario;

  InsumoModel({
    required this.id,
    required this.nombre,
    required this.stock,
    required this.stockMinimo,
    required this.unidadMedidaId,
    this.unidadMedidaNombre,
    required this.precioUnitario,
  });

  factory InsumoModel.fromJson(Map<String, dynamic> json) {
    return InsumoModel(
      id:                  json['id']                ?? 0,
      nombre:              json['nombre']            ?? '',
      stock:               (json['stock']            ?? 0).toDouble(),
      stockMinimo:         (json['stockMinimo']      ?? 0).toDouble(),
      unidadMedidaId:      json['unidadMedidaId']   ?? 0,
      unidadMedidaNombre:  json['unidadMedidaNombre'],
      precioUnitario:      (json['precioUnitario']   ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'nombre':          nombre,
    'stock':           stock,
    'stockMinimo':     stockMinimo,
    'unidadMedidaId':  unidadMedidaId,
    'precioUnitario':  precioUnitario,
  };
}
