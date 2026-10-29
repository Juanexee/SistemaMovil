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

    return ResumenInventarioModel(
      totalInsumos: parseInt(
        json['totalInsumos'] ?? json['totalItems'] ?? json['total'] ?? json['TotalInsumos'],
      ),
      valoracionTotal: parseNum(
        json['valoracionTotal'] ?? json['valorTotal'] ?? json['totalValor'] ?? json['ValoracionTotal'],
      ),
      tasaAlerta: parseNum(
        json['tasaAlerta'] ?? json['porcentajeAlerta'] ?? json['alertaTasa'] ?? json['TasaAlerta'],
      ),
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

    return AlertaStockModel(
      id: parseInt(json['id'] ?? json['insumoID'] ?? json['insumoId'] ?? json['_id']),
      nombre: (json['nombre'] ?? json['nombreInsumo'] ?? json['name'] ?? '').toString(),
      stockActual: parseNum(
        json['stockActual'] ?? json['stock'] ?? json['cantidad'] ?? json['existencias'] ?? json['StockActual'],
      ),
      stockMinimo: parseNum(
        json['stockMinimo'] ?? json['minimo'] ?? json['puntoReorden'] ?? json['StockMinimo'],
      ),
      unidadMedida: (json['unidadMedida'] ?? json['unidad'] ?? json['unidadMedidaNombre'] ?? json['UnidadMedida'] ?? 'Unidades').toString(),
    );
  }
}
