import 'package:flutter/foundation.dart';

class OrderCartManager extends ChangeNotifier {
  static final OrderCartManager _instance = OrderCartManager._internal();
  factory OrderCartManager() => _instance;
  OrderCartManager._internal();

  final List<Map<String, dynamic>> _items = [
    {
      'id': 1,
      'title': 'Carne Asada Especial',
      'note': 'Sin cebolla, término medio',
      'pricePerUnit': 240.0,
      'quantity': 1,
    },
    {
      'id': 2,
      'title': 'Vigorón Tradicional',
      'note': 'Con ensalada fresca',
      'pricePerUnit': 180.0,
      'quantity': 1,
    },
    {
      'id': 3,
      'title': 'Pollo a la Plancha',
      'note': 'Con vegetales',
      'pricePerUnit': 195.0,
      'quantity': 1,
    },
  ];

  List<Map<String, dynamic>> get items => _items;

  int get totalCount => _items.fold(0, (sum, i) => sum + (i['quantity'] as int));

  void addItem({
    int? id,
    required String title,
    required double price,
    String note = '',
  }) {
    final existingIndex = _items.indexWhere((i) => i['title'] == title);
    if (existingIndex != -1) {
      _items[existingIndex]['quantity'] = (_items[existingIndex]['quantity'] as int) + 1;
    } else {
      _items.add({
        'id': id,
        'title': title,
        'note': note.isNotEmpty ? note : 'Estándar',
        'pricePerUnit': price,
        'quantity': 1,
      });
    }
    notifyListeners();
  }

  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners();
    }
  }

  void updateQuantity(int index, int delta) {
    if (index >= 0 && index < _items.length) {
      final q = (_items[index]['quantity'] as int) + delta;
      if (q > 0) {
        _items[index]['quantity'] = q;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  double get subtotal => _items.fold(
      0.0, (sum, i) => sum + ((i['pricePerUnit'] as double) * (i['quantity'] as int)));
}
