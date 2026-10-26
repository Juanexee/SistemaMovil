// =========================================================
// pedidos_provider.dart
// Gestiona el estado de las comandas y pedidos usando VentasService
// =========================================================
import 'package:flutter/material.dart';
import '../../services/ventas_service.dart';
import '../../data/models/ventas_model.dart';

class PedidosProvider extends ChangeNotifier {
  final VentasService _ventasService;

  PedidosProvider(this._ventasService);

  bool _isLoading = false;
  dynamic _pedidos = [];
  String _errorMessage = '';

  // Getters para que la interfaz (UI) lea los datos
  bool get isLoading => _isLoading;
  dynamic get pedidos => _pedidos;
  String get errorMessage => _errorMessage;

  // Método para cargar los pedidos pendientes para la cocina
  Future<void> loadPedidos() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Usa el método que ya tienes programado en tu VentasService
      _pedidos = await _ventasService.getPedidos();
    } catch (e) {
      _errorMessage = 'Error al cargar los pedidos: $e';
    } finally {
      _isLoading = false;
      notifyListeners(); // Refresca la pantalla automáticamente
    }
  }

  // Método para actualizar el estado de un grupo de pedidos (Ej: Pendiente -> En Preparación)
  Future<bool> actualizarEstadoPedidos(
    List<int> pedidoIds,
    String nuevoEstado,
  ) async {
    try {
      final request = ActualizarEstadoGrupoRequest(
        pedidoIds: pedidoIds,
        nuevoEstado: nuevoEstado,
      );

      // Usa el método existente en tu VentasService
      await _ventasService.actualizarEstadoGrupo(request);
      await loadPedidos(); // Recarga la lista de pedidos al terminar
      return true;
    } catch (e) {
      _errorMessage = 'Error al actualizar estado del pedido: $e';
      notifyListeners();
      return false;
    }
  }

  // Limpia los datos almacenados al cerrar sesión o cambiar de usuario
  void clear() {
    _pedidos = [];
    _errorMessage = '';
    _isLoading = false;
    notifyListeners();
  }
}

