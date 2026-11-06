import 'package:flutter/foundation.dart';

class OrderCartManager extends ChangeNotifier {
  static final OrderCartManager _instance = OrderCartManager._internal();
  factory OrderCartManager() => _instance;
  OrderCartManager._internal();

  // Carrito separado por ID de mesa para no mezclar comandas entre mesas
  final Map<int, List<Map<String, dynamic>>> _cartsByMesa = {};
  Map<String, dynamic>? _activeMesa;

  // Lista global de mesas disponibles para el selector en el catálogo
  final List<Map<String, dynamic>> _availableTables = [
    {
      'id': 1,
      'numero': 1,
      'name': 'Mesa 01',
      'status': 'Libre',
      'capacidad': 4,
      'detail': 'Capacidad: 4 personas',
      'waiterInitials': 'MR',
      'waiterName': 'Mesero',
      'type': 'Libre',
    },
    {
      'id': 2,
      'numero': 2,
      'name': 'Mesa 02',
      'status': 'Libre',
      'capacidad': 4,
      'detail': 'Capacidad: 4 personas',
      'waiterInitials': 'MR',
      'waiterName': 'Mesero',
      'type': 'Libre',
    },
    {
      'id': 3,
      'numero': 3,
      'name': 'Mesa 03',
      'status': 'Libre',
      'capacidad': 2,
      'detail': 'Capacidad: 2 personas',
      'waiterInitials': 'MR',
      'waiterName': 'Mesero',
      'type': 'Libre',
    },
    {
      'id': 4,
      'numero': 4,
      'name': 'Mesa 04',
      'status': 'Libre',
      'capacidad': 6,
      'detail': 'Capacidad: 6 personas',
      'waiterInitials': 'MR',
      'waiterName': 'Mesero',
      'type': 'Libre',
    },
    {
      'id': 5,
      'numero': 5,
      'name': 'Mesa 05',
      'status': 'Libre',
      'capacidad': 4,
      'detail': 'Capacidad: 4 personas',
      'waiterInitials': 'MR',
      'waiterName': 'Mesero',
      'type': 'Libre',
    },
    {
      'id': 6,
      'numero': 6,
      'name': 'Mesa VIP 06',
      'status': 'Libre',
      'capacidad': 8,
      'detail': 'Capacidad: 8 personas',
      'waiterInitials': 'MR',
      'waiterName': 'Mesero',
      'type': 'Libre',
    },
  ];

  List<Map<String, dynamic>> get availableTables => _availableTables;

  void setAvailableTables(List<Map<String, dynamic>> tables,
      {bool notify = false}) {
    if (tables.isEmpty) return;
    _availableTables
      ..clear()
      ..addAll(tables);
    if (_activeMesa != null) {
      final activeId = resolveMesaKey(_activeMesa);
      final match = _availableTables.where((t) => resolveMesaKey(t) == activeId);
      if (match.isNotEmpty) {
        _activeMesa = match.first;
      }
    } else {
      _activeMesa = _availableTables.first;
    }
    if (notify) notifyListeners();
  }

  Map<String, dynamic>? get activeMesa =>
      _activeMesa ?? (_availableTables.isNotEmpty ? _availableTables.first : null);

  static int resolveMesaKey(Map<String, dynamic>? mesa, [int? fallbackId]) {
    if (mesa != null) {
      final rawId = mesa['id'];
      final parsedId = rawId is int
          ? rawId
          : (rawId != null ? int.tryParse(rawId.toString()) ?? 0 : 0);
      if (parsedId > 0) return parsedId;

      final rawNum = mesa['numero'];
      final parsedNum = rawNum is int
          ? rawNum
          : (rawNum != null ? int.tryParse(rawNum.toString()) ?? 0 : 0);
      if (parsedNum > 0) return parsedNum;
    }
    if (fallbackId != null && fallbackId > 0) return fallbackId;
    return 1;
  }

  int get currentMesaId => resolveMesaKey(_activeMesa);

  void setActiveMesa(Map<String, dynamic>? mesa, {bool notify = true}) {
    _activeMesa = mesa;
    if (notify) notifyListeners();
  }

