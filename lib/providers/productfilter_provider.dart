import 'package:flutter/material.dart';

class ProductFilterProvider extends ChangeNotifier {
  String? _category;

  String? get category => _category;

  void setCategory(String? newCategory) {
    _category = newCategory;
    notifyListeners();
  }
}
