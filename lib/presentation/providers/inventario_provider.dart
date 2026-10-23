// =========================================================
// inventario_provider.dart
// Gestiona el estado del inventario y las alertas de stock
// =========================================================
import 'package:flutter/material.dart';
import '../../services/inventario_service.dart';
import '../../data/models/inventario_model.dart';

class InventarioProvider extends ChangeNotifier {
  final InventarioService _inventarioService;

  InventarioProvider(this._inventarioService);

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

    try {
      try {
        _resumen = await _inventarioService.getResumen();
      } catch (e) {
        _errorMessage = 'Resumen no disponible: $e';
      }
      try {
        _alertas = await _inventarioService.getAlertas();
      } catch (e) {
        _errorMessage = (_errorMessage.isEmpty ? '' : '$_errorMessage | ') + 'Alertas: $e';
      }
    } finally {
      _isLoading = false;
      notifyListeners(); // La pantalla se refresca automáticamente con la info de la API
    }
  }
}
