// =========================================================
// inventario_provider.dart
// Gestiona el estado del inventario y las alertas de stock
// =========================================================
import 'package:flutter/material.dart';
import '../../core/di/injection.dart';
import '../../services/inventario_service.dart';
import '../../services/insumos_service.dart';
import '../../services/secure_storage_service.dart';
import '../../data/models/inventario_model.dart';

class InventarioProvider extends ChangeNotifier {
  final InventarioService _inventarioService;
  final InsumosService? _insumosService;

  InventarioProvider(this._inventarioService, [this._insumosService]);

  bool _isLoading = false;
  ResumenInventarioModel? _resumen;
  List<AlertaStockModel> _alertas = [];
  String _errorMessage = '';

  // Getters para la UI
  bool get isLoading => _isLoading;
  ResumenInventarioModel? get resumen => _resumen;
  List<AlertaStockModel> get alertas => _alertas;
  String get errorMessage => _errorMessage;

  // Método para cargar tanto el resumen como las alertas desde la API
  Future<void> loadInventarioData() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    bool resumenOk = false;
    bool alertasOk = false;

    double umbralPreferencia = 10.0;
    try {
      final prefs = await sl<SecureStorageService>().getSettings();
      umbralPreferencia = (prefs['stockMinimo'] as num?)?.toDouble() ?? 10.0;
    } catch (_) {}

    // 1. Intentamos obtener resumen y alertas del endpoint de InventarioMovil
    try {
      _resumen = await _inventarioService.getResumen();
      resumenOk = true;
    } catch (_) {}

    try {
      _alertas = await _inventarioService.getAlertas();
      alertasOk = true;
    } catch (_) {}

    // 2. Si alguno falló (por ejemplo por error 500 en la base de datos de Azure),
    // usamos InsumosService como fallback para calcular el inventario real
    if ((!resumenOk || !alertasOk) && _insumosService != null) {
      try {
        final insumos = await _insumosService.getInsumos();
        if (insumos.isNotEmpty) {
          final totalInsumos = insumos.length;
          final valoracionTotal = insumos.fold<double>(
            0.0,
            (sum, item) => sum + (item.stock * item.precioUnitario),
          );
          final alertasCalculadas = insumos
              .where((i) {
                final minEfectivo =
                    i.stockMinimo > 0 ? i.stockMinimo : umbralPreferencia;
                return i.stock <= minEfectivo;
              })
              .map((i) => AlertaStockModel(
                    id: i.id,
                    nombre: i.nombre,
                    stockActual: i.stock,
                    stockMinimo:
                        i.stockMinimo > 0 ? i.stockMinimo : umbralPreferencia,
                    unidadMedida: i.unidadMedidaNombre ?? 'Unidades',
                  ))
              .toList();
          final tasaAlerta = totalInsumos > 0
              ? (alertasCalculadas.length / totalInsumos) * 100
              : 0.0;

          if (!resumenOk) {
            _resumen = ResumenInventarioModel(
              totalInsumos: totalInsumos,
              valoracionTotal: valoracionTotal,
              tasaAlerta: tasaAlerta,
            );
          }
          if (!alertasOk) {
            _alertas = alertasCalculadas;
          }
          // Si obtuvimos los insumos con éxito, no mostramos error al usuario
          _errorMessage = '';
        }
      } catch (fallbackError) {
        if (_resumen == null && _alertas.isEmpty) {
          _errorMessage =
              'No fue posible sincronizar el inventario con el servidor.';
        }
      }
    } else if (!resumenOk && !alertasOk && _resumen == null) {
      _errorMessage =
          'No fue posible sincronizar el inventario con el servidor.';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Limpia los datos almacenados al cerrar sesión o cambiar de usuario
  void clear() {
    _resumen = null;
    _alertas = [];
    _errorMessage = '';
    _isLoading = false;
    notifyListeners();
  }
}
