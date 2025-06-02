import 'dart:async';

import 'package:assignment1/models/product.dart';
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final List<Product> _items = [];
  final _countController = StreamController<int>.broadcast();

  List<Product> get items => List.unmodifiable(_items);
  double get totalPrice =>
      _items.fold(0, (sum, p) => sum + (p.price * p.quantity));
  Stream<int> get itemCountStream => _countController.stream;

  void add(Product p) {
    int index = _items.indexWhere((item) => item.id == p.id);
    if (index != -1) {
      _items[index].quantity++;
    } else {
      _items.add(p.copyWith(quantity: 1));
    }
    _updateItemCount();
    notifyListeners();
  }

  void remove(Product p) {
    int index = _items.indexWhere((item) => item.id == p.id);
    if (index != -1) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      _updateItemCount();
      notifyListeners();
    }
  }

  void removeItem(Product p) {
    _items.removeWhere((item) => item.id == p.id);
    _updateItemCount();
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _countController.add(0);
    notifyListeners();
  }

  void _updateItemCount() {
    final totalQuantity = _items.fold(0, (sum, item) => sum + item.quantity);
    _countController.add(totalQuantity);
  }

  @override
  void dispose() {
    _countController.close();
    super.dispose();
  }
}
