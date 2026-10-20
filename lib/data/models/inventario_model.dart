// =========================================================
// inventario_model.dart
// Modelos para el monitoreo de inventario
// Cubre RF-MOV-MON-01 (resumen) y RF-MOV-MON-02 (alertas)
// =========================================================

// Resumen global del inventario â€” RF-MOV-MON-01
class ResumenInventarioModel {
  final int totalInsumos;        // Cuantos insumos hay registrados
  final double valoracionTotal;  // Valor monetario total del stock
  final double tasaAlerta;       // % de insumos en nivel critico

  ResumenInventarioModel({
    required this.totalInsumos,
    required this.valoracionTotal,
    required this.tasaAlerta,
  });

  factory ResumenInventarioModel.fromJson(Map<String, dynamic> json) {
    return ResumenInventarioModel(
      totalInsumos:    json['totalInsumos']    ?? 0,
      valoracionTotal: (json['valoracionTotal'] ?? 0).toDouble(),
      tasaAlerta:      (json['tasaAlerta']      ?? 0).toDouble(),
    );
  }
}

// Un insumo en nivel critico de stock â€” RF-MOV-MON-02
class AlertaStockModel {
  final int id;
  final String nombre;
  final double stockActual;
  final double stockMinimo;
  final String unidadMedida;

  AlertaStockModel({
    required this.id,
    required this.nombre,
    required this.stockActual,
    required this.stockMinimo,
    required this.unidadMedida,
  });

  factory AlertaStockModel.fromJson(Map<String, dynamic> json) {
    return AlertaStockModel(
      id:           json['id']           ?? 0,
      nombre:       json['nombre']       ?? '',
      stockActual:  (json['stockActual']  ?? 0).toDouble(),
      stockMinimo:  (json['stockMinimo']  ?? 0).toDouble(),
      unidadMedida: json['unidadMedida'] ?? '',
    );
  }
}