  List<Map<String, dynamic>> _listForMesa([int? mesaId]) {
    final id = (mesaId != null && mesaId > 0) ? mesaId : currentMesaId;
    return _cartsByMesa.putIfAbsent(id, () => []);
  }

  List<Map<String, dynamic>> get items => _listForMesa();

  List<Map<String, dynamic>> itemsForMesa(int mesaId) => _listForMesa(mesaId);

  int countForMesa(int mesaId) =>
      _listForMesa(mesaId).fold(0, (sum, i) => sum + (i['quantity'] as int));

  double subtotalForMesa(int mesaId) => _listForMesa(mesaId).fold(
        0.0,
        (sum, i) =>
            sum + ((i['pricePerUnit'] as num).toDouble() * (i['quantity'] as int)),
      );

  int get totalCount =>
      items.fold(0, (sum, i) => sum + (i['quantity'] as int));

  void addItem({
    int? id,
    required String title,
    required double price,
    int quantity = 1,
    String note = '',
    int? mesaId,
    Map<String, dynamic>? mesa,
  }) {
    if (mesa != null) {
      _activeMesa = mesa;
    }
    final targetMesaId =
        mesa != null ? resolveMesaKey(mesa, mesaId) : (mesaId ?? currentMesaId);
    final list = _listForMesa(targetMesaId);

    final cleanNote = note.trim().isNotEmpty ? note.trim() : 'Estándar';
    final existingIndex = list.indexWhere((i) =>
        ((id != null && i['id'] == id) || i['title'] == title) &&
        (i['note'] ?? 'Estándar') == cleanNote);

    if (existingIndex != -1) {
      list[existingIndex]['quantity'] =
          (list[existingIndex]['quantity'] as int) + quantity;
      list[existingIndex]['sent'] = false;
    } else {
      list.add({
        'id': id,
        'title': title,
        'note': cleanNote,
        'pricePerUnit': price,
        'quantity': quantity,
        'sent': false,
      });
    }

    // Actualizamos el estado visual de la mesa en la lista compartida
    for (final t in _availableTables) {
      if (resolveMesaKey(t) == targetMesaId) {
        if (t['status'] == 'Libre') {
          t['status'] = 'Ocupada';
          t['type'] = 'Ocupada';
        }
        final totalItems = countForMesa(targetMesaId);
        final sub = subtotalForMesa(targetMesaId);
        t['detail'] =
            '$totalItems platillo${totalItems == 1 ? '' : 's'} • C\$ ${sub.toStringAsFixed(2)}';
        break;
      }
    }

    notifyListeners();
  }

  // Marca los platillos de la mesa como enviados a cocina sin borrarlos de la mesa
  void markAsSent({int? mesaId}) {
    final targetId = (mesaId != null && mesaId > 0) ? mesaId : currentMesaId;
    final list = _listForMesa(targetId);
    for (final item in list) {
      item['sent'] = true;
    }
    for (final t in _availableTables) {
      if (resolveMesaKey(t) == targetId) {
        t['status'] = 'Ocupada';
        t['type'] = 'Ocupada';
        final totalItems = countForMesa(targetId);
        final sub = subtotalForMesa(targetId);
        t['detail'] =
            '$totalItems platillo${totalItems == 1 ? '' : 's'} en cocina • C\$ ${sub.toStringAsFixed(2)}';
        break;
      }
    }
    notifyListeners();
  }

  void removeItem(int index, {int? mesaId}) {
    final targetId = (mesaId != null && mesaId > 0) ? mesaId : currentMesaId;
    final list = _listForMesa(targetId);
    if (index >= 0 && index < list.length) {
      list.removeAt(index);
      notifyListeners();
    }
  }

  void updateQuantity(int index, int delta, {int? mesaId}) {
    final targetId = (mesaId != null && mesaId > 0) ? mesaId : currentMesaId;
    final list = _listForMesa(targetId);
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
    final targetId = (mesaId != null && mesaId > 0) ? mesaId : currentMesaId;
    _listForMesa(targetId).clear();
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
          sum + ((i['pricePerUnit'] as num).toDouble() * (i['quantity'] as int)));
}
