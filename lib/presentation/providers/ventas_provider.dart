// =========================================================
// ventas_provider.dart
// Gestiona el estado de las ventas, filtros y pedidos
// =========================================================
import 'package:flutter/material.dart';
import '../../services/ventas_service.dart';
import '../../data/models/ventas_model.dart';

class VentasProvider extends ChangeNotifier {
  final VentasService _ventasService;

  VentasProvider(this._ventasService);

  // Variables para guardar el estado en la pantalla
  List<VentaModel> _ventas = [];
  bool _isLoading = false;
  String _errorMessage = '';

  // Getters para que la UI lea los datos de forma segura
  List<VentaModel> get ventas => _ventas;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Método para cargar todas las ventas usando el service
  Future<void> loadVentas() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners(); // Avisa a la pantalla que estamos cargando

    try {
      _ventas = await _ventasService.getVentas();
    } catch (e) {
      _errorMessage = 'Error al cargar las ventas: $e';
    } finally {
      _isLoading = false;
      notifyListeners(); // Renderiza la información en la pantalla
    }
  }

  // Método para aplicar filtros avanzados de ventas (fechas, estado, método de pago, etc.)
  Future<void> filtrarVentas({
    String? fechaInicio,
    String? fechaFin,
    String? monto,
    String? metodoPago,
    String? estado,
  }) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _ventas = await _ventasService.filtrar(
        fechaInicio: fechaInicio,
        fechaFin: fechaFin,
        monto: monto,
        metodoPago: metodoPago,
        estado: estado,
      );
    } catch (e) {
      _errorMessage = 'Error al filtrar ventas: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Método para registrar una nueva venta y refrescar la lista
  Future<bool> registrarVenta(RegistrarVentaRequest request) async {
    try {
      await _ventasService.registrar(request);
      await loadVentas(); // Recargamos las ventas para mostrar la nueva
      return true;
    } catch (e) {
      _errorMessage = 'Error al registrar venta: $e';
      notifyListeners();
      return false;
    }
  }

  // Método para cobrar una venta por su ID
  Future<void> cobrarVenta(int id) async {
    try {
      await _ventasService.cobrar(id);
      await loadVentas(); // Actualiza la lista
    } catch (e) {
      _errorMessage = 'Error al cobrar la venta: $e';
      notifyListeners();
    }
  }
}
