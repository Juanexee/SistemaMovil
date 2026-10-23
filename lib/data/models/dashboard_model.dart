// =========================================================
// dashboard_model.dart
// Modelos para el dashboard gerencial (KPIs y tendencias)
// Cubre RF-MOV-DSH-01 y RF-MOV-DSH-02
// =========================================================

// KPIs del negocio: ventas del dia, ticket promedio y margen
class KpisModel {
  final double ventasDelDia;     // Total vendido hoy
  final double ticketPromedio;   // Promedio por venta/mesa
  final double margenAcumulado;  // Ganancia acumulada

  KpisModel({
    required this.ventasDelDia,
    required this.ticketPromedio,
    required this.margenAcumulado,
  });

  factory KpisModel.fromJson(Map<String, dynamic> json) {
    return KpisModel(
      // .toDouble() porque la API puede mandar int o double
      ventasDelDia:    (json['totalVentasHoy'] ?? json['ventasDelDia'] ?? 0).toDouble(),
      ticketPromedio:  (json['ticketPromedio']  ?? 0).toDouble(),
      margenAcumulado: (json['margenGananciaAcumulado'] ?? json['margenAcumulado'] ?? 0).toDouble(),
    );
  }
}

// Un punto de la grafica de tendencias (fecha + total)
class TendenciaModel {
  final String fecha;  // Ej: '2024-10-15'
  final double total;  // Total vendido ese dia

  TendenciaModel({required this.fecha, required this.total});

  factory TendenciaModel.fromJson(Map<String, dynamic> json) {
    return TendenciaModel(
      fecha: json['fecha'] ?? '',
      total: (json['total'] ?? 0).toDouble(),
    );
  }
}
