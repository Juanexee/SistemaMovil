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
    double parseNum(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString()) ?? 0.0;
    }

    int parseInt(dynamic val) {
      if (val == null) return 0;
      if (val is int) return val;
      return int.tryParse(val.toString()) ?? 0;
    }

    return InsumoModel(
      id: parseInt(json['insumoID'] ?? json['insumoId'] ?? json['id'] ?? json['_id']),
      nombre: (json['nombreInsumo'] ?? json['nombre'] ?? json['name'] ?? '').toString(),
      stock: parseNum(
        json['stock'] ?? json['stockActual'] ?? json['cantidad'] ?? json['existencias'] ?? json['cantidadDisponible'] ?? json['Stock'],
      ),
      stockMinimo: parseNum(
        json['stockMinimo'] ?? json['minimo'] ?? json['puntoReorden'] ?? json['StockMinimo'],
      ),
      unidadMedidaId: parseInt(
        json['unidadMedidaId'] ?? json['unidadMedidaID'] ?? json['idUnidadMedida'],
      ),
      unidadMedidaNombre: (json['unidadMedidaNombre'] ?? json['unidadMedida'] ?? json['unidad'] ?? json['UnidadMedida'])?.toString(),
      precioUnitario: parseNum(
        json['precioUnitario'] ?? json['costoUnitario'] ?? json['precio'] ?? json['costo'] ?? json['PrecioUnitario'],
      ),
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
