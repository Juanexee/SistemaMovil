// =========================================================
// inventario_model.dart
// Modelos para el monitoreo de inventario
// Cubre RF-MOV-MON-01 (resumen) y RF-MOV-MON-02 (alertas)
// =========================================================

double _parseDouble(dynamic val) {
  if (val == null) return 0.0;
  if (val is num) return val.toDouble();
  final clean = val.toString().replaceAll(RegExp(r'[^0-9.-]'), '');
  return double.tryParse(clean) ?? 0.0;
}

int _parseInt(dynamic val) {
  if (val == null) return 0;
  if (val is int) return val;
  if (val is num) return val.toInt();
  return int.tryParse(val.toString()) ?? 0;
}

dynamic _findByKeys(
  Map<String, dynamic> json,
  List<String> exactKeys,
  bool Function(String lowerKey) fuzzyMatcher,
) {
  for (final k in exactKeys) {
    if (json.containsKey(k) && json[k] != null) {
      return json[k];
    }
  }
  for (final entry in json.entries) {
    final lower = entry.key.toLowerCase();
    if (entry.value != null && fuzzyMatcher(lower)) {
      return entry.value;
    }
  }
  return null;
}

// Resumen global del inventario — RF-MOV-MON-01
class ResumenInventarioModel {
  final int totalInsumos; // Cuántos insumos hay registrados
  final double valoracionTotal; // Valor monetario total del stock
  final double tasaAlerta; // % de insumos en nivel crítico

  ResumenInventarioModel({
    required this.totalInsumos,
    required this.valoracionTotal,
    required this.tasaAlerta,
  });

  factory ResumenInventarioModel.fromJson(Map<String, dynamic> rawJson) {
    final json = (rawJson['data'] is Map<String, dynamic>)
        ? rawJson['data'] as Map<String, dynamic>
        : (rawJson['resumen'] is Map<String, dynamic>)
            ? rawJson['resumen'] as Map<String, dynamic>
            : rawJson;

    final rawTotal = _findByKeys(
      json,
      const [
        'totalInsumos',
        'TotalInsumos',
        'totalItems',
        'TotalItems',
        'cantidadInsumos',
        'CantidadInsumos',
        'total',
        'Total',
      ],
      (k) =>
          (k.contains('total') || k.contains('cantidad')) &&
          (k.contains('insumo') || k.contains('item')),
    );

    final rawValor = _findByKeys(
      json,
      const [
        'valoracionTotal',
        'ValoracionTotal',
        'valorTotal',
        'ValorTotal',
        'totalValor',
        'TotalValor',
        'valorInventario',
        'ValorInventario',
        'valorTotalInventario',
        'ValorTotalInventario',
        'valorTotalStock',
        'ValorTotalStock',
        'valorStock',
        'ValorStock',
        'costoTotal',
        'CostoTotal',
        'montoTotal',
        'MontoTotal',
        'valoracion',
        'Valoracion',
      ],
      (k) => k.contains('valor') || k.contains('costo') || k.contains('monto'),
    );

    final rawTasa = _findByKeys(
      json,
      const [
        'tasaAlerta',
        'TasaAlerta',
        'porcentajeAlerta',
        'PorcentajeAlerta',
        'alertaTasa',
        'AlertaTasa',
        'tasaCritica',
        'porcentajeCritico',
      ],
      (k) => k.contains('tasa') || k.contains('porcentaje'),
    );

    return ResumenInventarioModel(
      totalInsumos: _parseInt(rawTotal),
      valoracionTotal: _parseDouble(rawValor),
      tasaAlerta: _parseDouble(rawTasa),
    );
  }
}

// Un insumo en nivel crítico de stock — RF-MOV-MON-02
class AlertaStockModel {
  final int id;
  final String nombre;
  final double stockActual;
  final double stockMinimo;
  final String unidadMedida;
  final double precioUnitario;

  AlertaStockModel({
    required this.id,
    required this.nombre,
    required this.stockActual,
    required this.stockMinimo,
    required this.unidadMedida,
    this.precioUnitario = 0.0,
  });

  factory AlertaStockModel.fromJson(Map<String, dynamic> json) {
    final rawStock = _findByKeys(
      json,
      const [
        'stockActual',
        'StockActual',
        'stock',
        'Stock',
        'cantidadActual',
        'CantidadActual',
        'cantidadDisponible',
        'CantidadDisponible',
        'existencia',
        'Existencia',
        'existencias',
        'Existencias',
        'cantidad',
        'Cantidad',
        'saldo',
        'Saldo',
      ],
      (k) =>
          (k.contains('stock') && !k.contains('min')) ||
          (k.contains('existencia') && !k.contains('min')) ||
          (k.contains('cantidad') && !k.contains('min')) ||
          k.contains('disponible'),
    );

    final rawMin = _findByKeys(
      json,
      const [
        'stockMinimo',
        'StockMinimo',
        'minimo',
        'Minimo',
        'cantidadMinima',
        'CantidadMinima',
        'existenciaMinima',
        'ExistenciaMinima',
        'puntoReorden',
        'PuntoReorden',
        'stockMin',
        'StockMin',
      ],
      (k) =>
          k.contains('min') || k.contains('reorden') || k.contains('critico'),
    );

    final rawPrecio = _findByKeys(
      json,
      const [
        'precioUnitario',
        'PrecioUnitario',
        'costoUnitario',
        'CostoUnitario',
        'costoPromedio',
        'CostoPromedio',
        'precio',
        'Precio',
        'costo',
        'Costo',
      ],
      (k) => k.contains('precio') || k.contains('costo'),
    );

    String resolveUnidad() {
      final u = json['unidadMedida'] ??
          json['UnidadMedida'] ??
          json['unidad'] ??
          json['Unidad'] ??
          json['unidadMedidaNombre'] ??
          json['UnidadMedidaNombre'] ??
          json['abreviatura'] ??
          json['Abreviatura'];
      if (u is Map) {
        return (u['abreviatura'] ??
                u['Abreviatura'] ??
                u['nombre'] ??
                u['Nombre'] ??
                'Unidades')
            .toString();
      }
      if (u != null && u.toString().trim().isNotEmpty) {
        return u.toString().trim();
      }
      return 'Unidades';
    }

    return AlertaStockModel(
      id: _parseInt(
          json['id'] ?? json['insumoID'] ?? json['insumoId'] ?? json['_id']),
      nombre: (json['nombre'] ??
              json['nombreInsumo'] ??
              json['NombreInsumo'] ??
              json['Nombre'] ??
              json['name'] ??
              '')
          .toString(),
      stockActual: _parseDouble(rawStock),
      stockMinimo: _parseDouble(rawMin),
      unidadMedida: resolveUnidad(),
      precioUnitario: _parseDouble(rawPrecio),
    );
  }
}
