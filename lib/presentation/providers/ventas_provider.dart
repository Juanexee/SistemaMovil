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
  final List<VentaModel> _localVentas = [];
  bool _isLoading = false;
  String _errorMessage = '';

  // Getters para que la UI lea los datos de forma segura
  List<VentaModel> get ventas => _ventas;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  List<VentaModel> _mergeWithLocal(List<VentaModel> remote) {
    if (_localVentas.isEmpty) return remote;
    final remoteIds = remote.map((v) => v.id).toSet();
    final extras = _localVentas.where((v) => !remoteIds.contains(v.id)).toList();
    return [...extras, ...remote];
  }

  // Método para cargar todas las ventas usando el service
  Future<void> loadVentas() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners(); // Avisa a la pantalla que estamos cargando

    try {
      final remotas = await _ventasService.getVentas();
      _ventas = _mergeWithLocal(remotas);
      _errorMessage = '';
    } catch (e) {
      final errStr = e.toString();
      if (_localVentas.isNotEmpty && _ventas.isEmpty) {
        _ventas = List<VentaModel>.from(_localVentas);
      }
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
        if (_ventas.isEmpty) {
          _errorMessage =
              'Error al cargar las ventas: ${errStr.replaceFirst('Exception: ', '')}';
        }
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
      final remotas = await _ventasService.filtrar(
        fechaInicio: fechaInicio,
        fechaFin: fechaFin,
        monto: monto,
        metodoPago: metodoPago,
        estado: estado,
      );
      _ventas = _mergeWithLocal(remotas);
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
    final subtotal = request.detalles.fold<double>(
      0.0,
      (sum, d) => sum + d.subtotal,
    );
    final totalConIva = subtotal * 1.15;
    final nuevaLocal = VentaModel(
      id: DateTime.now().millisecondsSinceEpoch % 100000,
      mesaId: request.mesaId,
      total: totalConIva,
      estado: 'Activa',
      metodoPago: 'Efectivo',
      fecha: DateTime.now().toIso8601String(),
    );

    try {
      await _ventasService.registrar(request);
      await loadVentas(); // Recargamos las ventas para mostrar la nueva
      return true;
    } catch (e) {
      // Guardamos localmente (modo offline-first) para que aparezca en el historial
      _localVentas.insert(0, nuevaLocal);
      _ventas = _mergeWithLocal(_ventas);
      _errorMessage = '';
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
    _localVentas.clear();
    _errorMessage = '';
    _isLoading = false;
    notifyListeners();
  }
}
