// =========================================================
// number_formatter.dart
// Utilidad para formatear números y montos en formato contable
// con separador de miles (,) y punto decimal (.)
// =========================================================

class NumberFormatter {
  /// Formatea un número con separadores de miles (,) y [decimals] decimales (.)
  /// Ejemplo: format(12450.5, decimals: 2) -> "12,450.50"
  static String format(num? value, {int decimals = 2}) {
    final val = (value ?? 0).toDouble();
    final isNegative = val < 0;
    final absVal = val.abs();

    final fixed = absVal.toStringAsFixed(decimals);
    final parts = fixed.split('.');
    final intPart = parts[0];
    final decPart = parts.length > 1 ? parts[1] : '';

    final buffer = StringBuffer();
    for (int i = 0; i < intPart.length; i++) {
      final reverseIdx = intPart.length - i;
      buffer.write(intPart[i]);
      if (reverseIdx > 1 && reverseIdx % 3 == 1) {
        buffer.write(',');
      }
    }

    final formattedInt = buffer.toString();
    final sign = isNegative ? '-' : '';
    if (decimals <= 0) {
      return '$sign$formattedInt';
    }
    return '$sign$formattedInt.$decPart';
  }

  /// Formatea como moneda Córdoba: "C$ 12,450.00"
  static String currency(num? value, {int decimals = 2}) {
    return 'C\$ ${format(value, decimals: decimals)}';
  }

  /// Formatea enteros con separador de miles: "1,250"
  static String integer(num? value) {
    return format(value, decimals: 0);
  }
}

