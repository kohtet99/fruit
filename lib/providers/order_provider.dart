import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:assignment1/models/order.dart';

class OrdersProvider with ChangeNotifier {
  late final Box<Order> _ordersBox;
  bool _isInitialized = false;

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      _ordersBox = await Hive.openBox<Order>('orders');
      _isInitialized = true;
    }
  }

  Future<List<Order>> getOrders() async {
    await _ensureInitialized();
    return _ordersBox.values.toList().reversed.toList();
  }

  Future<void> addOrder(Order order) async {
    await _ensureInitialized();
    await _ordersBox.put(order.id, order);
    notifyListeners();
  }
}