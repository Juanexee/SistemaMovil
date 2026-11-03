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
      final clean = val.toString().replaceAll(RegExp(r'[^0-9.-]'), '');
      return double.tryParse(clean) ?? 0.0;
    }

    int parseInt(dynamic val) {
      if (val == null) return 0;
      if (val is int) return val;
      if (val is num) return val.toInt();
      return int.tryParse(val.toString()) ?? 0;
    }

    dynamic findByKeys(
      List<String> exactKeys,
      bool Function(String lowerKey) fuzzyMatcher,
    ) {
      for (final k in exactKeys) {
        if (json.containsKey(k) && json[k] != null && json[k] is! Map) {
          return json[k];
        }
      }
      for (final entry in json.entries) {
        final lower = entry.key.toLowerCase();
        if (entry.value != null &&
            entry.value is! Map &&
            entry.value is! List &&
            fuzzyMatcher(lower)) {
          return entry.value;
        }
      }
      return null;
    }

    final rawStock = findByKeys(
      const [
        'stock',
        'Stock',
        'stockActual',
        'StockActual',
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
        'saldoActual',
        'saldo',
      ],
      (k) =>
          (k.contains('stock') && !k.contains('min')) ||
          (k.contains('existencia') && !k.contains('min')) ||
          (k.contains('cantidad') && !k.contains('min')) ||
          k.contains('disponible') ||
          k.contains('saldo'),
    );

    final rawMin = findByKeys(
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

    final rawPrecio = findByKeys(
      const [
        'precioUnitario',
        'PrecioUnitario',
        'costoUnitario',
        'CostoUnitario',
        'costoPromedio',
        'CostoPromedio',
        'precioPromedio',
        'PrecioPromedio',
        'ultimoCosto',
        'UltimoCosto',
        'precioCompra',
        'PrecioCompra',
        'precio',
        'Precio',
        'costo',
        'Costo',
        'valorUnitario',
        'ValorUnitario',
      ],
      (k) => k.contains('precio') || k.contains('costo') || k.contains('valor'),
    );

    String? resolveUnidadNombre() {
      final rawU = json['unidadMedidaNombre'] ??
          json['UnidadMedidaNombre'] ??
          json['nombreUnidad'] ??
          json['NombreUnidad'] ??
          json['abreviatura'] ??
          json['Abreviatura'] ??
          json['unidadMedida'] ??
          json['UnidadMedida'] ??
          json['unidad'] ??
          json['Unidad'];
      if (rawU is Map) {
        final nested = rawU['abreviatura'] ??
            rawU['Abreviatura'] ??
            rawU['nombre'] ??
            rawU['Nombre'];
        if (nested != null && nested.toString().trim().isNotEmpty) {
          return nested.toString().trim();
        }
      } else if (rawU != null && rawU.toString().trim().isNotEmpty) {
        return rawU.toString().trim();
      }
      return null;
    }

    return InsumoModel(
      id: parseInt(
        json['insumoID'] ??
            json['insumoId'] ??
            json['InsumoID'] ??
            json['InsumoId'] ??
            json['id'] ??
            json['Id'] ??
            json['_id'],
      ),
      nombre: (json['nombreInsumo'] ??
              json['NombreInsumo'] ??
              json['nombre'] ??
              json['Nombre'] ??
              json['name'] ??
              '')
          .toString(),
      stock: parseNum(rawStock),
      stockMinimo: parseNum(rawMin),
      unidadMedidaId: parseInt(
        json['unidadMedidaId'] ??
            json['unidadMedidaID'] ??
            json['UnidadMedidaID'] ??
            json['UnidadMedidaId'] ??
            json['idUnidadMedida'],
      ),
      unidadMedidaNombre: resolveUnidadNombre(),
      precioUnitario: parseNum(rawPrecio),
    );
  }

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'stock': stock,
        'stockMinimo': stockMinimo,
        'unidadMedidaId': unidadMedidaId,
        'precioUnitario': precioUnitario,
      };
}
