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
      _errorMessage = '';
    } catch (e) {
      final errStr = e.toString();
      if (errStr.contains('403')) {
        // En caso de que el backend en Azure restrinja el listado de ventas exclusivamente a Administrador
        if (_ventas.isNotEmpty) {
          // Si ya hay datos en memoria, no mostramos un mensaje de error que opaque la vista
          _errorMessage = '';
        } else {
          _errorMessage =
              'Acceso restringido: El rol Gerente tiene permisos limitados en el servidor para consultar el registro detallado de facturas.';
        }
      } else {
        _errorMessage =
            'Error al cargar las ventas: ${errStr.replaceFirst('Exception: ', '')}';
      }
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
      _errorMessage = '';
    } catch (e) {
      final errStr = e.toString();
      if (errStr.contains('403')) {
        if (_ventas.isNotEmpty) {
          _errorMessage = '';
        } else {
          _errorMessage =
              'Acceso restringido: El rol actual no tiene permisos en el servidor para filtrar facturas.';
        }
      } else {
        _errorMessage =
            'Error al filtrar ventas: ${errStr.replaceFirst('Exception: ', '')}';
      }
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
      final errStr = e.toString();
      if (errStr.contains('403')) {
        _errorMessage =
            'No tiene permisos para registrar ventas con el rol actual.';
      } else {
        _errorMessage =
            'Error al registrar venta: ${errStr.replaceFirst('Exception: ', '')}';
      }
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
      final errStr = e.toString();
      if (errStr.contains('403')) {
        _errorMessage =
            'No tiene permisos para cobrar ventas con el rol actual.';
      } else {
        _errorMessage =
            'Error al cobrar la venta: ${errStr.replaceFirst('Exception: ', '')}';
      }
      notifyListeners();
    }
  }

  // Limpia los datos almacenados al cerrar sesión o cambiar de usuario
  void clear() {
    _ventas = [];
    _errorMessage = '';
    _isLoading = false;
    notifyListeners();
  }
}
