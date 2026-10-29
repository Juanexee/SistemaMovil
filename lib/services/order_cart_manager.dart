import 'package:flutter/foundation.dart';

class OrderCartManager extends ChangeNotifier {
  static final OrderCartManager _instance = OrderCartManager._internal();
  factory OrderCartManager() => _instance;
  OrderCartManager._internal();

  // Carrito separado por ID de mesa para no mezclar comandas entre mesas
  final Map<int, List<Map<String, dynamic>>> _cartsByMesa = {};
  Map<String, dynamic>? _activeMesa;

  Map<String, dynamic>? get activeMesa => _activeMesa;

  int get currentMesaId {
    final id = _activeMesa?['id'];
    if (id is int) return id;
    if (id != null) return int.tryParse(id.toString()) ?? 1;
    return 1;
  }

  void setActiveMesa(Map<String, dynamic>? mesa, {bool notify = true}) {
    _activeMesa = mesa;
    if (notify) notifyListeners();
  }

  List<Map<String, dynamic>> _listForMesa([int? mesaId]) {
    final id = mesaId ?? currentMesaId;
    return _cartsByMesa.putIfAbsent(id, () => []);
  }

  List<Map<String, dynamic>> get items => _listForMesa();

  List<Map<String, dynamic>> itemsForMesa(int mesaId) => _listForMesa(mesaId);

  int get totalCount =>
      items.fold(0, (sum, i) => sum + (i['quantity'] as int));

  void addItem({
    int? id,
    required String title,
    required double price,
    String note = '',
    int? mesaId,
  }) {
    final list = _listForMesa(mesaId);
    final existingIndex = list.indexWhere((i) =>
        (id != null && i['id'] == id) || i['title'] == title);
    if (existingIndex != -1) {
      list[existingIndex]['quantity'] =
          (list[existingIndex]['quantity'] as int) + 1;
    } else {
      list.add({
        'id': id,
        'title': title,
        'note': note.isNotEmpty ? note : 'Estándar',
        'pricePerUnit': price,
        'quantity': 1,
      });
    }
    notifyListeners();
  }

  void removeItem(int index, {int? mesaId}) {
    final list = _listForMesa(mesaId);
    if (index >= 0 && index < list.length) {
      list.removeAt(index);
      notifyListeners();
    }
  }

  void updateQuantity(int index, int delta, {int? mesaId}) {
    final list = _listForMesa(mesaId);
    if (index >= 0 && index < list.length) {
      final q = (list[index]['quantity'] as int) + delta;
      if (q > 0) {
        list[index]['quantity'] = q;
      } else {
        list.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clear({int? mesaId}) {
    _listForMesa(mesaId).clear();
    notifyListeners();
  }

  void clearAll() {
    _cartsByMesa.clear();
    _activeMesa = null;
    notifyListeners();
  }

  double get subtotal => items.fold(
      0.0,
      (sum, i) =>
          sum + ((i['pricePerUnit'] as double) * (i['quantity'] as int)));
}
